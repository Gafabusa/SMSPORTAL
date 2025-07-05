using System;
using System.Data;

namespace SmsPortalForms.SystemOperatorDashboard.ManageVendors
{
    public partial class EditVendorAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string vendorIdStr = Request.QueryString["vendorId"];
                if (!string.IsNullOrEmpty(vendorIdStr))
                {
                    int vendorId = int.Parse(vendorIdStr);
                    hdnVendorID.Value = vendorIdStr;
                    LoadVendorDetails(vendorId);
                }
            }
        }

        private void LoadVendorDetails(int vendorId)
        {
            var api = new SMSPORTALAPI.SmsportalApi();
            DataTable dt = api.GetVendorAdminById(vendorId);
            if (dt != null && dt.Rows.Count > 0)
            {
                txtVendorName.Text = dt.Rows[0]["VendorName"].ToString();
                txtUserName.Text = dt.Rows[0]["UserName"].ToString();
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int vendorId = int.Parse(hdnVendorID.Value);
            string vendorName = txtVendorName.Text.Trim();
            string userName = txtUserName.Text.Trim();
            string email = txtEmail.Text.Trim();

            var api = new SMSPORTALAPI.SmsportalApi();
            api.UpdateVendorAdmin(vendorId, vendorName, userName, email);

            Response.Redirect("~/SystemOperatorDashboard/ManageVendors/ViewVendorAdmins.aspx");
        }
    }
}
