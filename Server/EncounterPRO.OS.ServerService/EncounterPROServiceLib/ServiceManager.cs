//
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http:www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version.
//
using System;
using System.IO;
using System.Threading;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Collections;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;



namespace EncounterPRO.OS.ServerService.Lib
{
	/// <summary>
	/// Summary description for ServiceManager.
	/// </summary>
	public class ServiceManager
	{
		private static ServiceManager sm = null;
		private static string[] Args = null;

		private TcpChannel channel;

		private string[] dbConInfo = null;
		private ServiceThreadManager serviceThreadManager = null;
		private ServiceWrapper[] serviceWrappers = null;

		private Thread monitorMyHealthThread = null;

		private int RemotingPort=8089;
		private int MasterMemMaxMB=150;
		private int MaintQuerySleepTime=60000;
		private int MaintThreadMax=3;
		private int MaintThreadSleepTime=500;
		private int MaintQueryWaitTime=60000;
		private int MaintTimeout=10800000;
		private int ShortMaintTimeout=600000;
		private int MaintProcessPriority=3;
		private int MaintMemMaxMB=150;
		private int TaskQuerySleepTime=5000;
		private int TaskThreadMax=1;
		private int TaskThreadSleepTime=500;
		private int TaskQueryWaitTime=60000;
		private int TaskTimeout=600000;
		private int ShortTaskTimeout=60000;
		private int TaskProcessPriority=3;
		private int TaskMemMaxMB=150;
		private int ServiceExitInterval=3600000;
		private int ServiceExitMax=10;
		private int ServiceProcessPriority=3;
		private int ServiceMemMaxMB=150;
		private int StopProcessTimeout=30000;
		private int StartRetryMax=5;
		private int VerboseLogging=1;

		private string[] args = null;
		private bool shutdown = false;
		private bool running = false;
		private Thread mainLoopThread = null;
		private int startTryCount = 0;

		private long masterMemMax
		{
			get
			{
				return (((long)MasterMemMaxMB) * ((long)Math.Pow(2d,20d)));
			}
		}

		private ServiceManager(string[] Args)
		{
			args = Args;
			string databaseEntry = "<Default>";
			if(args.Length>0)
			{
				foreach(string arg in args)
				{
					if(arg.ToLower().StartsWith("database="))
					{
						databaseEntry = arg.Substring("database=".Length);
					}
				}
			}

			dbConInfo = GetDBEntry(databaseEntry);


			EPSEventLog.WriteEntry("SERVER="+dbConInfo[0]+Environment.NewLine+
				"DATABASE="+dbConInfo[1]);
		}
		public static void StartServices(string[] args)
		{
			Args = args;
			if(null==sm)
				sm = new ServiceManager(args);

			if(sm.mainLoopThread==null)
			{
				sm.KillActiveEproServerProcs();
				sm.mainLoopThread = new Thread(new ThreadStart(sm.mainLoop));
				sm.mainLoopThread.Start();
			}
			else
				throw new Exception("Service threads are already started");
		}
		private void KillActiveEproServerProcs()
		{
			ProcUtils.KillAll("eproserver.exe");
		}
		public static void StopServices()
		{
			if(null==sm)
				throw new Exception("No instance of ServiceManager is running");
			if(!sm.shutdown)
			{
				sm.shutdown=true;
				sm.stopServices();
				sm = null;
			}
			else
				throw new Exception("Service threads are already stopped");
		}
		private void mainLoop()
		{
			while (!shutdown)
			{
				SqlConnection con = null;
				try
				{
					con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
					con.Close();
					if(!running)
					{
						EPSEventLog.WriteEntry("Connection to "+dbConInfo[0]+"."+dbConInfo[1]+" is available.  Starting service threads...",EventLogEntryType.Information);
						startServices();
					}
				}
				catch(Exception exc)
				{
					if(running)
					{
						EPSEventLog.WriteEntry("Connection to "+dbConInfo[0]+"."+dbConInfo[1]+" is not available.  Stopping service threads..."+Environment.NewLine+Environment.NewLine+exc.ToString(),EventLogEntryType.Warning);
						stopServices();
					}
				}
				finally
				{
					try
					{
						con.Dispose();
					}
					catch{}
				}
				Thread.Sleep(5000);
				GC.Collect();
			}
		}

