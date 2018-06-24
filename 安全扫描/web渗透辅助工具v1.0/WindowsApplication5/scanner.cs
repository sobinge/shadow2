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
     public partial class scanner : Form
     {
         
         public scanner()
         {
             InitializeComponent();
         }
         string webtype = "";
         public delegate void functionDele();
         public functionDele doEvent;

        public delegate void functionDele1(string s);
         public functionDele1 doEvent1;

        bool tag = true;
        private void button1_Click(object sender, EventArgs e)
         {
            
         }
         public void DoWork(object state)
         {
                if(!tag)
                return;
             HttpWebRequest hwr = (HttpWebRequest)WebRequest.Create(this.textBox3.Text.Trim()+"/" + state.ToString() + "/");
             hwr.AllowAutoRedirect = false;
             hwr.Timeout = 1000;
             hwr.Proxy = null;
             hwr.ServicePoint.ConnectionLimit = 100;
             hwr.ReadWriteTimeout = 1000;
            hwr.Method = "GET"; 
            
            try
             {
                 HttpWebResponse hwrs = (HttpWebResponse)hwr.GetResponse();
                 if (hwrs.StatusCode == HttpStatusCode.OK) 
                {
                    if (doEvent1 != null)
                    {
                        this.BeginInvoke(doEvent1, new object[] { this.textBox3.Text.Trim() + "/" + state.ToString()});
                        
                        
                    }
                    hwrs.Close();
                }
              
             }
             catch (Exception ex)
             {
                
                 if (ex.ToString().ToLower().IndexOf("403") != -1)
                {
                     if (doEvent1 != null)
                     {
                         this.BeginInvoke(doEvent1, new object[] { this.textBox3.Text.Trim() + "/" + state.ToString()});
                         
                         
                     }
                       
                  
                 }
                 
             }
             
             if (doEvent != null)
             {
                 Thread.Sleep(1);
                 this.BeginInvoke(doEvent);
            }


            hwr.Abort(); 
            
           
         }

        private void scanner_Load(object sender, EventArgs e)
         {
             doEvent = new functionDele(addProgressBarvalue);
             doEvent1 = new functionDele1(addListBoxItem);
          
         }

         void addProgressBarvalue()
         {
             this.progressBar1.Value += 1;
         }
         void addListBoxItem(string s)
        {
             this.listBox1.Items.Add(s);
         }

         private void button1_Click_1(object sender, EventArgs e)
         {
             tag = true;
             this.progressBar1.Value = 0;
             this.listBox1.Items.Clear();
             if (this.label3.Text.ToString() == "ÇëÑ¡Ôñ×Öµä")
             {
                 MessageBox.Show("ÉÐÎ´Ñ¡Ôñ×Öµä");
                 return;
             }
             string check = textBox3.Text.Substring(0, 7);
             if (this.textBox3.Text.Trim() == "" || this.textBox3.Text.Trim().ToLower() == "http://")
             {
                 MessageBox.Show("ÊäÈëÍøÖ·²»ÕýÈ·");
                 return;
             }
             if (check != "http://")
             {
                 textBox3.Text = "http://" + textBox3.Text;
             }
             else
             { 
             
             }
             string[] strarr = System.IO.File.ReadAllLines(webtype + ".txt");
             WaitCallback waitcallback = new WaitCallback(DoWork);
             int count = strarr.Length;
             progressBar1.Maximum = count;
             ThreadPool.SetMaxThreads(100, 120);
             ThreadPool.SetMinThreads(80, 120);
             for (int i = 0; i < strarr.Length; i++)
             {
                 ThreadPool.QueueUserWorkItem(waitcallback, strarr[i]);

             }
         }

         private void button2_Click_1(object sender, EventArgs e)
         {
             tag = false;
         }

         private void textBox3_Enter_1(object sender, EventArgs e)
         {

         }

         private void listBox1_SelectedIndexChanged_1(object sender, EventArgs e)
         {
             try
             {
                 System.Diagnostics.Process.Start("iexplore.exe", this.listBox1.SelectedItem.ToString());
             }
             catch { }
         }

         private void item1_Click(object sender, EventArgs e)
         {
             webtype = item1.Text;
             label3.Text = item1.Text;
         }

         private void item2_Click(object sender, EventArgs e)
         {
             webtype = item2.Text;
             label3.Text = item2.Text;
         }

         private void item3_Click(object sender, EventArgs e)
         {
             webtype = item3.Text;
             label3.Text = item3.Text;
         }

         private void item4_Click(object sender, EventArgs e)
         {
             webtype = item4.Text;
             label3.Text = item4.Text;
         }

         private void item5_Click(object sender, EventArgs e)
         {
             webtype = item5.Text;
             label3.Text = item5.Text;
         }

         private void item6_Click(object sender, EventArgs e)
         {
             webtype = item6.Text;
             label3.Text = item6.Text;
         }
     }
 }
