using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;

namespace WebApplication1.Private.Doctor
{
    public partial class Profile : System.Web.UI.Page
    {
        private string ConnString => ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private string CurrentDoctorId
        {
            get => ViewState["CurrentDoctorId"]?.ToString();
            set => ViewState["CurrentDoctorId"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfileFromDatabase();
            }
        }

        private void LoadProfileFromDatabase()
        {
            string email = User.Identity.GetUserName() ?? "";
            string userId = User.Identity.GetUserId() ?? "";
            string fullName = "";
            string phone = "";
            string department = "Outpatients & Clinical Care";
            string room = "Room 1 — Chronic Care Unit";
            string queueStatus = "Available";

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();

                // Read phone & email from AspNetUsers
                using (SqlCommand uCmd = new SqlCommand(
                    "SELECT TOP 1 Email, PhoneNumber FROM [dbo].[AspNetUsers] WHERE Id = @UserId OR Email = @Email", conn))
                {
                    uCmd.Parameters.AddWithValue("@UserId", userId);
                    uCmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataReader ur = uCmd.ExecuteReader())
                    {
                        if (ur.Read())
                        {
                            if (ur["Email"] != DBNull.Value && !string.IsNullOrWhiteSpace(ur["Email"].ToString()))
                                email = ur["Email"].ToString().Trim();
                            if (ur["PhoneNumber"] != DBNull.Value && !string.IsNullOrWhiteSpace(ur["PhoneNumber"].ToString()))
                                phone = ur["PhoneNumber"].ToString().Trim();
                        }
                    }
                }

                // Read clinician record from dbo.Doctor
                string docTable = ResolveExistingTable(conn, "Doctor", "Doctors");
                if (docTable != null)
                {
                    EnsureDoctorProfileColumns(conn, docTable);
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
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@UserId", userId);

                            using (SqlDataReader r = cmd.ExecuteReader())
                            {
                                if (r.Read())
                                {
                                    string idCol = FindColumn(cols, "DoctorID", "Doctor_ID", "Id");
                                    if (idCol != null && r[idCol] != DBNull.Value)
                                    {
                                        CurrentDoctorId = r[idCol].ToString();
                                    }

                                    string fName = ReadFirstAvailable(r, cols, "FullName", "DoctorName", "Name");
                                    if (!string.IsNullOrWhiteSpace(fName))
                                    {
                                        fullName = fName;
                                    }
                                    else
                                    {
                                        string first = ReadFirstAvailable(r, cols, "FirstName", "DoctorFirstName", "FName");
                                        string last = ReadFirstAvailable(r, cols, "LastName", "Surname", "DoctorLastName", "LName");
                                        fullName = $"{first} {last}".Trim();
                                    }

                                    string docPhone = ReadFirstAvailable(r, cols, "PhoneNumber", "ContactNumber", "Phone", "CellNumber", "Telephone");
                                    if (!string.IsNullOrWhiteSpace(docPhone))
                                        phone = docPhone;

                                    string docDept = ReadFirstAvailable(r, cols, "Department", "Specialization", "Specialty", "Unit");
                                    if (!string.IsNullOrWhiteSpace(docDept))
                                        department = docDept;

                                    string docRoom = ReadFirstAvailable(r, cols, "ConsultationRoom", "Room");
                                    if (!string.IsNullOrWhiteSpace(docRoom))
                                        room = docRoom;

                                    string docStatus = ReadFirstAvailable(r, cols, "QueueStatus", "AvailabilityStatus", "Status");
                                    if (!string.IsNullOrWhiteSpace(docStatus))
                                        queueStatus = docStatus;
                                }
                            }
                        }
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(fullName))
            {
                fullName = FormatDoctorNameFromEmail(email);
            }
            else if (!fullName.StartsWith("Dr", StringComparison.OrdinalIgnoreCase))
            {
                fullName = "Dr. " + fullName;
            }

            // Populate UI controls
            litDoctorFullName.Text = Server.HtmlEncode(fullName);
            litInitials.Text = ExtractInitials(fullName);
            litDepartment.Text = Server.HtmlEncode(department);

