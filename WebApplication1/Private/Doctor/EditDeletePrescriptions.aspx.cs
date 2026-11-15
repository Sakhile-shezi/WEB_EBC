
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace WebApplication1.Private.Doctor
{
    public partial class ManagePrescriptions : Page
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

        private int CurrentDoctorID
        {
            get
            {
                object value = ViewState["CurrentDoctorID"];

                if (value == null)
                    throw new Exception("Doctor session could not be verified.");

                return Convert.ToInt32(value);
            }
            set
            {
                ViewState["CurrentDoctorID"] = value;
            }
        }

        private int SelectedPrescriptionID
        {
            get
            {
                object value = ViewState["SelectedPrescriptionID"];

                return value == null ? 0 : Convert.ToInt32(value);
            }
            set
            {
                ViewState["SelectedPrescriptionID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Context.User.Identity.IsAuthenticated ||
                !Context.User.IsInRole("Doctor"))
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadCurrentDoctor();
                LoadPrescriptions();
            }
        }

        // ==========================================
        // CURRENT DOCTOR
        // ==========================================

        private void LoadCurrentDoctor()
        {
            string userId = User.Identity.GetUserId();

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT DoctorID
                FROM Doctor
                WHERE UserId = @UserId;", con))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar, 128)
                    .Value = userId;

                con.Open();

                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    throw new Exception("Your doctor profile could not be found.");

                CurrentDoctorID = Convert.ToInt32(result);
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
                    P.PrescriptionID,
                    PA.FullName AS Patient,
                    P.DateIssued,
                    COUNT(PI.PrescriptionItemID) AS MedicineCount
                FROM Prescriptions P
                INNER JOIN Patient PA
                    ON P.PatientID = PA.PatientID
                LEFT JOIN PrescriptionItem PI
                    ON P.PrescriptionID = PI.PrescriptionID
                WHERE P.DoctorID = @DoctorID
                    AND (
                        @Name = ''
                        OR PA.FullName LIKE '%' + @Name + '%'
                    )
                    AND (
                        @Date IS NULL
                        OR (
                            P.DateIssued >= @Date
                            AND P.DateIssued < DATEADD(DAY, 1, @Date)
                        )
                    )
                GROUP BY
                    P.PrescriptionID,
                    PA.FullName,
                    P.DateIssued
                ORDER BY P.DateIssued DESC;", con))
            {
                cmd.Parameters.Add("@DoctorID", SqlDbType.Int)
                    .Value = CurrentDoctorID;

                cmd.Parameters.Add("@Name", SqlDbType.VarChar, 100)
                    .Value = (txtSearchPatient.Text ?? "").Trim();

                SqlParameter dateParameter =
                    cmd.Parameters.Add("@Date", SqlDbType.Date);

                if (string.IsNullOrWhiteSpace(txtSearchDate.Text))
                {
                    dateParameter.Value = DBNull.Value;
                }
                else
                {
                    DateTime date;

                    if (!DateTime.TryParse(txtSearchDate.Text, out date))
                    {
                        ShowError("Please enter a valid prescription date.");
                        return;
                    }

                    dateParameter.Value = date.Date;
                }

                DataTable dt = new DataTable();

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }

                gvPrescriptions.DataSource = dt;
                gvPrescriptions.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ClearMessages();

            SelectedPrescriptionID = 0;
            gvPrescriptions.SelectedIndex = -1;
            gvPrescriptions.PageIndex = 0;

            pnlPrescriptionDetails.Visible = false;
            pnlEditItem.Visible = false;

            LoadPrescriptions();
        }

        protected void gvPrescriptions_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            gvPrescriptions.PageIndex = e.NewPageIndex;
            gvPrescriptions.SelectedIndex = -1;

            SelectedPrescriptionID = 0;
            pnlPrescriptionDetails.Visible = false;
            pnlEditItem.Visible = false;

            LoadPrescriptions();
        }

        // ==========================================
        // SELECT A PRESCRIPTION
        // ==========================================

        protected void gvPrescriptions_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            ClearMessages();

            if (gvPrescriptions.SelectedDataKey == null)
            {
                ShowError("Please select a prescription.");
                return;
            }

            SelectedPrescriptionID = Convert.ToInt32(
                gvPrescriptions.SelectedDataKey.Value);

            LoadSelectedPrescription();
        }

        private void LoadSelectedPrescription()
        {
            if (SelectedPrescriptionID <= 0)
                return;

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    P.PrescriptionID,
                    PA.FullName AS Patient,
                    D.FullName AS Doctor,
                    P.DateIssued
                FROM Prescriptions P
                INNER JOIN Patient PA
                    ON P.PatientID = PA.PatientID
                INNER JOIN Doctor D
                    ON P.DoctorID = D.DoctorID
                WHERE P.PrescriptionID = @PrescriptionID
                    AND P.DoctorID = @DoctorID;", con))
            {
                cmd.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                    .Value = SelectedPrescriptionID;

                cmd.Parameters.Add("@DoctorID", SqlDbType.Int)
                    .Value = CurrentDoctorID;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        SelectedPrescriptionID = 0;
                        pnlPrescriptionDetails.Visible = false;
                        ShowError("The prescription could not be found.");
                        return;
                    }

                    lblPrescriptionInfo.Text =
                        "Prescription #" +
                        reader["PrescriptionID"] +
                        " | Patient: " +
                        Server.HtmlEncode(reader["Patient"].ToString()) +
                        " | Prescribing Doctor: " +
                        Server.HtmlEncode(reader["Doctor"].ToString()) +
                        " | Date Issued: " +
                        Convert.ToDateTime(reader["DateIssued"])
                            .ToString("dd MMM yyyy");
                }
            }

            LoadPrescriptionItems();

            pnlPrescriptionDetails.Visible = true;
        }

        // ==========================================
        // LOAD MEDICINE ITEMS
        // ==========================================

        private void LoadPrescriptionItems()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    PI.PrescriptionItemID,
                    PI.MedicineID,
                    M.MedicineName,
                    PI.Dosage,
                    PI.Frequency,
                    PI.Duration,
                    PI.Instruction
                FROM PrescriptionItem PI
                INNER JOIN Medicine M
                    ON PI.MedicineID = M.MedicineID
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                WHERE PI.PrescriptionID = @PrescriptionID
                    AND P.DoctorID = @DoctorID
                ORDER BY PI.PrescriptionItemID;", con))
            {
                cmd.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                    .Value = SelectedPrescriptionID;

                cmd.Parameters.Add("@DoctorID", SqlDbType.Int)
                    .Value = CurrentDoctorID;

                DataTable dt = new DataTable();

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }

                gvPrescriptionItems.DataSource = dt;
                gvPrescriptionItems.DataBind();
            }
        }

        // ==========================================
        // EDIT / DELETE INDIVIDUAL MEDICINE
        // ==========================================

        protected void gvPrescriptionItems_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            ClearMessages();

            int itemId;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out itemId))
            {
                ShowError("Invalid prescription item.");
                return;
            }

            if (e.CommandName == "EditMedicine")
            {
                LoadMedicineForEditing(itemId);
            }
            else if (e.CommandName == "DeleteMedicine")
            {
                DeletePrescriptionItem(itemId);
            }
        }

        private void LoadMedicineForEditing(int itemId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    PI.PrescriptionItemID,
                    M.MedicineName,
                    PI.Dosage,
                    PI.Frequency,
                    PI.Duration,
                    PI.Instruction
                FROM PrescriptionItem PI
                INNER JOIN Medicine M
                    ON PI.MedicineID = M.MedicineID
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                WHERE PI.PrescriptionItemID = @ItemID
                    AND PI.PrescriptionID = @PrescriptionID
                    AND P.DoctorID = @DoctorID;", con))
            {
                cmd.Parameters.Add("@ItemID", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                    .Value = SelectedPrescriptionID;
                cmd.Parameters.Add("@DoctorID", SqlDbType.Int)
                    .Value = CurrentDoctorID;

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowError("The medicine item could not be found.");
                        return;
                    }

                    hfPrescriptionItemID.Value = itemId.ToString();

                    txtEditMedicine.Text = reader["MedicineName"].ToString();
                    txtEditDosage.Text = reader["Dosage"].ToString();
                    txtEditFrequency.Text = reader["Frequency"].ToString();
                    txtEditDuration.Text = reader["Duration"].ToString();

                    txtEditInstruction.Text =
                        reader["Instruction"] == DBNull.Value
                            ? ""
                            : reader["Instruction"].ToString();
                }
            }

            pnlEditItem.Visible = true;
        }

        protected void btnUpdateItem_Click(object sender, EventArgs e)
        {
            ClearMessages();

            int itemId;
            int duration;

            if (!int.TryParse(hfPrescriptionItemID.Value, out itemId))
            {
                ShowError("Invalid prescription item.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtEditDosage.Text) ||
                string.IsNullOrWhiteSpace(txtEditFrequency.Text))
            {
                ShowError("Dosage and frequency are required.");
                return;
            }

            if (!int.TryParse(txtEditDuration.Text, out duration) ||
                duration <= 0)
            {
                ShowError("Please enter a valid duration in days.");
                return;
            }

            if (txtEditDosage.Text.Trim().Length > 50 ||
                txtEditFrequency.Text.Trim().Length > 50 ||
                txtEditInstruction.Text.Trim().Length > 200)
            {
                ShowError("One or more fields exceed the allowed length.");
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE PI
                SET
                    Dosage = @Dosage,
                    Frequency = @Frequency,
                    Duration = @Duration,
                    Instruction = @Instruction
                FROM PrescriptionItem PI
                INNER JOIN Prescriptions P
                    ON PI.PrescriptionID = P.PrescriptionID
                WHERE PI.PrescriptionItemID = @ItemID
                    AND PI.PrescriptionID = @PrescriptionID
                    AND P.DoctorID = @DoctorID;", con))
            {
                cmd.Parameters.Add("@Dosage", SqlDbType.VarChar, 50)
                    .Value = txtEditDosage.Text.Trim();

                cmd.Parameters.Add("@Frequency", SqlDbType.VarChar, 50)
                    .Value = txtEditFrequency.Text.Trim();

                cmd.Parameters.Add("@Duration", SqlDbType.Int)
                    .Value = duration;

                cmd.Parameters.Add("@Instruction", SqlDbType.VarChar, 200)
                    .Value = string.IsNullOrWhiteSpace(txtEditInstruction.Text)
                        ? (object)DBNull.Value
                        : txtEditInstruction.Text.Trim();

                cmd.Parameters.Add("@ItemID", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                    .Value = SelectedPrescriptionID;
                cmd.Parameters.Add("@DoctorID", SqlDbType.Int)
                    .Value = CurrentDoctorID;

                con.Open();

                int affected = cmd.ExecuteNonQuery();

                if (affected > 0)
                {
                    pnlEditItem.Visible = false;
                    hfPrescriptionItemID.Value = "";

                    LoadSelectedPrescription();
                    ShowSuccess("Prescription medicine updated successfully.");
                }
                else
                {
                    ShowError("The medicine could not be updated.");
                }
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            pnlEditItem.Visible = false;
            hfPrescriptionItemID.Value = "";
            ClearMessages();
        }

        // ==========================================
        // DELETE INDIVIDUAL MEDICINE
        // ==========================================

        private void DeletePrescriptionItem(int itemId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();

                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // Verify ownership and check for administration history.
                        using (SqlCommand check = new SqlCommand(@"
                            SELECT COUNT(*)
                            FROM PrescriptionItem PI
                            INNER JOIN Prescriptions P
                                ON PI.PrescriptionID = P.PrescriptionID
                            WHERE PI.PrescriptionItemID = @ItemID
                                AND PI.PrescriptionID = @PrescriptionID
                                AND P.DoctorID = @DoctorID
                                AND EXISTS (
                                    SELECT 1
                                    FROM MedicationAdministration MA
                                    WHERE MA.PrescriptionItemID = PI.PrescriptionItemID
                                );", con, transaction))
                        {
                            check.Parameters.Add("@ItemID", SqlDbType.Int).Value = itemId;
                            check.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                                .Value = SelectedPrescriptionID;
                            check.Parameters.Add("@DoctorID", SqlDbType.Int)
                                .Value = CurrentDoctorID;

                            if (Convert.ToInt32(check.ExecuteScalar()) > 0)
                            {
                                throw new Exception(
                                    "This medicine has medication administration history and cannot be deleted.");
                            }
                        }

                        using (SqlCommand delete = new SqlCommand(@"
                            DELETE PI
                            FROM PrescriptionItem PI
                            INNER JOIN Prescriptions P
                                ON PI.PrescriptionID = P.PrescriptionID
                            WHERE PI.PrescriptionItemID = @ItemID
                                AND PI.PrescriptionID = @PrescriptionID
                                AND P.DoctorID = @DoctorID;", con, transaction))
                        {
                            delete.Parameters.Add("@ItemID", SqlDbType.Int).Value = itemId;
                            delete.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                                .Value = SelectedPrescriptionID;
                            delete.Parameters.Add("@DoctorID", SqlDbType.Int)
                                .Value = CurrentDoctorID;

                            if (delete.ExecuteNonQuery() == 0)
                                throw new Exception("The medicine item could not be found.");
                        }

                        transaction.Commit();

                        pnlEditItem.Visible = false;
                        LoadSelectedPrescription();

                        ShowSuccess("Medicine removed from the prescription.");
                    }
                    catch (Exception ex)
                    {
                        try { transaction.Rollback(); } catch { }
                        ShowError(ex.Message);
                    }
                }
            }
        }

        // ==========================================
        // DELETE ENTIRE PRESCRIPTION
        // ==========================================

        protected void btnDeletePrescription_Click(object sender, EventArgs e)
        {
            ClearMessages();

            if (SelectedPrescriptionID <= 0)
            {
                ShowError("Please select a prescription first.");
                return;
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();

                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // Check whether any medicine item has administration history.
                        using (SqlCommand check = new SqlCommand(@"
                            SELECT COUNT(*)
                            FROM PrescriptionItem PI
                            INNER JOIN Prescriptions P
                                ON PI.PrescriptionID = P.PrescriptionID
                            INNER JOIN MedicationAdministration MA
                                ON MA.PrescriptionItemID = PI.PrescriptionItemID
                            WHERE P.PrescriptionID = @PrescriptionID
                                AND P.DoctorID = @DoctorID;", con, transaction))
                        {
                            check.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                                .Value = SelectedPrescriptionID;
                            check.Parameters.Add("@DoctorID", SqlDbType.Int)
                                .Value = CurrentDoctorID;

                            if (Convert.ToInt32(check.ExecuteScalar()) > 0)
                            {
                                throw new Exception(
                                    "This prescription has medication administration history. It cannot be deleted.");
                            }
                        }

                        // Delete its medicine items first.
                        using (SqlCommand deleteItems = new SqlCommand(@"
                            DELETE PI
                            FROM PrescriptionItem PI
                            INNER JOIN Prescriptions P
                                ON PI.PrescriptionID = P.PrescriptionID
                            WHERE P.PrescriptionID = @PrescriptionID
                                AND P.DoctorID = @DoctorID;", con, transaction))
                        {
                            deleteItems.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                                .Value = SelectedPrescriptionID;
                            deleteItems.Parameters.Add("@DoctorID", SqlDbType.Int)
                                .Value = CurrentDoctorID;

                            deleteItems.ExecuteNonQuery();
                        }

                        // Then delete the prescription header.
                        using (SqlCommand deletePrescription = new SqlCommand(@"
                            DELETE FROM Prescriptions
                            WHERE PrescriptionID = @PrescriptionID
                                AND DoctorID = @DoctorID;", con, transaction))
                        {
                            deletePrescription.Parameters.Add("@PrescriptionID", SqlDbType.Int)
                                .Value = SelectedPrescriptionID;
                            deletePrescription.Parameters.Add("@DoctorID", SqlDbType.Int)
                                .Value = CurrentDoctorID;

                            if (deletePrescription.ExecuteNonQuery() == 0)
                                throw new Exception("The prescription could not be found.");
                        }

                        transaction.Commit();

                        SelectedPrescriptionID = 0;
                        gvPrescriptions.SelectedIndex = -1;
                        pnlPrescriptionDetails.Visible = false;
                        pnlEditItem.Visible = false;

                        LoadPrescriptions();

                        ShowSuccess("Prescription and all its medicine items were deleted successfully.");
                    }
                    catch (Exception ex)
                    {
                        try { transaction.Rollback(); } catch { }
                        ShowError(ex.Message);
                    }
                }
            }
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

        private void ClearMessages()
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
        }
    }
}
