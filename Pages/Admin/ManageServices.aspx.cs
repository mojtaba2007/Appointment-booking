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
    public partial class ManageServices : System.Web.UI.Page
    {
        private readonly string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.PageTitle = "مدیریت سرویس‌ها";

            if (!IsPostBack)
            {
                LoadStats();
                LoadServices("", "");
            }

            if (IsPostBack && KeepModalOpen)
                RegisterModalScript(show: true);
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    ExecScalar(conn,
                        "SELECT COUNT(*) FROM Services",
                        v => litTotalCount.Text = v);

                    ExecScalar(conn,
                        "SELECT COUNT(*) FROM Services WHERE IsActive = 1",
                        v => litActiveCount.Text = v);

                    ExecScalar(conn,
                        "SELECT ROUND(AVG(CAST(DurationMinutes AS FLOAT)), 0) FROM Services WHERE IsActive = 1",
                        v => litAvgDuration.Text = v);

                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT AVG(Price) FROM Services WHERE IsActive = 1", conn))
                    {
                        object r = cmd.ExecuteScalar();
                        decimal avg = r != null ? Convert.ToDecimal(r) : 0m;
                        litAvgPrice.Text = avg.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[LoadStats] " + ex.Message);
            }
        }

        private void LoadServices(string search, string statusFilter)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string q = @"
                        SELECT ServiceID, Name, DurationMinutes, Price, IsActive
                        FROM   Services
                        WHERE  1 = 1";

                    if (!string.IsNullOrWhiteSpace(search))
                        q += " AND Name LIKE @Search";

                    if (statusFilter == "1") q += " AND IsActive = 1";
                    else if (statusFilter == "0") q += " AND IsActive = 0";

                    q += " ORDER BY IsActive DESC, Name ASC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        if (!string.IsNullOrWhiteSpace(search))
                            cmd.Parameters.AddWithValue("@Search", "%" + search.Trim() + "%");

                        DataTable dt = new DataTable();
                        new SqlDataAdapter(cmd).Fill(dt);

                        gvServices.DataSource = dt;
                        gvServices.DataBind();
                        litResultCount.Text = dt.Rows.Count.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری سرویس‌ها.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadServices] " + ex.Message);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            CurrentSearch = txtSearch.Text.Trim();
            CurrentStatusFilter = ddlFilterStatus.SelectedValue;
            LoadStats();
            LoadServices(CurrentSearch, CurrentStatusFilter);
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterStatus.SelectedValue = "";
            CurrentSearch = "";
            CurrentStatusFilter = "";
            LoadStats();
            LoadServices("", "");
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            hfEditServiceId.Value = "0";
            lblModalTitle.Text = "افزودن سرویس جدید";
            txtName.Text = "";
            txtDuration.Text = "30";
            txtPrice.Text = "";
            chkIsActive.Checked = true;

            KeepModalOpen = false;
            LoadStats();
            LoadServices(CurrentSearch, CurrentStatusFilter);
            RegisterModalScript(show: true);
        }

        protected void gvServices_RowCommand(object source, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument?.ToString(), out int serviceId))
                return;

            switch (e.CommandName)
            {
                case "EditService":
                    LoadForEdit(serviceId);
                    LoadServices(CurrentSearch, CurrentStatusFilter);
                    break;

                case "ToggleActive":
                    ToggleActive(serviceId);
                    break;
                case "DeleteService":
                    DeleteService(serviceId);
                    LoadServices(CurrentSearch, CurrentStatusFilter);
                    break;
            }
        }

        private void LoadForEdit(int serviceId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q =
                        "SELECT Name, DurationMinutes, Price, IsActive FROM Services WHERE ServiceID = @ID";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", serviceId);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (!dr.Read())
                            {
                                ShowMessage("سرویس مورد نظر یافت نشد.", "danger");
                                return;
                            }

                            hfEditServiceId.Value = serviceId.ToString();
                            lblModalTitle.Text = "ویرایش سرویس";
                            txtName.Text = dr["Name"].ToString();
                            txtDuration.Text = dr["DurationMinutes"].ToString();
                            txtPrice.Text = ((decimal)dr["Price"]).ToString("0");
                            chkIsActive.Checked = (bool)dr["IsActive"];
                        }
                    }
                }

                KeepModalOpen = false;
                RegisterModalScript(show: true);
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری اطلاعات سرویس.", "danger");
                KeepModalOpen = true;
                System.Diagnostics.Debug.WriteLine("[LoadForEdit] " + ex.Message);

            }
        }

        private void ToggleActive(int serviceId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    bool currentActive;
                    using (SqlCommand sel = new SqlCommand(
                        "SELECT IsActive FROM Services WHERE ServiceID = @ID", conn))
                    {
                        sel.Parameters.AddWithValue("@ID", serviceId);
                        object r = sel.ExecuteScalar();
                        if (r == null) { ShowMessage("سرویس یافت نشد.", "danger"); return; }
                        currentActive = Convert.ToBoolean(r);
                    }

                    bool newActive = !currentActive;
                    using (SqlCommand upd = new SqlCommand(
                        "UPDATE Services SET IsActive = @A WHERE ServiceID = @ID", conn))
                    {
                        upd.Parameters.AddWithValue("@A", newActive);
                        upd.Parameters.AddWithValue("@ID", serviceId);
                        upd.ExecuteNonQuery();
                    }

                    ShowMessage(
                        newActive ? "سرویس با موفقیت فعال شد." : "سرویس با موفقیت غیرفعال شد.",
                        newActive ? "success" : "warning");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در تغییر وضعیت سرویس.", "danger");
                System.Diagnostics.Debug.WriteLine("[ToggleActive] " + ex.Message);
            }

            LoadStats();
            LoadServices(CurrentSearch, CurrentStatusFilter);
        }

        private void DeleteService(int serviceId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q =
                        "DELETE FROM Services WHERE ServiceID = @ID";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", serviceId);
                        int count = cmd.ExecuteNonQuery();
                        if (count > 0)
                        {
                            ShowMessage("سرویس مورد نظر حذف شد.", "success");
                            return;
                        }
                        else
                        {
                            ShowMessage("مشکلی هنگام حذف پیش آمد دوباره تلاش کنید.", "warnning");
                            return;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری اطلاعات سرویس.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadForEdit] " + ex.Message);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                KeepModalOpen = true;
                RegisterModalScript(show: true);
                LoadStats();
                LoadServices(CurrentSearch, CurrentStatusFilter);
                return;
            }

            string name = SecureData.CheckSecurity(txtName.Text);

            if (string.IsNullOrWhiteSpace(name))
            {
                ShowMessage("نام سرویس معتبر نیست.", "danger");
                KeepModalOpen = true; RegisterModalScript(true);
                LoadServices(CurrentSearch, CurrentStatusFilter);
                return;
            }

            if (!int.TryParse(txtDuration.Text, out int duration)
                || duration < 5 || duration > 480)
            {
                ShowMessage("مدت زمان باید بین 5 تا 480 دقیقه باشد.", "danger");
                KeepModalOpen = true; RegisterModalScript(true);
                LoadServices(CurrentSearch, CurrentStatusFilter);
                return;
            }

            if (!decimal.TryParse(txtPrice.Text, out decimal price) || price < 1000)
            {
                ShowMessage("قیمت وارد شده باید بیشتر از 1,000 تومان باشد.", "danger");
                KeepModalOpen = true; RegisterModalScript(true);
                LoadServices(CurrentSearch, CurrentStatusFilter);
                return;
            }

            bool isActive = chkIsActive.Checked;
            int serviceId = Convert.ToInt32(hfEditServiceId.Value);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    if (serviceId == 0)
                    {
                        const string ins = @"
                            INSERT INTO Services (Name, DurationMinutes, Price, IsActive)
                            VALUES (@N, @D, @P, @A)";

                        using (SqlCommand cmd = new SqlCommand(ins, conn))
                        {
                            cmd.Parameters.AddWithValue("@N", name);
                            cmd.Parameters.AddWithValue("@D", duration);
                            cmd.Parameters.AddWithValue("@P", Math.Floor(price));
                            cmd.Parameters.AddWithValue("@A", isActive);
                            cmd.ExecuteNonQuery();
                        }
                        ShowMessage("سرویس جدید با موفقیت افزوده شد.", "success");
                    }
                    else
                    {
                        const string upd = @"
                            UPDATE Services
                            SET    Name = @N, DurationMinutes = @D, Price = @P, IsActive = @A
                            WHERE  ServiceID = @ID";

                        using (SqlCommand cmd = new SqlCommand(upd, conn))
                        {
                            cmd.Parameters.AddWithValue("@N", name);
                            cmd.Parameters.AddWithValue("@D", duration);
                            cmd.Parameters.AddWithValue("@P", Math.Floor(price));
                            cmd.Parameters.AddWithValue("@A", isActive);
                            cmd.Parameters.AddWithValue("@ID", serviceId);
                            cmd.ExecuteNonQuery();
                        }
                        ShowMessage("سرویس با موفقیت بروزرسانی شد.", "success");
                    }
                }
                
                hfEditServiceId.Value = "0";
                KeepModalOpen = false;
                RegisterModalScript(show: false);
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[btnSave_Click] " + ex.Message);
                KeepModalOpen = true;
                RegisterModalScript(show: true);
            }

            LoadStats();
            LoadServices(CurrentSearch, CurrentStatusFilter);
        }

        
        protected string GetStatusBadge(bool isActive)
        {
            return isActive
                ? "<span class=\"badge rounded-pill bg-success bg-opacity-10 " +
                  "text-success border border-success border-opacity-25 badge-sm\">" +
                  "<i class=\"bi bi-check-circle me-1\"></i>فعال</span>"
                : "<span class=\"badge rounded-pill bg-secondary bg-opacity-10 " +
                  "text-secondary border border-secondary border-opacity-25 badge-sm\">" +
                  "<i class=\"bi bi-x-circle me-1\"></i>غیرفعال</span>";
        }

        
        private void ShowMessage(string message, string type = "danger")
        {
            string icon = type == "success" ? "bi-check-circle-fill"
                        : type == "warning" ? "bi-exclamation-triangle-fill"
                        : "bi-x-circle-fill";

            lblMessage.Text = string.Format(
                "<i class=\"bi {0} me-2\"></i>{1}", icon,
                Server.HtmlEncode(message));
            lblMessage.CssClass = string.Format(
                "alert alert-{0} d-block rounded-3 mb-3 d-flex align-items-center gap-2", type);
            lblMessage.Visible = true;
        }

        
        private void RegisterModalScript(bool show)
        {
            string js = show
                ? "var __e=document.getElementById('serviceModal');" +
                  "if(__e){bootstrap.Modal.getOrCreateInstance(__e).show();}"
                : "var __e=document.getElementById('serviceModal');" +
                  "if(__e){var __m=bootstrap.Modal.getInstance(__e);if(__m)__m.hide();}";

            ScriptManager.RegisterStartupScript(
                this, GetType(), "modal_" + show.ToString().ToLower(), js, true);
        }

        private static void ExecScalar(SqlConnection conn, string sql, Action<string> setter)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn))
                setter(cmd.ExecuteScalar()?.ToString() ?? "0");
        }
        private string CurrentSearch
        {
            get { return ViewState["_srch"] as string ?? ""; }
            set { ViewState["_srch"] = value; }
        }

        private string CurrentStatusFilter
        {
            get { return ViewState["_sf"] as string ?? ""; }
            set { ViewState["_sf"] = value; }
        }

        private bool KeepModalOpen
        {
            get { return (bool)(ViewState["_modal"] ?? false); }
            set { ViewState["_modal"] = value; }
        }

    }
}