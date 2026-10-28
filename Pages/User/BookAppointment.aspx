<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="BookAppointment.aspx.cs" Inherits="Appointment_booking.Pages.User.BookAppointment" ValidateRequest="true" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/css/persian-datepicker.min.css" />

    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <%--<link href="../../Content/Assets/User/CSS/BookAppoint.css" rel="stylesheet" />--%>
    <style>
        .booking-wrapper {
            max-width: 900px;
            margin: auto;
        }

        .glass-card {
            background: rgba(20,20,20,.9);
            border: 1px solid rgba(212,175,55,.25);
            border-radius: 18px;
            backdrop-filter: blur(12px);
            box-shadow: 0 0 20px rgba(212,175,55,.08);
            overflow: hidden;
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

        .custom-input,
        .form-select {
            background: #15181d !important;
            border: 1px solid #2a2f36 !important;
            color: white !important;
            padding: 12px;
            border-radius: 12px;
        }

            .custom-input:focus,
            .form-select:focus {
                border-color: #d4af37 !important;
                box-shadow: 0 0 0 3px rgba(212,175,55,.15) !important;
            }

        .input-group-text {
            background: #15181d !important;
            border: 1px solid #2a2f36 !important;
            color: #d4af37 !important;
        }

        .btn-gold {
            background: linear-gradient(135deg,#d4af37,#b99120);
            border: none;
            color: #111;
            font-weight: 600;
            border-radius: 12px;
            padding: 12px;
        }

        .steps {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .step {
            flex: 1;
            text-align: center;
            padding: 12px;
            border-radius: 12px;
            background: #15181d;
            color: #aaa;
            border: 1px solid #2a2f36;
        }

            .step.active {
                border-color: #d4af37;
                color: #d4af37;
            }

            .step.done {
                background: rgba(212,175,55,.08);
                color: #d4af37;
            }

        .slot-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill,minmax(110px,1fr));
            gap: 12px;
        }

        .slot-btn {
            background: #15181d;
            color: white;
            border: 1px solid #2a2f36;
            border-radius: 12px;
            padding: 12px;
            transition: .2s;
        }

            .slot-btn:hover {
                border-color: #d4af37;
            }

            .slot-btn.selected {
                background: #d4af37;
                color: #111;
                font-weight: bold;
            }

            .slot-btn.taken {
                opacity: .4;
                cursor: not-allowed;
            }

        #summaryBox {
            background: rgba(212,175,55,.05);
            border: 1px solid rgba(212,175,55,.12);
            border-radius: 14px;
            padding: 20px;
        }

        .fw-semibold {
            color: #cfcfcf;
        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <br />
    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert d-block mb-3" />

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />

    <div class="booking-wrapper">
        <div class="glass-card">

            <div class="card-header-custom">
                <h4 class="card-title-custom">
                    <i class="fas fa-calendar-plus me-2"></i>رزرو نوبت آنلاین
                </h4>
            </div>

            <div class="card-body p-4">

                <div class="steps">
                    <div class="step active" id="service">سرویس</div>
                    <div class="step" id="date">تاریخ</div>
                    <div class="step" id="hour">ساعت</div>
                    <div class="step" id="submit">تایید</div>
                </div>

                <div class="mb-4">
                    <label class="form-label">نوع سرویس</label>

                    <asp:DropDownList ID="ddlService" runat="server"
                        CssClass="form-select custom-input"
                        AutoPostBack="false">
                        <asp:ListItem Text="انتخاب کنید" Value="" />
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvService" runat="server"
                        ControlToValidate="ddlService" InitialValue=""
                        ErrorMessage="لطفا سرویس را انتخاب کنید."
                        CssClass="text-danger small"
                        Display="Dynamic"
                        ValidationGroup="BookingVG" />

                    <div id="serviceInfo" class="mt-2 text-muted small" style="display: none">
                        مدت: <span id="svcDuration"></span>دقیقه
                        &nbsp;|&nbsp;
                        قیمت: <span id="svcPrice"></span>تومان
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">تاریخ نوبت</label>

                    <div class="input-group">
                        <input type="text" id="txtDateDisplay"
                            class="form-control custom-input"
                            placeholder="۱۴۰۶/۰۱/۰۱"
                            readonly="readonly" />

                        <span class="input-group-text">
                            <i class="fas fa-calendar-alt"></i>
                        </span>
                    </div>

                    <asp:HiddenField ID="hfSelectedDate" runat="server" />

                    <span id="dateError" class="text-danger small" style="display: none">لطفا تاریخ را انتخاب کنید.
                    </span>
                </div>

                <div class="mb-4">
                    <label class="form-label">ساعت نوبت</label>

                    <asp:UpdatePanel ID="upSlots" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <asp:Button ID="btnLoadSlots" runat="server"
                                Text="بارگذاری"
                                CssClass="d-none"
                                CausesValidation="false"
                                OnClick="btnLoadSlots_Click" />

                            <asp:Panel ID="pnlSlotHint" runat="server">
                                <div class="text-muted small p-2">
                                    پس از انتخاب سرویس و تاریخ، ساعت‌های آزاد نمایش داده می‌شوند.
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlSlots" runat="server" Visible="false">
                                <asp:Repeater ID="rptSlots" runat="server"
                                    OnItemDataBound="rptSlots_ItemDataBound">

                                    <HeaderTemplate>
                                        <div class="slot-grid">
                                    </HeaderTemplate>

                                    <ItemTemplate>
                                        <button type="button"
                                            class='slot-btn <%# (bool)Eval("IsTaken") ? "taken" : "" %>'
                                            data-time='<%# Eval("TimeValue") %>'
                                            <%# (bool)Eval("IsTaken") ? "disabled=\"disabled\"" : "" %>
                                            onclick='selectSlot(this)'>
                                            <%# Eval("DisplayTime") %>
                                        </button>
                                    </ItemTemplate>

                                    <FooterTemplate>
                                        </div>
                                    </FooterTemplate>

                                </asp:Repeater>

                                <asp:Label ID="lblNoSlots" runat="server"
                                    Visible="false"
                                    Text="در این تاریخ ساعت آزادی وجود ندارد."
                                    CssClass="text-warning small d-block mt-2" />
                            </asp:Panel>

                            <asp:HiddenField ID="hfSelectedTime" runat="server" />

                        </ContentTemplate>

                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnLoadSlots" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                    <span id="timeError" class="text-danger small" style="display: none">لطفا ساعت را انتخاب کنید.
                    </span>
                </div>

                <div id="summaryBox" class="mb-4" style="display: none">
                    <h6 class="fw-bold mb-3" style="color: #d4af37;">خلاصه رزرو
                    </h6>

                    <div class="row gy-1">
                        <div class="col-5 text-muted">سرویس:</div>
                        <div class="col-7 fw-semibold" id="sumService"></div>

                        <div class="col-5 text-muted">تاریخ:</div>
                        <div class="col-7 fw-semibold" id="sumDate"></div>

                        <div class="col-5 text-muted">ساعت:</div>
                        <div class="col-7 fw-semibold" id="sumTime"></div>

                        <div class="col-5 text-muted">مدت:</div>
                        <div class="col-7 fw-semibold" id="sumDuration"></div>

                        <div class="col-5 text-muted">قیمت:</div>
                        <div class="col-7 fw-semibold text-success" id="sumPrice"></div>
                    </div>
                </div>

                <div class="d-grid">
                    <asp:Button ID="btnBook" runat="server"
                        Text="ثبت نوبت"
                        CssClass="btn btn-gold btn-lg w-100"
                        OnClick="btnBook_Click"
                        ValidationGroup="BookingVG"
                        OnClientClick="return validateForm();" />
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/persian-date@1.1.0/dist/persian-date.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/persian-datepicker@1.2.0/dist/js/persian-datepicker.min.js"></script>
    <script>
        var services = {};

        var ddlServiceId = '<%= ddlService.ClientID %>';
        var hfDateId = '<%= hfSelectedDate.ClientID %>';
        var hfTimeId = '<%= hfSelectedTime.ClientID %>';
        var btnLoadId = '<%= btnLoadSlots.ClientID %>';

        $(function () {
            $('#txtDateDisplay').persianDatepicker({
                format: 'YYYY/MM/DD',
                autoClose: true,
                initialValue: false,
                minDate: new persianDate().add('days', 1),
                onSelect: function (unixDate) {
                    var pd = new persianDate(unixDate);
                    var gd = pd.toCalendar('gregorian');
                    var y = gd.year();
                    var m = String(gd.month()).padStart(2, '0');
                    var d = String(gd.date()).padStart(2, '0');
                    document.getElementById(hfDateId).value = y + '-' + m + '-' + d;
                    document.getElementById('dateError').style.display = 'none';
                    tryLoadSlots();
                    updateSteps();
                }
            });

            document.getElementById(ddlServiceId).addEventListener('change', function () {
                var val = this.value;
                if (val && services[val]) {
                    document.getElementById('serviceInfo').style.display = 'block';
                    document.getElementById('svcDuration').textContent = services[val].duration;
                    document.getElementById('svcPrice').textContent =
                        Number(services[val].price).toLocaleString('fa');
                } else {
                    document.getElementById('serviceInfo').style.display = 'none';
                }
                tryLoadSlots();
            });
        });

        function tryLoadSlots() {
            var svcVal = document.getElementById(ddlServiceId).value;
            var dateVal = document.getElementById(hfDateId).value;
            if (!svcVal || !dateVal) return;
            document.getElementById(btnLoadId).click();
        }

        function selectSlot(btn) {
            document.querySelectorAll('.slot-btn.selected')
                .forEach(function (b) { b.classList.remove('selected'); });
            btn.classList.add('selected');
            document.getElementById(hfTimeId).value = btn.getAttribute('data-time');
            document.getElementById('timeError').style.display = 'none';
            updateSummary();
            updateSteps();
        }

        function updateSummary() {
            var ddl = document.getElementById(ddlServiceId);
            var svcVal = ddl.value;
            var fullText = ddl.options[ddl.selectedIndex].text;
            var svcText = fullText.replace(/\s*\(.*?\)\s*$/, '');
            var dateTxt = document.getElementById('txtDateDisplay').value;
            var time = document.getElementById(hfTimeId).value;

            if (!svcVal || !dateTxt || !time) {
                document.getElementById('summaryBox').style.display = 'none';
                return;
            }

            document.getElementById('summaryBox').style.display = 'block';
            document.getElementById('sumService').textContent = svcText;
            document.getElementById('sumDate').textContent = dateTxt;
            document.getElementById('sumTime').textContent = time;
            document.getElementById('sumDuration').textContent =
                (services[svcVal] ? services[svcVal].duration : '') + ' دقیقه';
            document.getElementById('sumPrice').textContent =
                (services[svcVal] ? Number(services[svcVal].price).toLocaleString('fa') : '') + ' تومان';
        }

        function validateForm() {
            var ok = true;
            if (!document.getElementById(hfDateId).value) {
                document.getElementById('dateError').style.display = 'block';
                ok = false;
            }
            if (!document.getElementById(hfTimeId).value) {
                document.getElementById('timeError').style.display = 'block';
                ok = false;
            }
            return ok;
        }

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var saved = document.getElementById(hfTimeId).value;
            if (saved) {
                document.querySelectorAll('.slot-btn').forEach(function (b) {
                    if (b.getAttribute('data-time') === saved)
                        b.classList.add('selected');
                });
            }
        });

        function updateSteps() {
            var svcVal = document.getElementById(ddlServiceId).value;
            var dateVal = document.getElementById(hfDateId).value;
            var timeVal = document.getElementById(hfTimeId).value;

            var divservice = document.getElementById("service");
            var divdate = document.getElementById("date");
            var divhour = document.getElementById("hour");
            var divsubmit = document.getElementById("submit");


            [divservice, divdate, divhour, divsubmit].forEach(function (d) {
                d.classList.remove("active", "done");
            });

            if (!svcVal) {
                divservice.classList.add("active");
                return;
            }
            divservice.classList.add("done");

            if (!dateVal) {
                divdate.classList.add("active");
                return;
            }
            divdate.classList.add("done");

            if (!timeVal) {
                divhour.classList.add("active");
                return;
            }
            divhour.classList.add("done");

            divsubmit.classList.add("active");
        }


        document.getElementById(ddlServiceId).addEventListener('change', updateSteps);
    </script>
    <%--<script src="../../Content/Assets/User/JS/BookAppoint.js"></script>--%>
</asp:Content>
