
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Models;

namespace WebApplication1.Private.Appointments
{
    public partial class CompleteProfile : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "GroupPmb6ConnectionString"
                ].ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Do not overwrite user edits or form values on a postback.
            if (!IsPostBack)
            {
                txtEmail.Text = User.Identity.Name;

                string userId = User.Identity.GetUserId();
                if (!string.IsNullOrWhiteSpace(userId))
                {
                    var manager = Context.GetOwinContext()
                        .GetUserManager<ApplicationUserManager>();
                    var registeredUser = manager.FindById(userId);
                    if (registeredUser != null)
                    {
                        txtEmail.Text = registeredUser.Email;
                        txtPhone.Text = registeredUser.PhoneNumber ?? "";

                        // Existing AspNetUserClaims table stores the name.
                        var nameClaim = manager.GetClaims(userId)
                            .FirstOrDefault(c => c.Type == "registration_full_name");
                        if (nameClaim != null)
                            txtFullName.Text = nameClaim.Value;
                    }
                }

                // A previously completed Patient profile takes precedence.
                LoadExistingProfile();
            }
        }

        private void LoadExistingProfile()
        {
            string userId = User.Identity.GetUserId();

            if (string.IsNullOrWhiteSpace(userId))
                return;

            const string sql = @"
                SELECT *
                FROM dbo.Patient
                WHERE UserId = @UserId";

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.Add(
                    "@UserId", SqlDbType.NVarChar, 128)
                    .Value = userId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                        return;

                    txtFullName.Text =
                        reader["FullName"].ToString();

                    if (reader["DateOfBirth"] != DBNull.Value)
                    {
                        txtDateOfBirth.Text =
                            Convert.ToDateTime(reader["DateOfBirth"])
                            .ToString("yyyy-MM-dd");
                    }

                    txtPhone.Text =
                        reader["PhoneNumber"].ToString();

                    txtAlternativePhone.Text =
                        reader["AlternativePhoneNumber"].ToString();

                    txtAddress.Text =
                        reader["Address"].ToString();

                    txtIDNumber.Text =
                        reader["IdNumber"].ToString();

                    txtLanguage.Text =
                        reader["Language"].ToString().Trim();

                    txtReligion.Text =
                        reader["Religion"].ToString().Trim();

                    txtNextOfKin.Text =
                        reader["NextOfKinName"].ToString().Trim();

                    txtNextOfKinCell.Text =
                        reader["NextOfKinCellNumber"].ToString();

                    SetDropdownValue(
                        ddlGender,
                        reader["gender"].ToString().Trim());

                    SetDropdownValue(
                        ddlMaritalStatus,
                        reader["MaritalStatus"].ToString().Trim());
                }
            }
        }

        private void SetDropdownValue(
            System.Web.UI.WebControls.DropDownList dropdown,
            string value)
        {
            var item = dropdown.Items.FindByValue(value);

            if (item != null)
            {
                dropdown.ClearSelection();
                item.Selected = true;
            }
        }

        private object OptionalValue(string value)
        {
            return string.IsNullOrWhiteSpace(value)
                ? (object)DBNull.Value
                : value.Trim();
        }

        public void btnSaveProfile_Click(
            object sender, EventArgs e)
        {

            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string userId = User.Identity.GetUserId();
            string email = User.Identity.Name;

            if (string.IsNullOrWhiteSpace(userId) ||
                string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text =
                    "Please log in to complete your profile.";
                return;
            }

            DateTime dateOfBirth;

            if (!DateTime.TryParseExact(
                txtDateOfBirth.Text.Trim(),
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out dateOfBirth))
            {
                lblMessage.Text = "Please enter a valid date of birth.";
                return;
            }

            if (dateOfBirth > DateTime.Today ||
                dateOfBirth.Year < 1900)
            {
                lblMessage.Text = "Invalid date of birth.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtFullName.Text) ||
                string.IsNullOrWhiteSpace(txtPhone.Text) ||
                string.IsNullOrWhiteSpace(txtAddress.Text) ||
                string.IsNullOrWhiteSpace(ddlGender.SelectedValue))
            {
                lblMessage.Text =
                    "Please complete all required fields.";
                return;
            }

            // Enforce the Patient table's actual varchar/nchar column limits.
            if (txtFullName.Text.Trim().Length > 50 ||
                email.Length > 70 ||
                txtPhone.Text.Trim().Length > 20 ||
                txtAlternativePhone.Text.Trim().Length > 20 ||
                txtAddress.Text.Trim().Length > 60 ||
                txtIDNumber.Text.Trim().Length > 50 ||
                txtLanguage.Text.Trim().Length > 50 ||
                txtReligion.Text.Trim().Length > 50 ||
                txtNextOfKin.Text.Trim().Length > 50 ||
                txtNextOfKinCell.Text.Trim().Length > 50 ||
                ddlGender.SelectedValue.Length > 10 ||
                ddlMaritalStatus.SelectedValue.Length > 50)
            {
                lblMessage.Text = "One or more entries are too long.";
                return;
            }



            try
            {
                bool patientExists;
                bool emailConflict;

                // Check whether the registered account
                // already has a Patient profile.
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(@"
        SELECT
            CASE WHEN EXISTS (
                SELECT 1 FROM dbo.Patient
                WHERE UserId = @UserId
            ) THEN 1 ELSE 0 END AS PatientExists,

            CASE WHEN EXISTS (
                SELECT 1 FROM dbo.Patient
                WHERE EmailAddress = @Email
                  AND (UserId IS NULL OR UserId <> @UserId)
            ) THEN 1 ELSE 0 END AS EmailConflict",
                    con))
                {
                    cmd.Parameters.Add(
                        "@UserId", SqlDbType.NVarChar, 128).Value = userId;

                    cmd.Parameters.Add(
                        "@Email", SqlDbType.VarChar, 70).Value = email;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        reader.Read();

                        patientExists =
                            Convert.ToInt32(reader["PatientExists"]) == 1;

                        emailConflict =
                            Convert.ToInt32(reader["EmailConflict"]) == 1;
                    }
                }

                if (emailConflict)
                {
                    lblMessage.Text =
                        "An existing patient record uses this email. " +
                        "Please contact the clinic to link your account.";
                    return;
                }

                // Supply the values required by the datasource.
                if (patientExists)
                {
                    SetProfileParameters(
                        SqlDataSourcePatientProfile.UpdateParameters,
                        userId, email, dateOfBirth);

                    int rowsAffected = SqlDataSourcePatientProfile.Update();

                    if (rowsAffected <= 0)
                    {
                        lblMessage.Text =
                            "No patient record was updated. Please try again.";
                        return;
                    }
                }
                else
                {
                    SetProfileParameters(
                        SqlDataSourcePatientProfile.InsertParameters,
                        userId, email, dateOfBirth);

                    SqlDataSourcePatientProfile.Insert();
                }

                // Redirect after a successful database operation.
                Response.Redirect(
                    "~/Private/Appointments/Appointments.aspx",
                    false);

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Trace.TraceError(
                    "Patient profile save failed: " + ex);

                // Show only a generic error to website users.
                lblMessage.Text =
                    "Unable to save your profile. " +
                    "Please contact the clinic if the problem continues.";
            }
        }


        private void SetProfileParameters(
            ParameterCollection parameters,
            string userId,
            string email,
            DateTime dateOfBirth)
        {
            parameters["UserId"].DefaultValue = userId;
            parameters["Email"].DefaultValue = email;
            parameters["FullName"].DefaultValue =
                txtFullName.Text.Trim();

            parameters["DateOfBirth"].DefaultValue =
                dateOfBirth.ToString("yyyy-MM-dd",
                    CultureInfo.InvariantCulture);

            parameters["PhoneNumber"].DefaultValue =
                txtPhone.Text.Trim();

            parameters["Address"].DefaultValue =
                txtAddress.Text.Trim();

            parameters["AltPhone"].DefaultValue =
                txtAlternativePhone.Text.Trim();

            parameters["IdNumber"].DefaultValue =
                txtIDNumber.Text.Trim();

            parameters["Gender"].DefaultValue =
                ddlGender.SelectedValue;

            parameters["Language"].DefaultValue =
                txtLanguage.Text.Trim();

            parameters["Religion"].DefaultValue =
                txtReligion.Text.Trim();

            parameters["MaritalStatus"].DefaultValue =
                ddlMaritalStatus.SelectedValue;

            parameters["NextOfKin"].DefaultValue =
                txtNextOfKin.Text.Trim();

            parameters["NextOfKinCell"].DefaultValue =
                txtNextOfKinCell.Text.Trim();
        }

    }
}