		public static string getServiceInfo()
		{
			if(null==sm)
				throw new Exception("No instance of ServiceManager is running");

			System.Data.SqlClient.SqlConnection con = InternalMethods.GetNewConnection(sm.dbConInfo[0], sm.dbConInfo[1]);
			SqlCommand cmd = null;

			try
			{
				System.IO.MemoryStream ms = new System.IO.MemoryStream();
				System.Xml.XmlTextWriter w = new System.Xml.XmlTextWriter(ms, System.Text.Encoding.UTF8);

				w.WriteStartDocument();
				w.WriteStartElement("ServiceInfo");

				if(sm.serviceWrappers!=null && sm.serviceWrappers.Length>0)
					foreach(ServiceWrapper sw in sm.serviceWrappers)
					{
						w.WriteStartElement("Service");
						try
						{
							w.WriteElementString("ID",sw.ServiceID.ToString());
							cmd = new SqlCommand("SELECT service_name FROM o_server_component WHERE service_id = "+sw.ServiceID.ToString(),con);
							string serviceName = (string)cmd.ExecuteScalar();
							w.WriteElementString("Description", serviceName);
							w.WriteElementString("PID",sw.PID.ToString());
							w.WriteElementString("RunningTime",Math.Round(sw.AgentProcess.Runtime.TotalHours,2).ToString()+" hours");
							w.WriteElementString("Memory",sw.CurrentMemoryMB.ToString()+" MB");
							w.WriteElementString("MaxMemory",Math.Round(((double)sw.AgentProcess.MaxMemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
						}
						catch{}
						w.WriteEndElement();
					}

				if(sm.serviceThreadManager!=null)
					{
                        ServiceThreadManager stm = sm.serviceThreadManager;

						w.WriteStartElement("ProcessPools");

						w.WriteStartElement("ProcessPool");
						w.WriteAttributeString("type", "short");
						w.WriteElementString("MaxProcesses", stm.sMaxRunningProcesses.ToString());
						w.WriteStartElement("QueuedProcesses");
						if(stm.sQueuedProcessArray!=null && stm.sQueuedProcessArray.Length>0)
							foreach(ProcessInfo pi in stm.sQueuedProcessArray)
							{
								w.WriteStartElement("QueuedProcess");
								try
								{
									w.WriteElementString("Application", pi.Application);
									w.WriteElementString("Arguments", pi.Arguments);
								}
								catch{}
								w.WriteEndElement();
							}
						w.WriteEndElement();
						w.WriteStartElement("RunningProcesses");
						if(stm.sRunningProcessArray!=null && stm.sRunningProcessArray.Length>0)
							foreach(AgentProcess ap in stm.sRunningProcessArray)
							{
								w.WriteStartElement("RunningProcess");
								// WPItem
								try
								{
									if(ap.Arguments.IndexOf("WPITEM")>-1)
									{
										w.WriteElementString("Type","WPItem");
										w.WriteElementString("ID", ap.TaskId.ToString());
										cmd = new SqlCommand("SELECT description FROM p_patient_wp_item WHERE patient_workplan_item_id = "+ap.TaskId.ToString(),con);
										string wpitem = (string)cmd.ExecuteScalar();
										w.WriteElementString("Description",wpitem);
										w.WriteElementString("User", ap.TaskUser);
										w.WriteElementString("PID", ap.ProcessId.ToString());
										w.WriteElementString("RunningTime", Math.Round(ap.Runtime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("MaxRunningTime", Math.Round(ap.MaxRuntime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("Memory",Math.Round(((double)ap.MemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("MaxMemory",Math.Round(((double)ap.MaxMemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										cmd = new SqlCommand("SELECT retries FROM p_patient_wp_item WHERE patient_workplan_item_id = " + ap.TaskId.ToString(),con);
										string retries = cmd.ExecuteScalar().ToString();
										w.WriteElementString("Retries",retries);
									}
										// Scheduled
									else if(ap.Arguments.IndexOf("SCHEDULE")>-1)
									{
										w.WriteElementString("Type","Scheduled");
										w.WriteElementString("ID", ap.TaskId.ToString());
										cmd = new SqlCommand("SELECT service FROM o_service_schedule WHERE service_sequence = "+ap.TaskId.ToString(),con);
										string service = (string)cmd.ExecuteScalar();
										w.WriteElementString("Description", service);
										w.WriteElementString("User",ap.TaskUser);
										w.WriteElementString("PID",ap.ProcessId.ToString());
										w.WriteElementString("RunningTime", Math.Round(ap.Runtime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("MaxRunningTime", Math.Round(ap.MaxRuntime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("Memory",Math.Round(((double)ap.MemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("MaxMemory",Math.Round(((double)ap.MaxMemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("Retries",null);
									}
								}
								catch{}
								w.WriteEndElement();
							}
						w.WriteEndElement();
						w.WriteEndElement();

						w.WriteStartElement("ProcessPool");
						w.WriteAttributeString("type", "long");
						w.WriteElementString("MaxProcesses", stm.lMaxRunningProcesses.ToString());
						w.WriteStartElement("QueuedProcesses");
						if(stm.lQueuedProcessArray!=null && stm.lQueuedProcessArray.Length>0)
							foreach(ProcessInfo pi in stm.lQueuedProcessArray)
							{
								w.WriteStartElement("QueuedProcess");
								try
								{

									w.WriteElementString("Application", pi.Application);
									w.WriteElementString("Arguments", pi.Arguments);
								}
								catch{}
								w.WriteEndElement();
							}
						w.WriteEndElement();
						w.WriteStartElement("RunningProcesses");
						if(stm.lRunningProcessArray!=null && stm.lRunningProcessArray.Length>0)
							foreach(AgentProcess ap in stm.lRunningProcessArray)
							{
								w.WriteStartElement("RunningProcess");
								try
								{
									// WPItem
									if(ap.Arguments.IndexOf("WPITEM")>-1)
									{
										w.WriteElementString("Type","WPItem");
										w.WriteElementString("ID", ap.TaskId.ToString());
										cmd = new SqlCommand("SELECT description FROM p_patient_wp_item WHERE patient_workplan_item_id = "+ap.TaskId.ToString(),con);
										string wpitem = (string)cmd.ExecuteScalar();
										w.WriteElementString("Description",wpitem);
										w.WriteElementString("User", ap.TaskUser);
										w.WriteElementString("PID", ap.ProcessId.ToString());
										w.WriteElementString("RunningTime", Math.Round(ap.Runtime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("MaxRunningTime", Math.Round(ap.MaxRuntime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("Memory",Math.Round(((double)ap.MemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("MaxMemory",Math.Round(((double)ap.MaxMemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										cmd = new SqlCommand("SELECT retries FROM p_patient_wp_item WHERE patient_workplan_item_id = " + ap.TaskId.ToString(),con);
										string retries = cmd.ExecuteScalar().ToString();
										w.WriteElementString("Retries",retries);
									}
										// Scheduled
									else if(ap.Arguments.IndexOf("SCHEDULE")>-1)
									{
										w.WriteElementString("Type","Scheduled");
										w.WriteElementString("ID", ap.TaskId.ToString());
										cmd = new SqlCommand("SELECT service FROM o_service_schedule WHERE service_sequence = "+ap.TaskId.ToString(),con);
										string service = (string)cmd.ExecuteScalar();
										w.WriteElementString("Description", service);
										w.WriteElementString("User",ap.TaskUser);
										w.WriteElementString("PID",ap.ProcessId.ToString());
										w.WriteElementString("RunningTime", Math.Round(ap.Runtime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("MaxRunningTime", Math.Round(ap.MaxRuntime.TotalMinutes,2).ToString()+" minutes");
										w.WriteElementString("Memory",Math.Round(((double)ap.MemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("MaxMemory",Math.Round(((double)ap.MaxMemoryUsage)/Math.Pow(2d,20d),2).ToString()+" MB");
										w.WriteElementString("Retries",null);
									}
								}
								catch{}
								w.WriteEndElement();
							}
						w.WriteEndElement();
						w.WriteEndElement();
						w.WriteEndElement();
					}
				w.WriteEndElement();
				w.WriteEndDocument();
				w.Flush();

				ms.Position=0;

				System.IO.StreamReader sr = new System.IO.StreamReader(ms, System.Text.Encoding.UTF8);
				string results = sr.ReadToEnd();
				sr.Close();

				return results;
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry(exc.ToString(), EventLogEntryType.Error);
				return null;
			}
			finally
			{
				try{con.Close();}
				catch{}
			}
		}

		private void startServices()
		{
			running=true;
			startTryCount++;
			if(startTryCount>StartRetryMax)
			{
				running=false;
				EPSEventLog.WriteEntry("Failed to start service threads "+StartRetryMax+" times in a row."+Environment.NewLine+
					"No more attempts will be made until the service is restarted.",EventLogEntryType.Error);
				return;
			}
			try
			{
				GetConfigValue(ref RemotingPort, "RemotingPort");
				GetConfigValue(ref MasterMemMaxMB, "MasterMemMaxMB");
				GetConfigValue(ref MaintQuerySleepTime, "MaintQuerySleepTime");
				GetConfigValue(ref MaintThreadMax, "MaintThreadMax");
				GetConfigValue(ref MaintThreadSleepTime, "MaintThreadSleepTime");
				GetConfigValue(ref MaintQueryWaitTime, "MaintQueryWaitTime");
				GetConfigValue(ref MaintTimeout, "MaintTimeout");
				GetConfigValue(ref ShortMaintTimeout, "ShortMaintTimeout");
				GetConfigValue(ref MaintProcessPriority, "MaintProcessPriority");
				GetConfigValue(ref MaintMemMaxMB, "MaintMemMaxMB");
				GetConfigValue(ref TaskQuerySleepTime, "TaskQuerySleepTime");
				GetConfigValue(ref TaskThreadMax, "TaskThreadMax");
				GetConfigValue(ref TaskThreadSleepTime, "TaskThreadSleepTime");
				GetConfigValue(ref TaskQueryWaitTime, "TaskQueryWaitTime");
				GetConfigValue(ref TaskTimeout, "TaskTimeout");
				GetConfigValue(ref ShortTaskTimeout, "ShortTaskTimeout");
				GetConfigValue(ref TaskProcessPriority, "TaskProcessPriority");
				GetConfigValue(ref TaskMemMaxMB, "TaskMemMaxMB");
				GetConfigValue(ref ServiceExitInterval, "ServiceExitInterval");
				GetConfigValue(ref ServiceExitMax, "ServiceExitMax");
				GetConfigValue(ref ServiceProcessPriority, "ServiceProcessPriority");
				GetConfigValue(ref ServiceMemMaxMB, "ServiceMemMaxMB");
				GetConfigValue(ref StopProcessTimeout, "StopProcessTimeout");
				GetConfigValue(ref StartRetryMax, "StartRetryMax");
				GetConfigValueBoolean(ref VerboseLogging, "VerboseLogging");
			
				// starting monitorMyHealthThread
				monitorMyHealthThread = new Thread(new ThreadStart(monitorMyHealth));
				monitorMyHealthThread.Start();

				// start remoting
				try
				{
					channel = new TcpChannel(RemotingPort);
					ChannelServices.RegisterChannel(channel);
					RemotingConfiguration.RegisterWellKnownServiceType(typeof(RemotingObject), "EncounterPROService", WellKnownObjectMode.SingleCall);
				}
				catch(Exception exc)
				{
					EPSEventLog.WriteEntry("Could not start remoting to support the EncounterPRO Agent monitor application.  The port ("+
						RemotingPort.ToString()+") may already be in use.  Services will continue to function properly, but the monitor application will not work."+
						"To change the port that EncounterPRO Agent uses to enable remoting, refer to the following JMJ KB article:"+Environment.NewLine+
						"https://www.jmjtech.com/kb/Article.aspx?ArticleNumber=10178"+Environment.NewLine+Environment.NewLine+
						exc.ToString(), System.Diagnostics.EventLogEntryType.Warning);
				}

				int computerID;

				computerID = GetComputerID();

				// Initiate ServiceThreadManager array
				serviceThreadManager = new ServiceThreadManager(dbConInfo[0],dbConInfo[1],computerID,MaintThreadMax,MaintQuerySleepTime,MaintThreadSleepTime,MaintQueryWaitTime,MaintTimeout,ShortMaintTimeout,MaintProcessPriority,MaintMemMaxMB,VerboseLogging,StopProcessTimeout);
				serviceThreadManager.StartManager();

				EPSEventLog.WriteEntry("Service thread manager started.",EventLogEntryType.Information);	
				startTryCount=0;
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Failed to start service threads."+Environment.NewLine+exc.ToString(),EventLogEntryType.Error);
				stopServices();
			}
		}

		private void stopServices()
		{
			running=false;
			try
			{
				// stop remoting
				try
				{
					ChannelServices.UnregisterChannel(channel);
					channel.StopListening(null);
					channel = null;
				}
				catch(Exception){}

				//DateTime StopTime = DateTime.Now;
				try
				{
                    serviceThreadManager.StopManager();
				}
				catch(Exception exc)
				{
					EPSEventLog.WriteEntry("Error stopping threads"+Environment.NewLine+exc.ToString(),EventLogEntryType.Error);
				}

				// Wait until all processes have stopped to proceed
				do
				{
					Thread.Sleep(100);
                } while (serviceThreadManager.sRunningProcesses + serviceThreadManager.lRunningProcesses > 0);


				EPSEventLog.WriteEntry("Services stopped.",EventLogEntryType.Information);
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error stopping services"+Environment.NewLine+exc.ToString(),EventLogEntryType.Error);
			}
		}

		private static string[] GetDBEntry(string DatabaseEntry)
		{
			string[] dbEntry = new string[2];
			string iniSection = "["+DatabaseEntry+"]";
			iniSection = iniSection.ToLower();
			string[] fields = new string[]{"dbserver","dbname"};
			string path = System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);
#if (DEBUG)
			path = @"C:\Program Files\JMJ\EncounterPRO Server";
#endif
			string iniFile = System.IO.Path.Combine(path,"EncounterPRO.ini");
			string iniContents = null;
			System.IO.StreamReader sr = new System.IO.StreamReader(iniFile);
			iniContents = sr.ReadToEnd().ToLower();
			sr.Close();

			int sectionContPos = iniContents.IndexOf(iniSection);
			if(sectionContPos<0)
				goto ERROR;
			sectionContPos += iniSection.Length;
			
			int current=0;
			foreach(string field in fields)
			{
				int fieldPos = iniContents.IndexOf(field,sectionContPos);
				if(fieldPos<0)
					goto ERROR;
				fieldPos = iniContents.IndexOf("=",fieldPos);
				if(fieldPos<0)
					goto ERROR;
				fieldPos+=1;
				dbEntry[current] = iniContents.Substring(fieldPos, iniContents.IndexOf(Environment.NewLine,fieldPos)-fieldPos).Trim();
				current++;
			}
            
			return dbEntry;

			ERROR:
				throw new Exception("Error getting "+DatabaseEntry+" information from "+iniFile);
		}
		private void GetConfigValueBoolean(ref int Value, string ConfigEntry)
		{
			string ls_value;

			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SERVERCONFIG', '"+ConfigEntry+"') FROM c_1_Record",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue || dbValue.ToString().Length < 1)
				return;

			ls_value = dbValue.ToString().Substring(0,1).ToUpper();
			if (ls_value.Length > 0)
				if (ls_value == "Y" || ls_value == "T")
					Value = 1;
				else
					Value = 0;

		}
		private void GetConfigValue(ref int Value, string ConfigEntry)
		{
			string ls_value;

			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SERVERCONFIG', '"+ConfigEntry+"') FROM c_1_Record",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			ls_value = dbValue.ToString();
			if (ls_value.Length > 0)
				Value = Int32.Parse(ls_value);
		}
		private void GetConfigValue(ref long Value, string ConfigEntry)
		{
			string ls_value;

			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SERVERCONFIG', '"+ConfigEntry+"') FROM c_1_Record",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			ls_value = dbValue.ToString();
			if (ls_value.Length > 0)
				Value = Int64.Parse(ls_value);
		}
		private void GetConfigValue(ref string Value, string ConfigEntry)
		{
			string ls_value;

			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SERVERCONFIG', '"+ConfigEntry+"') FROM c_1_Record",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			ls_value = dbValue.ToString();
			if (ls_value.Length > 0)
				Value = ls_value; 
		}
		private int GetComputerID()
		{
			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT TOP 1 computer_id "+
				"FROM o_Computers WHERE computername='"+
				Environment.MachineName+"' AND logon_id='"+
				Environment.UserName+"' AND status='OK'",con);
			// Get computer_id
			object computerID = cmd.ExecuteScalar();
			if(null==computerID)
			{
				// Create record and return computer_id
				try
				{
					cmd.CommandText = "INSERT o_Computers (computername, logon_id, status) "+
						"VALUES('"+Environment.MachineName+"','"+Environment.UserName+"','OK')";
					cmd.ExecuteNonQuery();
					cmd.CommandText = "SELECT TOP 1 computer_id "+
						"FROM o_Computers WHERE computername='"+
						Environment.MachineName+"' AND logon_id='"+
						Environment.UserName+"' AND status='OK'";
					computerID = cmd.ExecuteScalar();
					if(null==computerID)
						goto ERROR;					
				}
				catch
				{
					goto ERROR;
				}
			}
			con.Close();
			return Int32.Parse(computerID.ToString());
			ERROR:
				try
				{
					con.Close();
				}
				catch{}
			throw new Exception("Error creating o_Computers record for "+Environment.MachineName+"\\"+Environment.UserName);
		}
		private string[] GetSystemUserID(int ComputerID)
		{
			System.Collections.ArrayList userIDList = new ArrayList();
			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT DISTINCT system_user_id "+
				"FROM o_Server_Component WHERE computer_id="+ComputerID+
				" AND component_id = 'JMJ_SERVERSERVICE' AND status='OK'",con);
			SqlDataReader reader = cmd.ExecuteReader();
			while(reader.Read())
			{
				userIDList.Add(reader["system_user_id"].ToString());
			}
			reader.Close();
			con.Close();
			return (string[])userIDList.ToArray(Type.GetType("System.String"));
		}
		private int[] GetServiceID(int ComputerID)
		{
			System.Collections.ArrayList serviceIDList = new ArrayList();
			SqlConnection con = InternalMethods.GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT service_id "+
				"FROM o_Server_Component WHERE computer_id="+ComputerID+
				" AND component_id <> 'JMJ_SERVERSERVICE' AND status='OK'",con);
			SqlDataReader reader = cmd.ExecuteReader();
			while(reader.Read())
			{
				serviceIDList.Add(reader["service_id"].ToString());
			}
			reader.Close();
			con.Close();
			object[] res = serviceIDList.ToArray();
			int[] iRes = new int[res.Length];
			for(int i=0; i<iRes.Length; i++)
			{
				iRes[i]=Int32.Parse(res[i].ToString());
			}
			return iRes;
		}
/* moved to InternalMethods
		private SqlConnection GetNewConnection(string Server, string Database)
		{
			SqlConnection con = new SqlConnection("Server="+Server+";Database="+Database+";Integrated Security=SSPI;POOLING=FALSE");
			con.Open();
			try
			{
				string ls_pref;
				string ls_approlecred;
				string ls_sql;

				SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SYSTEM', 'system_bitmap') FROM c_1_Record",con);
				object dbValue = cmd.ExecuteScalar();
				if(null==dbValue)
				{
					ls_approlecred = "applesauce28";
				}
				else
				{
					ls_pref = dbValue.ToString(); 
					ls_approlecred = InternalMethods.DecryptString(ls_pref);
				}

				ls_sql = "sp_setapprole 'cprsystem', '" + ls_approlecred + "'";
				SqlCommand com = new SqlCommand(ls_sql, con);
				com.ExecuteNonQuery();
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error executing sp_setapprole:"+Environment.NewLine+exc.ToString(),EventLogEntryType.Error);
			}
			return con;
		}
*/
		private void monitorMyHealth()
		{
			try
			{
				int myPID = Process.GetCurrentProcess().Id;
				while(running)
				{
					uint workingSet = ProcUtils.GetProcessMemoryUsage(myPID).WorkingSetSize;
					if(workingSet>masterMemMax)
					{
						// If over limit for memory usage, stop and start self
						EPSEventLog.WriteEntry("MasterMemMaxMB="+MasterMemMaxMB.ToString()+Environment.NewLine+
							"Current Memory Usage (MB)="+(workingSet/Math.Pow(2d,20d)).ToString()+
							Environment.NewLine+"Shutting down all processes.", EventLogEntryType.Warning);
						ServiceManager.StopServices();
						GC.Collect();
						EPSEventLog.WriteEntry("Restarting processes.",EventLogEntryType.Warning);
						ServiceManager.StartServices(Args);
						return;
					}
					Thread.Sleep(5000);
					GC.Collect(); // Perform garbage collection
				}
			}
			catch(ThreadAbortException){}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error in monitorHealth() " + Environment.NewLine + exc.ToString(), EventLogEntryType.Error);
			}
		}
	}
}
