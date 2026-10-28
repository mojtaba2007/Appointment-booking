using Microsoft.Ajax.Utilities;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Permissions;
using System.Security.Policy;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.User
{
    public partial class Register : System.Web.UI.Page
    {
        string _connStr = ConfigurationManager.ConnectionStrings["Appointment"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("~/Pages/User/Default.aspx");
            }

        }
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string fullName = SecureData.CheckSecurity(txtFullName.Text);
            string email = SecureData.CheckSecurity(txtEmail.Text);
            string phone = SecureData.CheckSecurity(txtPhone.Text);
            string password = SecureData.CheckSecurity(txtPassword.Text);

            string salt = GenerateSalt();
            string passwordHash = HashPassword(password, salt);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    string checkPhoneQuery = "SELECT COUNT(*) FROM Users WHERE Phone = @Phone";
                    SqlCommand checkEmailCmd = new SqlCommand(checkEmailQuery, conn);
                    SqlCommand checkPhoneCmd = new SqlCommand(checkPhoneQuery, conn);
                    using (checkEmailCmd)
                    {
                        checkEmailCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)checkEmailCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            ShowMessage("این ایمیل قبلاً ثبت شده است.", "danger");
                            return;
                        }
                    }
                    using (checkPhoneCmd)
                    {
                        checkPhoneCmd.Parameters.AddWithValue("@phone", phone);
                        int count = (int)checkPhoneCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            ShowMessage("این شماره قبلاً ثبت شده است.", "danger");
                            return;
                        }
                    }

                    string insertQuery = @"
                        INSERT INTO Users (FullName, Email, Phone, PasswordHash, Salt, Role, IsActive)
                        VALUES (@FullName, @Email, @Phone, @PasswordHash, @Salt, 'User', 1)";

                    using(SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@FullName", fullName);
                        insertCmd.Parameters.AddWithValue("@Email", email);
                        insertCmd.Parameters.AddWithValue("@Phone", phone);
                        insertCmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                        insertCmd.Parameters.AddWithValue("@Salt", salt);

                        int rowAffected = insertCmd.ExecuteNonQuery();

                        if (rowAffected > 0)
                        {
                            Response.Redirect("~/Pages/User/Login.aspx?msg=registered");
                        }
                        else
                        {
                            ShowMessage("خطا در ثبت‌نام. لطفاً دوباره تلاش کنید.", "danger");
                        }
                        
                    }
                }
            }
            catch (Exception)
            {

                ShowMessage("خطای سیستمی ", "danger");
            }
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

        private void ShowMessage(string message, string type = "danger")
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = $"alert alert-{type} d-block";
            lblMessage.Visible = true;
        }
    }
}
