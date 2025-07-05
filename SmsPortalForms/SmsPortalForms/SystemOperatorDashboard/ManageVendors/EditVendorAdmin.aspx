<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditVendorAdmin.aspx.cs" Inherits="SmsPortalForms.SystemOperatorDashboard.ManageVendors.EditVendorAdmin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Edit Vendor Admin</title>
    <style>
        .form-group { margin-bottom: 10px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="email"] {
            width: 100%; padding: 8px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Edit Vendor Admin</h2>

        <asp:HiddenField ID="hdnVendorID" runat="server" />

        <div class="form-group">
            <label>Vendor Name</label>
            <asp:TextBox ID="txtVendorName" runat="server" />
        </div>
        <div class="form-group">
            <label>Username</label>
            <asp:TextBox ID="txtUserName" runat="server" />
        </div>
        <div class="form-group">
            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
        </div>

        <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />
        <asp:Button ID="btnBack" runat="server" Text="Cancel" PostBackUrl="~/SystemOperatorDashboard/ManageVendors/ViewVendorAdmins.aspx" />
    </form>
</body>
</html>
