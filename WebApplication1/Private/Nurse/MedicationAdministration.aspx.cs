using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Nurse
{
    public partial class MedicationAdministration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        //    SqlDSMedAdmin.SelectParameters["id"].DefaultValue =
        //        User.Identity.GetUserId();
        }

        protected void TBPatient_TextChanged(object sender, EventArgs e)
        {

        }

        protected void BtnMedAdminRecord_Click(object sender, EventArgs e)
        {
            SqlDSRecordMedAdmin.InsertParameters["Admnistered_at"].DefaultValue = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            SqlDSRecordMedAdmin.Insert();
            lblStatus.Text = "Medication administration record inserted successfully.";
        }
    }
}