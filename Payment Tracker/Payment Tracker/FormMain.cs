using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.Xml.Linq;
using Payment_Tracker.Properties;

namespace Payment_Tracker
{
    public partial class FormMain : Form
    {
        private readonly List<Payment> _payments = new List<Payment>();
        private double _blueMoney = 0;
        private double _greenMoney = 0;

        public FormMain()
        {
            InitializeComponent();
            var xmlDoc = XDocument.Load(Application.StartupPath + "\\Payments.xml");
            foreach (var pay in xmlDoc.Descendants("Payments"))
            {
                var xElement = pay.Element("Type");
                if (xElement != null)
                {
                    switch (xElement.Value)
                    {
                        case "Green":

                            break;
                        case "Blue":

                            break;
                    }
                }
            }
        }

        private void RefreshNumbers()
        {
            var blue = _payments.Where(o => o.Type == PaymentType.Blue);
            var green = _payments.Where(o => o.Type == PaymentType.Green);

            _blueMoney += blue.Sum(payment => payment.Amount);
            _greenMoney += green.Sum(payment => payment.Amount);

            lblBlueMoney.Text = Resources.FormMain_RefreshNumbers_Money + Math.Round(_blueMoney, 2);
            lblGreenMoney.Text = Resources.FormMain_RefreshNumbers_Money + Math.Round(_greenMoney, 2);

            lstLog.Items.Clear();
            foreach (var payment in _payments)
            {
                lstLog.Items.Add(string.Format("File: {0} - Date: {1} - Type: {2} - Amount: {3}", payment.FileName,
                                               payment.Date.ToShortDateString(), payment.Type,
                                               payment.Amount));
            }

        }

        private void OutputToFile()
        {
            //Record Payment to File
            //Load XDocument
            var xmlDoc = XDocument.Load(Application.StartupPath + "\\Payments.xml");
            var xElement = xmlDoc.Element("Payments");

            if (xElement != null)
            {
                foreach (var payment in _payments)
                {
                    xElement.Add(
                        new XElement("Payment",
                                     new XElement("FileName", payment.FileName),
                                     new XElement("Date", payment.Date),
                                     new XElement("Type", payment.Type),
                                     new XElement("Amount", payment.Amount)));
                }
            }
            xmlDoc.Save(Application.StartupPath + "\\Payments.xml");
            //DONE!
        }

        private void BtnRecordClick(object sender, EventArgs e)
        {
            _payments.Add(new Payment(cmbType.Text, textFile.Text, dtpDate.Value, Convert.ToDouble(textAmount.Text)));
            textAmount.Clear();
            textFile.Clear();
            dtpDate.Value = DateTime.Now;
            cmbType.Text = "";
            MessageBox.Show(Resources.FormMain_BtnRecordClick_Added);
            RefreshNumbers();
        }

        private void FormMainFormClosing(object sender, FormClosingEventArgs e)
        {
            OutputToFile();
        }
    }


    public class Payment
    {
        public Payment(string type, string fileName, DateTime date, double amount)
        {
            FileName = fileName;
            switch (type)
            {
                case "Green":
                    Type = PaymentType.Green;
                    break;
                case "Blue":
                    Type = PaymentType.Blue;
                    break;
            }
            Date = date;
            Amount = amount;
        }

        public Payment()
        {
        }

        public double Amount { get; set; }
        public DateTime Date { get; set; }
        public PaymentType Type { get; set; }
        public string FileName { get; set; }
    }

    public enum PaymentType
    {
        Green,
        Blue
    }
}
