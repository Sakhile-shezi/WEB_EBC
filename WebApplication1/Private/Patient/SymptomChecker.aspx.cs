using System;
using System.Web.UI;

namespace WebApplication1.Private.Patient
{
    /// <summary>
    /// Symptom checker for patients.
    /// The whole checker runs in the browser (see the script in
    /// SymptomChecker.aspx). It does not use the database and does not
    /// store what the patient types.
    /// </summary>
    public partial class SymptomChecker : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}
