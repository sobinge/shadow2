using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Net;

namespace WindowsApplication3
{
    public partial class serverinfo : Form
    {
        public serverinfo()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                this.webBrowser1.Navigate(textBox1.Text);
           
                

            }
               
              

            catch { }

            

            
            }

        private void button2_Click(object sender, EventArgs e)
        {
           
        }

        private void tabControl1_MouseClick(object sender, MouseEventArgs e)
        {
            


        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            
        }

        private void serverinfo_Load(object sender, EventArgs e)
        {

        }

        private void webBrowser1_Navigating(object sender, WebBrowserNavigatingEventArgs e)
        {

        }

        private void button2_Click_2(object sender, EventArgs e)
        {
            webBrowser1.Document.Cookie = "";
            webBrowser1.Document.Cookie = richTextBox2.Text;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                this.webBrowser1.Navigate("http://virustotal.com");



            }



            catch { }

        }

        private void webBrowser1_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            try
            {

                richTextBox1.Text = webBrowser1.DocumentText.Trim();
                richTextBox2.Text = webBrowser1.Document.Cookie.Trim();
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create("http://" + textBox1.Text);

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                richTextBox3.Text = response.Headers.ToString();
                while (webBrowser1.IsBusy) Application.DoEvents();
                object window = webBrowser1.Document.Window.DomWindow;
                Type wt = window.GetType();
                object navigator = wt.InvokeMember("navigator", System.Reflection.BindingFlags.GetProperty, null, window, new object[] { });
                Type nt = navigator.GetType();
                object userAgent = nt.InvokeMember("userAgent", System.Reflection.BindingFlags.GetProperty, null, navigator, new object[] { });

                richTextBox4.Text = "User-Agent:" + userAgent.ToString() + "\r\n" + request.Headers.ToString();
                request.Abort();
                response.Close();
            }
            catch { }
        }
       
    }
}