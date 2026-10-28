 using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.Admin
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private readonly string _connStr =
                    ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PageTitle = "مدیریت نوبت‌ها";

            if (!IsPostBack)
            {
                LoadStats();
                LoadService();
                LoadAppointments();
            }
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    Executescalar(conn,
                        @"SELECT COUNT(*) FROM Appointments
                          WHERE AppointmentDate = CAST(GETDATE() AS DATE)
                            AND Status <> 'Cancelled'",
                        v => litTodayCount.Text = v);

                    Executescalar(conn,
                        @"SELECT COUNT(*) FROM Appointments WHERE Status = 'Completed'
                            AND MONTH(AppointmentDate) = MONTH(GETDATE())",
                        v => litDoneCount.Text = v);

                    Executescalar(conn,
                        "SELECT COUNT(*) FROM Appointments WHERE Status = 'Confirmed'",
                        v => litConfirmedCount.Text = v);

                    Executescalar(conn,
                        @"SELECT COUNT(*) FROM Appointments
                          WHERE MONTH(AppointmentDate) = MONTH(GETDATE())
                            AND YEAR(AppointmentDate)  = YEAR(GETDATE())
                            AND Status <> 'Cancelled'",
                        v => litMonthCount.Text = v);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[LoadStats] " + ex.Message);
            }
        }

        private void LoadService()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = "SELECT ServiceID, Name FROM Services ORDER BY Name";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlFilterService.Items.Clear();
                        ddlFilterService.Items.Add(new ListItem("همه سرویس‌ها", ""));
                        while (dr.Read())
                            ddlFilterService.Items.Add(new ListItem(
                                dr["Name"].ToString(), dr["ServiceID"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[LoadServiceDropdown] " + ex.Message);
            }
        }

        private void LoadAppointments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string q = @"
                        SELECT a.AppointmentID,
                               u.FullName AS UserName,
                               u.Phone,
                               u.Email,
                               s.Name AS ServiceName,
                               s.DurationMinutes,
                               s.Price,
                               a.AppointmentDate,
                               a.StartTime,
                               CAST(DATEADD(MINUTE, s.DurationMinutes,
                                   CAST(a.StartTime AS DATETIME)) AS Time) AS EndTime,
                               a.Status,
                               a.CreatedAt
                        FROM   Appointments a
                        JOIN   Users    u ON u.UserID    = a.UserID
                        JOIN   Services s ON s.ServiceID = a.ServiceID
                        WHERE  1 = 1";

                    if (!string.IsNullOrEmpty(CurrentSearchUser))
                        q += @" AND (u.FullName LIKE @Search
                                  OR u.Phone    LIKE @Search
                                  OR u.Email    LIKE @Search)";

                    if (!string.IsNullOrEmpty(CurrentStatusFilter))
                        q += " AND a.Status = @Status";

                    if (!string.IsNullOrEmpty(CurrentServiceFilter))
                        q += " AND a.ServiceID = @ServiceID";

                    if (!string.IsNullOrEmpty(CurrentDateFrom))
                        q += " AND a.AppointmentDate >= @DateFrom";

                    if (!string.IsNullOrEmpty(CurrentDateTo))
                        q += " AND a.AppointmentDate <= @DateTo";

                    q += " ORDER BY a.AppointmentDate DESC, a.StartTime DESC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        if (!string.IsNullOrEmpty(CurrentSearchUser))
                            cmd.Parameters.AddWithValue("@Search", "%" + CurrentSearchUser.Trim() + "%");

                        if (!string.IsNullOrEmpty(CurrentStatusFilter))
                            cmd.Parameters.AddWithValue("@Status", CurrentStatusFilter);

                        if (!string.IsNullOrEmpty(CurrentServiceFilter) &&
                            int.TryParse(CurrentServiceFilter, out int sid))
                            cmd.Parameters.AddWithValue("@ServiceID", sid);

                        if (!string.IsNullOrEmpty(CurrentDateFrom) &&
                            DateTime.TryParse(CurrentDateFrom, out DateTime df))
                            cmd.Parameters.AddWithValue("@DateFrom", df.Date);

                        if (!string.IsNullOrEmpty(CurrentDateTo) &&
                            DateTime.TryParse(CurrentDateTo, out DateTime dtt))
                            cmd.Parameters.AddWithValue("@DateTo", dtt.Date);

                        DataTable table = new DataTable();
                        new SqlDataAdapter(cmd).Fill(table);
                        gvAppointments.DataSource = table;
                        gvAppointments.DataBind();
                        litResultCount.Text = table.Rows.Count.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری نوبت‌ها.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadAppointments] " + ex.Message);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            CurrentSearchUser = SecureData.CheckSecurity(txtSearchUser.Text);
            CurrentStatusFilter = SecureData.CheckSecurity(ddlFilterStatus.SelectedValue);
            CurrentServiceFilter = SecureData.CheckSecurity(ddlFilterService.SelectedValue);
            CurrentDateFrom = SecureData.CheckSecurity(hfDateFrom.Value);
            CurrentDateTo = SecureData.CheckSecurity(hfDateTo.Value);
            LoadStats();
            LoadAppointments();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearchUser.Text = "";
            ddlFilterStatus.SelectedValue = "";
            ddlFilterService.SelectedValue = "";
            txtDateFrom.Text = "";
            hfDateFrom.Value = "";
            txtDateTo.Text = "";
            hfDateTo.Value = "";
            CurrentSearchUser = CurrentStatusFilter = CurrentServiceFilter =
                CurrentDateFrom = CurrentDateTo = "";
            LoadStats();
            LoadAppointments();
        }

        protected void gvAppointments_RowCommand(object source, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument?.ToString(), out int apptId)) return;

            switch (e.CommandName)
            {
                case "ViewDetail":
                    LoadDetailModal(apptId);
                    return;
                case "QuickConfirm":
                    ChangeStatus(apptId, "Confirmed");
                    break;
                case "QuickComplete":
                    ChangeStatus(apptId, "Completed");
                    break;
                case "QuickCancel":
                    ChangeStatus(apptId, "Cancelled");
                    break;
            }

            LoadStats();
            LoadAppointments();
        }

        private void LoadDetailModal(int apptId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = @"
                        SELECT a.AppointmentID,
                            u.FullName AS UserName, u.Phone, u.Email,
                            s.Name AS ServiceName, s.DurationMinutes, s.Price,
                            a.AppointmentDate, a.StartTime,
                            DATEADD(MINUTE, s.DurationMinutes,
                            CAST(a.StartTime AS DATETIME)) AS EndTime,
                            a.Status, a.CreatedAt
                        FROM Appointments a
                        JOIN Users u ON u.UserID = a.UserID
                        JOIN Services s ON s.ServiceID = a.ServiceID
                        WHERE a.AppointmentID = @ID";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", apptId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (!dr.Read())
                            {
                                ShowMessage("نوبت یافت نشد.", "danger");
                                return;
                            }

                            string status = dr["Status"].ToString();
                            TimeSpan startTs = (TimeSpan)dr["StartTime"];
                            DateTime endDt = (DateTime)dr["EndTime"];

                            litDetailUser.Text = Server.HtmlEncode(dr["UserName"].ToString());

                            litDetailPhone.Text = Server.HtmlEncode(dr["Phone"].ToString());

                            litDetailEmail.Text = Server.HtmlEncode(dr["Email"].ToString());

                            litDetailService.Text = Server.HtmlEncode(dr["ServiceName"].ToString());

                            litDetailDuration.Text = dr["DurationMinutes"].ToString();

                            litDetailPrice.Text = Convert.ToDecimal(dr["Price"]).ToString("N0");

                            litDetailDate.Text = Convert.ToDateTime(dr["AppointmentDate"]).ToString("yyyy/MM/dd");

                            litDetailTime.Text = startTs.ToString(@"hh\:mm") + " تا " + endDt.TimeOfDay.ToString(@"hh\:mm");

                            litDetailCreated.Text = Convert.ToDateTime(dr["CreatedAt"]).ToString("yyyy/MM/dd  HH:mm");

                            litDetailStatus.Text = BuildStatusBadge(status, large: true);

                            hfDetailApptId.Value = apptId.ToString();

                            btnModalComplete.Visible = (status == "Confirmed");
                            btnModalCancel.Visible = (status == "Confirmed");
                        }
                    }
                }

                LoadStats();
                LoadAppointments();
                RegisterModalScript(true);
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری جزئیات نوبت.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadDetailModal] " + ex.Message);
            }
        }

        protected void btnModalConfirm_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfDetailApptId.Value, out int id))
                ChangeStatus(id, "Confirmed");
            RegisterModalScript(false);
            LoadStats();
            LoadAppointments();
        }

        protected void btnModalComplete_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfDetailApptId.Value, out int id))
                ChangeStatus(id, "Completed");
            RegisterModalScript(false);
            LoadStats();
            LoadAppointments();
        }

        protected void btnModalCancel_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfDetailApptId.Value, out int id))
                ChangeStatus(id, "Cancelled");
            RegisterModalScript(false);
            LoadStats();
            LoadAppointments();
        }

        private void ChangeStatus(int apptId, string newStatus)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string current;
                    using (SqlCommand sel = new SqlCommand(
                        "SELECT AppointmentDate,Status FROM Appointments WHERE AppointmentID = @ID", conn))
                    {
                        sel.Parameters.AddWithValue("@ID", apptId);
                        using (SqlDataReader dr = sel.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                DateTime appointmentDate = Convert.ToDateTime(dr["AppointmentDate"]);

                                if ((appointmentDate.Date > DateTime.Now.Date) && (newStatus != "Cancelled"))
                                {
                                    ShowMessage("فقط در روز نویت یا بعد از آن میتوانید وضعیت را تغییر دهید.", "warning");
                                    return;
                                }
                            }
                        }
                        object r = sel.ExecuteScalar();
                        if (r == null) { ShowMessage("نوبت یافت نشد.", "danger"); return; }
                        current = r.ToString();
                    }

                    if (current == "Completed" || current == "Cancelled")
                    {
                        ShowMessage("این نوبت قابل تغییر وضعیت نیست.", "warning");
                        return;
                    }

                    using (SqlCommand upd = new SqlCommand(
                        "UPDATE Appointments SET Status = @Status WHERE AppointmentID = @ID", conn))
                    {
                        upd.Parameters.AddWithValue("@Status", newStatus);
                        upd.Parameters.AddWithValue("@ID", apptId);
                        int affected = upd.ExecuteNonQuery();

                        ShowMessage(affected > 0 ? GetStatusMessage(newStatus) : "خطا در تغییر وضعیت.",
                            affected > 0 ? "success" : "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[ChangeStatus] " + ex.Message);
            }
        }

        protected string GetStatusBadgeHtml(object status)
        {
            return BuildStatusBadge(
                status?.ToString() ?? "",
                false
            );
        }

        protected string FormatTime(object ts)
        {
            if (ts is TimeSpan t) return t.ToString(@"hh\:mm");
            if (ts is DateTime d) return d.TimeOfDay.ToString(@"hh\:mm");
            return ts?.ToString() ?? "";
        }

        protected string GetInitial(object name)
        {
            string n = name?.ToString() ?? "";
            return n.Length > 0 ? Server.HtmlEncode(n.Substring(0, 1)) : "؟";
        }

        protected string GetAvatarGradient(object name)
        {
            string[] g = {
                "linear-gradient(135deg,#6366f1,#4f46e5)",
                "linear-gradient(135deg,#10b981,#059669)",
                "linear-gradient(135deg,#f59e0b,#d97706)",
                "linear-gradient(135deg,#8b5cf6,#7c3aed)",
                "linear-gradient(135deg,#ec4899,#be185d)",
                "linear-gradient(135deg,#06b6d4,#0891b2)"
            };
            string n = name?.ToString() ?? "A";
            int idx = n.Length > 0 ? (n[0] % g.Length) : 0;
            return g[idx];
        }

        protected bool IsModifiable(object status)
        {
            string s = status?.ToString() ?? "";
            return s == "Confirmed";
        }

        protected bool IsConfirmed(object status)
        {
            return status?.ToString() == "Confirmed";
        }

        private string BuildStatusBadge(string status, bool large)
        {
            string cls, txt, icon;
            switch (status)
            {
                case "Confirmed":
                    cls = "bg-success"; txt = "تأیید شده"; icon = "bi-check-circle-fill";
                    break;
                case "Completed":
                    cls = "bg-secondary"; txt = "انجام شده"; icon = "bi-check2-all";
                    break;
                case "Cancelled":
                    cls = "bg-danger"; txt = "لغو شده"; icon = "bi-x-circle-fill";
                    break;
                default:
                    cls = "bg-light text-dark"; txt = Server.HtmlEncode(status); icon = "bi-circle";
                    break;
            }
            string size = large ? "fs-6 px-3 py-2" : "badge-sm";
            return string.Format(
                "<span class=\"badge rounded-pill {0} {1}\"><i class=\"bi {2} me-1\"></i>{3}</span>",
                cls, size, icon, txt);
        }

        private string GetStatusMessage(string status)
        {
            switch (status)
            {
                case "Confirmed": return "نوبت با موفقیت تأیید شد.";
                case "Completed": return "نوبت به عنوان «انجام‌شده» ثبت شد.";
                case "Cancelled": return "نوبت با موفقیت لغو شد.";
                default: return "وضعیت نوبت با موفقیت تغییر یافت.";
            }
        }

        private void RegisterModalScript(bool show)
        {
            string js = show
                ? "var __e=document.getElementById('detailModal');" +
                  "if(__e){bootstrap.Modal.getOrCreateInstance(__e).show();}"
                : "var __e=document.getElementById('detailModal');" +
                  "if(__e){var __m=bootstrap.Modal.getInstance(__e);if(__m)__m.hide();}";
            ScriptManager.RegisterStartupScript(
                this, GetType(), "apptModal_" + show.ToString().ToLower(), js, true);
        }

        private void ShowMessage(string msg, string type = "danger")
        {
            string headerClass;
            string bodyClass;
            string footerClass;
            string buttonClass;
            string title;
            string icon;

            switch (type)
            {
                case "success":
                    headerClass = "modal-header bg-success";
                    bodyClass = "modal-body bg-success bg-opacity-10 text-success";
                    footerClass = "modal-footer bg-success bg-opacity-10 border-0 justify-content-center";
                    buttonClass = "btn btn-success px-4";
                    title = "عملیات موفق";
                    icon = "<i class='bi bi-check-circle-fill display-1'></i>";
                    break;

                case "warning":
                    headerClass = "modal-header bg-warning";
                    bodyClass = "modal-body bg-warning bg-opacity-10 text-warning";
                    footerClass = "modal-footer bg-warning bg-opacity-10 border-0 justify-content-center";
                    buttonClass = "btn btn-warning px-4";
                    title = "هشدار";
                    icon = "<i class='bi bi-exclamation-triangle-fill display-1'></i>";
                    break;

                case "info":
                    headerClass = "modal-header bg-primary";
                    bodyClass = "modal-body bg-primary bg-opacity-10 text-primary";
                    footerClass = "modal-footer bg-primary bg-opacity-10 border-0 justify-content-center";
                    buttonClass = "btn btn-primary px-4";
                    title = "اطلاع رسانی";
                    icon = "<i class='bi bi-info-circle-fill display-1'></i>";
                    break;

                default:
                    headerClass = "modal-header bg-danger";
                    bodyClass = "modal-body bg-danger bg-opacity-10 text-danger";
                    footerClass = "modal-footer bg-danger bg-opacity-10 border-0 justify-content-center";
                    buttonClass = "btn btn-danger px-4";
                    title = "خطا";
                    icon = "<i class='bi bi-x-circle-fill display-1'></i>";
                    break;
            }

            modalHeader.Attributes["class"] = headerClass;
            modalBody.Attributes["class"] = bodyClass;
            modalFooter.Attributes["class"] = footerClass;

            btnModalOk.CssClass = buttonClass;

            modalTitle.InnerText = title;

            litModalIcon.Text = icon;
            litModalMessage.Text = Server.HtmlEncode(msg);

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "ShowMessageModal",
                @"var modal = bootstrap.Modal.getOrCreateInstance(
                document.getElementById('messageModal'));
                modal.show();",
                true);
        }

        private static void Executescalar(SqlConnection conn, string sql, Action<string> setter)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn))
                setter(cmd.ExecuteScalar()?.ToString() ?? "0");
        }
        public string ToShamsi(DateTime date)
        {
            PersianCalendar pc = new PersianCalendar();
            string persianDay = GetPersianDayName(date.DayOfWeek);

            return $"{pc.GetYear(date)}/{pc.GetMonth(date):00}/{pc.GetDayOfMonth(date):00},{persianDay}";
        }

        private static string GetPersianDayName(DayOfWeek day)
        {
            switch (day)
            {
                case DayOfWeek.Saturday: return "شنبه";
                case DayOfWeek.Sunday: return "یکشنبه";
                case DayOfWeek.Monday: return "دوشنبه";
                case DayOfWeek.Tuesday: return "سه‌شنبه";
                case DayOfWeek.Wednesday: return "چهارشنبه";
                case DayOfWeek.Thursday: return "پنجشنبه";
                case DayOfWeek.Friday: return "جمعه";
                default: return "";
            }
        }
        private string CurrentSearchUser
        {
            get { return ViewState["srchUser"] as string ?? ""; }
            set { ViewState["srchUser"] = value; }
        }
        private string CurrentStatusFilter
        {
            get { return ViewState["sf"] as string ?? ""; }
            set { ViewState["sf"] = value; }
        }
        private string CurrentServiceFilter
        {
            get { return ViewState["svc"] as string ?? ""; }
            set { ViewState["svc"] = value; }
        }
        private string CurrentDateFrom
        {
            get { return ViewState["df"] as string ?? ""; }
            set { ViewState["df"] = value; }
        }
        private string CurrentDateTo
        {
            get { return ViewState["dt"] as string ?? ""; }
            set { ViewState["dt"] = value; }
        }
    }
}