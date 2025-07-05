using System;

namespace SmsPortalForms.SystemOperatorDashboard
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Operator"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            lblOperator.Text = Session["Operator"].ToString();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login/Login.aspx");
        }
    }
}
