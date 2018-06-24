using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace WindowsApplication3
{
    public partial class ip2domain : Form
    {
        public ip2domain()
        {
            InitializeComponent();
        }
        
        string url = "http://www.114best.com/ip/114.aspx?w=";
        string url2 = "";
        string sourcecode = "";
        private void button1_Click(object sender, EventArgs e)
        {
            listBox2.Items.Clear();
            url2 = textBox1.Text;
            sourcecode = richTextBox1.Text;
            webBrowser1.Navigate(new Uri(url + url2));
           
        }
            

        

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Process.Start("iexplore.exe", this.listBox2.SelectedItem.ToString());
            }
            catch { }
        }

        private void Form2_Load(object sender, EventArgs e)
        {
         
        }

        private void Form2_KeyPress(object sender, KeyPressEventArgs e)
        {
            
        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar > 12 && e.KeyChar <14)
            {
                button1.Focus(); System.Windows.Forms.SendKeys.Send("{enter} "); 
                
            }
        }

        private void webBrowser1_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            listBox2.Items.Clear();
            richTextBox1.Text = webBrowser1.DocumentText.Trim();
            string[] s = this.richTextBox1.Lines;
            string regex = @"(\d+)\D+(\d+.)";

            if (textBox1.Text == "")
            {
                MessageBox.Show("请填写目标站点的ip或域名");
            }
            else if (s.Length > 0)
            {

                Match mstr = Regex.Match(s[40], regex);
                label2.Text = "共找到旁站" + mstr.Groups[2].Value.Trim() + "个";

                for (int i = 62, a = 0, b = 1; i < s.Length; i = i + 4, a = a + 1, b = b + 1)
                {


                    try
                    {
                        if (Convert.ToInt32(mstr.Groups[2].Value) > a)
                        {
                            string yoyoyo = "<span>" + b.ToString() + ". </span><a target=\"_blank\">";
                            string asd = s[i].Replace(yoyoyo, "");
                            string asdf = asd.Replace("</a>&nbsp;&nbsp;<img style=\"cursor:pointer\" onclick=\"window.open('http://", "");
                            string asdfg = asdf.Replace("');\" pop='http://", "");
                            string asdfgh = asdfg.Replace("' src=\"view.gif\"/></a><br>", "");
                            int fuckme = asdfgh.Length / 3;
                            string asdfghj = asdfgh.Substring(0, fuckme);
                            listBox2.Items.Add(asdfghj);


                        }
                    }
                    catch
                    {


                    }






                }



            }
        }
    }
}