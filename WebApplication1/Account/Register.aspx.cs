using System;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using WebApplication1.Models;

namespace WebApplication1.Account
{
    public partial class Register : Page
    {
        protected void CreateUser_Click(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();

            var user = new ApplicationUser()
            {
                UserName = Email.Text.Trim(),
                Email = Email.Text.Trim(),

                // Automatically save details entered during registration.
                PhoneNumber = TBContactNo.Text.Trim()
            };

            IdentityResult result = manager.Create(user, Password.Text);
            if (result.Succeeded)
            {
                // For more information on how to enable account confirmation and password reset please visit https://go.microsoft.com/fwlink/?LinkID=320771
                //string code = manager.GenerateEmailConfirmationToken(user.Id);
                //string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                //manager.SendEmail(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                //original code
                //signInManager.SignIn( user, isPersistent: false, rememberBrowser: false);
                //IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);

                // Every publicly registered account receives Patient, never a staff role.
                IdentityResult roleResult = manager.AddToRole(user.Id, "Patient");

                if (roleResult.Succeeded)
                {
                    // The registration name is saved in the existing Identity
                    // claims table, without a new AspNetUsers column/migration.
                    // Do not sign in if this required step fails.
                    IdentityResult claimResult = manager.AddClaim(
                        user.Id,
                        new Claim("registration_full_name", TBFullName.Text.Trim()));

                    if (!claimResult.Succeeded)
                    {
                        manager.Delete(user);
                        ErrorMessage.Text =
                            "Registration could not save your details. Please try again.";
                        return;
                    }

                    // Sign in only after role assignment succeeds.
                    signInManager.SignIn(
                        user,
                        isPersistent: false,
                        rememberBrowser: false
                    );

                    IdentityHelper.RedirectToReturnUrl(
                        Request.QueryString["ReturnUrl"],
                        Response
                    );
                }
                else
                {
                    // Avoid leaving an account that failed role assignment.
                    manager.Delete(user);

                    ErrorMessage.Text =
                        "Registration could not be completed. Please try again or contact the administrator.";
                }
            }
            else 
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
            }
        }
    }
}