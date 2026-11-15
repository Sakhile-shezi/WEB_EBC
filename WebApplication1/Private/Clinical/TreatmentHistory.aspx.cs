


using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Clinical
{
    public partial class TreatmentHistory : System.Web.UI.Page
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
                LoadTreatmentFilter();
                LoadHistory();
            }
        }

        private void LoadTreatmentFilter()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT treatmentID, FullName
                    FROM Treatment
                    ORDER BY FullName;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlTreatmentFilter.DataSource = reader;
                        ddlTreatmentFilter.DataTextField = "FullName";
                        ddlTreatmentFilter.DataValueField = "treatmentID";
                        ddlTreatmentFilter.DataBind();
                    }
                }
            }

            ddlTreatmentFilter.Items.Insert(
                0, new ListItem("-- All Treatments --", ""));
        }

        private void LoadHistory()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT
                        TI.treatmentInformationID,
                        P.FullName AS PatientName,
                        T.FullName AS TreatmentName,
                        TI.perfomed_at,

                        STUFF((
                            SELECT ', ' + D.FullName
                            FROM TreatmentInformationStaff TS
                            INNER JOIN Doctor D
                                ON TS.DoctorID = D.DoctorID
                            WHERE TS.treatmentInformationID =
                                TI.treatmentInformationID
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                        AS DoctorNames,

                        STUFF((
                            SELECT ', ' + N.FullName
                            FROM TreatmentInformationStaff TS
                            INNER JOIN Nurse N
                                ON TS.NurseID = N.NurseID
                            WHERE TS.treatmentInformationID =
                                TI.treatmentInformationID
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                        AS NurseNames,

                        STUFF((
                            SELECT ', ' + StaffName
                            FROM
                            (
                                SELECT D.FullName AS StaffName
                                FROM TreatmentInformationStaff TS
                                INNER JOIN Doctor D
                                    ON TS.DoctorID = D.DoctorID
                                WHERE TS.treatmentInformationID =
                                    TI.treatmentInformationID

                                UNION ALL

                                SELECT N.FullName AS StaffName
                                FROM TreatmentInformationStaff TS
                                INNER JOIN Nurse N
                                    ON TS.NurseID = N.NurseID
                                WHERE TS.treatmentInformationID =
                                    TI.treatmentInformationID
                            ) StaffMembers
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                        AS StaffNames

                    FROM TreatmentInformation TI

                    INNER JOIN Pro_Appointment A
                        ON TI.appointmentID = A.AppointmentID

                    INNER JOIN Patient P
                        ON A.PatientID = P.PatientID

                    INNER JOIN Treatment T
                        ON TI.treatmentID = T.treatmentID

                    WHERE
                        (@PatientName = ''
                            OR P.FullName LIKE '%' + @PatientName + '%')

                        AND
                        (@TreatmentID IS NULL
                            OR TI.treatmentID = @TreatmentID)

                        AND
                        (@DateFrom IS NULL
                            OR TI.perfomed_at >= @DateFrom)

                        AND
                        (@DateTo IS NULL
                            OR TI.perfomed_at < DATEADD(DAY, 1, @DateTo))

                    ORDER BY TI.perfomed_at DESC;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@PatientName", SqlDbType.VarChar, 255)
                        .Value = txtPatientSearch.Text.Trim();

                    if (string.IsNullOrEmpty(
                        ddlTreatmentFilter.SelectedValue))
                    {
                        cmd.Parameters.Add(
                            "@TreatmentID", SqlDbType.Int)
                            .Value = DBNull.Value;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@TreatmentID", SqlDbType.Int)
                            .Value = Convert.ToInt32(
                                ddlTreatmentFilter.SelectedValue);
                    }

                    DateTime dateFrom;
                    DateTime dateTo;

                    if (DateTime.TryParse(
                        txtDateFrom.Text, out dateFrom))
                    {
                        cmd.Parameters.Add(
                            "@DateFrom", SqlDbType.SmallDateTime)
                            .Value = dateFrom.Date;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@DateFrom", SqlDbType.SmallDateTime)
                            .Value = DBNull.Value;
                    }

                    if (DateTime.TryParse(
                        txtDateTo.Text, out dateTo))
                    {
                        cmd.Parameters.Add(
                            "@DateTo", SqlDbType.SmallDateTime)
                            .Value = dateTo.Date;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@DateTo", SqlDbType.SmallDateTime)
                            .Value = DBNull.Value;
                    }

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        adapter.Fill(dt);

                        gvTreatmentHistory.DataSource = dt;
                        gvTreatmentHistory.DataBind();
                    }
                }
            }
        }

        private void LoadTreatmentDetails(int recordID)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT
                        TI.treatmentInformationID,
                        P.FullName AS PatientName,
                        T.FullName AS TreatmentName,
                        TI.perfomed_at,
                        TI.diagnosis,
                        TI.results,
                        TI.notes,
                        TI.perfomedBy AS RecordedBy,

                        A.AppointmentID,
                        A.AppointmentReason,
                        A.AppointmentDate,
                        A.AppointmentStatus,

                        STUFF((
                            SELECT ', ' + D.FullName
                            FROM TreatmentInformationStaff TS
                            INNER JOIN Doctor D
                                ON TS.DoctorID = D.DoctorID
                            WHERE TS.treatmentInformationID =
                                TI.treatmentInformationID
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                        AS DoctorNames,

                        STUFF((
                            SELECT ', ' + N.FullName
                            FROM TreatmentInformationStaff TS
                            INNER JOIN Nurse N
                                ON TS.NurseID = N.NurseID
                            WHERE TS.treatmentInformationID =
                                TI.treatmentInformationID
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
                        AS NurseNames

                    FROM TreatmentInformation TI

                    INNER JOIN Pro_Appointment A
                        ON TI.appointmentID = A.AppointmentID

                    INNER JOIN Patient P
                        ON A.PatientID = P.PatientID

                    INNER JOIN Treatment T
                        ON TI.treatmentID = T.treatmentID

                    WHERE TI.treatmentInformationID = @RecordID;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@RecordID", SqlDbType.Int).Value = recordID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblDetailRecordID.Text =
                                SafeText(reader["treatmentInformationID"]);

                            lblDetailPatient.Text =
                                SafeText(reader["PatientName"]);

                            lblDetailTreatment.Text =
                                SafeText(reader["TreatmentName"]);

                            lblDetailDate.Text =
                                FormatDate(reader["perfomed_at"]);

                            lblDetailDiagnosis.Text =
                                SafeText(reader["diagnosis"]);

                            lblDetailResults.Text =
                                SafeText(reader["results"]);

                            lblDetailNotes.Text =
                                SafeText(reader["notes"]);

                            lblDetailRecordedBy.Text =
                                SafeText(reader["RecordedBy"]);

                            lblDetailAppointment.Text =
                                SafeText(reader["AppointmentID"]) +
                                " | " +
                                SafeText(reader["AppointmentReason"]) +
                                " | " +
                                FormatDate(reader["AppointmentDate"]) +
                                " | " +
                                SafeText(reader["AppointmentStatus"]);

                            lblDetailDoctors.Text =
                                EmptyFallback(reader["DoctorNames"]);

                            lblDetailNurses.Text =
                                EmptyFallback(reader["NurseNames"]);

                            pnlTreatmentDetails.Visible = true;
                        }
                        else
                        {
                            pnlTreatmentDetails.Visible = false;
                        }
                    }
                }
            }
        }

        private string SafeText(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not recorded";

            string result = value.ToString();

            if (string.IsNullOrWhiteSpace(result))
                return "Not recorded";

            return Server.HtmlEncode(result);
        }

        private string EmptyFallback(object value)
        {
            if (value == null || value == DBNull.Value ||
                string.IsNullOrWhiteSpace(value.ToString()))
            {
                return "No participating staff recorded.";
            }

            return Server.HtmlEncode(value.ToString());
        }

        private string FormatDate(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not recorded";

            DateTime date;

            if (DateTime.TryParse(value.ToString(), out date))
                return date.ToString("dd MMM yyyy HH:mm");

            return SafeText(value);
        }

        protected void gvTreatmentHistory_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            if (gvTreatmentHistory.SelectedDataKey == null)
                return;

            int recordID = Convert.ToInt32(
                gvTreatmentHistory.SelectedDataKey.Value);

            LoadTreatmentDetails(recordID);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvTreatmentHistory.PageIndex = 0;
            gvTreatmentHistory.SelectedIndex = -1;
            pnlTreatmentDetails.Visible = false;

            LoadHistory();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtPatientSearch.Text = "";
            txtDateFrom.Text = "";
            txtDateTo.Text = "";

            ddlTreatmentFilter.SelectedIndex = 0;

            gvTreatmentHistory.PageIndex = 0;
            gvTreatmentHistory.SelectedIndex = -1;
            pnlTreatmentDetails.Visible = false;

            LoadHistory();
        }

        protected void gvTreatmentHistory_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            gvTreatmentHistory.PageIndex = e.NewPageIndex;
            gvTreatmentHistory.SelectedIndex = -1;
            pnlTreatmentDetails.Visible = false;

            LoadHistory();
        }
    }
}
