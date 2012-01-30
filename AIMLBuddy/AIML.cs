using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using AIMLbot.AIMLTagHandlers;
using AIMLbot.Normalize;
using AIMLbot.Utils;
using Styx.Helpers;

#region Nicholas H.Tollervey's AIMLBot

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// An element called bot, which may be considered a restricted version of get, is used to
    /// tell the AIML interpreter that it should substitute the contents of a "bot predicate". The
    /// value of a bot predicate is set at load-time, and cannot be changed at run-time. The AIML
    /// interpreter may decide how to set the values of bot predicate at load-time. If the bot
    /// predicate has no value defined, the AIML interpreter should substitute an empty string.
    ///
    /// The bot element has a required name attribute that identifies the bot predicate.
    ///
    /// The bot element does not have any content.
    /// </summary>
    public class bot : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public bot(Bot bot,
                   User user,
                   SubQuery query,
                   Request request,
                   Result result,
                   XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "bot")
            {
                if (templateNode.Attributes.Count == 1)
                {
                    if (templateNode.Attributes[0].Name.ToLower() == "name")
                    {
                        string key = templateNode.Attributes["name"].Value;
                        return bot.GlobalSettings.grabSetting(key);
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The condition element instructs the AIML interpreter to return specified contents depending
    /// upon the results of matching a predicate against a pattern.
    ///
    /// NB: The condition element has three different types. The three different types specified
    /// here are distinguished by an xsi:type attribute, which permits a validating XML Schema
    /// processor to validate them. Two of the types may contain li elements, of which there are
    /// three different types, whose validity is determined by the type of enclosing condition. In
    /// practice, an AIML interpreter may allow the omission of the xsi:type attribute and may instead
    /// heuristically determine which type of condition (and hence li) is in use.
    ///
    /// Block Condition
    /// ---------------
    ///
    /// The blockCondition type of condition has a required attribute "name", which specifies an AIML
    /// predicate, and a required attribute "value", which contains a simple pattern expression.
    ///
    /// If the contents of the value attribute match the value of the predicate specified by name, then
    /// the AIML interpreter should return the contents of the condition. If not, the empty string ""
    /// should be returned.
    ///
    /// Single-predicate Condition
    /// --------------------------
    ///
    /// The singlePredicateCondition type of condition has a required attribute "name", which specifies
    /// an AIML predicate. This form of condition must contain at least one li element. Zero or more of
    /// these li elements may be of the valueOnlyListItem type. Zero or one of these li elements may be
    /// of the defaultListItem type.
    ///
    /// The singlePredicateCondition type of condition is processed as follows:
    ///
    /// Reading each contained li in order:
    ///
    /// 1. If the li is a valueOnlyListItem type, then compare the contents of the value attribute of
    /// the li with the value of the predicate specified by the name attribute of the enclosing
    /// condition.
    ///     a. If they match, then return the contents of the li and stop processing this condition.
    ///     b. If they do not match, continue processing the condition.
    /// 2. If the li is a defaultListItem type, then return the contents of the li and stop processing
    /// this condition.
    ///
    /// Multi-predicate Condition
    /// -------------------------
    ///
    /// The multiPredicateCondition type of condition has no attributes. This form of condition must
    /// contain at least one li element. Zero or more of these li elements may be of the
    /// nameValueListItem type. Zero or one of these li elements may be of the defaultListItem type.
    ///
    /// The multiPredicateCondition type of condition is processed as follows:
    ///
    /// Reading each contained li in order:
    ///
    /// 1. If the li is a nameValueListItem type, then compare the contents of the value attribute of
    /// the li with the value of the predicate specified by the name attribute of the li.
    ///     a. If they match, then return the contents of the li and stop processing this condition.
    ///     b. If they do not match, continue processing the condition.
    /// 2. If the li is a defaultListItem type, then return the contents of the li and stop processing
    /// this condition.
    ///
    /// ****************
    ///
    /// Condition List Items
    ///
    /// As described above, two types of condition may contain li elements. There are three types of
    /// li elements. The type of li element allowed in a given condition depends upon the type of that
    /// condition, as described above.
    ///
    /// Default List Items
    /// ------------------
    ///
    /// An li element of the type defaultListItem has no attributes. It may contain any AIML template
    /// elements.
    ///
    /// Value-only List Items
    /// ---------------------
    ///
    /// An li element of the type valueOnlyListItem has a required attribute value, which must contain
    /// a simple pattern expression. The element may contain any AIML template elements.
    ///
    /// Name and Value List Items
    /// -------------------------
    ///
    /// An li element of the type nameValueListItem has a required attribute name, which specifies an
    /// AIML predicate, and a required attribute value, which contains a simple pattern expression. The
    /// element may contain any AIML template elements.
    /// </summary>
    public class condition : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public condition(Bot bot,
                         User user,
                         SubQuery query,
                         Request request,
                         Result result,
                         XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
            isRecursive = false;
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "condition")
            {
                // heuristically work out the type of condition being processed
                if (templateNode.Attributes.Count == 2) // block
                {
                    string name = "";
                    string value = "";
                    if (templateNode.Attributes[0].Name == "name")
                    {
                        name = templateNode.Attributes[0].Value;
                    }
                    else if (templateNode.Attributes[0].Name == "value")
                    {
                        value = templateNode.Attributes[0].Value;
                    }
                    if (templateNode.Attributes[1].Name == "name")
                    {
                        name = templateNode.Attributes[1].Value;
                    }
                    else if (templateNode.Attributes[1].Name == "value")
                    {
                        value = templateNode.Attributes[1].Value;
                    }
                    if ((name.Length > 0) & (value.Length > 0))
                    {
                        string actualValue = user.Predicates.grabSetting(name);
                        var matcher = new Regex(value.Replace(" ", "\\s").Replace("*", "[\\sA-Z0-9]+"),
                                                RegexOptions.IgnoreCase);
                        if (matcher.IsMatch(actualValue))
                        {
                            return templateNode.InnerXml;
                        }
                    }
                }
                else if (templateNode.Attributes.Count == 1) // single predicate
                {
                    if (templateNode.Attributes[0].Name == "name")
                    {
                        string name = templateNode.Attributes[0].Value;
                        foreach (XmlNode childLINode in templateNode.ChildNodes)
                        {
                            if (childLINode.Name.ToLower() == "li")
                            {
                                if (childLINode.Attributes.Count == 1)
                                {
                                    if (childLINode.Attributes[0].Name.ToLower() == "value")
                                    {
                                        string actualValue = user.Predicates.grabSetting(name);
                                        var matcher =
                                            new Regex(
                                                childLINode.Attributes[0].Value.Replace(" ", "\\s").Replace("*",
                                                                                                            "[\\sA-Z0-9]+"),
                                                RegexOptions.IgnoreCase);
                                        if (matcher.IsMatch(actualValue))
                                        {
                                            return childLINode.InnerXml;
                                        }
                                    }
                                }
                                else if (childLINode.Attributes.Count == 0)
                                {
                                    return childLINode.InnerXml;
                                }
                            }
                        }
                    }
                }
                else if (templateNode.Attributes.Count == 0) // multi-predicate
                {
                    foreach (XmlNode childLINode in templateNode.ChildNodes)
                    {
                        if (childLINode.Name.ToLower() == "li")
                        {
                            if (childLINode.Attributes.Count == 2)
                            {
                                string name = "";
                                string value = "";
                                if (childLINode.Attributes[0].Name == "name")
                                {
                                    name = childLINode.Attributes[0].Value;
                                }
                                else if (childLINode.Attributes[0].Name == "value")
                                {
                                    value = childLINode.Attributes[0].Value;
                                }
                                if (childLINode.Attributes[1].Name == "name")
                                {
                                    name = childLINode.Attributes[1].Value;
                                }
                                else if (childLINode.Attributes[1].Name == "value")
                                {
                                    value = childLINode.Attributes[1].Value;
                                }
                                if ((name.Length > 0) & (value.Length > 0))
                                {
                                    string actualValue = user.Predicates.grabSetting(name);
                                    var matcher = new Regex(value.Replace(" ", "\\s").Replace("*", "[\\sA-Z0-9]+"),
                                                            RegexOptions.IgnoreCase);
                                    if (matcher.IsMatch(actualValue))
                                    {
                                        return childLINode.InnerXml;
                                    }
                                }
                            }
                            else if (childLINode.Attributes.Count == 0)
                            {
                                return childLINode.InnerXml;
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The date element tells the AIML interpreter that it should substitute the system local
    /// date and time. No formatting constraints on the output are specified.
    ///
    /// The date element does not have any content.
    /// </summary>
    public class date : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public date(Bot bot,
                    User user,
                    SubQuery query,
                    Request request,
                    Result result,
                    XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "date")
            {
                return DateTime.Now.ToString(bot.Locale);
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The formal element tells the AIML interpreter to render the contents of the element
    /// such that the first letter of each word is in uppercase, as defined (if defined) by
    /// the locale indicated by the specified language (if specified). This is similar to methods
    /// that are sometimes called "Title Case".
    ///
    /// If no character in this string has a different uppercase version, based on the Unicode
    /// standard, then the original string is returned.
    /// </summary>
    public class formal : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public formal(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "formal")
            {
                var result = new StringBuilder();
                if (templateNode.InnerText.Length > 0)
                {
                    string[] words = templateNode.InnerText.ToLower().Split();
                    foreach (string word in words)
                    {
                        string newWord = word.Substring(0, 1);
                        newWord = newWord.ToUpper();
                        if (word.Length > 1)
                        {
                            newWord += word.Substring(1);
                        }
                        result.Append(newWord + " ");
                    }
                }
                return result.ToString().Trim();
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The atomic version of the gender element is a shortcut for:
    ///
    /// <gender><star/></gender>
    ///
    /// The atomic gender does not have any content.
    ///
    /// The non-atomic gender element instructs the AIML interpreter to:
    ///
    /// 1. replace male-gendered words in the result of processing the contents of the gender element
    /// with the grammatically-corresponding female-gendered words; and
    ///
    /// 2. replace female-gendered words in the result of processing the contents of the gender element
    /// with the grammatically-corresponding male-gendered words.
    ///
    /// The definition of "grammatically-corresponding" is left up to the implementation.
    ///
    /// Historically, implementations of gender have exclusively dealt with pronouns, likely due to the
    /// fact that most AIML has been written in English. However, the decision about whether to
    /// transform gender of other words is left up to the implementation.
    /// </summary>
    public class gender : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public gender(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "gender")
            {
                if (templateNode.InnerText.Length > 0)
                {
                    // non atomic version of the node
                    return ApplySubstitutions.Substitute(bot, bot.GenderSubstitutions, templateNode.InnerText);
                }
                else
                {
                    // atomic version of the node
                    XmlNode starNode = getNode("<star/>");
                    var recursiveStar = new star(bot, user, query, request, result, starNode);
                    templateNode.InnerText = recursiveStar.Transform();
                    if (templateNode.InnerText.Length > 0)
                    {
                        return ProcessChange();
                    }
                    else
                    {
                        return string.Empty;
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The get element tells the AIML interpreter that it should substitute the contents of a
    /// predicate, if that predicate has a value defined. If the predicate has no value defined,
    /// the AIML interpreter should substitute the empty string "".
    ///
    /// The AIML interpreter implementation may optionally provide a mechanism that allows the
    /// AIML author to designate default values for certain predicates (see [9.3.]).
    ///
    /// The get element must not perform any text formatting or other "normalization" on the predicate
    /// contents when returning them.
    ///
    /// The get element has a required name attribute that identifies the predicate with an AIML
    /// predicate name.
    ///
    /// The get element does not have any content.
    /// </summary>
    public class get : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public get(Bot bot,
                   User user,
                   SubQuery query,
                   Request request,
                   Result result,
                   XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "get")
            {
                if (bot.GlobalSettings.Count > 0)
                {
                    if (templateNode.Attributes.Count == 1)
                    {
                        if (templateNode.Attributes[0].Name.ToLower() == "name")
                        {
                            return user.Predicates.grabSetting(templateNode.Attributes[0].Value);
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The gossip element instructs the AIML interpreter to capture the result of processing the
    /// contents of the gossip elements and to store these contents in a manner left up to the
    /// implementation. Most common uses of gossip have been to store captured contents in a separate
    /// file.
    ///
    /// The gossip element does not have any attributes. It may contain any AIML template elements.
    /// </summary>
    public class gossip : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public gossip(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The id element tells the AIML interpreter that it should substitute the user ID.
    /// The determination of the user ID is not specified, since it will vary by application.
    /// A suggested default return value is "localhost".
    ///
    /// The id element does not have any content.
    /// </summary>
    public class id : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public id(Bot bot,
                  User user,
                  SubQuery query,
                  Request request,
                  Result result,
                  XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "id")
            {
                return user.UserID;
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The input element tells the AIML interpreter that it should substitute the contents of a
    /// previous user input.
    ///
    /// The template-side input has an optional index attribute that may contain either a single
    /// integer or a comma-separated pair of integers. The minimum value for either of the integers
    /// in the index is "1". The index tells the AIML interpreter which previous user input should
    /// be returned (first dimension), and optionally which "sentence" (see [8.3.2.]) of the previous
    /// user input.
    ///
    /// The AIML interpreter should raise an error if either of the specified index dimensions is
    /// invalid at run-time.
    ///
    /// An unspecified index is the equivalent of "1,1". An unspecified second dimension of the index
    /// is the equivalent of specifying a "1" for the second dimension.
    ///
    /// The input element does not have any content.
    /// </summary>
    public class input : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public input(Bot bot,
                     User user,
                     SubQuery query,
                     Request request,
                     Result result,
                     XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "input")
            {
                if (templateNode.Attributes.Count == 0)
                {
                    return user.getResultSentence();
                }
                else if (templateNode.Attributes.Count == 1)
                {
                    if (templateNode.Attributes[0].Name.ToLower() == "index")
                    {
                        if (templateNode.Attributes[0].Value.Length > 0)
                        {
                            try
                            {
                                // see if there is a split
                                string[] dimensions = templateNode.Attributes[0].Value.Split(",".ToCharArray());
                                if (dimensions.Length == 2)
                                {
                                    int result = Convert.ToInt32(dimensions[0].Trim());
                                    int sentence = Convert.ToInt32(dimensions[1].Trim());
                                    if ((result > 0) & (sentence > 0))
                                    {
                                        return user.getResultSentence(result - 1, sentence - 1);
                                    }
                                }
                                else
                                {
                                    int result = Convert.ToInt32(templateNode.Attributes[0].Value.Trim());
                                    if (result > 0)
                                    {
                                        return user.getResultSentence(result - 1);
                                    }
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// NOT IMPLEMENTED FOR SECURITY REASONS
    /// </summary>
    public class javascript : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public javascript(Bot bot,
                          User user,
                          SubQuery query,
                          Request request,
                          Result result,
                          XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The learn element instructs the AIML interpreter to retrieve a resource specified by a URI,
    /// and to process its AIML object contents.
    /// </summary>
    public class learn : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public learn(Bot bot,
                     User user,
                     SubQuery query,
                     Request request,
                     Result result,
                     XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "learn")
            {
                // currently only AIML files in the local filesystem can be referenced
                // ToDo: Network HTTP and web service based learning
                if (templateNode.InnerText.Length > 0)
                {
                    string path = templateNode.InnerText;
                    var fi = new FileInfo(path);
                    if (fi.Exists)
                    {
                        var doc = new XmlDocument();
                        try
                        {
                            doc.Load(path);
                            bot.loadAIMLFromXML(doc, path);
                        }
                        catch
                        {
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The lowercase element tells the AIML interpreter to render the contents of the element
    /// in lowercase, as defined (if defined) by the locale indicated by the specified language
    /// (if specified).
    ///
    /// If no character in this string has a different lowercase version, based on the Unicode
    /// standard, then the original string is returned.
    /// </summary>
    public class lowercase : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public lowercase(Bot bot,
                         User user,
                         SubQuery query,
                         Request request,
                         Result result,
                         XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "lowercase")
            {
                return templateNode.InnerText.ToLower(bot.Locale);
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The atomic version of the person element is a shortcut for:
    ///
    /// <person><star/></person>
    ///
    /// The atomic person does not have any content.
    ///
    /// The non-atomic person element instructs the AIML interpreter to:
    ///
    /// 1. replace words with first-person aspect in the result of processing the contents of the
    /// person element with words with the grammatically-corresponding third-person aspect; and
    ///
    /// 2. replace words with third-person aspect in the result of processing the contents of the
    /// person element with words with the grammatically-corresponding first-person aspect.
    ///
    /// The definition of "grammatically-corresponding" is left up to the implementation.
    ///
    /// Historically, implementations of person have dealt with pronouns, likely due to the fact that
    /// most AIML has been written in English. However, the decision about whether to transform the
    /// person aspect of other words is left up to the implementation.
    /// </summary>
    public class person : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public person(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "person")
            {
                if (templateNode.InnerText.Length > 0)
                {
                    // non atomic version of the node
                    return ApplySubstitutions.Substitute(bot, bot.PersonSubstitutions, templateNode.InnerText);
                }
                else
                {
                    // atomic version of the node
                    XmlNode starNode = getNode("<star/>");
                    var recursiveStar = new star(bot, user, query, request, result, starNode);
                    templateNode.InnerText = recursiveStar.Transform();
                    if (templateNode.InnerText.Length > 0)
                    {
                        return ProcessChange();
                    }
                    else
                    {
                        return string.Empty;
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The atomic version of the person2 element is a shortcut for:
    ///
    /// <person2><star/></person2>
    ///
    /// The atomic person2 does not have any content.
    ///
    /// The non-atomic person2 element instructs the AIML interpreter to:
    ///
    /// 1. replace words with first-person aspect in the result of processing the contents of the
    /// person2 element with words with the grammatically-corresponding second-person aspect; and,
    ///
    /// 2. replace words with second-person aspect in the result of processing the contents of the
    /// person2 element with words with the grammatically-corresponding first-person aspect.
    ///
    /// The definition of "grammatically-corresponding" is left up to the implementation.
    ///
    /// Historically, implementations of person2 have dealt with pronouns, likely due to the fact
    /// that most AIML has been written in English. However, the decision about whether to transform
    /// the person aspect of other words is left up to the implementation.
    /// </summary>
    public class person2 : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public person2(Bot bot,
                       User user,
                       SubQuery query,
                       Request request,
                       Result result,
                       XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "person2")
            {
                if (templateNode.InnerText.Length > 0)
                {
                    // non atomic version of the node
                    return ApplySubstitutions.Substitute(bot, bot.Person2Substitutions, templateNode.InnerText);
                }
                else
                {
                    // atomic version of the node
                    XmlNode starNode = getNode("<star/>");
                    var recursiveStar = new star(bot, user, query, request, result, starNode);
                    templateNode.InnerText = recursiveStar.Transform();
                    if (templateNode.InnerText.Length > 0)
                    {
                        return ProcessChange();
                    }
                    else
                    {
                        return string.Empty;
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The random element instructs the AIML interpreter to return exactly one of its contained li
    /// elements randomly. The random element must contain one or more li elements of type
    /// defaultListItem, and cannot contain any other elements.
    /// </summary>
    public class random : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public random(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
            isRecursive = false;
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "random")
            {
                if (templateNode.HasChildNodes)
                {
                    // only grab <li> nodes
                    var listNodes = new List<XmlNode>();
                    foreach (XmlNode childNode in templateNode.ChildNodes)
                    {
                        if (childNode.Name == "li")
                        {
                            listNodes.Add(childNode);
                        }
                    }
                    if (listNodes.Count > 0)
                    {
                        var r = new Random();
                        XmlNode chosenNode = listNodes[r.Next(listNodes.Count)];
                        return chosenNode.InnerXml;
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The sentence element tells the AIML interpreter to render the contents of the element
    /// such that the first letter of each sentence is in uppercase, as defined (if defined) by
    /// the locale indicated by the specified language (if specified). Sentences are interpreted
    /// as strings whose last character is the period or full-stop character .. If the string does
    /// not contain a ., then the entire string is treated as a sentence.
    ///
    /// If no character in this string has a different uppercase version, based on the Unicode
    /// standard, then the original string is returned.
    /// </summary>
    public class sentence : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public sentence(Bot bot,
                        User user,
                        SubQuery query,
                        Request request,
                        Result result,
                        XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "sentence")
            {
                if (templateNode.InnerText.Length > 0)
                {
                    var result = new StringBuilder();
                    char[] letters = templateNode.InnerText.Trim().ToCharArray();
                    bool doChange = true;
                    for (int i = 0; i < letters.Length; i++)
                    {
                        string letterAsString = Convert.ToString(letters[i]);
                        if (bot.Splitters.Contains(letterAsString))
                        {
                            doChange = true;
                        }
                        var lowercaseLetter = new Regex("[a-zA-Z]");
                        if (lowercaseLetter.IsMatch(letterAsString))
                        {
                            if (doChange)
                            {
                                result.Append(letterAsString.ToUpper(bot.Locale));
                                doChange = false;
                            }
                            else
                            {
                                result.Append(letterAsString.ToLower(bot.Locale));
                            }
                        }
                        else
                        {
                            result.Append(letterAsString);
                        }
                    }
                    return result.ToString();
                }
                else
                {
                    // atomic version of the node
                    XmlNode starNode = getNode("<star/>");
                    var recursiveStar = new star(bot, user, query, request, result, starNode);
                    templateNode.InnerText = recursiveStar.Transform();
                    if (templateNode.InnerText.Length > 0)
                    {
                        return ProcessChange();
                    }
                    else
                    {
                        return string.Empty;
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The set element instructs the AIML interpreter to set the value of a predicate to the result
    /// of processing the contents of the set element. The set element has a required attribute name,
    /// which must be a valid AIML predicate name. If the predicate has not yet been defined, the AIML
    /// interpreter should define it in memory.
    ///
    /// The AIML interpreter should, generically, return the result of processing the contents of the
    /// set element. The set element must not perform any text formatting or other "normalization" on
    /// the predicate contents when returning them.
    ///
    /// The AIML interpreter implementation may optionally provide a mechanism that allows the AIML
    /// author to designate certain predicates as "return-name-when-set", which means that a set
    /// operation using such a predicate will return the name of the predicate, rather than its
    /// captured value. (See [9.2].)
    ///
    /// A set element may contain any AIML template elements.
    /// </summary>
    public class set : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public set(Bot bot,
                   User user,
                   SubQuery query,
                   Request request,
                   Result result,
                   XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "set")
            {
                if (bot.GlobalSettings.Count > 0)
                {
                    if (templateNode.Attributes.Count == 1)
                    {
                        if (templateNode.Attributes[0].Name.ToLower() == "name")
                        {
                            if (templateNode.InnerText.Length > 0)
                            {
                                user.Predicates.addSetting(templateNode.Attributes[0].Value, templateNode.InnerText);
                                return user.Predicates.grabSetting(templateNode.Attributes[0].Value);
                            }
                            else
                            {
                                // remove the predicate
                                user.Predicates.removeSetting(templateNode.Attributes[0].Value);
                                return string.Empty;
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The size element tells the AIML interpreter that it should substitute the number of
    /// categories currently loaded.
    ///
    /// The size element does not have any content.
    /// </summary>
    public class size : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public size(Bot bot,
                    User user,
                    SubQuery query,
                    Request request,
                    Result result,
                    XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "size")
            {
                return Convert.ToString(bot.Size);
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The sr element is a shortcut for:
    ///
    /// <srai><star/></srai>
    ///
    /// The atomic sr does not have any content.
    /// </summary>
    public class sr : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public sr(Bot bot,
                  User user,
                  SubQuery query,
                  Request request,
                  Result result,
                  XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "sr")
            {
                XmlNode starNode = getNode("<star/>");
                var recursiveStar = new star(bot, user, query, request, result, starNode);
                string starContent = recursiveStar.Transform();
                XmlNode sraiNode = getNode("<srai>" + starContent + "</srai>");
                var sraiHandler = new srai(bot, user, query, request, result, sraiNode);
                return sraiHandler.Transform();
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The srai element instructs the AIML interpreter to pass the result of processing the contents
    /// of the srai element to the AIML matching loop, as if the input had been produced by the user
    /// (this includes stepping through the entire input normalization process). The srai element does
    /// not have any attributes. It may contain any AIML template elements.
    ///
    /// As with all AIML elements, nested forms should be parsed from inside out, so embedded srais are
    /// perfectly acceptable.
    /// </summary>
    public class srai : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public srai(Bot bot,
                    User user,
                    SubQuery query,
                    Request request,
                    Result result,
                    XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "srai")
            {
                if (templateNode.InnerText.Length > 0)
                {
                    var subRequest = new Request(templateNode.InnerText, user, bot);
                    subRequest.StartedOn = request.StartedOn; // make sure we don't keep adding time to the request
                    Result subQuery = bot.Chat(subRequest);
                    request.hasTimedOut = subRequest.hasTimedOut;
                    return subQuery.Output;
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The star element indicates that an AIML interpreter should substitute the value "captured"
    /// by a particular wildcard from the pattern-specified portion of the match path when returning
    /// the template.
    ///
    /// The star element has an optional integer index attribute that indicates which wildcard to use.
    /// The minimum acceptable value for the index is "1" (the first wildcard), and the maximum
    /// acceptable value is equal to the number of wildcards in the pattern.
    ///
    /// An AIML interpreter should raise an error if the index attribute of a star specifies a wildcard
    /// that does not exist in the category element's pattern. Not specifying the index is the same as
    /// specifying an index of "1".
    ///
    /// The star element does not have any content.
    /// </summary>
    public class star : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public star(Bot bot,
                    User user,
                    SubQuery query,
                    Request request,
                    Result result,
                    XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "star")
            {
                if (query.InputStar.Count > 0)
                {
                    if (templateNode.Attributes.Count == 0)
                    {
                        // return the first (latest) star in the List<>
                        return query.InputStar[0];
                    }
                    else if (templateNode.Attributes.Count == 1)
                    {
                        if (templateNode.Attributes[0].Name.ToLower() == "index")
                        {
                            try
                            {
                                int index = Convert.ToInt32(templateNode.Attributes[0].Value);
                                index--;
                                if ((index >= 0) & (index < query.InputStar.Count))
                                {
                                    return query.InputStar[index];
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// NOT IMPLEMENTED FOR SECURITY REASONS
    /// </summary>
    public class system : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public system(Bot bot,
                      User user,
                      SubQuery query,
                      Request request,
                      Result result,
                      XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The template-side that element indicates that an AIML interpreter should substitute the
    /// contents of a previous bot output.
    ///
    /// The template-side that has an optional index attribute that may contain either a single
    /// integer or a comma-separated pair of integers. The minimum value for either of the integers
    /// in the index is "1". The index tells the AIML interpreter which previous bot output should be
    /// returned (first dimension), and optionally which "sentence" (see [8.3.2.]) of the previous bot
    /// output (second dimension).
    ///
    /// The AIML interpreter should raise an error if either of the specified index dimensions is
    /// invalid at run-time.
    ///
    /// An unspecified index is the equivalent of "1,1". An unspecified second dimension of the index
    /// is the equivalent of specifying a "1" for the second dimension.
    ///
    /// The template-side that element does not have any content.
    /// </summary>
    public class that : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public that(Bot bot,
                    User user,
                    SubQuery query,
                    Request request,
                    Result result,
                    XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "that")
            {
                if (templateNode.Attributes.Count == 0)
                {
                    return user.getThat();
                }
                else if (templateNode.Attributes.Count == 1)
                {
                    if (templateNode.Attributes[0].Name.ToLower() == "index")
                    {
                        if (templateNode.Attributes[0].Value.Length > 0)
                        {
                            try
                            {
                                // see if there is a split
                                string[] dimensions = templateNode.Attributes[0].Value.Split(",".ToCharArray());
                                if (dimensions.Length == 2)
                                {
                                    int result = Convert.ToInt32(dimensions[0].Trim());
                                    int sentence = Convert.ToInt32(dimensions[1].Trim());
                                    if ((result > 0) & (sentence > 0))
                                    {
                                        return user.getThat(result - 1, sentence - 1);
                                    }
                                }
                                else
                                {
                                    int result = Convert.ToInt32(templateNode.Attributes[0].Value.Trim());
                                    if (result > 0)
                                    {
                                        return user.getThat(result - 1);
                                    }
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The thatstar element tells the AIML interpreter that it should substitute the contents of a
    /// wildcard from a pattern-side that element.
    ///
    /// The thatstar element has an optional integer index attribute that indicates which wildcard
    /// to use; the minimum acceptable value for the index is "1" (the first wildcard).
    ///
    /// An AIML interpreter should raise an error if the index attribute of a star specifies a
    /// wildcard that does not exist in the that element's pattern content. Not specifying the index
    /// is the same as specifying an index of "1".
    ///
    /// The thatstar element does not have any content.
    /// </summary>
    public class thatstar : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public thatstar(Bot bot,
                        User user,
                        SubQuery query,
                        Request request,
                        Result result,
                        XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "thatstar")
            {
                if (templateNode.Attributes.Count == 0)
                {
                    if (query.ThatStar.Count > 0)
                    {
                        return query.ThatStar[0];
                    }
                }
                else if (templateNode.Attributes.Count == 1)
                {
                    if (templateNode.Attributes[0].Name.ToLower() == "index")
                    {
                        if (templateNode.Attributes[0].Value.Length > 0)
                        {
                            try
                            {
                                int result = Convert.ToInt32(templateNode.Attributes[0].Value.Trim());
                                if (query.ThatStar.Count > 0)
                                {
                                    if (result > 0)
                                    {
                                        return query.ThatStar[result - 1];
                                    }
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The think element instructs the AIML interpreter to perform all usual processing of its
    /// contents, but to not return any value, regardless of whether the contents produce output.
    ///
    /// The think element has no attributes. It may contain any AIML template elements.
    /// </summary>
    public class think : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public think(Bot bot,
                     User user,
                     SubQuery query,
                     Request request,
                     Result result,
                     XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The topicstar element tells the AIML interpreter that it should substitute the contents of
    /// a wildcard from the current topic (if the topic contains any wildcards).
    ///
    /// The topicstar element has an optional integer index attribute that indicates which wildcard
    /// to use; the minimum acceptable value for the index is "1" (the first wildcard). Not
    /// specifying the index is the same as specifying an index of "1".
    ///
    /// The topicstar element does not have any content.
    /// </summary>
    public class topicstar : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public topicstar(Bot bot,
                         User user,
                         SubQuery query,
                         Request request,
                         Result result,
                         XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "topicstar")
            {
                if (templateNode.Attributes.Count == 0)
                {
                    if (query.TopicStar.Count > 0)
                    {
                        return query.TopicStar[0];
                    }
                }
                else if (templateNode.Attributes.Count == 1)
                {
                    if (templateNode.Attributes[0].Name.ToLower() == "index")
                    {
                        if (templateNode.Attributes[0].Value.Length > 0)
                        {
                            try
                            {
                                int result = Convert.ToInt32(templateNode.Attributes[0].Value.Trim());
                                if (query.TopicStar.Count > 0)
                                {
                                    if (result > 0)
                                    {
                                        return query.TopicStar[result - 1];
                                    }
                                }
                            }
                            catch
                            {
                            }
                        }
                    }
                }
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The uppercase element tells the AIML interpreter to render the contents of the element
    /// in uppercase, as defined (if defined) by the locale indicated by the specified language
    /// if specified).
    ///
    /// If no character in this string has a different uppercase version, based on the Unicode
    /// standard, then the original string is returned.
    /// </summary>
    public class uppercase : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public uppercase(Bot bot,
                         User user,
                         SubQuery query,
                         Request request,
                         Result result,
                         XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "uppercase")
            {
                return templateNode.InnerText.ToUpper(bot.Locale);
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot.AIMLTagHandlers
{
    /// <summary>
    /// The version element tells the AIML interpreter that it should substitute the version number
    /// of the AIML interpreter.
    ///
    /// The version element does not have any content.
    /// </summary>
    public class version : AIMLTagHandler
    {
        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request inputted into the system</param>
        /// <param name="result">The result to be passed to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public version(Bot bot,
                       User user,
                       SubQuery query,
                       Request request,
                       Result result,
                       XmlNode templateNode)
            : base(bot, user, query, request, result, templateNode)
        {
        }

        protected override string ProcessChange()
        {
            if (templateNode.Name.ToLower() == "version")
            {
                return bot.GlobalSettings.grabSetting("version");
            }
            return string.Empty;
        }
    }
}

namespace AIMLbot
{
    /// <summary>
    /// Encapsulates a bot. If no settings.xml file is found or referenced the bot will try to
    /// default to safe settings.
    /// </summary>
    public class Bot
    {
        #region Attributes

        /// <summary>
        /// Holds references to the assemblies that hold the custom tag handling code.
        /// </summary>
        private readonly Dictionary<string, Assembly> LateBindingAssemblies = new Dictionary<string, Assembly>();

        /// <summary>
        /// Holds information about the available custom tag handling classes (if loaded)
        /// Key = class name
        /// Value = TagHandler class that provides information about the class
        /// </summary>
        private Dictionary<string, TagHandler> CustomTags;

        /// <summary>
        /// The default predicates to set up for a user
        /// </summary>
        public SettingsDictionary DefaultPredicates;

        /// <summary>
        /// A dictionary of all the gender based substitutions used by this bot
        /// </summary>
        public SettingsDictionary GenderSubstitutions;

        /// <summary>
        /// A dictionary object that looks after all the settings associated with this bot
        /// </summary>
        public SettingsDictionary GlobalSettings;

        /// <summary>
        /// The "brain" of the bot
        /// </summary>
        public Node Graphmaster;

        /// <summary>
        /// A buffer to hold log messages to be written out to the log file when a max size is reached
        /// </summary>
        private List<string> LogBuffer = new List<string>();

        /// <summary>
        /// The maximum number of characters a "that" element of a path is allowed to be. Anything above
        /// this length will cause "that" to be "*". This is to avoid having the graphmaster process
        /// huge "that" elements in the path that might have been caused by the bot reporting third party
        /// data.
        /// </summary>
        public int MaxThatSize = 256;

        /// <summary>
        /// A dictionary of all the first person to second person (and back) substitutions
        /// </summary>
        public SettingsDictionary Person2Substitutions;

        /// <summary>
        /// A dictionary of first / third person substitutions
        /// </summary>
        public SettingsDictionary PersonSubstitutions;

        /// <summary>
        /// The number of categories this bot has in its graphmaster "brain"
        /// </summary>
        public int Size;

        /// <summary>
        /// An List<> containing the tokens used to split the input into sentences during the
        /// normalization process
        /// </summary>
        public List<string> Splitters = new List<string>();

        /// <summary>
        /// When the Bot was initialised
        /// </summary>
        public DateTime StartedOn = DateTime.Now;

        /// <summary>
        /// Generic substitutions that take place during the normalization process
        /// </summary>
        public SettingsDictionary Substitutions;

        /// <summary>
        /// If set to false the input from AIML files will undergo the same normalization process that
        /// user input goes through. If true the bot will assume the AIML is correct. Defaults to true.
        /// </summary>
        public bool TrustAIML = true;

        /// <summary>
        /// Flag to show if the bot is willing to accept user input
        /// </summary>
        public bool isAcceptingUserInput = true;

        /// <summary>
        /// How big to let the log buffer get before writing to disk
        /// </summary>
        private int MaxLogBufferSize
        {
            get { return Convert.ToInt32(GlobalSettings.grabSetting("maxlogbuffersize")); }
        }

        /// <summary>
        /// The message to show if a user tries to use the bot whilst it is set to not process user input
        /// </summary>
        private string NotAcceptingUserInputMessage
        {
            get { return GlobalSettings.grabSetting("notacceptinguserinputmessage"); }
        }

        /// <summary>
        /// The maximum amount of time a request should take (in milliseconds)
        /// </summary>
        public double TimeOut
        {
            get { return Convert.ToDouble(GlobalSettings.grabSetting("timeout")); }
        }

        /// <summary>
        /// The message to display in the event of a timeout
        /// </summary>
        public string TimeOutMessage
        {
            get { return GlobalSettings.grabSetting("timeoutmessage"); }
        }

        /// <summary>
        /// The locale of the bot as a CultureInfo object
        /// </summary>
        public CultureInfo Locale
        {
            get { return new CultureInfo(GlobalSettings.grabSetting("culture")); }
        }

        /// <summary>
        /// Will match all the illegal characters that might be inputted by the user
        /// </summary>
        public Regex Strippers
        {
            get { return new Regex(GlobalSettings.grabSetting("stripperregex"), RegexOptions.IgnorePatternWhitespace); }
        }

        /// <summary>
        /// The email address of the botmaster to be used if WillCallHome is set to true
        /// </summary>
        public string AdminEmail
        {
            get { return GlobalSettings.grabSetting("adminemail"); }
            set
            {
                if (value.Length > 0)
                {
                    // check that the email is valid
                    string patternStrict = @"^(([^<>()[\]\\.,;:\s@\""]+"
                                           + @"(\.[^<>()[\]\\.,;:\s@\""]+)*)|(\"".+\""))@"
                                           + @"((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
                                           + @"\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+"
                                           + @"[a-zA-Z]{2,}))$";
                    var reStrict = new Regex(patternStrict);
                    if (reStrict.IsMatch(value))
                    {
                        // update the settings
                        GlobalSettings.addSetting("adminemail", value);
                    }
                    else
                    {
                        Logging.WriteDebug("The AdminEmail is not a valid email address");
                    }
                }
                else
                {
                    GlobalSettings.addSetting("adminemail", "");
                }
            }
        }

        /// <summary>
        /// Flag to denote if the bot is writing messages to its logs
        /// </summary>
        public bool IsLogging
        {
            get
            {
                string islogging = GlobalSettings.grabSetting("islogging");
                if (islogging.ToLower() == "true")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        /// <summary>
        /// The supposed sex of the bot
        /// </summary>
        public Gender Sex
        {
            get
            {
                int sex = Convert.ToInt32(GlobalSettings.grabSetting("gender"));
                Gender result;
                switch (sex)
                {
                    case -1:
                        result = Gender.Unknown;
                        break;
                    case 0:
                        result = Gender.Female;
                        break;
                    case 1:
                        result = Gender.Male;
                        break;
                    default:
                        result = Gender.Unknown;
                        break;
                }
                return result;
            }
        }

        /// <summary>
        /// The directory to look in for the AIML files
        /// </summary>
        public string PathToAIML
        {
            get { return Path.Combine(Logging.ApplicationPath, "Plugins\\AIMLBuddy\\aiml"); }
        }

        /// <summary>
        /// The directory to look in for the various XML configuration files
        /// </summary>
        public string PathToConfigFiles
        {
            get { return Path.Combine(Logging.ApplicationPath, "Plugins\\AIMLBuddy\\config"); }
        }

        #endregion

        #region Delegates

        public delegate void LogMessageDelegate();

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        public Bot()
        {
            setup();
        }

        #region Settings methods

        /// <summary>
        /// Loads AIML from .aiml files into the graphmaster "brain" of the bot
        /// </summary>
        public void loadAIMLFromFiles()
        {
            var loader = new AIMLLoader(this);
            loader.loadAIML();
        }

        /// <summary>
        /// Allows the bot to load a new XML version of some AIML
        /// </summary>
        /// <param name="newAIML">The XML document containing the AIML</param>
        /// <param name="filename">The originator of the XML document</param>
        public void loadAIMLFromXML(XmlDocument newAIML, string filename)
        {
            var loader = new AIMLLoader(this);
            loader.loadAIMLFromXML(newAIML, filename);
        }

        /// <summary>
        /// Instantiates the dictionary objects and collections associated with this class
        /// </summary>
        private void setup()
        {
            GlobalSettings = new SettingsDictionary(this);
            GenderSubstitutions = new SettingsDictionary(this);
            Person2Substitutions = new SettingsDictionary(this);
            PersonSubstitutions = new SettingsDictionary(this);
            Substitutions = new SettingsDictionary(this);
            DefaultPredicates = new SettingsDictionary(this);
            CustomTags = new Dictionary<string, TagHandler>();
            Graphmaster = new Node();
            loadSettings();
            isAcceptingUserInput = false;
            loadAIMLFromFiles();
            isAcceptingUserInput = true;
        }

        /// <summary>
        /// Loads settings based upon the default location of the Settings.xml file
        /// </summary>
        public void loadSettings()
        {
            // try a safe default setting for the settings xml file
            string path = Path.Combine(Environment.CurrentDirectory, Path.Combine("config", "Settings.xml"));
            loadSettings(path);
        }

        /// <summary>
        /// Loads settings and configuration info from various xml files referenced in the settings file passed in the args.
        /// Also generates some default values if such values have not been set by the settings file.
        /// </summary>
        /// <param name="pathToSettings">Path to the settings xml file</param>
        public void loadSettings(string pathToSettings)
        {
            GlobalSettings.loadSettings(pathToSettings);
            // Checks for some important default settings
            if (!GlobalSettings.containsSettingCalled("version"))
            {
                GlobalSettings.addSetting("version", Environment.Version.ToString());
            }
            if (!GlobalSettings.containsSettingCalled("name"))
            {
                GlobalSettings.addSetting("name", "Unknown");
            }
            if (!GlobalSettings.containsSettingCalled("botmaster"))
            {
                GlobalSettings.addSetting("botmaster", "Unknown");
            }
            if (!GlobalSettings.containsSettingCalled("master"))
            {
                GlobalSettings.addSetting("botmaster", "Unknown");
            }
            if (!GlobalSettings.containsSettingCalled("author"))
            {
                GlobalSettings.addSetting("author", "Nicholas H.Tollervey");
            }
            if (!GlobalSettings.containsSettingCalled("location"))
            {
                GlobalSettings.addSetting("location", "Unknown");
            }
            if (!GlobalSettings.containsSettingCalled("gender"))
            {
                GlobalSettings.addSetting("gender", "-1");
            }
            if (!GlobalSettings.containsSettingCalled("birthday"))
            {
                GlobalSettings.addSetting("birthday", "2006/11/08");
            }
            if (!GlobalSettings.containsSettingCalled("birthplace"))
            {
                GlobalSettings.addSetting("birthplace", "Towcester, Northamptonshire, UK");
            }
            if (!GlobalSettings.containsSettingCalled("website"))
            {
                GlobalSettings.addSetting("website", "http://sourceforge.net/projects/aimlbot");
            }
            if (GlobalSettings.containsSettingCalled("adminemail"))
            {
                string emailToCheck = GlobalSettings.grabSetting("adminemail");
                AdminEmail = emailToCheck;
            }
            else
            {
                GlobalSettings.addSetting("adminemail", "");
            }
            if (!GlobalSettings.containsSettingCalled("islogging"))
            {
                GlobalSettings.addSetting("islogging", "False");
            }
            if (!GlobalSettings.containsSettingCalled("willcallhome"))
            {
                GlobalSettings.addSetting("willcallhome", "False");
            }
            if (!GlobalSettings.containsSettingCalled("timeout"))
            {
                GlobalSettings.addSetting("timeout", "2000");
            }
            if (!GlobalSettings.containsSettingCalled("timeoutmessage"))
            {
                GlobalSettings.addSetting("timeoutmessage", "ERROR: The request has timed out.");
            }
            if (!GlobalSettings.containsSettingCalled("culture"))
            {
                GlobalSettings.addSetting("culture", "en-US");
            }
            if (!GlobalSettings.containsSettingCalled("splittersfile"))
            {
                GlobalSettings.addSetting("splittersfile", "Splitters.xml");
            }
            if (!GlobalSettings.containsSettingCalled("person2substitutionsfile"))
            {
                GlobalSettings.addSetting("person2substitutionsfile", "Person2Substitutions.xml");
            }
            if (!GlobalSettings.containsSettingCalled("personsubstitutionsfile"))
            {
                GlobalSettings.addSetting("personsubstitutionsfile", "PersonSubstitutions.xml");
            }
            if (!GlobalSettings.containsSettingCalled("gendersubstitutionsfile"))
            {
                GlobalSettings.addSetting("gendersubstitutionsfile", "GenderSubstitutions.xml");
            }
            if (!GlobalSettings.containsSettingCalled("defaultpredicates"))
            {
                GlobalSettings.addSetting("defaultpredicates", "DefaultPredicates.xml");
            }
            if (!GlobalSettings.containsSettingCalled("substitutionsfile"))
            {
                GlobalSettings.addSetting("substitutionsfile", "Substitutions.xml");
            }
            if (!GlobalSettings.containsSettingCalled("aimldirectory"))
            {
                GlobalSettings.addSetting("aimldirectory", "aiml");
            }
            if (!GlobalSettings.containsSettingCalled("configdirectory"))
            {
                GlobalSettings.addSetting("configdirectory", "config");
            }
            if (!GlobalSettings.containsSettingCalled("logdirectory"))
            {
                GlobalSettings.addSetting("logdirectory", "logs");
            }
            if (!GlobalSettings.containsSettingCalled("maxlogbuffersize"))
            {
                GlobalSettings.addSetting("maxlogbuffersize", "64");
            }
            if (!GlobalSettings.containsSettingCalled("notacceptinguserinputmessage"))
            {
                GlobalSettings.addSetting("notacceptinguserinputmessage",
                                          "This bot is currently set to not accept user input.");
            }
            if (!GlobalSettings.containsSettingCalled("stripperregex"))
            {
                GlobalSettings.addSetting("stripperregex", "[^0-9a-zA-Z]");
            }
            // Load the dictionaries for this Bot from the various configuration files
            Person2Substitutions.loadSettings(Path.Combine(PathToConfigFiles,
                                                           GlobalSettings.grabSetting("person2substitutionsfile")));
            PersonSubstitutions.loadSettings(Path.Combine(PathToConfigFiles,
                                                          GlobalSettings.grabSetting("personsubstitutionsfile")));
            GenderSubstitutions.loadSettings(Path.Combine(PathToConfigFiles,
                                                          GlobalSettings.grabSetting("gendersubstitutionsfile")));
            DefaultPredicates.loadSettings(Path.Combine(PathToConfigFiles,
                                                        GlobalSettings.grabSetting("defaultpredicates")));
            Substitutions.loadSettings(Path.Combine(PathToConfigFiles, GlobalSettings.grabSetting("substitutionsfile")));
            // Grab the splitters for this bot
            loadSplitters(Path.Combine(PathToConfigFiles, GlobalSettings.grabSetting("splittersfile")));
        }

        /// <summary>
        /// Loads the splitters for this bot from the supplied config file (or sets up some safe defaults)
        /// </summary>
        /// <param name="pathToSplitters">Path to the config file</param>
        private void loadSplitters(string pathToSplitters)
        {
            var splittersFile = new FileInfo(pathToSplitters);
            if (splittersFile.Exists)
            {
                var splittersXmlDoc = new XmlDocument();
                splittersXmlDoc.Load(pathToSplitters);
                // the XML should have an XML declaration like this:
                // <?xml version="1.0" encoding="utf-8" ?>
                // followed by a <root> tag with children of the form:
                // <item value="value"/>
                if (splittersXmlDoc.ChildNodes.Count == 2)
                {
                    if (splittersXmlDoc.LastChild.HasChildNodes)
                    {
                        foreach (XmlNode myNode in splittersXmlDoc.LastChild.ChildNodes)
                        {
                            if ((myNode.Name == "item") & (myNode.Attributes.Count == 1))
                            {
                                string value = myNode.Attributes["value"].Value;
                                Splitters.Add(value);
                            }
                        }
                    }
                }
            }
            if (Splitters.Count == 0)
            {
                // we don't have any splitters, so lets make do with these...
                Splitters.Add(".");
                Splitters.Add("!");
                Splitters.Add("?");
                Splitters.Add(";");
            }
        }

        #endregion

        #region Conversation methods

        /// <summary>
        /// Given some raw input and a unique ID creates a response for a new user
        /// </summary>
        /// <param name="rawInput">the raw input</param>
        /// <param name="UserGUID">an ID for the new user (referenced in the result object)</param>
        /// <returns>the result to be output to the user</returns>
        public Result Chat(string rawInput, string UserGUID)
        {
            var request = new Request(rawInput, new User(UserGUID, this), this);
            return Chat(request);
        }

        /// <summary>
        /// Given a request containing user input, produces a result from the bot
        /// </summary>
        /// <param name="request">the request from the user</param>
        /// <returns>the result to be output to the user</returns>
        public Result Chat(Request request)
        {
            var result = new Result(request.user, this, request);
            if (isAcceptingUserInput)
            {
                // Normalize the input
                var loader = new AIMLLoader(this);
                var splitter = new SplitIntoSentences(this);
                string[] rawSentences = splitter.Transform(request.rawInput);
                foreach (string sentence in rawSentences)
                {
                    result.InputSentences.Add(sentence);
                    string path = loader.generatePath(sentence, request.user.getLastBotOutput(), request.user.Topic,
                                                      true);
                    result.NormalizedPaths.Add(path);
                }
                // grab the templates for the various sentences from the graphmaster
                foreach (string path in result.NormalizedPaths)
                {
                    var query = new SubQuery(path);
                    query.Template = Graphmaster.evaluate(path, query, request, MatchState.UserInput,
                                                          new StringBuilder());
                    result.SubQueries.Add(query);
                }
                // process the templates into appropriate output
                foreach (SubQuery query in result.SubQueries)
                {
                    if (query.Template.Length > 0)
                    {
                        try
                        {
                            XmlNode templateNode = AIMLTagHandler.getNode(query.Template);
                            string outputSentence = processNode(templateNode, query, request, result, request.user);
                            if (outputSentence.Length > 0)
                            {
                                result.OutputSentences.Add(outputSentence);
                            }
                        }
                        catch (Exception e)
                        {
                        }
                    }
                }
            }
            else
            {
                result.OutputSentences.Add(NotAcceptingUserInputMessage);
            }
            // populate the Result object
            result.Duration = DateTime.Now - request.StartedOn;
            request.user.addResult(result);
            return result;
        }

        /// <summary>
        /// Recursively evaluates the template nodes returned from the bot
        /// </summary>
        /// <param name="node">the node to evaluate</param>
        /// <param name="query">the query that produced this node</param>
        /// <param name="request">the request from the user</param>
        /// <param name="result">the result to be sent to the user</param>
        /// <param name="user">the user who originated the request</param>
        /// <returns>the output string</returns>
        private string processNode(XmlNode node, SubQuery query, Request request, Result result, User user)
        {
            // check for timeout (to avoid infinite loops)
            if (request.StartedOn.AddMilliseconds(request.bot.TimeOut) < DateTime.Now)
            {
                request.hasTimedOut = true;
                return string.Empty;
            }

            // process the node
            string tagName = node.Name.ToLower();
            if (tagName == "template")
            {
                var templateResult = new StringBuilder();
                if (node.HasChildNodes)
                {
                    // recursively check
                    foreach (XmlNode childNode in node.ChildNodes)
                    {
                        templateResult.Append(processNode(childNode, query, request, result, user));
                    }
                }
                return templateResult.ToString();
            }
            else
            {
                AIMLTagHandler tagHandler = null;
                tagHandler = getBespokeTags(user, query, request, result, node);
                if (Equals(null, tagHandler))
                {
                    switch (tagName)
                    {
                        case "bot":
                            tagHandler = new bot(this, user, query, request, result, node);
                            break;
                        case "condition":
                            tagHandler = new condition(this, user, query, request, result, node);
                            break;
                        case "date":
                            tagHandler = new date(this, user, query, request, result, node);
                            break;
                        case "formal":
                            tagHandler = new formal(this, user, query, request, result, node);
                            break;
                        case "gender":
                            tagHandler = new gender(this, user, query, request, result, node);
                            break;
                        case "get":
                            tagHandler = new get(this, user, query, request, result, node);
                            break;
                        case "gossip":
                            tagHandler = new gossip(this, user, query, request, result, node);
                            break;
                        case "id":
                            tagHandler = new id(this, user, query, request, result, node);
                            break;
                        case "input":
                            tagHandler = new input(this, user, query, request, result, node);
                            break;
                        case "javascript":
                            tagHandler = new javascript(this, user, query, request, result, node);
                            break;
                        case "learn":
                            tagHandler = new learn(this, user, query, request, result, node);
                            break;
                        case "lowercase":
                            tagHandler = new lowercase(this, user, query, request, result, node);
                            break;
                        case "person":
                            tagHandler = new person(this, user, query, request, result, node);
                            break;
                        case "person2":
                            tagHandler = new person2(this, user, query, request, result, node);
                            break;
                        case "random":
                            tagHandler = new random(this, user, query, request, result, node);
                            break;
                        case "sentence":
                            tagHandler = new sentence(this, user, query, request, result, node);
                            break;
                        case "set":
                            tagHandler = new set(this, user, query, request, result, node);
                            break;
                        case "size":
                            tagHandler = new size(this, user, query, request, result, node);
                            break;
                        case "sr":
                            tagHandler = new sr(this, user, query, request, result, node);
                            break;
                        case "srai":
                            tagHandler = new srai(this, user, query, request, result, node);
                            break;
                        case "star":
                            tagHandler = new star(this, user, query, request, result, node);
                            break;
                        case "system":
                            tagHandler = new system(this, user, query, request, result, node);
                            break;
                        case "that":
                            tagHandler = new that(this, user, query, request, result, node);
                            break;
                        case "thatstar":
                            tagHandler = new thatstar(this, user, query, request, result, node);
                            break;
                        case "think":
                            tagHandler = new think(this, user, query, request, result, node);
                            break;
                        case "topicstar":
                            tagHandler = new topicstar(this, user, query, request, result, node);
                            break;
                        case "uppercase":
                            tagHandler = new uppercase(this, user, query, request, result, node);
                            break;
                        case "version":
                            tagHandler = new version(this, user, query, request, result, node);
                            break;
                        default:
                            tagHandler = null;
                            break;
                    }
                }
                if (Equals(null, tagHandler))
                {
                    return node.InnerText;
                }
                else
                {
                    if (tagHandler.isRecursive)
                    {
                        if (node.HasChildNodes)
                        {
                            // recursively check
                            foreach (XmlNode childNode in node.ChildNodes)
                            {
                                if (childNode.NodeType != XmlNodeType.Text)
                                {
                                    childNode.InnerXml = processNode(childNode, query, request, result, user);
                                }
                            }
                        }
                        return tagHandler.Transform();
                    }
                    else
                    {
                        string resultNodeInnerXML = tagHandler.Transform();
                        XmlNode resultNode = AIMLTagHandler.getNode("<node>" + resultNodeInnerXML + "</node>");
                        if (resultNode.HasChildNodes)
                        {
                            var recursiveResult = new StringBuilder();
                            // recursively check
                            foreach (XmlNode childNode in resultNode.ChildNodes)
                            {
                                recursiveResult.Append(processNode(childNode, query, request, result, user));
                            }
                            return recursiveResult.ToString();
                        }
                        else
                        {
                            return resultNode.InnerXml;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Searches the CustomTag collection and processes the AIML if an appropriate tag handler is found
        /// </summary>
        /// <param name="user">the user who originated the request</param>
        /// <param name="query">the query that produced this node</param>
        /// <param name="request">the request from the user</param>
        /// <param name="result">the result to be sent to the user</param>
        /// <param name="node">the node to evaluate</param>
        /// <returns>the output string</returns>
        public AIMLTagHandler getBespokeTags(User user, SubQuery query, Request request, Result result, XmlNode node)
        {
            if (CustomTags.ContainsKey(node.Name.ToLower()))
            {
                TagHandler customTagHandler = CustomTags[node.Name.ToLower()];
                AIMLTagHandler newCustomTag = customTagHandler.Instantiate(LateBindingAssemblies);
                if (Equals(null, newCustomTag))
                {
                    return null;
                }
                else
                {
                    newCustomTag.user = user;
                    newCustomTag.query = query;
                    newCustomTag.request = request;
                    newCustomTag.result = result;
                    newCustomTag.templateNode = node;
                    newCustomTag.bot = this;
                    return newCustomTag;
                }
            }
            else
            {
                return null;
            }
        }

        #endregion

        #region Serialization

        /// <summary>
        /// Saves the graphmaster node (and children) to a binary file to avoid processing the AIML each time the
        /// bot starts
        /// </summary>
        /// <param name="path">the path to the file for saving</param>
        public void saveToBinaryFile(string path)
        {
            // check to delete an existing version of the file
            var fi = new FileInfo(path);
            if (fi.Exists)
            {
                fi.Delete();
            }
            FileStream saveFile = File.Create(path);
            var bf = new BinaryFormatter();
            bf.Serialize(saveFile, Graphmaster);
            saveFile.Close();
        }

        /// <summary>
        /// Loads a dump of the graphmaster into memory so avoiding processing the AIML files again
        /// </summary>
        /// <param name="path">the path to the dump file</param>
        public void loadFromBinaryFile(string path)
        {
            FileStream loadFile = File.OpenRead(path);
            var bf = new BinaryFormatter();
            Graphmaster = (Node) bf.Deserialize(loadFile);
            loadFile.Close();
        }

        #endregion

        #region Latebinding custom-tag dll handlers

        /// <summary>
        /// Loads any custom tag handlers found in the dll referenced in the argument
        /// </summary>
        /// <param name="pathToDLL">the path to the dll containing the custom tag handling code</param>
        public void loadCustomTagHandlers(string pathToDLL)
        {
            Assembly tagDLL = Assembly.LoadFrom(pathToDLL);
            Type[] tagDLLTypes = tagDLL.GetTypes();
            for (int i = 0; i < tagDLLTypes.Length; i++)
            {
                object[] typeCustomAttributes = tagDLLTypes[i].GetCustomAttributes(false);
                for (int j = 0; j < typeCustomAttributes.Length; j++)
                {
                    if (typeCustomAttributes[j] is CustomTagAttribute)
                    {
                        // We've found a custom tag handling class
                        // so store the assembly and store it away in the Dictionary<,> as a TagHandler class for
                        // later usage

                        // store Assembly
                        if (!LateBindingAssemblies.ContainsKey(tagDLL.FullName))
                        {
                            LateBindingAssemblies.Add(tagDLL.FullName, tagDLL);
                        }
                        // create the TagHandler representation
                        var newTagHandler = new TagHandler();
                        newTagHandler.AssemblyName = tagDLL.FullName;
                        newTagHandler.ClassName = tagDLLTypes[i].FullName;
                        newTagHandler.TagName = tagDLLTypes[i].Name.ToLower();
                        if (CustomTags.ContainsKey(newTagHandler.TagName))
                        {
                            Logging.WriteDebug("ERROR! Unable to add the custom tag: <" + newTagHandler.TagName +
                                               ">, found in: " + pathToDLL +
                                               " as a handler for this tag already exists.");
                        }
                        else
                        {
                            CustomTags.Add(newTagHandler.TagName, newTagHandler);
                        }
                    }
                }
            }
        }

        #endregion
    }
}

namespace AIMLbot.Normalize
{
    /// <summary>
    /// Checks the text for any matches in the bot's substitutions dictionary and makes
    /// any appropriate changes.
    /// </summary>
    public class ApplySubstitutions : TextTransformer
    {
        public ApplySubstitutions(Bot bot, string inputString)
            : base(bot, inputString)
        {
        }

        public ApplySubstitutions(Bot bot)
            : base(bot)
        {
        }

        /// <summary>
        /// Produces a random "marker" string that tags text that is already the result of a substitution
        /// </summary>
        /// <param name="len">The length of the marker</param>
        /// <returns>the resulting marker</returns>
        private static string getMarker(int len)
        {
            char[] chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray();
            var result = new StringBuilder();
            var r = new Random();
            for (int i = 0; i < len; i++)
            {
                result.Append(chars[r.Next(chars.Length)]);
            }
            return result.ToString();
        }

        protected override string ProcessChange()
        {
            return Substitute(bot, bot.Substitutions, inputString);
        }

        /// <summary>
        /// Static helper that applies replacements from the passed dictionary object to the
        /// target string
        /// </summary>
        /// <param name="bot">The bot for whom this is being processed</param>
        /// <param name="dictionary">The dictionary containing the substitutions</param>
        /// <param name="target">the target string to which the substitutions are to be applied</param>
        /// <returns>The processed string</returns>
        public static string Substitute(Bot bot, SettingsDictionary dictionary, string target)
        {
            string marker = getMarker(5);
            string result = target;
            foreach (string pattern in dictionary.SettingNames)
            {
                string p2 = makeRegexSafe(pattern);
                //string match = "\\b"+@p2.Trim().Replace(" ","\\s*")+"\\b";
                string match = "\\b" + p2.TrimEnd().TrimStart() + "\\b";
                string replacement = marker + dictionary.grabSetting(pattern).Trim() + marker;
                result = Regex.Replace(result, match, replacement, RegexOptions.IgnoreCase);
            }
            return result.Replace(marker, "");
        }

        /// <summary>
        /// Given an input, escapes certain characters so they can be used as part of a regex
        /// </summary>
        /// <param name="input">The raw input</param>
        /// <returns>the safe version</returns>
        private static string makeRegexSafe(string input)
        {
            string result = input.Replace("\\", "");
            result = result.Replace(")", "\\)");
            result = result.Replace("(", "\\(");
            result = result.Replace(".", "\\.");
            return result;
        }
    }
}

namespace AIMLbot.Normalize
{
    /// <summary>
    /// Normalizes the input text into upper case
    /// </summary>
    public class MakeCaseInsensitive : TextTransformer
    {
        public MakeCaseInsensitive(Bot bot, string inputString)
            : base(bot, inputString)
        {
        }

        public MakeCaseInsensitive(Bot bot)
            : base(bot)
        {
        }

        protected override string ProcessChange()
        {
            return inputString.ToUpper();
        }

        /// <summary>
        /// An ease-of-use static method that re-produces the instance transformation methods
        /// </summary>
        /// <param name="input">The string to transform</param>
        /// <returns>The resulting string</returns>
        public static string TransformInput(string input)
        {
            return input.ToUpper();
        }
    }
}

namespace AIMLbot.Normalize
{
    /// <summary>
    /// Splits the raw input into its constituent sentences. Split using the tokens found in
    /// the bots Splitters string array.
    /// </summary>
    public class SplitIntoSentences
    {
        /// <summary>
        /// The bot this sentence splitter is associated with
        /// </summary>
        private readonly Bot bot;

        /// <summary>
        /// The raw input string
        /// </summary>
        private string inputString;

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot this sentence splitter is associated with</param>
        /// <param name="inputString">The raw input string to be processed</param>
        public SplitIntoSentences(Bot bot, string inputString)
        {
            this.bot = bot;
            this.inputString = inputString;
        }

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot this sentence splitter is associated with</param>
        public SplitIntoSentences(Bot bot)
        {
            this.bot = bot;
        }

        /// <summary>
        /// Splits the supplied raw input into an array of strings according to the tokens found in
        /// the bot's Splitters List<>
        /// </summary>
        /// <param name="inputString">The raw input to split</param>
        /// <returns>An array of strings representing the constituent "sentences"</returns>
        public string[] Transform(string inputString)
        {
            this.inputString = inputString;
            return Transform();
        }

        /// <summary>
        /// Splits the raw input supplied via the ctor into an array of strings according to the tokens
        /// found in the bot's Splitters List<>
        /// </summary>
        /// <returns>An array of strings representing the constituent "sentences"</returns>
        public string[] Transform()
        {
            string[] tokens = bot.Splitters.ToArray();
            string[] rawResult = inputString.Split(tokens, StringSplitOptions.RemoveEmptyEntries);
            var tidyResult = new List<string>();
            foreach (string rawSentence in rawResult)
            {
                string tidySentence = rawSentence.Trim();
                if (tidySentence.Length > 0)
                {
                    tidyResult.Add(tidySentence);
                }
            }
            return tidyResult.ToArray();
        }
    }
}

namespace AIMLbot.Normalize
{
    /// <summary>
    /// Strips any illegal characters found within the input string. Illegal characters are referenced from
    /// the bot's Strippers regex that is defined in the setup XML file.
    /// </summary>
    public class StripIllegalCharacters : TextTransformer
    {
        public StripIllegalCharacters(Bot bot, string inputString)
            : base(bot, inputString)
        {
        }

        public StripIllegalCharacters(Bot bot)
            : base(bot)
        {
        }

        protected override string ProcessChange()
        {
            return bot.Strippers.Replace(inputString, " ");
        }
    }
}

namespace AIMLbot
{
    /// <summary>
    /// Encapsulates all sorts of information about a request to the bot for processing
    /// </summary>
    public class Request
    {
        #region Attributes

        /// <summary>
        /// The time at which this request was created within the system
        /// </summary>
        public DateTime StartedOn;

        /// <summary>
        /// The bot to which the request is being made
        /// </summary>
        public Bot bot;

        /// <summary>
        /// Flag to show that the request has timed out
        /// </summary>
        public bool hasTimedOut;

        /// <summary>
        /// The raw input from the user
        /// </summary>
        public string rawInput;

        /// <summary>
        /// The final result produced by this request
        /// </summary>
        public Result result;

        /// <summary>
        /// The user who made this request
        /// </summary>
        public User user;

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="rawInput">The raw input from the user</param>
        /// <param name="user">The user who made the request</param>
        /// <param name="bot">The bot to which this is a request</param>
        public Request(string rawInput, User user, Bot bot)
        {
            this.rawInput = rawInput;
            this.user = user;
            this.bot = bot;
            StartedOn = DateTime.Now;
        }
    }
}

namespace AIMLbot
{
    /// <summary>
    /// Encapsulates information about the result of a request to the bot
    /// </summary>
    public class Result
    {
        /// <summary>
        /// The amount of time the request took to process
        /// </summary>
        public TimeSpan Duration;

        /// <summary>
        /// The individual sentences that constitute the raw input from the user
        /// </summary>
        public List<string> InputSentences = new List<string>();

        /// <summary>
        /// The normalized sentence(s) (paths) fed into the graphmaster
        /// </summary>
        public List<string> NormalizedPaths = new List<string>();

        /// <summary>
        /// The individual sentences produced by the bot that form the complete response
        /// </summary>
        public List<string> OutputSentences = new List<string>();

        /// <summary>
        /// The subQueries processed by the bot's graphmaster that contain the templates that
        /// are to be converted into the collection of Sentences
        /// </summary>
        public List<SubQuery> SubQueries = new List<SubQuery>();

        /// <summary>
        /// The bot that is providing the answer
        /// </summary>
        public Bot bot;

        /// <summary>
        /// The request from the user
        /// </summary>
        public Request request;

        /// <summary>
        /// The user for whom this is a result
        /// </summary>
        public User user;

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="user">The user for whom this is a result</param>
        /// <param name="bot">The bot providing the result</param>
        /// <param name="request">The request that originated this result</param>
        public Result(User user, Bot bot, Request request)
        {
            this.user = user;
            this.bot = bot;
            this.request = request;
            this.request.result = this;
        }

        /// <summary>
        /// The raw input from the user
        /// </summary>
        public string RawInput
        {
            get { return request.rawInput; }
        }

        /// <summary>
        /// The result from the bot with logging and checking
        /// </summary>
        public string Output
        {
            get
            {
                if (OutputSentences.Count > 0)
                {
                    return RawOutput;
                }
                else
                {
                    if (request.hasTimedOut)
                    {
                        return bot.TimeOutMessage;
                    }
                    else
                    {
                        var paths = new StringBuilder();
                        foreach (string pattern in NormalizedPaths)
                        {
                            paths.Append(pattern + Environment.NewLine);
                        }
                        return string.Empty;
                    }
                }
            }
        }

        /// <summary>
        /// Returns the raw sentences without any logging
        /// </summary>
        public string RawOutput
        {
            get
            {
                var result = new StringBuilder();
                foreach (string sentence in OutputSentences)
                {
                    string sentenceForOutput = sentence.Trim();
                    if (!checkEndsAsSentence(sentenceForOutput))
                    {
                        sentenceForOutput += ".";
                    }
                    result.Append(sentenceForOutput + " ");
                }
                return result.ToString().Trim();
            }
        }

        /// <summary>
        /// Returns the raw output from the bot
        /// </summary>
        /// <returns>The raw output from the bot</returns>
        public override string ToString()
        {
            return Output;
        }

        /// <summary>
        /// Checks that the provided sentence ends with a sentence splitter
        /// </summary>
        /// <param name="sentence">the sentence to check</param>
        /// <returns>True if ends with an appropriate sentence splitter</returns>
        private bool checkEndsAsSentence(string sentence)
        {
            foreach (string splitter in bot.Splitters)
            {
                if (sentence.Trim().EndsWith(splitter))
                {
                    return true;
                }
            }
            return false;
        }
    }
}

namespace AIMLbot
{
    /// <summary>
    /// Encapsulates information and history of a user who has interacted with the bot
    /// </summary>
    public class User
    {
        #region Attributes

        /// <summary>
        /// A collection of all the result objects returned to the user in this session
        /// </summary>
        private readonly List<Result> Results = new List<Result>();

        /// <summary>
        /// The local instance of the GUID that identifies this user to the bot
        /// </summary>
        private readonly string id;

        /// <summary>
        /// the predicates associated with this particular user
        /// </summary>
        public SettingsDictionary Predicates;

        /// <summary>
        /// The bot this user is using
        /// </summary>
        public Bot bot;

        /// <summary>
        /// The GUID that identifies this user to the bot
        /// </summary>
        public string UserID
        {
            get { return id; }
        }

        /// <summary>
        /// the value of the "topic" predicate
        /// </summary>
        public string Topic
        {
            get { return Predicates.grabSetting("topic"); }
        }

        /// <summary>
        /// The most recent result to be returned by the bot
        /// </summary>
        public Result LastResult
        {
            get
            {
                if (Results.Count > 0)
                {
                    return Results[0];
                }
                else
                {
                    return null;
                }
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="UserID">The GUID of the user</param>
        /// <param name="bot">the bot the user is connected to</param>
        public User(string UserID, Bot bot)
        {
            if (UserID.Length > 0)
            {
                id = UserID;
                this.bot = bot;
                Predicates = new SettingsDictionary(this.bot);
                this.bot.DefaultPredicates.Clone(Predicates);
                Predicates.addSetting("topic", "*");
            }
            else
            {
                Logging.WriteDebug("The UserID cannot be empty");
            }
        }

        /// <summary>
        /// Returns the string to use for the next that part of a subsequent path
        /// </summary>
        /// <returns>the string to use for that</returns>
        public string getLastBotOutput()
        {
            if (Results.Count > 0)
            {
                return (Results[0]).RawOutput;
            }
            else
            {
                return "*";
            }
        }

        /// <summary>
        /// Returns the first sentence of the last output from the bot
        /// </summary>
        /// <returns>the first sentence of the last output from the bot</returns>
        public string getThat()
        {
            return getThat(0, 0);
        }

        /// <summary>
        /// Returns the first sentence of the output "n" steps ago from the bot
        /// </summary>
        /// <param name="n">the number of steps back to go</param>
        /// <returns>the first sentence of the output "n" steps ago from the bot</returns>
        public string getThat(int n)
        {
            return getThat(n, 0);
        }

        /// <summary>
        /// Returns the sentence numbered by "sentence" of the output "n" steps ago from the bot
        /// </summary>
        /// <param name="n">the number of steps back to go</param>
        /// <param name="sentence">the sentence number to get</param>
        /// <returns>the sentence numbered by "sentence" of the output "n" steps ago from the bot</returns>
        public string getThat(int n, int sentence)
        {
            if ((n >= 0) & (n < Results.Count))
            {
                Result historicResult = Results[n];
                if ((sentence >= 0) & (sentence < historicResult.OutputSentences.Count))
                {
                    return historicResult.OutputSentences[sentence];
                }
            }
            return string.Empty;
        }

        /// <summary>
        /// Returns the first sentence of the last output from the bot
        /// </summary>
        /// <returns>the first sentence of the last output from the bot</returns>
        public string getResultSentence()
        {
            return getResultSentence(0, 0);
        }

        /// <summary>
        /// Returns the first sentence from the output from the bot "n" steps ago
        /// </summary>
        /// <param name="n">the number of steps back to go</param>
        /// <returns>the first sentence from the output from the bot "n" steps ago</returns>
        public string getResultSentence(int n)
        {
            return getResultSentence(n, 0);
        }

        /// <summary>
        /// Returns the identified sentence number from the output from the bot "n" steps ago
        /// </summary>
        /// <param name="n">the number of steps back to go</param>
        /// <param name="sentence">the sentence number to return</param>
        /// <returns>the identified sentence number from the output from the bot "n" steps ago</returns>
        public string getResultSentence(int n, int sentence)
        {
            if ((n >= 0) & (n < Results.Count))
            {
                Result historicResult = Results[n];
                if ((sentence >= 0) & (sentence < historicResult.InputSentences.Count))
                {
                    return historicResult.InputSentences[sentence];
                }
            }
            return string.Empty;
        }

        /// <summary>
        /// Adds the latest result from the bot to the Results collection
        /// </summary>
        /// <param name="latestResult">the latest result from the bot</param>
        public void addResult(Result latestResult)
        {
            Results.Insert(0, latestResult);
        }

        #endregion
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// A utility class for loading AIML files from disk into the graphmaster structure that
    /// forms an AIML bot's "brain"
    /// </summary>
    public class AIMLLoader
    {
        #region Attributes

        /// <summary>
        /// The bot whose brain is being processed
        /// </summary>
        private readonly Bot bot;

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot whose brain is being processed</param>
        public AIMLLoader(Bot bot)
        {
            this.bot = bot;
        }

        #region Methods

        /// <summary>
        /// Loads the AIML from files found in the bot's AIMLpath into the bot's brain
        /// </summary>
        public void loadAIML()
        {
            loadAIML(bot.PathToAIML);
        }

        /// <summary>
        /// Loads the AIML from files found in the path
        /// </summary>
        /// <param name="path"></param>
        public void loadAIML(string path)
        {
            if (Directory.Exists(path))
            {
                // process the AIML
                string[] fileEntries = Directory.GetFiles(path, "*.aiml");
                if (fileEntries.Length > 0)
                {
                    foreach (string filename in fileEntries)
                    {
                        loadAIMLFile(filename);
                    }
                }
                else
                {
                    Logging.WriteDebug("Could not find any .aiml files in the specified directory (" + path +
                                       "). Please make sure that your aiml file end in a lowercase aiml extension, for example - myFile.aiml is valid but myFile.AIML is not.");
                }
            }
            else
            {
                Logging.WriteDebug("The directory specified as the path to the AIML files (" + path +
                                   ") cannot be found by the AIMLLoader object. Please make sure the directory where you think the AIML files are to be found is the same as the directory specified in the settings file.");
            }
        }

        /// <summary>
        /// Given the name of a file in the AIML path directory, attempts to load it into the
        /// graphmaster
        /// </summary>
        /// <param name="filename">The name of the file to process</param>
        public void loadAIMLFile(string filename)
        {
            // load the document
            var doc = new XmlDocument();
            doc.Load(filename);
            loadAIMLFromXML(doc, filename);
        }

        /// <summary>
        /// Given an XML document containing valid AIML, attempts to load it into the graphmaster
        /// </summary>
        /// <param name="doc">The XML document containing the AIML</param>
        /// <param name="filename">Where the XML document originated</param>
        public void loadAIMLFromXML(XmlDocument doc, string filename)
        {
            // Get a list of the nodes that are children of the <aiml> tag
            // these nodes should only be either <topic> or <category>
            // the <topic> nodes will contain more <category> nodes
            XmlNodeList rootChildren = doc.DocumentElement.ChildNodes;
            // process each of these child nodes
            foreach (XmlNode currentNode in rootChildren)
            {
                if (currentNode.Name == "topic")
                {
                    processTopic(currentNode, filename);
                }
                else if (currentNode.Name == "category")
                {
                    processCategory(currentNode, filename);
                }
            }
        }

        /// <summary>
        /// Given a "topic" node, processes all the categories for the topic and adds them to the
        /// graphmaster "brain"
        /// </summary>
        /// <param name="node">the "topic" node</param>
        /// <param name="filename">the file from which this node is taken</param>
        private void processTopic(XmlNode node, string filename)
        {
            // find the name of the topic or set to default "*"
            string topicName = "*";
            if ((node.Attributes.Count == 1) & (node.Attributes[0].Name == "name"))
            {
                topicName = node.Attributes["name"].Value;
            }
            // process all the category nodes
            foreach (XmlNode thisNode in node.ChildNodes)
            {
                if (thisNode.Name == "category")
                {
                    processCategory(thisNode, topicName, filename);
                }
            }
        }

        /// <summary>
        /// Adds a category to the graphmaster structure using the default topic ("*")
        /// </summary>
        /// <param name="node">the XML node containing the category</param>
        /// <param name="filename">the file from which this category was taken</param>
        private void processCategory(XmlNode node, string filename)
        {
            processCategory(node, "*", filename);
        }

        /// <summary>
        /// Adds a category to the graphmaster structure using the given topic
        /// </summary>
        /// <param name="node">the XML node containing the category</param>
        /// <param name="topicName">the topic to be used</param>
        /// <param name="filename">the file from which this category was taken</param>
        private void processCategory(XmlNode node, string topicName, string filename)
        {
            // reference and check the required nodes
            XmlNode pattern = FindNode("pattern", node);
            XmlNode template = FindNode("template", node);
            if (Equals(null, pattern))
            {
                Logging.WriteDebug("Missing pattern tag in a node found in " + filename);
            }
            if (Equals(null, template))
            {
                Logging.WriteDebug("Missing template tag in the node with pattern: " + pattern.InnerText + " found in " +
                                   filename);
            }
            string categoryPath = generatePath(node, topicName, false);
            // o.k., add the processed AIML to the GraphMaster structure
            if (categoryPath.Length > 0)
            {
                try
                {
                    bot.Graphmaster.addCategory(categoryPath, template.OuterXml, filename);
                    // keep count of the number of categories that have been processed
                    bot.Size++;
                }
                catch
                {
                }
            }
        }

        /// <summary>
        /// Generates a path from a category XML node and topic name
        /// </summary>
        /// <param name="node">the category XML node</param>
        /// <param name="topicName">the topic</param>
        /// <param name="isUserInput">marks the path to be created as originating from user input - so
        /// normalize out the * and _ wildcards used by AIML</param>
        /// <returns>The appropriately processed path</returns>
        public string generatePath(XmlNode node, string topicName, bool isUserInput)
        {
            // get the nodes that we need
            XmlNode pattern = FindNode("pattern", node);
            XmlNode that = FindNode("that", node);
            string patternText;
            string thatText = "*";
            if (Equals(null, pattern))
            {
                patternText = string.Empty;
            }
            else
            {
                patternText = pattern.InnerText;
            }
            if (!Equals(null, that))
            {
                thatText = that.InnerText;
            }
            return generatePath(patternText, thatText, topicName, isUserInput);
        }

        /// <summary>
        /// Given a name will try to find a node named "name" in the childnodes or return null
        /// </summary>
        /// <param name="name">The name of the node</param>
        /// <param name="node">The node whose children need searching</param>
        /// <returns>The node (or null)</returns>
        private XmlNode FindNode(string name, XmlNode node)
        {
            foreach (XmlNode child in node.ChildNodes)
            {
                if (child.Name == name)
                {
                    return child;
                }
            }
            return null;
        }

        /// <summary>
        /// Generates a path from the passed arguments
        /// </summary>
        /// <param name="pattern">the pattern</param>
        /// <param name="that">the that</param>
        /// <param name="topicName">the topic</param>
        /// <param name="isUserInput">marks the path to be created as originating from user input - so
        /// normalize out the * and _ wildcards used by AIML</param>
        /// <returns>The appropriately processed path</returns>
        public string generatePath(string pattern, string that, string topicName, bool isUserInput)
        {
            // to hold the normalized path to be entered into the graphmaster
            var normalizedPath = new StringBuilder();
            string normalizedPattern = string.Empty;
            string normalizedThat = "*";
            string normalizedTopic = "*";
            if ((bot.TrustAIML) & (!isUserInput))
            {
                normalizedPattern = pattern.Trim();
                normalizedThat = that.Trim();
                normalizedTopic = topicName.Trim();
            }
            else
            {
                normalizedPattern = Normalize(pattern, isUserInput).Trim();
                normalizedThat = Normalize(that, isUserInput).Trim();
                normalizedTopic = Normalize(topicName, isUserInput).Trim();
            }
            // check sizes
            if (normalizedPattern.Length > 0)
            {
                if (normalizedThat.Length == 0)
                {
                    normalizedThat = "*";
                }
                if (normalizedTopic.Length == 0)
                {
                    normalizedTopic = "*";
                }
                // This check is in place to avoid huge "that" elements having to be processed by the
                // graphmaster.
                if (normalizedThat.Length > bot.MaxThatSize)
                {
                    normalizedThat = "*";
                }
                // o.k. build the path
                normalizedPath.Append(normalizedPattern);
                normalizedPath.Append(" <that> ");
                normalizedPath.Append(normalizedThat);
                normalizedPath.Append(" <topic> ");
                normalizedPath.Append(normalizedTopic);
                return normalizedPath.ToString();
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Given an input, provide a normalized output
        /// </summary>
        /// <param name="input">The string to be normalized</param>
        /// <param name="isUserInput">True if the string being normalized is part of the user input path -
        /// flags that we need to normalize out * and _ chars</param>
        /// <returns>The normalized string</returns>
        public string Normalize(string input, bool isUserInput)
        {
            var result = new StringBuilder();
            // objects for normalization of the input
            var substitutor = new ApplySubstitutions(bot);
            var stripper = new StripIllegalCharacters(bot);
            string substitutedInput = substitutor.Transform(input);
            // split the pattern into it's component words
            string[] substitutedWords = substitutedInput.Split(" \r\n\t".ToCharArray());
            // Normalize all words unless they're the AIML wildcards "*" and "_" during AIML loading
            foreach (string word in substitutedWords)
            {
                string normalizedWord;
                if (isUserInput)
                {
                    normalizedWord = stripper.Transform(word);
                }
                else
                {
                    if ((word == "*") || (word == "_"))
                    {
                        normalizedWord = word;
                    }
                    else
                    {
                        normalizedWord = stripper.Transform(word);
                    }
                }
                result.Append(normalizedWord.Trim() + " ");
            }
            return result.ToString().Replace("  ", " "); // make sure the whitespace is neat
        }

        #endregion
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// The template for all classes that handle the AIML tags found within template nodes of a
    /// category.
    /// </summary>
    public abstract class AIMLTagHandler : TextTransformer
    {
        /// <summary>
        /// A flag to denote if inner tags are to be processed recursively before processing this tag
        /// </summary>
        public bool isRecursive = true;

        /// <summary>
        /// The query that produced this node containing the wildcard matches
        /// </summary>
        public SubQuery query;

        /// <summary>
        /// A representation of the input into the bot made by the user
        /// </summary>
        public Request request;

        /// <summary>
        /// A representation of the result to be returned to the user
        /// </summary>
        public Result result;

        /// <summary>
        /// The template node to be processed by the class
        /// </summary>
        public XmlNode templateNode;

        /// <summary>
        /// A representation of the user who made the request
        /// </summary>
        public User user;

        #region Helper methods

        /// <summary>
        /// Helper method that turns the passed string into an XML node
        /// </summary>
        /// <param name="outerXML">the string to XMLize</param>
        /// <returns>The XML node</returns>
        public static XmlNode getNode(string outerXML)
        {
            var temp = new XmlDocument();
            temp.LoadXml(outerXML);
            return temp.FirstChild;
        }

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot involved in this request</param>
        /// <param name="user">The user making the request</param>
        /// <param name="query">The query that originated this node</param>
        /// <param name="request">The request itself</param>
        /// <param name="result">The result to be passed back to the user</param>
        /// <param name="templateNode">The node to be processed</param>
        public AIMLTagHandler(Bot bot,
                              User user,
                              SubQuery query,
                              Request request,
                              Result result,
                              XmlNode templateNode)
            : base(bot, templateNode.OuterXml)
        {
            this.user = user;
            this.query = query;
            this.request = request;
            this.result = result;
            this.templateNode = templateNode;
            this.templateNode.Attributes.RemoveNamedItem("xmlns");
        }

        /// <summary>
        /// Default ctor to use when late binding
        /// </summary>
        public AIMLTagHandler()
        {
        }
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// A custom attribute to be applied to all custom tags in external "late bound" dlls
    /// </summary>
    [AttributeUsage(AttributeTargets.Class)]
    public class CustomTagAttribute : Attribute
    {
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// Used to determine the gender of things
    /// </summary>
    public enum Gender
    {
        Unknown = -1,
        Female = 0,
        Male = 1
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// Denotes what part of the input path a node represents.
    ///
    /// Used when pushing values represented by wildcards onto collections for
    /// the star, thatstar and topicstar AIML values.
    /// </summary>
    public enum MatchState
    {
        UserInput,
        That,
        Topic
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// Encapsulates a node in the graphmaster tree structure
    /// </summary>
    [Serializable]
    public class Node
    {
        #region Attributes

        /// <summary>
        /// Contains the child nodes of this node
        /// </summary>
        private readonly Dictionary<string, Node> children = new Dictionary<string, Node>();

        /// <summary>
        /// The AIML source for the category that defines the template
        /// </summary>
        public string filename = string.Empty;

        /// <summary>
        /// The template (if any) associated with this node
        /// </summary>
        public string template = string.Empty;

        /// <summary>
        /// The word that identifies this node to it's parent node
        /// </summary>
        public string word = string.Empty;

        /// <summary>
        /// The number of direct children (non-recursive) of this node
        /// </summary>
        public int NumberOfChildNodes
        {
            get { return children.Count; }
        }

        #endregion

        #region Methods

        #region Add category

        /// <summary>
        /// Adds a category to the node
        /// </summary>
        /// <param name="path">the path for the category</param>
        /// <param name="template">the template to find at the end of the path</param>
        /// <param name="filename">the file that was the source of this category</param>
        public void addCategory(string path, string template, string filename)
        {
            if (template.Length == 0)
            {
                Logging.WriteDebug("The category with a pattern: " + path + " found in file: " + filename +
                                   " has an empty template tag. ABORTING");
            }
            // check we're not at the leaf node
            if (path.Trim().Length == 0)
            {
                this.template = template;
                this.filename = filename;
                return;
            }
            // otherwise, this sentence requires further child nodemappers in order to
            // be fully mapped within the GraphMaster structure.
            // split the input into its component words
            string[] words = path.Trim().Split(" ".ToCharArray());
            // get the first word (to form the key for the child nodemapper)
            string firstWord = MakeCaseInsensitive.TransformInput(words[0]);
            // concatenate the rest of the sentence into a suffix (to act as the
            // path argument in the child nodemapper)
            string newPath = path.Substring(firstWord.Length, path.Length - firstWord.Length).Trim();
            // o.k. check we don't already have a child with the key from this sentence
            // if we do then pass the handling of this sentence down the branch to the
            // child nodemapper otherwise the child nodemapper doesn't yet exist, so create a new one
            if (children.ContainsKey(firstWord))
            {
                Node childNode = children[firstWord];
                childNode.addCategory(newPath, template, filename);
            }
            else
            {
                var childNode = new Node();
                childNode.word = firstWord;
                childNode.addCategory(newPath, template, filename);
                children.Add(childNode.word, childNode);
            }
        }

        #endregion

        #region Evaluate Node

        /// <summary>
        /// Navigates this node (and recusively into child nodes) for a match to the path passed as an argument
        /// whilst processing the referenced request
        /// </summary>
        /// <param name="path">The normalized path derived from the user's input</param>
        /// <param name="query">The query that this search is for</param>
        /// <param name="request">An encapsulation of the request from the user</param>
        /// <param name="matchstate">The part of the input path the node represents</param>
        /// <param name="wildcard">The contents of the user input absorbed by the AIML wildcards "_" and "*"</param>
        /// <returns>The template to process to generate the output</returns>
        public string evaluate(string path, SubQuery query, Request request, MatchState matchstate,
                               StringBuilder wildcard)
        {
            // check for timeout
            if (request.StartedOn.AddMilliseconds(request.bot.TimeOut) < DateTime.Now)
            {
                request.hasTimedOut = true;
                return string.Empty;
            }
            // so we still have time!
            path = path.Trim();
            // check if this is the end of a branch in the GraphMaster
            // return the cCategory for this node
            if (children.Count == 0)
            {
                if (path.Length > 0)
                {
                    // if we get here it means that there is a wildcard in the user input part of the
                    // path.
                    storeWildCard(path, wildcard);
                }
                return template;
            }
            // if we've matched all the words in the input sentence and this is the end
            // of the line then return the cCategory for this node
            if (path.Length == 0)
            {
                return template;
            }
            // otherwise split the input into it's component words
            string[] splitPath = path.Split(" \r\n\t".ToCharArray());
            // get the first word of the sentence
            string firstWord = MakeCaseInsensitive.TransformInput(splitPath[0]);
            // and concatenate the rest of the input into a new path for child nodes
            string newPath = path.Substring(firstWord.Length, path.Length - firstWord.Length);
            // first option is to see if this node has a child denoted by the "_"
            // wildcard. "_" comes first in precedence in the AIML alphabet
            if (children.ContainsKey("_"))
            {
                Node childNode = children["_"];
                // add the next word to the wildcard match
                var newWildcard = new StringBuilder();
                storeWildCard(splitPath[0], newWildcard);

                // move down into the identified branch of the GraphMaster structure
                string result = childNode.evaluate(newPath, query, request, matchstate, newWildcard);
                // and if we get a result from the branch process the wildcard matches and return
                // the result
                if (result.Length > 0)
                {
                    if (newWildcard.Length > 0)
                    {
                        // capture and push the star content appropriate to the current matchstate
                        switch (matchstate)
                        {
                            case MatchState.UserInput:
                                query.InputStar.Add(newWildcard.ToString());
                                // added due to this match being the end of the line
                                newWildcard.Remove(0, newWildcard.Length);
                                break;
                            case MatchState.That:
                                query.ThatStar.Add(newWildcard.ToString());
                                break;
                            case MatchState.Topic:
                                query.TopicStar.Add(newWildcard.ToString());
                                break;
                        }
                    }
                    return result;
                }
            }
            // second option - the nodemapper may have contained a "_" child, but led to no match
            // or it didn't contain a "_" child at all. So get the child nodemapper from this
            // nodemapper that matches the first word of the input sentence.
            if (children.ContainsKey(firstWord))
            {
                // process the matchstate - this might not make sense but the matchstate is working
                // with a "backwards" path: "topic <topic> that <that> user input"
                // the "classic" path looks like this: "user input <that> that <topic> topic"
                // but having it backwards is more efficient for searching purposes
                MatchState newMatchstate = matchstate;
                if (firstWord == "<THAT>")
                {
                    newMatchstate = MatchState.That;
                }
                else if (firstWord == "<TOPIC>")
                {
                    newMatchstate = MatchState.Topic;
                }
                Node childNode = children[firstWord];
                // move down into the identified branch of the GraphMaster structure using the new
                // matchstate
                var newWildcard = new StringBuilder();
                string result = childNode.evaluate(newPath, query, request, newMatchstate, newWildcard);
                // and if we get a result from the child return it
                if (result.Length > 0)
                {
                    if (newWildcard.Length > 0)
                    {
                        // capture and push the star content appropriate to the matchstate if it exists
                        // and then clear it for subsequent wildcards
                        switch (matchstate)
                        {
                            case MatchState.UserInput:
                                query.InputStar.Add(newWildcard.ToString());
                                newWildcard.Remove(0, newWildcard.Length);
                                break;
                            case MatchState.That:
                                query.ThatStar.Add(newWildcard.ToString());
                                newWildcard.Remove(0, newWildcard.Length);
                                break;
                            case MatchState.Topic:
                                query.TopicStar.Add(newWildcard.ToString());
                                newWildcard.Remove(0, newWildcard.Length);
                                break;
                        }
                    }
                    return result;
                }
            }
            // third option - the input part of the path might have been matched so far but hasn't
            // returned a match, so check to see it contains the "*" wildcard. "*" comes last in
            // precedence in the AIML alphabet.
            if (children.ContainsKey("*"))
            {
                // o.k. look for the path in the child node denoted by "*"
                Node childNode = children["*"];
                // add the next word to the wildcard match
                var newWildcard = new StringBuilder();
                storeWildCard(splitPath[0], newWildcard);
                string result = childNode.evaluate(newPath, query, request, matchstate, newWildcard);
                // and if we get a result from the branch process and return it
                if (result.Length > 0)
                {
                    if (newWildcard.Length > 0)
                    {
                        // capture and push the star content appropriate to the current matchstate
                        switch (matchstate)
                        {
                            case MatchState.UserInput:
                                query.InputStar.Add(newWildcard.ToString());
                                // added due to this match being the end of the line
                                newWildcard.Remove(0, newWildcard.Length);
                                break;
                            case MatchState.That:
                                query.ThatStar.Add(newWildcard.ToString());
                                break;
                            case MatchState.Topic:
                                query.TopicStar.Add(newWildcard.ToString());
                                break;
                        }
                    }
                    return result;
                }
            }
            // o.k. if the nodemapper has failed to match at all: the input contains neither
            // a "_", the sFirstWord text, or "*" as a means of denoting a child node. However,
            // if this node is itself representing a wildcard then the search continues to be
            // valid if we proceed with the tail.
            if ((word == "_") || (word == "*"))
            {
                storeWildCard(splitPath[0], wildcard);
                return evaluate(newPath, query, request, matchstate, wildcard);
            }
            // If we get here then we're at a dead end so return an empty string. Hopefully, if the
            // AIML files have been set up to include a "* <that> * <topic> *" catch-all this
            // state won't be reached. Remember to empty the surplus to requirements wildcard matches
            wildcard = new StringBuilder();
            return string.Empty;
        }

        /// <summary>
        /// Correctly stores a word in the wildcard slot
        /// </summary>
        /// <param name="word">The word matched by the wildcard</param>
        /// <param name="wildcard">The contents of the user input absorbed by the AIML wildcards "_" and "*"</param>
        private void storeWildCard(string word, StringBuilder wildcard)
        {
            if (wildcard.Length > 0)
            {
                wildcard.Append(" ");
            }
            wildcard.Append(word);
        }

        #endregion

        #endregion
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// A bespoke Dictionary<,> for loading, adding, checking, removing and extracting
    /// settings.
    /// </summary>
    public class SettingsDictionary
    {
        #region Attributes

        /// <summary>
        /// Contains an ordered collection of all the keys (unfortunately Dictionary<,>s are
        /// not ordered)
        /// </summary>
        private readonly List<string> orderedKeys = new List<string>();

        /// <summary>
        /// Holds a dictionary of settings
        /// </summary>
        private readonly Dictionary<string, string> settingsHash = new Dictionary<string, string>();

        /// <summary>
        /// The bot this dictionary is associated with
        /// </summary>
        protected Bot bot;

        /// <summary>
        /// The number of items in the dictionary
        /// </summary>
        public int Count
        {
            get { return orderedKeys.Count; }
        }

        /// <summary>
        /// An XML representation of the contents of this dictionary
        /// </summary>
        public XmlDocument DictionaryAsXML
        {
            get
            {
                var result = new XmlDocument();
                XmlDeclaration dec = result.CreateXmlDeclaration("1.0", "UTF-8", "");
                result.AppendChild(dec);
                XmlNode root = result.CreateNode(XmlNodeType.Element, "root", "");
                result.AppendChild(root);
                foreach (string key in orderedKeys)
                {
                    XmlNode item = result.CreateNode(XmlNodeType.Element, "item", "");
                    XmlAttribute name = result.CreateAttribute("name");
                    name.Value = key;
                    XmlAttribute value = result.CreateAttribute("value");
                    value.Value = settingsHash[key];
                    item.Attributes.Append(name);
                    item.Attributes.Append(value);
                    root.AppendChild(item);
                }
                return result;
            }
        }

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="bot">The bot for whom this is a settings dictionary</param>
        public SettingsDictionary(Bot bot)
        {
            this.bot = bot;
        }

        #region Methods

        /// <summary>
        /// Returns a collection of the names of all the settings defined in the dictionary
        /// </summary>
        /// <returns>A collection of the names of all the settings defined in the dictionary</returns>
        public string[] SettingNames
        {
            get
            {
                var result = new string[orderedKeys.Count];
                orderedKeys.CopyTo(result, 0);
                return result;
            }
        }

        /// <summary>
        /// Loads bespoke settings into the class from the file referenced in pathToSettings.
        ///
        /// The XML should have an XML declaration like this:
        ///
        /// <?xml version="1.0" encoding="utf-8" ?>
        ///
        /// followed by a <root> tag with child nodes of the form:
        ///
        /// <item name="name" value="value"/>
        /// </summary>
        /// <param name="pathToSettings">The file containing the settings</param>
        public void loadSettings(string pathToSettings)
        {
            if (pathToSettings.Length > 0)
            {
                var fi = new FileInfo(pathToSettings);
                if (fi.Exists)
                {
                    var xmlDoc = new XmlDocument();
                    xmlDoc.Load(pathToSettings);
                    loadSettings(xmlDoc);
                }
                else
                {
                    Logging.WriteDebug("file not found");
                }
            }
            else
            {
                Logging.WriteDebug("file not found");
            }
        }

        /// <summary>
        /// Loads bespoke settings to the class from the XML supplied in the args.
        ///
        /// The XML should have an XML declaration like this:
        ///
        /// <?xml version="1.0" encoding="utf-8" ?>
        ///
        /// followed by a <root> tag with child nodes of the form:
        ///
        /// <item name="name" value="value"/>
        /// </summary>
        /// <param name="settingsAsXML">The settings as an XML document</param>
        public void loadSettings(XmlDocument settingsAsXML)
        {
            // empty the hash
            clearSettings();
            XmlNodeList rootChildren = settingsAsXML.DocumentElement.ChildNodes;
            foreach (XmlNode myNode in rootChildren)
            {
                if ((myNode.Name == "item") & (myNode.Attributes.Count == 2))
                {
                    if ((myNode.Attributes[0].Name == "name") & (myNode.Attributes[1].Name == "value"))
                    {
                        string name = myNode.Attributes["name"].Value;
                        string value = myNode.Attributes["value"].Value;
                        if (name.Length > 0)
                        {
                            addSetting(name, value);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Adds a bespoke setting to the Settings class (accessed via the grabSettings(string name)
        /// method.
        /// </summary>
        /// <param name="name">The name of the new setting</param>
        /// <param name="value">The value associated with this setting</param>
        public void addSetting(string name, string value)
        {
            string key = MakeCaseInsensitive.TransformInput(name);
            if (key.Length > 0)
            {
                removeSetting(key);
                orderedKeys.Add(key);
                settingsHash.Add(MakeCaseInsensitive.TransformInput(key), value);
            }
        }

        /// <summary>
        /// Removes the named setting from this class
        /// </summary>
        /// <param name="name">The name of the setting to remove</param>
        public void removeSetting(string name)
        {
            string normalizedName = MakeCaseInsensitive.TransformInput(name);
            orderedKeys.Remove(normalizedName);
            removeFromHash(normalizedName);
        }

        /// <summary>
        /// Removes a named setting from the Dictionary<,>
        /// </summary>
        /// <param name="name">the key for the Dictionary<,></param>
        private void removeFromHash(string name)
        {
            string normalizedName = MakeCaseInsensitive.TransformInput(name);
            settingsHash.Remove(normalizedName);
        }

        /// <summary>
        /// Updates the named setting with a new value whilst retaining the position in the
        /// dictionary
        /// </summary>
        /// <param name="name">the name of the setting</param>
        /// <param name="value">the new value</param>
        public void updateSetting(string name, string value)
        {
            string key = MakeCaseInsensitive.TransformInput(name);
            if (orderedKeys.Contains(key))
            {
                removeFromHash(key);
                settingsHash.Add(MakeCaseInsensitive.TransformInput(key), value);
            }
        }

        /// <summary>
        /// Clears the dictionary to an empty state
        /// </summary>
        public void clearSettings()
        {
            orderedKeys.Clear();
            settingsHash.Clear();
        }

        /// <summary>
        /// Returns the value of a setting given the name of the setting
        /// </summary>
        /// <param name="name">the name of the setting whose value we're interested in</param>
        /// <returns>the value of the setting</returns>
        public string grabSetting(string name)
        {
            string normalizedName = MakeCaseInsensitive.TransformInput(name);
            if (containsSettingCalled(normalizedName))
            {
                return settingsHash[normalizedName];
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Checks to see if a setting of a particular name exists
        /// </summary>
        /// <param name="name">The setting name to check</param>
        /// <returns>Existential truth value</returns>
        public bool containsSettingCalled(string name)
        {
            string normalizedName = MakeCaseInsensitive.TransformInput(name);
            if (normalizedName.Length > 0)
            {
                return orderedKeys.Contains(normalizedName);
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Copies the values in the current object into the SettingsDictionary passed as the target
        /// </summary>
        /// <param name="target">The target to recieve the values from this SettingsDictionary</param>
        public void Clone(SettingsDictionary target)
        {
            foreach (string key in orderedKeys)
            {
                target.addSetting(key, grabSetting(key));
            }
        }

        #endregion
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// A container class for holding wildcard matches encountered during an individual path's
    /// interrogation of the graphmaster.
    /// </summary>
    public class SubQuery
    {
        #region Attributes

        /// <summary>
        /// The path that this query relates to
        /// </summary>
        public string FullPath;

        /// <summary>
        /// If the raw input matches a wildcard then this attribute will contain the block of
        /// text that the user has inputted that is matched by the wildcard.
        /// </summary>
        public List<string> InputStar = new List<string>();

        /// <summary>
        /// The template found from searching the graphmaster brain with the path
        /// </summary>
        public string Template = string.Empty;

        /// <summary>
        /// If the "that" part of the normalized path contains a wildcard then this attribute
        /// will contain the block of text that the user has inputted that is matched by the wildcard.
        /// </summary>
        public List<string> ThatStar = new List<string>();

        /// <summary>
        /// If the "topic" part of the normalized path contains a wildcard then this attribute
        /// will contain the block of text that the user has inputted that is matched by the wildcard.
        /// </summary>
        public List<string> TopicStar = new List<string>();

        #endregion

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="fullPath">The path that this query relates to</param>
        public SubQuery(string fullPath)
        {
            FullPath = fullPath;
        }
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// Encapsulates information about a custom tag class
    /// </summary>
    public class TagHandler
    {
        /// <summary>
        /// The assembly this class is found in
        /// </summary>
        public string AssemblyName;

        /// <summary>
        /// The class name for the assembly
        /// </summary>
        public string ClassName;

        /// <summary>
        /// The name of the tag this class will deal with
        /// </summary>
        public string TagName;

        /// <summary>
        /// Provides an instantiation of the class represented by this tag-handler
        /// </summary>
        /// <param name="Assemblies">All the assemblies the bot knows about</param>
        /// <returns>The instantiated class</returns>
        public AIMLTagHandler Instantiate(Dictionary<string, Assembly> Assemblies)
        {
            if (Assemblies.ContainsKey(AssemblyName))
            {
                Assembly tagDLL = Assemblies[AssemblyName];
                Type[] tagDLLTypes = tagDLL.GetTypes();
                return (AIMLTagHandler) tagDLL.CreateInstance(ClassName);
            }
            else
            {
                return null;
            }
        }
    }
}

namespace AIMLbot.Utils
{
    /// <summary>
    /// Encapsulates all the required methods and attributes for any text transformation.
    ///
    /// An input string is provided and various methods and attributes can be used to grab
    /// a transformed string.
    ///
    /// The protected ProcessChange() method is abstract and should be overridden to contain
    /// the code for transforming the input text into the output text.
    /// </summary>
    public abstract class TextTransformer
    {
        #region Attributes

        /// <summary>
        /// The bot that this transformation is connected with
        /// </summary>
        public Bot bot;

        /// <summary>
        /// Instance of the input string
        /// </summary>
        protected string inputString;

        /// <summary>
        /// The input string to be transformed in some way
        /// </summary>
        public string InputString
        {
            get { return inputString; }
            set { inputString = value; }
        }

        /// <summary>
        /// The transformed string
        /// </summary>
        public string OutputString
        {
            get { return Transform(); }
        }

        #endregion

        /// <summary>
        /// ctor
        /// </summary>
        /// <param name="bot">The bot this transformer is a part of</param>
        /// <param name="inputString">The input string to be transformed</param>
        public TextTransformer(Bot bot, string inputString)
        {
            this.bot = bot;
            this.inputString = inputString;
        }

        /// <summary>
        /// ctor
        /// </summary>
        /// <param name="bot">The bot this transformer is a part of</param>
        public TextTransformer(Bot bot)
        {
            this.bot = bot;
            inputString = string.Empty;
        }

        /// <summary>
        /// Default ctor for used as part of late binding mechanism
        /// </summary>
        public TextTransformer()
        {
            bot = null;
            inputString = string.Empty;
        }

        /// <summary>
        /// Do a transformation on the supplied input string
        /// </summary>
        /// <param name="input">The string to be transformed</param>
        /// <returns>The resulting output</returns>
        public string Transform(string input)
        {
            inputString = input;
            return Transform();
        }

        /// <summary>
        /// Do a transformation on the string found in the InputString attribute
        /// </summary>
        /// <returns>The resulting transformed string</returns>
        public string Transform()
        {
            if (inputString.Length > 0)
            {
                return ProcessChange();
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// The method that does the actual processing of the text.
        /// </summary>
        /// <returns>The resulting processed text</returns>
        protected abstract string ProcessChange();
    }
}

#endregion