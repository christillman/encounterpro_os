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
using System.Threading;
using System.Diagnostics;

namespace EncounterPRO.OS.ServerService.Lib
{
	/// <summary>
	/// Summary description for ServiceWrapper.
	/// </summary>
	public class ServiceWrapper
	{
		private AgentProcess p = null;
		public AgentProcess AgentProcess
		{
			get{return p;}
		}
		private System.Collections.ArrayList exitTimes = new System.Collections.ArrayList();
		public int ServiceID;
//		public int PID;
		public int PID
		{
			get{return p.ProcessId;}
		}
		private Thread healthMonThread = null;
//		private Thread ServiceThread = null;
//		private Process workerProcess = null;
		private bool keepRunning = false;
		private int exitInterval;
		private int exitMax;
//		private int serviceProcessPriority;
//		private int serviceMemMaxMB;
//		private bool verboseLogging=true;

		public double CurrentMemoryMB
		{
			get
			{
				return Math.Round(p.MemoryUsage/Math.Pow(2d,20d),2);
//				if(workerProcess!=null && !workerProcess.HasExited)
//				{
//					uint workingSet = ProcUtils.GetProcessMemoryUsage(workerProcess.Id).WorkingSetSize;
//					return Math.Round((workingSet / Math.Pow(2d,20d)),2);
//				}
//				else
//					return 0;
			}
		}
//
//		private long serviceMemMax
//		{
//			get
//			{
//				return (((long)serviceMemMaxMB) * ((long)Math.Pow(2d,20d)));
//			}
//		}

		public ServiceWrapper(int ServiceID, int ExitInterval, int ExitMax, int ServiceProcessPriority, int ServiceMemMaxMB, int VerboseLogging, int StopProcessTimeout)
		{
			string path = System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);

