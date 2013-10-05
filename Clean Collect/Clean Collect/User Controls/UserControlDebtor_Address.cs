using System.Drawing;
using System.Windows.Forms;

namespace Clean_Collect.User_Controls
{
    public partial class UserControlDebtorAddress : UserControl
    {
        private readonly ContextMenu _rightClickMenu;
        private bool _bMoving;
        private Control _ctrlMoved = new Control();
        private Point _pointMouse;

        public UserControlDebtorAddress()
        {
            MouseDown += ControlMouseDown;
            MouseUp += ControlMouseUp;
            MouseMove += ControlMouseMove;
            _rightClickMenu = new ContextMenu();
            _rightClickMenu.MenuItems.Add(new MenuItem("Settings"));
            InitializeComponent();
        }

        private void ControlMouseDown(object sender, MouseEventArgs e)
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

        private void ControlMouseUp(object sender, MouseEventArgs e)
        {
            _bMoving = false;
            switch (e.Button)
            {
                case MouseButtons.Right:
                    _rightClickMenu.Show(this, e.Location);
                    break;
            }
        }

        private void ControlMouseMove(object sender, MouseEventArgs e)
        {
            //if not being moved or left mouse button not used, exit
            if (!_bMoving || e.Button != MouseButtons.Left)
            {
                return;
            }
            //get control reference
            _ctrlMoved = (Control) sender;
            //set control's position based upon mouse's position change
            _ctrlMoved.Left += e.X - _pointMouse.X;
            _ctrlMoved.Top += e.Y - _pointMouse.Y;
        }
    }
}