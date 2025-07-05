<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorAdmin.aspx.cs" Inherits="SmsPortalForms.VendorAdminDashboard.VendorAdmin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Vendor Admin Dashboard</title>
    <link href="VendorAdmin.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>SMS Portal - Vendor Dashboard</h1>
            <div class="header-buttons">
                <span class="welcome-text">Welcome back <asp:Label ID="lblVendorName" runat="server" /></span>
                <asp:Button ID="btnOpenUserModal" runat="server" Text="+ Create User" CssClass="btn btn-create"
                    OnClientClick="openUserModal(); return false;" UseSubmitBehavior="false" />
                <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" 
                    CssClass="btn btn-logout" UseSubmitBehavior="true" CausesValidation="false" />
            </div>
        </div>
        
        <div class="sidebar">
            <asp:LinkButton ID="lnkDashboard" runat="server" OnClick="lnkDashboard_Click" CssClass="nav-item active">
                Dashboard
            </asp:LinkButton>
            <asp:LinkButton ID="lnkSmsHistory" runat="server" OnClick="lnkSmsHistory_Click" CssClass="nav-item">
                SMS History
            </asp:LinkButton>
            <asp:LinkButton ID="lnkReports" runat="server" OnClick="lnkReports_Click" CssClass="nav-item">
                Reports
            </asp:LinkButton>
        </div>
        
        <div class="main-content">
            <asp:Panel ID="pnlDashboard" runat="server" Visible="true">
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total SMS Sent</h3>
                        <asp:Label ID="lblTotalSent" runat="server" CssClass="stat-number" />
                    </div>
                    <div class="stat-card">
                        <h3>Failed SMS</h3>
                        <asp:Label ID="lblFailed" runat="server" CssClass="stat-number" />
                    </div>
                    <div class="stat-card">
                        <h3>Current Credits</h3>
                        <asp:Label ID="lblCredits" runat="server" CssClass="stat-number" />
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSmsHistory" runat="server" Visible="false">
                <h2>SMS History</h2>
                <asp:GridView ID="gvSmsHistory" runat="server" CssClass="data-grid" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Message" HeaderText="Message" />
                        <asp:BoundField DataField="PhoneNumber" HeaderText="Phone" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:BoundField DataField="SentDate" HeaderText="Date" />
                    </Columns>
                </asp:GridView>
            </asp:Panel>
            
            <asp:Panel ID="pnlReports" runat="server" Visible="false">
                <h2>Reports</h2>
                <p>Reports and analytics will be displayed here.</p>
            </asp:Panel>
        </div>

        <!-- Vendor User Creation Modal -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Create Vendor User</h3>
                    <button type="button" class="modal-close" onclick="closeUserModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <asp:TextBox ID="txtUserUsername" runat="server" CssClass="form-input" placeholder="Enter username" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <asp:TextBox ID="txtUserEmail" runat="server" CssClass="form-input" placeholder="Enter email address" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <asp:TextBox ID="txtUserPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter password" />
                    </div>
                    <asp:Button ID="btnCreateUser" runat="server" Text="Create User" OnClick="btnCreateUser_Click" CssClass="btn-submit" />
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function openUserModal() {
            document.getElementById('userModal').style.display = 'block';
        }

        function closeUserModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        window.onclick = function (event) {
            var modal = document.getElementById('userModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>
