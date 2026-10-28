<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageAppointments.aspx.cs" Inherits="Appointment_booking.Pages.Admin.WebForm2" %>

<%@ MasterType VirtualPath="~/Pages/Admin/Admin.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/Assets/Admin/CSS/ManageAppoint.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="upMain" runat="server">
        <ContentTemplate>
            <div class="modal fade" id="messageModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div id="modalContent" runat="server" class="modal-content border-0 shadow">

                        <div id="modalHeader" runat="server" class="modal-header">

                            <h5 id="modalTitle"
                                runat="server"
                                class="modal-title text-white fw-bold">پیام
                            </h5>

                            <button type="button"
                                class="btn-close btn-close-white"
                                data-bs-dismiss="modal">
                            </button>

                        </div>

                        <div id="modalBody" runat="server" class="modal-body text-center py-4">

                            <asp:Literal ID="litModalIcon" runat="server"></asp:Literal>

                            <div class="mt-3 fs-5">
                                <asp:Literal ID="litModalMessage" runat="server"></asp:Literal>
                            </div>

                        </div>

                        <div class="border-0 justify-content-center">

                            <div id="modalFooter" runat="server" class="modal-footer border-0 justify-content-center">

                                <asp:Button
                                    ID="btnModalOk"
                                    runat="server"
                                    Text="تأیید"
                                    CssClass="btn px-4"
                                    data-bs-dismiss="modal"
                                    UseSubmitBehavior="false"
                                    OnClientClick="return false;" />
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <%-- ══════════════ PAGE HEADER ══════════════ --%>
            <div class="d-flex align-items-start justify-content-between mb-4 gap-2 flex-wrap">
                <div>
                    <h5 class="fw-bold mb-1">مدیریت نوبت‌ها</h5>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0 small">
                            <li class="breadcrumb-item">
                                <a href="Dashboard.aspx" class="text-decoration-none">
                                    <i class="bi bi-house-door"></i>داشبورد
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-muted">نوبت‌ها</li>
                        </ol>
                    </nav>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <span class="badge rounded-pill text-bg-light border px-3 py-2 small">
                        <i class="bi bi-calendar3 me-1"></i>
                        وضعیت‌ها: تأیید شده، انجام شده، لغو شده
                    </span>
                </div>
            </div>

            <%-- ══════════════ ALERT MESSAGE ══════════════ --%>
            <asp:Label ID="lblMessage" runat="server" Visible="false"
                CssClass="alert d-block rounded-3 mb-3 d-flex align-items-center gap-2" />

            <%-- ══════════════ STATS ROW ══════════════ --%>
            <div class="row g-3 mb-4">

                <%-- امروز --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="appt-stat-icon" style="background: rgba(99,102,241,.12); color: #6366f1;">
                                <i class="bi bi-calendar-day-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">نوبت‌های امروز</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litTodayCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- تأیید شده --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="appt-stat-icon" style="background: rgba(16,185,129,.12); color: #059669;">
                                <i class="bi bi-check-circle-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">تأیید شده</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litConfirmedCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- انجام شده --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="appt-stat-icon" style="background: #6C757D; color: #FFFFFF;">
                                <i class="bi bi-check2-all fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">نوبت‌های انجام‌شده در ماه</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litDoneCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- این ماه --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="appt-stat-icon" style="background: rgba(139,92,246,.12); color: #7c3aed;">
                                <i class="bi bi-calendar-range-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">نوبت‌های این ماه</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litMonthCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <%-- /stats --%>

            <%-- ══════════════ FILTER BAR ══════════════ --%>
            <div class="card filter-card mb-3">
                <div class="card-body py-3 px-3">
                    <div class="row g-2 align-items-end">

                        <%-- جستجوی کاربر --%>
                        <div class="col-12 col-md-3">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">
                                جستجوی کاربر
                            </label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-white border-end-0 text-muted">
                                    <i class="bi bi-search" style="font-size: .78rem;"></i>
                                </span>
                                <asp:TextBox ID="txtSearchUser" runat="server"
                                    CssClass="form-control form-control-sm border-start-0 ps-0"
                                    placeholder="نام، تلفن یا ایمیل..." />
                            </div>
                        </div>

                        <%-- وضعیت --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">وضعیت</label>
                            <asp:DropDownList ID="ddlFilterStatus" runat="server"
                                CssClass="form-select form-select-sm">
                                <asp:ListItem Value="">همه وضعیت‌ها</asp:ListItem>
                                <asp:ListItem Value="Confirmed">تأیید شده</asp:ListItem>
                                <asp:ListItem Value="Completed">انجام شده</asp:ListItem>
                                <asp:ListItem Value="Cancelled">لغو شده</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <%-- سرویس --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">سرویس</label>
                            <asp:DropDownList ID="ddlFilterService" runat="server"
                                CssClass="form-select form-select-sm">
                                <asp:ListItem Value="">همه سرویس‌ها</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <%-- از تاریخ --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">از تاریخ</label>
                            <asp:TextBox ID="txtDateFrom" runat="server"
                                CssClass="form-control form-control-sm persian-date" Text="" />
                            <asp:HiddenField ID="hfDateFrom" runat="server" />

                        </div>

                        <%-- تا تاریخ --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">تا تاریخ</label>
                            <asp:TextBox ID="txtDateTo" runat="server"
                                CssClass="form-control form-control-sm persian-date" Text="" />
                            <asp:HiddenField ID="hfDateTo" runat="server" />
                        </div>

                        <%-- دکمه‌ها --%>
                        <div class="col-12 col-md-1 d-flex gap-1 justify-content-md-end">
                            <asp:Button ID="btnFilter" runat="server"
                                Text="جستجو"
                                CssClass="btn btn-sm btn-primary"
                                OnClick="btnFilter_Click" CausesValidation="false" />
                            <asp:Button ID="btnResetFilter" runat="server"
                                Text="پاک"
                                CssClass="btn btn-sm btn-outline-secondary"
                                OnClick="btnResetFilter_Click" CausesValidation="false" />
                        </div>

                    </div>
                </div>
            </div>
            <%-- /filter --%>

            <%-- ══════════════ APPOINTMENTS GRIDVIEW ══════════════ --%>
            <div class="card grid-card">
                <div class="card-header py-3 d-flex align-items-center justify-content-between">
                    <span class="small fw-semibold text-secondary">
                        <i class="bi bi-table me-1"></i>لیست نوبت‌ها
                    </span>
                    <span class="badge bg-secondary rounded-pill badge-sm">
                        <asp:Literal ID="litResultCount" runat="server" Text="0" />
                        مورد
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvAppointments" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="table table-hover align-middle mb-0"
                            GridLines="None"
                            OnRowCommand="gvAppointments_RowCommand">
                            <HeaderStyle CssClass="tbl-header" />
                            <Columns>

                                <%-- # --%>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <span class="ps-3 text-muted">#</span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <span class="ps-3 text-muted small">
                                            <%# Container.DataItemIndex + 1 %>
                                        </span>
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" />
                                </asp:TemplateField>

                                <%-- کاربر --%>
                                <asp:TemplateField HeaderText="کاربر">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="appt-avatar text-white flex-shrink-0"
                                                style='background: <%# GetAvatarGradient(Eval("UserName")) %>'>
                                                <%# GetInitial(Eval("UserName")) %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold small lh-sm">
                                                    <%# Server.HtmlEncode(Eval("UserName").ToString()) %>
                                                </div>
                                                <div class="text-muted lh-sm" style="font-size: .72rem;">
                                                    <%# Server.HtmlEncode(Eval("Phone").ToString()) %>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- سرویس --%>
                                <asp:TemplateField HeaderText="سرویس">
                                    <ItemTemplate>
                                        <div class="fw-semibold small lh-sm">
                                            <%# Server.HtmlEncode(Eval("ServiceName").ToString()) %>
                                        </div>
                                        <div class="text-muted lh-sm" style="font-size: .72rem;">
                                            <i class="bi bi-clock me-1"></i><%# Eval("DurationMinutes") %> دقیقه
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- تاریخ --%>
                                <asp:TemplateField HeaderText="تاریخ">
                                    <ItemTemplate>
                                        <span class="small">
                                            <%# ToShamsi(Convert.ToDateTime(Eval("AppointmentDate"))) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- ساعت --%>
                                <asp:TemplateField HeaderText="بازه ساعت">
                                    <ItemTemplate>
                                        <span class="badge bg-light text-secondary border badge-sm lh-base">
                                            <i class="bi bi-clock me-1"></i>
                                            <%# FormatTime(Eval("StartTime")) %> – <%# FormatTime(Eval("EndTime")) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- وضعیت --%>
                                <asp:TemplateField HeaderText="وضعیت">
                                    <ItemTemplate>
                                        <%# GetStatusBadgeHtml(Eval("Status")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- قیمت --%>
                                <asp:TemplateField HeaderText="قیمت (تومان)">
                                    <ItemTemplate>
                                        <span class="fw-semibold small">
                                            <%# Convert.ToDecimal(Eval("Price")).ToString("N0") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- عملیات --%>
                                <asp:TemplateField HeaderText="عملیات">
                                    <ItemTemplate>
                                        <div class="d-flex gap-1 pe-2">

                                            <%-- جزئیات: همیشه نمایش --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="ViewDetail"
                                                CommandArgument='<%# Eval("AppointmentID") %>'
                                                CssClass="btn btn-sm btn-outline-primary tbl-action"
                                                CausesValidation="false"
                                                title="مشاهده جزئیات">
                                                <i class="bi bi-eye-fill"></i>
                                            </asp:LinkButton>

                                            <%-- تأیید سریع: فقط Pending --%>
                                            <%--                                            <asp:LinkButton runat="server"
                                                CommandName="QuickConfirm"
                                                CommandArgument='<%# Eval("AppointmentID") %>'
                                                CssClass="btn btn-sm btn-outline-success tbl-action"
                                                CausesValidation="false"
                                                Visible='<%# IsPending(Eval("Status")) %>'
                                                OnClientClick="return confirm('آیا این نوبت را تأیید می‌کنید؟')"
                                                title="تأیید نوبت">
                                                <i class="bi bi-check-lg"></i>
                                            </asp:LinkButton>--%>

                                            <%-- انجام شد: فقط Confirmed --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="QuickComplete"
                                                CommandArgument='<%# Eval("AppointmentID") %>'
                                                CssClass="btn btn-sm btn-outline-secondary tbl-action"
                                                CausesValidation="false"
                                                Visible='<%# IsConfirmed(Eval("Status")) %>'
                                                OnClientClick="return confirm('آیا این نوبت انجام شده است؟')"
                                                title="انجام شد">
                                                <i class="bi bi-check2-all"></i>
                                            </asp:LinkButton>

                                            <%-- لغو سریعیا Confirmed --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="QuickCancel"
                                                CommandArgument='<%# Eval("AppointmentID") %>'
                                                CssClass="btn btn-sm btn-outline-danger tbl-action"
                                                CausesValidation="false"
                                                Visible='<%# IsModifiable(Eval("Status")) %>'
                                                OnClientClick="return confirm('آیا از لغو این نوبت اطمینان دارید؟')"
                                                title="لغو نوبت">
                                                <i class="bi bi-x-lg"></i>
                                            </asp:LinkButton>

                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle Width="130px" />
                                </asp:TemplateField>

                            </Columns>

                            <EmptyDataTemplate>
                                <div class="text-center py-5">
                                    <div class="text-muted mb-3" style="font-size: 3rem;">
                                        <i class="bi bi-calendar2-x"></i>
                                    </div>
                                    <p class="text-muted mb-1 fw-semibold">هیچ نوبتی یافت نشد</p>
                                    <small class="text-muted">فیلترها را تغییر دهید یا جستجوی جدید انجام دهید</small>
                                </div>
                            </EmptyDataTemplate>

                        </asp:GridView>
                    </div>
                </div>
            </div>
            <asp:HiddenField ID="hfDetailApptId" runat="server" />

            <%-- ══════════════ DETAIL MODAL ══════════════ --%>
            <div class="modal fade" id="detailModal" tabindex="-1"
                data-bs-backdrop="static" aria-labelledby="detailModalLabel">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content border-0 shadow-lg">

                        <%-- Header --%>
                        <div class="modal-header border-0 px-4 pt-4 pb-3 align-items-start">
                            <div>
                                <h6 class="modal-title fw-bold text-dark mb-2" id="detailModalLabel">
                                    <i class="bi bi-calendar-check text-primary me-2"></i>جزئیات نوبت
                                    </span>
                                </h6>
                                <asp:Literal ID="litDetailStatus" runat="server" />
                            </div>
                            <button type="button" class="btn-close mt-1" data-bs-dismiss="modal" aria-label="بستن"></button>
                        </div>

                        <%-- Body --%>
                        <div class="modal-body px-4 py-0 pb-3">
                            <div class="row g-3">

                                <%-- اطلاعات کاربر --%>
                                <div class="col-md-6">
                                    <div class="detail-info-block">
                                        <div class="detail-info-label">
                                            <i class="bi bi-person-fill"></i>اطلاعات کاربر
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-person text-muted"></i>
                                            <span class="fw-semibold">
                                                <asp:Literal ID="litDetailUser" runat="server" />
                                            </span>
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-telephone text-muted"></i>
                                            <span>
                                                <asp:Literal ID="litDetailPhone" runat="server" />
                                            </span>
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-envelope text-muted"></i>
                                            <span style="word-break: break-all;">
                                                <asp:Literal ID="litDetailEmail" runat="server" />
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <%-- اطلاعات نوبت --%>
                                <div class="col-md-6">
                                    <div class="detail-info-block">
                                        <div class="detail-info-label">
                                            <i class="bi bi-calendar3"></i>اطلاعات نوبت
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-scissors text-muted"></i>
                                            <span>
                                                <asp:Literal ID="litDetailService" runat="server" />
                                                <span class="text-muted small">(<asp:Literal ID="litDetailDuration" runat="server" />
                                                    دقیقه)
                                                </span>
                                            </span>
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-calendar-date text-muted"></i>
                                            <span class="fw-semibold">
                                                <asp:Literal ID="litDetailDate" runat="server" />
                                            </span>
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-clock text-muted"></i>
                                            <span>
                                                <asp:Literal ID="litDetailTime" runat="server" />
                                            </span>
                                        </div>
                                        <div class="detail-info-row">
                                            <i class="bi bi-cash-coin text-muted"></i>
                                            <span class="fw-semibold">
                                                <asp:Literal ID="litDetailPrice" runat="server" />
                                            </span>
                                            <span class="text-muted small">تومان</span>
                                        </div>
                                        <div class="detail-info-row text-muted" style="font-size: .78rem;">
                                            <i class="bi bi-clock-history text-muted"></i>
                                            <span>ثبت:
                                                <asp:Literal ID="litDetailCreated" runat="server" />
                                            </span>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <%-- راهنمای جریان وضعیت --%>
                            <div class="status-flow-hint mt-2 px-1">
                                <small class="text-muted">
                                    <i class="bi bi-info-circle me-1"></i>
                                    مسیر نوبت:
                                    <span class="badge bg-success badge-xs">تأیید شده</span>
                                    <i class="bi bi-arrow-left mx-1 text-muted" style="font-size: .65rem;"></i>
                                    <span class="badge bg-secondary badge-xs">انجام شده</span>
                                </small>
                            </div>
                        </div>

                        <%-- Footer / Actions --%>
                        <div class="modal-footer bg-light border-top py-3 px-4 gap-2 flex-wrap">
                            <button type="button" class="btn btn-sm btn-outline-secondary"
                                data-bs-dismiss="modal">
                                <i class="bi bi-x-lg me-1"></i>بستن
                            </button>

                            <%-- لغو نوبت --%>
                            <asp:Button ID="btnModalCancel" runat="server"
                                Text="لغو نوبت"
                                Visible="false"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClick="btnModalCancel_Click"
                                CausesValidation="false"
                                OnClientClick="return confirm('آیا از لغو این نوبت اطمینان دارید؟')" />

                            <%-- انجام شد --%>
                            <asp:Button ID="btnModalComplete" runat="server"
                                Text="انجام شد"
                                Visible="false"
                                CssClass="btn btn-sm btn-secondary"
                                OnClick="btnModalComplete_Click"
                                CausesValidation="false"
                                OnClientClick="return confirm('آیا این نوبت انجام شده است؟')" />

                            <%-- تأیید نوبت --%>
                            <asp:Button ID="btnModalConfirm" runat="server"
                                Text="تأیید نوبت"
                                Visible="false"
                                CssClass="btn btn-sm btn-success"
                                OnClick="btnModalConfirm_Click"
                                CausesValidation="false"
                                OnClientClick="return confirm('آیا این نوبت را تأیید می‌کنید؟')" />
                        </div>

                    </div>
                </div>
            </div>

            <%-- /modal --%>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
    <link rel="stylesheet" href="Content/persian-datepicker.min.css" />
    <script src="../../Scripts/jquery-3.7.0.min.js"></script>
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/css/persian-datepicker.min.css" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/persian-date@1.1.0/dist/persian-date.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/js/persian-datepicker.min.js"></script>
    <script>
        var hfDateFromId = '<%= hfDateFrom.ClientID %>';
        var hfDateToId = '<%= hfDateTo.ClientID %>';

        function initDatePickers() {
            initPersianDatePicker('<%= txtDateFrom.ClientID %>', hfDateFromId);
            initPersianDatePicker('<%= txtDateTo.ClientID %>', hfDateToId);
        }

        function initPersianDatePicker(textBoxId, hiddenFieldId) {
            var $el = $('#' + textBoxId);

            // اگر قبلاً روی این المان پیکری ست شده، اول destroy کن تا دوبار بایند نشه
            if ($el.data('persianDatepicker')) {
                $el.persianDatepicker('destroy');
            }

            $el.persianDatepicker({
                format: 'YYYY/MM/DD',
                autoClose: true,
                initialValue: false,

                onSelect: function (unixDate) {
                    var pd = new persianDate(unixDate);
                    var gd = pd.toCalendar('gregorian');

                    var y = String(gd.year());
                    var m = String(gd.month()).padStart(2, '0');
                    var d = String(gd.date()).padStart(2, '0');

                    document.getElementById(hiddenFieldId).value = y + '-' + m + '-' + d;
                }
            });
        }

        $(document).ready(function () {
            initDatePickers();
        });

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                initDatePickers();
            });
        }
    </script>
</asp:Content>
