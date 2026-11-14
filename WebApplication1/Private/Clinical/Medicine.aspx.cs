
using System;
using System.Web.UI;

namespace WebApplication1.Private
{
    public partial class Medicine : System.Web.UI.Page
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

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            GVMedicine.PageIndex = 0;
            GVMedicine.DataBind();
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            TBMedicine.Text = "";

            GVMedicine.PageIndex = 0;
            GVMedicine.DataBind();
        }
    }
}