			exitInterval = ExitInterval;
			exitMax = ExitMax;
//			serviceProcessPriority = ServiceProcessPriority;
			this.ServiceID = ServiceID;
//			this.serviceMemMaxMB=ServiceMemMaxMB;
//			verboseLogging = VerboseLogging==1;
			p = new AgentProcess();
			p.Application = System.IO.Path.Combine(path,"EproServer.exe");
			p.Arguments="SERVICE="+this.ServiceID.ToString();
			p.MaxMemoryUsage=(uint)(ServiceMemMaxMB*Math.Pow(2d,20d));
			p.StopProcessTimeout=TimeSpan.FromMilliseconds(StopProcessTimeout);
			p.VerboseLogging=VerboseLogging==1;
			switch(ServiceProcessPriority)
			{
				case 1:
					p.Priority=System.Diagnostics.ProcessPriorityClass.Idle;
					break;
				case 2:
					p.Priority=System.Diagnostics.ProcessPriorityClass.BelowNormal;
					break;
				case 3:
				default:
					p.Priority=System.Diagnostics.ProcessPriorityClass.Normal;
					break;
				case 4:
					p.Priority=System.Diagnostics.ProcessPriorityClass.AboveNormal;
					break;
				case 5:
					p.Priority=System.Diagnostics.ProcessPriorityClass.High;
					break;
			}
			p.Started+=new EventHandler(p_Started);
			p.Stopped+=new EventHandler(p_Stopped);
			p.Stopping+=new EventHandler(p_Stopping);
		}
		public void StartService()
		{
//			if(null!=ServiceThread)
//				throw new Exception("ServiceThread already exists!");
//			ServiceThread = new Thread(new ThreadStart(StartServiceThread));
			keepRunning=true;
//			ServiceThread.Start();
			p.Start();
			healthMonThread = new Thread(new System.Threading.ThreadStart(monitorHealth));
			healthMonThread.Start();

		}
		public void StopService()
		{
			keepRunning = false;
			p.StopAsync();
//			try
//			{
//				keepRunning=false;
//				workerProcess.CloseMainWindow();
//			}
//			catch(Exception exc)
//			{
//				throw exc;
//			}
		}
//		public void KillService()
//		{
//			try
//			{
//				keepRunning=false;
//				workerProcess.Kill();
//			}
//			catch(Exception exc)
//			{
//				throw exc;
//			}
//		}
		public bool IsAlive()
		{
			return p.IsRunning;
//			if(null==workerProcess)
//				return false;
//			return !workerProcess.HasExited;
		}
//		private void StartServiceThread()
//		{
//			string path = System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);
//#if (DEBUG)
//			path = @"C:\Program Files\JMJ\EncounterPRO Server";
//#endif
//			while(keepRunning)
//			{
//				try
//				{
//					try
//					{
//						workerProcess = new Process();
//						workerProcess.StartInfo = new ProcessStartInfo(System.IO.Path.Combine(path,"EproServer.exe"),"SERVICE="+ServiceID.ToString());
//						workerProcess.StartInfo.UseShellExecute=false;
//						EPSEventLog.WriteEntry("Starting Service Process."+Environment.NewLine+
//							"FileName="+workerProcess.StartInfo.FileName+Environment.NewLine+
//							"Arguments="+workerProcess.StartInfo.Arguments,EventLogEntryType.Information);
//						workerProcess.Start();
//						PID = workerProcess.Id;
//						if(verboseLogging)
//							EPSEventLog.WriteEntry("PID = "+workerProcess.Id.ToString()+Environment.NewLine+"EXECUTING:"+Environment.NewLine+"ServiceID = "+ServiceID.ToString()+
//								Environment.NewLine+workerProcess.StartInfo.FileName+" "+workerProcess.StartInfo.Arguments,EventLogEntryType.Information);
//
//						// start another thread to monitor process health
//						Thread healthMonThread = new Thread(new System.Threading.ThreadStart(monitorHealth));
//						healthMonThread.Start();
//
//						switch(serviceProcessPriority)
//						{
//							case 1:
//								workerProcess.PriorityClass = ProcessPriorityClass.Idle;
//								break;
//							case 2:
//								workerProcess.PriorityClass = ProcessPriorityClass.BelowNormal;
//								break;
//							case 3:
//								workerProcess.PriorityClass = ProcessPriorityClass.Normal;
//								break;
//							case 4:
//								workerProcess.PriorityClass = ProcessPriorityClass.AboveNormal;
//								break;
//							case 5:
//								workerProcess.PriorityClass = ProcessPriorityClass.High;
//								break;
//						}
//						workerProcess.WaitForExit();
//					}
//					catch(Exception exc)
//					{
//						EPSEventLog.WriteEntry(exc.ToString(),EventLogEntryType.Error);
//					}
//					keepRunning = CanContinueRunning() && keepRunning;
//					Thread.Sleep(10000);
//				}
//				catch(Exception exc)
//				{
//					EPSEventLog.WriteEntry(exc.ToString(), EventLogEntryType.Error);
//				}
//			}
//		}
		private bool CanContinueRunning()
		{
			exitTimes.Add(DateTime.Now);

			// Remove times older than exitInterval (milliseconds)
			for(int i=exitTimes.Count-1; i>=0; i--)
			{
				if(((DateTime)exitTimes[i]).AddMilliseconds((double)exitInterval)<DateTime.Now)
					exitTimes.RemoveAt(i);
			}

			EPSEventLog.WriteEntry("Service exited "+exitTimes.Count+" times in the last "+(exitInterval/60000).ToString()+" minutes."+
				Environment.NewLine+"The maximum allowed is "+exitMax.ToString(), EventLogEntryType.Warning);

			return (exitTimes.Count<=exitMax);
		}

		private void monitorHealth()
		{
			try
			{
				while(keepRunning)
				{
					if(p.IsRunning && !p.IsHealthy)
						p.Stop();
					Thread.Sleep(500);
				}
//				while(!workerProcess.HasExited && keepRunning)
//				{
//					uint workingSet = ProcUtils.GetProcessMemoryUsage(workerProcess.Id).WorkingSetSize;
//					if(workingSet>serviceMemMax)
//					{
//						EPSEventLog.WriteEntry("ServiceMemMaxMB="+serviceMemMaxMB.ToString()+Environment.NewLine+
//							"Current Memory Usage (MB)="+(workingSet/Math.Pow(2d,20d)).ToString()+
//							Environment.NewLine+"Shutting down process."+Environment.NewLine+
//							"ServiceID="+this.ServiceID.ToString(), EventLogEntryType.Warning);
//
//						workerProcess.Kill();
//						return;
//					}
//					Thread.Sleep(5000);
//				}
			}
			catch(ThreadAbortException){}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error in monitorHealth() " + Environment.NewLine + exc.ToString(), EventLogEntryType.Error);
			}
		}

		private void p_Started(object sender, EventArgs e)
		{

		}

		private void p_Stopped(object sender, EventArgs e)
		{
			if(keepRunning)
				keepRunning = CanContinueRunning() && keepRunning;
			if(keepRunning)
				p.Start();
		}

		private void p_Stopping(object sender, EventArgs e)
		{

		}
	}
}
