<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Appointment_booking.Pages.Admin.Dashboard" %>

<%@ MasterType VirtualPath="~/Pages/Admin/Admin.Master" %>
<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="body" ContentPlaceHolderID="MainContent" runat="server">
    <%--Page header --%>
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
        <div>
            <h5 class="fw-bold text-dark mb-0">داشبورد</h5>
            <p class="text-muted small mb-0 mt-1">خلاصه وضعیت سامانه نوبت‌دهی</p>
        </div>
        <span class="badge rounded-pill text-bg-light border px-3 py-2 small">
            <i class="bi bi-calendar3 me-1"></i>
            <asp:Literal ID="litCurrentDate" runat="server" />
        </span>
    </div>
    <%-- Stat cards (row 1) --%>
    <div class="row g-3 mb-3">

        <%-- نوبت‌های امروز --%>
        <div class="col-xl-3 col-md-6">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg,#6366f1,#4f46e5);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="bg-white bg-opacity-25 rounded-3 p-2 lh-1">
                            <i class="bi bi-calendar-event-fill text-white fs-4"></i>
                        </div>
                        <span class="badge bg-white bg-opacity-25 text-white small rounded-pill">امروز</span>
                    </div>
                    <div class="fs-1 fw-bold text-white lh-1">
                        <asp:Literal ID="litTodayCount" runat="server" Text="0" />
                    </div>
                    <div class="text-white mt-2 small" style="opacity: .8;">نوبت‌های امروز</div>
                </div>
            </div>
        </div>

        <%-- همه نوبت ها --%>
        <div class="col-xl-3 col-md-6">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg,#f59e0b,#d97706);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="bg-white bg-opacity-25 rounded-3 p-2 lh-1">
                            <i class="bi bi-calendar4-week text-white fs-4"></i>
                        </div>
                        <span class="badge bg-white bg-opacity-25 text-white small rounded-pill">کل نوبت ها</span>
                    </div>
                    <div class="fs-1 fw-bold text-white lh-1">
                        <asp:Literal ID="litAllCount" runat="server" Text="0" />
                    </div>
                    <div class="text-white mt-2 small" style="opacity: .8;">کل نوبت ها</div>
                </div>
            </div>
        </div>

        <%-- کاربران فعال --%>
        <div class="col-xl-3 col-md-6">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg,#10b981,#059669);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="bg-white bg-opacity-25 rounded-3 p-2 lh-1">
                            <i class="bi bi-people-fill text-white fs-4"></i>
                        </div>
                        <span class="badge bg-white bg-opacity-25 text-white small rounded-pill">فعال</span>
                    </div>
                    <div class="fs-1 fw-bold text-white lh-1">
                        <asp:Literal ID="litUserCount" runat="server" Text="0" />
                    </div>
                    <div class="text-white mt-2 small" style="opacity: .8;">کاربران فعال</div>
                </div>
            </div>
        </div>

        <%-- سرویس‌های فعال --%>
        <div class="col-xl-3 col-md-6">
            <div class="card border-0 shadow-sm h-100" style="background: linear-gradient(135deg,#8b5cf6,#7c3aed);">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="bg-white bg-opacity-25 rounded-3 p-2 lh-1">
                            <i class="bi bi-gear-wide-connected text-white fs-4"></i>
                        </div>
                        <span class="badge bg-white bg-opacity-25 text-white small rounded-pill">فعال</span>
                    </div>
                    <div class="fs-1 fw-bold text-white lh-1">
                        <asp:Literal ID="litServiceCount" runat="server" Text="0" />
                    </div>
                    <div class="text-white mt-2 small" style="opacity: .8;">سرویس‌های فعال</div>
                </div>
            </div>
        </div>

    </div>

    <%-- Row 2 : درآمد + دسترسی سریع --%>
    <div class="row g-3 mb-3">

        <%-- درآمد ماه جاری --%>
        <div class="col-xl-4 col-md-12">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="rounded-3 p-3 lh-1" style="background: linear-gradient(135deg,#ec4899,#be185d);">
                            <i class="bi bi-cash-coin text-white fs-4"></i>
                        </div>
                        <div>
                            <div class="text-muted small">مجموع مبلغ نوبت‌های ماه جاری</div>
                            <div class="fw-bold text-dark small">درآمد تخمینی</div>
                        </div>
                    </div>
                    <div class="d-flex align-items-baseline gap-2">
                        <span class="fs-2 fw-bold text-dark">
                            <asp:Literal ID="litMonthRevenue" runat="server" Text="0" />
                        </span>
                        <span class="text-muted small">تومان</span>
                    </div>
                    <div class="mt-3">
                        <span class="badge rounded-pill text-bg-success small">
                            <i class="bi bi-arrow-up-short"></i>ماه جاری
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <%-- دسترسی سریع --%>
        <div class="col-xl-8 col-md-12">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <h6 class="fw-bold text-dark mb-4">
                        <i class="bi bi-lightning-charge-fill text-warning me-2"></i>دسترسی سریع
                    </h6>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <a href="<%=ResolveUrl("~/Pages/Admin/ManageAppointments.aspx")%>"
                                class="quick-card d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none"
                                style="background: #f0f1ff; border: 1px solid #dde0ff;">
                                <div class="rounded-3 p-2 lh-1" style="background: #6366f1;">
                                    <i class="bi bi-calendar-check-fill text-white"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark small">مدیریت نوبت‌ها</div>
                                    <div class="text-muted" style="font-size: .72rem;">تأیید، لغو، تکمیل</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%=ResolveUrl("~/Pages/Admin/ManageServices.aspx")%>"
                                class="quick-card d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none"
                                style="background: #f0fdf4; border: 1px solid #bbf7d0;">
                                <div class="rounded-3 p-2 lh-1" style="background: #10b981;">
                                    <i class="bi bi-gear-fill text-white"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark small">مدیریت سرویس‌ها</div>
                                    <div class="text-muted" style="font-size: .72rem;">افزودن و ویرایش</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%=ResolveUrl("~/Pages/Admin/ManageUsers.aspx")%>"
                                class="quick-card d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none"
                                style="background: #faf5ff; border: 1px solid #e9d5ff;">
                                <div class="rounded-3 p-2 lh-1" style="background: #8b5cf6;">
                                    <i class="bi bi-people-fill text-white"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark small">مدیریت کاربران</div>
                                    <div class="text-muted" style="font-size: .72rem;">نقش‌ها و دسترسی</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="<%=ResolveUrl("~/Pages/User/Default.aspx")%>"
                                class="quick-card d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none"
                                style="background: #fffbeb; border: 1px solid #fde68a;">
                                <div class="rounded-3 p-2 lh-1" style="background: #f59e0b;">
                                    <i class="bi bi-globe text-white"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark small">مشاهده سایت</div>
                                    <div class="text-muted" style="font-size: .72rem;">پنل کاربری</div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <%-- Recent Appointments Table --%>
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-transparent border-0 px-4 pt-4 pb-0 d-flex align-items-center justify-content-between flex-wrap gap-2">
            <h6 class="fw-bold text-dark mb-0">
                <i class="bi bi-clock-history text-primary me-2"></i>آخرین نوبت‌های ثبت‌شده
            </h6>
            <a href="<%=ResolveUrl("~/Pages/Admin/ManageAppointments.aspx")%>"
                class="btn btn-sm btn-outline-primary rounded-pill px-3" style="font-size: .78rem;">مشاهده همه <i class="bi bi-arrow-left-short"></i>
            </a>
        </div>
        <div class="card-body p-0 pt-2">
            <div class="table-responsive px-2 pb-2">
                <asp:GridView ID="gvRecent" runat="server"
                    CssClass="table table-hover align-middle mb-0"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    EmptyDataText="هنوز هیچ نوبتی ثبت نشده است."
                    EmptyDataRowStyle-CssClass="text-center text-muted py-5">
                    <HeaderStyle CssClass="table-light" />
                    <Columns>

                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <span class="text-muted small"><%# ((GridViewRow)Container).RowIndex + 1 %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="کاربر">
                            <ItemTemplate>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center text-white flex-shrink-0"
                                        style="width: 30px; height: 30px; font-size: .78rem; background: linear-gradient(135deg,#6366f1,#8b5cf6);">
                                        <%# GetInitial(Eval("UserName")) %>
                                    </div>
                                    <span class="fw-semibold small"><%# Server.HtmlEncode(Eval("UserName").ToString()) %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="سرویس">
                            <ItemTemplate>
                                <span class="small"><%# Server.HtmlEncode(Eval("ServiceName").ToString()) %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="تاریخ">
                            <ItemTemplate>
                                <span class="small"><%# ToShamsi(Convert.ToDateTime(Eval("AppointmentDate"))) %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="ساعت">
                            <ItemTemplate>
                                <span class="small"><%# FormatTime(Eval("StartTime")) %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="وضعیت">
                            <ItemTemplate>
                                <span class="<%# GetStatusClass(Eval("Status").ToString()) %>">
                                    <%# GetStatusText(Eval("Status").ToString()) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="مبلغ (تومان)">
                            <ItemTemplate>
                                <span class="fw-semibold small"><%# Convert.ToDecimal(Eval("Price")).ToString("N0") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
                <div class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none"
                    style="background: #ffffff;"></div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="cScripts" ContentPlaceHolderID="Scripts" runat="server">
    <style>
        .quick-card {
            transition: filter .18s, transform .18s;
        }

            .quick-card:hover {
                filter: brightness(.96);
                transform: translateY(-2px);
            }
    </style>
</asp:Content>
