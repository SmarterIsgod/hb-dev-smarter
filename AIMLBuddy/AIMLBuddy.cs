using System;
using System.Collections.Generic;
using System.Linq;
using AIMLbot;
using Styx;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;

namespace AIMLBuddy
{
    public class Response
    {
        public readonly string Message;
        public readonly string User;

        public Response(string userName, string message)
        {
            User = userName;
            Message = message;
        }
    }

    public class AimlBuddy : HBPlugin
    {
        private Bot _aimlBot;
        private DateTime _lastRecieved;
        private DateTime _lastSent;
        private List<Response> _responseList;
        private List<User> _userList;
        private TimeSpan _waitTime = new TimeSpan(0, 0, 0, 3);

        public override string Name
        {
            get { return "AIMLBuddy"; }
        }

        public override string Author
        {
            get { return "Smarter"; }
        }

        public override Version Version
        {
            get { return new Version(0, 0, 2, 0); }
        }


        public override void Initialize()
        {
            WoWChat.Whisper += WoWChatWhisper;
            _aimlBot = new Bot();
            _aimlBot.loadSettings();
            _aimlBot.loadAIMLFromFiles();
            _userList = new List<User>();
            _responseList = new List<Response>();
        }

        private void WoWChatWhisper(WoWChat.ChatWhisperEventArgs e)
        {
            User user = _userList.Find(o => o.UserID == e.Author);
            if (user == null)
            {
                user = new User(e.Author, _aimlBot);
                _userList.Add(user);
            }

            Result result = _aimlBot.Chat(new Request(e.Message, user, _aimlBot));

            var response = new Response(user.UserID, result.Output);

            if (!_responseList.Contains(response))
            {
                _responseList.Add(response);
            }

            _lastRecieved = DateTime.Now;
        }

        private void TrySend(Response response)
        {
            if (DateTime.Now.Subtract(_lastSent) >= _waitTime && DateTime.Now.Subtract(_lastRecieved) >= _waitTime)
            {
                Lua.DoString(String.Format("SendChatMessage(\"{0}\", \"WHISPER\", nil, \"{1}\");", response.Message,
                                           response.User));
                _lastSent = DateTime.Now;
                _responseList.Remove(response);
            }
        }

        public override void Pulse()
        {
            if (StyxWoW.Me == null || !StyxWoW.Me.IsAlive || !StyxWoW.IsInGame || !StyxWoW.IsInWorld) return;


            if (_responseList.Count > 0)
            {
                _waitTime = new TimeSpan(0, 0, 0, (int) Math.Round((_responseList[0].Message.Length*0.22)));
                TrySend(_responseList.First());
                _aimlBot.GlobalSettings.updateSetting("location", StyxWoW.Me.ZoneText);
            }
        }
    }
}