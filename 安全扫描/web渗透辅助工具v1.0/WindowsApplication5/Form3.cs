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
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }
        string folder = "";

        private void button1_Click(object sender, EventArgs e)
        {

            StreamWriter sw = File.AppendText(folder+"/list.txt");
            sw.WriteLine(textBox1.Text);
            sw.Flush();
            sw.Close();

            if (!File.Exists(folder +"/"+textBox1.Text + ".txt"))
            {
                FileStream sw3= File.Create(folder + "/" + textBox1.Text + ".txt");
                sw3.Flush();
                sw3.Close();
                
                StreamWriter sw2 = File.AppendText(folder + "/" + textBox1.Text + ".txt");
                sw2.WriteLine(richTextBox1.Text);
                sw2.Flush();
                sw2.Close();

                MessageBox.Show("Ìí¼Ó³É¹¦");

            }
             
            
        }

        private void Form3_Load(object sender, EventArgs e)
        {
            string[] strarr2 = System.IO.File.ReadAllLines("webapp.txt");
            for (int c = 0; c < strarr2.Length; c++)
            {
                this.listBox1.Items.Add(strarr2[c]);
            }
        }

        private void listBox1_MouseClick(object sender, MouseEventArgs e)
        {
            int index = listBox1.IndexFromPoint(e.X, e.Y); listBox1.SelectedIndex = index;
            if (listBox1.SelectedIndex != -1)
            {
                folder = listBox1.SelectedItem.ToString();
            }
        }
    }
}