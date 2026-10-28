<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Appointment_booking.Pages.User.Profile" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .profile-wrapper {
            max-width: 900px;
            margin: auto;
        }

        .glass-card {
            background: rgba(20, 20, 20, 0.9);
            border: 1px solid rgba(212,175,55,.25);
            border-radius: 18px;
            backdrop-filter: blur(12px);
            box-shadow: 0 0 20px rgba(212,175,55,.08);
            overflow: hidden;
            transition: .3s;
        }

            .glass-card:hover {
                box-shadow: 0 0 25px rgba(212,175,55,.18);
            }

        .card-header-custom {
            background: rgba(212,175,55,.08);
            border-bottom: 1px solid rgba(212,175,55,.15);
            padding: 18px 22px;
        }

        .card-title-custom {
            color: #d4af37;
            font-weight: 700;
            margin: 0;
        }

        .form-label {
            color: #cfcfcf !important;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control {
            background: #15181d !important;
            border: 1px solid #2a2f36 !important;
            color: white !important;
            padding: 12px;
            border-radius: 12px;
        }

            .form-control:focus {
                background: #15181d !important;
                border-color: #d4af37 !important;
                box-shadow: 0 0 0 3px rgba(212,175,55,.15) !important;
                color: white !important;
            }

            .form-control:disabled {
                background: #101215 !important;
                opacity: .7;
            }

        .page-title {
            color: #d4af37;
            font-weight: 700;
            margin-bottom: 25px;
        }

        .btn-gold {
            background: linear-gradient(135deg,#d4af37,#b99120);
            border: none;
            color: #111;
            font-weight: 600;
            border-radius: 12px;
            padding: 10px 22px;
            transition: .25s;
        }

            .btn-gold:hover {
            }

        .btn-dark-custom {
            border: 1px solid #555;
            background: transparent;
            color: #ddd;
            border-radius: 12px;
            padding: 10px 22px;
        }

        .text-danger {
            font-size: 13px;
            margin-top: 5px;
            display: block;
        }

        .section-space {
            margin-bottom: 30px;
        }

        @media(max-width:768px) {
            .profile-wrapper {
                padding: 10px;
            }
        }
    </style>
</asp:Content>


<asp:Content ID="body" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <br />
    <div class="profile-wrapper">

        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger w-100 mb-4" Visible="false" />

        <div class="d-flex align-items-center mb-4">
            <i class="fas fa-user-edit fa-2x ms-3" style="color: #d4af37;"></i>
            <h2 class="page-title mb-0">ویرایش حساب کاربری</h2>
        </div>


        <!-- اطلاعات عمومی -->
        <div class="glass-card section-space">
            <div class="card-header-custom">
                <h5 class="card-title-custom">
                    <i class="fas fa-id-card ms-2"></i>
                    اطلاعات عمومی
                </h5>
            </div>

            <div class="p-4">
                <div class="row g-4">

                    <div class="col-md-6 col-12">
                        <label for="txtName" class="form-label">نام و نام خانوادگی</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                            ControlToValidate="txtName"
                            CssClass="text-danger"
                            ErrorMessage="وارد کردن نام کامل الزامی است"
                            Display="Dynamic" />
                    </div>

                    <div class="col-md-6 col-12">
                        <label for="txtPhone" class="form-label">شماره تلفن همراه</label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="form-control"
                            Enabled="false"></asp:TextBox>
                    </div>

                    <div class="col-12">
                        <label for="txtEmail" class="form-label">آدرس ایمیل</label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="form-control"
                            TextMode="Email"
                            Enabled="false"></asp:TextBox>
                    </div>

                </div>
            </div>
        </div>


        <!-- تغییر رمز -->
        <div class="glass-card section-space">
            <div class="card-header-custom">
                <h5 class="card-title-custom">
                    <i class="fas fa-lock ms-2"></i>
                    تغییر رمز عبور
                </h5>
            </div>

            <div class="p-4">
                <div class="row g-4">

                    <div class="col-md-4 col-12">
                        <label for="txtCurrentPassword" class="form-label">رمز عبور فعلی</label>

                        <asp:TextBox ID="txtCurrentPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password"></asp:TextBox>

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


                    <div class="col-md-4 col-12">
                        <label for="txtNewPassword" class="form-label">رمز عبور جدید</label>

                        <asp:TextBox ID="txtNewPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password"></asp:TextBox>

                        <asp:RegularExpressionValidator ID="revPassword" runat="server"
                            ControlToValidate="txtNewPassword"
                            CssClass="text-danger"
                            ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                            ErrorMessage="حداقل ۶ کاراکتر (حروف و اعداد) لاتین"
                            Display="Dynamic" />
                    </div>


                    <div class="col-md-4 col-12">
                        <label for="txtConfirmPassword" class="form-label">تکرار رمز عبور جدید</label>

                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                            CssClass="form-control"
                            TextMode="Password"></asp:TextBox>

                        <asp:CompareValidator ID="cvPassword" runat="server"
                            ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtNewPassword"
                            CssClass="text-danger"
                            ErrorMessage="رمز عبور و تکرار آن یکسان نیستند"
                            Display="Dynamic" />
                    </div>

                </div>
            </div>
        </div>


        <!-- Buttons -->
        <div class="d-flex justify-content-end gap-3">

            <asp:Button ID="btnSave" runat="server"
                Text="ذخیره تغییرات"
                CssClass="btn btn-gold"
                OnClick="btnSave_Click" />

        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
