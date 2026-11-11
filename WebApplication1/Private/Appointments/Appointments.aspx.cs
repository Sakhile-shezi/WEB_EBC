using Microsoft.AspNet.Identity;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Appointments
{
    public partial class Appointments : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "GroupPmb6ConnectionString"].ConnectionString;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string userId = User.Identity.GetUserId();

            // Filter appointment history by the registered account.
            SqlDataSourceMyAppointments
                .SelectParameters["UserId"]
                .DefaultValue = userId ?? "";

            if (!IsPostBack)
            {
                // Load patient information without blocking browsing.
                PopulatePatientDisplay();

                DateTime date = DateTime.Today;

                while (date.DayOfWeek == DayOfWeek.Saturday ||
                       date.DayOfWeek == DayOfWeek.Sunday)
                {
                    date = date.AddDays(1);
                }

                Calendar1BookDate.SelectedDate = date;
                Calendar1BookDate.VisibleDate = date;

                // Doctor and nurse dropdowns continue using
                // their existing SqlDataSources.
            }
        }


        private int GetPatientId(string email)
        {
            // Retrieve the user ID from the authenticated account.
            string userId = User.Identity.GetUserId();

            if (string.IsNullOrWhiteSpace(userId))
                return 0;

            const string sql = @"
        SELECT TOP (1) PatientID
        FROM dbo.Patient
        WHERE UserId = @UserId
          AND NULLIF(LTRIM(RTRIM(FullName)), '') IS NOT NULL
          AND DateOfBirth IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(PhoneNumber)), '') IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(Address)), '') IS NOT NULL
          AND NULLIF(LTRIM(RTRIM(gender)), '') IS NOT NULL";

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(sql, connection))
            {
                command.Parameters.Add(
                    "@UserId",
                    SqlDbType.NVarChar,
                    128
                ).Value = userId;

                connection.Open();

                object result = command.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    return 0;

                return Convert.ToInt32(result);
            }
        }



        private void PopulatePatientDisplay()
        {
            txtPatientEmail.Text = User.Identity.Name;
            txtPatientName.Text = "Profile not completed";

            string userId = User.Identity.GetUserId();

            if (string.IsNullOrWhiteSpace(userId))
                return;

            const string sql = @"
        SELECT TOP (1) FullName
        FROM dbo.Patient
        WHERE UserId = @UserId";

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(sql, connection))
            {
                command.Parameters.Add(
                    "@UserId",
                    SqlDbType.NVarChar, 128
                ).Value = userId;

                connection.Open();

                object result = command.ExecuteScalar();

                if (result != null &&
                    result != DBNull.Value &&
                    !string.IsNullOrWhiteSpace(result.ToString()))
                {
                    txtPatientName.Text = result.ToString();
                }
            }
        }



        private void ShowProfilePopup()
        {
            string profileUrl = HttpUtility.JavaScriptStringEncode(
                ResolveUrl("~/Private/CompletePatientProfile.aspx"));

            string script =
                "if (confirm('Before booking, please complete your patient profile.\\n\\n" +
                "Would you like to complete it now?')) {" +
                "window.location.href = '" + profileUrl + "';" +
                "}";

            ClientScript.RegisterStartupScript(
                GetType(),
                "CompleteProfilePrompt",
                script,
                true
            );
        }


        protected void Calendar1BookDate_SelectionChanged(object sender, EventArgs e)
        {
            LoadAvailableTimeSlots();
        }

        protected void Calendar1BookDate_DayRender(object sender, DayRenderEventArgs e)
        {
   
            DateTime minimumDate = DateTime.Today.AddDays(1);

            bool isPastOrToday = e.Day.Date < minimumDate;

            bool isWeekend =
                e.Day.Date.DayOfWeek == DayOfWeek.Saturday ||
                e.Day.Date.DayOfWeek == DayOfWeek.Sunday;

            if (isPastOrToday || isWeekend)
            {
                e.Day.IsSelectable = false;

                e.Cell.ForeColor = System.Drawing.Color.Gray;
                e.Cell.ToolTip = isWeekend
                    ? "Appointments are only available Monday to Friday."
                    : "Appointments can only be booked from tomorrow onwards.";
            }
        }
        

        protected void BookingSelectionChanged(object sender, EventArgs e)
        {
            LoadAvailableTimeSlots();
        }

        private bool IsValidBookingDate(DateTime date)
        {
            // Reject dates before today
            if (date.Date < DateTime.Today)
                return false;

            // Reject weekends
            if (date.DayOfWeek == DayOfWeek.Saturday ||
                date.DayOfWeek == DayOfWeek.Sunday)
                return false;

            return true;
        }


        // These time options are display aids only; the SQL procedure enforces
        // the same rules atomically before accepting any appointment.
        private static readonly TimeSpan OpenAt = new TimeSpan(9, 0, 0);
        private static readonly TimeSpan CloseAt = new TimeSpan(16, 30, 0);
        private static readonly TimeSpan LunchFrom = new TimeSpan(12, 0, 0);
        private static readonly TimeSpan LunchUntil = new TimeSpan(13, 0, 0);
        private static readonly TimeSpan Step = TimeSpan.FromMinutes(30);
        private bool _bookingInserted;

        private static string FormatTime(TimeSpan time)
        {
            return DateTime.Today.Add(time).ToString("hh:mm tt", CultureInfo.InvariantCulture);
        }

        private static bool ParseTime(string value, out TimeSpan time)
        {
            DateTime parsed;
            bool ok = DateTime.TryParseExact(value, new[] { "hh:mm tt", "h:mm tt", "HH:mm", "HH:mm:ss" },
                CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed);
            time = ok ? parsed.TimeOfDay : TimeSpan.Zero;
            return ok;
        }

        // A read-only schedule of all active appointments matching this selection.
        private DataTable ReadExistingBookings(DateTime date, int doctorId, int nurseId, int patientId)
        {
            const string sql = @"SELECT PatientID AS Patient_ID, DoctorID AS Doctor_ID, NurseID AS Nurse_ID,
                      TRY_CONVERT(time(0), LTRIM(RTRIM(CASE WHEN CHARINDEX(' - ', TimeSlots) > 0
                        THEN LEFT(TimeSlots, CHARINDEX(' - ', TimeSlots)-1)
                        WHEN CHARINDEX('-', TimeSlots) > 0 THEN LEFT(TimeSlots, CHARINDEX('-', TimeSlots)-1)
                        ELSE '' END))) AS BookedStart,
                      TRY_CONVERT(time(0), LTRIM(RTRIM(CASE WHEN CHARINDEX(' - ', TimeSlots) > 0
                        THEN SUBSTRING(TimeSlots, CHARINDEX(' - ', TimeSlots)+3, 100)
                        WHEN CHARINDEX('-', TimeSlots) > 0 THEN SUBSTRING(TimeSlots, CHARINDEX('-', TimeSlots)+1, 100)
                        ELSE '' END))) AS BookedEnd
                FROM dbo.Pro_Appointment
                WHERE AppointmentDate >= @Date AND AppointmentDate < DATEADD(day, 1, @Date)
                  AND UPPER(LTRIM(RTRIM(ISNULL(AppointmentStatus, '')))) <> 'CANCELLED'
                  AND (DoctorID = @DoctorID OR NurseID = @NurseID
                       OR (@PatientID > 0 AND PatientID = @PatientID))";
            var data = new DataTable();
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@Date", SqlDbType.Date).Value = date.Date;
                cmd.Parameters.Add("@DoctorID", SqlDbType.Int).Value = doctorId;
                cmd.Parameters.Add("@NurseID", SqlDbType.Int).Value = nurseId;
                cmd.Parameters.Add("@PatientID", SqlDbType.Int).Value = patientId;
                using (var adapter = new SqlDataAdapter(cmd)) adapter.Fill(data);
            }
            return data;
        }

        private static bool IsFree(DataTable rows, TimeSpan start, TimeSpan end)
        {
            if (end <= start || start < OpenAt || end > CloseAt ||
                (start < LunchUntil && end > LunchFrom)) return false;
            foreach (DataRow row in rows.Rows)
            {
                // Fail closed rather than silently ignore unparsable legacy bookings.
                if (row["BookedStart"] == DBNull.Value || row["BookedEnd"] == DBNull.Value)
                    return false;
                TimeSpan bookedStart = (TimeSpan)row["BookedStart"];
                TimeSpan bookedEnd = (TimeSpan)row["BookedEnd"];
                if (start < bookedEnd && end > bookedStart) return false;
            }
            return true;
        }

        private void LoadAvailableTimeSlots()
        {
            ddlTimeSlot.Items.Clear();
            ddlTimeSlot.Items.Add(new ListItem("-- Select Start Time --", ""));
            ddlEndTime.Items.Clear();
            ddlEndTime.Items.Add(new ListItem("-- Select End Time --", ""));
            int doctorId, nurseId;
            DateTime date = Calendar1BookDate.SelectedDate.Date;
            if (!int.TryParse(ddlDoctor.SelectedValue, out doctorId) ||
                !int.TryParse(ddlNurse.SelectedValue, out nurseId) || !IsValidBookingDate(date)) return;

            var booked = ReadExistingBookings(date, doctorId, nurseId, GetPatientId(User.Identity.Name));
            int dailyCount = 0;
            foreach (DataRow row in booked.Rows)
                if (Convert.ToInt32(row["Doctor_ID"]) == doctorId) dailyCount++;
            if (dailyCount >= 6)
            {
                ShowMessage("This doctor has reached six appointments today.", false);
                return;
            }
            for (TimeSpan start = OpenAt; start + Step <= CloseAt; start += Step)
            {
                if (date == DateTime.Today && start <= DateTime.Now.TimeOfDay) continue;
                // Include a start only if at least one 30-minute or longer end is available.
                bool hasEnd = false;
                for (TimeSpan end = start + Step; end <= CloseAt; end += Step)
                    if (IsFree(booked, start, end)) { hasEnd = true; break; }
                if (hasEnd)
                {
                    string label = FormatTime(start);
                    ddlTimeSlot.Items.Add(new ListItem(label, label));
                }
            }
        }

        protected void StartTimeSelectionChanged(object sender, EventArgs e)
        {
            LoadEndTimes();
        }

        private void LoadEndTimes()
        {
            ddlEndTime.Items.Clear();
            ddlEndTime.Items.Add(new ListItem("-- Select End Time --", ""));
            int doctorId, nurseId;
            TimeSpan start;
            DateTime date = Calendar1BookDate.SelectedDate.Date;
            if (!int.TryParse(ddlDoctor.SelectedValue, out doctorId) ||
                !int.TryParse(ddlNurse.SelectedValue, out nurseId) ||
                !ParseTime(ddlTimeSlot.SelectedValue, out start) || !IsValidBookingDate(date)) return;
            var booked = ReadExistingBookings(date, doctorId, nurseId, GetPatientId(User.Identity.Name));
            for (TimeSpan end = start + Step; end <= CloseAt; end += Step)
            {
                if (!IsFree(booked, start, end)) break;
                string label = FormatTime(end);
                ddlEndTime.Items.Add(new ListItem(label, label));
            }
        }

        protected void Button1BookAppointement_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Request.IsAuthenticated) { Response.Redirect("~/Account/Login.aspx"); return; }
                string userId = User.Identity.GetUserId();
                int patientId = GetPatientId(User.Identity.Name);
                if (patientId <= 0) { ShowMessage("Complete your patient profile before booking.", false); ShowProfilePopup(); return; }
                int doctorId, nurseId;
                if (!int.TryParse(ddlDoctor.SelectedValue, out doctorId) ||
                    !int.TryParse(ddlNurse.SelectedValue, out nurseId))
                { ShowMessage("Please select a doctor and nurse.", false); return; }
                DateTime date = Calendar1BookDate.SelectedDate.Date;
                TimeSpan start, end;
                if (!IsValidBookingDate(date) ||
                    !ParseTime(ddlTimeSlot.SelectedValue, out start) ||
                    !ParseTime(ddlEndTime.SelectedValue, out end) ||
                    start.Ticks % Step.Ticks != 0 || end.Ticks % Step.Ticks != 0 ||
                    !IsFree(new DataTable(), start, end) ||
                    (date == DateTime.Today && start <= DateTime.Now.TimeOfDay))
                { ShowMessage("Please select a valid weekday, start time and end time.", false); return; }

                string reason = txtAppointmentReason.Text.Trim();
                if (reason.Length < 1 || reason.Length > 100)
                { ShowMessage("Enter an appointment reason (1-100 characters).", false); return; }

                // The database procedure checks overlaps and daily limit again under a lock.
                // Only the authenticated account determines the PatientID; controls cannot impersonate others.

                // Combine start time and end time into one TimeSlots value
                string timeSlots =
                    DateTime.Today.Add(start).ToString("hh:mm tt", CultureInfo.InvariantCulture)
                    + "-" +
                    DateTime.Today.Add(end).ToString("hh:mm tt", CultureInfo.InvariantCulture);

                // Set appointment parameters
                var p = SqlDataSourceInsertAppointment.InsertParameters;

                p["patientID"].DefaultValue =
                    patientId.ToString(CultureInfo.InvariantCulture);

                p["appointmentReason"].DefaultValue = reason;

                p["appointmentDate"].DefaultValue =
                    date.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

                // Combine the selected start and end times.
            

                p["timeslots"].DefaultValue = timeSlots;

                _bookingInserted = false;
                SqlDataSourceInsertAppointment.Insert();
                if (!_bookingInserted) return;
                lblAppointmentStatus.Text = "SCHEDULED MEETING";
                lblAppointmentStatus.CssClass = "eb-status-scheduled";
                GridViewMyAppointments.DataBind();
                txtAppointmentReason.Text = "";
                ddlTimeSlot.SelectedIndex = 0;
                LoadAvailableTimeSlots();
                ShowMessage("Appointment booked successfully.", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Appointment save error: " + ex);
                ShowMessage("Unable to save appointment. Check the database procedure and try again.", false);
            }
        }

        protected void SqlDataSourceInsertAppointment_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {

            {
                if (e.Exception != null)
                {
                    Exception actualError = e.Exception.GetBaseException();

                    System.Diagnostics.Trace.TraceError(
                        "Appointment booking failed: " +
                        e.Exception.ToString());

                    // Only show database details while debugging locally.
                    if (Request.IsLocal)
                    {
                        lblBookingMessage.Text =
                            "Booking error: " +
                            Server.HtmlEncode(actualError.Message);
                    }
                    else
                    {
                        lblBookingMessage.Text =
                            "Unable to book this appointment. " +
                            "Please try again or contact the clinic.";
                    }

                    lblBookingMessage.ForeColor = Color.Red;

                    e.ExceptionHandled = true;
                    _bookingInserted = false;
                    return;
                }

                _bookingInserted = e.AffectedRows >= 0;
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblBookingMessage.Text = Server.HtmlEncode(message);
            lblBookingMessage.ForeColor = success ? Color.Green : Color.Red;
        }

        protected void SqlDataSourceInsertAppointment_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
    }
}
