using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net.NetworkInformation;
using System.Runtime.Remoting.Metadata.W3cXsd2001;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.User
{
    public partial class MyAppointments : System.Web.UI.Page
    {
        string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;

        private const double MinHoursBeforeChange = 24;

        private int CurrentUserId
        {
            get { return Convert.ToInt32(Session["UserId"]); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/User/Login.aspx?msg=needlogin");
                return;
            }

            if (!IsPostBack)
                LoadAppointments();
        }

        private void LoadAppointments()
        {
            var upcoming = new List<AppointmentRow>();
            var past = new List<AppointmentRow>();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = @"
                        SELECT a.AppointmentID, a.ServiceID, s.Name AS ServiceName,
                               s.DurationMinutes, s.Price, a.AppointmentDate, a.StartTime,
                               a.Status, a.CreatedAt
                        FROM Appointments a
                        JOIN Services s ON s.ServiceID = a.ServiceID
                        WHERE a.UserID = @UserID
                        ORDER BY a.AppointmentDate DESC, a.StartTime DESC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                var row = MapRow(dr);
                                if (row.AppointmentDateTime >= DateTime.Now && row.Status != "Cancelled")
                                    upcoming.Add(row);
                                else
                                    past.Add(row);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطا در بارگذاری نوبت‌ها.", "danger");
                System.Diagnostics.Debug.WriteLine("[LoadAppointments] " + ex.Message);
                return;
            }

            upcoming = upcoming.OrderBy(x => x.AppointmentDateTime).ToList();

            rptUpcoming.DataSource = upcoming;
            rptUpcoming.DataBind();
            pnlNoUpcoming.Visible = upcoming.Count == 0;
            litUpcomingCount.Text = upcoming.Count.ToString();

            rptPast.DataSource = past;
            rptPast.DataBind();
            pnlNoPast.Visible = past.Count == 0;
            litPastCount.Text = past.Count.ToString();
        }

        private AppointmentRow MapRow(SqlDataReader dr)
        {
            DateTime date = (DateTime)dr["AppointmentDate"];
            TimeSpan time = (TimeSpan)dr["StartTime"];
            int duration = Convert.ToInt32(dr["DurationMinutes"]);

            return new AppointmentRow
            {
                AppointmentID = Convert.ToInt32(dr["AppointmentID"]),
                ServiceID = Convert.ToInt32(dr["ServiceID"]),
                ServiceName = dr["ServiceName"].ToString(),
                DurationMinutes = duration,
                Price = Convert.ToDecimal(dr["Price"]),
                AppointmentDate = date,
                StartTime = time,
                EndTime = time.Add(TimeSpan.FromMinutes(duration)),
                Status = dr["Status"].ToString(),
                CreatedAt = Convert.ToDateTime(dr["CreatedAt"])
            };
        }

        protected void rptUpcoming_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int appointmentId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Cancel")
            {
                CancelAppointment(appointmentId);
                LoadAppointments();
            }
            else if (e.CommandName == "Edit")
            {
                CheckEeditAppointment(appointmentId);
            }
        }

        private void StatusAppointment(int appointmentId, out int serviceId, out string status, out DateTime apDate, out TimeSpan apTime)
        {
            int ownerId;
            serviceId = 0;
            status = "";
            apDate = default;
            apTime = default;
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string selQ = @"
                        SELECT UserID, ServiceID, Status, AppointmentDate, StartTime
                        FROM Appointments WHERE AppointmentID = @ID";

                    using (SqlCommand cmd = new SqlCommand(selQ, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", appointmentId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (!dr.Read())
                            {
                                ShowMessage("نوبت یافت نشد.", "danger");
                                return;
                            }
                            ownerId = Convert.ToInt32(dr["UserID"]);
                            serviceId = Convert.ToInt32(dr["ServiceID"]);
                            status = dr["Status"].ToString();
                            apDate = (DateTime)dr["AppointmentDate"];
                            apTime = (TimeSpan)dr["StartTime"];
                        }
                    }

                    if (ownerId != CurrentUserId)
                    {
                        ShowMessage("شما اجازه دسترسی به این نوبت را ندارید.", "danger");
                        status = "";
                        return;
                    }

                    if (status == "Cancelled" || status == "Completed")
                    {
                        ShowMessage("این نوبت قابل حذف/ویرایش نیست.", "warning");
                        status = "";
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی هنگام لغو نوبت.", "danger");
                System.Diagnostics.Debug.WriteLine("[CancelAppointment] " + ex.Message);
            }

        }
        private void CancelAppointment(int appointmentId)
        {
            StatusAppointment(appointmentId, out int serviceId, out string status, out DateTime apDate, out TimeSpan apTime);
            if (string.IsNullOrEmpty(status)) return;
            DateTime apDateTime = apDate.Date + apTime;
            if ((apDateTime - DateTime.Now).TotalHours < MinHoursBeforeChange)
            {
                ShowMessage("لغو نوبت باید حداقل ۲۴ ساعت قبل از زمان نوبت انجام شود.", "warning");
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string updQ = "UPDATE Appointments SET Status = 'Cancelled' WHERE AppointmentID = @ID AND UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(updQ, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", appointmentId);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserId);
                        int affected = cmd.ExecuteNonQuery();

                        ShowMessage(affected > 0
                            ? "نوبت با موفقیت لغو شد."
                            : "خطا در لغو نوبت.", affected > 0 ? "success" : "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی هنگام لغو نوبت.", "danger");
                System.Diagnostics.Debug.WriteLine("[CancelAppointment] " + ex.Message);
            }
        }

        private void CheckEeditAppointment(int appointmentId)
        {
            StatusAppointment(appointmentId, out int serviceId, out string status, out DateTime apDate, out TimeSpan apTime);
            if (string.IsNullOrEmpty(status)) return;
            DateTime apDateTime = apDate.Date + apTime;
            if ((apDateTime - DateTime.Now).TotalHours < MinHoursBeforeChange)
            {
                ShowMessage("ویرایش نوبت باید حداقل ۲۴ ساعت قبل از زمان نوبت انجام شود.", "warning");
                return;
            }
            string dateStr = apDate.ToString("yyyy-MM-dd");
            string timeStr = apTime.ToString(@"hh\:mm");
            Response.Redirect($"BookAppointment.aspx?edit=1&id={appointmentId}&service={serviceId}&date={dateStr}&time={timeStr}");
        }
        public string ToShamsi(DateTime date)
        {
            PersianCalendar pc = new PersianCalendar();

            return $"{pc.GetYear(date)}/{pc.GetMonth(date):00}/{pc.GetDayOfMonth(date):00}";
        }

        private void ShowMessage(string message, string type = "danger")
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = string.Format("alert alert-{0} d-block", type);
            lblMessage.Visible = true;
        }
    }

    public class AppointmentRow
    {
        public int AppointmentID { get; set; }
        public int ServiceID { get; set; }
        public string ServiceName { get; set; }
        public int DurationMinutes { get; set; }
        public decimal Price { get; set; }
        public DateTime AppointmentDate { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }

        public DateTime AppointmentDateTime
        {
            get { return AppointmentDate.Date + StartTime; }
        }

        public string FormattedDate
        {
            get
            {
                PersianCalendar pc = new PersianCalendar();

                string shamsiDate =
                    $"{pc.GetYear(AppointmentDate)}/" +
                    $"{pc.GetMonth(AppointmentDate):00}/" +
                    $"{pc.GetDayOfMonth(AppointmentDate):00}";

                return shamsiDate + " - " + GetPersianDayName(AppointmentDate.DayOfWeek);
            }
        }

        public string FormattedTimeRange
        {
            get { return StartTime.ToString(@"hh\:mm") + " تا " + EndTime.ToString(@"hh\:mm"); }
        }

        public string FormattedPrice
        {
            get { return Price.ToString("N0") + " تومان"; }
        }

        public string StatusText
        {
            get
            {
                switch (Status)
                {
                    case "Confirmed": return "تأیید شد";
                    case "Completed": return "انجام شده";
                    case "Cancelled": return "لغو شده";
                    default: return Status;
                }
            }
        }

        public string StatusBadgeClass
        {
            get
            {
                switch (Status)
                {
                    case "Confirmed": return "bg-success";
                    case "Completed": return "bg-secondary";
                    case "Cancelled": return "bg-danger";
                    default: return "bg-light text-dark";
                }
            }
        }

        public double HoursRemaining
        {
            get { return (AppointmentDateTime - DateTime.Now).TotalHours; }
        }

        public bool CanModify
        {
            get { return (Status == "Confirmed") && HoursRemaining >= 24; }
        }

        public string ModifyHintText
        {
            get
            {
                if (Status == "Cancelled") return "این نوبت لغو شده است.";
                if (Status == "Completed") return "این نوبت انجام شده است.";
                if (HoursRemaining < 24) return "کمتر از ۲۴ ساعت به نوبت مانده است.";
                return "";
            }
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
    }
}
