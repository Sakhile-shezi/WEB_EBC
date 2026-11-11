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
                    System.Diagnostics.Trace.TraceError("Patient dashboard failed: " + ex);
                    lblDashboardMessage.Text = "We could not load your dashboard. Please try again later.";
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
            // "Completed" means explicitly marked completed, not just past its date.
            const string sql = @"
SELECT COUNT(a.Appointment_ID) AS Total,
       COALESCE(SUM(CASE WHEN UPPER(LTRIM(RTRIM(ISNULL(a.Appointment_Status,'')))) = 'COMPLETED' THEN 1 ELSE 0 END),0) AS Completed,
       COALESCE(SUM(CASE WHEN UPPER(LTRIM(RTRIM(ISNULL(a.Appointment_Status,'')))) = 'CANCELLED' THEN 1 ELSE 0 END),0) AS Cancelled,
       COALESCE(SUM(CASE WHEN UPPER(LTRIM(RTRIM(ISNULL(a.Appointment_Status,'')))) NOT IN ('CANCELLED','COMPLETED')
                          AND (a.Appointment_Date > CONVERT(date,GETDATE()) OR
                               (a.Appointment_Date=CONVERT(date,GETDATE()) AND TRY_CONVERT(time,a.EndTime)>CONVERT(time,GETDATE())))
                    THEN 1 ELSE 0 END),0) AS Upcoming
FROM dbo.Patient p LEFT JOIN dbo.Appointment a ON a.Patient_ID=p.PatientID
WHERE p.UserId=@UserId";
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value = userId;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblTotal.Text = Convert.ToString(reader["Total"]);
                        lblCompleted.Text = Convert.ToString(reader["Completed"]);
                        lblCancelled.Text = Convert.ToString(reader["Cancelled"]);
                        lblUpcoming.Text = Convert.ToString(reader["Upcoming"]);
                    }
                }
            }

            const string nextSql = @"
SELECT TOP (1) a.Appointment_Date, a.StartTime, a.EndTime,
       COALESCE(d.FullName,'Doctor to be confirmed') AS DoctorName
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON a.Patient_ID=p.PatientID
LEFT JOIN dbo.Doctor d ON a.Doctor_ID=d.DoctorID
WHERE p.UserId=@UserId
  AND UPPER(LTRIM(RTRIM(ISNULL(a.Appointment_Status,'')))) NOT IN ('CANCELLED','COMPLETED')
  AND (a.Appointment_Date>CONVERT(date,GETDATE()) OR
       (a.Appointment_Date=CONVERT(date,GETDATE()) AND TRY_CONVERT(time,a.EndTime)>CONVERT(time,GETDATE())))
ORDER BY a.Appointment_Date, TRY_CONVERT(time,a.StartTime), a.Appointment_ID";
            lblNextAppointment.Text = "No upcoming appointment scheduled.";
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(nextSql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value = userId;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return;
                    string date = Convert.ToDateTime(reader["Appointment_Date"]).ToString("dddd, dd MMMM yyyy");
                    string start = HttpUtility.HtmlEncode(Convert.ToString(reader["StartTime"]));
                    string end = HttpUtility.HtmlEncode(Convert.ToString(reader["EndTime"]));
                    string doctor = HttpUtility.HtmlEncode(Convert.ToString(reader["DoctorName"]));
                    lblNextAppointment.Text = "<strong>" + HttpUtility.HtmlEncode(date) + "</strong>" +
                        "<small>" + start + " - " + end + " | " + doctor + "</small>";
                }
            }
        }
    }
}
