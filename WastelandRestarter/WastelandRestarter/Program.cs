using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Threading;

using BattleNET;

using MySql.Data.MySqlClient;

using NLog;

namespace WastelandRestarter
{
    class Program
    {
        private static readonly Logger logger = LogManager.GetLogger("RestarterLogger");

        static void Main(string[] args)
        {
            

            var credentials =
                new BattlEyeLoginCredentials(
                    Dns.GetHostAddresses(ConfigurationManager.AppSettings["host"])[0],
                    int.Parse(ConfigurationManager.AppSettings["port"]),
                    ConfigurationManager.AppSettings["password"]);

            var b = new BattlEyeClient(credentials);
            b.BattlEyeMessageReceived += BattlEyeMessageReceived;
            b.BattlEyeConnected += BattlEyeConnected;
            b.BattlEyeDisconnected += BattlEyeDisconnected;
            b.ReconnectOnPacketLoss = true;
            b.Connect();

            //b.SendCommand("say -1 Server will be locked for base and vehicle saving and restart after that");
            //while (b.CommandQueue > 0) { /* wait until server received packet */ };
            Thread.Sleep(10000);
            Console.WriteLine("Lock:");
            b.SendCommand("#lock");
            while (b.CommandQueue > 0) { /* wait until server received packet */ };

            logger.Info("Locked");

            Thread.Sleep(5);

            List<int> playerIds = null;

            while (playerIds == null || playerIds.Any())
            {
                playerIds = new List<int>();

                Console.WriteLine("Players:");
                b.SendCommand("players ");
                while (b.CommandQueue > 0) { /* wait until server received packet */ };

                var regex1 = Regex.Match(LastResult, @"Players\son\sserver:", RegexOptions.IgnoreCase | RegexOptions.Multiline);

                if (regex1.Captures.Count == 0)
                {
                    logger.Info(string.Join(",", regex1.Captures.Cast<Match>().Select(c => c.Value)));
                    playerIds = null;
                    continue;
                }

                var regex = Regex.Match(LastResult, @"(\d+)\s+[0-9.:]+\s+\d+\s+[0-9a-z]+");

                logger.Info(string.Join(",", regex.Captures.Cast<Match>().Select(c => c.Value)));

                foreach (Match match in regex.Captures)
                {
                    logger.Info(match.Groups[1].Value);
                    playerIds.Add(int.Parse(match.Groups[1].Value));
                }

                if (!playerIds.Any())
                {
                    logger.Info("No more players left");
                    break;
                }

                for (int i = playerIds.Max(); i >= 0; i--)
                {
                    b.SendCommand(string.Format("kick {0} Server Restart", i));
                    while (b.CommandQueue > 0)
                    {
                        /* wait until server received packet */
                    }
                }
            }

            logger.Info("Kicked players");

            var conn = new MySqlConnection(ConfigurationManager.AppSettings["DBConnectionString"]);
            conn.Open();

            var command = conn.CreateCommand();
            command.CommandText = @"UPDATE `triggers` SET `Condition`=1 WHERE Name=""DoSave""";
            command.ExecuteNonQuery();

            logger.Info("Saving Bases and Vehicles");

            command.CommandText = @"SELECT `Condition` FROM `triggers` WHERE Name=""DoSave""";

            var cond = false;

            while (!cond)
            {
                object result = null;
                try
                {
                    result = command.ExecuteScalar();
                    cond = ((uint)result) == 0; //wait for save to be done
                }
                catch (Exception ex)
                {
                    logger.ErrorException(string.Format("Waiting for save to be finished: {0}", result), ex);
                }
                Thread.Sleep(1000);
            }

            b.SendCommand("#shutdown");

            logger.Info("shutdown");

            var path = string.Format(
                @"{0}MPMissions\ArmA3_Wasteland.Altis.pbo",
                ConfigurationManager.AppSettings["Arma3Path"]);
            var path2 = string.Format(
                @"{0}Deploy\ArmA3_Wasteland.Altis.pbo",
                ConfigurationManager.AppSettings["Arma3Path"]);


            if (File.Exists(path2))
            {
                try
                {
                    WaitForFileNotLocked(path);

                    File.Copy(
                        path,
                        string.Format(
                            @"{0}MPMissions\Backup\ArmA3_Wasteland.Altis.{1}.pbo",
                            ConfigurationManager.AppSettings["Arma3Path"],
                            DateTime.Now.ToString("yy-mm-dd-hh-MM")));

                    WaitForFileNotLocked(path);

                    File.Copy(
                        path2,
                        path,
                        true);

                    WaitForFileNotLocked(path);

                    File.Delete(path2);
                }
                catch (Exception ex)
                {
                    logger.Info(path);
                    logger.ErrorException("Couldn't copy mission file", ex);
                }
            }
            
        }

        private static void WaitForFileNotLocked(string path)
        {
            var open = true;

            while (open)
            {
                try
                {
                    using (File.Open(path, FileMode.Open))
                    {
                    }
                }
                catch (IOException)
                {
                    continue;
                }

                open = false;
            }
        }

        private static string LastResult { get; set; }

        private static void BattlEyeConnected(BattlEyeConnectEventArgs args)
        {
            //if (args.ConnectionResult == BattlEyeConnectionResult.Success) { /* Connected successfully */ }
            //if (args.ConnectionResult == BattlEyeConnectionResult.InvalidLogin) { /* Connection failed, invalid login details */ }
            //if (args.ConnectionResult == BattlEyeConnectionResult.ConnectionFailed) { /* Connection failed, host unreachable */ }

            Console.WriteLine(args.Message);
        }

        private static void BattlEyeDisconnected(BattlEyeDisconnectEventArgs args)
        {
            //if (args.DisconnectionType == BattlEyeDisconnectionType.ConnectionLost) { /* Connection lost (timeout), if ReconnectOnPacketLoss is set to true it will reconnect */ }
            //if (args.DisconnectionType == BattlEyeDisconnectionType.SocketException) { /* Something went terribly wrong... */ }
            //if (args.DisconnectionType == BattlEyeDisconnectionType.Manual) { /* Disconnected by implementing application, that would be you */ }

            Console.WriteLine(args.Message);
        }

        private static void BattlEyeMessageReceived(BattlEyeMessageEventArgs args)
        {
            LastResult = args.Message;

            logger.Info(args.Message);

            Console.WriteLine(args.Message);
        }
    }
}
