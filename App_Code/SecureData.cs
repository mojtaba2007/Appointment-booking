using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace Appointment_booking
{
    public class SecureData
    {
         public static string CheckSecurity(string inputstr)
        {
            string mode = "H";
            string functionReturnValue = null;
            if (inputstr == null || string.IsNullOrEmpty(inputstr))
            {
                return inputstr;
            }
            inputstr = inputstr.ToLower(); 
             //For all string 
            inputstr = inputstr.Trim();
            inputstr = inputstr.Replace("ی", "ي");
            inputstr = inputstr.Replace("ی", "ي");
            inputstr = inputstr.Replace("ک", "ك");
            inputstr = inputstr.Replace("ڪ", "ك");
            inputstr = inputstr.Replace("۱", "1");
            inputstr = inputstr.Replace("۲", "2");
            inputstr = inputstr.Replace("۳", "3");
            inputstr = inputstr.Replace("۴", "4");
            inputstr = inputstr.Replace("۵", "5");
            inputstr = inputstr.Replace("۶", "6");
            inputstr = inputstr.Replace("۷", "7");
            inputstr = inputstr.Replace("۸", "8");
            inputstr = inputstr.Replace("۹", "9");
            inputstr = inputstr.Replace("۰", "0");

            switch (mode)
            {
                //H mode =default mode 
                case "H":
                    inputstr = inputstr.Replace("'", "''");
                    inputstr = inputstr.Replace(">", "_>");
                    inputstr = inputstr.Replace("<", "<_");
                    //a = Replace(a, "--", "__") 
                    inputstr = inputstr.Replace("/*", " ");
                    inputstr = inputstr.Replace("*/", " ");
                    inputstr = inputstr.ToLower().Replace("script", "BLOCKED");
                    inputstr = inputstr.ToLower().Replace("xp_", " ");
                    inputstr = inputstr.ToLower().Replace("union", "_union");
                    inputstr = inputstr.ToLower().Replace("having", "_having");
                    inputstr = inputstr.ToLower().Replace("insert", "_insert");
                    inputstr = inputstr.ToLower().Replace("select", "_select");
                    inputstr = inputstr.ToLower().Replace("delete", "_delete");
                    inputstr = inputstr.ToLower().Replace("update", "_update");
                    inputstr = inputstr.ToLower().Replace("drop", "_drop");
                    inputstr = inputstr.ToLower().Replace("exec", "_exec");
                    inputstr = inputstr.ToLower().Replace("sp_", "_sp_");
                    inputstr = inputstr.ToLower().Replace("shutdown", "_shutdown");
                    inputstr = inputstr.ToLower().Replace("javascript\\:", "BLOCKED ");
                    inputstr = inputstr.ToLower().Replace("vbscript\\:", "BLOCKED ");

                    break;
                case "M":
                    inputstr = inputstr.Replace("'", "''");
                    inputstr = inputstr.ToLower().Replace("script", "BLOCKED");
                    inputstr = inputstr.ToLower().Replace("javascript\\:", "BLOCKED ");
                    inputstr = inputstr.ToLower().Replace("vbscript\\:", "BLOCKED ");

                    break;
                case "L":
                    inputstr = inputstr.Replace("'", "''");
                    break;
            }
            functionReturnValue = inputstr;
            return functionReturnValue;
        }
    }
    


}
