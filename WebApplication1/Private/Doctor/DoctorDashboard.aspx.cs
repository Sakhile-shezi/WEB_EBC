using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Doctor
{
    public partial class DoctorDashboard : System.Web.UI.Page
    {
        private string ConnString => ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private string CurrentDoctorId
        {
            get => ViewState["CurrentDoctorId"]?.ToString();
            set => ViewState["CurrentDoctorId"] = value;
        }

        private string SelectedPatientId
        {
            get => ViewState["SelectedPatientId"]?.ToString();
            set => ViewState["SelectedPatientId"] = value;
        }

        private string SelectedPatientName
        {
            get => ViewState["SelectedPatientName"]?.ToString();
            set => ViewState["SelectedPatientName"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            List<DateTime> workingDays = GetUpcomingWorkingDays(5);
            txtConsultationDate.Attributes["max"] = workingDays.Last().ToString("yyyy-MM-dd");

            if (!IsPostBack)
            {
                txtConsultationDate.Text = workingDays.First().ToString("yyyy-MM-dd");
                LoadLoggedInClinician();
                LoadDashboardData();
            }
        }

        protected void txtConsultationDate_TextChanged(object sender, EventArgs e)
        {
            SelectedPatientId = null;
            SelectedPatientName = null;
            LoadDashboardData();
        }

        protected void rptQuickDates_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectDate")
            {
                txtConsultationDate.Text = e.CommandArgument.ToString();
                SelectedPatientId = null;
                SelectedPatientName = null;
                LoadDashboardData();
            }
        }

        protected void btnResetRxFilter_Click(object sender, EventArgs e)
        {
            SelectedPatientId = null;
            SelectedPatientName = null;
            LoadDashboardData();
        }

        private List<DateTime> GetUpcomingWorkingDays(int count = 5)
        {
            List<DateTime> days = new List<DateTime>();
            DateTime cursor = GetNextWorkingDay(DateTime.Today);

            while (days.Count < count)
            {
                if (cursor.DayOfWeek != DayOfWeek.Saturday && cursor.DayOfWeek != DayOfWeek.Sunday)
                {
                    days.Add(cursor);
                }
                cursor = cursor.AddDays(1);
            }
            return days;
        }

        private DateTime GetNextWorkingDay(DateTime date)
        {
            DateTime d = date.Date;
            while (d.DayOfWeek == DayOfWeek.Saturday || d.DayOfWeek == DayOfWeek.Sunday)
            {
                d = d.AddDays(1);
            }
            return d;
        }

        private (DateTime Monday, DateTime Friday) GetWorkingWeekRange(DateTime date)
        {
            int diffFromMonday = ((int)date.DayOfWeek - (int)DayOfWeek.Monday + 7) % 7;
            DateTime monday = date.Date.AddDays(-diffFromMonday);
            DateTime friday = monday.AddDays(4);
            return (monday, friday);
        }

        private void BindQuickDatePills(DateTime activeDate)
        {
            List<DateTime> workingDays = GetUpcomingWorkingDays(5);

            var pills = workingDays.Select(d =>
            {
                string label = d.Date == DateTime.Today
                    ? $"Today ({d:ddd, dd MMM})"
                    : $"{d:ddd, dd MMM}";

                return new
                {
                    Label = label,
                    IsoDate = d.ToString("yyyy-MM-dd"),
                    IsActive = d.Date == activeDate.Date
                };
            }).ToList();

            rptQuickDates.DataSource = pills;
            rptQuickDates.DataBind();
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
                            string sql = $"SELECT TOP 1 * FROM [{docTable}] WHERE {string.Join(" OR ", where)}";
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
                // Falls back cleanly to email-derived display name
            }

            if (string.IsNullOrWhiteSpace(displayName))
            {
                displayName = FormatDoctorNameFromEmail(email);
            }
            else if (!displayName.StartsWith("Dr", StringComparison.OrdinalIgnoreCase))
            {
                displayName = "Dr. " + displayName;
            }

            litDoctorName.Text = Server.HtmlEncode(displayName);
        }

        private void LoadDashboardData()
        {
            List<DateTime> workingDays = GetUpcomingWorkingDays(5);
            DateTime maxAllowedWorkingDay = workingDays.Last();

            if (!DateTime.TryParse(txtConsultationDate.Text, out DateTime selectedDate))
            {
                selectedDate = workingDays.First();
            }

            pnlWeekendNotice.Visible = false;

            if (selectedDate.DayOfWeek == DayOfWeek.Saturday || selectedDate.DayOfWeek == DayOfWeek.Sunday)
            {
                DateTime adjustedMonday = GetNextWorkingDay(selectedDate);
                if (adjustedMonday > maxAllowedWorkingDay)
                    adjustedMonday = maxAllowedWorkingDay;

                selectedDate = adjustedMonday;
                pnlWeekendNotice.Visible = true;
                litWeekendNotice.Text = $"Clinicians do not operate on weekends (Saturday–Sunday). Schedule adjusted to {selectedDate:dddd, yyyy/MM/dd}.";
            }

            if (selectedDate.Date > maxAllowedWorkingDay)
            {
                selectedDate = maxAllowedWorkingDay;
            }

            txtConsultationDate.Text = selectedDate.ToString("yyyy-MM-dd");
            BindQuickDatePills(selectedDate);
            litSelectedDateDisplay.Text = $"{selectedDate:dddd, yyyy/MM/dd}";

            var (weekMonday, weekFriday) = GetWorkingWeekRange(selectedDate);
            litScriptsWeekRange.Text = $"{weekMonday:dd MMM} – {weekFriday:dd MMM}";

            int totalAppts = 0;
            int completed = 0;
            int inProgress = 0;
            int pending = 0;
            int weeklyScriptsCount = 0;

            DataTable dtAppts = new DataTable();
            dtAppts.Columns.Add("AppointmentID");
            dtAppts.Columns.Add("PatientID");
            dtAppts.Columns.Add("TimeSlot");
            dtAppts.Columns.Add("PatientName");
            dtAppts.Columns.Add("PatientIdentifier");
            dtAppts.Columns.Add("Reason");
            dtAppts.Columns.Add("AssignedNurse");
            dtAppts.Columns.Add("Status");

            DataTable dtRx = new DataTable();
            dtRx.Columns.Add("DateIssued");
            dtRx.Columns.Add("PatientName");
            dtRx.Columns.Add("Medication");
            dtRx.Columns.Add("DosageInstructions");
            dtRx.Columns.Add("Duration");

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();

                    string apptTable = ResolveExistingTable(conn, "Pro_Appointment", "Appointments", "Appointment");
                    string patTable = ResolveExistingTable(conn, "Patient", "Patients");
                    string nurseTable = ResolveExistingTable(conn, "Nurse", "Nurses", "Staff");
                    string treatTable = ResolveExistingTable(conn, "Treatment", "Treatments");

                    if (apptTable != null)
                    {
                        HashSet<string> aCols = GetTableColumns(conn, apptTable);
                        string apptPkCol = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                        string dateCol = FindColumn(aCols, "AppointmentDate", "Date", "ConsultationDate", "VisitDate", "ScheduledDate");
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

                        string statusCol = FindColumn(aCols, "Status", "AppointmentStatus");

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
                                 c.IndexOf("comment", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                 c.IndexOf("note", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                 c.IndexOf("desc", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                 c.IndexOf("detail", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                 c.IndexOf("service", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                 c.IndexOf("type", StringComparison.OrdinalIgnoreCase) >= 0));
                        }

                        string reasonFkCol = FindColumn(aCols,
                            "ServiceID", "Service_ID", "AppointmentTypeID", "Appointment_Type_ID",
                            "ConsultationTypeID", "Consultation_Type_ID", "ReasonID", "Reason_ID");

                        string docFkCol = FindColumn(aCols, "DoctorID", "Doctor_ID");
                        string patFkCol = FindColumn(aCols, "PatientID", "Patient_ID");
                        string nurseFkCol = FindColumn(aCols, "NurseID", "Nurse_ID", "AssignedNurseID", "Assigned_Nurse_ID", "StaffID", "Staff_ID");
                        string directNurseCol = FindColumn(aCols, "NurseName", "AssignedNurse", "Assigned_Nurse", "Nurse");

                        if (dateCol != null)
                        {
                            List<string> conditions = new List<string>
                            {
                                $"CAST(a.[{dateCol}] AS DATE) = @SelectedDate"
                            };

                            if (docFkCol != null && !string.IsNullOrWhiteSpace(CurrentDoctorId))
                            {
                                conditions.Add($"a.[{docFkCol}] = @DoctorID");
                            }

                            List<string> joinClauses = new List<string>();
                            string patSelectSql = "'' AS PFirst, '' AS PLast, '' AS PFull, '' AS PIdNum";
                            string nurseSelectSql = (directNurseCol != null ? $"a.[{directNurseCol}] AS DirectNurse, " : "'' AS DirectNurse, ") +
                                                    "'' AS NFirst, '' AS NLast, '' AS NFull";
                            string reasonLookupSelect = "'' AS LookupReason";

                            if (patTable != null && patFkCol != null)
                            {
                                HashSet<string> pCols = GetTableColumns(conn, patTable);
                                string pPkCol = FindColumn(pCols, "PatientID", "Patient_ID", "Id");
                                if (pPkCol != null)
                                {
                                    joinClauses.Add($"LEFT JOIN [{patTable}] p ON a.[{patFkCol}] = p.[{pPkCol}]");
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
                                        joinClauses.Add($"LEFT JOIN [{targetNurseTable}] n ON a.[{nurseFkCol}] = n.[{nPkCol}]");
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

                            if (reasonFkCol != null)
                            {
                                string lookupTable = ResolveExistingTable(conn,
                                    "Service", "Services", "AppointmentType", "AppointmentTypes",
                                    "ConsultationType", "ConsultationTypes", "Reason", "Reasons");
                                if (lookupTable != null)
                                {
                                    HashSet<string> lCols = GetTableColumns(conn, lookupTable);
                                    string lPk = FindColumn(lCols, reasonFkCol, "ServiceID", "AppointmentTypeID", "ConsultationTypeID", "ReasonID", "Id");
                                    string lName = FindColumn(lCols, "ServiceName", "TypeName", "ReasonName", "Reason", "Title", "Name", "Description");
                                    if (lPk != null && lName != null)
                                    {
                                        joinClauses.Add($"LEFT JOIN [{lookupTable}] rLookup ON a.[{reasonFkCol}] = rLookup.[{lPk}]");
                                        reasonLookupSelect = $"rLookup.[{lName}] AS LookupReason";
                                    }
                                }
                            }

                            string orderCol = timeCol ?? dateCol;
                            string apptQuery = $@"
                                SELECT a.*, {patSelectSql}, {nurseSelectSql}, {reasonLookupSelect}
                                FROM [{apptTable}] a
                                {string.Join(" ", joinClauses)}
                                WHERE {string.Join(" AND ", conditions)}
                                ORDER BY a.[{orderCol}] ASC";

                            using (SqlCommand cmd = new SqlCommand(apptQuery, conn))
                            {
                                cmd.Parameters.AddWithValue("@SelectedDate", selectedDate.Date);
                                if (!string.IsNullOrWhiteSpace(CurrentDoctorId))
                                    cmd.Parameters.AddWithValue("@DoctorID", CurrentDoctorId);

                                using (SqlDataReader r = cmd.ExecuteReader())
                                {
                                    while (r.Read())
                                    {
                                        totalAppts++;

                                        string apptId = (apptPkCol != null && r[apptPkCol] != DBNull.Value)
                                            ? r[apptPkCol].ToString()
                                            : "0";

                                        string status = (statusCol != null && r[statusCol] != DBNull.Value)
                                            ? r[statusCol].ToString().Trim()
                                            : "Scheduled";

                                        if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase))
                                            completed++;
                                        else if (status.IndexOf("Progress", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                                 status.IndexOf("Consultation", StringComparison.OrdinalIgnoreCase) >= 0)
                                            inProgress++;
                                        else if (!status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) &&
                                                 !status.Equals("No Show", StringComparison.OrdinalIgnoreCase))
                                            pending++;

                                        string patId = (patFkCol != null && r[patFkCol] != DBNull.Value)
                                            ? r[patFkCol].ToString()
                                            : "0";

                                        string pName = r["PFull"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["PFull"].ToString())
                                            ? r["PFull"].ToString().Trim()
                                            : $"{r["PFirst"]} {r["PLast"]}".Trim();

                                        if (string.IsNullOrWhiteSpace(pName))
                                            pName = "Patient #" + patId;

                                        string pIdent = r["PIdNum"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["PIdNum"].ToString())
                                            ? r["PIdNum"].ToString().Trim()
                                            : $"PAT-{patId}";

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
                                                nurseName = "Nurse #" + r[nurseFkCol].ToString();
                                            else
                                                nurseName = "Unassigned";
                                        }

                                        string timeStr = FormatAppointmentTime(
                                            timeCol != null ? r[timeCol] : null,
                                            dateCol != null ? r[dateCol] : null);

                                        string reason = "";
                                        if (reasonCol != null && r[reasonCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[reasonCol].ToString()))
                                            reason = r[reasonCol].ToString().Trim();
                                        else if (r["LookupReason"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["LookupReason"].ToString()))
                                            reason = r["LookupReason"].ToString().Trim();
                                        else
                                            reason = "Not specified";

                                        dtAppts.Rows.Add(apptId, patId, timeStr, pName, pIdent, reason, nurseName, status);
                                    }
                                }
                            }
                        }
                    }

                    string rxTable = ResolveExistingTable(conn, "Prescription", "Prescriptions");
                    if (rxTable != null)
                    {
                        weeklyScriptsCount = CountWeeklyScripts(conn, rxTable, treatTable, apptTable, weekMonday, weekFriday);
                        LoadPrescriptionsTable(conn, rxTable, patTable, treatTable, apptTable, dtRx);
                    }
                }
            }
            catch
            {
                // Retains clean empty states if a table is uninitialized
            }

            lblTotalAppointments.Text = totalAppts.ToString();
            lblCompletedCount.Text = completed.ToString();
            lblInProgressCount.Text = inProgress.ToString();
            lblPendingCount.Text = pending.ToString();
            lblScriptsIssuedCount.Text = weeklyScriptsCount.ToString();

            gvAppointments.DataSource = dtAppts;
            gvAppointments.DataBind();
            pnlNoAppointments.Visible = dtAppts.Rows.Count == 0;

            if (!string.IsNullOrWhiteSpace(SelectedPatientId))
            {
                litRxSectionTitle.Text = "Patient Prescription History — " + Server.HtmlEncode(SelectedPatientName ?? "Selected Patient");
                litRxSectionSubtitle.Text = "Showing electronic prescription history recorded for this patient.";
                btnResetRxFilter.Visible = true;
            }
            else
            {
                litRxSectionTitle.Text = "Recent Prescriptions Issued";
                litRxSectionSubtitle.Text = "Showing the 2 most recent electronic prescriptions issued.";
                btnResetRxFilter.Visible = false;
            }

            gvPrescriptions.DataSource = dtRx;
            gvPrescriptions.DataBind();
            pnlNoPrescriptions.Visible = dtRx.Rows.Count == 0;
        }

        private int CountWeeklyScripts(
            SqlConnection conn,
            string rxTable,
            string treatTable,
            string apptTable,
            DateTime weekMonday,
            DateTime weekFriday)
        {
            HashSet<string> rxCols = GetTableColumns(conn, rxTable);
            string rxDateCol = FindColumn(rxCols, "DateIssued", "PrescriptionDate", "IssueDate", "DatePrescribed", "CreatedDate", "Prescription_Date", "Date_Issued", "Date");
            string rxDocCol = FindColumn(rxCols, "DoctorID", "Doctor_ID");
            string rxTreatCol = FindColumn(rxCols, "TreatmentID", "Treatment_ID", "SessionID");
            string rxApptCol = FindColumn(rxCols, "AppointmentID", "Appointment_ID");

            if (rxDateCol == null) return 0;

            List<string> joins = new List<string>();
            string doctorIdExpr = rxDocCol != null ? $"rx.[{rxDocCol}]" : null;

            if (doctorIdExpr == null && rxTreatCol != null && treatTable != null)
            {
                HashSet<string> tCols = GetTableColumns(conn, treatTable);
                string tPk = FindColumn(tCols, "TreatmentID", "Treatment_ID", "SessionID", "Id");
                string tDoc = FindColumn(tCols, "DoctorID", "Doctor_ID");
                if (tPk != null && tDoc != null)
                {
                    joins.Add($"LEFT JOIN [{treatTable}] t ON rx.[{rxTreatCol}] = t.[{tPk}]");
                    doctorIdExpr = $"t.[{tDoc}]";
                }
            }
            else if (doctorIdExpr == null && rxApptCol != null && apptTable != null)
            {
                HashSet<string> aCols = GetTableColumns(conn, apptTable);
                string aPk = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                string aDoc = FindColumn(aCols, "DoctorID", "Doctor_ID");
                if (aPk != null && aDoc != null)
                {
                    joins.Add($"LEFT JOIN [{apptTable}] a ON rx.[{rxApptCol}] = a.[{aPk}]");
                    doctorIdExpr = $"a.[{aDoc}]";
                }
            }

            List<string> whereClauses = new List<string>
            {
                $"CAST(rx.[{rxDateCol}] AS DATE) BETWEEN @WeekStart AND @WeekEnd"
            };

            string userId = User.Identity.GetUserId();
            if (doctorIdExpr != null && !string.IsNullOrWhiteSpace(CurrentDoctorId))
            {
                whereClauses.Add($"CAST({doctorIdExpr} AS NVARCHAR(128)) IN (@DoctorID, @UserId)");
            }

            string sql = $@"
                SELECT COUNT(*)
                FROM [dbo].[{rxTable}] rx
                {string.Join(" ", joins)}
                WHERE {string.Join(" AND ", whereClauses)}";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@WeekStart", weekMonday.Date);
                cmd.Parameters.AddWithValue("@WeekEnd", weekFriday.Date);
                cmd.Parameters.AddWithValue("@DoctorID", CurrentDoctorId ?? "");
                cmd.Parameters.AddWithValue("@UserId", userId ?? "");

                int count = Convert.ToInt32(cmd.ExecuteScalar());

                if (count == 0 && whereClauses.Count > 1)
                {
                    string fallbackSql = $@"
                        SELECT COUNT(*)
                        FROM [dbo].[{rxTable}] rx
                        WHERE CAST(rx.[{rxDateCol}] AS DATE) BETWEEN @WeekStart AND @WeekEnd";

                    using (SqlCommand fbCmd = new SqlCommand(fallbackSql, conn))
                    {
                        fbCmd.Parameters.AddWithValue("@WeekStart", weekMonday.Date);
                        fbCmd.Parameters.AddWithValue("@WeekEnd", weekFriday.Date);
                        count = Convert.ToInt32(fbCmd.ExecuteScalar());
                    }
                }

                return count;
            }
        }

        private void LoadPrescriptionsTable(
            SqlConnection conn,
            string rxTable,
            string patTable,
            string treatTable,
            string apptTable,
            DataTable dtRx)
        {
            HashSet<string> rxCols = GetTableColumns(conn, rxTable);

            string rxPkCol = FindColumn(rxCols, "PrescriptionID", "Prescription_ID", "Id");
            string rxDateCol = FindColumn(rxCols, "DateIssued", "PrescriptionDate", "IssueDate", "DatePrescribed", "CreatedDate", "Prescription_Date", "Date_Issued", "Date");
            string rxDocCol = FindColumn(rxCols, "DoctorID", "Doctor_ID");
            string rxPatCol = FindColumn(rxCols, "PatientID", "Patient_ID");
            string rxTreatCol = FindColumn(rxCols, "TreatmentID", "Treatment_ID", "SessionID");
            string rxApptCol = FindColumn(rxCols, "AppointmentID", "Appointment_ID");

            string rxMedCol = FindColumn(rxCols, "MedicationName", "Medication", "DrugName", "MedicineName", "ItemName", "Medicine");
            string rxMedFkCol = FindColumn(rxCols, "MedicineID", "Medicine_ID", "MedicationID", "DrugID");
            string rxDoseCol = FindColumn(rxCols, "Dosage", "DosageInstructions", "Dose", "Instructions");
            string rxFreqCol = FindColumn(rxCols, "Frequency");
            string rxDurCol = FindColumn(rxCols, "Duration", "Notes", "Quantity", "Days");

            List<string> joins = new List<string>();
            string patSelect = "'' AS PFirst, '' AS PLast, '' AS PFull, '' AS ResolvedPatId";
            string patientIdExpr = rxPatCol != null ? $"rx.[{rxPatCol}]" : null;
            string doctorIdExpr = rxDocCol != null ? $"rx.[{rxDocCol}]" : null;

            if (patientIdExpr == null && rxTreatCol != null && treatTable != null)
            {
                HashSet<string> tCols = GetTableColumns(conn, treatTable);
                string tPk = FindColumn(tCols, "TreatmentID", "Treatment_ID", "SessionID", "Id");
                string tPat = FindColumn(tCols, "PatientID", "Patient_ID");
                string tDoc = FindColumn(tCols, "DoctorID", "Doctor_ID");
                if (tPk != null)
                {
                    joins.Add($"LEFT JOIN [{treatTable}] t ON rx.[{rxTreatCol}] = t.[{tPk}]");
                    if (tPat != null) patientIdExpr = $"t.[{tPat}]";
                    if (doctorIdExpr == null && tDoc != null) doctorIdExpr = $"t.[{tDoc}]";
                }
            }
            else if (patientIdExpr == null && rxApptCol != null && apptTable != null)
            {
                HashSet<string> aCols = GetTableColumns(conn, apptTable);
                string aPk = FindColumn(aCols, "AppointmentID", "Appointment_ID", "Id");
                string aPat = FindColumn(aCols, "PatientID", "Patient_ID");
                string aDoc = FindColumn(aCols, "DoctorID", "Doctor_ID");
                if (aPk != null)
                {
                    joins.Add($"LEFT JOIN [{apptTable}] a ON rx.[{rxApptCol}] = a.[{aPk}]");
                    if (aPat != null) patientIdExpr = $"a.[{aPat}]";
                    if (doctorIdExpr == null && aDoc != null) doctorIdExpr = $"a.[{aDoc}]";
                }
            }

            if (patTable != null && patientIdExpr != null)
            {
                HashSet<string> pCols = GetTableColumns(conn, patTable);
                string pPkCol = FindColumn(pCols, "PatientID", "Patient_ID", "Id");
                if (pPkCol != null)
                {
                    joins.Add($"LEFT JOIN [{patTable}] p ON {patientIdExpr} = p.[{pPkCol}]");
                    string pFirst = FindColumn(pCols, "FirstName", "PatientFirstName", "FName");
                    string pLast = FindColumn(pCols, "LastName", "Surname", "PatientLastName", "LName");
                    string pFull = FindColumn(pCols, "FullName", "PatientName", "Name");

                    patSelect =
                        (pFirst != null ? $"p.[{pFirst}] AS PFirst, " : "'' AS PFirst, ") +
                        (pLast != null ? $"p.[{pLast}] AS PLast, " : "'' AS PLast, ") +
                        (pFull != null ? $"p.[{pFull}] AS PFull, " : "'' AS PFull, ") +
                        $"CAST({patientIdExpr} AS NVARCHAR(50)) AS ResolvedPatId";
                }
            }

            string medSelect = "'' AS ResolvedMedName";
            if (rxMedCol == null && rxMedFkCol != null)
            {
                string medTable = ResolveExistingTable(conn, "Medicine", "Medicines", "Medication", "Medications");
                if (medTable != null)
                {
                    HashSet<string> mCols = GetTableColumns(conn, medTable);
                    string mPk = FindColumn(mCols, "MedicineID", "Medicine_ID", "MedicationID", "DrugID", "Id");
                    string mName = FindColumn(mCols, "MedicineName", "MedicationName", "Name", "DrugName");
                    if (mPk != null && mName != null)
                    {
                        joins.Add($"LEFT JOIN [{medTable}] m ON rx.[{rxMedFkCol}] = m.[{mPk}]");
                        medSelect = $"m.[{mName}] AS ResolvedMedName";
                    }
                }
            }

            string orderBy = rxDateCol != null
                ? $"ORDER BY rx.[{rxDateCol}] DESC" + (rxPkCol != null ? $", rx.[{rxPkCol}] DESC" : "")
                : (rxPkCol != null ? $"ORDER BY rx.[{rxPkCol}] DESC" : "");

            List<string> whereClauses = new List<string>();
            if (!string.IsNullOrWhiteSpace(SelectedPatientId) && patientIdExpr != null)
            {
                whereClauses.Add($"{patientIdExpr} = @PatientID");
            }
            else if (doctorIdExpr != null && !string.IsNullOrWhiteSpace(CurrentDoctorId))
            {
                whereClauses.Add($"{doctorIdExpr} = @DoctorID");
            }

            ExecutePrescriptionQuery(conn, rxTable, joins, patSelect, medSelect, whereClauses, orderBy,
                rxDateCol, rxMedCol, rxDoseCol, rxFreqCol, rxDurCol, dtRx);

            if (dtRx.Rows.Count == 0 && string.IsNullOrWhiteSpace(SelectedPatientId) && whereClauses.Count > 0)
            {
                ExecutePrescriptionQuery(conn, rxTable, joins, patSelect, medSelect, new List<string>(), orderBy,
                    rxDateCol, rxMedCol, rxDoseCol, rxFreqCol, rxDurCol, dtRx);
            }
        }

        private void ExecutePrescriptionQuery(
            SqlConnection conn,
            string rxTable,
            List<string> joins,
            string patSelect,
            string medSelect,
            List<string> whereClauses,
            string orderBy,
            string rxDateCol,
            string rxMedCol,
            string rxDoseCol,
            string rxFreqCol,
            string rxDurCol,
            DataTable dtRx)
        {
            int rowLimit = string.IsNullOrWhiteSpace(SelectedPatientId) ? 2 : 25;
            string whereSql = whereClauses.Count > 0 ? "WHERE " + string.Join(" AND ", whereClauses) : "";

            string sql = $@"
                SELECT TOP {rowLimit} rx.*, {patSelect}, {medSelect}
                FROM [dbo].[{rxTable}] rx
                {string.Join(" ", joins)}
                {whereSql}
                {orderBy}";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (!string.IsNullOrWhiteSpace(CurrentDoctorId))
                    cmd.Parameters.AddWithValue("@DoctorID", CurrentDoctorId);
                if (!string.IsNullOrWhiteSpace(SelectedPatientId))
                    cmd.Parameters.AddWithValue("@PatientID", SelectedPatientId);

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string dateStr = DateTime.Today.ToString("yyyy/MM/dd");
                        if (rxDateCol != null && r[rxDateCol] != DBNull.Value &&
                            DateTime.TryParse(r[rxDateCol].ToString(), out DateTime dIssued))
                        {
                            dateStr = dIssued.ToString("yyyy/MM/dd");
                        }

                        string pName = r["PFull"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["PFull"].ToString())
                            ? r["PFull"].ToString().Trim()
                            : $"{r["PFirst"]} {r["PLast"]}".Trim();

                        if (string.IsNullOrWhiteSpace(pName))
                        {
                            string resId = r["ResolvedPatId"] != DBNull.Value ? r["ResolvedPatId"].ToString() : "";
                            pName = !string.IsNullOrWhiteSpace(resId) ? "Patient #" + resId : "Clinic Patient";
                        }

                        string med = (rxMedCol != null && r[rxMedCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[rxMedCol].ToString()))
                            ? r[rxMedCol].ToString().Trim()
                            : (r["ResolvedMedName"] != DBNull.Value && !string.IsNullOrWhiteSpace(r["ResolvedMedName"].ToString())
                                ? r["ResolvedMedName"].ToString().Trim()
                                : "Prescribed Medication");

                        string dose = (rxDoseCol != null && r[rxDoseCol] != DBNull.Value) ? r[rxDoseCol].ToString().Trim() : "";
                        string freq = (rxFreqCol != null && r[rxFreqCol] != DBNull.Value) ? r[rxFreqCol].ToString().Trim() : "";
                        string doseCombined = $"{dose} {freq}".Trim();
                        if (string.IsNullOrWhiteSpace(doseCombined)) doseCombined = "As directed";

                        string dur = (rxDurCol != null && r[rxDurCol] != DBNull.Value && !string.IsNullOrWhiteSpace(r[rxDurCol].ToString()))
                            ? r[rxDurCol].ToString().Trim()
                            : "—";

                        dtRx.Rows.Add(dateStr, pName, med, doseCombined, dur);
                    }
                }
            }
        }

        protected void gvAppointments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewRx")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                if (rowIndex >= 0 && rowIndex < gvAppointments.DataKeys.Count)
                {
                    SelectedPatientId = gvAppointments.DataKeys[rowIndex]["PatientID"]?.ToString();
                    SelectedPatientName = gvAppointments.DataKeys[rowIndex]["PatientName"]?.ToString();
                    LoadDashboardData();
                }
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