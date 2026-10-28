using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private readonly string _connStr =
                    ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Pages/User/Login.aspx", true);
                return;
            }

            Master.PageTitle = "داشبورد";

            if (!IsPostBack)
            {
                litCurrentDate.Text = ToShamsi(DateTime.Now);
                LoadStats();
                LoadRecentAppointments();
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
                        "SELECT COUNT(*) FROM Appointments WHERE AppointmentDate = CAST(GETDATE() AS DATE) AND Status <> 'Cancelled'",
                        v => litTodayCount.Text = v);

                    Executescalar(conn,
                        "SELECT COUNT(*) FROM Appointments WHERE Status <> 'Cancelled'",
                        v => litAllCount.Text = v);

                    Executescalar(conn,
                        "SELECT COUNT(*) FROM Users WHERE Role = 'User' AND IsActive = 1",
                        v => litUserCount.Text = v);

                   
                    Executescalar(conn,
                        "SELECT COUNT(*) FROM Services WHERE IsActive = 1",
                        v => litServiceCount.Text = v);

                    
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT ISNULL(SUM(s.Price), 0)
                        FROM   Appointments a
                        JOIN   Services s ON s.ServiceID = a.ServiceID
                        WHERE  MONTH(a.AppointmentDate) = MONTH(GETDATE())
                          AND  YEAR(a.AppointmentDate)  = YEAR(GETDATE())
                          AND  a.Status = 'Completed'", conn))
                    {
                        decimal revenue = Convert.ToDecimal(cmd.ExecuteScalar());
                        litMonthRevenue.Text = revenue.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[AdminHome.LoadStats] " + ex.Message);
            }
        }

        
        private void LoadRecentAppointments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q = @"
                        SELECT TOP 10
                               u.FullName AS UserName,
                               s.Name AS ServiceName,
                               a.AppointmentDate,
                               a.StartTime,
                               a.Status,
                               s.Price
                        FROM Appointments a
                        JOIN Users u ON u.UserID    = a.UserID
                        JOIN Services s ON s.ServiceID = a.ServiceID
                        ORDER BY a.CreatedAt DESC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        gvRecent.DataSource = dr;
                        gvRecent.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("[AdminHome.LoadRecentAppointments] " + ex.Message);
            }
        }

        protected string GetInitial(object userName)
        {
            string name = userName?.ToString() ?? "";
            return name.Length > 0 ? Server.HtmlEncode(name.Substring(0, 1)) : "؟";
        }

        protected string FormatTime(object time)
        {
            if (time is TimeSpan ts) return ts.ToString(@"hh\:mm");
            return time?.ToString() ?? "";
        }

        protected string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Confirmed": return "badge rounded-pill bg-success";
                case "Completed": return "badge rounded-pill bg-secondary";
                case "Cancelled": return "badge rounded-pill bg-danger";
                default: return "badge rounded-pill bg-light text-dark";
            }
        }

        protected string GetStatusText(string status)
        {
            switch (status)
            {
                case "Confirmed": return "تأیید شد";
                case "Completed": return "انجام شده";
                case "Cancelled": return "لغو شده";
                default: return Server.HtmlEncode(status);
            }
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
    }
}