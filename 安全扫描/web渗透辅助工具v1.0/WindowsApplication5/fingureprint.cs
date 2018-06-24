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
     public partial class fingureprint : Form
     {
         
         public fingureprint()
         {
             InitializeComponent();
         }
         string[] strarr = System.IO.File.ReadAllLines("file.txt");
         string[] strarr2 = System.IO.File.ReadAllLines("webapp.txt");
         string[] strarr3 = System.IO.File.ReadAllLines("dedecms/version.txt");

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

        private void Form1_Load(object sender, EventArgs e)
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

            WebClient wc = new WebClient();
            wc.Credentials = CredentialCache.DefaultCredentials;
            Encoding enc = Encoding.GetEncoding("GB2312");
            for (int i=0;i<strarr.Length;i++)
            {
             if (s.IndexOf(strarr[i]) > -1)
            {

                this.listBox1.Items.Add("目测是一套" + strarr2[i]);
                try
                {
                    string[] strarr4 = System.IO.File.ReadAllLines(strarr2[i] + "/list.txt", System.Text.Encoding.Default);

                    for (int c = 0; c < strarr4.Length; c++)
                    {
                        this.listBox2.Items.Add(strarr2[i] + "/" + strarr4[c] + ".txt");
                        if (c == strarr4.Length-1)
                        {
                            label2.Text = "可能存在漏洞"+(c+1).ToString()+"个:";
                        }
                    }
                }
                catch { }
                 try
                 {
                     Byte[] pageData = wc.DownloadData(textBox3.Text.Trim() + "/data/admin/ver.txt");
                     string sss = enc.GetString(pageData);
                     for (int x = 0; x < strarr3.Length; x = x + 2)
                     {
                         if (strarr3[x] == sss)
                         {
                             label1.Text = "版本信息：更新文件内容为"+sss+".版本号是:" + strarr3[x + 1].ToString();
                         }
 
                     }
                        
                     
                 }
                 catch { }
             
             
             }
         }
         }

         private void button1_Click_1(object sender, EventArgs e)
         {
             richTextBox1.Text = "";
             listBox2.Items.Clear();
             label1.Text = "版本信息：";
             tag = true;
             this.progressBar1.Value = 0;
             this.listBox1.Items.Clear();
             if (this.textBox3.Text.Trim() == "" || this.textBox3.Text.Trim().ToLower() == "http://")
             {
                 MessageBox.Show("输入网址不正确");
                 return;
             }
             if (textBox3.Text.Substring(0, 7) != "http://")
             {
                 textBox3.Text = "http://" + textBox3.Text;
             }
             else
             { 
             
             }
             
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

         private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
         {

         }

         private void listBox2_MouseClick(object sender, MouseEventArgs e)
         {
             int index = listBox2.IndexFromPoint(e.X, e.Y); listBox2.SelectedIndex = index; 
             if (listBox2.SelectedIndex != -1) 
             {
                richTextBox1.Text=System.IO.File.ReadAllText(listBox2.SelectedItem.ToString(),System.Text.Encoding.Default); 
             }
         }

         private void 关于ToolStripMenuItem_Click(object sender, EventArgs e)
         {
             
         }

         private void 漏洞库ToolStripMenuItem_Click(object sender, EventArgs e)
         {
             Form2 form = new Form2();

             form.Show();
             
         }

         private void 漏洞库ToolStripMenuItem1_Click(object sender, EventArgs e)
         {
             Form3 form = new Form3();

             form.Show();
         }

  

     }
 }
