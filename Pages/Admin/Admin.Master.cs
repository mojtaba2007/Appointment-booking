using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Appointment_booking.Pages.Admin
{

    public partial class Site1 : System.Web.UI.MasterPage
    {
        public string PageTitle
        {
            get { return litPageTitle.Text; }
            set { litPageTitle.Text = Server.HtmlEncode(value); }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/User/Login.aspx?msg=needlogin");
            }
            if (Session["FullName"] != null)
            {
                litAdminName.Text = Server.HtmlEncode(Session["FullName"].ToString());
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/User/Login.aspx?msg=logout");
        }
    }
}
