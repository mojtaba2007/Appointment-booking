<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="MyAppointments.aspx.cs" Inherits="Appointment_booking.Pages.User.MyAppointments" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server" ClientIDMode="Static">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        .glass-card {
            background: rgba(20,20,20,.9);
            border: 1px solid rgba(212,175,55,.25);
            border-radius: 18px;
            backdrop-filter: blur(12px);
            box-shadow: 0 0 20px rgba(212,175,55,.08);
            overflow: hidden;
        }

        .page-title {
            color: #d4af37;
            font-weight: 700;
        }

        .btn-gold {
            background: linear-gradient(135deg,#d4af37,#b99120);
            border: none;
            color: #111;
            font-weight: 600;
            border-radius: 12px;
            padding: 10px 20px;
        }

        .btn-outline-gold {
            border: 1px solid #d4af37;
            color: #d4af37;
            border-radius: 12px;
        }

        .appointment-card {
            background: #15181d;
            border: 1px solid #2a2f36;
            border-radius: 16px;
            transition: .25s;
        }

            .appointment-card:hover {
                border-color: rgba(212,175,55,.35);
            }

        .service-icon {
            width: 60px;
            height: 60px;
            background: rgba(212,175,55,.1);
            color: #d4af37;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .barber-tabs .nav-link {
            background: #15181d;
            color: #aaa;
            border: 1px solid #2a2f36;
            margin-left: 8px;
            border-radius: 12px;
        }

            .barber-tabs .nav-link.active {
                background: rgba(212,175,55,.08);
                border-color: #d4af37;
                color: #d4af37;
            }

        .badge-status {
            padding: 8px 14px;
            border-radius: 20px;
        }

        .empty-state {
            background: #15181d;
            border: 1px dashed #2a2f36;
            padding: 30px;
            text-align: center;
            border-radius: 16px;
            color: #999;
        }

        .barber-edit-panel {
            background: rgba(20,20,20,.9);
            border: 1px solid rgba(212,175,55,.25);
            border-radius: 18px;
        }

        .form-label {
            color: #cfcfcf !important;
        }

        .custom-input {
            background: #15181d !important;
            border: 1px solid #2a2f36 !important;
            color: white !important;
            border-radius: 12px;
        }

        .input-group-text {
            background: #15181d !important;
            border: 1px solid #2a2f36 !important;
            color: #d4af37 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <br />
    <br />
    <br />
    <br />

    <div class="container py-4" dir="rtl">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <h3 class="page-title mb-0">
                <i class="fas fa-calendar-check me-2"></i>
                نوبت‌های من
            </h3>

            <a href="BookAppointment.aspx" class="btn btn-gold">
                <i class="fas fa-plus-circle me-1"></i>
                رزرو نوبت جدید
            </a>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="alert d-none" Visible="false"></asp:Label>

        <ul class="nav nav-pills barber-tabs mb-4" id="apptTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tabUpcoming" type="button">
                    نوبت‌های آینده
                    <span class="badge bg-primary rounded-pill ms-1">
                        <asp:Literal ID="litUpcomingCount" runat="server" Text="0" />
                    </span>
                </button>
            </li>

            <li class="nav-item" role="presentation">
                <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tabPast" type="button">
                    نوبت‌های گذشته
                    <span class="badge bg-secondary rounded-pill ms-1">
                        <asp:Literal ID="litPastCount" runat="server" Text="0" />
                    </span>
                </button>
            </li>
        </ul>

        <div class="tab-content">

            <!-- آینده -->
            <div class="tab-pane fade show active" id="tabUpcoming">

                <asp:Panel ID="pnlNoUpcoming" runat="server" CssClass="empty-state" Visible="false">
                    شما در حال حاضر نوبت آینده‌ای ندارید.
                    <div class="mt-3">
                        <a href="BookAppointment.aspx" class="btn btn-gold">رزرو نوبت جدید
                        </a>
                    </div>
                </asp:Panel>

                <asp:Repeater ID="rptUpcoming" runat="server" OnItemCommand="rptUpcoming_ItemCommand">
                    <ItemTemplate>
                        <div class="appointment-card mb-3 p-3">
                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">

                                <div class="d-flex align-items-center gap-3">
                                    <div class="service-icon">
                                        <i class="fas fa-cut"></i>
                                    </div>

                                    <div>
                                        <div class="fw-bold fs-5 text-light"><%# Eval("ServiceName") %></div>

                                        <div class="text-muted small">
                                            <%# Eval("FormattedDate") %>
                                            &nbsp;|&nbsp;
                                            <%# Eval("FormattedTimeRange") %>
                                        </div>

                                        <div class="text-muted small">
                                            <%# Eval("FormattedPrice") %>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <span class='badge badge-status <%# Eval("StatusBadgeClass") %>'>
                                        <%# Eval("StatusText") %>
                                    </span>
                                </div>

                                <div class="d-flex gap-2">
                                    <asp:LinkButton runat="server"
                                        CssClass="btn btn-outline-gold btn-sm"
                                        CommandName="Edit"
                                        CommandArgument='<%# Eval("AppointmentID") %>'
                                        Visible='<%# (bool)Eval("CanModify") %>' Style="padding: 8px 16x;">
                                        ویرایش
                                    </asp:LinkButton>

                                    <asp:LinkButton runat="server"
                                        CssClass="btn btn-outline-danger btn-sm"
                                        CommandName="Cancel"
                                        CommandArgument='<%# Eval("AppointmentID") %>'
                                        Visible='<%# (bool)Eval("CanModify") %>'
                                        OnClientClick="return confirm('آیا از لغو این نوبت مطمئن هستید؟');" Style="border-radius: 12px; padding: 8px 11px;">
                                        لغو نوبت
                                    </asp:LinkButton>

                                    <asp:Label runat="server"
                                        CssClass="text-muted small"
                                        Visible='<%# !(bool)Eval("CanModify") %>'
                                        Text='<%# Eval("ModifyHintText") %>'>
                                    </asp:Label>
                                </div>

                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>

            <!-- گذشته -->
            <div class="tab-pane fade" id="tabPast">

                <asp:Panel ID="pnlNoPast" runat="server" CssClass="empty-state" Visible="false">
                    تاریخچه‌ای از نوبت‌های گذشته یافت نشد.
                </asp:Panel>

                <asp:Repeater ID="rptPast" runat="server">
                    <ItemTemplate>
                        <div class="appointment-card mb-3 p-3" style="opacity: .85;">
                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">

                                <div class="d-flex align-items-center gap-3">
                                    <div class="service-icon">
                                        <i class="fas fa-cut"></i>
                                    </div>

                                    <div>
                                        <div class="fw-bold fs-5 text-light"><%# Eval("ServiceName") %></div>

                                        <div class="text-muted small">
                                            <%# Eval("FormattedDate") %>
                                            &nbsp;|&nbsp;
                                            <%# Eval("FormattedTimeRange") %>
                                        </div>

                                        <div class="text-muted small">
                                            <%# Eval("FormattedPrice") %>
                                        </div>
                                    </div>
                                </div>

                                <span class='badge badge-status <%# Eval("StatusBadgeClass") %>'>
                                    <%# Eval("StatusText") %>
                                </span>

                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>
        </div>

        <!-- Edit Panel -->
        <asp:Panel ID="pnlEdit" runat="server"
            CssClass="barber-edit-panel mt-4"
            Visible="false">

            <div class="card-body p-4">

                <h5 class="fw-bold mb-4" style="color: #d4af37;">ویرایش نوبت
                </h5>

                <div class="mb-4">
                    <p class="mb-1">
                        سرویس :
                        <strong>
                            <asp:Label ID="lblEditServiceName" runat="server" />
                        </strong>
                    </p>

                    <p class="text-muted">
                        <asp:Label ID="lblEditCurrentInfo" runat="server" />
                    </p>
                </div>

                <asp:HiddenField ID="hfEditAppointmentId" runat="server" />
                <asp:HiddenField ID="hfEditServiceId" runat="server" />
                <asp:HiddenField ID="hfEditDate" runat="server" />
                <asp:HiddenField ID="hfEditSelectedTime" runat="server" />

                <div class="mb-4">
                    <label class="form-label fw-bold">تاریخ جدید</label>

                    <div class="input-group">
                        <input type="text" id="txtEditDateDisplay"
                            class="form-control custom-input"
                            placeholder="1406/01/01"
                            readonly="readonly" />

                        <span class="input-group-text">
                            <i class="fas fa-calendar-alt"></i>
                        </span>
                    </div>

                    <span id="dateError" class="text-danger small" style="display: none">لطفا تاریخ را انتخاب کنید.
                    </span>
                </div>

            </div>

        </asp:Panel>

    </div>

    <script src="../../Content/Assets/User/JS/MyAppoint.js"></script>

</asp:Content>
