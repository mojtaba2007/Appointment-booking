using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private readonly string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PageTitle = "مدیریت کاربران";

            if (!IsPostBack)
            {
                LoadStats();
                LoadUsers();
            }
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    ExecScalar(conn,
                        "SELECT COUNT(*) FROM Users",
                        v => litTotalCount.Text = v);

                    ExecScalar(conn,
                        "SELECT COUNT(*) FROM Users WHERE IsActive = 1",
                        v => litActiveCount.Text = v);

                    ExecScalar(conn,
                        "SELECT COUNT(*) FROM Users WHERE Role = 'Admin'",
                        v => litAdminCount.Text = v);

                    ExecScalar(conn,
                        @"SELECT COUNT(*) FROM Users
                          WHERE MONTH(CreatedAt) = MONTH(GETDATE())
                            AND YEAR(CreatedAt)  = YEAR(GETDATE())
                            AND Role = 'User'",
                        v => litNewCount.Text = v);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[LoadStats] " + ex.Message);
            }
        }

        private void LoadUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string q = @"
                        SELECT u.UserID, u.FullName, u.Email, u.Phone,
                               u.Role, u.IsActive, u.CreatedAt,
                               (SELECT COUNT(*) FROM Appointments a
                                WHERE a.UserID = u.UserID
                                  AND a.Status <> 'Cancelled') AS ApptCount
                        FROM Users u
                        WHERE 1 = 1";

                    if (!string.IsNullOrEmpty(CurrentSearch))
                        q += @" AND (u.FullName LIKE @Search
                                  OR u.Email    LIKE @Search
                                  OR u.Phone    LIKE @Search)";

                    if (!string.IsNullOrEmpty(CurrentRoleFilter))
                        q += " AND Role = @Role";

                    if (CurrentStatusFilter == "1")
                        q += " AND u.IsActive = 1";
                    else if (CurrentStatusFilter == "0")
                        q += " AND u.IsActive = 0";

                    q += " ORDER BY CreatedAt DESC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        if (!string.IsNullOrEmpty(CurrentSearch))
                            cmd.Parameters.AddWithValue("@Search", "%" + CurrentSearch.Trim() + "%");
                        if (!string.IsNullOrEmpty(CurrentRoleFilter))
                            cmd.Parameters.AddWithValue("@Role", CurrentRoleFilter);

                        DataTable dt = new DataTable();
                        new SqlDataAdapter(cmd).Fill(dt);
                        gvUsers.DataSource = dt;
                        gvUsers.DataBind();
                        litResultCount.Text = dt.Rows.Count.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری کاربران.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadUsers] " + ex.Message);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            CurrentSearch = SecureData.CheckSecurity(txtSearch.Text);
            CurrentRoleFilter = ddlFilterRole.SelectedValue;
            CurrentStatusFilter = ddlFilterStatus.SelectedValue;
            LoadStats();
            LoadUsers();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterRole.SelectedValue = "";
            ddlFilterStatus.SelectedValue = "";
            CurrentSearch = CurrentRoleFilter = CurrentStatusFilter = "";
            LoadStats();
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object source, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument?.ToString(), out int userId))
            {
                return;
            }

            switch (e.CommandName)
            {
                case "ViewDetail":
                    LoadDetailModal(userId);
                    return;
                case "ToggleActive":
                    ToggleActive(userId);
                    break;
                case "ChangeRole":
                    ChangeRole(userId);
                    break;
            }

            LoadStats();
            LoadUsers();
        }

        private void LoadDetailModal(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    const string userQ = @"
                        SELECT u.UserID, u.FullName, u.Email, u.Phone,
                               u.Role, u.IsActive, u.CreatedAt,
                               (SELECT COUNT(*) FROM Appointments a
                                WHERE  a.UserID = u.UserID
                                  AND  a.Status <> 'Cancelled') AS ApptCount
                        FROM Users u WHERE UserID = @ID";

                    using (SqlCommand cmd = new SqlCommand(userQ, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", userId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (!dr.Read()) { ShowMessage("کاربر یافت نشد.", "danger"); return; }

                            bool isActive = Convert.ToBoolean(dr["IsActive"]);
                            string role = dr["Role"].ToString();
                            string fullName = dr["FullName"].ToString();
                            bool isSelf = userId == CurrentAdminId;

                            litModalUserName.Text = Server.HtmlEncode(fullName);
                            litModalEmail.Text = Server.HtmlEncode(dr["Email"].ToString());
                            litModalPhone.Text = Server.HtmlEncode(dr["Phone"].ToString());
                            litModalCreated.Text = Convert.ToDateTime(dr["CreatedAt"]).ToString("yyyy/MM/dd");
                            litModalApptCount.Text = dr["ApptCount"].ToString();
                            litModalRole.Text = BuildRoleBadge(role, large: true);
                            litModalStatus.Text = BuildActiveBadge(isActive, large: true);
                            litModalSelfNote.Text = isSelf
                                ? "<span class=\"badge bg-info ms-2 badge-xs\">حساب شما</span>"
                                : "";

                            litModalInitial.Text = fullName.Length > 0
                                ? Server.HtmlEncode(fullName.Substring(0, 1))
                                : "؟";

                            divModalAvatar.Attributes["style"] =
                                "background:" + GetAvatarGradient(fullName) + ";";

                            _UseId = userId;

                            btnModalToggleActive.Visible = !isSelf;
                            btnModalChangeRole.Visible = !isSelf;

                            if (!isSelf)
                            {
                                btnModalToggleActive.Text = isActive ? "غیرفعال کردن" : "فعال کردن";
                                btnModalToggleActive.CssClass = isActive
                                    ? "btn btn-sm btn-outline-warning"
                                    : "btn btn-sm btn-outline-success";
                                btnModalToggleActive.OnClientClick = isActive
                                    ? "return confirm(\"آیا از غیرفعال کردن این حساب اطمینان دارید؟\")"
                                    : "return confirm(\"آیا از فعال کردن این حساب اطمینان دارید؟\")";

                                btnModalChangeRole.Text = role == "Admin"
                                    ? "تنزیل به کاربر عادی"
                                    : "ارتقا به ادمین";
                                btnModalChangeRole.CssClass = role == "Admin"
                                    ? "btn btn-sm btn-outline-secondary"
                                    : "btn btn-sm btn-outline-primary";
                                btnModalChangeRole.OnClientClick = role == "Admin"
                                    ? "return confirm(\"آیا از تنزیل رتبه این مدیر اطمینان دارید؟\")"
                                    : "return confirm(\"آیا از ارتقای این کاربر به ادمین اطمینان دارید؟\")";
                            }
                        }
                        if (int.TryParse(litModalApptCount.Text, out int lenappt) && lenappt > 5)
                        {
                            btnToggleAppointments.Visible = true;
                        }
                        else
                        {
                            btnToggleAppointments.Visible = false;
                        }
                    }
                    ShowAllAppointments = false;

                    LoadAppointments(conn, userId);
                }

                LoadStats();
                LoadUsers();
                RegisterModalScript(true);
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری اطلاعات کاربر.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadDetailModal] " + ex.Message);
            }
        }


        private void LoadAppointments(SqlConnection conn, int userId)
        {
            string top = ShowAllAppointments ? "" : "TOP 5";

            liappointment.Text = ShowAllAppointments
                ? "همه‌ی نوبت‌ها"
                : "آخرین ۵ نوبت";

            string q = $@"
                        SELECT {top}
                               s.Name AS ServiceName,
                               a.AppointmentDate,
                               a.StartTime,
                               DATEADD(MINUTE,s.DurationMinutes,
                               CAST(a.StartTime AS DATETIME)) AS EndTime,
                               a.Status,
                               s.Price
                        FROM Appointments a
                        JOIN Services s ON s.ServiceID = a.ServiceID
                        WHERE a.UserID=@ID
                        ORDER BY a.AppointmentDate DESC,a.StartTime DESC";

            using (SqlCommand cmd = new SqlCommand(q, conn))
            {
                cmd.Parameters.AddWithValue("@ID", userId);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                gvUserAppts.DataSource = dt;
                gvUserAppts.DataBind();

                pnlNoAppts.Visible = dt.Rows.Count == 0;
                gvUserAppts.Visible = dt.Rows.Count > 0;
            }

            btnToggleAppointments.Text =
                ShowAllAppointments
                ? "نمایش ۵ نوبت آخر"
                : "مشاهده همه";
            RegisterModalScript(true);
        }

        protected void btnToggleAppointments_Click(object sender, EventArgs e)
        {
            ShowAllAppointments = !ShowAllAppointments;

            using (SqlConnection conn = new SqlConnection(_connStr))
            {
                conn.Open();

                LoadAppointments(conn, Convert.ToInt32(_UseId));
            }
        }

        protected void btnModalToggleActive_Click(object sender, EventArgs e)
        {
            ToggleActive(_UseId);
            RegisterModalScript(false);
            LoadStats();
            LoadUsers();
            _UseId = 0;
        }

        protected void btnModalChangeRole_Click(object sender, EventArgs e)
        {
            ChangeRole(_UseId);
            RegisterModalScript(false);
            LoadStats();
            LoadUsers();
            _UseId = 0;
        }

        private void ToggleActive(int userId)
        {
            if (userId == CurrentAdminId)
            {
                ShowMessage("نمی‌توانید حساب خود را غیرفعال کنید.", "warning");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    bool current;
                    using (SqlCommand sel = new SqlCommand(
                        "SELECT IsActive FROM Users WHERE UserID = @ID", conn))
                    {
                        sel.Parameters.AddWithValue("@ID", userId);
                        object r = sel.ExecuteScalar();
                        if (r == null) { ShowMessage("کاربر یافت نشد.", "danger"); return; }
                        current = Convert.ToBoolean(r);
                    }

                    bool newVal = !current;
                    using (SqlCommand upd = new SqlCommand(
                        "UPDATE Users SET IsActive = @A WHERE UserID = @ID", conn))
                    {
                        upd.Parameters.AddWithValue("@A", newVal);
                        upd.Parameters.AddWithValue("@ID", userId);
                        int affected = upd.ExecuteNonQuery();
                        ShowMessage(
                            affected > 0
                                ? (newVal ? "حساب کاربری با موفقیت فعال شد." : "حساب کاربری با موفقیت غیرفعال شد.")
                                : "خطا در تغییر وضعیت حساب.",
                            affected > 0 ? "success" : "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[ToggleActive] " + ex.Message);
            }
        }


        private void ChangeRole(int userId)
        {
            if (userId == CurrentAdminId)
            {
                ShowMessage("نمی‌توانید نقش حساب خود را تغییر دهید.", "warning");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string current;
                    using (SqlCommand sel = new SqlCommand(
                        "SELECT Role FROM Users WHERE UserID = @ID", conn))
                    {
                        sel.Parameters.AddWithValue("@ID", userId);
                        object r = sel.ExecuteScalar();
                        if (r == null) { ShowMessage("کاربر یافت نشد.", "danger"); return; }
                        current = r.ToString();
                    }

                    if (current == "Admin")
                    {
                        int adminCount;
                        using (SqlCommand cnt = new SqlCommand(
                            "SELECT COUNT(*) FROM Users WHERE Role = 'Admin'", conn))
                            adminCount = (int)cnt.ExecuteScalar();

                        if (adminCount <= 1)
                        {
                            ShowMessage("نمی‌توانید تنها مدیر سیستم را تنزیل رتبه دهید.", "warning");
                            return;
                        }
                    }

                    string newRole = (current == "Admin") ? "User" : "Admin";
                    using (SqlCommand upd = new SqlCommand(
                        "UPDATE Users SET Role = @Role WHERE UserID = @ID", conn))
                    {
                        upd.Parameters.AddWithValue("@Role", newRole);
                        upd.Parameters.AddWithValue("@ID", userId);
                        int affected = upd.ExecuteNonQuery();
                        ShowMessage(
                            affected > 0
                                ? (newRole == "Admin"
                                    ? "کاربر با موفقیت به ادمین ارتقا یافت."
                                    : "کاربر با موفقیت به نقش عادی تنزیل یافت.")
                                : "خطا در تغییر نقش کاربر.",
                            affected > 0 ? "success" : "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[ChangeRole] " + ex.Message);
            }
        }


        protected string GetActiveBadgeHtml(object isActive)
        {
            return BuildActiveBadge(Convert.ToBoolean(isActive), large: false);
        }

        protected string GetRoleBadgeHtml(object role)
        {
            return BuildRoleBadge(role?.ToString() ?? "", large: false);
        }

        protected string GetApptStatusBadgeHtml(object status)
        {
            return BuildApptStatusBadge(status?.ToString() ?? "");
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

        protected bool CanModify(object userId)
        {
            return Convert.ToInt32(userId) != CurrentAdminId;
        }


        protected string GetSelfBadgeHtml(object userId)
        {
            return Convert.ToInt32(userId) == CurrentAdminId
               ? "<span class=\"badge bg-info badge-xs ms-1\">شما</span>"
               : "";
        }

        // Dynamic CSS/icon for grid action buttons
        protected string GetToggleActiveCss(object isActive)
        {
            return Convert.ToBoolean(isActive)
                ? "btn btn-sm btn-outline-warning tbl-action"
                : "btn btn-sm btn-outline-success tbl-action";
        }

        protected string GetToggleActiveIcon(object isActive)
        {
            return Convert.ToBoolean(isActive) ? "bi-lock-fill" : "bi-unlock-fill";
        }

        protected string GetToggleActiveTitle(object isActive)
        {
            return Convert.ToBoolean(isActive) ? "غیرفعال کردن" : "فعال کردن";
        }

        protected string GetToggleActiveConfirm(object isActive)
        {
            return Convert.ToBoolean(isActive)
               ? "return confirm(\"آیا از غیرفعال کردن این حساب اطمینان دارید؟\")"
               : "return confirm(\"آیا از فعال کردن این حساب اطمینان دارید؟\")";
        }

        protected string GetChangeRoleCss(object role)
        {
            return role?.ToString() == "Admin"
               ? "btn btn-sm btn-outline-secondary tbl-action"
               : "btn btn-sm btn-outline-info tbl-action";
        }

        protected string GetChangeRoleIcon(object role)
        {
            return role?.ToString() == "Admin"
               ? "bi-arrow-down-circle-fill"
               : "bi-arrow-up-circle-fill";
        }

        protected string GetChangeRoleTitle(object role)
        {
            return role?.ToString() == "Admin" ? "تنزیل به کاربر عادی" : "ارتقا به ادمین";
        }
        protected string GetChangeRoleConfirm(object role)
        {
            return role?.ToString() == "Admin"
               ? "return confirm(\"آیا از تنزیل رتبه این مدیر اطمینان دارید؟\")"
               : "return confirm(\"آیا از ارتقای این کاربر به ادمین اطمینان دارید؟\")";
        }
        protected string FormatTime(object ts)
        {
            if (ts is TimeSpan t) return t.ToString(@"hh\:mm");
            if (ts is DateTime d) return d.TimeOfDay.ToString(@"hh\:mm");
            return ts?.ToString() ?? "";
        }

        private string BuildActiveBadge(bool isActive, bool large)
        {
            string size = large ? "fs-6 px-3 py-2" : "badge-sm";
            return isActive
                ? string.Format(
                    "<span class=\"badge rounded-pill bg-success {0}\"><i class=\"bi bi-check-circle-fill me-1\"></i>فعال</span>",
                    size)
                : string.Format(
                    "<span class=\"badge rounded-pill bg-secondary {0}\"><i class=\"bi bi-x-circle-fill me-1\"></i>غیرفعال</span>",
                    size);
        }

        private string BuildRoleBadge(string role, bool large)
        {
            string size = large ? "fs-6 px-3 py-2" : "badge-sm";
            return role == "Admin"
                ? string.Format(
                    "<span class=\" badge-admin {0}\"><i class=\"bi bi-shield-fill-check me-1\"></i>مدیر</span>",
                    size)
                : string.Format(
                    "<span class=\" badge-user {0}\"><i class=\"bi bi-person-fill me-1\"></i>کاربر</span>",
                    size);
        }

        private string BuildApptStatusBadge(string status)
        {
            switch (status)
            {
                case "Pending":
                    return "<span class=\"badge rounded-pill bg-warning text-dark badge-sm\"><i class=\"bi bi-hourglass-split me-1\"></i>در انتظار</span>";
                case "Confirmed":
                    return "<span class=\"badge rounded-pill bg-success badge-sm\"><i class=\"bi bi-check-circle-fill me-1\"></i>تأیید شده</span>";
                case "Completed":
                    return "<span class=\"badge rounded-pill bg-secondary badge-sm\"><i class=\"bi bi-check2-all me-1\"></i>انجام شده</span>";
                case "Cancelled":
                    return "<span class=\"badge rounded-pill bg-danger badge-sm\"><i class=\"bi bi-x-circle-fill me-1\"></i>لغو شده</span>";
                default:
                    return string.Format(
                        "<span class=\"badge rounded-pill bg-light text-dark badge-sm\">{0}</span>",
                        Server.HtmlEncode(status));
            }
        }


        // ai : باز و بستن مدال
        private void RegisterModalScript(bool show)
        {
            string js = show
                ? @"
                    (function(){
                        var el = document.getElementById('userDetailModal');

                        document.querySelectorAll('.modal-backdrop').forEach(function(b){
                            b.parentNode.removeChild(b);
                        });
                        document.body.classList.remove('modal-open');
                        document.body.style.removeProperty('padding-right');
                        document.body.style.removeProperty('overflow');

                        var m = bootstrap.Modal.getInstance(el);
                        if (m == null)
                            m = new bootstrap.Modal(el);

                        m.show();
                    })();"
                                        : @"
                    (function(){
                        var el = document.getElementById('userDetailModal');
                        var m = bootstrap.Modal.getInstance(el);
                        if (m)
                            m.hide();

                        setTimeout(function(){
                            document.querySelectorAll('.modal-backdrop').forEach(function(b){
                                b.parentNode.removeChild(b);
                            });
                            document.body.classList.remove('modal-open');
                            document.body.style.removeProperty('padding-right');
                            document.body.style.removeProperty('overflow');
                        }, 300);
                    })();";

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                Guid.NewGuid().ToString(),
                js,
                true);
        }

        private void ShowMessage(string msg, string type = "danger")
        {
            string icon = type == "success" ? "bi-check-circle-fill"
                        : type == "warning" ? "bi-exclamation-triangle-fill"
                        : "bi-x-circle-fill";
            lblMessage.Text = string.Format(
                "<i class=\"bi {0} me-2\"></i>{1}", icon, Server.HtmlEncode(msg));
            lblMessage.CssClass = string.Format(
                "alert alert-{0} d-block rounded-3 mb-3 d-flex align-items-center gap-2", type);
            lblMessage.Visible = true;
        }

        private static void ExecScalar(SqlConnection conn, string sql, Action<string> setter)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn))
                setter(cmd.ExecuteScalar()?.ToString() ?? "0");
        }
        private int _UseId
        {
            get => ViewState["_UseId"] as int? ?? 0;
            set => ViewState["_UseId"] = value;
        }
        private int CurrentAdminId
        {
            get { return Convert.ToInt32(Session["UserId"]); }
        }

        private string CurrentSearch
        {
            get { return ViewState["_srch"] as string ?? ""; }
            set { ViewState["_srch"] = value; }
        }
        private string CurrentRoleFilter
        {
            get { return ViewState["_rf"] as string ?? ""; }
            set { ViewState["_rf"] = value; }
        }
        private string CurrentStatusFilter
        {
            get { return ViewState["_sf"] as string ?? ""; }
            set { ViewState["_sf"] = value; }
        }
        private bool ShowAllAppointments
        {
            get => ViewState["ShowAllAppointments"] as bool? ?? false;
            set => ViewState["ShowAllAppointments"] = value;
        }

    }
}