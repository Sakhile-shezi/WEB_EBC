
using System;
using System.Web.UI;

namespace WebApplication1.Private.Clinical
{
    public partial class MedicineManagement : System.Web.UI.Page
    {
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
        }

        protected void BtnMedAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                SqlDSmedicine.Insert();

                TBNewMed.Text = "";

                GVMedicine.DataBind();

                lblError.Text = "";
                lblStatus.Text = "Medicine added successfully.";
            }
            catch (Exception)
            {
                lblStatus.Text = "";
                lblError.Text =
                    "The medicine could not be added. Please check the details and try again.";
            }
        }
    }
}
