
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private
{
    public partial class Treatment : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["GroupPmb6ConnectionString"]
                    .ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login");
                return;
            }

            if (!User.IsInRole("Doctor") && !User.IsInRole("Nurse"))
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                txtPerformedAt.Text =
                    DateTime.Now.ToString("yyyy-MM-ddTHH:mm");

                LoadAppointments();
                LoadTreatments();
                LoadDoctors();
                LoadNurses();
            }
        }


        private void LoadAppointments()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
            SELECT
                A.AppointmentID,
                CAST(A.AppointmentID AS VARCHAR(20))
                + ' | ' + P.FullName
                + ' | ' + A.AppointmentReason
                + ' | ' + CONVERT(VARCHAR(10), A.AppointmentDate, 103)
                + ' | ' + A.AppointmentStatus AS DisplayText
            FROM Pro_Appointment A
            INNER JOIN Patient P
                ON A.PatientID = P.PatientID
            WHERE A.AppointmentStatus IN ('Scheduled', 'Completed')
            ORDER BY A.AppointmentDate DESC;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlAppointment.DataSource = reader;
                        ddlAppointment.DataTextField = "DisplayText";
                        ddlAppointment.DataValueField = "AppointmentID";
                        ddlAppointment.DataBind();
                    }
                }
            }

            ddlAppointment.Items.Insert(0,
                new ListItem("-- Select Appointment --", ""));
        }


        private void LoadTreatments()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT treatmentID, FullName
                    FROM Treatment
                    WHERE isActive = 1
                    ORDER BY FullName;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlTreatment.DataSource = reader;
                        ddlTreatment.DataTextField = "FullName";
                        ddlTreatment.DataValueField = "treatmentID";
                        ddlTreatment.DataBind();
                    }
                }
            }

            ddlTreatment.Items.Insert(0,
                new ListItem("-- Select Treatment --", ""));
        }

        private void LoadDoctors()
        {
            LoadStaffList(
                "SELECT DoctorID, FullName FROM Doctor ORDER BY FullName",
                cblDoctors, "DoctorID");
        }

        private void LoadNurses()
        {
            LoadStaffList(
                "SELECT NurseID, FullName FROM Nurse ORDER BY FullName",
                cblNurses, "NurseID");
        }

        private void LoadStaffList(string query,
            CheckBoxList list, string idColumn)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    list.DataSource = reader;
                    list.DataTextField = "FullName";
                    list.DataValueField = idColumn;
                    list.DataBind();
                }
            }
        }

        protected void ddlTreatment_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            pnlTreatmentInfo.Visible = false;

            if (string.IsNullOrEmpty(ddlTreatment.SelectedValue))
                return;

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT Instructions, RequiresDoctor
                    FROM Treatment
                    WHERE treatmentID = @TreatmentID;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add("@TreatmentID",
                        SqlDbType.Int).Value =
                        Convert.ToInt32(ddlTreatment.SelectedValue);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblInstructions.Text =
                                Server.HtmlEncode(reader["Instructions"].ToString());

                            lblRequiresDoctor.Text =
                                Convert.ToInt32(reader["RequiresDoctor"]) == 1
                                ? "Doctor involvement recommended/required according to treatment information."
                                : "A doctor is not indicated as required in the treatment information.";

                            pnlTreatmentInfo.Visible = true;
                        }
                    }
                }
            }
        }

        private string GetCurrentStaffName()
        {
            string userId = User.Identity.GetUserId();

            if (string.IsNullOrEmpty(userId))
                throw new Exception("Unable to identify the logged-in user.");

            string query;

            if (User.IsInRole("Doctor"))
                query = "SELECT FullName FROM Doctor WHERE UserId = @UserId";
            else if (User.IsInRole("Nurse"))
                query = "SELECT FullName FROM Nurse WHERE UserId = @UserId";
            else
                throw new Exception("Only Doctors and Nurses can record treatment information.");

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128)
                    .Value = userId;

                con.Open();

                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    throw new Exception(
                        "Your account is not linked to a Doctor or Nurse profile.");

                return result.ToString();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            if (string.IsNullOrEmpty(ddlAppointment.SelectedValue) ||
                string.IsNullOrEmpty(ddlTreatment.SelectedValue))
            {
                ShowError("Please select an appointment and treatment.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDiagnosis.Text) ||
                string.IsNullOrWhiteSpace(txtResults.Text))
            {
                ShowError("Please provide the diagnosis and treatment results.");
                return;
            }

            bool doctorSelected = false;
            bool nurseSelected = false;

            foreach (ListItem item in cblDoctors.Items)
                if (item.Selected) doctorSelected = true;

            foreach (ListItem item in cblNurses.Items)
                if (item.Selected) nurseSelected = true;

            if (!doctorSelected && !nurseSelected)
            {
                ShowError("Please select at least one participating staff member.");
                return;
            }

            DateTime performedAt;

            if (!DateTime.TryParse(txtPerformedAt.Text, out performedAt))
            {
                ShowError("Please enter a valid treatment date and time.");
                return;
            }

            try
            {
                string performedBy = GetCurrentStaffName();

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            string insertTreatment = @"
    INSERT INTO TreatmentInformation
    (appointmentID, treatmentID, perfomed_at,
     results, diagnosis, notes, perfomedBy)
    OUTPUT INSERTED.treatmentInformationID
    VALUES
    (@AppointmentID, @TreatmentID, @PerformedAt,
     @Results, @Diagnosis, @Notes, @PerformedBy);";

                            int treatmentInformationId;

                            using (SqlCommand cmd = new SqlCommand(
                                insertTreatment, con, transaction))
                            {
                                cmd.Parameters.Add("@AppointmentID",
                                    SqlDbType.Int).Value =
                                    Convert.ToInt32(ddlAppointment.SelectedValue);

                                cmd.Parameters.Add("@TreatmentID",
                                    SqlDbType.Int).Value =
                                    Convert.ToInt32(ddlTreatment.SelectedValue);

                                cmd.Parameters.Add("@PerformedAt",
                                    SqlDbType.SmallDateTime).Value = performedAt;

                                cmd.Parameters.Add("@Results",
                                    SqlDbType.VarChar, 500).Value =
                                    txtResults.Text.Trim();

                                cmd.Parameters.Add("@Diagnosis",
                                    SqlDbType.VarChar, 255).Value =
                                    txtDiagnosis.Text.Trim();

                                cmd.Parameters.Add("@Notes",SqlDbType.VarChar, 500).Value = txtNotes.Text.Trim();

                                cmd.Parameters.Add("@PerformedBy",
                                    SqlDbType.VarChar, 255).Value = performedBy;

                                treatmentInformationId =
                                    Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            string insertStaff = @"
                                INSERT INTO TreatmentInformationStaff
                                (treatmentInformationID, DoctorID, NurseID)
                                VALUES
                                (@TreatmentInformationID, @DoctorID, @NurseID);";

                            foreach (ListItem item in cblDoctors.Items)
                            {
                                if (item.Selected)
                                {
                                    using (SqlCommand cmd = new SqlCommand(
                                        insertStaff, con, transaction))
                                    {
                                        cmd.Parameters.AddWithValue(
                                            "@TreatmentInformationID",
                                            treatmentInformationId);

                                        cmd.Parameters.AddWithValue(
                                            "@DoctorID",
                                            Convert.ToInt32(item.Value));

                                        cmd.Parameters.Add("@NurseID",
                                            SqlDbType.Int).Value = DBNull.Value;

                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }

                            foreach (ListItem item in cblNurses.Items)
                            {
                                if (item.Selected)
                                {
                                    using (SqlCommand cmd = new SqlCommand(
                                        insertStaff, con, transaction))
                                    {
                                        cmd.Parameters.AddWithValue(
                                            "@TreatmentInformationID",
                                            treatmentInformationId);

                                        cmd.Parameters.Add("@DoctorID",
                                            SqlDbType.Int).Value = DBNull.Value;

                                        cmd.Parameters.AddWithValue(
                                            "@NurseID",
                                            Convert.ToInt32(item.Value));

                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }

                            transaction.Commit();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }

                ClearForm();

                pnlSuccess.Visible = true;
                lblSuccess.Text =
                    "Treatment information and participating staff saved successfully.";
            }
            catch (Exception ex)
            {
                ShowError("Unable to save treatment information: " +
                    ex.Message);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        private void ClearForm()
        {
            ddlAppointment.SelectedIndex = 0;
            ddlTreatment.SelectedIndex = 0;

            txtPerformedAt.Text =
                DateTime.Now.ToString("yyyy-MM-ddTHH:mm");

            txtDiagnosis.Text = "";
            txtResults.Text = "";
            txtNotes.Text = "";

            foreach (ListItem item in cblDoctors.Items)
                item.Selected = false;

            foreach (ListItem item in cblNurses.Items)
                item.Selected = false;

            pnlTreatmentInfo.Visible = false;
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = Server.HtmlEncode(message);
        }
    }
}
