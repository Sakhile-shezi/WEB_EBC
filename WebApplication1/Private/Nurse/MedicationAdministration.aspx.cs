
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Nurse
{
    public partial class MedicationAdministration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only logged-in nurses may access this page.
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login");
                return;
            }

            if (!User.IsInRole("Nurse"))
            {
                Response.Redirect("~/");
                return;
            }

            if (!IsPostBack)
            {
                pnlSelectedDetails.Visible = false;
                DetailsView2.Visible = false;

                GVMedicationAdmin.DataBind();
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            // Clear the previous selection when searching again.
            GVMedicationAdmin.SelectedIndex = -1;
            GVMedicationAdmin.PageIndex = 0;

            GVAdministrationHistory.SelectedIndex = -1;
            GVAdministrationHistory.PageIndex = 0;

            pnlSelectedDetails.Visible = false;
            DetailsView2.Visible = false;

            GVMedicationAdmin.DataBind();
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            TBPatient.Text = "";
            TBDate.Text = "";

            GVMedicationAdmin.SelectedIndex = -1;
            GVMedicationAdmin.PageIndex = 0;

            GVAdministrationHistory.SelectedIndex = -1;
            GVAdministrationHistory.PageIndex = 0;

            pnlSelectedDetails.Visible = false;
            DetailsView2.Visible = false;

            GVMedicationAdmin.DataBind();
        }

        protected void GVMedicationAdmin_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            // A prescription item has been selected.
            pnlSelectedDetails.Visible = true;

            GVAdministrationHistory.SelectedIndex = -1;
            GVAdministrationHistory.PageIndex = 0;

            DetailsView2.Visible = false;

            GVAdministrationHistory.DataBind();
            DetailsView1.DataBind();
        }

        protected void GVMedicationAdmin_PageIndexChanging(
            object sender, GridViewPageEventArgs e)
        {
            // Do not keep showing details for a row on another page.
            GVMedicationAdmin.SelectedIndex = -1;

            pnlSelectedDetails.Visible = false;
            DetailsView2.Visible = false;

            GVAdministrationHistory.SelectedIndex = -1;
        }

        protected void GVAdministrationHistory_SelectedIndexChanged(
            object sender, EventArgs e)
        {
            // An individual administration record has been selected.
            DetailsView2.Visible = true;
            DetailsView2.DataBind();
        }
    }
}
