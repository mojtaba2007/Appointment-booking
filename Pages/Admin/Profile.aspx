<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Appointment_booking.Pages.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/Assets/Admin/CSS/Profile.css" rel="stylesheet" />
    <style>
        .appt-avatar {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: .82rem;
            font-weight: 600;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid">

        <!-- Header -->
        <div class="d-flex align-items-start justify-content-between mb-4 gap-2 flex-wrap">
            <div>
                <h5 class="fw-bold mb-1">پروفایل کاربری</h5>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0 small">
                        <li class="breadcrumb-item">
                            <a href="Dashboard.aspx" class="text-decoration-none">
                                <i class="bi bi-house-door"></i>داشبورد
                            </a>
                        </li>
                        <li class="breadcrumb-item active text-muted">پروفایل</li>
                    </ol>
                </nav>
            </div>
        </div>

        <%--   ALERT MESSAGE   --%>
        <asp:Label ID="lblMessage" runat="server" Visible="false"
            CssClass="alert d-block rounded-3 mb-3 d-flex align-items-center gap-2" />

        <div class="row">

            <!-- Profile Card -->
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-body text-center p-4">

                        <div class="profile-avatar ">
                            <i style="font-size: xxx-large;"
                                class="bi bi-person-square"></i>
                        </div>

                        <h4 class="fw-bold mb-1">
                            <asp:Literal ID="litFullName" runat="server" Text=""></asp:Literal>
                        </h4>

                        <p class="text-muted mb-3">
                            مدیر سیستم
                       
                        </p>

                        <span class="badge bg-success px-3 py-2 rounded-pill">فعال
                        </span>

                    </div>
                </div>
            </div>

            <!-- Edit Form -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-4">ویرایش اطلاعات</h5>

                        <div class="row">

                            <div class="col-md-6 mb-3">
                                <label class="form-label">نام کامل</label>
                                <asp:TextBox ID="txtFullName" runat="server"
                                    CssClass="form-control custom-input"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="rfvname" runat="server"
                                    ControlToValidate="txtFullName"
                                    CssClass="text-danger"
                                    ValidationExpression="^(?=.{3,20}$)\S.*\S$"
                                    ErrorMessage="مقدار کاراکتر مجاز بین 3 تا 20 بدون"
                                    Display="Dynamic" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">شماره تماس</label>
                                <asp:TextBox ID="txtPhone" runat="server"
                                    CssClass="form-control custom-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    CssClass="text-danger"
                                    ErrorMessage="شماره تلفن خود را وارد کنید"
                                    Display="Dynamic" />

                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    CssClass="text-danger"
                                    ValidationExpression="^(09|۰۹)[0-9۰-۹]{9}$"
                                    ErrorMessage="شماره تلفن معتبر وارد کنید"
                                    Display="Dynamic" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">ایمیل</label>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control custom-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                    ControlToValidate="txtEmail"
                                    CssClass="text-danger"
                                    ErrorMessage="ایمیل خود را وارد کنید"
                                    Display="Dynamic" />

                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                    ControlToValidate="txtEmail"
                                    CssClass="text-danger"
                                    ValidationExpression="^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$"
                                    ErrorMessage="ایمیل معتبر وارد کنید"
                                    Display="Dynamic" />

                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">رمز عبور فعلی</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server"
                                    TextMode="Password"
                                    CssClass="form-control custom-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                    ControlToValidate="txtCurrentPassword"
                                    CssClass="text-danger"
                                    ErrorMessage="رمز عبور فعلی را وارد کنید."
                                    Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                    ControlToValidate="txtCurrentPassword"
                                    CssClass="text-danger"
                                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                                    ErrorMessage="حداقل ۶ کاراکتر (حروف و اعداد)"
                                    Display="Dynamic" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">رمز عبور جدید</label>
                                <asp:TextBox ID="txtNewPassword" runat="server"
                                    TextMode="Password"
                                    CssClass="form-control custom-input"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                    ControlToValidate="txtNewPassword"
                                    CssClass="text-danger"
                                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                                    ErrorMessage="حداقل ۶ کاراکتر (حروف و اعداد) لاتین"
                                    Display="Dynamic" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">تکرار رمز عبور</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server"
                                    TextMode="Password"
                                    CssClass="form-control custom-input"></asp:TextBox>

                                <asp:CompareValidator ID="cvPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ControlToCompare="txtNewPassword"
                                    CssClass="text-danger"
                                    ErrorMessage="رمز عبور و تکرار آن یکسان نیستند"
                                    Display="Dynamic" />
                            </div>

                        </div>

                        <div class="mt-4">
                            <asp:Button ID="btnSave" runat="server"
                                Text="ذخیره تغییرات"
                                CssClass="btn btn-primary px-4 rounded-pill"
                                OnClick="btnSave_Click" />
                        </div>

                    </div>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
