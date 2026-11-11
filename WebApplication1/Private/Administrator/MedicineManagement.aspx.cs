using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.Private.Administrator
{
    public partial class MedicineManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnMedAdd_Click(object sender, EventArgs e)
        {
            SqlDSmedicine.Insert();
        }
    }
}