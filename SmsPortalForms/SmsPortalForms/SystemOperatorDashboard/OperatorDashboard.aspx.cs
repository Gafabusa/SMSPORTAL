using System;
using System.Linq;

namespace SmsPortalForms.SystemOperatorDashboard
{
    public partial class OperatorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack && hdnShowModal.Value == "true")
            {
                string script = "setTimeout(function() { openVendorModal(); }, 100);";
                ClientScript.RegisterStartupScript(this.GetType(), "ReopenModal", script, true);
                hdnShowModal.Value = "false";
            }
        }

        protected void btnCreateVendorAdmin_Click(object sender, EventArgs e)
        {
            string vendorName = txtVendorName.Text.Trim();
            string userName = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(vendorName) || string.IsNullOrWhiteSpace(userName) ||
                string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password) ||
                !IsValidEmail(email) || password.Length < 6 || !password.Any(char.IsLetter) || !password.Any(char.IsDigit))
            {
                hdnShowModal.Value = "true";
                return;
            }

            try
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                api.sp_CreateVendorAdmin(vendorName, userName, email, password);

                string subject = "Your Vendor Admin Account Has Been Created \n";
                string body = $@"
Dear {userName}\n,Your vendor admin account has been successfully created.\nYou can now log in using the following credentials:\n

Email: {email}
Password: {password}
Regards,
SMS Portal Team";

                SendEmail(email, subject, body);

                txtVendorName.Text = "";
                txtUsername.Text = "";
                txtEmail.Text = "";
                txtPassword.Text = "";
            }
            catch (Exception ex)
            {
                hdnShowModal.Value = "true";
                System.Diagnostics.Debug.WriteLine("Create vendor error: " + ex.Message);
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                var message = new System.Net.Mail.MailMessage();
                message.From = new System.Net.Mail.MailAddress("willygafabusa@gmail.com", "SMS Portal");
                message.To.Add(new System.Net.Mail.MailAddress(toEmail));
                message.Subject = subject;
                message.Body = body;
                message.IsBodyHtml = false;

                var smtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                smtpClient.Credentials = new System.Net.NetworkCredential("willygafabusa@gmail.com", "nixl jyks zbay mvkg");
                smtpClient.EnableSsl = true;

                smtpClient.Send(message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Email sending error: " + ex.Message);
            }
        }
    }
}
