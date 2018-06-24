using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using System.Net;
using System.Net.Sockets;
using System.Threading;


namespace WindowsApplication3
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        TcpClient tcpclient;
        string ip;
        public delegate void dele1();//进度条++
        public dele1 doEvent1;
        public delegate void dele2(string item);//listbox增加项
        public dele2 doEvent2;
        bool tag = true; //是否停止 true为否
        private void Form1_Load(object sender, EventArgs e)
        {

            ip2domain form2 = new ip2domain();
            form2.TopLevel = false;
            form2.Parent = tabPage2;
            form2.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form2.Show();

            scanner form3 = new scanner();
            form3.TopLevel = false;
            form3.Parent = tabPage3;
            form3.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form3.Show();

            fingureprint form4 = new fingureprint();
            form4.TopLevel = false;
            form4.Parent = tabPage4;
            form4.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form4.Show();

            serverinfo form5 = new serverinfo();
            form5.TopLevel = false;
            form5.Parent = tabPage5;
            form5.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form5.Show();

            NC form6 = new NC();
            form6.TopLevel = false;
            form6.Parent = tabPage6;
            form6.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form6.Show();

            CMD form7 = new CMD();
            form7.TopLevel = false;
            form7.Parent = tabPage7;
            form7.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form7.Show();

            MD5 form8 = new MD5();
            form8.TopLevel = false;
            form8.Parent = tabPage8;
            form8.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form8.Show();

            encode form9 = new encode();
            form9.TopLevel = false;
            form9.Parent = tabPage9;
            form9.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            form9.Show();

            doEvent1 = new dele1(addProgressBarValue);
            doEvent2 = new dele2(addListBoxItem);
        }

        void scan(object obj)
        {
            if (!tag)//停止
                return;
            try
            {
                this.BeginInvoke(doEvent1);//进度条++
                int port = int.Parse(obj.ToString());
                tcpclient = new TcpClient();
                tcpclient.SendTimeout = 1000;
                tcpclient.ReceiveTimeout = 1000;
                tcpclient.Connect(ip, port); //核心代码,如果连接不成功将会引发错误执行catch而不执行下面一句;
                this.BeginInvoke(doEvent2, new object[] { port.ToString() }); //如果连接成功则执行增加listbox项的操作;
            }
            catch (Exception ex) { /*MessageBox.Show(ex.ToString()); */}
        }
        void addProgressBarValue()
        {
            this.progressBar1.Value += 1;
        }
        void addListBoxItem(string item)
        {
            IPAddress[] ips = Dns.GetHostAddresses(textBox1.Text);
            ip = ips[0].ToString();
            this.listBox1.Items.Add(ips[0]+":"+item);
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            //停止
            tag = false;
            this.progressBar1.Minimum = 0;
            this.progressBar1.Value = 0;
        }

        private void tabControl1_MouseClick(object sender, MouseEventArgs e)
        {



            

            
        }

        private void button3_Click(object sender, EventArgs e)
        {
           
            listBox1.Items.Clear();
            tag = true;
            this.progressBar1.Value = 0;
            IPAddress[] ips=Dns.GetHostAddresses(textBox1.Text);
            ip = ips[0].ToString();
            try
            {
                IPAddress ipaddress = IPAddress.Parse(this.textBox1.Text);
            }
            catch
            {  }
            string[] port = System.IO.File.ReadAllLines("port.txt");

            this.progressBar1.Maximum = port.Length;

            ThreadPool.SetMaxThreads(100, 120);
            ThreadPool.SetMinThreads(80, 120);

            for (int i = 0; i < port.Length;i++)
            {
                ThreadPool.QueueUserWorkItem(scan, port[i]);
            }
        }

        private void 关于ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("渗透辅助工具v0.1.如果有好的意见或建议请联系E-mail:mramydnei@qq.com");
        }

        private void tabPage8_Click(object sender, EventArgs e)
        {

        }
    }
}
