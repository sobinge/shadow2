namespace WindowsApplication3
{
    partial class scanner
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.progressBar1 = new System.Windows.Forms.ProgressBar();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.item1 = new System.Windows.Forms.ToolStripMenuItem();
            this.item2 = new System.Windows.Forms.ToolStripMenuItem();
            this.item3 = new System.Windows.Forms.ToolStripMenuItem();
            this.item4 = new System.Windows.Forms.ToolStripMenuItem();
            this.item5 = new System.Windows.Forms.ToolStripMenuItem();
            this.item6 = new System.Windows.Forms.ToolStripMenuItem();
            this.label1 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button1.Location = new System.Drawing.Point(954, 30);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "扫描";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // button2
            // 
            this.button2.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button2.Location = new System.Drawing.Point(1035, 30);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 1;
            this.button2.Text = "停止";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click_1);
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.ItemHeight = 12;
            this.listBox1.Location = new System.Drawing.Point(2, 59);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(1108, 436);
            this.listBox1.TabIndex = 2;
            this.listBox1.SelectedIndexChanged += new System.EventHandler(this.listBox1_SelectedIndexChanged_1);
            // 
            // progressBar1
            // 
            this.progressBar1.Location = new System.Drawing.Point(2, 498);
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Size = new System.Drawing.Size(1108, 23);
            this.progressBar1.TabIndex = 3;
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(2, 32);
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(946, 21);
            this.textBox3.TabIndex = 5;
            this.textBox3.Enter += new System.EventHandler(this.textBox3_Enter_1);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.item1,
            this.item2,
            this.item3,
            this.item4,
            this.item5,
            this.item6});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1110, 24);
            this.menuStrip1.TabIndex = 6;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // item1
            // 
            this.item1.Name = "item1";
            this.item1.Size = new System.Drawing.Size(35, 20);
            this.item1.Text = "asp";
            this.item1.Click += new System.EventHandler(this.item1_Click);
            // 
            // item2
            // 
            this.item2.Name = "item2";
            this.item2.Size = new System.Drawing.Size(41, 20);
            this.item2.Text = "aspx";
            this.item2.Click += new System.EventHandler(this.item2_Click);
            // 
            // item3
            // 
            this.item3.Name = "item3";
            this.item3.Size = new System.Drawing.Size(35, 20);
            this.item3.Text = "php";
            this.item3.Click += new System.EventHandler(this.item3_Click);
            // 
            // item4
            // 
            this.item4.Name = "item4";
            this.item4.Size = new System.Drawing.Size(35, 20);
            this.item4.Text = "jsp";
            this.item4.Click += new System.EventHandler(this.item4_Click);
            // 
            // item5
            // 
            this.item5.Name = "item5";
            this.item5.Size = new System.Drawing.Size(35, 20);
            this.item5.Text = "dir";
            this.item5.Click += new System.EventHandler(this.item5_Click);
            // 
            // item6
            // 
            this.item6.Name = "item6";
            this.item6.Size = new System.Drawing.Size(35, 20);
            this.item6.Text = "mdb";
            this.item6.Click += new System.EventHandler(this.item6_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(964, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 12);
            this.label1.TabIndex = 7;
            this.label1.Text = "当前字典：";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(1035, 9);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(65, 12);
            this.label3.TabIndex = 8;
            this.label3.Text = "请选择字典";
            // 
            // scanner
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1110, 522);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.progressBar1);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "scanner";
            this.Text = "多线程后台扫描 By：Mramydnei";
            this.Load += new System.EventHandler(this.scanner_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.ProgressBar progressBar1;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ToolStripMenuItem item1;
        private System.Windows.Forms.ToolStripMenuItem item2;
        private System.Windows.Forms.ToolStripMenuItem item3;
        private System.Windows.Forms.ToolStripMenuItem item4;
        private System.Windows.Forms.ToolStripMenuItem item5;
        private System.Windows.Forms.ToolStripMenuItem item6;
    }
}

