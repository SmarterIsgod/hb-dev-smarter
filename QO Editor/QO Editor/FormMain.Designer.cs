namespace QO_Editor
{
    partial class FormMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.TreeNode treeNode21 = new System.Windows.Forms.TreeNode("Blackspot");
            System.Windows.Forms.TreeNode treeNode22 = new System.Windows.Forms.TreeNode("Blackspots", new System.Windows.Forms.TreeNode[] {
            treeNode21});
            System.Windows.Forms.TreeNode treeNode23 = new System.Windows.Forms.TreeNode("AvoidMob");
            System.Windows.Forms.TreeNode treeNode24 = new System.Windows.Forms.TreeNode("AvoidMobs", new System.Windows.Forms.TreeNode[] {
            treeNode23});
            System.Windows.Forms.TreeNode treeNode25 = new System.Windows.Forms.TreeNode("Node14");
            System.Windows.Forms.TreeNode treeNode26 = new System.Windows.Forms.TreeNode("Mailbox", new System.Windows.Forms.TreeNode[] {
            treeNode25});
            System.Windows.Forms.TreeNode treeNode27 = new System.Windows.Forms.TreeNode("Vendor");
            System.Windows.Forms.TreeNode treeNode28 = new System.Windows.Forms.TreeNode("Vendors", new System.Windows.Forms.TreeNode[] {
            treeNode27});
            System.Windows.Forms.TreeNode treeNode29 = new System.Windows.Forms.TreeNode("Hotspots");
            System.Windows.Forms.TreeNode treeNode30 = new System.Windows.Forms.TreeNode("Objective", new System.Windows.Forms.TreeNode[] {
            treeNode29});
            System.Windows.Forms.TreeNode treeNode31 = new System.Windows.Forms.TreeNode("Quest", new System.Windows.Forms.TreeNode[] {
            treeNode30});
            System.Windows.Forms.TreeNode treeNode32 = new System.Windows.Forms.TreeNode("Quest Overrides", new System.Windows.Forms.TreeNode[] {
            treeNode31});
            System.Windows.Forms.TreeNode treeNode33 = new System.Windows.Forms.TreeNode("PickUp");
            System.Windows.Forms.TreeNode treeNode34 = new System.Windows.Forms.TreeNode("Hotspots");
            System.Windows.Forms.TreeNode treeNode35 = new System.Windows.Forms.TreeNode("Objective", new System.Windows.Forms.TreeNode[] {
            treeNode34});
            System.Windows.Forms.TreeNode treeNode36 = new System.Windows.Forms.TreeNode("TurnIn");
            System.Windows.Forms.TreeNode treeNode37 = new System.Windows.Forms.TreeNode("Hotspot");
            System.Windows.Forms.TreeNode treeNode38 = new System.Windows.Forms.TreeNode("Hotspots", new System.Windows.Forms.TreeNode[] {
            treeNode37});
            System.Windows.Forms.TreeNode treeNode39 = new System.Windows.Forms.TreeNode("SetGrindArea", new System.Windows.Forms.TreeNode[] {
            treeNode38});
            System.Windows.Forms.TreeNode treeNode40 = new System.Windows.Forms.TreeNode("QuestOrder", new System.Windows.Forms.TreeNode[] {
            treeNode33,
            treeNode35,
            treeNode36,
            treeNode39});
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.treeView1 = new System.Windows.Forms.TreeView();
            this.propertyGrid1 = new System.Windows.Forms.PropertyGrid();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.propertyGrid1);
            this.groupBox2.Controls.Add(this.treeView1);
            this.groupBox2.Location = new System.Drawing.Point(212, 12);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(466, 442);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Profile Name";
            // 
            // treeView1
            // 
            this.treeView1.Location = new System.Drawing.Point(6, 19);
            this.treeView1.Name = "treeView1";
            treeNode21.Name = "Node7";
            treeNode21.Text = "Blackspot";
            treeNode22.Name = "Node6";
            treeNode22.Text = "Blackspots";
            treeNode23.Name = "Node13";
            treeNode23.Text = "AvoidMob";
            treeNode24.Name = "Node8";
            treeNode24.Text = "AvoidMobs";
            treeNode25.Name = "Node14";
            treeNode25.Text = "Node14";
            treeNode26.Name = "Node9";
            treeNode26.Text = "Mailbox";
            treeNode27.Name = "Node15";
            treeNode27.Text = "Vendor";
            treeNode28.Name = "Node10";
            treeNode28.Text = "Vendors";
            treeNode29.Name = "Node17";
            treeNode29.Text = "Hotspots";
            treeNode30.Name = "Node16";
            treeNode30.Text = "Objective";
            treeNode31.Name = "Node12";
            treeNode31.Text = "Quest";
            treeNode32.Name = "Node11";
            treeNode32.Text = "Quest Overrides";
            treeNode33.Name = "Node19";
            treeNode33.Text = "PickUp";
            treeNode34.Name = "Node21";
            treeNode34.Text = "Hotspots";
            treeNode35.Name = "Node20";
            treeNode35.Text = "Objective";
            treeNode36.Name = "Node22";
            treeNode36.Text = "TurnIn";
            treeNode37.Name = "Node25";
            treeNode37.Text = "Hotspot";
            treeNode38.Name = "Node24";
            treeNode38.Text = "Hotspots";
            treeNode39.Name = "Node23";
            treeNode39.Text = "SetGrindArea";
            treeNode40.Name = "Node18";
            treeNode40.Text = "QuestOrder";
            this.treeView1.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode22,
            treeNode24,
            treeNode26,
            treeNode28,
            treeNode32,
            treeNode40});
            this.treeView1.Size = new System.Drawing.Size(457, 304);
            this.treeView1.TabIndex = 0;
            // 
            // propertyGrid1
            // 
            this.propertyGrid1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.propertyGrid1.HelpVisible = false;
            this.propertyGrid1.Location = new System.Drawing.Point(3, 329);
            this.propertyGrid1.Name = "propertyGrid1";
            this.propertyGrid1.PropertySort = System.Windows.Forms.PropertySort.Alphabetical;
            this.propertyGrid1.Size = new System.Drawing.Size(460, 110);
            this.propertyGrid1.TabIndex = 1;
            this.propertyGrid1.ToolbarVisible = false;
            // 
            // richTextBox1
            // 
            this.richTextBox1.BackColor = System.Drawing.SystemColors.AppWorkspace;
            this.richTextBox1.Location = new System.Drawing.Point(7, 330);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(193, 109);
            this.richTextBox1.TabIndex = 1;
            this.richTextBox1.Text = "The <Pickup> tag is how a Profile Writer initiates a quest. The game world curren" +
                "tly allows for three sources of quest initiation:\nNPCs\nObjects\nItems";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.listBox1);
            this.groupBox1.Controls.Add(this.richTextBox1);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(200, 442);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "groupBox1";
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.Items.AddRange(new object[] {
            "Blackspot",
            "AvoidMob",
            "Mailbox",
            "Vendor",
            "Quest Override",
            "Hotspot",
            "PickUp",
            "TurnIn",
            "Objective",
            "SetGrindArea",
            "Checkpoint",
            "If",
            "While",
            "CustomBehavior",
            "Custom Action",
            "UseItem",
            "RunTo",
            "SetVendor"});
            this.listBox1.Location = new System.Drawing.Point(7, 19);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(187, 303);
            this.listBox1.TabIndex = 2;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(682, 506);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form1";
            this.Text = "Smarter\'s Profile Editor";
            this.groupBox2.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TreeView treeView1;
        private System.Windows.Forms.PropertyGrid propertyGrid1;
        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ListBox listBox1;
    }
}

