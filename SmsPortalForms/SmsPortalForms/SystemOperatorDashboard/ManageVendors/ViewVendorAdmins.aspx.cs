using System;
using System.Data;
using System.Web.UI.WebControls;

namespace SmsPortalForms.SystemOperatorDashboard.ManageVendors
{
    public partial class ViewVendorAdmins : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadVendorAdmins();
            }
        }

        private void LoadVendorAdmins()
        {
            try
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                DataTable dt = api.GetAllVendorAdmins();
                gvVendors.DataSource = dt;
                gvVendors.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading vendor admins: " + ex.Message);
            }
        }

        protected void gvVendors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int vendorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditVendor")
            {
                Response.Redirect($"EditVendorAdmin.aspx?vendorId={vendorId}");
            }
            else if (e.CommandName == "DeleteVendor")
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                api.DeleteVendorAdmin(vendorId);
                LoadVendorAdmins(); // Refresh table
            }
            else if (e.CommandName == "UnlockVendor")
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                api.UnlockVendorAdmin(vendorId);
                LoadVendorAdmins(); // Refresh table
            }
        }
    }
}
