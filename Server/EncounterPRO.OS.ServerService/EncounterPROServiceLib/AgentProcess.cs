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
	public struct ProcessInfo
	{
		public string Application;
		public string Arguments;
		public ProcessInfo(string Application, string Arguments)
		{
			this.Application = Application;
			this.Arguments = Arguments;
		}
	}
	/// <summary>
	/// Summary description for AgentProcess.
	/// </summary>
	public class AgentProcess
	{
		public event EventHandler Started;
		public event EventHandler Stopped;
		public event EventHandler Stopping;
		private System.Diagnostics.Process p = null;
		private System.Diagnostics.ProcessPriorityClass priority = System.Diagnostics.ProcessPriorityClass.Normal;
		private bool isRunning = false;
		private bool verboseLogging = false;
		private TimeSpan stopProcessTimeout = TimeSpan.FromSeconds(30d);
		private TimeSpan maxRuntime = TimeSpan.MaxValue;
		private uint maxMemoryUsage = UInt32.MaxValue;
		private string application = null;
		private string arguments = null;
		private DateTime startTime;

		#region Event Methods

		protected void OnStarted()
		{
			if(null!=Started)
				Started(this, new EventArgs());
		}

		protected void OnStopped()
		{
			if(null!=Stopped)
				Stopped(this, new EventArgs());
		}

		protected void OnStopping()
		{
			if(null!=Stopping)
				Stopping(this, new EventArgs());
		}

		#endregion

		#region Read/Write Properties

		public TimeSpan StopProcessTimeout
		{
			get{return stopProcessTimeout;}
			set{stopProcessTimeout=value;}
		}

		public bool VerboseLogging
		{
			get
			{
				return verboseLogging;
			}
			set
			{
				verboseLogging = value;
			}
		}

		public System.Diagnostics.ProcessPriorityClass Priority
		{
			get
			{
				return priority;
			}
			set
			{
				priority = value;
			}
		}

		public string Application
		{
			get
			{
				return application;
			}
			set
			{
				application = value;
			}
		}

		public string Arguments
		{
			get
			{
				return arguments;
			}
			set
			{
				arguments = value;
			}
		}

		public TimeSpan MaxRuntime
		{
			get
			{
				return maxRuntime;
			}
			set
			{
				maxRuntime = value;
			}
		}

		public uint MaxMemoryUsage
		{
			get
			{
				return maxMemoryUsage;
			}
			set
			{
				maxMemoryUsage = value;
			}
		}

		#endregion

		#region ReadOnly Properties

		public bool IsRunning
		{
			get
			{
				return isRunning;
			}
		}

		public int TaskId
		{
			get
			{
				if(IsRunning)
				{
					string[] args = Arguments.Split(new char[]{','});
					return Int32.Parse(args[0].Split(new char[]{'='})[1].Trim());
				}
				throw new Exception("Process is not running.");
			}
		}

		public string TaskUser
		{
			get
			{
				if(IsRunning)
				{
					string[] args = Arguments.Split(new char[]{','});
					return args[2].Trim();
				}
				throw new Exception("Process is not running.");
			}
		}

		public int ProcessId
		{
			get
			{
				if(IsRunning)
					return p.Id;
				throw new Exception("Process is not running.");
			}
		}

		public DateTime StartTime
		{
			get
			{
				if(IsRunning)
					return startTime;
				throw new Exception("Process is not running.");
			}
		}

		public TimeSpan Runtime
		{
			get
			{
				if(IsRunning)
					return DateTime.Now.Subtract(StartTime);
				throw new Exception("Process is not running.");
			}
		}

		public uint MemoryUsage
		{
			get
			{
				if(IsRunning)
					return ProcUtils.GetProcessMemoryUsage(p.Id).WorkingSetSize;
				throw new Exception("Process is not running.");
			}
		}

		public bool IsHealthy
		{
			get
			{
				if(IsRunning)
					return ((Runtime<=MaxRuntime) && (MemoryUsage<=MaxMemoryUsage));
				throw new Exception("Process is not running.");
			}
		}

		#endregion

		public AgentProcess()
		{		
		}

		public void Start()
		{
			if(IsRunning)
				throw new Exception("Process is already running.");
			p = new System.Diagnostics.Process();
			System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo(Application,Arguments);
			p.StartInfo = startInfo;
			p.Start();
			startTime = DateTime.Now;
			isRunning=true;
			Monitor();
			p.PriorityClass = Priority;
			if(VerboseLogging)
				EPSEventLog.WriteEntry("Process Started" + Environment.NewLine +
					"FileName   = " + Application + Environment.NewLine +
					"Arguments  = " + Arguments + Environment.NewLine +
					"Process ID = " + ProcessId.ToString() + Environment.NewLine + 
					"Priority   = " + Priority.ToString(), System.Diagnostics.EventLogEntryType.Information);
			OnStarted();
		}

		private void Monitor()
		{
			System.Threading.Thread t = new System.Threading.Thread(new System.Threading.ThreadStart(monitor));
			t.Start();
		}

		private void monitor()
		{
			try
			{
				while(!p.HasExited)
				{
					System.Threading.Thread.Sleep(100);
				}
				p_Exited();
			}
			catch{}
		}

		public void Stop()
		{
			try
			{
				OnStopping();

				// Forcefully kill the application
				if(IsRunning)
				{
					ProcUtils.Kill(ProcessId);
					p.WaitForExit();
				}
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error in Stop()"+Environment.NewLine+
					exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
		}

		public void Dispose()
		{
			if(null!=p)
			{
				p.Dispose();
				p = null;
			}
		}

		public void StopAsync()
		{
			System.Threading.Thread stopProcessThread = new System.Threading.Thread(new System.Threading.ThreadStart(Stop));
			stopProcessThread.Start();
		}

		private void p_Exited()
		{
			if(VerboseLogging)
				EPSEventLog.WriteEntry("Process Stopped" + Environment.NewLine +
					"Runtime    = " + Runtime.TotalSeconds.ToString() + " seconds" + Environment.NewLine + 
					"FileName   = " + Application + Environment.NewLine +
					"Arguments  = " + Arguments + Environment.NewLine +
					"Process ID = " + ProcessId.ToString() + Environment.NewLine +
					"Exit Code  = " + p.ExitCode.ToString(), System.Diagnostics.EventLogEntryType.Information);
			isRunning = false;
			p.Dispose();
			p = null;
			OnStopped();
		}

		public override string ToString()
		{
			return 			"FileName   = " + Application + Environment.NewLine +
							"Arguments  = " + Arguments + Environment.NewLine +
							"Process ID = " + ProcessId.ToString() + Environment.NewLine +
							"Runtime    = " + Runtime.TotalSeconds.ToString() + " seconds" + Environment.NewLine + 
							"MaxRuntime = " + MaxRuntime.TotalSeconds.ToString() + " seconds" + Environment.NewLine +
							"Memory     = " + (MemoryUsage/Math.Pow(2d,20d)).ToString() + " MB" + Environment.NewLine +
							"MaxMemory  = " + (MaxMemoryUsage/Math.Pow(2d,20d)).ToString() + " MB";
		}

	}
}
