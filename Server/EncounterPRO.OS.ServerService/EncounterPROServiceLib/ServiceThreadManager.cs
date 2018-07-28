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
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System.Threading;

namespace EncounterPRO.OS.ServerService.Lib
{
	public enum ServiceTypeEnum
	{
		WorkplanItem,
		ScheduledService
	}
	public struct ServiceThreadInfo
	{
		private string systemUserID;
		private long idNumber;
		private ServiceTypeEnum serviceType;

		public string SystemUserID
		{
			get{return systemUserID;}
		}

		public long IDNumber
		{
			get{return idNumber;}
		}

		public ServiceTypeEnum ServiceType
		{
			get{return serviceType;}
		}

		public ServiceThreadInfo(string SystemUserID, int IDNumber, ServiceTypeEnum ServiceType)
		{
			systemUserID = SystemUserID;
			idNumber = IDNumber;
			serviceType = ServiceType;
		}
	}

	public delegate object GetQueuedItemDelegate(string SystemUserID);
	public delegate void FinishedWithItemDelegate(object Item);

	/// <summary>
	/// Summary description for ServiceThreadManager.
	/// </summary>
	public class ServiceThreadManager
	{
		public string Server = null;
		public string Database = null;
		public int ComputerID;
		private int MainServiceLoopSleepTime;
		private int ThreadSleepTime;
		private int QueryWaitTime;
		private AgentProcessPool shortPool = null;
		private AgentProcessPool longPool = null;
		private Thread mainLoopThread = null;
		private bool keepRunning = true;

		public ServiceThreadManager(string Server, string Database, int ComputerID,
			int ThreadMax, int MainServiceLoopSleepTime, 
			int ThreadSleepTime, int QueryWaitTime, int TaskTimeout, int ShortTimeout,
			int TaskProcessPriority, int TaskMemMaxMB, int VerboseLogging,
			int StopProcessTimeout)
		{
			this.Server = Server;
			this.Database = Database;
			this.ComputerID = ComputerID;
			this.MainServiceLoopSleepTime = MainServiceLoopSleepTime;
			this.ThreadSleepTime = ThreadSleepTime;
			this.QueryWaitTime = QueryWaitTime;

			shortPool = new AgentProcessPool();
			shortPool.AutoRestartProcesses=false;
			shortPool.MaxPerProcessMemoryUsage=(uint)(TaskMemMaxMB*Math.Pow(2d,20d));
			shortPool.MaxPerProcessRuntime=TimeSpan.FromMilliseconds(ShortTimeout);
			shortPool.StopProcessTimeout=TimeSpan.FromMilliseconds(StopProcessTimeout);
			shortPool.MaxRunningProcesses=ThreadMax;

			longPool = new AgentProcessPool();
			longPool.AutoRestartProcesses=false;
			longPool.MaxPerProcessMemoryUsage=(uint)(TaskMemMaxMB*Math.Pow(2d,20d));
			longPool.MaxPerProcessRuntime=TimeSpan.FromMilliseconds(TaskTimeout);
			longPool.StopProcessTimeout=TimeSpan.FromMilliseconds(StopProcessTimeout);
			longPool.MaxRunningProcesses=ThreadMax;

			switch(TaskProcessPriority)
			{
				case 1:
					shortPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.Idle;
					longPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.Idle;
					break;
				case 2:
					shortPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.BelowNormal;
					longPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.BelowNormal;
					break;
				case 3:
				default:
					shortPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.Normal;
					longPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.Normal;
					break;
				case 4:
					shortPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.AboveNormal;
					longPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.AboveNormal;
					break;
				case 5:
					shortPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.High;
					longPool.ProcessPriority=System.Diagnostics.ProcessPriorityClass.High;
					break;
			}
			shortPool.VerboseLogging=(VerboseLogging==1);
			longPool.VerboseLogging=(VerboseLogging==1);

			shortPool.ProcessStopping+=new EventHandler(shortPool_ProcessStopping);
			shortPool.ProcessNotHealthy+=new EventHandler(shortPool_ProcessNotHealthy);
			longPool.ProcessStopping+=new EventHandler(longPool_ProcessStopping);
			longPool.ProcessNotHealthy+=new EventHandler(longPool_ProcessNotHealthy);
		}

		public void StartManager()
		{
			keepRunning=true;
			shortPool.Start();
			longPool.Start();
			mainLoopThread = new Thread(new ThreadStart(MainServiceLoop));
			mainLoopThread.Start();
		}

		public void StopManager()
		{
			keepRunning = false;
			shortPool.StopAsync();
			longPool.StopAsync();
		}

