using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace WindowsApplication3
{
    public partial class encode : Form
    {
        public encode()
        {
            InitializeComponent();
        }

        private void encode_Load(object sender, EventArgs e)
        {
            webBrowser1.Navigate("http://ha.ckers.org/xsscalc.html");
        }
    }
}