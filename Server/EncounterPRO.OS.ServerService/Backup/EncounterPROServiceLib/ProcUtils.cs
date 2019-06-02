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
using System.Text;
using System.Runtime.InteropServices;

namespace EncounterPRO.OS.ServerService.Lib
{
	internal class ProcessRights
	{
		public const uint TERMINATE         = 0x0001  ;
		public const uint CREATE_THREAD     = 0x0002  ;
		public const uint SET_SESSIONID     = 0x0004  ;
		public const uint VM_OPERATION      = 0x0008  ;
		public const uint VM_READ           = 0x0010  ;
		public const uint VM_WRITE          = 0x0020  ;
		public const uint DUP_HANDLE        = 0x0040  ;
		public const uint CREATE_PROCESS    = 0x0080  ;
		public const uint SET_QUOTA         = 0x0100  ;
		public const uint SET_INFORMATION   = 0x0200  ;
		public const uint QUERY_INFORMATION = 0x0400  ;
		public const uint SUSPEND_RESUME    = 0x0800  ;

		private const uint STANDARD_RIGHTS_REQUIRED = 0x000F0000;
		private const uint SYNCHRONIZE              = 0x00100000;
	
		public const uint ALL_ACCESS        = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0xFFF;
	}

	/// <summary>
	/// Summary description for ProcUtils.
	/// </summary>
	public class ProcUtils
	{
		public ProcUtils()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		public static void Kill(int PID)
		{
			ProcessEntry32 pe;
			try
			{
				pe = GetProcess(PID);
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error getting process entry."+Environment.NewLine+
					exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				goto Error;
			}
			int hProcess;
			try
			{
				hProcess = OpenProcess(ProcessRights.TERMINATE, false, pe.th32ProcessID);
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Error opening process."+Environment.NewLine+
					exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				goto Error;
			}
			try
			{
				if(TerminateProcess(hProcess, -1) == 0)
				{
					throw new Exception("Call to TerminateProcess() failed.  The function returned 0.");
				}
				return;
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Could not kill process."+Environment.NewLine+
					exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				goto Error;
			}
			finally
			{
				CloseHandle(hProcess);
			}
			Error:
				return;
		}

		public static int KillAll(string ExeName)
		{
			int count = 0;
			foreach(ProcessEntry32 pe in GetProcesses(ExeName))
			{
				int hProcess = OpenProcess(ProcessRights.TERMINATE, false, pe.th32ProcessID);
				try
				{
					TerminateProcess(hProcess, -1);
					count++;
				}
				finally
				{
					CloseHandle(hProcess);
				}
			}
			return count;
		}

		[DllImport("PSAPI.DLL")]
		private static extern int GetProcessMemoryInfo(int hProcess, ref PROCESS_MEMORY_COUNTERS ppsmemCounters, uint cb);

		[DllImport("KERNEL32.DLL")]
		private static extern int CreateToolhelp32Snapshot(uint flags, uint processid);

		[DllImport("KERNEL32.DLL")]
		private static extern int CloseHandle(int handle);

		[StructLayout(LayoutKind.Sequential)]
		public struct ProcessEntry32 
		{ 
			public uint dwSize; 
			public uint cntUsage; 
			public uint th32ProcessID; 
			public uint th32DefaultHeapID; 
			public uint th32ModuleID; 
			public uint cntThreads; 
			public uint th32ParentProcessID; 
			public int  pcPriClassBase; 
			public uint dwFlags; 
			[MarshalAs(UnmanagedType.ByValTStr, SizeConst=256)] public string szExeFile;
		};

		[StructLayout(LayoutKind.Sequential)]
		public struct PROCESS_MEMORY_COUNTERS
		{
			public uint cb;
			public uint PageFaultCount;
			public uint PeakWorkingSetSize;
			public uint WorkingSetSize;
			public uint QuotaPeakPagedPoolUsage;
			public uint QuotaPagedPoolUsage;
			public uint QuotaPeakNonPagedPoolUsage;
			public uint QuotaNonPagedPoolUsage;
			public uint PagefileUsage;
			public uint PeakPagefileUsage;
		};

		[DllImport("KERNEL32.DLL")]
		private static extern int Process32First(int handle, ref ProcessEntry32 pe);
	
		[DllImport("KERNEL32.DLL")]
		private static extern int Process32Next(int handle, ref ProcessEntry32 pe);

		[DllImport("KERNEL32.DLL")]
		private static extern int TerminateProcess ( int hProcess, int uExitCode);

		[DllImport("KERNEL32.DLL")]
		private static extern int OpenProcess(uint dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

		public static ProcessEntry32[] GetProcesses(string ExeName)
		{
			System.Collections.ArrayList pal = new System.Collections.ArrayList();
			int handle=CreateToolhelp32Snapshot(2,0);
		
			if (handle>0)
			{
				try
				{
					StringBuilder sb = new StringBuilder(" ",256);
			
					ProcessEntry32 pe32 = new ProcessEntry32();
					pe32.szExeFile=sb.ToString();

					uint size=548; // sizeof ints + twice size of sb (thanks to unicode)

					pe32.dwSize=(uint)size;
			
					int retval=Process32First(handle,ref pe32);
			
					while(retval==1)
					{
						if(pe32.szExeFile.ToLower()==ExeName.ToLower())
							pal.Add(pe32);
						size=548;
						pe32.dwSize=size;
						retval=Process32Next(handle, ref pe32);
					}
					return (ProcessEntry32[]) pal.ToArray(typeof(ProcessEntry32));
				}
				finally
				{
					CloseHandle(handle);	
				}
			}
			throw new Exception("Could not create snapshot.");
		}

		public static ProcessEntry32 GetProcess(int PID)
		{
			int handle=CreateToolhelp32Snapshot(2,0);
		
			if (handle>0)
			{
				try
				{
					StringBuilder sb = new StringBuilder(" ",256);
			
					ProcessEntry32 pe32 = new ProcessEntry32();
					pe32.szExeFile=sb.ToString();

					uint size=548; // sizeof ints + twice size of sb (thanks to unicode)

					pe32.dwSize=(uint)size;
			
					int retval=Process32First(handle,ref pe32);
			
					while(retval==1)
					{
						if(pe32.th32ProcessID == PID)
							return pe32;
						size=548;
						pe32.dwSize=size;
						retval=Process32Next(handle, ref pe32);
					}
				}
				finally
				{
					CloseHandle(handle);	
				}
				throw new Exception("Process with PID="+PID.ToString()+" not found.");
			}
			throw new Exception("Could not create snapshot.");
		}

		public static PROCESS_MEMORY_COUNTERS GetProcessMemoryUsage(int PID)
		{
			int hProcess = OpenProcess(ProcessRights.QUERY_INFORMATION, false, (uint)PID);
			PROCESS_MEMORY_COUNTERS pmc1 = new PROCESS_MEMORY_COUNTERS();
			try
			{
				if(GetProcessMemoryInfo(hProcess, ref pmc1, 40)==0)
					throw new Exception("GetProcessMemoryInfo failed for PID="+PID.ToString());
			}
			finally
			{
				CloseHandle(hProcess);
			}
			return pmc1;
		}
	}
}
