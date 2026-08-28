using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private
{
    public partial class Private2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }
        private void LoadDashboardData()
        {
            // Bind stats dynamically
            lblDoctorName.Text = "Dr. Smith";
            lblTodayAppointments.Text = "12";
            lblPendingPrescriptions.Text = "5";
            lblTotalPatients.Text = "148";

            // Bind appointments table
            var appointments = new List<Appointment>
            {
                new Appointment { PatientID = 101, Time = "09:00 AM", PatientName = "John Smith", Reason = "Routine Checkup", Status = "Confirmed", StatusClass = "confirmed" },
                new Appointment { PatientID = 102, Time = "10:30 AM", PatientName = "Amanda Naidoo", Reason = "Follow-up", Status = "Pending", StatusClass = "pending" },
                new Appointment { PatientID = 103, Time = "11:15 AM", PatientName = "Michael Dlamini", Reason = "Blood Test Results", Status = "Confirmed", StatusClass = "confirmed" },
                new Appointment { PatientID = 104, Time = "01:30 PM", PatientName = "Lebo Mkhize", Reason = "Burn Injury", Status = "Confirmed", StatusClass = "confirmed" },
                new Appointment { PatientID = 105, Time = "02:45 PM", PatientName = "Emily Watson", Reason = "Prescription Refill", Status = "Confirmed", StatusClass = "confirmed" },
                new Appointment { PatientID = 106, Time = "03:30 PM", PatientName = "Liam Parker", Reason = "General Consultation", Status = "Pending", StatusClass = "pending" }
            };

            gvAppointments.DataSource = appointments;
            gvAppointments.DataBind();
        }

        protected void gvAppointments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewChart")
            {
                string patientId = e.CommandArgument.ToString();
                Response.Redirect($"~/PatientChart.aspx?id={patientId}");
            }
        }
    }

    public class Appointment
    {
        public int PatientID { get; set; }
        public string Time { get; set; }
        public string PatientName { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
        public string StatusClass { get; set; }
    }
}