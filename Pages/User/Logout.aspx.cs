using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.User
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // پاک کردن تمام متغیرهای Session
            Session.Clear();

            // تخریب کامل Session حذف از سرور
            Session.Abandon();

            // پاک کردن کوکی Session از مرورگر
            DeleteCookie("ASP.NET_SessionId");
            DeleteCookie("RememberMe");

            // هدایت به صفحه ورود
            Response.Redirect("~/Pages/User/Login.aspx?msg=loggedout");
            
        }

        //حذف کوکی ها
        private void DeleteCookie(string cookiename)
        {
            if (Request.Cookies[$"{cookiename}"] != null)
            {
                HttpCookie cookie = new HttpCookie($"{cookiename}")
                {
                    Expires = DateTime.Now.AddYears(-1),
                    HttpOnly = true
                };
                Response.Cookies.Add(cookie);
            }
        }
    }
}