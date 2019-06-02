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

namespace EncounterPRO.OS.ServerService.Lib
{
	/// <summary>
	/// Summary description for AgentProcessPool.
	/// </summary>
	public class AgentProcessPool
	{
		public event EventHandler ProcessStopping;
		public event EventHandler ProcessNotHealthy;
		private System.Threading.Thread runThread = null;
		private bool keepRunning = false;
		private System.Collections.ArrayList runningProcesses = new System.Collections.ArrayList();
		private System.Collections.Queue processQueue = new System.Collections.Queue();
		private uint maxPerProcessMemoryUsage = UInt32.MaxValue;
		private TimeSpan maxPerProcessRuntime = TimeSpan.MaxValue;
		private TimeSpan stopProcessTimeout = TimeSpan.FromSeconds(30d);
		private int maxRunningProcesses = Int32.MaxValue;
		private System.Diagnostics.ProcessPriorityClass processPriority = System.Diagnostics.ProcessPriorityClass.Normal;
		private bool autoRestartProcesses = false;
		private bool verboseLogging = false;

		protected void OnProcessStopping(AgentProcess process)
		{
			if(null!=ProcessStopping)
				ProcessStopping(process, new EventArgs());
		}

		protected void OnProcessNotHealthy(AgentProcess process)
		{
			if(null!=ProcessNotHealthy)
				ProcessNotHealthy(process, new EventArgs());
		}

		#region Read/Write Properties

		public TimeSpan StopProcessTimeout
		{
			get{return stopProcessTimeout;}
			set{stopProcessTimeout=value;}
		}

		public uint MaxPerProcessMemoryUsage
		{
			get{return maxPerProcessMemoryUsage;}
			set{maxPerProcessMemoryUsage = value;}
		}

		public TimeSpan MaxPerProcessRuntime
		{
			get{return maxPerProcessRuntime;}
			set{maxPerProcessRuntime = value;}
		}

		public int MaxRunningProcesses
		{
			get{return maxRunningProcesses;}
			set{maxRunningProcesses = value;}
		}

		public System.Diagnostics.ProcessPriorityClass ProcessPriority
		{
			get{return processPriority;}
			set{processPriority = value;}
		}

		public bool AutoRestartProcesses
		{
			get{return autoRestartProcesses;}
			set{autoRestartProcesses = value;}
		}

		public bool VerboseLogging
		{
			get{return verboseLogging;}
			set{verboseLogging = value;}
		}

		#endregion

		#region ReadOnly Properties

		public int RunningProcesses
		{
			get{return runningProcesses.Count;}
		}

		public int QueuedProcesses
		{
			get{return processQueue.Count;}
		}

		public AgentProcess[] RunningProcessesArray
		{
			get{return (AgentProcess[])runningProcesses.ToArray(typeof(AgentProcess));}
		}

		public ProcessInfo[] QueuedProcessesArray
		{
			get
			{
				object[] queued = processQueue.ToArray();
				ProcessInfo[] piq = new ProcessInfo[queued.Length];
				for(int i=0; i<queued.Length; i++)
					piq[i]=(ProcessInfo)queued[i];
				queued=null;
				return piq;
			}
		}
		
		public bool IsActive
		{
			get{return (keepRunning || RunningProcesses>0);}
		}

		#endregion

		public AgentProcessPool()
		{
		}

		public bool IsRunning(ProcessInfo Info)
		{
			foreach(AgentProcess p in runningProcesses)
			{
				if(Info.Equals(new ProcessInfo(p.Application,p.Arguments)))
				{
					return true;
				}
			}
			return false;
		}

		public bool IsQueued(ProcessInfo Info)
		{
			return processQueue.Contains(Info);
		}

