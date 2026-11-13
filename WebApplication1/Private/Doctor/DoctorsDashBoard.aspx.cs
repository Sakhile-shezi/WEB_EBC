using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Microsoft.AspNet.Identity;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Doctor
{
    public partial class DoctorsDashBoard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDoctorProfile();
                txtDateFilter.Text = DateTime.Today.ToString("yyyy-MM-dd");
                lblDisplayDate.Text = DateTime.Today.ToString("yyyy/MM/dd");

                LoadAppointmentsByDate(DateTime.Today);
            }
        }

        private void LoadDoctorProfile()
        {
            string currentUserId = User.Identity.GetUserId();
            if (string.IsNullOrEmpty(currentUserId)) return;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FullName FROM [dbo].[Doctor] WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", currentUserId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null) lblDoctorName.Text = result.ToString();
                }
            }
        }

        protected void txtDateFilter_TextChanged(object sender, EventArgs e)
        {
            if (DateTime.TryParse(txtDateFilter.Text, out DateTime selectedDate))
            {
                lblDisplayDate.Text = selectedDate.ToString("yyyy/MM/dd");
                LoadAppointmentsByDate(selectedDate);
            }
        }

        protected void btnToday_Click(object sender, EventArgs e)
        {
            txtDateFilter.Text = DateTime.Today.ToString("yyyy-MM-dd");
            lblDisplayDate.Text = DateTime.Today.ToString("yyyy/MM/dd");
            LoadAppointmentsByDate(DateTime.Today);
        }

        private void LoadAppointmentsByDate(DateTime targetDate)
        {
            try
            {
                string currentUserId = User.Identity.GetUserId();
                if (string.IsNullOrEmpty(currentUserId)) return;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            a.[AppointmentID],
                            a.[TimeSlots],
                            p.[FullName] AS PatientName,
                            CONCAT(DATEDIFF(YEAR, p.[DateOfBirth], GETDATE()), ' / ', COALESCE(NULLIF(LEFT(p.[Gender], 1), ''), 'U')) AS AgeGender,
                            a.[AppointmentReason],
                            a.[AppointmentStatus]
                        FROM 
                            [dbo].[Pro_Appointment] a
                        INNER JOIN 
                            [dbo].[Patient] p ON a.[PatientID] = p.[PatientID]
                        INNER JOIN 
                            [dbo].[Doctor] d ON a.[DoctorID] = d.[DoctorID]
                        INNER JOIN 
                            [dbo].[AspNetUsers] u ON d.[UserId] = u.[Id]
                        WHERE 
                            u.[Id] = @CurrentUserId 
                            AND CAST(a.[AppointmentDate] AS DATE) = @TargetDate
                        ORDER BY 
                            a.[TimeSlots] ASC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserId", currentUserId);
                        cmd.Parameters.AddWithValue("@TargetDate", targetDate.Date);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            gvAppointments.DataSource = dt;
                            gvAppointments.DataBind();

                            lblTotalCount.Text = dt.Rows.Count.ToString();
                            lblCompletedCount.Text = dt.Select("AppointmentStatus = 'Completed'").Length.ToString();
                            lblInProgressCount.Text = dt.Select("AppointmentStatus = 'In Progress'").Length.ToString();
                            lblPendingCount.Text = dt.Select("AppointmentStatus = 'Scheduled' OR AppointmentStatus = 'Waiting'").Length.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "An error occurred: " + ex.Message;
            }
        }

        protected void btnViewConsultation_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string appointmentId = btn.CommandArgument;
            Response.Redirect($"PatientDetails.aspx?AppointmentID={appointmentId}");
        }

        protected void gvAppointments_PreRender(object sender, EventArgs e)
        {
            if (gvAppointments.Rows.Count > 0)
            {
                gvAppointments.UseAccessibleHeader = true;
                gvAppointments.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }
    }
}