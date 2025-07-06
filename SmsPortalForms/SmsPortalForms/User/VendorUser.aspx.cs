using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmsPortalForms.User
{
    public partial class VendorUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Disable unobtrusive validation for this page
            Page.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            if (Session["VendorUser"] == null)
            {
                Response.Redirect("~/Login/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblUserName.Text = Session["username"].ToString();
                LoadCredits();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login/Login.aspx");
        }

        protected void lnkSendSMS_Click(object sender, EventArgs e)
        {
            ShowPanel("SendSMS");
            SetActiveMenuItem(sender);
        }

        protected void lnkHistory_Click(object sender, EventArgs e)
        {
            ShowPanel("History");
            SetActiveMenuItem(sender);
            LoadHistory();
        }

        protected void lnkCredits_Click(object sender, EventArgs e)
        {
            ShowPanel("Credits");
            SetActiveMenuItem(sender);
        }

        protected void btnStartSendSMS_Click(object sender, EventArgs e)
        {
            ShowPanel("SendSMS");
            SetActiveMenuItem(lnkSendSMS);
        }

        protected void btnCancelSMS_Click(object sender, EventArgs e)
        {
            // Clear form and return to dashboard
            ClearForm();
            ShowPanel("Dashboard");
            SetActiveMenuItem(lnkSendSMS);
        }

        protected void rblDeliveryType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblDeliveryType.SelectedValue == "Single")
            {
                singleSmsDiv.Style["display"] = "block";
                rfvPhoneNumber.Enabled = true;
                revPhoneNumber.Enabled = true;
            }
            else
            {
                singleSmsDiv.Style["display"] = "none";
                rfvPhoneNumber.Enabled = false;
                revPhoneNumber.Enabled = false;
                txtPhoneNumber.Text = "";
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Store form data in labels
                lblDisplaySmsType.Text = rblSmsType.SelectedItem.Text;
                lblDisplayDeliveryType.Text = rblDeliveryType.SelectedItem.Text;             
                lblDisplayMessage.Text = txtMessage.Text;

                // Show/hide file upload based on delivery type
                if (rblDeliveryType.SelectedValue == "Bulk")
                {
                    fileUploadDiv.Style["display"] = "block";
                }
                else
                {
                    fileUploadDiv.Style["display"] = "none";
                }

                ShowPanel("Upload");
            }
        }

        protected void rblSchedule_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblSchedule.SelectedValue == "Schedule")
            {
                scheduleDiv.Style["display"] = "block";
                rfvScheduleDateTime.Enabled = true;
            }
            else
            {
                scheduleDiv.Style["display"] = "none";
                rfvScheduleDateTime.Enabled = false;
                scheduleDateTime.Text = "";
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Process SMS submission here
                    // Add your SMS processing logic

                    // Show success message
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('SMS submitted successfully!');", true);

                    // Clear form and return to dashboard
                    ClearForm();
                    ShowPanel("Dashboard");
                    SetActiveMenuItem(lnkSendSMS);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        $"alert('Error: {ex.Message}');", true);
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            ShowPanel("SendSMS");
        }

        private void ShowPanel(string panelName)
        {
            // Hide all panels
            pnlDashboard.Visible = false;
            pnlSendSMS.Visible = false;
            pnlUpload.Visible = false;
            pnlHistory.Visible = false;
            pnlCredits.Visible = false;

            // Show selected panel
            switch (panelName)
            {
                case "Dashboard":
                    pnlDashboard.Visible = true;
                    break;
                case "SendSMS":
                    pnlSendSMS.Visible = true;
                    break;
                case "Upload":
                    pnlUpload.Visible = true;
                    break;
                case "History":
                    pnlHistory.Visible = true;
                    break;
                case "Credits":
                    pnlCredits.Visible = true;
                    break;
            }
        }

        private void SetActiveMenuItem(object sender)
        {
            lnkSendSMS.CssClass = "nav-item";
            lnkHistory.CssClass = "nav-item";
            lnkCredits.CssClass = "nav-item";

            if (sender is LinkButton)
            {
                ((LinkButton)sender).CssClass = "nav-item active";
            }
        }

        private void LoadCredits()
        {
            lblCredits.Text = "1,250";
        }

        private void LoadHistory()
        {
            // Load SMS history from database
        }

        private void ClearForm()
        {
            txtMessage.Text = "";
            txtPhoneNumber.Text = "";
            rblSmsType.SelectedIndex = 0;
            rblDeliveryType.SelectedIndex = 1;
            rblSchedule.SelectedIndex = 0;
            scheduleDateTime.Text = "";
            singleSmsDiv.Style["display"] = "none";
            scheduleDiv.Style["display"] = "none";

            // Reset validators
            rfvPhoneNumber.Enabled = false;
            revPhoneNumber.Enabled = false;
            rfvScheduleDateTime.Enabled = false;
        }
    }
}
