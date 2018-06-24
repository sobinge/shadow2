using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace WindowsApplication3
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            StreamWriter sw = File.AppendText("webapp.txt");
            sw.WriteLine(textBox1.Text);
            sw.Flush();
            sw.Close();
            StreamWriter sw2 = File.AppendText("file.txt");
            sw2.WriteLine("/"+textBox2.Text);
            sw2.Flush();
            sw2.Close();
            string foldername = textBox1.Text;
            if (!Directory.Exists(foldername))
            {

                Directory.CreateDirectory(foldername);
                File.Create(foldername+"/list.txt");

                MessageBox.Show("Ìí¼Ó³É¹¦");

            }
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            textBox1.Text = "";
            textBox2.Text = "";
        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }
    }
}