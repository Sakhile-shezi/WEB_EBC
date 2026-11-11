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
        // Retrieves the connection string defined in your Web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTodayDate.Text = DateTime.Today.ToString("dd MMMM yyyy");
                LoadDailyAppointments();
            }
        }

        private void LoadDailyAppointments()
        {
            try
            {
                // Get the currently logged-in user's identity ID
                string currentUserId = User.Identity.GetUserId();

                if (string.IsNullOrEmpty(currentUserId))
                {
                    lblErrorMessage.Text = "Error: User is not authenticated.";
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            a.[AppointmentID],
                            a.[TimeSlots],
                            p.[FullName] AS PatientName,
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

                        // Use DateTime.Today to automatically filter by the current day
                        cmd.Parameters.AddWithValue("@TargetDate", DateTime.Today.Date);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            gvAppointments.DataSource = dt;
                            gvAppointments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception (ex) in a real-world scenario
                lblErrorMessage.Text = "An error occurred while loading your schedule. Please contact IT support.";
            }
        }

        protected void btnViewConsultation_Click(object sender, EventArgs e)
        {
            // Extract the AppointmentID from the clicked button's CommandArgument
            LinkButton btn = (LinkButton)sender;
            string appointmentId = btn.CommandArgument;

            // Redirect the doctor to the detailed consultation page for that specific appointment
            Response.Redirect($"PatientDetails.aspx?AppointmentID={appointmentId}");
        }
    }
}