            string idDisplay = !string.IsNullOrWhiteSpace(CurrentDoctorId) ? $"DOC-{CurrentDoctorId}" : "Active Account";
            litHeroDoctorId.Text = Server.HtmlEncode(idDisplay);
            litSpecDoctorId.Text = Server.HtmlEncode(idDisplay);

            txtOfficialEmail.Text = email;
            txtContactNumber.Text = phone;

            if (ddlConsultationRoom.Items.FindByValue(room) != null)
                ddlConsultationRoom.SelectedValue = room;

            if (ddlQueueStatus.Items.FindByValue(queueStatus) != null)
                ddlQueueStatus.SelectedValue = queueStatus;

            UpdateLiveStatusDisplay(room, queueStatus);
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string phone = (txtContactNumber.Text ?? "").Trim();
            string room = ddlConsultationRoom.SelectedValue;
            string queueStatus = ddlQueueStatus.SelectedValue;
            string email = User.Identity.GetUserName() ?? "";
            string userId = User.Identity.GetUserId() ?? "";

            if (string.IsNullOrWhiteSpace(phone))
            {
                ShowAlert(pnlProfileAlert, litProfileAlert, "Please enter a valid contact number before saving.", false);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnString))
                {
                    conn.Open();

                    // 1. Update AspNetUsers.PhoneNumber
                    using (SqlCommand uCmd = new SqlCommand(
                        "UPDATE [dbo].[AspNetUsers] SET PhoneNumber = @Phone WHERE Id = @UserId OR Email = @Email", conn))
                    {
                        uCmd.Parameters.AddWithValue("@Phone", phone);
                        uCmd.Parameters.AddWithValue("@UserId", userId);
                        uCmd.Parameters.AddWithValue("@Email", email);
                        uCmd.ExecuteNonQuery();
                    }

                    // 2. Update dbo.Doctor (Phone, ConsultationRoom, QueueStatus)
                    string docTable = ResolveExistingTable(conn, "Doctor", "Doctors");
                    if (docTable != null)
                    {
                        EnsureDoctorProfileColumns(conn, docTable);
                        HashSet<string> cols = GetTableColumns(conn, docTable);

                        List<string> sets = new List<string>();
                        string phoneCol = FindColumn(cols, "PhoneNumber", "ContactNumber", "Phone", "CellNumber", "Telephone");
                        if (phoneCol != null) sets.Add($"[{phoneCol}] = @Phone");
                        if (cols.Contains("ConsultationRoom")) sets.Add("[ConsultationRoom] = @Room");
                        if (cols.Contains("QueueStatus")) sets.Add("[QueueStatus] = @QueueStatus");

                        string idCol = FindColumn(cols, "DoctorID", "Doctor_ID", "Id");
                        List<string> where = new List<string>();
                        if (idCol != null && !string.IsNullOrWhiteSpace(CurrentDoctorId))
                            where.Add($"[{idCol}] = @DoctorID");
                        else
                        {
                            if (cols.Contains("Email")) where.Add("[Email] = @Email");
                            if (cols.Contains("UserId")) where.Add("[UserId] = @UserId");
                            if (cols.Contains("AspNetUserId")) where.Add("[AspNetUserId] = @UserId");
                        }

                        if (sets.Count > 0 && where.Count > 0)
                        {
                            string updateSql = $"UPDATE [dbo].[{docTable}] SET {string.Join(", ", sets)} WHERE {string.Join(" OR ", where)}";
                            using (SqlCommand dCmd = new SqlCommand(updateSql, conn))
                            {
                                dCmd.Parameters.AddWithValue("@Phone", phone);
                                dCmd.Parameters.AddWithValue("@Room", room);
                                dCmd.Parameters.AddWithValue("@QueueStatus", queueStatus);
                                dCmd.Parameters.AddWithValue("@DoctorID", CurrentDoctorId ?? "");
                                dCmd.Parameters.AddWithValue("@Email", email);
                                dCmd.Parameters.AddWithValue("@UserId", userId);
                                dCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                UpdateLiveStatusDisplay(room, queueStatus);
                ShowAlert(pnlProfileAlert, litProfileAlert, "Profile changes, consultation room, and queue status saved to the database.", true);
            }
            catch (Exception ex)
            {
                ShowAlert(pnlProfileAlert, litProfileAlert, "Unable to save profile changes: " + ex.Message, false);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string currentPwd = txtCurrentPassword.Text;
            string newPwd = txtNewPassword.Text;
            string confirmPwd = txtConfirmPassword.Text;

            if (string.IsNullOrWhiteSpace(currentPwd) || string.IsNullOrWhiteSpace(newPwd))
            {
                ShowAlert(pnlPasswordAlert, litPasswordAlert, "Please enter both your current password and a new password.", false);
                return;
            }

            if (newPwd != confirmPwd)
            {
                ShowAlert(pnlPasswordAlert, litPasswordAlert, "New password and confirmation password do not match.", false);
                return;
            }

            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            if (manager == null)
            {
                ShowAlert(pnlPasswordAlert, litPasswordAlert, "Authentication service unavailable.", false);
                return;
            }

            IdentityResult result = manager.ChangePassword(User.Identity.GetUserId(), currentPwd, newPwd);
            if (result.Succeeded)
            {
                var user = manager.FindById(User.Identity.GetUserId());
                if (user != null)
                {
                    var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
                    signInManager?.SignIn(user, isPersistent: false, rememberBrowser: false);
                }

                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
                ShowAlert(pnlPasswordAlert, litPasswordAlert, "Password updated successfully.", true);
            }
            else
            {
                ShowAlert(pnlPasswordAlert, litPasswordAlert, string.Join(" ", result.Errors), false);
            }
        }

        /// <summary>
        /// Ensures ConsultationRoom and QueueStatus columns exist on dbo.Doctor so settings persist in SQL Server.
        /// </summary>
        private void EnsureDoctorProfileColumns(SqlConnection conn, string docTable)
        {
            try
            {
                HashSet<string> cols = GetTableColumns(conn, docTable);
                if (!cols.Contains("ConsultationRoom"))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        $"ALTER TABLE [dbo].[{docTable}] ADD [ConsultationRoom] NVARCHAR(100) NULL", conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
                if (!cols.Contains("QueueStatus"))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        $"ALTER TABLE [dbo].[{docTable}] ADD [QueueStatus] NVARCHAR(50) NULL", conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Ignored if columns already exist or DDL permissions are restricted
            }
        }

        private void UpdateLiveStatusDisplay(string room, string queueStatus)
        {
            litHeroRoom.Text = Server.HtmlEncode(room);
            litSpecRoom.Text = Server.HtmlEncode(room);
            litHeroQueueStatus.Text = Server.HtmlEncode(queueStatus);

            if (queueStatus.Equals("Available", StringComparison.OrdinalIgnoreCase))
                spanStatusDot.Attributes["class"] = "status-dot dot-available";
            else if (queueStatus.Equals("In Consultation", StringComparison.OrdinalIgnoreCase))
                spanStatusDot.Attributes["class"] = "status-dot dot-busy";
            else
                spanStatusDot.Attributes["class"] = "status-dot dot-away";
        }

        private void ShowAlert(System.Web.UI.WebControls.Panel panel, System.Web.UI.WebControls.Literal literal, string message, bool isSuccess)
        {
            panel.Visible = true;
            panel.CssClass = isSuccess ? "alert-banner alert-success" : "alert-banner alert-error";
            literal.Text = Server.HtmlEncode(message);
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

        private string ExtractInitials(string fullName)
        {
            string cleaned = fullName.Replace("Dr.", "").Replace("Dr", "").Trim();
            string[] parts = cleaned.Split(new[] { ' ', '.' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2)
                return $"{char.ToUpper(parts[0][0])}{char.ToUpper(parts[parts.Length - 1][0])}";
            if (parts.Length == 1 && parts[0].Length >= 2)
                return parts[0].Substring(0, 2).ToUpper();
            return "DR";
        }
    }
}