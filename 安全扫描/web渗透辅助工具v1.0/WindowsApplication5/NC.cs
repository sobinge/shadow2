using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using System.Net;
using System.Windows.Forms.PropertyGridInternal;

namespace WindowsApplication3
{
    public partial class NC : Form
    {
        public NC()
        {
            InitializeComponent();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            
            try
            {
                
                richTextBox1.Text="";
                WebClient wc = new WebClient();
                wc.Credentials = CredentialCache.DefaultCredentials;
                Encoding enc = Encoding.Default;
                if (radioButton1.Checked == true)
                {
                    string password=textBox1.Text;
                    Byte[] pageData = wc.DownloadData("http://www.zjjv.com/wp-content/create/create.php?type=asp&name=PenTest&pass="+password);
                    string sss = enc.GetString(pageData);
                    
                    richTextBox1.Text = sss;
                }
                else if (radioButton2.Checked == true)
                {
                    string password=textBox1.Text;
                    Byte[] pageData = wc.DownloadData("http://www.zjjv.com/wp-content/create/create.php?type=php&name=PenTest&pass="+password);
                    string sss = enc.GetString(pageData);
                    richTextBox1.Text = sss;
                                 
             
                }
                    


            }
            catch { }
        }
       
   
      
 
    }  
    
}