using SmsPortalClassLibrary.ControlObjects;
using System;
using System.Linq;

namespace SmsPortalForms.SystemOperatorDashboard
{
    public partial class OperatorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
                lblMessage.CssClass = "";
            }

            if (hdnShowModal.Value == "true")
            {
                // show modal and fade it out after 3 seconds
                string script = @"
            setTimeout(function () {
                openVendorModal();
                setTimeout(function () {
                    closeVendorModal();
                }, 3000);
            }, 100);";

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModalWithFadeOut", script, true);

                // clear the value to avoid showing modal again on next load
                hdnShowModal.Value = "false";
            }
        }


        protected void btnCreateVendorAdmin_Click(object sender, EventArgs e)
        {
            string vendorName = txtVendorName.Text.Trim();
            string userName = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            lblMessage.Text = ""; // Clear previous message

            if (string.IsNullOrWhiteSpace(vendorName) || string.IsNullOrWhiteSpace(userName) ||
                string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "All fields are required.";
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
                return;
            }

            if (!IsValidEmail(email))
            {
                lblMessage.Text = "Invalid email format.";
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
                return;
            }

            if (password.Length < 6 || !password.Any(char.IsLetter) || !password.Any(char.IsDigit))
            {
                lblMessage.Text = "Password must be at least 6 characters, with letters and numbers.";
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
                return;
            }

            var logic = new BusinessLogic();
            string checkResult = logic.CheckDuplicateVendor(vendorName, email);

            if (checkResult == "VendorNameExists")
            {
                lblMessage.Text = "Vendor name already exists.";
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
                return;
            }
            else if (checkResult == "EmailExists")
            {
                lblMessage.Text = "Email already exists.";
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
                return;
            }

            try
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                api.sp_CreateVendorAdmin(vendorName, userName, email, password);

                SendEmail(email, "Your Vendor Admin Account Has Been Created",
                    $"Dear {userName},\nYour Vedor admin account has been created successfully.\nYou can login with the following credentials please" +
                    $"\nEmail: {email}\nPassword: {password}");

                txtVendorName.Text = "";
                txtUsername.Text = "";
                txtEmail.Text = "";
                txtPassword.Text = "";
                lblMessage.Text = "Vendor created successfully.";
                lblMessage.CssClass = "message-label success-message";
                hdnShowModal.Value = "true";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred while creating vendor: " + ex.Message;
                lblMessage.CssClass = "message-label error-message";
                hdnShowModal.Value = "true";
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
