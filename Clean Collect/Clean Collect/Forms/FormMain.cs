using System.Windows.Forms;
using Clean_Collect.User_Controls;

namespace Clean_Collect.Forms
{
    public partial class FormMain : Form
    {
        public FormMain()
        {
            InitializeComponent();
            tabPage1.Controls.Add(new UserControlDebtorGeneral());
            tabPage1.Controls.Add(new UserControlDebtorEmployment());
            tabPage1.Controls.Add(new UserControlDebtorPhone());
            tabPage1.Controls.Add(new UserControlDebtorIdentification());
            tabPage1.Controls.Add(new UserControlDebtorAddress());


            //Method for Auto Fitting User Controls ... NEEDS WORK
            //var previous = new UserControl();
            //for (var i = 0; i < tabPage1.Controls.Count; i++)
            //{
            //    var control = tabPage1.Controls[i];
            //    if (i <= 0) continue;
            //    control.Location = new Point((int)(previous.Location.X + previous.Width*1.56));
            //    previous.Location = control.Location;
            //}
        }
    }
}