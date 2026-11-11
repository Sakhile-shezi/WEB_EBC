using Microsoft.AspNet.Identity;
using System;
using System.Web.UI;

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

            // Use the logged-in Doctor's Identity ID.
            SqlDSPrescription.SelectParameters["id"].DefaultValue =
                User.Identity.GetUserId();

            // Load today's date on the initial page load.
            if (!IsPostBack)
            {
                TBDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            // Clear the selected prescription when performing a new search.
            GridView1.SelectedIndex = -1;

            // Refresh the prescription list.
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

                GridView2.DataBind();
            }
        }
    }
}