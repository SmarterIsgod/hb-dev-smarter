namespace Travel
{
    partial class FormTravel
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
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.labelPortalInfo = new System.Windows.Forms.Label();
            this.btnGrabInfoUsePortal = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.lblTransportInfo = new System.Windows.Forms.Label();
            this.btnGrabTransportUse = new System.Windows.Forms.Button();
            this.textOutput = new System.Windows.Forms.TextBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.labelPortalInfo);
            this.groupBox1.Controls.Add(this.btnGrabInfoUsePortal);
            this.groupBox1.Location = new System.Drawing.Point(13, 13);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(200, 100);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Portal Information";
            // 
            // labelPortalInfo
            // 
            this.labelPortalInfo.AutoSize = true;
            this.labelPortalInfo.Location = new System.Drawing.Point(7, 20);
            this.labelPortalInfo.Name = "labelPortalInfo";
            this.labelPortalInfo.Size = new System.Drawing.Size(35, 13);
            this.labelPortalInfo.TabIndex = 1;
            this.labelPortalInfo.Text = "label1";
            // 
            // btnGrabInfoUsePortal
            // 
            this.btnGrabInfoUsePortal.Location = new System.Drawing.Point(44, 71);
            this.btnGrabInfoUsePortal.Name = "btnGrabInfoUsePortal";
            this.btnGrabInfoUsePortal.Size = new System.Drawing.Size(111, 23);
            this.btnGrabInfoUsePortal.TabIndex = 0;
            this.btnGrabInfoUsePortal.Text = "Grab Portal && Use";
            this.btnGrabInfoUsePortal.UseVisualStyleBackColor = true;
            this.btnGrabInfoUsePortal.Click += new System.EventHandler(this.BtnGrabInfoUsePortalClick);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.lblTransportInfo);
            this.groupBox2.Controls.Add(this.btnGrabTransportUse);
            this.groupBox2.Location = new System.Drawing.Point(219, 13);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(200, 100);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Transport Information:";
            // 
            // lblTransportInfo
            // 
            this.lblTransportInfo.AutoSize = true;
            this.lblTransportInfo.Location = new System.Drawing.Point(7, 20);
            this.lblTransportInfo.Name = "lblTransportInfo";
            this.lblTransportInfo.Size = new System.Drawing.Size(35, 13);
            this.lblTransportInfo.TabIndex = 1;
            this.lblTransportInfo.Text = "label1";
            // 
            // btnGrabTransportUse
            // 
            this.btnGrabTransportUse.Location = new System.Drawing.Point(35, 71);
            this.btnGrabTransportUse.Name = "btnGrabTransportUse";
            this.btnGrabTransportUse.Size = new System.Drawing.Size(135, 23);
            this.btnGrabTransportUse.TabIndex = 0;
            this.btnGrabTransportUse.Text = "Grab Transportl && Use";
            this.btnGrabTransportUse.UseVisualStyleBackColor = true;
            this.btnGrabTransportUse.Click += new System.EventHandler(this.BtnGrabTransportUseClick);
            // 
            // textOutput
            // 
            this.textOutput.Location = new System.Drawing.Point(12, 119);
            this.textOutput.Multiline = true;
            this.textOutput.Name = "textOutput";
            this.textOutput.Size = new System.Drawing.Size(407, 132);
            this.textOutput.TabIndex = 2;
            // 
            // FormTravel
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(437, 257);
            this.Controls.Add(this.textOutput);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "FormTravel";
            this.Text = "Travel Record";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        public System.Windows.Forms.Label labelPortalInfo;
        private System.Windows.Forms.Button btnGrabInfoUsePortal;
        private System.Windows.Forms.GroupBox groupBox2;
        public System.Windows.Forms.Label lblTransportInfo;
        private System.Windows.Forms.Button btnGrabTransportUse;
        public System.Windows.Forms.TextBox textOutput;
    }
}