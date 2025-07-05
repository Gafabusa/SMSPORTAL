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
                // Optionally: show error message
                return;
            }

            if(string.IsNullOrWhiteSpace(vendorName))
                return;

            try
            {
                byte[] passwordHash;
                using (var sha = new System.Security.Cryptography.SHA256Managed())
                {
                    passwordHash = sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                }

                var api = new SMSPORTALAPI.SmsportalApi();
                string result = api.CreateVendorUser(vendorName, username, email, passwordHash);
                // 1. Prepare email content
                string subject = "Your Vendor User Account Has Been Created \n";
                string body = $@"  Dear {username},\n Your vendor user account has been successfully created. \n You can now log in using the following credentials:

                Email: {email}
                Password: {password}
                Regards,  
                SMS Portal Team
                ";

                // 2. Send email
                SendEmail(email, subject, body);

                // 3. Clear form fields

                System.Diagnostics.Debug.WriteLine("Vendor User Creation Result: " + result);
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", $"alert('{result}');", true);

                System.Diagnostics.Debug.WriteLine(result);

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
