using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmsPortalForms.VendorAdminDashboard
{
    public partial class VendorAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check session
                if (Session["VendorAdmin"] == null)
                {
                    Response.Redirect("~/Login/Login.aspx");
                    return;
                }

                lblVendorName.Text = Session["VendorName"].ToString();
                LoadDashboardData();
                RegisterUserModalScripts();
            }
            if (hdnShowUserModal.Value == "true")
            {
                string script = @"
        setTimeout(function () {
            openUserModal();
            setTimeout(function () {
                closeUserModal();
            }, 6000);
        }, 100);";
ClientScript.RegisterStartupScript(this.GetType(), "ShowUserModalWithFadeOut", script, true); hdnShowUserModal.Value = "false";
 }
}

        private void LoadDashboardData()
        {
            lblTotalSent.Text = "1,245";
            lblFailed.Text = "23";
            lblCredits.Text = "500";
        }

        protected void lnkDashboard_Click(object sender, EventArgs e)
        {
            ShowPanel("dashboard");
            SetActiveNav((LinkButton)sender);
        }

        protected void lnkSmsHistory_Click(object sender, EventArgs e)
        {
            ShowPanel("history");
            SetActiveNav((LinkButton)sender);
            LoadSmsHistory();
        }

        protected void lnkReports_Click(object sender, EventArgs e)
        {
            ShowPanel("reports");
            SetActiveNav((LinkButton)sender);
        }

        private void ShowPanel(string panelName)
        {
            pnlDashboard.Visible = panelName == "dashboard";
            pnlSmsHistory.Visible = panelName == "history";
            pnlReports.Visible = panelName == "reports";
        }

        private void SetActiveNav(LinkButton activeLink)
        {
            lnkDashboard.CssClass = "nav-item";
            lnkSmsHistory.CssClass = "nav-item";
            lnkReports.CssClass = "nav-item";
            activeLink.CssClass = "nav-item active";
        }

        private void LoadSmsHistory()
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login/Login.aspx");
        }

        //  Create Vendor User
        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            string username = txtUserUsername.Text.Trim();
            string email = txtUserEmail.Text.Trim();
            string password = txtUserPassword.Text.Trim();
            string vendorName = Session["VendorName"]?.ToString(); 

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                
                return;
            }

            if (!IsValidEmail(email))
            {
                return;
            }

            if (password.Length < 6 || !password.Any(char.IsLetter) || !password.Any(char.IsDigit))
            {
                lblUserMessage.Text = "Password must be at least 6 characters long and contain both letters and numbers.";
                lblUserMessage.CssClass = "message-label error-message";
                hdnShowUserModal.Value = "true";
                return;
            }

            if(string.IsNullOrWhiteSpace(vendorName))
                return;

            try
            {
                var api = new SMSPORTALAPI.SmsportalApi();
                string checkResult = api.CheckDuplicateVendorUser(username, email);

                if (checkResult == "UsernameExists")
                {
                    lblUserMessage.Text = "Username already exists.";
                    lblUserMessage.CssClass = "message-label error-message";
                    hdnShowUserModal.Value = "true";
                    return;
                }
                else if (checkResult == "EmailExists") 
                {
                    lblUserMessage.Text = "Email already exists.";
                    lblUserMessage.CssClass = "message-label error-message";
                    hdnShowUserModal.Value = "true";
                    return;
                }

                // Hash password
                byte[] passwordHash;
                using (var sha = new System.Security.Cryptography.SHA256Managed())
                {
                    passwordHash = sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                }

                // Create vendor user
                string result = api.CreateVendorUser(vendorName, username, email, passwordHash);

                // Send email
                SendEmail(email, "Your Vendor User Account Has Been Created",
       $"Dear {username},\nYour Vedor user account has been created successfully.\nYou can login with the following credentials please" +
                    $"\nEmail: {email}\nPassword: {password}");

                // Show success message
                lblUserMessage.Text = "Vendor user created successfully.";
                lblUserMessage.CssClass = "message-label success-message";
                hdnShowUserModal.Value = "true";

                // Clear form fields
                txtUserUsername.Text = "";
                txtUserEmail.Text = "";
                txtUserPassword.Text = "";
            }

            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error creating vendor user: " + ex.Message);
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

        private void RegisterUserModalScripts()
        {
            string script = @"
                <script type='text/javascript'>
                    function openUserModal() {
                        document.getElementById('userModal').style.display = 'block';
                    }

                    function closeUserModal() {
                        document.getElementById('userModal').style.display = 'none';
                    }

                    window.onclick = function(event) {
                        var modal = document.getElementById('userModal');
                        if (event.target == modal) {
                            modal.style.display = 'none';
                        }
                    };
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "UserModalScript", script, false);
        }

    }
}