		public int sQueued
		{
			get{return shortPool.QueuedProcesses;}
		}
		public int sRunningProcesses
		{
			get{return shortPool.RunningProcesses;}
		}
		public int lQueued
		{
			get{return longPool.QueuedProcesses;}
		}
		public int lRunningProcesses
		{
			get{return longPool.RunningProcesses;}
		}

		public int sMaxRunningProcesses
		{
			get{return shortPool.MaxRunningProcesses;}
		}
		public int lMaxRunningProcesses
		{
			get{return longPool.MaxRunningProcesses;}
		}

		public AgentProcess[] sRunningProcessArray
		{
			get
			{
				return shortPool.RunningProcessesArray;
			}
		}

		public AgentProcess[] lRunningProcessArray
		{
			get
			{
				return longPool.RunningProcessesArray;
			}
		}

		public ProcessInfo[] sQueuedProcessArray
		{
			get
			{
				return shortPool.QueuedProcessesArray;
			}
		}

		public ProcessInfo[] lQueuedProcessArray
		{
			get
			{
				return longPool.QueuedProcessesArray;
			}
		}
		

		private void Dispose()
		{

		}
/* moved to InternalMethods
		public static SqlConnection GetNewConnection(string Server, string Database)
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
		private void MainServiceLoop()
		{
#if(DEBUG)
			string path = @"C:\Program Files\JMJ\EncounterPRO Server";
#else
			string path = System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);
#endif
			EventLog log = new EventLog("Application",Environment.MachineName,"EncounterPROService");
			SqlConnection sqlCon = null;

			CONNECT:
				try
				{
					sqlCon = InternalMethods.GetNewConnection(Server,Database);
				}
				catch
				{
					return;
				}

			SqlCommand cmd = null;
			SqlDataReader rdr = null;

			// Remove locks before starting
			try
			{
				cmd = new SqlCommand("DELETE o_user_service_lock WHERE computer_id = "+ComputerID.ToString(),sqlCon);
				cmd.ExecuteNonQuery();

				cmd = new SqlCommand("DELETE o_users WHERE computer_id = "+ComputerID.ToString(),sqlCon);
				cmd.ExecuteNonQuery();
			}
			catch(Exception exc)
			{
				log.WriteEntry("Failed to clean up locks and users"+Environment.NewLine+exc.ToString(),EventLogEntryType.Warning);
			}
			

			DateTime LastRuntime = DateTime.Now;
			try
			{
				while(keepRunning)
				{
					try
					{
						if((shortPool.QueuedProcesses+longPool.QueuedProcesses)==0 || LastRuntime.AddMilliseconds(QueryWaitTime)>DateTime.Now)
						{
							LastRuntime = DateTime.Now;

                            cmd = new SqlCommand("EXEC jmjsys_ready_server_services", sqlCon);
							// EXECUTE SP TO GET WAITING SERVICES
							try
							{
								rdr = cmd.ExecuteReader();
							}
							catch(SqlException sexc)
							{
								log.WriteEntry(sexc.ToString()+Environment.NewLine+Environment.NewLine+cmd.CommandText,EventLogEntryType.Error);
								continue;
							}
							catch(InvalidOperationException ioc)
							{// Likely DB disconnect
								log.WriteEntry(ioc.ToString(), EventLogEntryType.Error);
								goto CONNECT;
							}
							catch(Exception exc)
							{
								log.WriteEntry(exc.ToString(), EventLogEntryType.Error);
								continue;
							}
							try
							{
								while(rdr.Read())
								{
									string ls_arg;
									string ls_item_type;
									ls_item_type = rdr["item_type"].ToString().ToUpper();
									if (ls_item_type == "SERVICE")
										ls_arg = "WPITEM=" + rdr["patient_workplan_item_id"].ToString();
									else
										ls_arg = ls_item_type + "=" + rdr["patient_workplan_item_id"].ToString();

									ProcessInfo newPI = new ProcessInfo(System.IO.Path.Combine(path,"EproServer.exe"), ls_arg);

									if(!rdr.IsDBNull(rdr.GetOrdinal("retries")))
										// ADD WAITING RETRY SERVICES TO LONG QUEUE
										longPool.Enqueue(newPI);
									else
										// ADD WAITING FIRST TIME SERVICES TO SHORT QUEUE 
										// IF IT HAS NOT BEEN MOVED TO LONG QUEUE ALREADY
										if(!longPool.IsRunning(newPI))
										shortPool.Enqueue(newPI);
								}
							}
							catch(SqlException sexc)
							{
								log.WriteEntry(sexc.ToString(),EventLogEntryType.Error);
								continue;
							}
							rdr.Close();
						}
						Thread.Sleep(MainServiceLoopSleepTime);
					}
					catch(Exception exc)
					{
						try
						{
							rdr.Close();
						}
						catch{}
						log.WriteEntry(exc.ToString(), EventLogEntryType.Error);
					}
				}
			}
			finally
			{
				//EPSEventLog.WriteEntry("Exited main loop in ServiceThreadManager");
			}
			sqlCon.Close();
		}


		public bool IsLocked(int ComputerID, long ServiceID, string SystemUserID)
		{
			SqlConnection con = InternalMethods.GetNewConnection(Server, Database);
			SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM "+
				"o_User_Service_Lock WHERE patient_workplan_item_id = '"+
				ServiceID+"' AND user_id = '"+SystemUserID+"' AND "+
				"computer_id = "+ComputerID.ToString(),con);
			int lockCount = (int)cmd.ExecuteScalar();
			return (lockCount>0);
		}

		public void RemoveLock(int ComputerID, long ServiceID, string SystemUserID)
		{
			SqlConnection con = InternalMethods.GetNewConnection(Server,Database);
			SqlCommand cmd = new SqlCommand("DELETE FROM o_User_Service_Lock "+
				"WHERE patient_workplan_item_id = "+ServiceID+" "+
				"AND user_id = '"+SystemUserID+"' AND computer_id = "+
				ComputerID.ToString(),con);
			cmd.ExecuteNonQuery();
		}

		public void ServiceError(long WorkplanItemID, string SystemUserID)
		{
			SqlConnection con = InternalMethods.GetNewConnection(Server,Database);
			SqlCommand cmd = new SqlCommand("EXEC jmj_set_service_error "+
				WorkplanItemID.ToString()+", '"+SystemUserID+"','"+SystemUserID+"','N'",con);
			try
			{
				cmd.ExecuteNonQuery();
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error in ServiceError()"+Environment.NewLine+
					exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
			}
		}

		private void shortPool_ProcessStopping(object sender, EventArgs e)
		{
			AgentProcess p = (AgentProcess)sender;
			if(p.Arguments.StartsWith("WPITEM"))
			{ // only call service error for WPITEM problems
				ServiceError(p.TaskId, p.TaskUser);
			}
		}

		private void longPool_ProcessStopping(object sender, EventArgs e)
		{
			AgentProcess p = (AgentProcess)sender;
			if(p.Arguments.StartsWith("WPITEM"))
			{ // only call service error for WPITEM problems
				ServiceError(p.TaskId, p.TaskUser);
			}
		}

		private void shortPool_ProcessNotHealthy(object sender, EventArgs e)
		{
			
			AgentProcess p = (AgentProcess)sender;
			
			// Check whether service timed out
			if(p.Runtime>p.MaxRuntime)
			{ // Service timed out
				// Attempt to add the process to the long pool.
				// Increase timeout
				p.MaxRuntime = longPool.MaxPerProcessRuntime;
				if(!longPool.AddProcess(p))
				{
					EPSEventLog.WriteEntry("Extended queue rejected process.  Process will be terminated."+Environment.NewLine+
						p.ToString(), System.Diagnostics.EventLogEntryType.Warning);
					p.Stop(); // Stop the process if the long pool will not accept it.
				}
				else
				{ // Must call RemoveProcess AFTER any possible process stopping,
					//because RemoveProcess unregisters events
					shortPool.RemoveProcess(p);
					EPSEventLog.WriteEntry("Process was moved to extended queue."+Environment.NewLine+
						p.ToString(), System.Diagnostics.EventLogEntryType.Warning);
				}
			}
			else
			{ // Service exceeded memory limit
				EPSEventLog.WriteEntry("Process has exceeded maximum allowed memory.  Process will be terminated."+Environment.NewLine+
					p.ToString(), System.Diagnostics.EventLogEntryType.Warning);
				p.Stop();
			}
		}

		private void longPool_ProcessNotHealthy(object sender, EventArgs e)
		{
			// Stop unhealthy processes in long pool
			AgentProcess p = (AgentProcess)sender;
			// Check whether service timed out
			if(p.Runtime>p.MaxRuntime)
			{ // Service timed out
				EPSEventLog.WriteEntry("Process timed out in extended queue.  Process will be terminated."+Environment.NewLine+
					p.ToString(), System.Diagnostics.EventLogEntryType.Warning);
				p.Stop();
			}
			else
			{ // Service exceeded memory limit
				EPSEventLog.WriteEntry("Process has exceeded maximum allowed memory.  Process will be terminated."+Environment.NewLine+
					p.ToString(), System.Diagnostics.EventLogEntryType.Warning);
				p.Stop();
			}
		}
	}
}

