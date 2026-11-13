using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Patient
{
    public partial class PatientDashboard : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["GroupPmb6ConnectionString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string userId = User.Identity.GetUserId();
            if (!User.IsInRole("Patient") || string.IsNullOrEmpty(userId))
            {
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Always restrict the GridView to the authenticated Identity account.
            dsUpcomingAppointments.SelectParameters["UserId"].DefaultValue = userId;
            if (!IsPostBack)
            {
                try
                {
                    LoadPublicPatientDetails(userId);
                    LoadAppointmentOverview(userId);
                }
                catch (SqlException ex)
                {
                    System.Diagnostics.Trace.TraceError(
                        "Patient dashboard failed: " + ex);

                    lblDashboardMessage.Text =
                        "We could not load your dashboard. Please try again later.";
                }
            }
        }

        private void LoadPublicPatientDetails(string userId)
        {
            lblPatientName.Text = "Profile not completed";
            lblPatientEmail.Text = HttpUtility.HtmlEncode(User.Identity.Name);
            lblPatientContact.Text = "Not provided";
            lblProfileState.Text = "Incomplete";
            lnkCompleteProfile.Visible = true;

            const string sql = @"SELECT TOP (1) FullName, EmailAddress, PhoneNumber
                                  FROM dbo.Patient WHERE UserId=@UserId";
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value = userId;
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return;
                    string fullName = Convert.ToString(r["FullName"]);
                    string email = Convert.ToString(r["EmailAddress"]);
                    string phone = Convert.ToString(r["PhoneNumber"]);
                    lblPatientName.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(fullName) ? "Not provided" : fullName);
                    lblPatientEmail.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(email) ? User.Identity.Name : email);
                    lblPatientContact.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(phone) ? "Not provided" : phone);
                    lblProfileState.Text = "Profile linked";
                    lnkCompleteProfile.Visible = false;
                }
            }
        }


        private void LoadAppointmentOverview(string userId)
        {
            const string sql = @"
    SELECT
        COUNT(a.PatientID) AS Total,

        COALESCE(SUM(CASE
            WHEN UPPER(LTRIM(RTRIM(a.AppointmentStatus)))
                = 'COMPLETED'
            THEN 1 ELSE 0 END), 0) AS Completed,

        COALESCE(SUM(CASE
            WHEN UPPER(LTRIM(RTRIM(a.AppointmentStatus)))
                = 'CANCELLED'
            THEN 1 ELSE 0 END), 0) AS Cancelled,

        COALESCE(SUM(CASE
            WHEN UPPER(LTRIM(RTRIM(a.AppointmentStatus)))
                = 'SCHEDULED'
            AND a.AppointmentDate IS NOT NULL
            AND CHARINDEX('-', a.TimeSlots) > 0
            AND (
                a.AppointmentDate > CONVERT(date, GETDATE())
                OR (
                    a.AppointmentDate = CONVERT(date, GETDATE())
                    AND TRY_CONVERT(time,
                        LTRIM(RTRIM(SUBSTRING(
                            a.TimeSlots,
                            CHARINDEX('-', a.TimeSlots) + 1,
                            LEN(a.TimeSlots)))))
                        > CONVERT(time, GETDATE())
                )
            )
            THEN 1 ELSE 0 END), 0) AS Upcoming

    FROM dbo.Patient p

    LEFT JOIN dbo.Pro_Appointment a
        ON a.PatientID = p.PatientID

    WHERE p.UserId = @UserId";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128)
                    .Value = userId;

                con.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblTotal.Text = Convert.ToString(reader["Total"]);
                        lblUpcoming.Text = Convert.ToString(reader["Upcoming"]);
                        lblCompleted.Text = Convert.ToString(reader["Completed"]);
                        lblCancelled.Text = Convert.ToString(reader["Cancelled"]);
                    }
                }
            }

            // Retrieve the patient's nearest scheduled appointment.
            const string nextSql = @"
    SELECT TOP (1)
        a.AppointmentDate,
        a.TimeSlots,
        COALESCE(d.FullName, 'Doctor to be confirmed')
            AS DoctorName

    FROM dbo.Pro_Appointment a

    INNER JOIN dbo.Patient p
        ON a.PatientID = p.PatientID

    LEFT JOIN dbo.Doctor d
        ON a.DoctorID = d.DoctorID

    WHERE p.UserId = @UserId

    AND UPPER(LTRIM(RTRIM(a.AppointmentStatus)))
        = 'SCHEDULED'

    AND CHARINDEX('-', a.TimeSlots) > 0

    AND (
        a.AppointmentDate > CONVERT(date, GETDATE())
        OR (
            a.AppointmentDate = CONVERT(date, GETDATE())
            AND TRY_CONVERT(time,
                LTRIM(RTRIM(SUBSTRING(
                    a.TimeSlots,
                    CHARINDEX('-', a.TimeSlots) + 1,
                    LEN(a.TimeSlots)))))
                > CONVERT(time, GETDATE())
        )
    )

    ORDER BY a.AppointmentDate,
        TRY_CONVERT(time,
            LEFT(a.TimeSlots,
                CHARINDEX('-', a.TimeSlots) - 1))";

            lblNextAppointment.Text =
                "No upcoming appointment scheduled.";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(nextSql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128)
                    .Value = userId;

                con.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string date = Convert.ToDateTime(
                            reader["AppointmentDate"])
                            .ToString("dddd, dd MMMM yyyy");

                        string timeSlots = HttpUtility.HtmlEncode(
                            Convert.ToString(reader["TimeSlots"]));

                        string doctor = HttpUtility.HtmlEncode(
                            Convert.ToString(reader["DoctorName"]));

                        lblNextAppointment.Text =
                            "<strong>" +
                            HttpUtility.HtmlEncode(date) +
                            "</strong>" +
                            "<small>" +
                            timeSlots + " | " + doctor +
                            "</small>";
                    }
                }
            }
        }

    }
}
