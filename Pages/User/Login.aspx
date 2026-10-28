<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Appointment_booking.Pages.User.Login" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="../../Content/Assets/User/CSS/Login.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br /><br /><br /><br />
    <div class="login-wrapper">

        <div class="glass-card">

            <!-- Header -->
            <div class="card-header-custom">
                <i class="fas fa-sign-in-alt fa-2x mb-3" style="color:#d4af37;"></i>
                <h2 class="card-title-custom">ورود به سایت</h2>
                <p class="card-subtitle">
                    برای مدیریت نوبت‌ها و رزرو آنلاین وارد شوید
                </p>
            </div>

            <!-- Body -->
            <div class="p-4">

                <asp:Label ID="lblMessage" runat="server"
                    CssClass="alert alert-danger w-100 mb-4"
                    Visible="false" />

                <!-- Login -->
                <div class="mb-4">
                    <label class="form-label">شماره تلفن / ایمیل</label>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>

                        <asp:TextBox ID="txtLogin" runat="server"
                            CssClass="form-control"
                            placeholder="example@mail.com یا 0912..." />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvLogin" runat="server"
                        ControlToValidate="txtLogin"
                        CssClass="text-danger"
                        ErrorMessage="شماره تلفن یا ایمیل خود را وارد کنید"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revLogin" runat="server"
                        ControlToValidate="txtLogin"
                        CssClass="text-danger"
                        ValidationExpression="(^(09|۰۹)[0-9۰-۹]{9}$)|(^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$)"
                        ErrorMessage="شماره تلفن یا ایمیل معتبر وارد کنید"
                        Display="Dynamic" />
                </div>

                <!-- Password -->
                <div class="mb-4">
                    <label class="form-label">رمز عبور</label>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-key"></i>
                        </span>

                        <asp:TextBox ID="txtPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password"
                            ClientIDMode="Static" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        CssClass="text-danger"
                        ErrorMessage="رمز عبور را وارد کنید"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        CssClass="text-danger"
                        ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                        ErrorMessage="حداقل ۶ کاراکتر (حروف و اعداد) لاتین"
                        Display="Dynamic" />
                </div>

                <!-- Remember -->
                <div class="mb-4 remember-box">
                    <asp:CheckBox ID="chkRemember" runat="server" Text="مرا به خاطر بسپار" />
                </div>

                <!-- Button -->
                <div class="d-grid">
                    <asp:Button ID="btnLogin" runat="server"
                        Text="ورود"
                        CssClass="btn btn-gold"
                        OnClick="btnLogin_Click"
                        CausesValidation="true" />
                </div>

                <!-- Register -->
                <div class="login-footer">
                    حسابی ندارید؟
                    <a href="Register.aspx">ثبت‌نام کنید</a>
                </div>

            </div>

        </div>

    </div>
</asp:Content>