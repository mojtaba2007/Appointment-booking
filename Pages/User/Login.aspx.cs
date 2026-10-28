using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Appointment_booking;
using System.Configuration;
using Microsoft.AspNet.FriendlyUrls;

namespace Appointment_booking.Pages.User
{
    public partial class Login : System.Web.UI.Page
    {
        string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)

        {
            if (Session["UserId"] != null)
            {
                string role = Session["Role"]?.ToString();
                RedirectByRole(role);
            }
            else
            {
                HttpCookie cookie = Request.Cookies["RememberMe"];
                if (cookie != null)
                {
                    Session["UserId"] = cookie["UserId"];
                    Session["FullName"] = cookie["FullName"];
                    Session["Role"] = cookie["role"];
                    RedirectByRole(cookie["Role"]);
                }
            }

            if (!IsPostBack && Request.QueryString["msg"] == "registered")
            {
                ShowMessage("ثبت نام با موفقیت انجام شد. اکنون وارد شوید", "success");
            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) { return; }

            string loginInput = SecureData.CheckSecurity(txtLogin.Text);
            string password = SecureData.CheckSecurity(txtPassword.Text);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string query = @"
                        SELECT UserID, FullName, Role, Salt, PasswordHash, IsActive
                        FROM   Users WHERE  Email = @Login OR  Phone = @Login";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Login", loginInput);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                ShowMessage("ایمیل/شماره در سایت ثبت نشده است.", "danger");
                                return;
                            }

                            bool isActive = reader.GetBoolean(reader.GetOrdinal("IsActive"));
                            if (!isActive)
                            {
                                ShowMessage("حساب کاربری شما غیرفعال شده است. با پشتیبانی تماس بگیرید.", "warning");
                                return;
                            }
                            string salt = reader["Salt"].ToString();
                            string storedHash = reader["PasswordHash"].ToString();
                            string inputHash = HashPassword(password, salt);

                            if (storedHash != inputHash)
                            {
                                ShowMessage("رمز عبور اشتباه است. درصورت فراموشی. با پشتیبانی تماس بگیرید.", "danger");
                                return;
                            }

                            string userId = reader["UserID"].ToString();
                            string fullName = reader["FullName"].ToString();
                            string role = reader["Role"].ToString();

                            Session["UserId"] = userId;
                            Session["FullName"] = fullName;
                            Session["Role"] = role;

                            if (chkRemember.Checked)
                            {
                                HttpCookie userCookie = new HttpCookie("RememberMe");
                                userCookie["UserId"] = userId;
                                userCookie["FullName"] = fullName;
                                userCookie["Role"] = role;
                                userCookie.Expires = DateTime.Now.AddDays(30);
                                userCookie.HttpOnly = true;
                                Response.Cookies.Add(userCookie);
                            }
                            RedirectByRole(role);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "danger");
                System.Diagnostics.Debug.WriteLine("[Login Error] " + ex.Message);
            }
        }

        private string HashPassword(string password, string salt)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                string salted = salt + password;
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(salted));

                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("X2"));

                return sb.ToString();
            }
        }

        private void RedirectByRole(string role)
        {
            if (role == "Admin")
            {
                Response.Redirect("~/Pages/Admin/Dashboard.aspx", false);
            }
            else
            {
                Response.Redirect("~/Pages/User/Default.aspx", false);
            }
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowMessage(string message, string type = "danger")
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = $"alert alert-{type} d-block mt-2";
            lblMessage.Visible = true;
        }
    }
}