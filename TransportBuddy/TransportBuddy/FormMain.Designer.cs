namespace TransportBuddy
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
            this.buttonWaitAt = new System.Windows.Forms.Button();
            this.buttonOnTransport = new System.Windows.Forms.Button();
            this.buttonDestination = new System.Windows.Forms.Button();
            this.buttonOffTransport = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.textBoxCode = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxZoneInfo = new System.Windows.Forms.TextBox();
            this.buttonZoneInfo = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // buttonWaitAt
            // 
            this.buttonWaitAt.Location = new System.Drawing.Point(13, 13);
            this.buttonWaitAt.Name = "buttonWaitAt";
            this.buttonWaitAt.Size = new System.Drawing.Size(182, 23);
            this.buttonWaitAt.TabIndex = 0;
            this.buttonWaitAt.Text = "Click When at WaitAt Location";
            this.buttonWaitAt.UseVisualStyleBackColor = true;
            this.buttonWaitAt.Click += new System.EventHandler(this.ButtonWaitAtClick);
            // 
            // buttonOnTransport
            // 
            this.buttonOnTransport.Location = new System.Drawing.Point(13, 42);
            this.buttonOnTransport.Name = "buttonOnTransport";
            this.buttonOnTransport.Size = new System.Drawing.Size(182, 23);
            this.buttonOnTransport.TabIndex = 1;
            this.buttonOnTransport.Text = "Click when On Transport";
            this.buttonOnTransport.UseVisualStyleBackColor = true;
            this.buttonOnTransport.Click += new System.EventHandler(this.ButtonOnTransportClick);
            // 
            // buttonDestination
            // 
            this.buttonDestination.Location = new System.Drawing.Point(13, 71);
            this.buttonDestination.Name = "buttonDestination";
            this.buttonDestination.Size = new System.Drawing.Size(182, 23);
            this.buttonDestination.TabIndex = 2;
            this.buttonDestination.Text = "Click before Getting Off Transport";
            this.buttonDestination.UseVisualStyleBackColor = true;
            this.buttonDestination.Click += new System.EventHandler(this.ButtonDestinationClick);
            // 
            // buttonOffTransport
            // 
            this.buttonOffTransport.Location = new System.Drawing.Point(13, 100);
            this.buttonOffTransport.Name = "buttonOffTransport";
            this.buttonOffTransport.Size = new System.Drawing.Size(182, 23);
            this.buttonOffTransport.TabIndex = 3;
            this.buttonOffTransport.Text = "Click when Off the Transport";
            this.buttonOffTransport.UseVisualStyleBackColor = true;
            this.buttonOffTransport.Click += new System.EventHandler(this.ButtonOffTransportClick);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.textBoxCode);
            this.groupBox1.Location = new System.Drawing.Point(201, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(350, 108);
            this.groupBox1.TabIndex = 4;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "UseTransport Code";
            // 
            // textBoxCode
            // 
            this.textBoxCode.Location = new System.Drawing.Point(6, 19);
            this.textBoxCode.Multiline = true;
            this.textBoxCode.Name = "textBoxCode";
            this.textBoxCode.Size = new System.Drawing.Size(338, 83);
            this.textBoxCode.TabIndex = 0;
            this.textBoxCode.WordWrap = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 145);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(90, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Zone Information:";
            // 
            // textBoxZoneInfo
            // 
            this.textBoxZoneInfo.Location = new System.Drawing.Point(108, 142);
            this.textBoxZoneInfo.Multiline = true;
            this.textBoxZoneInfo.Name = "textBoxZoneInfo";
            this.textBoxZoneInfo.Size = new System.Drawing.Size(443, 65);
            this.textBoxZoneInfo.TabIndex = 6;
            this.textBoxZoneInfo.WordWrap = false;
            // 
            // buttonZoneInfo
            // 
            this.buttonZoneInfo.Location = new System.Drawing.Point(13, 161);
            this.buttonZoneInfo.Name = "buttonZoneInfo";
            this.buttonZoneInfo.Size = new System.Drawing.Size(75, 23);
            this.buttonZoneInfo.TabIndex = 7;
            this.buttonZoneInfo.Text = "Zone Info";
            this.buttonZoneInfo.UseVisualStyleBackColor = true;
            this.buttonZoneInfo.Click += new System.EventHandler(this.ButtonZoneInfoClick);
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(563, 212);
            this.Controls.Add(this.buttonZoneInfo);
            this.Controls.Add(this.textBoxZoneInfo);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.buttonOffTransport);
            this.Controls.Add(this.buttonDestination);
            this.Controls.Add(this.buttonOnTransport);
            this.Controls.Add(this.buttonWaitAt);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "FormMain";
            this.Text = "TransportBuddy";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonWaitAt;
        private System.Windows.Forms.Button buttonOnTransport;
        private System.Windows.Forms.Button buttonDestination;
        private System.Windows.Forms.Button buttonOffTransport;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox textBoxCode;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxZoneInfo;
        private System.Windows.Forms.Button buttonZoneInfo;

    }
}