using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Appointment_booking.Pages.Admin
{
    public partial class Profile : System.Web.UI.Page
    {
        string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                string fullname = "";
                string phone = "";
                string email = "";
                GetDatas(userId, out fullname, out phone, out email);
                txtFullName.Text = fullname;
                txtPhone.Text = phone;
                txtEmail.Text = email;
                litFullName.Text = fullname;
            }
        }
        private void GetDatas(int userId, out string fullname, out string phone, out string email)
        {
            string passwordHash;
            string salt;

            GetDatas(userId, out fullname, out phone, out email, out passwordHash, out salt);
        }
        private void GetDatas(int userid, out string fullname, out string phone, out string email, out string passwordHash, out string salt)
        {
            fullname = "";
            phone = "";
            email = "";
            passwordHash = "";
            salt = "";
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string q =
                        "SELECT FullName,Phone ,Email ,PasswordHash ,Salt FROM Users WHERE UserId=@ID AND IsActive=1";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", userid);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                fullname = dr["FullName"].ToString();
                                phone = dr["Phone"].ToString();
                                email = dr["Email"].ToString();
                                passwordHash = dr["PasswordHash"].ToString();
                                salt = dr["Salt"].ToString();
                            }
                            else
                            {
                                ShowMessage("مشکلی پیش آمد لطفا دوباره تلاش شوید.", "warning");
                                return;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("خطای سیستمی. لطفاً دوباره تلاش کنید.", "warning");
                System.Diagnostics.Debug.WriteLine("[ProfileGetData Error] " + ex.Message);
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string beforeFullname = "";
            string fullname = SecureData.CheckSecurity(txtFullName.Text);

            string beforePhone = "";
            string Phone = SecureData.CheckSecurity(txtPhone.Text);

            string beforeEmail = "";
            string Email = SecureData.CheckSecurity(txtEmail.Text);

            string beforePasswordHash = "";
            string currentpassword = SecureData.CheckSecurity(txtCurrentPassword.Text);
            string newPassword = SecureData.CheckSecurity(txtNewPassword.Text);
            string checkPassword = SecureData.CheckSecurity(txtConfirmPassword.Text);


            string beforeSalt = "";
            string newsalt = GenerateSalt();

            GetDatas(userId, out beforeFullname, out beforePhone, out beforeEmail, out beforePasswordHash, out beforeSalt);

            string inputhash = HashPassword(currentpassword, beforeSalt);
            string newinputhash = HashPassword(newPassword, newsalt);
            List<string> changedFields = new List<string>();

            if (beforePasswordHash != inputhash)
            {
                ShowMessage("رمزعبور فعلی صحیح نمی باشد. درصورت فراموشی فعلا کاری نمیتونی بکنی:/", "danger");
                return;
            }

            if (beforeFullname != fullname)
                changedFields.Add("نام کامل");
            if ((beforePasswordHash != newinputhash) && (checkPassword != ""))
                changedFields.Add("رمز");
            if (beforePhone != Phone)
                changedFields.Add("موبایل");
            if (beforeEmail != Email)
                changedFields.Add("ایمیل");

            if (changedFields.Count > 0)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        conn.Open();
                        const string updQ = @"
                        UPDATE Users
                        SET FullName=@FullName,PasswordHash=@Passwdhash ,Salt=@Salt ,Phone=@Phone ,Email=@Email
                        WHERE UserId = @ID AND IsActive=1";
                        using (SqlCommand cmd = new SqlCommand(updQ, conn))
                        {
                            cmd.Parameters.AddWithValue("@FullName", fullname);
                            if (checkPassword == "")
                            {
                                cmd.Parameters.AddWithValue("@Passwdhash", beforePasswordHash);
                                cmd.Parameters.AddWithValue("@Salt", beforeSalt);
                                cmd.Parameters.AddWithValue("@Phone", Phone);
                                cmd.Parameters.AddWithValue("@Email", Email);
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("@Passwdhash", newinputhash);
                                cmd.Parameters.AddWithValue("@Salt", newsalt);
                                cmd.Parameters.AddWithValue("@Phone", Phone);
                                cmd.Parameters.AddWithValue("@Email", Email);
                            }
                            cmd.Parameters.AddWithValue("@ID", userId);
                            int affected = cmd.ExecuteNonQuery();

                            if (affected > 0)
                            {
                                Session["UserName"] = fullname;
                                string changedText = string.Join(" ، ", changedFields);
                                ShowMessage($"اطلاعات با موفقیت ذخیره شد. موارد تغییر یافته: {changedText}", "success");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("اطلاعات تغییر نکرد دوباره تلاش کنید.");
                    System.Diagnostics.Debug.WriteLine("[UpdateProfile Error] " + ex.Message);
                }
            }
        }

        private void ShowMessage(string message, string type = "danger")
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = $"alert alert-{type} d-block mt-2";
            lblMessage.Visible = true;
        }
        private string GenerateSalt()
        {
            byte[] saltBytes = new byte[16];
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
                rng.GetBytes(saltBytes);
            return Convert.ToBase64String(saltBytes);
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
    }
}