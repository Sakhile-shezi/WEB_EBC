using Microsoft.AspNet.Identity;
using System;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Patient
{
    // The patient's own history: every appointment, newest first, each with its receipt.
    public partial class History : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Only the signed-in account's appointments are ever listed.
            SqlDataSourceHistory.SelectParameters["UserId"].DefaultValue =
                User.Identity.GetUserId() ?? "";
        }

        protected void GridViewHistory_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id;
            if (e.CommandName != "Receipt" ||
                !int.TryParse(Convert.ToString(e.CommandArgument), out id))
                return;

            if (!ReceiptViewer1.Show(id))
            {
                lblHistoryMessage.Text = "That appointment could not be found.";
                lblHistoryMessage.ForeColor = Color.Red;
            }
        }

        protected string StatusCss(object status)
        {
            string value = Convert.ToString(status).Trim().ToUpperInvariant();
            if (value == "SCHEDULED") return "ph-status scheduled";
            if (value == "CANCELLED") return "ph-status cancelled";
            return "ph-status";
        }
    }
}
