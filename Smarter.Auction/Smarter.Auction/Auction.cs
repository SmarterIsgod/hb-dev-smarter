using System;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Windows.Forms;
using Styx;
using Styx.Helpers;
using Styx.Logic.Inventory.Frames;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;
using TreeSharp;
using Action=TreeSharp.Action;
using Mail = Styx.Logic.Inventory.Frames.MailBox.MailFrame;
using Nav = Styx.Logic.Pathing.Navigator;
using WoW = Styx.StyxWoW;

namespace Smarter.Auction
{
    public class Auction : BotBase
    {
        private readonly WaitTimer _mailIdle = new WaitTimer(new TimeSpan(0,0,5,0));

        public override string Name { get { return string.Format("Smarter's Auction Bot v{0}", new Version(0, 0, 1, 0)); } }

        private Composite _root;
        public override Composite Root
        {
            /* Design Plan:
             * Check for new Mail every 5 minutes
             * If new Mail, Go to Mailbox
             * Retrieve New Mail
             * Go to Auction House
             * Auction off Goods
             * Go to Guild Bank
             * Deposit X Gold
             * -- Repeat --
             */
            get
            {
                return _root ?? (_root =
                                 new PrioritySelector(

                                     new Decorator (ret => WoW.Me.IsMoving,
                                         new Action(delegate { return RunStatus.Success;})),

                                     new Decorator(ret => NeedMailbox && CanGetMail(),
                                         new Action(ret => GetAllMail())),
                                         
                                     new Decorator(ret => CanAuction(),
                                         new Action(ret => AuctioneerInteract())),

                                     new Decorator(ret => NeedMailbox,
                                         new Action(ret => GoToMailbox())),
                                         
                                     new Decorator(ret => NeedAuction(),
                                         new Action(ret => GoToAuctionHouse()))
                                        
                                        ));
            }
        }

        #region Logic
        private static bool CanAuction()
        {
             return Auctioneer.WithinInteractRange/* && WoW.Me.BagItems.Count > 3*/;
        }

        private static bool CanGetMail()
        {
            return Mailbox.Distance <= Mailbox.InteractRange && !WoW.Me.BagsFull;
        }

        private static bool NeedAuction()
        {
            return WoW.Me.BagItems.Count > 3;
        }
        
        private static bool NeedMailbox
        {
            get
            {
                return Mail.Instance.HasNewMail && !WoW.Me.BagsFull;
            }
        }
        #endregion

        #region Objects
        private static WoWUnit _auctioneer; 
        public static WoWUnit Auctioneer
        {
            get
            {
                return _auctioneer ?? (ObjectManager.GetObjectsOfType<WoWUnit>().FindAll(o => o.IsAuctioneer).OrderBy(
                                          o => o.Distance).FirstOrDefault());
            }
        }
        

        private static WoWGameObject _mailBox;
        private static WoWGameObject Mailbox
        {
            get
            {
                return _mailBox ??
                       (_mailBox = ObjectManager.GetObjectsOfType<WoWGameObject>().FindAll(o => o.Name == "Mailbox").OrderBy(
                           o => o.Distance).FirstOrDefault());
            }
        }
        #endregion

        #region Functions

        private static void AuctioneerInteract()
        {
            Logging.Write(Color.Blue, "AuctioneerInteract() Called");
            if (Auctioneer != null)
            {
                if (Auctioneer.WithinInteractRange)
                {
                    Auctioneer.Interact();
                    Logging.Write(Color.Goldenrod, "Interacting with Auctioneer");
                    var auctionFrame = new Frame("AuctionFrame");
                    if (auctionFrame.IsVisible)
                    {
                        Logging.Write(Color.GreenYellow, "Auction Frame Visible");
                        /* AuctionFrameTab5:Click()
                         * Drag Item to: Atr_SellControls_Tex
                         * Atr_CreateAuctionButton:Click()
                         */
                        Lua.DoString("AuctionFrameTab5:Click()");
                        Logging.Write(Color.Goldenrod, "Switching to Sell Tab");
                        Logging.Write(Color.Teal, "Clicking Item");
                        WoWItem item = StyxWoW.Me.BagItems.FindAll(o => o.Name == "Frostweave Cloth").FirstOrDefault();
                        Lua.DoString("PickupContainerItem(" + (item.BagIndex + 1) + ", " + (item.BagSlot + 1) + ")");
                        Lua.DoString("Atr_SellControls_Tex:Click()");
                        Logging.Write(Color.Tomato, "Clicking Sell Button");

                        //if (Lua.GetReturnVal<int>("Atr_CreateAuctionButton:IsEnabled()", 0) == 1)
                        //{
                        //    StyxWoW.ResetAfk();
                        //    Lua.DoString("Atr_CreateAuctionButton:Click()");
                        //}
                        //else
                        //{
                        //    Thread.Sleep(15000);
                        //    StyxWoW.ResetAfk();
                        //    Lua.DoString("Atr_CreateAuctionButton:Click()");
                        //}
                    }
                    // Do Auctioning
                }
            }
        }

        private static void GoToAuctionHouse()
        {
            Logging.Write(Color.Blue, "GoToAuctionHouse() Called");
            if (Auctioneer != null)
            {
                Nav.MoveTo(Auctioneer.Location);
            }
            else
            {
                Logging.Write(Color.Red, "Cannot locate an Auctioneer!");
            }
        }

        private void GetAllMail()
        {
            Logging.Write(Color.Blue, "GetAllMail() Called");
            if (_mailIdle.IsFinished)
            {
                Logging.Write(Color.Blue, "Mail Idle has Finished, Getting Mail!");
                if (!Mailbox.WithinInteractRange) return;
                Mailbox.Interact(); 
                Logging.Write(Color.Blue, "Opening Mailbox");
                Lua.DoString("PostalOpenAllButton:Click()");
                Logging.Write(Color.Blue, "Retrieving Mail");
                _mailIdle.Reset();
            }
            else
            {
                Logging.Write(Color.Blue, "Mail Idle has not Finished, skipping mail retrevial.");
            }
        }

        
        private static void GoToMailbox()
        {
            Logging.Write(Color.Blue, "GoToMailbox() Called");
            if (Mailbox != null)
            {
                Nav.MoveTo(Mailbox.Location);
            }
            else
            {
                Logging.Write(Color.Red, "Cannot locate a Mailbox!");
            }
        }
        #endregion


        #region Default Stuff
        public override PulseFlags PulseFlags { get { return PulseFlags.All; } }

        public override Form ConfigurationForm
        {
            get
            {
                return new Form();
            }
        }

        public override void Initialize()
        {
            
        }

        public override void Pulse()
        {
            //if (_mailIdle.IsFinished)
            //{
            //    Logging.Write(Color.Blue, "HasNewMail Pulsed");
            //    HasMail = Mail.Instance.HasNewMail;
            //    _mailIdle.Reset();
            //}
            //Do Shit;
        }
        public override void Start()
        {
            _mailIdle.Stop();
            //Do Shit;
        }
        public override void Stop()
        {
            //Do Shit;
        }
        #endregion
    }
}
