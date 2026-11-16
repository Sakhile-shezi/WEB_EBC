using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Nurse
{
    public partial class NurseDashboard : System.Web.UI.Page
    {
        // Same database the other nurse pages use.
        private string ConnString =>
            ConfigurationManager.ConnectionStrings["GroupPmb6ConnectionString"].ConnectionString;

        private const int RecentAdministrationLimit = 5;
        private const int PatientMedicationLimit = 25;

        private int? CurrentNurseId
        {
            get => ViewState["CurrentNurseId"] as int?;
            set => ViewState["CurrentNurseId"] = value;
        }

        private int? SelectedPatientId
        {
            get => ViewState["SelectedPatientId"] as int?;
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

            if (!User.IsInRole("Nurse"))
            {
                Response.Redirect("~/");
                return;
            }

            List<DateTime> workingDays = GetUpcomingWorkingDays(5);
            txtShiftDate.Attributes["max"] = workingDays.Last().ToString("yyyy-MM-dd");

            if (!IsPostBack)
            {
                txtShiftDate.Text = workingDays.First().ToString("yyyy-MM-dd");
                LoadDashboardData();
            }
        }

        // ==========================================
        // EVENTS
        // ==========================================

        protected void txtShiftDate_TextChanged(object sender, EventArgs e)
        {
            ClearSelectedPatient();
            LoadDashboardData();
        }

        protected void rptQuickDates_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectDate")
            {
                txtShiftDate.Text = e.CommandArgument.ToString();
                ClearSelectedPatient();
                LoadDashboardData();
            }
        }

        protected void btnResetMedFilter_Click(object sender, EventArgs e)
        {
            ClearSelectedPatient();
            LoadDashboardData();
        }

        protected void gvAppointments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "ViewMeds") return;

            int rowIndex;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out rowIndex)) return;
            if (rowIndex < 0 || rowIndex >= gvAppointments.DataKeys.Count) return;

            int patientId;
            if (int.TryParse(Convert.ToString(gvAppointments.DataKeys[rowIndex]["PatientID"]), out patientId))
            {
                SelectedPatientId = patientId;
                SelectedPatientName = Convert.ToString(gvAppointments.DataKeys[rowIndex]["PatientName"]);
            }

            LoadDashboardData();
        }

        private void ClearSelectedPatient()
        {
            SelectedPatientId = null;
            SelectedPatientName = null;
        }

        // ==========================================
        // WORKING-DAY HELPERS (same rules as the doctor dashboard)
        // ==========================================

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

        private DateTime GetWeekMonday(DateTime date)
        {
            int diffFromMonday = ((int)date.DayOfWeek - (int)DayOfWeek.Monday + 7) % 7;
            return date.Date.AddDays(-diffFromMonday);
        }

        private void BindQuickDatePills(DateTime activeDate)
        {
            var pills = GetUpcomingWorkingDays(5).Select(d => new
            {
                Label = d.Date == DateTime.Today
                    ? $"Today ({d:ddd, dd MMM})"
                    : $"{d:ddd, dd MMM}",
                IsoDate = d.ToString("yyyy-MM-dd"),
                IsActive = d.Date == activeDate.Date
            }).ToList();

            rptQuickDates.DataSource = pills;
            rptQuickDates.DataBind();
        }

        // ==========================================
        // LOGGED-IN NURSE
        // ==========================================

        private void LoadLoggedInNurse()
        {
            string userId = User.Identity.GetUserId();
            string displayName = "";
            CurrentNurseId = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP (1) NurseID, FullName
                    FROM dbo.Nurse
                    WHERE UserId = @UserId;", conn))
                {
                    cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value =
                        (object)userId ?? DBNull.Value;

                    conn.Open();

                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            CurrentNurseId = Convert.ToInt32(r["NurseID"]);
                            Session["NurseID"] = CurrentNurseId;
                            displayName = Convert.ToString(r["FullName"]).Trim();
                        }
                    }
                }
            }
            catch (SqlException)
            {
                ShowLoadError("The nurse profile could not be loaded. Please refresh the page or try again shortly.");
            }

            if (string.IsNullOrWhiteSpace(displayName))
            {
                displayName = User.Identity.GetUserName();
            }
            else if (!displayName.StartsWith("Nurse", StringComparison.OrdinalIgnoreCase) &&
                     !displayName.StartsWith("Sr", StringComparison.OrdinalIgnoreCase))
            {
                displayName = "Nurse " + displayName;
            }

            litNurseName.Text = Server.HtmlEncode(displayName);
        }

        // ==========================================
        // DASHBOARD DATA
        // ==========================================

        private void LoadDashboardData()
        {
            List<DateTime> workingDays = GetUpcomingWorkingDays(5);
            DateTime maxAllowedWorkingDay = workingDays.Last();

            DateTime selectedDate;
            if (!DateTime.TryParse(txtShiftDate.Text, out selectedDate))
            {
                selectedDate = workingDays.First();
            }
            selectedDate = selectedDate.Date;

            pnlWeekendNotice.Visible = false;

            if (selectedDate.DayOfWeek == DayOfWeek.Saturday || selectedDate.DayOfWeek == DayOfWeek.Sunday)
            {
                DateTime adjusted = GetNextWorkingDay(selectedDate);
                if (adjusted > maxAllowedWorkingDay)
                    adjusted = maxAllowedWorkingDay;

                selectedDate = adjusted;
                pnlWeekendNotice.Visible = true;
                litWeekendNotice.Text =
                    $"Clinicians do not operate on weekends (Saturday–Sunday). Schedule adjusted to {selectedDate:dddd, yyyy/MM/dd}.";
            }

            if (selectedDate > maxAllowedWorkingDay)
            {
                selectedDate = maxAllowedWorkingDay;
            }

            txtShiftDate.Text = selectedDate.ToString("yyyy-MM-dd");
            BindQuickDatePills(selectedDate);
            litSelectedDateDisplay.Text = $"{selectedDate:dddd, yyyy/MM/dd}";

            DateTime weekMonday = GetWeekMonday(selectedDate);
            DateTime weekFriday = weekMonday.AddDays(4);
            litDosesWeekRange.Text = $"{weekMonday:dd MMM} – {weekFriday:dd MMM}";

            int active = 0, completed = 0, inProgress = 0, pending = 0, cancelled = 0;
            int weeklyDoses = 0;

            DataTable dtAppts = NewTable(
                "AppointmentID", "PatientID", "TimeSlot", "PatientName",
                "PatientIdentifier", "Reason", "AttendingDoctor", "Status");
            DataTable dtRecent = NewTable(
                "AdministeredAt", "PatientName", "Medication", "DoseGiven", "Status", "Notes");
            DataTable dtPatientMeds = NewTable(
                "DateIssued", "Medication", "DosageInstructions", "Duration",
                "PrescribedBy", "DosesGiven", "LastGiven");

            bool showingPatient = SelectedPatientId.HasValue;

            // Retry the profile lookup on later requests if it failed earlier.
            bool profileLookupFailed = false;
            pnlLoadError.Visible = false;
            if (!CurrentNurseId.HasValue)
            {
                LoadLoggedInNurse();
                profileLookupFailed = pnlLoadError.Visible;
            }
            pnlNotLinked.Visible = !CurrentNurseId.HasValue && !profileLookupFailed;

            // Without a linked nurse record nothing is shown: the dashboard never
            // falls back to other nurses' appointments or records.
            if (CurrentNurseId.HasValue)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnString))
                    {
                        conn.Open();

                        LoadAppointments(conn, CurrentNurseId.Value, selectedDate, dtAppts);
                        weeklyDoses = CountWeeklyDoses(conn, CurrentNurseId.Value, weekMonday);

                        if (showingPatient)
                            LoadPatientMedication(conn, SelectedPatientId.Value, dtPatientMeds);
                        else
                            LoadRecentAdministrations(conn, CurrentNurseId.Value, dtRecent);
                    }
                }
                catch (SqlException)
                {
                    dtAppts.Clear();
                    dtRecent.Clear();
                    dtPatientMeds.Clear();
                    weeklyDoses = 0;
                    ShowLoadError("The dashboard data could not be loaded, so the figures below are not current. Please refresh the page or try again shortly.");
                }
            }

            foreach (DataRow row in dtAppts.Rows)
            {
                switch (GetStatusGroup(row["Status"].ToString()))
                {
                    case "completed": completed++; active++; break;
                    case "progress": inProgress++; active++; break;
                    case "cancelled": cancelled++; break;
                    default: pending++; active++; break;
                }
            }

            // Appointments = Completed + In Progress + Pending.
            // Cancelled / no-show bookings stay in the list but are reported separately.
            lblTotalAppointments.Text = active.ToString();
            lblCompletedCount.Text = completed.ToString();
            lblInProgressCount.Text = inProgress.ToString();
            lblPendingCount.Text = pending.ToString();
            lblDosesGivenCount.Text = weeklyDoses.ToString();
            litCancelledNote.Text = cancelled > 0
                ? $"+ {cancelled} cancelled / no-show"
                : "";

            gvAppointments.DataSource = dtAppts;
            gvAppointments.DataBind();
            pnlNoAppointments.Visible = dtAppts.Rows.Count == 0;

            if (showingPatient)
            {
                litMedSectionTitle.Text = "Prescribed Medication — " +
                    Server.HtmlEncode(SelectedPatientName ?? "Selected Patient");
                litMedSectionSubtitle.Text =
                    "Showing medication prescribed to this patient and how many doses have been administered.";
                litNoMedication.Text = "No medication has been prescribed to this patient.";
                btnResetMedFilter.Visible = true;

                gvRecentAdministrations.Visible = false;
                gvPatientMedication.Visible = true;
                gvPatientMedication.DataSource = dtPatientMeds;
                gvPatientMedication.DataBind();
                pnlNoMedication.Visible = dtPatientMeds.Rows.Count == 0;
            }
            else
            {
                litMedSectionTitle.Text = "Recent Medication Administered";
                litMedSectionSubtitle.Text =
                    $"Showing the {RecentAdministrationLimit} most recent administration records you captured.";
                litNoMedication.Text = "You have not captured any medication administration records yet.";
                btnResetMedFilter.Visible = false;

                gvPatientMedication.Visible = false;
                gvRecentAdministrations.Visible = true;
                gvRecentAdministrations.DataSource = dtRecent;
                gvRecentAdministrations.DataBind();
                pnlNoMedication.Visible = dtRecent.Rows.Count == 0;
            }
        }

        // Appointments booked for this nurse on the selected day, earliest slot first.
        private void LoadAppointments(SqlConnection conn, int nurseId, DateTime selectedDate, DataTable dtAppts)
        {
            const string sql = @"
                SELECT
                    A.AppointmentID,
                    A.PatientID,
                    A.TimeSlots,
                    A.AppointmentReason,
                    A.AppointmentStatus,
                    P.FullName AS PatientName,
                    D.FullName AS DoctorName
                FROM dbo.Pro_Appointment A
                LEFT JOIN dbo.Patient P
                    ON A.PatientID = P.PatientID
                LEFT JOIN dbo.Doctor D
                    ON A.DoctorID = D.DoctorID
                WHERE A.NurseID = @NurseID
                  AND A.AppointmentDate >= @Date
                  AND A.AppointmentDate < DATEADD(DAY, 1, @Date)
                ORDER BY
                    CASE WHEN TRY_CONVERT(time(0), LTRIM(RTRIM(
                            CASE WHEN CHARINDEX('-', A.TimeSlots) > 0
                                 THEN LEFT(A.TimeSlots, CHARINDEX('-', A.TimeSlots) - 1)
                                 ELSE A.TimeSlots END))) IS NULL THEN 1 ELSE 0 END,
                    TRY_CONVERT(time(0), LTRIM(RTRIM(
                            CASE WHEN CHARINDEX('-', A.TimeSlots) > 0
                                 THEN LEFT(A.TimeSlots, CHARINDEX('-', A.TimeSlots) - 1)
                                 ELSE A.TimeSlots END))),
                    A.AppointmentID;";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@NurseID", SqlDbType.Int).Value = nurseId;
                cmd.Parameters.Add("@Date", SqlDbType.Date).Value = selectedDate.Date;

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string apptId = Text(r, "AppointmentID");
                        string patId = Text(r, "PatientID");

                        dtAppts.Rows.Add(
                            apptId,
                            patId,
                            TextOr(r, "TimeSlots", "--:--"),
                            TextOr(r, "PatientName", patId.Length > 0 ? "Patient #" + patId : "Unknown patient"),
                            patId.Length > 0 ? "PAT-" + patId : "—",
                            TextOr(r, "AppointmentReason", "Not specified"),
                            TextOr(r, "DoctorName", "Unassigned"),
                            TextOr(r, "AppointmentStatus", "Scheduled"));
                    }
                }
            }
        }

        // Doses this nurse actually gave (fully or partially) in the Mon–Fri week
        // of the selected date. "Not Administered" records are not counted.
        private int CountWeeklyDoses(SqlConnection conn, int nurseId, DateTime weekMonday)
        {
            const string sql = @"
                SELECT COUNT(*)
                FROM dbo.MedicationAdministration
                WHERE NurseID = @NurseID
                  AND Admnistered_at >= @WeekStart
                  AND Admnistered_at < @WeekEndExclusive
                  AND UPPER(LTRIM(RTRIM(ISNULL(status, '')))) <> 'NOT ADMINISTERED';";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@NurseID", SqlDbType.Int).Value = nurseId;
                cmd.Parameters.Add("@WeekStart", SqlDbType.DateTime).Value = weekMonday.Date;
                cmd.Parameters.Add("@WeekEndExclusive", SqlDbType.DateTime).Value = weekMonday.Date.AddDays(5);

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // The latest administration records captured by this nurse.
        private void LoadRecentAdministrations(SqlConnection conn, int nurseId, DataTable dtRecent)
        {
            string sql = $@"
                SELECT TOP ({RecentAdministrationLimit})
                    MA.Admnistered_at,
                    MA.dosageGiven,
                    MA.frequency_Instance,
                    MA.status,
                    MA.Notes,
                    PA.FullName AS PatientName,
                    M.MedicineName
                FROM dbo.MedicationAdministration MA
                INNER JOIN dbo.PrescriptionItem PI
                    ON MA.PrescriptionItemID = PI.PrescriptionItemID
                INNER JOIN dbo.Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                LEFT JOIN dbo.Patient PA
                    ON P.PatientID = PA.PatientID
                LEFT JOIN dbo.Medicine M
                    ON PI.MedicineID = M.MedicineID
                WHERE MA.NurseID = @NurseID
                ORDER BY MA.Admnistered_at DESC, MA.medication_AdministrationID DESC;";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@NurseID", SqlDbType.Int).Value = nurseId;

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string dose = Text(r, "dosageGiven");
                        string instance = Text(r, "frequency_Instance");
                        string doseDisplay = dose.Length > 0 ? dose : "—";
                        if (instance.Length > 0)
                            doseDisplay += $" (dose #{instance})";

                        dtRecent.Rows.Add(
                            FormatDateTime(r["Admnistered_at"], "yyyy/MM/dd HH:mm"),
                            TextOr(r, "PatientName", "Unknown patient"),
                            TextOr(r, "MedicineName", "Unknown medicine"),
                            doseDisplay,
                            TextOr(r, "status", "Not recorded"),
                            TextOr(r, "Notes", "—"));
                    }
                }
            }
        }

        // Everything prescribed to the selected patient, with the number of doses
        // already given (by any nurse) against each prescribed item.
        private void LoadPatientMedication(SqlConnection conn, int patientId, DataTable dtPatientMeds)
        {
            string sql = $@"
                SELECT TOP ({PatientMedicationLimit})
                    P.DateIssued,
                    M.MedicineName,
                    PI.Dosage,
                    PI.Frequency,
                    PI.Duration,
                    D.FullName AS DoctorName,
                    (SELECT COUNT(*)
                     FROM dbo.MedicationAdministration MA
                     WHERE MA.PrescriptionItemID = PI.PrescriptionItemID
                       AND UPPER(LTRIM(RTRIM(ISNULL(MA.status, '')))) <> 'NOT ADMINISTERED') AS DosesGiven,
                    (SELECT MAX(MA.Admnistered_at)
                     FROM dbo.MedicationAdministration MA
                     WHERE MA.PrescriptionItemID = PI.PrescriptionItemID
                       AND UPPER(LTRIM(RTRIM(ISNULL(MA.status, '')))) <> 'NOT ADMINISTERED') AS LastGiven
                FROM dbo.PrescriptionItem PI
                INNER JOIN dbo.Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                LEFT JOIN dbo.Medicine M
                    ON PI.MedicineID = M.MedicineID
                LEFT JOIN dbo.Doctor D
                    ON P.DoctorID = D.DoctorID
                WHERE P.PatientID = @PatientID
                ORDER BY P.DateIssued DESC, PI.PrescriptionItemID DESC;";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@PatientID", SqlDbType.Int).Value = patientId;

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string doseCombined = (Text(r, "Dosage") + " " + Text(r, "Frequency")).Trim();
                        if (doseCombined.Length == 0) doseCombined = "As directed";

                        string duration = Text(r, "Duration");
                        int durationDays;
                        if (duration.Length == 0)
                            duration = "—";
                        else if (int.TryParse(duration, out durationDays))
                            duration = durationDays == 1 ? "1 day" : durationDays + " days";

                        dtPatientMeds.Rows.Add(
                            FormatDateTime(r["DateIssued"], "yyyy/MM/dd"),
                            TextOr(r, "MedicineName", "Unknown medicine"),
                            doseCombined,
                            duration,
                            TextOr(r, "DoctorName", "—"),
                            Text(r, "DosesGiven"),
                            r["LastGiven"] == DBNull.Value
                                ? "Not yet given"
                                : FormatDateTime(r["LastGiven"], "yyyy/MM/dd HH:mm"));
                    }
                }
            }
        }

        // ==========================================
        // STATUS HELPERS
        // ==========================================

        // One rule decides both the KPI a booking is counted under and its badge colour,
        // so the cards and the table can never disagree.
        private static string GetStatusGroup(string status)
        {
            string s = (status ?? "").Trim();

            if (s.Equals("Completed", StringComparison.OrdinalIgnoreCase))
                return "completed";
            if (s.IndexOf("Progress", StringComparison.OrdinalIgnoreCase) >= 0 ||
                s.IndexOf("Consultation", StringComparison.OrdinalIgnoreCase) >= 0)
                return "progress";
            if (s.StartsWith("Cancel", StringComparison.OrdinalIgnoreCase) ||
                s.Replace("-", " ").Equals("No Show", StringComparison.OrdinalIgnoreCase))
                return "cancelled";
            return "pending";
        }

        protected string GetStatusBadgeClass(string status)
        {
            switch (GetStatusGroup(status))
            {
                case "completed": return "badge-completed";
                case "progress": return "badge-progress";
                case "cancelled": return "badge-cancelled";
                default: return "badge-pending";
            }
        }

        protected string GetAdministrationBadgeClass(string status)
        {
            string s = (status ?? "").Trim();

            if (s.Equals("Administered", StringComparison.OrdinalIgnoreCase)) return "badge-completed";
            if (s.StartsWith("Partial", StringComparison.OrdinalIgnoreCase)) return "badge-progress";
            if (s.StartsWith("Not Administered", StringComparison.OrdinalIgnoreCase)) return "badge-cancelled";
            return "badge-neutral";
        }

        // ==========================================
        // SMALL UTILITIES
        // ==========================================

        private void ShowLoadError(string message)
        {
            litLoadError.Text = Server.HtmlEncode(message);
            pnlLoadError.Visible = true;
        }

        private static DataTable NewTable(params string[] columns)
        {
            DataTable dt = new DataTable();
            foreach (string column in columns)
                dt.Columns.Add(column);
            return dt;
        }

        private static string Text(SqlDataReader r, string column)
        {
            object value = r[column];
            return value == DBNull.Value ? "" : Convert.ToString(value).Trim();
        }

        private static string TextOr(SqlDataReader r, string column, string fallback)
        {
            string value = Text(r, column);
            return value.Length > 0 ? value : fallback;
        }

        private static string FormatDateTime(object value, string format)
        {
            if (value == null || value == DBNull.Value) return "—";
            if (value is DateTime) return ((DateTime)value).ToString(format);

            DateTime parsed;
            return DateTime.TryParse(Convert.ToString(value), out parsed)
                ? parsed.ToString(format)
                : Convert.ToString(value);
        }
    }
}
