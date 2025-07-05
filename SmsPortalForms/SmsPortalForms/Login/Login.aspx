<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SmsPortalForms.Login.Login" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Login - SMS Portal</title>
    <link href="Login.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <h2>SMS Portal Login</h2>
                    <p>Login to access your respective dashboard</p>
                </div>
                
                <div class="login-body">
                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="error-message" />
                    
                    <div class="form-group">
                        <asp:Label runat="server" Text="Email:" AssociatedControlID="txtEmail" CssClass="form-label" />
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter your email" />
                    </div>
                    
                    <div class="form-group">
                        <asp:Label runat="server" Text="Password:" AssociatedControlID="txtPassword" CssClass="form-label" />
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Enter your password" />
                    </div>
                    
                    <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="BtnLogin_Click" CssClass="btn-login" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
