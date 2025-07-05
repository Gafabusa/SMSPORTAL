<%@ Page Title="Vendor Admins" Language="C#" MasterPageFile="~/SystemOperatorDashboard/SiteMaster.master"
 AutoEventWireup="true" CodeBehind="ViewVendorAdmins.aspx.cs" Inherits="SmsPortalForms.SystemOperatorDashboard.ManageVendors.ViewVendorAdmins" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .action-btn { margin-right: 5px; }
    </style>

    <h2>Vendor Admins</h2>
    <asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" OnRowCommand="gvVendors_RowCommand">
        <Columns>
            <asp:BoundField DataField="VendorID" HeaderText="Vendor ID" />
            <asp:BoundField DataField="VendorName" HeaderText="Vendor Name" />
            <asp:BoundField DataField="UserName" HeaderText="Username" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="CreatedOn" HeaderText="Created On" DataFormatString="{0:yyyy-MM-dd}" />

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" CommandName="EditVendor" CommandArgument='<%# Eval("VendorID") %>' Text="Edit" CssClass="action-btn" />
                    <asp:Button ID="btnDelete" runat="server" CommandName="DeleteVendor" CommandArgument='<%# Eval("VendorID") %>' Text="Delete" CssClass="action-btn" OnClientClick="return confirm('Are you sure you want to delete this vendor?');" />
                    <asp:Button ID="btnUnlock" runat="server" CommandName="UnlockVendor" CommandArgument='<%# Eval("VendorID") %>' Text="Unlock" CssClass="action-btn" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>

