

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Doctor
{
    public partial class PrescriptionManagement : Page
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

        // Temporarily stores medicines before saving the prescription.
        private DataTable PendingMedicines
        {
            get
            {
                if (ViewState["PendingMedicines"] == null)
                {
                    DataTable table = new DataTable();

                    table.Columns.Add("MedicineID", typeof(int));
                    table.Columns.Add("MedicineName", typeof(string));
                    table.Columns.Add("Dosage", typeof(string));
                    table.Columns.Add("Frequency", typeof(string));
                    table.Columns.Add("Duration", typeof(int));
                    table.Columns.Add("Instruction", typeof(string));

                    ViewState["PendingMedicines"] = table;
                }

                return (DataTable)ViewState["PendingMedicines"];
            }
            set
            {
                ViewState["PendingMedicines"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only authenticated Doctors may access this page.
            if (!Context.User.Identity.IsAuthenticated ||
                !Context.User.IsInRole("Doctor"))
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadPatients();
                LoadMedicines();
                LoadDoctorName();
                BindPendingMedicines();
            }
        }

        // ==========================================
        // PATIENT SELECTION
        // ==========================================


        private void LoadPatients(string search = "")
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT
            PatientID,
            FullName,
            IdNumber,
            PatientFileNumber,
            DateOfBirth
        FROM Patient
        WHERE
            (@Search = ''
            OR FullName LIKE '%' + @Search + '%'
            OR CAST(PatientID AS VARCHAR(20))
                LIKE '%' + @Search + '%'
            OR ISNULL(CAST(IdNumber AS VARCHAR(50)), '')
                LIKE '%' + @Search + '%'
            OR ISNULL(CAST(PatientFileNumber AS VARCHAR(50)), '')
                LIKE '%' + @Search + '%')
        ORDER BY FullName;", con))
            {
                cmd.Parameters.Add("@Search", SqlDbType.VarChar, 100)
                    .Value = (search ?? "").Trim();

                // Load the query results into a DataTable.
                DataTable patients = new DataTable();

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(patients);
                }

                // Bind the DataTable instead of SqlDataReader.
                gvPatients.DataSource = patients;
                gvPatients.DataBind();
            }
        }


        protected void btnSearchPatient_Click(object sender, EventArgs e)
        {
            // Start at the first page when performing a new search.
            gvPatients.PageIndex = 0;
            gvPatients.SelectedIndex = -1;

            hfPatientID.Value = "";
            lblSelectedPatient.Text = "No patient selected.";

            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            LoadPatients(txtPatientSearch.Text);
        }

        protected void gvPatients_PageIndexChanging(
            object sender,
            System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            // Change the page and reload using the current search.
            gvPatients.PageIndex = e.NewPageIndex;
            gvPatients.SelectedIndex = -1;

            LoadPatients(txtPatientSearch.Text);
        }

        protected void gvPatients_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            if (gvPatients.SelectedDataKey != null)
            {
                string patientId =
                    gvPatients.SelectedDataKey.Values["PatientID"].ToString();

                string patientName =
                    Convert.ToString(
                        gvPatients.SelectedDataKey.Values["FullName"]);

                string idNumber =
                    Convert.ToString(
                        gvPatients.SelectedDataKey.Values["IdNumber"]);

                string fileNumber =
                    Convert.ToString(
                        gvPatients.SelectedDataKey.Values["PatientFileNumber"]);

                object dobValue =
                    gvPatients.SelectedDataKey.Values["DateOfBirth"];

                string dateOfBirth = "Not recorded";

                if (dobValue != null && dobValue != DBNull.Value)
                {
                    DateTime dob = Convert.ToDateTime(dobValue);
                    dateOfBirth = dob.ToString("dd MMM yyyy");
                }

                hfPatientID.Value = patientId;

                lblSelectedPatient.Text =
                    "Selected patient: " +
                    Server.HtmlEncode(patientName) +
                    " | Patient ID: " +
                    Server.HtmlEncode(patientId) +
                    " | National ID: " +
                    Server.HtmlEncode(
                        string.IsNullOrWhiteSpace(idNumber)
                            ? "Not recorded"
                            : idNumber) +
                    " | File No.: " +
                    Server.HtmlEncode(
                        string.IsNullOrWhiteSpace(fileNumber)
                            ? "Not recorded"
                            : fileNumber) +
                    " | Date of Birth: " +
                    Server.HtmlEncode(dateOfBirth);

                pnlError.Visible = false;
            }
        }

        // ==========================================
        // MEDICINE SELECTION
        // ==========================================

        private void LoadMedicines()
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    MedicineID,
                    MedicineName + ' (' +
                    COALESCE(
                        NULLIF(DosageUnit, ''),
                        'Unit not specified'
                    ) + ')' AS DisplayName
                FROM Medicine
                ORDER BY MedicineName;", con))
            {
                con.Open();

                ddlMedicine.DataSource = cmd.ExecuteReader();
                ddlMedicine.DataTextField = "DisplayName";
                ddlMedicine.DataValueField = "MedicineID";
                ddlMedicine.DataBind();
            }

            ddlMedicine.Items.Insert(0,
                new System.Web.UI.WebControls.ListItem(
                    "-- Select Medicine --", ""));
        }

        // ==========================================
        // DOCTOR INFORMATION
        // ==========================================

        private void LoadDoctorName()
        {
            string userId = User.Identity.GetUserId();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT FullName
                FROM Doctor
                WHERE UserId = @UserId;", con))
            {
                cmd.Parameters.Add("@UserId",
                    SqlDbType.NVarChar, 128).Value = userId;

                con.Open();

                object result = cmd.ExecuteScalar();

                if (result == null)
                    throw new Exception(
                        "Your doctor profile could not be found.");

                lblDoctor.Text =
                    "Logged in as: " +
                    Server.HtmlEncode(result.ToString());
            }
        }

        // ==========================================
        // ADD MEDICINE TO PENDING LIST
        // ==========================================

        protected void btnAddMedicine_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            if (string.IsNullOrEmpty(ddlMedicine.SelectedValue))
            {
                ShowError("Please select a medicine.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDosage.Text) ||
                string.IsNullOrWhiteSpace(txtFrequency.Text))
            {
                ShowError("Please enter the dosage and frequency.");
                return;
            }

            int duration;

            if (!int.TryParse(txtDuration.Text, out duration) ||
                duration <= 0)
            {
                ShowError("Please enter a valid duration in days.");
                return;
            }

            if (txtDosage.Text.Trim().Length > 50 ||
                txtFrequency.Text.Trim().Length > 50 ||
                txtInstruction.Text.Trim().Length > 200)
            {
                ShowError("One or more fields exceed the allowed length.");
                return;
            }

            int medicineId =
                Convert.ToInt32(ddlMedicine.SelectedValue);

            // Prevent accidentally adding the same medicine twice.
            foreach (DataRow existing in PendingMedicines.Rows)
            {
                if (Convert.ToInt32(existing["MedicineID"]) == medicineId)
                {
                    ShowError(
                        "This medicine is already in the prescription.");
                    return;
                }
            }

            DataRow row = PendingMedicines.NewRow();

            row["MedicineID"] = medicineId;
            row["MedicineName"] = ddlMedicine.SelectedItem.Text;
            row["Dosage"] = txtDosage.Text.Trim();
            row["Frequency"] = txtFrequency.Text.Trim();
            row["Duration"] = duration;
            row["Instruction"] = txtInstruction.Text.Trim();

            PendingMedicines.Rows.Add(row);

            BindPendingMedicines();

            // Clear medicine entry fields.
            txtDosage.Text = "";
            txtFrequency.Text = "";
            txtDuration.Text = "";
            txtInstruction.Text = "";

            ddlMedicine.SelectedIndex = 0;
        }

        private void BindPendingMedicines()
        {
            gvMedicines.DataSource = PendingMedicines;
            gvMedicines.DataBind();

            lblEmptyList.Visible =
                PendingMedicines.Rows.Count == 0;
        }

        // ==========================================
        // SAVE PRESCRIPTION
        // ==========================================

        protected void btnSavePrescription_Click(
            object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            if (string.IsNullOrEmpty(hfPatientID.Value))
            {
                ShowError("Please select a patient.");
                return;
            }

            if (PendingMedicines.Rows.Count == 0)
            {
                ShowError(
                    "Please add at least one medicine.");
                return;
            }

            int patientId;

            if (!int.TryParse(hfPatientID.Value, out patientId))
            {
                ShowError("Invalid patient selection.");
                return;
            }

            string userId = User.Identity.GetUserId();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            {
                con.Open();

                SqlTransaction transaction =
                    con.BeginTransaction();

                try
                {
                    // Find the DoctorID belonging to the logged-in Doctor.
                    int doctorId;

                    using (SqlCommand doctorCmd = new SqlCommand(@"
                        SELECT DoctorID
                        FROM Doctor
                        WHERE UserId = @UserId;",
                        con, transaction))
                    {
                        doctorCmd.Parameters.Add("@UserId",
                            SqlDbType.NVarChar, 128).Value = userId;

                        object doctorResult =
                            doctorCmd.ExecuteScalar();

                        if (doctorResult == null)
                            throw new Exception(
                                "Doctor profile not found.");

                        doctorId =
                            Convert.ToInt32(doctorResult);
                    }

                    // Verify that the selected patient exists.
                    using (SqlCommand patientCmd = new SqlCommand(@"
                        SELECT COUNT(*)
                        FROM Patient
                        WHERE PatientID = @PatientID;",
                        con, transaction))
                    {
                        patientCmd.Parameters.Add("@PatientID",
                            SqlDbType.Int).Value = patientId;

                        if (Convert.ToInt32(
                            patientCmd.ExecuteScalar()) == 0)
                        {
                            throw new Exception(
                                "The selected patient could not be found.");
                        }
                    }

                    // Create the prescription header.
                    int prescriptionId;

                    using (SqlCommand prescriptionCmd =
                        new SqlCommand(@"
                            INSERT INTO Prescriptions
                                (DoctorID, PatientID, DateIssued)
                            OUTPUT INSERTED.PrescriptionID
                            VALUES
                                (@DoctorID, @PatientID, GETDATE());",
                            con, transaction))
                    {
                        prescriptionCmd.Parameters.Add("@DoctorID",
                            SqlDbType.Int).Value = doctorId;

                        prescriptionCmd.Parameters.Add("@PatientID",
                            SqlDbType.Int).Value = patientId;

                        prescriptionId =
                            Convert.ToInt32(
                                prescriptionCmd.ExecuteScalar());
                    }

                    // Insert all medicines into PrescriptionItem.
                    foreach (DataRow medicine in PendingMedicines.Rows)
                    {
                        using (SqlCommand itemCmd =
                            new SqlCommand(@"
                                INSERT INTO PrescriptionItem
                                    (PrescriptionID, MedicineID, Dosage,
                                     Frequency, Duration, Instruction)
                                VALUES
                                    (@PrescriptionID, @MedicineID,
                                     @Dosage, @Frequency,
                                     @Duration, @Instruction);",
                                con, transaction))
                        {
                            itemCmd.Parameters.Add("@PrescriptionID",
                                SqlDbType.Int).Value = prescriptionId;

                            itemCmd.Parameters.Add("@MedicineID",
                                SqlDbType.Int).Value =
                                Convert.ToInt32(medicine["MedicineID"]);

                            itemCmd.Parameters.Add("@Dosage",
                                SqlDbType.VarChar, 50).Value =
                                medicine["Dosage"];

                            itemCmd.Parameters.Add("@Frequency",
                                SqlDbType.VarChar, 50).Value =
                                medicine["Frequency"];

                            itemCmd.Parameters.Add("@Duration",
                                SqlDbType.Int).Value =
                                medicine["Duration"];

                            itemCmd.Parameters.Add("@Instruction",
                                SqlDbType.VarChar, 200).Value =
                                string.IsNullOrWhiteSpace(
                                    medicine["Instruction"].ToString())
                                    ? (object)DBNull.Value
                                    : medicine["Instruction"];

                            itemCmd.ExecuteNonQuery();
                        }
                    }

                    // Commit all records together.
                    transaction.Commit();

                    PendingMedicines.Clear();
                    BindPendingMedicines();

                    lblSuccess.Text =
                        "Prescription #" + prescriptionId +
                        " was created successfully.";

                    pnlSuccess.Visible = true;
                }
                catch (Exception ex)
                {
                    try
                    {
                        transaction.Rollback();
                    }
                    catch
                    {
                        // Preserve the original database error.
                    }

                    ShowError(
                        "Unable to save prescription: " + ex.Message);
                }
            }
        }

        // ==========================================
        // CLEAR FORM
        // ==========================================

        protected void btnClear_Click(object sender, EventArgs e)
        {
            PendingMedicines.Clear();
            BindPendingMedicines();

            txtDosage.Text = "";
            txtFrequency.Text = "";
            txtDuration.Text = "";
            txtInstruction.Text = "";

            ddlMedicine.SelectedIndex = 0;

            hfPatientID.Value = "";

            lblSelectedPatient.Text =
                "No patient selected.";

            gvPatients.SelectedIndex = -1;
            gvPatients.PageIndex = 0;

            txtPatientSearch.Text = "";

            LoadPatients();

            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        // ==========================================
        // ERROR NOTIFICATION
        // ==========================================

        private void ShowError(string message)
        {
            lblError.Text = Server.HtmlEncode(message);
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
        }
    }
}

