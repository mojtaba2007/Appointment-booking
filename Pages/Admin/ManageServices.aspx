<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageServices.aspx.cs" Inherits="Appointment_booking.Pages.Admin.ManageServices" %>

<%@ MasterType VirtualPath="~/Pages/Admin/Admin.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/Assets/Admin/CSS/ManageService.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <asp:UpdatePanel ID="upMain" runat="server">
        <ContentTemplate>

            <%-- ═══ Page Header   ════════════ --%>
            <div class="d-flex align-items-start justify-content-between mb-4 gap-2 flex-wrap">
                <div>
                    <h5 class="fw-bold mb-1">مدیریت سرویس‌ها</h5>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0 small">
                            <li class="breadcrumb-item">
                                <a href="Dashboard.aspx" class="text-decoration-none">
                                    <i class="bi bi-house-door"></i>داشبورد
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-muted">سرویس‌ها</li>
                        </ol>
                    </nav>
                </div>
                <asp:LinkButton ID="btnAddNew" runat="server"
                    CssClass="btn btn-primary d-inline-flex align-items-center gap-2"
                    OnClick="btnAddNew_Click" CausesValidation="false">
                <i class="bi bi-plus-circle-fill"></i> افزودن سرویس
                </asp:LinkButton>
            </div>

            <%-- ═══ Alert Message   ══════════ --%>
            <asp:Label ID="lblMessage" runat="server" Visible="false"
                CssClass="alert d-block rounded-3 mb-3 d-flex align-items-center gap-2" />

            <%-- ═══ Stats Row     --%>
            <div class="row g-3 mb-4">
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-grid-3x3-gap-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0" style="font-size: .76rem">کل سرویس‌ها</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litTotalCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-check-circle-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0" style="font-size: .76rem">سرویس فعال</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litActiveCount" runat="server" Text="—" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-clock-fill fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0" style="font-size: .76rem">میانگین مدت</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litAvgDuration" runat="server" Text="—" />
                                    <small class="fs-6 fw-normal text-muted">دقیقه</small>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="card card-stat h-100">
                        <div class="card-body d-flex align-items-center gap-3">
                            <div class="svc-stat-icon bg-info bg-opacity-10 text-info">
                                <i class="bi bi-cash-coin fs-5"></i>
                            </div>
                            <div>
                                <p class="text-muted mb-0" style="font-size: .76rem">میانگین قیمت</p>
                                <h4 class="mb-0 fw-bold lh-1 mt-1">
                                    <asp:Literal ID="litAvgPrice" runat="server" Text="—" />
                                    <small class="fs-6 fw-normal text-muted">تومان</small>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- ═══ Filter Bar   ═════════════ --%>
            <div class="card filter-card mb-3">
                <div class="card-body py-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-white border-end-0 text-muted">
                                    <i class="bi bi-search small"></i>
                                </span>
                                <asp:TextBox ID="txtSearch" runat="server"
                                    CssClass="form-control form-control-sm border-start-0 ps-0"
                                    placeholder="جستجو در نام سرویس..." />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlFilterStatus" runat="server"
                                CssClass="form-select form-select-sm">
                                <asp:ListItem Value="">همه وضعیت‌ها</asp:ListItem>
                                <asp:ListItem Value="1">فعال</asp:ListItem>
                                <asp:ListItem Value="0">غیرفعال</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4 d-flex gap-2 justify-content-md-end">
                            <asp:Button ID="btnFilter" runat="server" Text="جستجو"
                                CssClass="btn btn-sm btn-outline-primary"
                                OnClick="btnFilter_Click" CausesValidation="false" />
                            <asp:Button ID="btnResetFilter" runat="server" Text="پاک‌سازی"
                                CssClass="btn btn-sm btn-outline-secondary"
                                OnClick="btnResetFilter_Click" CausesValidation="false" />
                        </div>
                    </div>
                </div>
            </div>

            <%-- ═══ Services Grid   ══════════ --%>
            <div class="card grid-card">
                <div class="card-header py-3 d-flex align-items-center justify-content-between">
                    <span class="small fw-semibold text-secondary">
                        <i class="bi bi-table me-1"></i>لیست سرویس‌ها
                    </span>
                    <span class="badge bg-secondary rounded-pill badge-sm">
                        <asp:Literal ID="litResultCount" runat="server" Text="0" />
                        مورد
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvServices" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="table table-hover align-middle mb-0"
                            GridLines="None"
                            OnRowCommand="gvServices_RowCommand">
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
                                    <HeaderStyle Width="55px" />
                                </asp:TemplateField>

                                <%-- Name --%>
                                <asp:TemplateField HeaderText="نام سرویس">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="svc-avatar bg-primary bg-opacity-10 text-primary">
                                                <i class="bi bi-scissors small"></i>
                                            </div>
                                            <span class="fw-semibold">
                                                <%# Server.HtmlEncode(Eval("Name").ToString()) %>
                                            </span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Duration --%>
                                <asp:TemplateField HeaderText="مدت زمان">
                                    <ItemTemplate>
                                        <span class="badge bg-light text-secondary border badge-sm">
                                            <i class="bi bi-clock me-1"></i><%# Eval("DurationMinutes") %> دقیقه
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Price --%>
                                <asp:TemplateField HeaderText="قیمت">
                                    <ItemTemplate>
                                        <span class="fw-semibold">
                                            <%# string.Format("{0:N0}", Eval("Price")) %>
                                        </span>
                                        <span class="text-muted small">تومان</span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Status --%>
                                <asp:TemplateField HeaderText="وضعیت">
                                    <ItemTemplate>
                                        <%# GetStatusBadge((bool)Eval("IsActive")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Actions --%>
                                <asp:TemplateField HeaderText="عملیات">
                                    <ItemTemplate>
                                        <div class="d-flex gap-1 pe-3">
                                            <asp:LinkButton runat="server"
                                                CommandName="EditService"
                                                CommandArgument='<%# Eval("ServiceID") %>'
                                                CssClass="btn btn-sm btn-outline-primary tbl-action"
                                                CausesValidation="false"
                                                title="ویرایش">
                                            <i class="bi bi-pencil-fill"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server"
                                                CommandName="ToggleActive"
                                                CommandArgument='<%# Eval("ServiceID") %>'
                                                CssClass='<%# (bool)Eval("IsActive")
                                                ? "btn btn-sm btn-outline-warning tbl-action"
                                                : "btn btn-sm btn-outline-success tbl-action" %>'
                                                CausesValidation="false"
                                                OnClientClick="return confirm('آیا از این تغییر اطمینان دارید؟')"
                                                title='<%# (bool)Eval("IsActive") ? "غیرفعال کردن" : "فعال کردن" %>'>
                                            <i class='<%# (bool)Eval("IsActive") ? "bi bi-pause-fill" : "bi bi-play-fill" %>'></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server"
                                                CommandName="DeleteService"
                                                CommandArgument='<%# Eval("ServiceID") %>'
                                                CssClass="btn btn-sm btn-outline-danger tbl-action"
                                                CausesValidation="false"
                                                OnClientClick="return confirm('آیا از حذف سرویس اطمینان دارید؟')"
                                                title="حذف کردن">
                                            <i class="bi bi-x-lg"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle Width="105px" />
                                </asp:TemplateField>

                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-5">
                                    <div class="text-muted mb-3" style="font-size: 3rem">
                                        <i class="bi bi-inbox"></i>
                                    </div>
                                    <p class="text-muted mb-1">هیچ سرویسی یافت نشد</p>
                                    <small class="text-muted">یک سرویس جدید اضافه کنید یا فیلتر را تغییر دهید</small>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <%-- ═══ Hidden Field   ══════════ --%>
            <asp:HiddenField ID="hfEditServiceId" runat="server" Value="0" />

            <%-- ═══ Add / Edit Modal   ══════ --%>
            <div class="modal fade" id="serviceModal" tabindex="-1"
                data-bs-backdrop="static" aria-labelledby="serviceModalLabel">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg">

                        <div class="modal-header bg-primary text-white py-3 px-4">
                            <h6 class="modal-title fw-semibold mb-0" id="serviceModalLabel">
                                <i class="bi bi-scissors me-2"></i>
                                <asp:Label ID="lblModalTitle" runat="server" Text="افزودن سرویس جدید" />
                            </h6>
                            <button type="button" class="btn-close btn-close-white"
                                data-bs-dismiss="modal" aria-label="بستن">
                            </button>
                        </div>

                        <div class="modal-body p-4">

                            <asp:ValidationSummary ID="valSummary" runat="server"
                                CssClass="alert alert-danger small mb-3 rounded-3 py-2"
                                HeaderText="لطفاً موارد زیر را برطرف کنید:"
                                ValidationGroup="ServiceForm" />

                            <%-- Name --%>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold mb-1">
                                    نام سرویس <span class="text-danger">*</span>
                                </label>
                                <asp:TextBox ID="txtName" runat="server"
                                    CssClass="form-control form-control-sm"
                                    placeholder="مثال: کوتاهی مو" MaxLength="100" />
                                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                                    ControlToValidate="txtName"
                                    ErrorMessage="نام سرویس الزامی است."
                                    Text="<div class='text-danger mt-1' style='font-size:.78rem'>نام سرویس الزامی است.</div>"
                                    Display="Dynamic" ValidationGroup="ServiceForm" />
                            </div>

                            <%-- Duration & Price (side by side) --%>
                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label class="form-label small fw-semibold mb-1">
                                        مدت زمان <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group input-group-sm">
                                        <asp:TextBox ID="txtDuration" runat="server"
                                            CssClass="form-control form-control-sm"
                                            placeholder="30" TextMode="Number" />
                                        <span class="input-group-text text-muted small">دقیقه</span>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvDuration" runat="server"
                                        ControlToValidate="txtDuration"
                                        ErrorMessage="مدت زمان الزامی است."
                                        Text="<div class='text-danger mt-1' style='font-size:.78rem'>الزامی است.</div>"
                                        Display="Dynamic" ValidationGroup="ServiceForm" />
                                    <asp:RangeValidator ID="rvDuration" runat="server"
                                        ControlToValidate="txtDuration"
                                        MinimumValue="5" MaximumValue="480" Type="Integer"
                                        ErrorMessage="مدت باید بین ۵ تا ۴۸۰ دقیقه باشد."
                                        Text="<div class='text-danger mt-1' style='font-size:.78rem'>بین ۵ تا ۴۸۰ دقیقه.</div>"
                                        Display="Dynamic" ValidationGroup="ServiceForm" />
                                </div>
                                <div class="col-sm-6">
                                    <label class="form-label small fw-semibold mb-1">
                                        قیمت <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group input-group-sm">
                                        <asp:TextBox ID="txtPrice" runat="server"
                                            CssClass="form-control form-control-sm"
                                            placeholder="0" TextMode="Number" />
                                        <span class="input-group-text text-muted small">تومان</span>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                                        ControlToValidate="txtPrice"
                                        ErrorMessage="قیمت الزامی است."
                                        Text="<div class='text-danger mt-1' style='font-size:.78rem'>الزامی است.</div>"
                                        Display="Dynamic" ValidationGroup="ServiceForm" />
                                    <asp:RangeValidator ID="rvPrice" runat="server"
                                        ControlToValidate="txtPrice"
                                        MinimumValue="1000" MaximumValue="999999999" Type="Double"
                                        ErrorMessage="مقدار قیمت باید بیشتر از ۱,۰۰۰ تومان باشد."
                                        Text="<div class='text-danger mt-1' style='font-size:.78rem'>مقدار قیمت باید بیشتر از ۱,۰۰۰ تومان باشد.</div>"
                                        Display="Dynamic" ValidationGroup="ServiceForm" />
                                </div>
                            </div>

                            <%-- IsActive toggle --%>
                            <div class="form-check form-switch">
                                <input id="chkIsActive" runat="server" type="checkbox"
                                    class="form-check-input" role="switch" />
                                <label class="form-check-label small" for="<%= chkIsActive.ClientID %>">
                                    سرویس <strong>فعال</strong> باشد
                                </label>
                            </div>

                        </div>
                        <%-- /modal-body --%>

                        <div class="modal-footer bg-light border-top py-3 px-4">
                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                data-bs-dismiss="modal">
                                <i class="bi bi-x-lg me-1"></i>انصراف
                            </button>
                            <asp:LinkButton ID="btnSave" runat="server"
                                CssClass="btn btn-primary btn-sm d-inline-flex align-items-center gap-2"
                                OnClick="btnSave_Click" ValidationGroup="ServiceForm">
                            <i class="bi bi-check-lg"></i>ذخیره سرویس
                            </asp:LinkButton>
                        </div>

                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Scripts" runat="server">
    <script src="../../Content/Assets/Admin/JS/ManageService.js"></script>
</asp:Content>
