using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using WebApplication1.Models;

namespace WebApplication1.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register";
            // Enable this once you have account confirmation enabled for password reset functionality
            //ForgotPasswordHyperLink.NavigateUrl = "Forgot";
            OpenAuthLogin.ReturnUrl = Request.QueryString["ReturnUrl"];
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
            if (!String.IsNullOrEmpty(returnUrl))
            {
                RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            }
        }

        protected void LogIn(object sender, EventArgs e)
        {
            //if (IsValid)
            //{
            //    // Validate the user password
            //    var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            //    var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

            //    // This doen't count login failures towards account lockout
            //    // To enable password failures to trigger lockout, change to shouldLockout: true
            //    var result = signinManager.PasswordSignIn(Email.Text, Password.Text, RememberMe.Checked, shouldLockout: false);

            //    switch (result)
            //    {
            //        case SignInStatus.Success:
            //            IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
            //            break;
            //        case SignInStatus.LockedOut:
            //            Response.Redirect("/Account/Lockout");
            //            break;
            //        case SignInStatus.RequiresVerification:
            //            Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}", 
            //                                            Request.QueryString["ReturnUrl"],
            //                                            RememberMe.Checked),
            //                              true);
            //            break;
            //        case SignInStatus.Failure:
            //        default:
            //            FailureText.Text = "Invalid login attempt";
            //            ErrorMessage.Visible = true;
            //            break;
            //    }
            //}

            if (IsValid)
            {
                var manager = Context.GetOwinContext()
                    .GetUserManager<ApplicationUserManager>();

                var signinManager = Context.GetOwinContext()
                    .GetUserManager<ApplicationSignInManager>();

                // Validate the user's credentials.
                var result = signinManager.PasswordSignIn(
                    Email.Text,
                    Password.Text,
                    RememberMe.Checked,
                    shouldLockout: false
                );

                switch (result)
                {
                    case SignInStatus.Success:

                        // Retrieve the authenticated user's account.
                        var user = manager.FindByName(Email.Text);

                        if (user == null)
                        {
                            Context.GetOwinContext().Authentication.SignOut(
                                DefaultAuthenticationTypes.ApplicationCookie);

                            FailureText.Text = "Unable to retrieve your account.";
                            ErrorMessage.Visible = true;
                            return;
                        }

                        // Retrieve the roles assigned to this user.
                        var roles = manager.GetRoles(user.Id);

                        // This application expects each account to have one role.
                        if (roles.Count != 1)
                        {
                            Context.GetOwinContext().Authentication.SignOut(
                                DefaultAuthenticationTypes.ApplicationCookie);

                            FailureText.Text =
                                "Your account does not have a valid role. Please contact the administrator.";

                            ErrorMessage.Visible = true;
                            return;
                        }

                        // Redirect according to the assigned role.
                        switch (roles[0])
                        {
                            case "Patient":
                                Response.Redirect("~/Private/Patient/WebForm1.aspx", false);
                                break;

                            case "Doctor":
                                Response.Redirect("~/Private/Doctor/WebForm1.aspx", false);
                                break;

                            case "Nurse":
                                Response.Redirect("~/Private/Nurse/WebForm1.aspx", false);
                                break;

                            case "Admin":
                                Response.Redirect("~/Private/Administrator/WebForm1.aspx", false);
                                break;

                            default:
                                Context.GetOwinContext().Authentication.SignOut(
                                    DefaultAuthenticationTypes.ApplicationCookie);

                                FailureText.Text =
                                    "Your account has an unrecognized role. Please contact the administrator.";

                                ErrorMessage.Visible = true;
                                return;
                        }

                        Context.ApplicationInstance.CompleteRequest();
                        break;

                    case SignInStatus.LockedOut:
                        Response.Redirect("~/Account/Lockout");
                        break;

                    case SignInStatus.RequiresVerification:
                        Response.Redirect(
                            String.Format(
                                "~/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]),
                                RememberMe.Checked
                            )
                        );
                        break;

                    case SignInStatus.Failure:
                    default:
                        FailureText.Text = "Invalid login attempt.";
                        ErrorMessage.Visible = true;
                        break;
                }
            }
        }

    }
}