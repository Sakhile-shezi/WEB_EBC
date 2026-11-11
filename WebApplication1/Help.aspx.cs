using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1
{
    public partial class Help : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSubmitQuery_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string fullName = txtFullName.Text.Trim();
                string contact = txtContact.Text.Trim();
                string queryType = ddlQueryType.SelectedValue;
                string message = txtMessage.Text.Trim();

                // Note: Ensure "DefaultConnection" matches your Web.config connection string name
                string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                string query = "INSERT INTO SupportQueries (FullName, ContactInfo, QueryType, Message, DateSubmitted) VALUES (@FullName, @ContactInfo, @QueryType, @Message, GETDATE())";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@ContactInfo", contact);
                        cmd.Parameters.AddWithValue("@QueryType", queryType);
                        cmd.Parameters.AddWithValue("@Message", message);
                        try
                        {
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            lblSuccessMessage.Text = "Query submitted successfully!";
                            lblSuccessMessage.Visible = true;
                            txtFullName.Text = ""; txtContact.Text = ""; txtMessage.Text = "";
                        }
                        catch (Exception)
                        {
                            lblSuccessMessage.Text = "An error occurred while saving your query.";
                            lblSuccessMessage.Visible = true;
                            lblSuccessMessage.Style["background"] = "#ffebee";
                            lblSuccessMessage.Style["color"] = "#c62828";
                        }
                    }
                }
            }
        }
    }
}