using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Doctor
{
    public partial class UpdateAppointment : System.Web.UI.Page
    {
        private string ConnString => ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private string CurrentDoctorId
        {
            get => ViewState["CurrentDoctorId"]?.ToString();
            set => ViewState["CurrentDoctorId"] = value;
        }

        private string SelectedAppointmentId
        {
            get => ViewState["SelectedAppointmentId"]?.ToString();
            set => ViewState["SelectedAppointmentId"] = value;
        }

        private string PreviousStatus
        {
            get => ViewState["PreviousStatus"]?.ToString();
            set => ViewState["PreviousStatus"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string dashUrl = File.Exists(Server.MapPath("~/Private/Doctor/DoctorDashboard.aspx"))
                ? "~/Private/Doctor/DoctorDashboard.aspx"
                : "~/Private/Doctor/DoctorsDashboard.aspx";
            lnkBackToDashTop.NavigateUrl = dashUrl;
            lnkBackToDashPopup.NavigateUrl = dashUrl;

            if (!IsPostBack)
            {
                AutoCancelExpiredAppointments();
                LoadLoggedInClinician();

                string preselectId = Request.QueryString["AppointmentID"];
                BindAppointmentsGrid(filterByDate: false, preselectAppointmentId: preselectId);
            }
        }

        /// <summary>
        /// Automatically cancels any past-day appointment whose status was never finalized
        /// (i.e. not Completed, Cancelled, or No Show).
        /// </summary>
        private void AutoCancelExpiredAppointments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();
                    string apptTable = ResolveExistingTable(conn, "Pro_Appointment", "Appointments", "Appointment");
                    if (apptTable == null) return;

                    HashSet<string> aCols = GetTableColumns(conn, apptTable);
                    string dateCol = FindColumn(aCols, "AppointmentDate", "Date", "ConsultationDate", "VisitDate", "ScheduledDate");
                    string statusCol = FindColumn(aCols, "Status", "AppointmentStatus");

                    if (dateCol != null && statusCol != null)
                    {
                        string sql = $@"
                            UPDATE [dbo].[{apptTable}]
                            SET [{statusCol}] = 'Cancelled'
                            WHERE CAST([{dateCol}] AS DATE) < CAST(GETDATE() AS DATE)
                              AND (
                                    [{statusCol}] IS NULL
                                    OR LTRIM(RTRIM([{statusCol}])) = ''
                                    OR LOWER(LTRIM(RTRIM([{statusCol}]))) NOT IN ('completed', 'cancelled', 'no show', 'noshow')
                                  )";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch
            {
                // Non-blocking safeguard
            }
        }

        protected void gvAppointments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            pnlError.Visible = false;
            gvAppointments.PageIndex = e.NewPageIndex;
            bool isDateFiltered = !string.IsNullOrWhiteSpace(txtFilterDate.Text);
            BindAppointmentsGrid(filterByDate: isDateFiltered, preselectAppointmentId: null);
        }

        protected void btnFilterByDate_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            gvAppointments.PageIndex = 0;
            ClearSelectedAppointment();
            BindAppointmentsGrid(filterByDate: true, preselectAppointmentId: null);
        }

        protected void btnShowAllAppointments_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            txtFilterDate.Text = "";
            gvAppointments.PageIndex = 0;
            ClearSelectedAppointment();
            BindAppointmentsGrid(filterByDate: false, preselectAppointmentId: null);
        }

        protected void gvAppointments_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            if (gvAppointments.SelectedDataKey != null)
            {
                string apptId = gvAppointments.SelectedDataKey.Value?.ToString();
                LoadSingleAppointmentForEdit(apptId);
                ScrollToEditSection();
            }
        }

        protected void btnClearSelection_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            ClearSelectedAppointment();
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            pnlStatusPopup.Visible = false;
        }

        private void ClearSelectedAppointment()
        {
            SelectedAppointmentId = null;
            PreviousStatus = null;
            gvAppointments.SelectedIndex = -1;
            pnlEditForm.Visible = false;
            pnlSelectPrompt.Visible = true;
        }

        private void ScrollToEditSection()
        {
            string script = @"
                setTimeout(function() {
                    var el = document.getElementById('appointment-edit-section');
                    if (el) {
                        el.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }, 100);";
            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToEditSection", script, true);
        }

        private void LoadLoggedInClinician()
        {
            string email = User.Identity.GetUserName();
            string userId = User.Identity.GetUserId();
            string displayName = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();
                    string docTable = ResolveExistingTable(conn, "Doctor", "Doctors");

                    if (docTable != null)
                    {
                        HashSet<string> cols = GetTableColumns(conn, docTable);
                        List<string> where = new List<string>();
                        if (cols.Contains("Email")) where.Add("Email = @Email");
                        if (cols.Contains("UserId")) where.Add("UserId = @UserId");
                        if (cols.Contains("AspNetUserId")) where.Add("AspNetUserId = @UserId");

                        if (where.Count > 0)
                        {
                            string sql = $"SELECT TOP 1 * FROM [dbo].[{docTable}] WHERE {string.Join(" OR ", where)}";
                            using (SqlCommand cmd = new SqlCommand(sql, conn))
                            {
                                cmd.Parameters.AddWithValue("@Email", (object)email ?? DBNull.Value);
                                cmd.Parameters.AddWithValue("@UserId", (object)userId ?? DBNull.Value);

                                using (SqlDataReader r = cmd.ExecuteReader())
                                {
                                    if (r.Read())
                                    {
                                        string idCol = FindColumn(cols, "DoctorID", "Doctor_ID", "Id");
                                        if (idCol != null && r[idCol] != DBNull.Value)
                                        {
                                            CurrentDoctorId = r[idCol].ToString();
                                            Session["DoctorID"] = CurrentDoctorId;
                                        }

                                        string full = ReadFirstAvailable(r, cols, "FullName", "DoctorName", "Name");
                                        if (!string.IsNullOrWhiteSpace(full))
                                        {
                                            displayName = full;
                                        }
                                        else
                                        {
                                            string first = ReadFirstAvailable(r, cols, "FirstName", "DoctorFirstName", "FName");
                                            string last = ReadFirstAvailable(r, cols, "LastName", "Surname", "DoctorLastName", "LName");
                                            displayName = $"{first} {last}".Trim();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                // Fallback handled below
            }

            if (string.IsNullOrWhiteSpace(displayName))
                displayName = FormatDoctorNameFromEmail(email);
            else if (!displayName.StartsWith("Dr", StringComparison.OrdinalIgnoreCase))
                displayName = "Dr. " + displayName;

            litDoctorName.Text = Server.HtmlEncode(displayName);
        }

        private void BindAppointmentsGrid(bool filterByDate, string preselectAppointmentId)
        {
            DataTable dtAppts = new DataTable();
            dtAppts.Columns.Add("AppointmentID");
            dtAppts.Columns.Add("AppointmentDate");
            dtAppts.Columns.Add("TimeSlot");
            dtAppts.Columns.Add("PatientName");
            dtAppts.Columns.Add("PatientIdentifier");
            dtAppts.Columns.Add("Reason");
            dtAppts.Columns.Add("AssignedNurse");
            dtAppts.Columns.Add("Status");

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();
                    string apptTable = ResolveExistingTable(conn, "Pro_Appointment", "Appointments", "Appointment");
                    string patTable = ResolveExistingTable(conn, "Patient", "Patients");
                    string nurseTable = ResolveExistingTable(conn, "Nurse", "Nurses", "Staff");

                    if (apptTable != null)
                    {
                        HashSet<string> aCols = GetTableColumns(conn, apptTable);
                        string pkCol = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                        string dateCol = FindColumn(aCols, "AppointmentDate", "Date", "ConsultationDate", "VisitDate", "ScheduledDate");
                        string timeCol = ResolveTimeColumn(aCols);
                        string statusCol = FindColumn(aCols, "Status", "AppointmentStatus");
                        string reasonCol = ResolveReasonColumn(aCols);
                        string docFkCol = FindColumn(aCols, "DoctorID", "Doctor_ID");
                        string patFkCol = FindColumn(aCols, "PatientID", "Patient_ID");
                        string nurseFkCol = FindColumn(aCols, "NurseID", "Nurse_ID", "AssignedNurseID", "Assigned_Nurse_ID", "StaffID", "Staff_ID");
                        string directNurseCol = FindColumn(aCols, "NurseName", "AssignedNurse", "Assigned_Nurse", "Nurse");

                        List<string> conditions = new List<string>();
                        if (docFkCol != null && !string.IsNullOrWhiteSpace(CurrentDoctorId))
                        {
                            conditions.Add($"a.[{docFkCol}] = @DoctorID");
                        }

                        DateTime parsedFilterDate = DateTime.Today;
                        bool hasValidFilterDate = filterByDate && dateCol != null && DateTime.TryParse(txtFilterDate.Text, out parsedFilterDate);
                        if (hasValidFilterDate)
                        {
                            conditions.Add($"CAST(a.[{dateCol}] AS DATE) = @FilterDate");
                        }

                        List<string> joinClauses = new List<string>();
                        string patSelectSql = "'' AS PFirst, '' AS PLast, '' AS PFull, '' AS PIdNum";
                        string nurseSelectSql = (directNurseCol != null ? $"a.[{directNurseCol}] AS DirectNurse, " : "'' AS DirectNurse, ") +
                                                "'' AS NFirst, '' AS NLast, '' AS NFull";

                        if (patTable != null && patFkCol != null)
                        {
                            HashSet<string> pCols = GetTableColumns(conn, patTable);
                            string pPkCol = FindColumn(pCols, "PatientID", "Patient_ID", "Id");
                            if (pPkCol != null)
                            {
                                joinClauses.Add($"LEFT JOIN [dbo].[{patTable}] p ON a.[{patFkCol}] = p.[{pPkCol}]");
                                string pFirst = FindColumn(pCols, "FirstName", "PatientFirstName", "FName");
                                string pLast = FindColumn(pCols, "LastName", "Surname", "PatientLastName", "LName");
                                string pFull = FindColumn(pCols, "FullName", "PatientName", "Name");
                                string pIdNo = FindColumn(pCols, "IDNumber", "SAID", "IdentityNumber", "FileNumber");

                                patSelectSql =
                                    (pFirst != null ? $"p.[{pFirst}] AS PFirst, " : "'' AS PFirst, ") +
                                    (pLast != null ? $"p.[{pLast}] AS PLast, " : "'' AS PLast, ") +
                                    (pFull != null ? $"p.[{pFull}] AS PFull, " : "'' AS PFull, ") +
                                    (pIdNo != null ? $"p.[{pIdNo}] AS PIdNum" : "'' AS PIdNum");
                            }
                        }

                        if (nurseFkCol != null)
                        {
                            string targetNurseTable = nurseTable ?? ResolveExistingTable(conn, "AspNetUsers");
                            if (targetNurseTable != null)
                            {
                                HashSet<string> nCols = GetTableColumns(conn, targetNurseTable);
                                string nPkCol = FindColumn(nCols, "NurseID", "Nurse_ID", "StaffID", "Staff_ID", "Id");
                                if (nPkCol != null)
                                {
                                    joinClauses.Add($"LEFT JOIN [dbo].[{targetNurseTable}] n ON a.[{nurseFkCol}] = n.[{nPkCol}]");
                                    string nFirst = FindColumn(nCols, "FirstName", "NurseFirstName", "FName");
                                    string nLast = FindColumn(nCols, "LastName", "Surname", "NurseLastName", "LName");
                                    string nFull = FindColumn(nCols, "FullName", "NurseName", "Name", "UserName");

                                    nurseSelectSql =
                                        (directNurseCol != null ? $"a.[{directNurseCol}] AS DirectNurse, " : "'' AS DirectNurse, ") +
                                        (nFirst != null ? $"n.[{nFirst}] AS NFirst, " : "'' AS NFirst, ") +
                                        (nLast != null ? $"n.[{nLast}] AS NLast, " : "'' AS NLast, ") +
                                        (nFull != null ? $"n.[{nFull}] AS NFull" : "'' AS NFull");
                                }
                            }
                        }

                        string whereSql = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";
                        string orderBy = dateCol != null
                            ? $"ORDER BY a.[{dateCol}] DESC" + (timeCol != null ? $", a.[{timeCol}] ASC" : "")
                            : (pkCol != null ? $"ORDER BY a.[{pkCol}] DESC" : "");

                        string sql = $@"
                            SELECT a.*, {patSelectSql}, {nurseSelectSql}
                            FROM [dbo].[{apptTable}] a
                            {string.Join(" ", joinClauses)}
                            {whereSql}
                            {orderBy}";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            if (!string.IsNullOrWhiteSpace(CurrentDoctorId))
                                cmd.Parameters.AddWithValue("@DoctorID", CurrentDoctorId);
                            if (hasValidFilterDate)
                                cmd.Parameters.AddWithValue("@FilterDate", parsedFilterDate.Date);

                            using (SqlDataReader r = cmd.ExecuteReader())
                            {
                                while (r.Read())
                                {
                                    string apptId = (pkCol != null && r[pkCol] != DBNull.Value) ? r[pkCol].ToString() : "0";
                                    string dateStr = (dateCol != null && r[dateCol] != DBNull.Value && DateTime.TryParse(r[dateCol].ToString(), out DateTime dVal))
                                        ? dVal.ToString("yyyy/MM/dd")
                                        : "—";

                                    string timeStr = FormatAppointmentTime(
                                        timeCol != null ? r[timeCol] : null,
                                        dateCol != null ? r[dateCol] : null);

                                    string patId = (patFkCol != null && r[patFkCol] != DBNull.Value) ? r[patFkCol].ToString() : "0";
                                    string pName = r["PFull"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["PFull"].ToString())
                                        ? r["PFull"].ToString().Trim()
                                        : $"{r["PFirst"]} {r["PLast"]}".Trim();
                                    if (string.IsNullOrWhiteSpace(pName))
                                        pName = "Patient #" + patId;

                                    string pIdent = r["PIdNum"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["PIdNum"].ToString())
                                        ? r["PIdNum"].ToString().Trim()
                                        : $"PAT-{patId}";

                                    string nurseName = ResolveNurseDisplay(r, nurseFkCol);

                                    string reason = (reasonCol != null && r[reasonCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[reasonCol].ToString()))
                                        ? r[reasonCol].ToString().Trim()
                                        : "Not specified";

                                    string status = (statusCol != null && r[statusCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[statusCol].ToString()))
                                        ? r[statusCol].ToString().Trim()
                                        : "Scheduled";

                                    dtAppts.Rows.Add(apptId, dateStr, timeStr, pName, pIdent, reason, nurseName, status);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Error loading appointments: " + Server.HtmlEncode(ex.Message);
            }

            litTotalCountInfo.Text = $"{dtAppts.Rows.Count} total";

            // Jump to the page containing the preselected AppointmentID if arriving from Dashboard
            string targetId = !string.IsNullOrWhiteSpace(preselectAppointmentId) ? preselectAppointmentId : SelectedAppointmentId;
            if (!string.IsNullOrWhiteSpace(targetId) && dtAppts.Rows.Count > 0)
            {
                for (int idx = 0; idx < dtAppts.Rows.Count; idx++)
                {
                    if (dtAppts.Rows[idx]["AppointmentID"].ToString() == targetId)
                    {
                        gvAppointments.PageIndex = idx / gvAppointments.PageSize;
                        break;
                    }
                }
            }

            gvAppointments.DataSource = dtAppts;
            gvAppointments.DataBind();
            pnlNoAppointments.Visible = dtAppts.Rows.Count == 0;

            if (!string.IsNullOrWhiteSpace(targetId))
            {
                for (int i = 0; i < gvAppointments.DataKeys.Count; i++)
                {
                    if (gvAppointments.DataKeys[i].Value?.ToString() == targetId)
                    {
                        gvAppointments.SelectedIndex = i;
                        if (!string.IsNullOrWhiteSpace(preselectAppointmentId))
                        {
                            LoadSingleAppointmentForEdit(targetId);
                            ScrollToEditSection();
                        }
                        break;
                    }
                }
            }
        }

        private void LoadSingleAppointmentForEdit(string apptId)
        {
            if (string.IsNullOrWhiteSpace(apptId)) return;

            for (int i = 0; i < gvAppointments.DataKeys.Count; i++)
            {
                if (gvAppointments.DataKeys[i].Value?.ToString() == apptId)
                {
                    gvAppointments.SelectedIndex = i;
                    GridViewRow row = gvAppointments.Rows[i];

                    SelectedAppointmentId = apptId;
                    string dateStr = Server.HtmlDecode(row.Cells[1].Text).Trim();
                    string timeStr = Server.HtmlDecode(row.Cells[2].Text).Trim();
                    string patientName = Server.HtmlDecode(row.Cells[3].Text).Trim();
                    string patientIdNo = Server.HtmlDecode(row.Cells[4].Text).Trim();
                    string reason = Server.HtmlDecode(row.Cells[5].Text).Trim();
                    string nurse = Server.HtmlDecode(row.Cells[6].Text).Trim();

                    string currentStatus = "Scheduled";
                    using (SqlConnection conn = new SqlConnection(ConnString))
                    {
                        conn.Open();
                        string apptTable = ResolveExistingTable(conn, "Pro_Appointment", "Appointments", "Appointment");
                        if (apptTable != null)
                        {
                            HashSet<string> aCols = GetTableColumns(conn, apptTable);
                            string pkCol = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                            string statusCol = FindColumn(aCols, "Status", "AppointmentStatus");
                            if (pkCol != null && statusCol != null)
                            {
                                using (SqlCommand cmd = new SqlCommand(
                                    $"SELECT TOP 1 [{statusCol}] FROM [dbo].[{apptTable}] WHERE [{pkCol}] = @Id", conn))
                                {
                                    cmd.Parameters.AddWithValue("@Id", apptId);
                                    object val = cmd.ExecuteScalar();
                                    if (val != null && val != DBNull.Value && !string.IsNullOrWhiteSpace(val.ToString()))
                                        currentStatus = val.ToString().Trim();
                                }
                            }
                        }
                    }

                    PreviousStatus = currentStatus;
                    litSelPatientName.Text = Server.HtmlEncode(patientName);
                    litSelPatientIdNo.Text = Server.HtmlEncode(patientIdNo);
                    litSelDateTime.Text = Server.HtmlEncode($"{dateStr} ({timeStr})");
                    litSelNurse.Text = Server.HtmlEncode(nurse);
                    txtConsultationReason.Text = reason;

                    if (ddlAppointmentStatus.Items.FindByValue(currentStatus) != null)
                    {
                        ddlAppointmentStatus.SelectedValue = currentStatus;
                    }
                    else
                    {
                        ddlAppointmentStatus.Items.Add(new ListItem(currentStatus, currentStatus));
                        ddlAppointmentStatus.SelectedValue = currentStatus;
                    }

                    pnlSelectPrompt.Visible = false;
                    pnlEditForm.Visible = true;
                    break;
                }
            }
        }

        protected void btnSaveAppointment_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            if (string.IsNullOrWhiteSpace(SelectedAppointmentId))
            {
                pnlError.Visible = true;
                litError.Text = "Please select an appointment from the table first.";
                return;
            }

            string newStatus = ddlAppointmentStatus.SelectedValue;
            string oldStatus = string.IsNullOrWhiteSpace(PreviousStatus) ? "Scheduled" : PreviousStatus;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();
                    string apptTable = ResolveExistingTable(conn, "Pro_Appointment", "Appointments", "Appointment");
                    if (apptTable == null)
                        throw new Exception("Appointments table could not be located in the database.");

                    HashSet<string> aCols = GetTableColumns(conn, apptTable);
                    string pkCol = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                    string statusCol = FindColumn(aCols, "Status", "AppointmentStatus");

                    if (pkCol == null || statusCol == null)
                        throw new Exception("Required Status or AppointmentID column is missing in the appointments table.");

                    // Consultation Reason is read-only; only Status is persisted
                    string updateSql = $@"
                        UPDATE [dbo].[{apptTable}]
                        SET [{statusCol}] = @Status
                        WHERE [{pkCol}] = @AppointmentID";

                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@AppointmentID", SelectedAppointmentId);

                        int affected = cmd.ExecuteNonQuery();
                        if (affected == 0)
                            throw new Exception("No appointment record was updated. Please re-select the row and try again.");
                    }
                }

                bool isDateFiltered = !string.IsNullOrWhiteSpace(txtFilterDate.Text);
                BindAppointmentsGrid(filterByDate: isDateFiltered, preselectAppointmentId: null);

                litPopupPatient.Text = litSelPatientName.Text;
                litPopupDateTime.Text = litSelDateTime.Text;
                litPopupOldStatus.Text = Server.HtmlEncode(oldStatus);
                litPopupNewStatus.Text = Server.HtmlEncode(newStatus);
                PreviousStatus = newStatus;

                pnlStatusPopup.Visible = true;
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                litError.Text = "Unable to update appointment: " + Server.HtmlEncode(ex.Message);
            }
        }

        protected string GetStatusBadgeClass(string status)
        {
            if (string.IsNullOrWhiteSpace(status)) return "badge-pending";
            if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) return "badge-completed";
            if (status.IndexOf("Progress", StringComparison.OrdinalIgnoreCase) >= 0 ||
                status.IndexOf("Consultation", StringComparison.OrdinalIgnoreCase) >= 0) return "badge-progress";
            if (status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) ||
                status.Equals("No Show", StringComparison.OrdinalIgnoreCase)) return "badge-cancelled";
            return "badge-pending";
        }

        private string ResolveNurseDisplay(SqlDataReader r, string nurseFkCol)
        {
            string nurseName = "";
            if (r["DirectNurse"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["DirectNurse"].ToString()))
                nurseName = r["DirectNurse"].ToString().Trim();
            else if (r["NFull"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["NFull"].ToString()))
                nurseName = r["NFull"].ToString().Trim();
            else
                nurseName = $"{r["NFirst"]} {r["NLast"]}".Trim();

            if (string.IsNullOrWhiteSpace(nurseName))
            {
                if (nurseFkCol != null && r[nurseFkCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[nurseFkCol].ToString()))
                    return "Nurse #" + r[nurseFkCol].ToString();
                return "Unassigned";
            }
            return nurseName;
        }

        private string ResolveTimeColumn(HashSet<string> aCols)
        {
            string timeCol = FindColumn(aCols,
                "AppointmentTime", "Appointment_Time", "ApptTime", "AppTime",
                "TimeSlot", "Time_Slot", "SlotTime", "StartTime", "Start_Time",
                "ScheduledTime", "BookingTime", "ConsultationTime", "Time");

            if (timeCol == null)
            {
                timeCol = aCols.FirstOrDefault(c =>
                    (c.IndexOf("time", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("slot", StringComparison.OrdinalIgnoreCase) >= 0) &&
                    c.IndexOf("stamp", StringComparison.OrdinalIgnoreCase) < 0 &&
                    c.IndexOf("created", StringComparison.OrdinalIgnoreCase) < 0 &&
                    c.IndexOf("updated", StringComparison.OrdinalIgnoreCase) < 0);
            }
            return timeCol;
        }

        private string ResolveReasonColumn(HashSet<string> aCols)
        {
            string reasonCol = FindColumn(aCols,
                "Reason", "AppointmentReason", "Appointment_Reason",
                "ConsultationReason", "Consultation_Reason",
                "ReasonForVisit", "Reason_For_Visit", "VisitReason", "Visit_Reason",
                "Purpose", "ChiefComplaint", "Complaint", "Symptoms", "Symptom",
                "ServiceName", "Service", "AppointmentType", "VisitType",
                "Notes", "Note", "Comments", "Comment", "Description", "Details", "Remarks");

            if (reasonCol == null)
            {
                reasonCol = aCols.FirstOrDefault(c =>
                    !c.EndsWith("ID", StringComparison.OrdinalIgnoreCase) &&
                    (c.IndexOf("reason", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("purpose", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("symptom", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("complaint", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("note", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     c.IndexOf("desc", StringComparison.OrdinalIgnoreCase) >= 0));
            }
            return reasonCol;
        }

        private string FormatAppointmentTime(object rawTime, object rawDate)
        {
            if (rawTime != null && rawTime != DBNull.Value)
            {
                if (rawTime is TimeSpan ts)
                    return DateTime.Today.Add(ts).ToString("HH:mm");
                if (rawTime is DateTime dtTime)
                    return dtTime.ToString("HH:mm");

                string strVal = rawTime.ToString().Trim();
                if (TimeSpan.TryParse(strVal, out TimeSpan parsedTs))
                    return DateTime.Today.Add(parsedTs).ToString("HH:mm");
                if (DateTime.TryParse(strVal, out DateTime parsedDt))
                    return parsedDt.ToString("HH:mm");
                if (!string.IsNullOrWhiteSpace(strVal))
                    return strVal;
            }

            if (rawDate != null && rawDate != DBNull.Value &&
                rawDate is DateTime dtVal && dtVal.TimeOfDay != TimeSpan.Zero)
            {
                return dtVal.ToString("HH:mm");
            }

            return "--:--";
        }

        private string ResolveExistingTable(SqlConnection conn, params string[] candidates)
        {
            foreach (string table in candidates)
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName", conn))
                {
                    cmd.Parameters.AddWithValue("@TableName", table);
                    if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                        return table;
                }
            }
            return null;
        }

        private HashSet<string> GetTableColumns(SqlConnection conn, string tableName)
        {
            HashSet<string> cols = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            using (SqlCommand cmd = new SqlCommand(
                "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName", conn))
            {
                cmd.Parameters.AddWithValue("@TableName", tableName);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                        cols.Add(r.GetString(0));
                }
            }
            return cols;
        }

        private string FindColumn(HashSet<string> cols, params string[] candidates)
        {
            return candidates.FirstOrDefault(c => cols.Contains(c));
        }

        private string ReadFirstAvailable(SqlDataReader reader, HashSet<string> cols, params string[] candidates)
        {
            string match = FindColumn(cols, candidates);
            if (match != null && reader[match] != DBNull.Value)
                return reader[match].ToString().Trim();
            return string.Empty;
        }

        private string FormatDoctorNameFromEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email) || !email.Contains("@")) return "Doctor";
            string local = email.Split('@')[0];
            if (local.Length > 1)
            {
                string initial = char.ToUpper(local[0]).ToString();
                string surname = char.ToUpper(local[1]) + local.Substring(2).ToLower();
                return $"Dr. {initial}. {surname}";
            }
            return "Dr. " + local.ToUpper();
        }
    }
}