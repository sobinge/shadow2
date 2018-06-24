using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;

namespace WindowsApplication3
{
    public partial class CMD : Form
    {
        public CMD()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
           Process p = new Process();
   p.StartInfo.FileName = "cmd.exe";
   p.StartInfo.UseShellExecute = false;
   p.StartInfo.RedirectStandardInput = true;
   p.StartInfo.RedirectStandardOutput = true;
   p.StartInfo.RedirectStandardError = true;
   p.StartInfo.CreateNoWindow = true;
   p.Start();
   string strOutput=null;
   p.StandardInput.WriteLine(textBox1.Text);
   p.StandardInput.WriteLine("exit");
   strOutput = p.StandardOutput.ReadToEnd();
   richTextBox1.Text = strOutput;
   p.WaitForExit();
   p.Close();

        }
    }
}