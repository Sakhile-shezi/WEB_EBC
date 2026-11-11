
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using WebApplication1.Models;

namespace WebApplication1.Private.Administrator
{
    public partial class ManageStaff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Administrator authorization check.
            if (!Context.User.Identity.IsAuthenticated ||
                !Context.User.IsInRole("Admin"))
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Configure the dropdown query for the selected role.
            ConfigureClinicRecords();

            if (!IsPostBack)
            {
                ddlClinicRecord.DataBind();
            }
        }

        private void ConfigureClinicRecords()
        {
            if (ddlRole.SelectedValue == "Doctor")
            {
                sqlClinicRecords.SelectCommand = @"
                    SELECT DoctorID AS RecordID, FullName
                    FROM dbo.Doctor
                    WHERE UserId IS NULL
                    ORDER BY FullName";
            }
            else if (ddlRole.SelectedValue == "Nurse")
            {
                sqlClinicRecords.SelectCommand = @"
                    SELECT NurseID AS RecordID, FullName
                    FROM dbo.Nurse
                    WHERE UserId IS NULL
                    ORDER BY FullName";
            }
        }

        protected void ddlRole_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            ConfigureClinicRecords();

            ddlClinicRecord.DataBind();

            lblMessage.Text = "";
        }

        protected void btnCreateStaff_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string selectedRole = ddlRole.SelectedValue;
            string recordId = ddlClinicRecord.SelectedValue;

            // Only allow Doctor or Nurse.
            if (selectedRole != "Doctor" &&
                selectedRole != "Nurse")
            {
                ShowMessage("Invalid staff role selected.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(recordId))
            {
                ShowMessage("Please select a clinic record.", false);
                return;
            }

            var manager = Context.GetOwinContext()
                .GetUserManager<ApplicationUserManager>();

            // Check whether email already exists.
            var existingUser = manager.FindByEmail(email);

            if (existingUser != null)
            {
                ShowMessage(
                    "An account with this email already exists.",
                    false);
                return;
            }

            // Create the Identity account.
            var user = new ApplicationUser
            {
                UserName = email,
                Email = email
            };

            IdentityResult result = manager.Create(user, password);

            if (!result.Succeeded)
            {
                ShowMessage(string.Join(" ", result.Errors), false);
                return;
            }

            // Assign the role.
            IdentityResult roleResult =
                manager.AddToRole(user.Id, selectedRole);

            if (!roleResult.Succeeded)
            {
                manager.Delete(user);

                ShowMessage(
                    "Role assignment failed: " +
                    string.Join(" ", roleResult.Errors),
                    false);

                return;
            }

            // Link the Identity account to the clinic record.
            try
            {
                int rowsAffected = LinkClinicRecord(
                    selectedRole,
                    recordId,
                    user.Id);

                if (rowsAffected != 1)
                {
                    // Record was already linked or no longer exists.
                    manager.RemoveFromRole(user.Id, selectedRole);
                    manager.Delete(user);

                    ShowMessage(
                        "The clinic record could not be linked. " +
                        "It may already have an account. " +
                        "The newly created account was removed.",
                        false);

                    return;
                }
            }
            catch (Exception)
            {
                // Remove the newly created Identity account.
                manager.RemoveFromRole(user.Id, selectedRole);
                manager.Delete(user);

                ShowMessage(
                    "An error occurred while linking the clinic record. " +
                    "The newly created account was removed. " +
                    "Please verify the database and try again.",
                    false);

                return;
            }

            // Everything succeeded.
            ShowMessage(
                "Account created and linked successfully! Role: " +
                selectedRole,
                true);

            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";

            ConfigureClinicRecords();
            ddlClinicRecord.DataBind();
        }

        private int LinkClinicRecord(
            string role,
            string recordId,
            string userId)
        {
            string connectionString =
                ConfigurationManager
                    .ConnectionStrings["DefaultConnection"]
                    .ConnectionString;

            string query;

            // Choose a fixed SQL statement based on the role.
            // Never insert user-provided table names into SQL.
            if (role == "Doctor")
            {
                query = @"
                    UPDATE dbo.Doctor
                    SET UserId = @UserId
                    WHERE DoctorID = @RecordID
                      AND UserId IS NULL";
            }
            else if (role == "Nurse")
            {
                query = @"
                    UPDATE dbo.Nurse
                    SET UserId = @UserId
                    WHERE NurseID = @RecordID
                      AND UserId IS NULL";
            }
            else
            {
                throw new InvalidOperationException(
                    "Invalid role.");
            }

            using (SqlConnection connection =
                new SqlConnection(connectionString))
            {
                using (SqlCommand command =
                    new SqlCommand(query, connection))
                {
                    command.Parameters.Add(
                        "@UserId", SqlDbType.NVarChar, 128)
                        .Value = userId;

                    command.Parameters.Add(
                        "@RecordID", SqlDbType.Int)
                        .Value = Convert.ToInt32(recordId);

                    connection.Open();

                    return command.ExecuteNonQuery();
                }
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = message;

            lblMessage.ForeColor = success
                ? System.Drawing.Color.Green
                : System.Drawing.Color.Red;
        }
    }
}

