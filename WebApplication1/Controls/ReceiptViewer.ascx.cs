using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Web;
using System.Web.UI;
using WebApplication1.Helperss;

namespace WebApplication1.Controls
{
    // Appointment receipt for the signed-in patient: view, print or email.
    // A page opens it with ReceiptViewer1.Show(appointmentId).
    public partial class ReceiptViewer : UserControl
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "GroupPmb6ConnectionString"].ConnectionString;
            }
        }

        // Reads one appointment of the signed-in patient (never someone else's).
        // A null id returns that patient's most recently created booking.
        private DataRow ReadReceipt(int? appointmentId)
        {
            string userId = Page.User.Identity.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return null;

            const string sql = @"
                SELECT TOP (1) a.AppointmentID, p.FullName AS PatientName,
                       d.FullName AS DoctorName, d.Specialty, n.FullName AS NurseName,
                       a.AppointmentDate, a.TimeSlots, a.AppointmentStatus, a.AppointmentReason
                FROM dbo.Pro_Appointment a
                INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID
                LEFT JOIN dbo.Doctor d ON a.DoctorID = d.DoctorID
                LEFT JOIN dbo.Nurse n ON a.NurseID = n.NurseID
                WHERE p.UserId = @UserId
                  AND (@AppointmentID IS NULL OR a.AppointmentID = @AppointmentID)
                ORDER BY a.AppointmentID DESC";

            var data = new DataTable();
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value = userId;
                cmd.Parameters.Add("@AppointmentID", SqlDbType.Int).Value =
                    appointmentId.HasValue ? (object)appointmentId.Value : DBNull.Value;
                using (var adapter = new SqlDataAdapter(cmd)) adapter.Fill(data);
            }
            return data.Rows.Count > 0 ? data.Rows[0] : null;
        }

        private static string ReceiptText(object value, string fallback)
        {
            string text = value == null || value == DBNull.Value ? "" : value.ToString().Trim();
            return HttpUtility.HtmlEncode(text.Length > 0 ? text : fallback);
        }

        private static string ReceiptLine(string label, string encodedValue)
        {
            return "<tr><td style=\"padding:10px 0;border-bottom:1px solid #e2ebe5;color:#70867a;font-size:13px;width:38%\">" +
                   label + "</td><td style=\"padding:10px 0;border-bottom:1px solid #e2ebe5;color:#244438;font-size:13px;font-weight:bold;text-align:right\">" +
                   encodedValue + "</td></tr>";
        }

        // One receipt layout for the screen, the printout and the email (inline styles only).
        private static string BuildReceiptHtml(DataRow r)
        {
            string date = "Not set";
            if (r["AppointmentDate"] != DBNull.Value)
            {
                DateTime parsed;
                date = DateTime.TryParse(Convert.ToString(r["AppointmentDate"], CultureInfo.InvariantCulture),
                                         CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed)
                    ? parsed.ToString("dddd, d MMMM yyyy", CultureInfo.InvariantCulture)
                    : Convert.ToString(r["AppointmentDate"]);
            }

            string doctor = ReceiptText(r["DoctorName"], "Not assigned");
            string specialty = ReceiptText(r["Specialty"], "");
            if (specialty.Length > 0) doctor += " <span style=\"font-weight:normal;color:#70867a\">(" + specialty + ")</span>";

            return
                "<div style=\"font-family:Segoe UI,Arial,sans-serif;color:#203b35\">" +
                "<div style=\"font-size:11px;font-weight:bold;letter-spacing:1.5px;color:#267455\">EASTBOOM CLINIC</div>" +
                "<div style=\"font-size:22px;font-weight:bold;margin:4px 0 2px\">Appointment receipt</div>" +
                "<div style=\"font-size:12px;color:#6f817b;margin-bottom:14px\">Booking #" + ReceiptText(r["AppointmentID"], "") +
                " &middot; Issued " + DateTime.Now.ToString("d MMM yyyy, HH:mm", CultureInfo.InvariantCulture) + "</div>" +
                "<table style=\"width:100%;border-collapse:collapse\" cellpadding=\"0\" cellspacing=\"0\">" +
                ReceiptLine("Patient", ReceiptText(r["PatientName"], "Not set")) +
                ReceiptLine("Date", HttpUtility.HtmlEncode(date)) +
                ReceiptLine("Time", ReceiptText(r["TimeSlots"], "Not set")) +
                ReceiptLine("Doctor", doctor) +
                ReceiptLine("Nurse", ReceiptText(r["NurseName"], "Not assigned")) +
                ReceiptLine("Reason", ReceiptText(r["AppointmentReason"], "Not given")) +
                ReceiptLine("Status", ReceiptText(r["AppointmentStatus"], "Not set")) +
                "</table>" +
                "<div style=\"font-size:11px;color:#84909c;margin:14px 0 10px\">Please arrive 10 minutes early and bring this receipt " +
                "(printed or on your phone). To change or cancel, contact the clinic reception.</div>" +
                "</div>";
        }

        private ApplicationUserManager UserManager
        {
            get { return Context.GetOwinContext().GetUserManager<ApplicationUserManager>(); }
        }

        // The newest booking of the signed-in patient, or null if there is none.
        public int? LatestAppointmentId()
        {
            DataRow row = ReadReceipt(null);
            return row == null ? (int?)null : Convert.ToInt32(row["AppointmentID"]);
        }

        // Opens the receipt for one appointment.
        // Returns false if it is not one of this patient's appointments.
        public bool Show(int? appointmentId)
        {
            if (!appointmentId.HasValue)
                return false;

            DataRow row = ReadReceipt(appointmentId);
            if (row == null)
                return false;

            ViewState["ReceiptId"] = Convert.ToInt32(row["AppointmentID"]);
            litReceipt.Text = BuildReceiptHtml(row);

            // Tell the patient where the receipt would go, and whether that address is verified.
            string userId = Page.User.Identity.GetUserId();
            var account = UserManager.FindById(userId);
            string email = account == null ? "" : account.Email;
            lblReceiptEmail.Text = string.IsNullOrWhiteSpace(email)
                ? "No email address is saved on your account."
                : "Email goes to " + Server.HtmlEncode(email) +
                  (UserManager.IsEmailConfirmed(userId) ? " (verified)." : " (not verified yet).");

            pnlReceipt.Visible = true;
            return true;
        }

        private void ShowReceiptMessage(string message, bool success)
        {
            lblReceiptMessage.Text = Server.HtmlEncode(message);
            lblReceiptMessage.ForeColor = success ? Color.Green : Color.Red;
        }

        protected void btnCloseReceipt_Click(object sender, EventArgs e)
        {
            pnlReceipt.Visible = false;
        }

        // Emails the receipt to the patient's own account address.
        // The address must be well-formed AND verified (link clicked) before anything is sent to it.
        protected void btnEmailReceipt_Click(object sender, EventArgs e)
        {
            try
            {
                string userId = Page.User.Identity.GetUserId();
                var manager = UserManager;
                var account = string.IsNullOrWhiteSpace(userId) ? null : manager.FindById(userId);
                string email = account == null ? null : account.Email;

                if (!ClinicMailer.IsValidAddress(email))
                {
                    ShowReceiptMessage("Your account does not have a valid email address, so the receipt cannot be emailed.", false);
                    return;
                }

                if (!ClinicMailer.IsConfigured)
                {
                    ShowReceiptMessage("Email is not set up on the site yet. You can still print the receipt.", false);
                    return;
                }

                if (!manager.IsEmailConfirmed(userId))
                {
                    // Not verified: send the verification link instead of the receipt.
                    string code = manager.GenerateEmailConfirmationToken(userId);
                    string link = IdentityHelper.GetUserConfirmationRedirectUrl(code, userId, Request);
                    ClinicMailer.Send(email, "Verify your email - Eastboom Clinic",
                        "<div style=\"font-family:Segoe UI,Arial,sans-serif;color:#203b35;font-size:14px\">" +
                        "<p>Please verify this email address so Eastboom Clinic can send your appointment receipts to it.</p>" +
                        "<p><a href=\"" + HttpUtility.HtmlAttributeEncode(link) + "\" " +
                        "style=\"display:inline-block;background:#1e704f;color:#ffffff;padding:11px 18px;border-radius:8px;text-decoration:none;font-weight:bold\">Verify my email</a></p>" +
                        "<p style=\"color:#6f817b;font-size:12px\">If you did not ask for this, you can ignore this message.</p></div>");
                    lblReceiptEmail.Text = "Email goes to " + Server.HtmlEncode(email) + " (not verified yet).";
                    ShowReceiptMessage("Your email is not verified yet. We sent a verification link to " + email +
                        ". Open it, then press \"Email it to me\" again.", false);
                    return;
                }

                DataRow row = ReadReceipt(ViewState["ReceiptId"] as int?);
                if (ViewState["ReceiptId"] == null || row == null)
                {
                    ShowReceiptMessage("That appointment could not be found.", false);
                    return;
                }

                ClinicMailer.Send(email,
                    "Your Eastboom Clinic appointment receipt (booking #" + row["AppointmentID"] + ")",
                    "<div style=\"max-width:560px;margin:0 auto;padding:22px;border:1px solid #e0e9e4;border-radius:12px\">" +
                    BuildReceiptHtml(row) + "</div>");
                ShowReceiptMessage("Receipt sent to " + email + ".", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Receipt email error: " + ex);
                ShowReceiptMessage(Request.IsLocal
                    ? "Email could not be sent: " + ex.GetBaseException().Message
                    : "The email could not be sent. Please try again later or print the receipt.", false);
            }
        }
    }
}
