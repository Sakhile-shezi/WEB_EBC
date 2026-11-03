
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using WebApplication1.Models;

namespace WebApplication1
{
    public partial class InitialAdminSetup : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // This temporary page is only available locally.
            if (!Request.IsLocal)
            {
                Response.StatusCode = 404;
                Response.SuppressContent = true;
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            CheckAdministratorExists();
        }


        private bool CheckAdministratorExists()
        {
            var manager = Context.GetOwinContext()
                .GetUserManager<ApplicationUserManager>();

            // Check whether any existing user has the Admin role.
            bool adminExists = manager.Users
                .ToList()
                .Any(user => manager.IsInRole(user.Id, "Admin"));

            if (adminExists)
            {
                pnlSetup.Visible = false;
                lblStatus.Text =
                    "An Administrator account already exists. Setup is disabled.";

                return true;
            }

            return false;
        }

        protected void btnCreateAdmin_Click(object sender, EventArgs e)
        {
            // Check again when the button is clicked.
            if (!Request.IsLocal || CheckAdministratorExists())
                return;

            if (string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                lblStatus.Text = "Please complete all fields.";
                return;
            }

            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                lblStatus.Text = "Passwords do not match.";
                return;
            }

            var manager = Context.GetOwinContext()
                .GetUserManager<ApplicationUserManager>();

            var user = new ApplicationUser
            {
                UserName = txtEmail.Text.Trim(),
                Email = txtEmail.Text.Trim()
            };

            // Create the administrator account.
            IdentityResult result = manager.Create(
                user,
                txtPassword.Text
            );

            if (!result.Succeeded)
            {
                lblStatus.Text = string.Join("<br/>", result.Errors);
                return;
            }

            // Assign the Admin role.
            IdentityResult roleResult =
                manager.AddToRole(user.Id, "Admin");

            if (!roleResult.Succeeded)
            {
                // Remove the account if role assignment fails.
                manager.Delete(user);

                lblStatus.Text =
                    "Could not assign the Admin role: " +
                    string.Join(", ", roleResult.Errors);

                return;
            }

            pnlSetup.Visible = false;

            lblStatus.ForeColor =
                System.Drawing.Color.Green;

            lblStatus.Text =
                "Administrator account created successfully! " +
                "You can now log in.";
        }
    }
}
