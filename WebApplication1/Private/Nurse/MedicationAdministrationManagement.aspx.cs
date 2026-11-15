

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Nurse
{
    public partial class MedicationAdministrationManagement : Page
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
            if (!Context.User.Identity.IsAuthenticated ||
                !Context.User.IsInRole("Nurse"))
            {
                Response.Redirect("~/Account/Login", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                pnlAdministration.Visible = false;
                LoadPrescriptions();
                LoadAdministrationRecords();
            }
        }

        // ==========================================
        // LOAD PRESCRIPTIONS
        // ==========================================

        private void LoadPrescriptions()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    PI.PrescriptionItemID,
                    PA.FullName AS Patient,
                    D.FullName AS Doctor,
                    M.MedicineName,
                    PI.Dosage,
                    PI.Frequency,
                    PI.Duration,
                    PI.Instruction,
                    P.DateIssued
                FROM PrescriptionItem PI
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                INNER JOIN Patient PA
                    ON P.PatientID = PA.PatientID
                INNER JOIN Doctor D
                    ON P.DoctorID = D.DoctorID
                INNER JOIN Medicine M
                    ON PI.MedicineID = M.MedicineID
                WHERE
                    (@Name = ''
                     OR PA.FullName LIKE '%' + @Name + '%')
                    AND
                    (@Date IS NULL
                     OR (
                        P.DateIssued >= @Date
                        AND P.DateIssued < DATEADD(DAY, 1, @Date)
                     ))
                ORDER BY P.DateIssued DESC;", con))
            {
                cmd.Parameters.Add("@Name", SqlDbType.VarChar, 100)
                    .Value = (TBPatient.Text ?? "").Trim();

                SqlParameter dateParameter =
                    cmd.Parameters.Add("@Date", SqlDbType.Date);

                if (string.IsNullOrWhiteSpace(TBDate.Text))
                {
                    dateParameter.Value = DBNull.Value;
                }
                else
                {
                    DateTime selectedDate;

                    if (!DateTime.TryParse(TBDate.Text, out selectedDate))
                    {
                        ShowError("Please enter a valid prescription date.");
                        return;
                    }

                    dateParameter.Value = selectedDate.Date;
                }

                DataTable dt = new DataTable();

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }

                GVMedicationAdmin.DataSource = dt;
                GVMedicationAdmin.DataBind();
            }
        }

        // ==========================================
        // LOAD EXISTING ADMINISTRATION RECORDS
        // ==========================================

        private void LoadAdministrationRecords()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    MA.medication_AdministrationID AS AdministrationID,
                    MA.PrescriptionItemID,
                    MA.NurseID,
                    MA.dosageGiven,
                    MA.frequency_Instance,
                    MA.status,
                    MA.Notes,
                    MA.Admnistered_at,
                    PA.FullName AS Patient,
                    D.FullName AS Doctor,
                    N.FullName AS Nurse,
                    M.MedicineName
                FROM MedicationAdministration MA
                INNER JOIN PrescriptionItem PI
                    ON MA.PrescriptionItemID = PI.PrescriptionItemID
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                INNER JOIN Patient PA
                    ON P.PatientID = PA.PatientID
                INNER JOIN Doctor D
                    ON P.DoctorID = D.DoctorID
                INNER JOIN Nurse N
                    ON MA.NurseID = N.NurseID
                INNER JOIN Medicine M
                    ON PI.MedicineID = M.MedicineID
                ORDER BY MA.Admnistered_at DESC;", con))
            {
                DataTable dt = new DataTable();

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }

                gvAdministrationRecords.DataSource = dt;
                gvAdministrationRecords.DataBind();
            }
        }

        // ==========================================
        // SEARCH
        // ==========================================

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            GVMedicationAdmin.SelectedIndex = -1;
            GVMedicationAdmin.PageIndex = 0;

            pnlAdministration.Visible = false;

            LoadPrescriptions();
        }

        protected void GVMedicationAdmin_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            GVMedicationAdmin.PageIndex = e.NewPageIndex;
            GVMedicationAdmin.SelectedIndex = -1;
            pnlAdministration.Visible = false;

            LoadPrescriptions();
        }

        // ==========================================
        // SELECT PRESCRIPTION ITEM
        // ==========================================

        protected void GVMedicationAdmin_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            if (GVMedicationAdmin.SelectedDataKey == null)
            {
                ShowError("Please select a prescribed medication.");
                return;
            }

            DataKey selected = GVMedicationAdmin.SelectedDataKey;

            int itemId = Convert.ToInt32(selected.Values["PrescriptionItemID"]);

            hfPrescriptionItemID.Value = itemId.ToString();
            hfAdministrationID.Value = "";

            string patient = Convert.ToString(selected.Values["Patient"]);
            string doctor = Convert.ToString(selected.Values["Doctor"]);
            string medicine = Convert.ToString(selected.Values["MedicineName"]);
            string dosage = Convert.ToString(selected.Values["Dosage"]);
            string frequency = Convert.ToString(selected.Values["Frequency"]);
            string duration = Convert.ToString(selected.Values["Duration"]);

            lblSelectedMedication.Text =
                "Patient: " + Server.HtmlEncode(patient) +
                " | Prescribing Doctor: " + Server.HtmlEncode(doctor) +
                " | Medicine: " + Server.HtmlEncode(medicine) +
                " | Prescribed dosage: " + Server.HtmlEncode(dosage) +
                " | Frequency: " + Server.HtmlEncode(frequency) +
                " | Duration: " + Server.HtmlEncode(duration) + " days";

            lblFormHeading.Text = "2. Record Medication Administration";
            btnSaveAdministration.Text = "Save Administration Record";

            txtDosageGiven.Text = "";
            txtFrequencyInstance.Text = "";
            txtNotes.Text = "";
            ddlStatus.SelectedIndex = 0;

            pnlAdministration.Visible = true;
        }

        // ==========================================
        // SAVE NEW ADMINISTRATION
        // ==========================================

        protected void btnSaveAdministration_Click(object sender, EventArgs e)
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            int prescriptionItemId;
            int dosageGiven;
            int frequencyInstance;
            if (!string.IsNullOrEmpty(hfAdministrationID.Value))
            {
                int editId;

                if (!int.TryParse(hfAdministrationID.Value, out editId))
                {
                    ShowError("Invalid administration record.");
                    return;
                }

                UpdateAdministration(editId);
                return;
            }

            if (!int.TryParse(hfPrescriptionItemID.Value, out prescriptionItemId) ||
                prescriptionItemId <= 0)
            {
                ShowError("Please select a prescribed medicine.");
                return;
            }

            if (!int.TryParse(txtDosageGiven.Text, out dosageGiven) ||
                dosageGiven < 0)
            {
                ShowError("Please enter a valid numeric dosage.");
                return;
            }

            if (!int.TryParse(txtFrequencyInstance.Text, out frequencyInstance) ||
                frequencyInstance <= 0)
            {
                ShowError("Please enter a valid frequency instance.");
                return;
            }

            if (string.IsNullOrWhiteSpace(ddlStatus.SelectedValue))
            {
                ShowError("Please select an administration status.");
                return;
            }

            if (txtNotes.Text.Trim().Length > 50)
            {
                ShowError("Nursing notes cannot exceed 50 characters.");
                return;
            }

            string userId = User.Identity.GetUserId();

            if (string.IsNullOrEmpty(userId))
            {
                ShowError("Your login session could not be verified.");
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();

                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        int nurseId = GetCurrentNurseID(con, transaction, userId);

                        // Verify the prescription item.
                        using (SqlCommand verify = new SqlCommand(@"
                            SELECT COUNT(*)
                            FROM PrescriptionItem
                            WHERE PrescriptionItemID = @ItemID;",
                            con, transaction))
                        {
                            verify.Parameters.Add("@ItemID", SqlDbType.Int)
                                .Value = prescriptionItemId;

                            if (Convert.ToInt32(verify.ExecuteScalar()) == 0)
                                throw new Exception("The selected prescription item no longer exists.");
                        }

                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO MedicationAdministration
                            (
                                NurseID,
                                PrescriptionItemID,
                                Admnistered_at,
                                Notes,
                                dosageGiven,
                                status,
                                frequency_Instance
                            )
                            VALUES
                            (
                                @NurseID,
                                @ItemID,
                                GETDATE(),
                                @Notes,
                                @Dosage,
                                @Status,
                                @Frequency
                            );", con, transaction))
                        {
                            cmd.Parameters.Add("@NurseID", SqlDbType.Int).Value = nurseId;
                            cmd.Parameters.Add("@ItemID", SqlDbType.Int).Value = prescriptionItemId;
                            cmd.Parameters.Add("@Notes", SqlDbType.VarChar, 50).Value =
                                txtNotes.Text.Trim();
                            cmd.Parameters.Add("@Dosage", SqlDbType.Int).Value = dosageGiven;
                            cmd.Parameters.Add("@Status", SqlDbType.VarChar, 50).Value =
                                ddlStatus.SelectedValue;
                            cmd.Parameters.Add("@Frequency", SqlDbType.Int).Value =
                                frequencyInstance;

                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();

                        ShowSuccess("Medication administration was recorded successfully.");

                        ClearAdministrationForm();
                        LoadAdministrationRecords();
                    }
                    catch (Exception ex)
                    {
                        try { transaction.Rollback(); }
                        catch { }

                        ShowError("Unable to record administration: " + ex.Message);
                    }
                }
            }
        }

        // ==========================================
        // EDIT / DELETE GRID COMMANDS
        // ==========================================

        protected void gvAdministrationRecords_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRecord")
            {
                int administrationId;

                if (!int.TryParse(Convert.ToString(e.CommandArgument),
                    out administrationId))
                {
                    ShowError("Invalid administration record.");
                    return;
                }

                LoadRecordForEditing(administrationId);
            }
            else if (e.CommandName == "DeleteRecord")
            {
                int administrationId;

                if (!int.TryParse(Convert.ToString(e.CommandArgument),
                    out administrationId))
                {
                    ShowError("Invalid administration record.");
                    return;
                }

                DeleteAdministration(administrationId);
            }
        }

        private void LoadRecordForEditing(int administrationId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    MA.medication_AdministrationID,
                    MA.PrescriptionItemID,
                    MA.dosageGiven,
                    MA.frequency_Instance,
                    MA.status,
                    MA.Notes,
                    PA.FullName AS Patient,
                    D.FullName AS Doctor,
                    M.MedicineName,
                    PI.Dosage,
                    PI.Frequency,
                    PI.Duration
                FROM MedicationAdministration MA
                INNER JOIN PrescriptionItem PI
                    ON MA.PrescriptionItemID = PI.PrescriptionItemID
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                INNER JOIN Patient PA
                    ON P.PatientID = PA.PatientID
                INNER JOIN Doctor D
                    ON P.DoctorID = D.DoctorID
                INNER JOIN Medicine M
                    ON PI.MedicineID = M.MedicineID
                WHERE MA.medication_AdministrationID = @ID;", con))
            {
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = administrationId;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowError("The administration record could not be found.");
                        return;
                    }

                    hfAdministrationID.Value = administrationId.ToString();
                    hfPrescriptionItemID.Value =
                        reader["PrescriptionItemID"].ToString();

                    txtDosageGiven.Text =
                        reader["dosageGiven"] == DBNull.Value
                            ? "" : reader["dosageGiven"].ToString();

                    txtFrequencyInstance.Text =
                        reader["frequency_Instance"].ToString();

                    txtNotes.Text =
                        reader["Notes"] == DBNull.Value
                            ? "" : reader["Notes"].ToString();

                    string status = reader["status"] == DBNull.Value
                        ? "" : reader["status"].ToString();

                    ddlStatus.ClearSelection();

                    ListItem item = ddlStatus.Items.FindByValue(status);

                    if (item != null)
                        item.Selected = true;
                    else
                        ddlStatus.SelectedIndex = 0;

                    lblSelectedMedication.Text =
                        "Patient: " + Server.HtmlEncode(reader["Patient"].ToString()) +
                        " | Prescribing Doctor: " + Server.HtmlEncode(reader["Doctor"].ToString()) +
                        " | Medicine: " + Server.HtmlEncode(reader["MedicineName"].ToString()) +
                        " | Prescribed dosage: " + Server.HtmlEncode(reader["Dosage"].ToString()) +
                        " | Frequency: " + Server.HtmlEncode(reader["Frequency"].ToString()) +
                        " | Duration: " + Server.HtmlEncode(reader["Duration"].ToString()) + " days";
                }
            }

            lblFormHeading.Text = "Edit Medication Administration";
            btnSaveAdministration.Text = "Update Administration Record";
            pnlAdministration.Visible = true;

            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        private void DeleteAdministration(int administrationId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                DELETE FROM MedicationAdministration
                WHERE medication_AdministrationID = @ID;", con))
            {
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = administrationId;

                con.Open();

                int affected = cmd.ExecuteNonQuery();

                if (affected > 0)
                {
                    ShowSuccess("Medication administration record deleted successfully.");
                    LoadAdministrationRecords();
                }
                else
                {
                    ShowError("The record could not be found or was already deleted.");
                }
            }
        }

        // ==========================================
        // UPDATE EXISTING ADMINISTRATION
        // ==========================================

        private void UpdateAdministration(int administrationId)
        {
            int dosageGiven;
            int frequencyInstance;

            if (!int.TryParse(txtDosageGiven.Text, out dosageGiven) ||
                dosageGiven < 0)
            {
                ShowError("Please enter a valid numeric dosage.");
                return;
            }

            if (!int.TryParse(txtFrequencyInstance.Text, out frequencyInstance) ||
                frequencyInstance <= 0)
            {
                ShowError("Please enter a valid frequency instance.");
                return;
            }

            if (string.IsNullOrWhiteSpace(ddlStatus.SelectedValue))
            {
                ShowError("Please select an administration status.");
                return;
            }

            if (txtNotes.Text.Trim().Length > 50)
            {
                ShowError("Nursing notes cannot exceed 50 characters.");
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE MedicationAdministration
                SET dosageGiven = @Dosage,
                    frequency_Instance = @Frequency,
                    status = @Status,
                    Notes = @Notes
                WHERE medication_AdministrationID = @ID;", con))
            {
                cmd.Parameters.Add("@Dosage", SqlDbType.Int).Value = dosageGiven;
                cmd.Parameters.Add("@Frequency", SqlDbType.Int).Value = frequencyInstance;
                cmd.Parameters.Add("@Status", SqlDbType.VarChar, 50).Value =
                    ddlStatus.SelectedValue;
                cmd.Parameters.Add("@Notes", SqlDbType.VarChar, 50).Value =
                    txtNotes.Text.Trim();
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = administrationId;

                con.Open();

                int affected = cmd.ExecuteNonQuery();

                if (affected > 0)
                {
                    ShowSuccess("Medication administration record updated successfully.");

                    ClearAdministrationForm();
                    LoadAdministrationRecords();
                }
                else
                {
                    ShowError("The administration record could not be found.");
                }
            }
        }

        // ==========================================
        // SAVE BUTTON: ADD OR UPDATE
        // ==========================================

        private int GetCurrentNurseID(
            SqlConnection con, SqlTransaction transaction, string userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT NurseID
                FROM Nurse
                WHERE UserId = @UserId;", con, transaction))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128).Value = userId;

                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    throw new Exception("Your nurse profile could not be found.");

                return Convert.ToInt32(result);
            }
        }

        // ==========================================
        // CANCEL / CLEAR FORM
        // ==========================================

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearAdministrationForm();
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }

        private void ClearAdministrationForm()
        {
            hfAdministrationID.Value = "";
            hfPrescriptionItemID.Value = "";

            txtDosageGiven.Text = "";
            txtFrequencyInstance.Text = "";
            txtNotes.Text = "";

            ddlStatus.SelectedIndex = 0;

            lblFormHeading.Text = "2. Record Medication Administration";
            btnSaveAdministration.Text = "Save Administration Record";

            pnlAdministration.Visible = false;
            GVMedicationAdmin.SelectedIndex = -1;
        }

        protected void gvAdministrationRecords_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            gvAdministrationRecords.PageIndex = e.NewPageIndex;
            LoadAdministrationRecords();
        }

        // ==========================================
        // NOTIFICATIONS
        // ==========================================

        private void ShowSuccess(string message)
        {
            lblSuccess.Text = Server.HtmlEncode(message);
            pnlSuccess.Visible = true;
            pnlError.Visible = false;
        }

        private void ShowError(string message)
        {
            lblError.Text = Server.HtmlEncode(message);
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
        }
    }
}

