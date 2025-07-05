<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/SystemOperatorDashboard/SiteMaster.Master"
    AutoEventWireup="true" CodeBehind="OperatorDashboard.aspx.cs" Inherits="SmsPortalForms.SystemOperatorDashboard.OperatorDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="mainInnerContent">
        <div class="dashboard-container">
            <h2 class="dashboard-title">System Overview</h2>
            <p class="dashboard-subtitle">Monitor and manage your SMS portal operations</p>

            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-number">100</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50</div>
                    <div class="stat-label">Active Vendors</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">15,632</div>
                    <div class="stat-label">Messages Sent</div>
                </div>
            </div>
        </div>

        <!-- Vendor Creation Modal -->
        <div id="vendorModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Create New Vendor</h3>
                    <button type="button" class="modal-close" onclick="closeVendorModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Vendor Name</label>
                        <asp:TextBox ID="txtVendorName" runat="server" CssClass="form-input" placeholder="Enter vendor name" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Enter username" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter email address" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter password" />
                    </div>
                    <asp:HiddenField ID="hdnShowModal" runat="server" />
                    <asp:Button ID="btnCreateVendorAdmin" runat="server" CssClass="btn-submit" Text="Create Vendor Admin" OnClick="btnCreateVendorAdmin_Click" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openVendorModal() {
            document.getElementById('vendorModal').style.display = 'block';
        }

        function closeVendorModal() {
            document.getElementById('vendorModal').style.display = 'none';
        }

        window.onclick = function (event) {
            var modal = document.getElementById('vendorModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</asp:Content>
