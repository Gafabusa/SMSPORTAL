using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using SmsPortalForms.SMSPORTALAPI;

namespace SmsPortalForms.Login
{
    public partial class Login : System.Web.UI.Page
    {
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            byte[] passwordHash = HashPassword(password);

            SmsportalApi api = new SmsportalApi();

            // 1. Try login as System Operator
            DataTable dt = api.LoginSystemOperator(email, passwordHash);
            if (dt != null && dt.Rows.Count > 0)
            {
                Session["Operator"] = dt.Rows[0]["username"].ToString();
                Response.Redirect("/SystemOperatorDashboard/OperatorDashboard.aspx");
                return;
            }
                

            // 2. Try login as VendorAdmin
            DataTable dt1 = api.LoginVendorAdmin(email, passwordHash);
            if (dt1 !=null && dt1.Rows.Count >0)
                    {
                Session["VendorAdmin"] = dt1.Rows[0]["Email"].ToString();  
                Session["VendorName"] = dt1.Rows[0]["VendorName"].ToString();
                Response.Redirect("/VendorAdminDashboard/VendorAdmin.aspx");
                return;
            }
                       
            // 3. Try login as VendorUser
            DataTable dt2 = api.ValidateVendorUserByEmail(email, passwordHash);
            if (dt2 != null && dt2.Rows.Count > 0)
            {
                Session["VendorUser"] = email;
                Session["username"] = dt2.Rows[0]["Username"].ToString();
                Response.Redirect("/User/VendorUser.aspx");
                return;
            }


            // 4. If both fail
            lblMessage.Text = "Invalid email or password.";
        }


        private byte[] HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                return sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            }
        }
    }
}
