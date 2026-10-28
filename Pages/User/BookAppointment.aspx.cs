using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;
using System.Globalization;

namespace Appointment_booking.Pages.User
{
    public partial class BookAppointment : System.Web.UI.Page
    {
        string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/User/Login.aspx?msg=needlogin");
                return;
            }

            if (!IsPostBack)
            {
                LoadServices();
            }
            InjectServiceJson();
            if (!IsPostBack && Request.QueryString["edit"] == "1")
            { LoadEditData(); }
        }

        private void LoadServices()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = @"
                        SELECT ServiceID, Name, DurationMinutes, Price
                        FROM   Services
                        WHERE  IsActive = 1
                        ORDER  BY Name";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlService.Items.Clear();
                        ddlService.Items.Add(new ListItem("انتخاب کنید", ""));

                        while (dr.Read())
                        {
                            string display = string.Format(
                                "{0} ({1} دقیقه)",
                                dr["Name"].ToString(),
                                dr["DurationMinutes"].ToString()
                            );
                            var item = new ListItem(display, dr["ServiceID"].ToString());
                            item.Attributes["data-duration"] = dr["DurationMinutes"].ToString();
                            item.Attributes["data-price"] = dr["Price"].ToString();
                            ddlService.Items.Add(item);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری سرویس‌ها.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadServices] " + ex.Message);
            }
        }

        private void LoadEditData()
        {
            string serviceId = Request.QueryString["service"];
            string date = Request.QueryString["date"];
            string time = Request.QueryString["time"];

            if (ddlService.Items.FindByValue(serviceId) != null)
                ddlService.SelectedValue = serviceId;

            SecureData.CheckSecurity(date);
            hfSelectedDate.Value = date;
            SecureData.CheckSecurity(time);
            hfSelectedTime.Value = time;

            btnLoadSlots_Click(null, null);

            string shamsiDate = ToShamsi(Convert.ToDateTime(date));

            ScriptManager.RegisterStartupScript(this, GetType(), "setEditData", $@"
                    document.getElementById('txtDateDisplay').value = '{shamsiDate}';

                    var svcVal = document.getElementById(ddlServiceId).value;
                    if (svcVal && services[svcVal]) {{
                        document.getElementById('serviceInfo').style.display = 'block';
                        document.getElementById('svcDuration').textContent = services[svcVal].duration;
                        document.getElementById('svcPrice').textContent = Number(services[svcVal].price).toLocaleString('fa');
                    }}

                    var selectedTime = '{time}';
                    document.querySelectorAll('.slot-btn').forEach(function(btn) {{
                        if (btn.getAttribute('data-time') === selectedTime)
                            btn.classList.add('selected');
                    }});
                    updateSummary();
                    updateSteps();
                ", true);
            btnBook.Text = "ذخیره تغییرات";
        }

        private void InjectServiceJson()
        {
            var sb = new StringBuilder("services = {");
            bool first = true;

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = @"
                        SELECT ServiceID, DurationMinutes, Price
                        FROM   Services
                        WHERE  IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            if (!first) sb.Append(",");
                            sb.AppendFormat(
                                "\"{0}\":{{\"duration\":\"{1}\",\"price\":\"{2}\"}}",
                                dr["ServiceID"],
                                dr["DurationMinutes"],
                                dr["Price"]
                            );
                            first = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[InjectServiceJson] " + ex.Message);
            }

            sb.Append("};");

            ScriptManager.RegisterStartupScript(
                this, GetType(), "serviceData", sb.ToString(), true
            );
        }

        protected void btnLoadSlots_Click(object sender, EventArgs e)
        {
            pnlSlotHint.Visible = false;
            pnlSlots.Visible = false;
            lblNoSlots.Visible = false;

            string serviceIdStr = ddlService.SelectedValue;
            string dateStr = SecureData.CheckSecurity(hfSelectedDate.Value);



            if (string.IsNullOrEmpty(serviceIdStr) || string.IsNullOrEmpty(dateStr))
            {
                pnlSlotHint.Visible = true;
                return;
            }

            if (!int.TryParse(serviceIdStr, out int serviceId) ||
                !DateTime.TryParse(dateStr, out DateTime selectedDate))
            {
                pnlSlotHint.Visible = true;
                return;
            }

            if (selectedDate.Date <= DateTime.Today)
            {
                ShowMessage("لطفا تاریخ فردا یا بعد از آن را انتخاب کنید.", "warning");
                pnlSlotHint.Visible = true;
                return;
            }

            int excludeId = (Request.QueryString["edit"] == "1" && int.TryParse(Request.QueryString["id"], out int eid)) ? eid : 0;
            var slots = GenerateSlots(serviceId, selectedDate.Date, excludeId);

            pnlSlots.Visible = true;

            if (slots.Count == 0)
            {
                lblNoSlots.Visible = true;
                return;
            }

            rptSlots.DataSource = slots;
            rptSlots.DataBind();
        }

        private int GetServiceDuration(int serviceId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q =
                        "SELECT DurationMinutes FROM Services WHERE ServiceID=@ID AND IsActive=1";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", serviceId);
                        object r = cmd.ExecuteScalar();
                        if (r != null)
                        { return Convert.ToInt32(r); }
                        else
                        { return 0; }
                    }
                }
            }
            catch { return 0; }
        }

        private static readonly TimeSpan WorkStart = new TimeSpan(9, 0, 0);
        private static readonly TimeSpan WorkEnd = new TimeSpan(17, 0, 0);
        private List<TimeSlot> GenerateSlots(int serviceId, DateTime date, int excludeId = 0)
        {
            int duration = GetServiceDuration(serviceId);
            if (duration <= 0) return new List<TimeSlot>();

            var taken = GetTakenSlots(serviceId, date);
            var slots = new List<TimeSlot>();

            TimeSpan current = WorkStart;
            while (current + TimeSpan.FromMinutes(duration) <= WorkEnd)
            {
                TimeSpan slotEnd = current + TimeSpan.FromMinutes(duration);
                bool isTaken = HasOverlap(current, slotEnd, taken);

                slots.Add(new TimeSlot
                {
                    TimeValue = current.ToString(@"hh\:mm"),
                    DisplayTime = current.ToString(@"hh\:mm"),
                    IsTaken = isTaken
                });

                current = current.Add(TimeSpan.FromMinutes(duration));
            }

            return slots;
        }

        private List<(TimeSpan Start, TimeSpan End)> GetTakenSlots(int serviceId, DateTime date, int excludeId = 0)
        {
            var taken = new List<(TimeSpan, TimeSpan)>();
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT a.StartTime,
                               DATEADD(MINUTE, s.DurationMinutes,
                                   CAST(a.StartTime AS DATETIME)) AS EndTime
                        FROM Appointments a
                        JOIN Services s ON s.ServiceID = a.ServiceID
                        WHERE a.AppointmentDate = @Date
                          AND a.Status <> 'Cancelled'";
                    if (excludeId > 0)
                        q += " AND a.AppointmentID <> @ExcludeID";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ServiceID", serviceId);
                        cmd.Parameters.AddWithValue("@Date", date);
                        if (excludeId > 0)
                            cmd.Parameters.AddWithValue("@ExcludeID", excludeId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                var start = (TimeSpan)dr["StartTime"];
                                var end = ((DateTime)dr["EndTime"]).TimeOfDay;
                                taken.Add((start, end));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[GetTakenSlots] " + ex.Message);
            }
            return taken;
        }

        private bool HasOverlap(TimeSpan newStart, TimeSpan newEnd,
            List<(TimeSpan Start, TimeSpan End)> taken)
        {
            foreach (var s in taken)
                if (newStart < s.End && newEnd > s.Start) return true;
            return false;
        }

        protected void rptSlots_ItemDataBound(object sender, RepeaterItemEventArgs e) { }

        private bool IsEditMode
        {
            get
            {
                return Request.QueryString["edit"] == "1"
                    && int.TryParse(Request.QueryString["id"], out _);
            }
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string serviceIdStr = ddlService.SelectedValue;
            string dateStr = hfSelectedDate.Value;
            string timeStr = hfSelectedTime.Value;

            if (string.IsNullOrEmpty(serviceIdStr) ||
                string.IsNullOrEmpty(dateStr) ||
                string.IsNullOrEmpty(timeStr))
            {
                ShowMessage("لطفا تمام فیلدها را تکمیل کنید.", "warning");
                return;
            }

            if (!int.TryParse(serviceIdStr, out int serviceId) ||
                !DateTime.TryParse(dateStr, out DateTime appointDate) ||
                !TimeSpan.TryParse(timeStr, out TimeSpan startTime))
            {
                ShowMessage("مقادیر وارد شده نامعتبر است.", "danger");
                return;
            }

            if (appointDate.Date <= DateTime.Today)
            {
                ShowMessage("لطفا تاریخ آینده انتخاب کنید.", "warning");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    int duration = GetDuration(conn, serviceId);
                    if (duration <= 0)
                    {
                        ShowMessage("سرویس انتخابی معتبر نیست.", "danger");
                        return;
                    }

                    TimeSpan endTime = startTime + TimeSpan.FromMinutes(duration);
                    int excludeId = IsEditMode ? EditAppointmentId : 0;
                    if (HasConflict(conn, serviceId, appointDate.Date, startTime, endTime, excludeId))
                    {
                        ShowMessage("این ساعت همزمان رزرو شد. لطفا ساعت دیگری انتخاب کنید.", "warning");
                        btnLoadSlots_Click(null, null);
                        return;
                    }



                    if (IsEditMode)
                    {
                        if (!VerifyOwner(conn, EditAppointmentId, userId))
                        {
                            ShowMessage("شما اجازه ویرایش این نوبت را ندارید.", "danger");
                            return;
                        }

                        const string updateQ = @"
                            UPDATE Appointments
                            SET    ServiceID       = @ServiceID,
                                   AppointmentDate = @Date,
                                   StartTime       = @StartTime
                            WHERE  AppointmentID   = @ID
                              AND  UserID          = @UserID";

                        using (SqlCommand cmd = new SqlCommand(updateQ, conn))
                        {
                            cmd.Parameters.AddWithValue("@ServiceID", serviceId);
                            cmd.Parameters.AddWithValue("@Date", appointDate.Date);
                            cmd.Parameters.AddWithValue("@StartTime", startTime);
                            cmd.Parameters.AddWithValue("@ID", EditAppointmentId);
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        const string insertQ = @"
                            INSERT INTO Appointments
                                   (UserID, ServiceID, AppointmentDate, StartTime, Status)
                            VALUES (@UserID, @ServiceID, @Date, @StartTime, 'Confirmed')";

                        using (SqlCommand cmd = new SqlCommand(insertQ, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.Parameters.AddWithValue("@ServiceID", serviceId);
                            cmd.Parameters.AddWithValue("@Date", appointDate.Date);
                            cmd.Parameters.AddWithValue("@StartTime", startTime);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                Response.Redirect("~/Pages/User/MyAppointments.aspx?msg=booked");
            }
            catch (SqlException sqlEx) when (sqlEx.Number == 2601 || sqlEx.Number == 2627)
            {
                ShowMessage("این نوبت همزمان توسط کاربر دیگری رزرو شد. ساعت دیگری انتخاب کنید.", "warning");
                btnLoadSlots_Click(null, null);
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفا دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[BookAppointment] " + ex.Message);
            }
        }

        private int GetDuration(SqlConnection conn, int serviceId)
        {
            const string q =
                "SELECT DurationMinutes FROM Services WHERE ServiceID=@ID AND IsActive=1";
            using (SqlCommand cmd = new SqlCommand(q, conn))
            {
                cmd.Parameters.AddWithValue("@ID", serviceId);
                object r = cmd.ExecuteScalar();
                return r != null ? Convert.ToInt32(r) : 0;
            }
        }

        private bool HasConflict(SqlConnection conn, int serviceId, DateTime date,
            TimeSpan newStart, TimeSpan newEnd, int excludeId = 0)
        {
            string q = @"
                SELECT COUNT(*) FROM Appointments a
                JOIN Services s ON s.ServiceID = a.ServiceID
                WHERE a.AppointmentDate = @Date
                  AND a.Status <> 'Cancelled'
                  AND a.StartTime < @NewEnd
                  AND DATEADD(MINUTE, s.DurationMinutes,
                           CAST(a.StartTime AS DATETIME)) > CAST(@NewStart AS DATETIME)";

            if (excludeId > 0) q += " AND a.AppointmentID <> @ExcludeID";

            using (SqlCommand cmd = new SqlCommand(q, conn))
            {
                cmd.Parameters.AddWithValue("@ServiceID", serviceId);
                cmd.Parameters.AddWithValue("@Date", date);
                cmd.Parameters.AddWithValue("@NewStart", newStart);
                cmd.Parameters.AddWithValue("@NewEnd", newEnd);
                if (excludeId > 0)
                {
                    cmd.Parameters.AddWithValue("@ExcludeID", excludeId);
                }
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private void ShowMessage(string message, string type = "danger")
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = string.Format("alert alert-{0} d-block", type);
            lblMessage.Visible = true;
        }
        public string ToShamsi(DateTime date)
        {
            PersianCalendar pc = new PersianCalendar();

            return $"{pc.GetYear(date)}/{pc.GetMonth(date):00}/{pc.GetDayOfMonth(date):00}";
        }
        private bool VerifyOwner(SqlConnection conn, int appointmentId, int userId)
        {
            const string q = "SELECT UserID FROM Appointments WHERE AppointmentID = @ID";
            using (SqlCommand cmd = new SqlCommand(q, conn))
            {
                cmd.Parameters.AddWithValue("@ID", appointmentId);
                object r = cmd.ExecuteScalar();
                return r != null && Convert.ToInt32(r) == userId;
            }
        }

        private int EditAppointmentId
        {
            get
            {
                int.TryParse(Request.QueryString["id"], out int id);
                return id;
            }
        }
        public class TimeSlot
        {
            public string TimeValue { get; set; }
            public string DisplayTime { get; set; }
            public bool IsTaken { get; set; }
        }
    }
}