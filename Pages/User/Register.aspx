<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Appointment_booking.Pages.User.Register" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="../../Content/Assets/User/CSS/register.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br /><br /><br /><br />
    <div class="register-wrapper">

        <div class="glass-card">

            <!-- Header -->
            <div class="card-header-custom">
                <i class="fas fa-user-plus fa-2x mb-3" style="color: #d4af37;"></i>
                <h2 class="card-title-custom">عضویت در سایت</h2>
                <p class="card-subtitle">
                    برای رزرو سریع و مدیریت نوبت‌ها ثبت‌نام کنید
                </p>
            </div>

            <!-- Body -->
            <div class="p-4">

                <asp:Label ID="lblMessage" runat="server"
                    CssClass="alert alert-danger w-100 mb-4"
                    Visible="false" />

                <!-- Full Name -->
                <div class="mb-4">
                    <label class="form-label">نام و نام خانوادگی</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>

                        <asp:TextBox ID="txtFullName" runat="server"
                            CssClass="form-control"
                            placeholder="مثال: علی محمدی" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        CssClass="text-danger"
                        ErrorMessage="وارد کردن نام کامل الزامی است"
                        Display="Dynamic" />
                </div>

                <!-- Email -->
                <div class="mb-4">
                    <label class="form-label">آدرس ایمیل</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-envelope"></i>
                        </span>

                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="form-control"
                            TextMode="Email"
                            placeholder="example@domain.com" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        CssClass="text-danger"
                        ErrorMessage="ایمیل الزامی است"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        CssClass="text-danger"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                        ErrorMessage="فرمت ایمیل صحیح نیست"
                        Display="Dynamic" />
                </div>

                <!-- Phone -->
                <div class="mb-4">
                    <label class="form-label">شماره تلفن</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-phone"></i>
                        </span>

                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="form-control"
                            TextMode="Phone"
                            placeholder="09123456789" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                        ControlToValidate="txtPhone"
                        CssClass="text-danger"
                        ErrorMessage="شماره تلفن الزامی است"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revPhone" runat="server"
                        ControlToValidate="txtPhone"
                        CssClass="text-danger"
                        ValidationExpression="^(09|۰۹)[0-9۰-۹]{9}$"
                        ErrorMessage="شماره تلفن باید با 09 شروع و 11 رقم باشد"
                        Display="Dynamic" />
                </div>

                <!-- Password -->
                <div class="mb-4">
                    <label class="form-label">رمز عبور</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>

                        <asp:TextBox ID="txtPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password"
                            ClientIDMode="Static" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        CssClass="text-danger"
                        ErrorMessage="رمز عبور الزامی است"
                        Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        CssClass="text-danger"
                        ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                        ErrorMessage="حداقل ۶ کاراکتر (حروف و اعداد)"
                        Display="Dynamic" />
                </div>

                <!-- Confirm Password -->
                <div class="mb-4">
                    <label class="form-label">تکرار رمز عبور</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-shield-alt"></i>
                        </span>

                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password" />
                    </div>

                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        CssClass="text-danger"
                        ErrorMessage="تکرار رمز الزامی است"
                        Display="Dynamic" />

                    <asp:CompareValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        CssClass="text-danger"
                        ErrorMessage="رمز عبور و تکرار آن یکسان نیستند"
                        Display="Dynamic" />
                </div>

                <!-- Button -->
                <div class="d-grid">
                    <asp:Button ID="btnRegister" runat="server"
                        Text="ثبت‌نام"
                        CssClass="btn btn-gold"
                        OnClick="btnRegister_Click"
                        CausesValidation="true" />
                </div>

                <!-- Footer -->
                <div class="login-footer">
                    قبلاً ثبت‌نام کرده‌اید؟
                    <a href="Login.aspx">وارد شوید</a>
                </div>

            </div>

        </div>

    </div>

</asp:Content>
