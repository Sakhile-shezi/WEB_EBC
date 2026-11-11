using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //   if (Context.User.Identity.IsAuthenticated) {
            //      Menu1.Visible = true;
            //  }

            // Hide all role-specific navigation by default.
            patientDashboardNav.Visible = false;

            nurseDashboardNav.Visible = false;
            nurseMedicationNav.Visible = false;
            nurseProfileNav.Visible = false;

            doctorDashboardNav.Visible = false;
            doctorPrescriptionNav.Visible = false;
            doctorProfileNav.Visible = false;

            adminDashboardNav.Visible = false;
            adminMedicineNav.Visible = false;
            adminManageStaffNav.Visible = false;


            // Only display role-specific links to authenticated users.
            if (!Context.User.Identity.IsAuthenticated)
                return;


            // PATIENT
            if (Context.User.IsInRole("Patient"))
            {
                patientDashboardNav.Visible = true;
            }


            // NURSE
            if (Context.User.IsInRole("Nurse"))
            {
                nurseDashboardNav.Visible = true;
                nurseMedicationNav.Visible = true;
                nurseProfileNav.Visible = true;
            }


            // DOCTOR
            if (Context.User.IsInRole("Doctor"))
            {
                doctorDashboardNav.Visible = true;
                doctorPrescriptionNav.Visible = true;
                doctorProfileNav.Visible = true;
            }


            // ADMINISTRATOR
            if (Context.User.IsInRole("Admin"))
            {
                adminDashboardNav.Visible = true;
                adminMedicineNav.Visible = true;
                adminManageStaffNav.Visible = true;
            }
        }

        protected void Unnamed_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
        }
    }

}