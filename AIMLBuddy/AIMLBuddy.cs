using System;
using System.Collections.Generic;
using System.Linq;
using AIMLbot;
using Styx;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;

namespace AIMLBuddy
{
    public class AIMLBuddy : HBPlugin
    {
        private bool _firstPulse = true;
        private Bot _aimlBot;
        private List<User> _userList;
        private List<Response> _responseList;
        private TimeSpan _waitTime = new TimeSpan(0,0,0,3);

        private DateTime _lastRecieved;
        private DateTime _lastSent;

        public override void Pulse()
        {
            if (_firstPulse)
            {
                WoWChat.Whisper += WoWChatWhisper;
                _aimlBot = new Bot();
                _aimlBot.loadSettings();
                _aimlBot.loadAIMLFromFiles();
                _userList = new List<User>();
                _responseList = new List<Response>();
                _lastRecieved = DateTime.Now;
                _lastSent = DateTime.Now;
                
                _firstPulse = false;
            }

            if (StyxWoW.Me == null || !StyxWoW.Me.IsAlive || !StyxWoW.IsInGame || !StyxWoW.IsInWorld) return;

            if (_responseList.Count <= 0) return;
            
            _waitTime = new TimeSpan(0, 0, 0, (int)Math.Round((_responseList.First().Message.Length * 0.22)));

            if (DateTime.Now.Subtract(_lastSent) >= _waitTime && DateTime.Now.Subtract(_lastRecieved) >= _waitTime)
            {
                Send(_responseList.First());
            }
        }


        private void Send(Response response)
        {
            Lua.DoString(String.Format("SendChatMessage(\"{0}\", \"WHISPER\", nil, \"{1}\");", response.Message,
                                           response.User));
            _lastSent = DateTime.Now;
            _responseList.Remove(response);
        }

        private void WoWChatWhisper(WoWChat.ChatWhisperEventArgs e)
        {
            var user = _userList.Find(o => o.UserID == e.Author);

            if (user == null)
            {
                user = new User(e.Author, _aimlBot);
                _userList.Add(user);
            }

            _aimlBot.GlobalSettings.updateSetting("location", StyxWoW.Me.ZoneText); //Update Zone Info BEFORE creating Response

            var result = new Result(user, _aimlBot, new Request(e.Message, user, _aimlBot));

            var response = new Response(user.UserID, result.Output);

            if (!_responseList.Contains(response))
            {
                _responseList.Add(response);
            }

            _lastRecieved = DateTime.Now;
        }

        public override string Name { get { return "AIMLBuddy"; } }
        public override string Author { get { return "Smarter"; } }
        public override Version Version { get { return new Version(0,3,0,0); }}
    }

    public class Response
    {
        public string User { get; private set; }
        public string Message { get; private set; }

        public Response(string user, string message)
        {
            User = user;
            Message = message;
        }
    }
}
