<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="Appointment_booking.Pages.Admin.ManageUsers" %>

<%@ MasterType VirtualPath="~/Pages/Admin/Admin.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/Assets/Admin/CSS/ManageUsers.css" rel="stylesheet" />
    <link href="../../Content/Assets/Admin/CSS/ManageAppoint.css" rel="stylesheet" />
    <style>
        .svc-stat-icon {
            width: 46px;
            height: 46px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="upMain" runat="server">
        <ContentTemplate>

            <%--   PAGE HEADER   --%>
            <div class="d-flex align-items-start justify-content-between mb-4 gap-2 flex-wrap">
                <div>
                    <h5 class="fw-bold mb-1">مدیریت کاربران</h5>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0 small">
                            <li class="breadcrumb-item">
                                <a href="Dashboard.aspx" class="text-decoration-none">
                                    <i class="bi bi-house-door"></i>داشبورد
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-muted">کاربران</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <%--   ALERT MESSAGE   --%>
            <asp:Label ID="lblMessage" runat="server" Visible="false"
                CssClass="alert d-block rounded-3 mb-3 d-flex align-items-center gap-2" />

            <%--   STATS ROW   --%>
            <div class="row g-3 mb-4">

                <%-- کل کاربران --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon" style="background: rgba(99,102,241,.12); color: #6366f1;">
                                <i class="bi bi-people-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">کل کاربران</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litTotalCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- کاربران فعال --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon" style="background: rgba(16,185,129,.12); color: #059669;">
                                <i class="bi bi-person-check-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">کاربران فعال</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litActiveCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- مدیران --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon" style="background: rgba(245,158,11,.12); color: #d97706;">
                                <i class="bi bi-shield-fill-check fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">مدیران سیستم</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litAdminCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- عضو جدید این ماه --%>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon" style="background: rgba(6,182,212,.12); color: #0891b2;">
                                <i class="bi bi-person-plus-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0 stat-label">عضو جدید این ماه</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litNewCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <%-- /stats --%>

            <%--   FILTER BAR   --%>
            <div class="card filter-card mb-3">
                <div class="card-body py-3 px-3">
                    <div class="row g-2 align-items-end">

                        <%-- جستجو --%>
                        <div class="col-12 col-md-5">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">
                                جستجو
                            </label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-white border-end-0 text-muted">
                                    <i class="bi bi-search" style="font-size: .78rem;"></i>
                                </span>
                                <asp:TextBox ID="txtSearch" runat="server"
                                    CssClass="form-control form-control-sm border-start-0 ps-0"
                                    placeholder="نام، ایمیل یا شماره تلفن..." />
                            </div>
                        </div>

                        <%-- نقش --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">نقش</label>
                            <asp:DropDownList ID="ddlFilterRole" runat="server"
                                CssClass="form-select form-select-sm">
                                <asp:ListItem Value="">همه نقش‌ها</asp:ListItem>
                                <asp:ListItem Value="User">کاربر عادی</asp:ListItem>
                                <asp:ListItem Value="Admin">مدیر</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <%-- وضعیت --%>
                        <div class="col-6 col-md-2">
                            <label class="form-label form-label-sm fw-semibold text-muted mb-1">وضعیت</label>
                            <asp:DropDownList ID="ddlFilterStatus" runat="server"
                                CssClass="form-select form-select-sm">
                                <asp:ListItem Value="">همه وضعیت‌ها</asp:ListItem>
                                <asp:ListItem Value="1">فعال</asp:ListItem>
                                <asp:ListItem Value="0">غیرفعال</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <%-- دکمه‌ها --%>
                        <div class="col-12 col-md-3 d-flex gap-2 justify-content-md-end">
                            <asp:Button ID="btnFilter" runat="server"
                                Text="جستجو"
                                CssClass="btn btn-sm btn-primary"
                                OnClick="btnFilter_Click" CausesValidation="false" />
                            <asp:Button ID="btnResetFilter" runat="server"
                                Text="پاک‌سازی"
                                CssClass="btn btn-sm btn-outline-secondary"
                                OnClick="btnResetFilter_Click" CausesValidation="false" />
                        </div>

                    </div>
                </div>
            </div>
            <%-- /filter --%>

            <%--   USERS GRIDVIEW   --%>
            <div class="card grid-card">
                <div class="card-header py-3 d-flex align-items-center justify-content-between">
                    <span class="small fw-semibold text-secondary">
                        <i class="bi bi-table me-1"></i>لیست کاربران
                    </span>
                    <span class="badge bg-secondary rounded-pill badge-sm">
                        <asp:Literal ID="litResultCount" runat="server" Text="0" />
                        مورد
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvUsers" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="table table-hover align-middle mb-0"
                            GridLines="None"
                            OnRowCommand="gvUsers_RowCommand">
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

                                <%-- کاربر: آواتار , نام , ایمیل --%>
                                <asp:TemplateField HeaderText="کاربر">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="appt-avatar text-white flex-shrink-0"
                                                style='background: <%# GetAvatarGradient(Eval("FullName")) %>'>
                                                <%# GetInitial(Eval("FullName")) %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold small lh-sm">
                                                    <%# Server.HtmlEncode(Eval("FullName").ToString()) %>
                                                    <%# GetSelfBadgeHtml(Eval("UserID")) %>
                                                </div>
                                                <div class="text-muted lh-sm" style="font-size: .72rem;">
                                                    <%# Server.HtmlEncode(Eval("Email").ToString()) %>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- تلفن --%>
                                <asp:TemplateField HeaderText="تلفن">
                                    <ItemTemplate>
                                        <span class="small text-muted">
                                            <%# Server.HtmlEncode(Eval("Phone").ToString()) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- نقش --%>
                                <asp:TemplateField HeaderText="نقش">
                                    <ItemTemplate>
                                        <span>
                                            <%# GetRoleBadgeHtml(Eval("Role")) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- وضعیت --%>
                                <asp:TemplateField HeaderText="وضعیت">
                                    <ItemTemplate>
                                        <%# GetActiveBadgeHtml(Eval("IsActive")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- تعداد نوبت --%>
                                <asp:TemplateField HeaderText="نوبت‌ها">
                                    <ItemTemplate>
                                        <span class='<%# Convert.ToInt32(Eval("ApptCount")) > 0 ? "badge rounded-pill bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 badge-sm" : "badge rounded-pill bg-light text-muted border badge-sm" %>'>
                                            <i class="bi bi-calendar2-check me-1"></i>
                                            <%# Eval("ApptCount") %>
                                        </span>
                                    </ItemTemplate>
                                    <HeaderStyle Width="90px" />
                                </asp:TemplateField>

                                <%-- تاریخ عضویت --%>
                                <asp:TemplateField HeaderText="عضویت">
                                    <ItemTemplate>
                                        <span class="small text-muted">
                                            <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("yyyy/MM/dd") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- عملیات --%>
                                <asp:TemplateField HeaderText="عملیات">
                                    <ItemTemplate>
                                        <div class="d-flex gap-1 pe-2">

                                            <%-- مشاهده جزئیات --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="ViewDetail"
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass="btn btn-sm btn-outline-primary tbl-action"
                                                CausesValidation="false"
                                                title="مشاهده پروفایل و نوبت‌ها">
                                                <i class="bi bi-eye-fill"></i>
                                            </asp:LinkButton>

                                            <%-- تغییر نقش فقط غیر خود --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="ChangeRole"
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass='<%# GetChangeRoleCss(Eval("Role")) %>'
                                                CausesValidation="false"
                                                Visible='<%# CanModify(Eval("UserID")) %>'
                                                OnClientClick='<%# GetChangeRoleConfirm(Eval("Role")) %>'
                                                title='<%# GetChangeRoleTitle(Eval("Role")) %>'>
                                                <i class='bi <%# GetChangeRoleIcon(Eval("Role")) %>'></i>
                                            </asp:LinkButton>

                                            <%-- فعال/غیرفعال: فقط غیر خود --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="ToggleActive"
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass='<%# GetToggleActiveCss(Eval("IsActive")) %>'
                                                CausesValidation="false"
                                                Visible='<%# CanModify(Eval("UserID")) %>'
                                                OnClientClick='<%# GetToggleActiveConfirm(Eval("IsActive")) %>'
                                                title='<%# GetToggleActiveTitle(Eval("IsActive")) %>'>
                                                <i class='bi <%# GetToggleActiveIcon(Eval("IsActive")) %>'></i>
                                            </asp:LinkButton>

                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle Width="110px" />
                                </asp:TemplateField>

                            </Columns>

                            <EmptyDataTemplate>
                                <div class="text-center py-5">
                                    <div class="text-muted mb-3" style="font-size: 3rem;">
                                        <i class="bi bi-people"></i>
                                    </div>
                                    <p class="text-muted mb-1 fw-semibold">هیچ کاربری یافت نشد</p>
                                    <small class="text-muted">فیلترها را تغییر دهید یا جستجوی جدید انجام دهید</small>
                                </div>
                            </EmptyDataTemplate>

                        </asp:GridView>
                    </div>
                </div>
            </div>
            <%-- /grid --%>

            <%--   USER DETAIL MODAL   --%>
            <div class="modal fade" id="userDetailModal" tabindex="-1"
                data-bs-backdrop="static" aria-labelledby="userDetailModalLabel">
                <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                    <div class="modal-content border-0 shadow-lg">

                        <%-- Header --%>
                        <div class="modal-header border-0 px-4 pt-4 pb-0">
                            <h6 class="modal-title fw-bold text-dark" id="userDetailModalLabel">
                                <i class="bi bi-person-badge text-primary me-2"></i>پروفایل کاربر
                            </h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="بستن"></button>
                        </div>

                        <%-- Body --%>
                        <div class="modal-body px-4 pt-3 pb-2">

                            <%-- Profile Section --%>
                            <div class="usr-profile-card mb-4">
                                <div class="d-flex align-items-center gap-4 flex-wrap">

                                    <%-- Large Avatar --%>
                                    <div id="divModalAvatar" runat="server"
                                        class="appt-avatar text-white flex-shrink-0">
                                        <asp:Literal ID="litModalInitial" runat="server" />
                                    </div>

                                    <%-- Name Badges Info --%>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center flex-wrap gap-2 mb-2">
                                            <h5 class="fw-bold mb-0">
                                                <asp:Literal ID="litModalUserName" runat="server" />
                                            </h5>
                                            <asp:Literal ID="litModalSelfNote" runat="server" />
                                        </div>
                                        <div class="d-flex flex-wrap gap-2 mb-3">
                                            <asp:Literal ID="litModalRole" runat="server" />
                                            <asp:Literal ID="litModalStatus" runat="server" />
                                        </div>
                                        <div class="row g-2">
                                            <div class="col-auto">
                                                <div class="usr-info-chip">
                                                    <i class="bi bi-envelope text-muted"></i>
                                                    <span>
                                                        <asp:Literal ID="litModalEmail" runat="server" /></span>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <div class="usr-info-chip">
                                                    <i class="bi bi-telephone text-muted"></i>
                                                    <span>
                                                        <asp:Literal ID="litModalPhone" runat="server" /></span>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <div class="usr-info-chip">
                                                    <i class="bi bi-calendar-plus text-muted"></i>
                                                    <span>عضو از
                                                        <asp:Literal ID="litModalCreated" runat="server" /></span>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <div class="usr-info-chip">
                                                    <i class="bi bi-calendar2-check text-primary"></i>
                                                    <span class="text-primary fw-semibold">
                                                        <asp:Literal ID="litModalApptCount" runat="server" />
                                                        نوبت ثبت‌شده
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <%-- /profile --%>

                            <%-- Appoint Section --%>
                            <div>
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="fw-semibold small text-secondary">
                                        <i class="bi bi-clock-history me-1"></i>
                                        <asp:Literal ID="liappointment" runat="server" />
                                    </span>
                                    <asp:Button ID="btnToggleAppointments"
                                        Visible="false"
                                        runat="server"
                                        CssClass="btn btn-info btn-sm"
                                        Text="مشاهده همه"
                                        OnClick="btnToggleAppointments_Click"
                                        CausesValidation="false" />
                                </div>

                                <%-- No appoint --%>
                                <asp:Panel ID="pnlNoAppts" runat="server" Visible="false">
                                    <div class="text-center py-4 rounded-3"
                                        style="background: #f8f9fc; border: 1px dashed #dee2e6;">
                                        <i class="bi bi-calendar-x text-muted" style="font-size: 2rem;"></i>
                                        <p class="text-muted mt-2 mb-0 small">این کاربر هنوز نوبتی ثبت نکرده است.</p>
                                    </div>
                                </asp:Panel>

                                <%-- Appoint GridView --%>
                                <asp:GridView ID="gvUserAppts" runat="server"
                                    AutoGenerateColumns="false"
                                    CssClass="table table-sm table-hover align-middle mb-0 appt-mini-table"
                                    GridLines="None"
                                    Visible="false">
                                    <HeaderStyle CssClass="appt-tbl-header" />
                                    <Columns>

                                        <asp:TemplateField HeaderText="سرویس">
                                            <ItemTemplate>
                                                <span class="small fw-semibold">
                                                    <%# Server.HtmlEncode(Eval("ServiceName").ToString()) %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="تاریخ">
                                            <ItemTemplate>
                                                <span class="small">
                                                    <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("yyyy/MM/dd") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="ساعت">
                                            <ItemTemplate>
                                                <span class="small text-muted">
                                                    <%# FormatTime(Eval("StartTime")) %> – <%# FormatTime(Eval("EndTime")) %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="وضعیت">
                                            <ItemTemplate>
                                                <%# GetApptStatusBadgeHtml(Eval("Status")) %>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="قیمت (تومان)">
                                            <ItemTemplate>
                                                <span class="small fw-semibold">
                                                    <%# Convert.ToDecimal(Eval("Price")).ToString("N0") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>

                            </div>
                            <%-- /appointments --%>
                        </div>
                        <%-- /modal-body --%>

                        <%-- Footer --%>
                        <div class="modal-footer bg-light border-top py-3 px-4 gap-2 flex-wrap">
                            <button type="button" class="btn btn-sm btn-outline-secondary"
                                data-bs-dismiss="modal">
                                <i class="bi bi-x-lg me-1"></i>بستن
                            </button>

                            <%-- تغییر وضعیت --%>
                            <asp:Button ID="btnModalToggleActive" runat="server"
                                Visible="false"
                                CssClass="btn btn-sm btn-outline-warning"
                                OnClick="btnModalToggleActive_Click"
                                CausesValidation="false" />

                            <%-- تغییر نقش --%>
                            <asp:Button ID="btnModalChangeRole" runat="server"
                                Visible="false"
                                CssClass="btn btn-sm btn-outline-primary"
                                OnClick="btnModalChangeRole_Click"
                                CausesValidation="false" />
                        </div>

                    </div>
                </div>
            </div>
            <%-- /modal --%>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
</asp:Content>
