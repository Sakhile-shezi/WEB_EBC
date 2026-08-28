using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private
{
    public partial class Private1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Access your form values directly via ID
            string patientName = txtPatientName.Text;
            string dob = txtPatientDob.Text;
            string medication = txtMedication.Text;
            string dosage = txtDosage.Text;
            string frequency = txtFrequency.Text;
            string instructions = txtInstructions.Text;

            // Add saving logic here
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/DoctorDashboard.aspx");
        }
    }
}