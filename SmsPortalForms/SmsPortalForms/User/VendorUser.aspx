<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorUser.aspx.cs" Inherits="SmsPortalForms.User.VendorUser" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Vendor User Dashboard</title>
    <link href="VendorUser.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="header">
            <h1>SMS Portal - Vendor User Dashboard</h1>
            <div class="header-buttons">
                <span class="welcome-text">Welcome back <asp:Label ID="lblUserName" runat="server" /></span>
<%--                <asp:Button ID="btnHeaderSendSMS" runat="server" Text="Send SMS" OnClick="btnStartSendSMS_Click" CssClass="btn btn-send-sms" />--%>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" CssClass="btn btn-logout" />
            </div>
        </div>
        
        <div class="sidebar">
            <asp:LinkButton ID="lnkSendSMS" runat="server" OnClick="lnkSendSMS_Click" CssClass="nav-item active">Send SMS</asp:LinkButton>
            <asp:LinkButton ID="lnkHistory" runat="server" OnClick="lnkHistory_Click" CssClass="nav-item">SMS History</asp:LinkButton>
            <asp:LinkButton ID="lnkCredits" runat="server" OnClick="lnkCredits_Click" CssClass="nav-item">Credits</asp:LinkButton>
        </div>
        
        <div class="main-content">
            <!-- Main Dashboard Panel -->
            <asp:Panel ID="pnlDashboard" runat="server" Visible="true">
                <div class="content-card">
                    <h2>Welcome to SMS Portal</h2>
                    <div class="dashboard-content">
                        <p>Click the button below to start sending SMS messages.</p>
                        <asp:Button ID="btnStartSendSMS" runat="server" Text="Send SMS" OnClick="btnStartSendSMS_Click" CssClass="btn-start-sms" />
                    </div>
                </div>
            </asp:Panel>

            <!-- Send SMS Panel -->
            <asp:Panel ID="pnlSendSMS" runat="server" Visible="false">
                <div class="content-card">
                    <div class="card-header">
                        <h2>Send SMS</h2>
                        <asp:Button ID="btnCancelSMS" runat="server" Text="Cancel" OnClick="btnCancelSMS_Click" CssClass="btn btn-cancel" />
                    </div>
                    <div class="form-container">
                        <div class="form-group">
                            <label class="form-label">SMS Type:</label>
                            <asp:RadioButtonList ID="rblSmsType" runat="server" RepeatDirection="Horizontal" CssClass="radio-list">
                                <asp:ListItem Text="File SMS" Value="FileSMS" Selected="True" />
                                <asp:ListItem Text="SMS Template" Value="SMSTemplate" />
                            </asp:RadioButtonList>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Message: <span class="required">*</span></label>
                            <asp:TextBox ID="txtMessage" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="4" placeholder="Enter your SMS message"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" ErrorMessage="Message is required" CssClass="error-text" ValidationGroup="SendSMS" />
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Delivery Type:</label>
                            <asp:RadioButtonList ID="rblDeliveryType" runat="server" RepeatDirection="Horizontal" CssClass="radio-list" AutoPostBack="true" OnSelectedIndexChanged="rblDeliveryType_SelectedIndexChanged">
                                <asp:ListItem Text="Single" Value="Single" />
                                <asp:ListItem Text="Bulk" Value="Bulk" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        
                        <div class="form-group" id="singleSmsDiv" runat="server" style="display:none;">
                            <label class="form-label">Phone Number: <span class="required">*</span></label>
                            <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-input" placeholder="Enter 10-digit phone number" MaxLength="10"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber" 
                                ErrorMessage="Phone number is required" CssClass="error-text" ValidationGroup="SendSMS" Enabled="false" />
                            <asp:RegularExpressionValidator ID="revPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber" 
                                ValidationExpression="^\d{10}$" ErrorMessage="Please enter exactly 10 digits" CssClass="error-text" ValidationGroup="SendSMS" Enabled="false" />
                        </div>
                        
                        <div class="button-group">
                            <asp:Button ID="btnNext" runat="server" CssClass="btn-submit" Text="Next" OnClick="btnNext_Click" ValidationGroup="SendSMS" />
                            <asp:Button ID="btnCancelForm" runat="server" CssClass="btn-secondary" Text="Cancel" OnClick="btnCancelSMS_Click" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Upload Panel -->
            <asp:Panel ID="pnlUpload" runat="server" Visible="false">
                <div class="content-card">
                    <div class="card-header">
                        <h2>Upload File & Schedule SMS</h2>
                        <asp:Button ID="btnCancelUpload" runat="server" Text="Cancel" OnClick="btnCancelSMS_Click" CssClass="btn btn-cancel" />
                    </div>
                    <div class="form-container">
                        <div class="selected-options">
                            <h5>Selected Options:</h5>
                            <p><strong>SMS Type:</strong> <asp:Label ID="lblDisplaySmsType" runat="server" /></p>
                            <p><strong>Delivery Type:</strong> <asp:Label ID="lblDisplayDeliveryType" runat="server" /></p>
                            <p><strong>Phone Number:</strong> <asp:Label ID="lblDisplayPhoneNumber" runat="server" /></p>
                            <div class="message-display">
                                <strong>Message:</strong><br />
                                <asp:Label ID="lblDisplayMessage" runat="server" CssClass="message-text" />
                            </div>
                        </div>
                        
                        <div class="form-group" id="fileUploadDiv" runat="server">
                            <label class="form-label">Upload CSV File <span class="required">*</span></label>
                            <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-input file-upload" />
                            <small class="form-help">
                                For File SMS: CSV file with contacts<br/>
                                For SMS Template: CSV file with placeholder values and contacts
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">SMS Scheduling:</label>
                            <asp:RadioButtonList ID="rblSchedule" runat="server" RepeatDirection="Horizontal" CssClass="radio-list" AutoPostBack="true" OnSelectedIndexChanged="rblSchedule_SelectedIndexChanged">
                                <asp:ListItem Text="Send Now" Value="SendNow" Selected="True" />
                                <asp:ListItem Text="Schedule" Value="Schedule" />
                            </asp:RadioButtonList>
                        </div>
                        
                        <div class="form-group" id="scheduleDiv" runat="server" style="display: none;">
                            <label class="form-label">Schedule Date & Time: <span class="required">*</span></label>
                            <asp:TextBox ID="scheduleDateTime" runat="server" CssClass="form-input" TextMode="DateTimeLocal" />
                            <asp:RequiredFieldValidator ID="rfvScheduleDateTime" runat="server" ControlToValidate="scheduleDateTime" 
                                ErrorMessage="Please select date and time" CssClass="error-text" ValidationGroup="SubmitSMS" Enabled="false" />
                        </div>
                        
                        <div class="button-group">
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn-submit" Text="Submit SMS" OnClick="btnSubmit_Click" ValidationGroup="SubmitSMS" />
                            <asp:Button ID="btnBack" runat="server" CssClass="btn-secondary" Text="Back" OnClick="btnBack_Click" />
                            <asp:Button ID="btnCancelFinal" runat="server" CssClass="btn-cancel-alt" Text="Cancel" OnClick="btnCancelSMS_Click" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlHistory" runat="server" Visible="false">
                <div class="content-card">
                    <h2>SMS History</h2>
                    <asp:GridView ID="gvHistory" runat="server" CssClass="data-grid" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="Message" HeaderText="Message" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:BoundField DataField="UploadedAt" HeaderText="Date" />
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlCredits" runat="server" Visible="false">
                <div class="content-card">
                    <h2>Credits</h2>
                    <div class="credit-card">
                        <h3>Available Credits</h3>
                        <asp:Label ID="lblCredits" runat="server" CssClass="credit-number" />
                    </div>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
