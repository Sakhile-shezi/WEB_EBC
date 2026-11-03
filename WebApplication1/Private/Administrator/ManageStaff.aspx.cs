using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Web;
using WebApplication1.Models;

namespace WebApplication1.Private.Administrator
{
    public partial class ManageStaff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Additional server-side authorization check.
            if (!Context.User.Identity.IsAuthenticated ||
                !Context.User.IsInRole("Admin"))
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        protected void btnCreateStaff_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            var manager = Context.GetOwinContext()
                .GetUserManager<ApplicationUserManager>();

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string selectedRole = ddlRole.SelectedValue;

            // Only allow the two staff roles.
            if (selectedRole != "Doctor" && selectedRole != "Nurse")
            {
                lblMessage.Text = "Invalid staff role selected.";
                lblMessage.ForeColor =
                    System.Drawing.Color.Red;
                return;
            }

            // Check whether this email is already registered.
            var existingUser = manager.FindByEmail(email);

            if (existingUser != null)
            {
                lblMessage.Text =
                    "An account with this email already exists.";

                lblMessage.ForeColor =
                    System.Drawing.Color.Red;

                return;
            }

            // Create the new account.
            var user = new ApplicationUser
            {
                UserName = email,
                Email = email
            };

            IdentityResult result = manager.Create(user, password);

            if (!result.Succeeded)
            {
                lblMessage.Text =
                    string.Join(" ", result.Errors);

                lblMessage.ForeColor =
                    System.Drawing.Color.Red;

                return;
            }

            // Assign the selected staff role.
            IdentityResult roleResult =
                manager.AddToRole(user.Id, selectedRole);

            if (!roleResult.Succeeded)
            {
                // Remove the account if role assignment fails.
                manager.Delete(user);

                lblMessage.Text =
                    "Account creation failed during role assignment: " +
                    string.Join(" ", roleResult.Errors);

                lblMessage.ForeColor =
                    System.Drawing.Color.Red;

                return;
            }

            // Successful registration.
            lblMessage.Text =
                "Staff account created successfully! Role assigned: " +
                selectedRole;

            lblMessage.ForeColor =
                System.Drawing.Color.Green;

            // Clear the form.
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlRole.SelectedIndex = 0;
        }
    }
}