		public void Stop()
		{
			keepRunning=false;
			// Begin closing all running processes
			for(int i=runningProcesses.Count-1; i>-1; i--)
			{
				((AgentProcess)runningProcesses[i]).StopAsync();
			}
			if(RunningProcesses>0)
			{
				// Give each process until its Runtime > StopProcessTimeout to end
				while(runningProcesses.Count>0)
				{
					AgentProcess[] pa = RunningProcessesArray;
					for(int i=0; i<pa.Length; i++)
					{
						if(pa[i].Runtime>StopProcessTimeout)
							pa[i].Stop();
					}
					System.Threading.Thread.Sleep(100);
				}
				// Remove any stuck processes from the runningProcesses collection
				for(int i=runningProcesses.Count-1; i>-1; i--)
				{
					((AgentProcess)runningProcesses[i]).Dispose();
					runningProcesses.RemoveAt(i);
				}
			}
		}

		public void StopAsync()
		{
			System.Threading.Thread stopPoolThread = new System.Threading.Thread(new System.Threading.ThreadStart(Stop));
			stopPoolThread.Start();
		}

		public void Start()
		{
			keepRunning = true;
			runThread = new System.Threading.Thread(new System.Threading.ThreadStart(run));
			runThread.Start();
		}

		public void Enqueue(ProcessInfo Info)
		{
			if(!IsQueued(Info) && !IsRunning(Info))
			{
				processQueue.Enqueue(Info);
			}
		}

		/// <summary>
		/// Add an existing AgentProcess to the pool if there is room.
		/// </summary>
		/// <param name="Process">An instantiated AgentProcess object.</param>
		/// <returns>A bool indicating whether the AgentProcess was added to the pool.</returns>
		public bool AddProcess(AgentProcess Process)
		{
			if(processQueue.Count==0 && RunningProcesses<MaxRunningProcesses)
			{
				runningProcesses.Add(Process);
				Process.Started+=new EventHandler(Process_Started);
				Process.Stopped+=new EventHandler(Process_Stopped);
				Process.Stopping+=new EventHandler(Process_Stopping);
				return true;
			}
			else
				return false;
		}

		/// <summary>
		/// Disassociates an AgentProcess with the pool.
		/// </summary>
		/// <param name="Process">AgentProcess object to remove from the pool.</param>
		public void RemoveProcess(AgentProcess Process)
		{
			Process.Started-=new EventHandler(Process_Started);
			Process.Stopped-=new EventHandler(Process_Stopped);
			Process.Stopping-=new EventHandler(Process_Stopping);
			runningProcesses.Remove(Process);
		}

		private void run()
		{

			while(keepRunning)
			{
				if(RunningProcesses<MaxRunningProcesses && processQueue.Count>0)
				{

					ProcessInfo processInfo = (ProcessInfo)processQueue.Dequeue();
					AgentProcess newProcess = new AgentProcess();
					newProcess.Application = processInfo.Application;
					newProcess.Arguments = processInfo.Arguments;
					newProcess.MaxMemoryUsage = MaxPerProcessMemoryUsage;
					newProcess.MaxRuntime = MaxPerProcessRuntime;
					newProcess.Priority = ProcessPriority;
					newProcess.VerboseLogging = VerboseLogging;
					newProcess.Started+=new EventHandler(Process_Started);
					newProcess.Stopped+=new EventHandler(Process_Stopped);
					newProcess.Stopping+=new EventHandler(Process_Stopping);
					newProcess.Start();
				}
				for(int i=runningProcesses.Count-1; i>-1; i--)
				{
					try
					{
						AgentProcess p = (AgentProcess)runningProcesses[i];
						if(!p.IsHealthy)
						{
							OnProcessNotHealthy(p);
						}
					}
					catch{}
				}
				System.Threading.Thread.Sleep(1000);
			}
		}
	

		private void Process_Started(object sender, EventArgs e)
		{
			runningProcesses.Add(sender);
		}

		private void Process_Stopped(object sender, EventArgs e)
		{
			runningProcesses.Remove(sender);
			if(AutoRestartProcesses && keepRunning)
				((AgentProcess)sender).Start();
		}

		private void Process_Stopping(object sender, EventArgs e)
		{
			OnProcessStopping((AgentProcess)sender);
		}
	}
}
