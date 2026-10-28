using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace Appointment_booking
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                liLogin.Visible = false;
                liRegister.Visible = false;
                liLogout.Visible = true;
                liUser.Visible = true;

                liLoginMobile.Visible = false;
                liRegisterMobile.Visible = false;
                liLogoutMobile.Visible = true;
                liUserMobile.Visible = true;

                if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
                {
                    liAdminPanel.Visible = true;
                    liAdminPanelMobile.Visible = true;
                }
                else
                {
                    liAdminPanel.Visible = false;
                    liAdminPanelMobile.Visible = false;
                }
            }
            else
            {
                liLogin.Visible = true;
                liRegister.Visible = true;
                liLogout.Visible = false;
                liUser.Visible = false;
                liAdminPanel.Visible = false;

                liLoginMobile.Visible = true;
                liRegisterMobile.Visible = true;
                liLogoutMobile.Visible = false;
                liUserMobile.Visible = false;
                liAdminPanelMobile.Visible = false;
            }
            ReadName();
        }
        private void ReadName()
        {
            if (Session["UserId"] != null)
            {
                string userId = Session["UserId"].ToString();
                string username = Session["FullName"].ToString();
                Usertxt.InnerText = username;
                UsertxtMobile.InnerText = username;
            }
        }
    }
}