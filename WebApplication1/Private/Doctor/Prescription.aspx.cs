using Microsoft.AspNet.Identity;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Doctor
{
    public partial class Prescription : System.Web.UI.Page
    {
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

            // Get the logged-in Doctor's Identity ID.
            string userId = User.Identity.GetUserId();

            // Supply the Identity ID to the prescription query.
            SqlDSPrescription.SelectParameters["id"].DefaultValue = userId;

            // Load prescriptions immediately on the initial page visit.
            if (!IsPostBack)
            {
                GridView2.Visible = false;
                GridView1.DataBind();
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            // Clear the previously selected prescription.
            GridView1.SelectedIndex = -1;

            // Refresh the prescription records using the supplied filters.
            GridView1.DataBind();

            // Refresh the details table.
            GridView2.DataBind();

            lblDetails.Text =
                "Select a prescription above to view its medicine details.";
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (GridView1.SelectedIndex >= 0)
            {
                lblDetails.Text =
                    "Showing medicine details for prescription #" +
                    GridView1.SelectedValue.ToString();
                GridView2.Visible = true;

                GridView2.DataBind();
            }
        }
        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Clear the previously selected prescription.
            GridView1.SelectedIndex = -1;

            // Reset the prescription details.
            GridView2.DataBind();

            lblDetails.Text =
                "Select a prescription above to view its medicine details.";
        }
    }
}