using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Clean_Collect.User_Controls
{
    public partial class UserControlDebtorPhone : UserControl
    {
        private Point _pointMouse = new Point();
        private Control _ctrlMoved = new Control();
        private bool _bMoving = false;

        public UserControlDebtorPhone()
        {
            MouseDown += ControlMouseDown;
            MouseUp += ControlMouseUp;
            MouseMove += ControlMouseMove;
            InitializeComponent();
        }

        private void ControlMouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            //if not left mouse button, exit
            if (e.Button != MouseButtons.Left)
            {
                return;
            }
            // save cursor location
            _pointMouse = e.Location;
            //remember that we're moving
            _bMoving = true;
        }
        private void ControlMouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            _bMoving = false;
        }
        private void ControlMouseMove(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            //if not being moved or left mouse button not used, exit
            if (!_bMoving || e.Button != MouseButtons.Left)
            {
                return;
            }
            //get control reference
            _ctrlMoved = (Control)sender;
            //set control's position based upon mouse's position change
            _ctrlMoved.Left += e.X - _pointMouse.X;
            _ctrlMoved.Top += e.Y - _pointMouse.Y;
        }
    }
}
