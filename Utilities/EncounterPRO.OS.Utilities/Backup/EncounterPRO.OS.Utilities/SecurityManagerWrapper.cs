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

namespace EncounterPRO.OS.Component
{
	/// <summary>
	/// Summary description for SecurityManagerWrapper.
	/// </summary>
	[Serializable]
	public class SecurityManagerWrapper : PBCOMWrapper
	{
		private const uint WM_USER = 0x0400;
		private const uint MSG_CALLBACKEVENT = WM_USER + 0;

		public SecurityManagerWrapper() : base()
		{
			base.ClassConnected+=new EventHandler(SecurityManagerWrapper_ClassConnected);
		}

		private void SecurityManagerWrapper_ClassConnected(object sender, EventArgs e)
		{
			System.Reflection.EventInfo userActivityEvent = connectedType.GetEvent("UserActivity");
			userActivityEvent.AddEventHandler(connectedClass, new EventHandler(UserActivityEvent));
		}

		/// <summary>
		/// Sends a Windows message to inform caller of status update
		/// </summary>
		private void CallBack()
		{
			try
			{
				if (componentAttributes.Contains("CallbackWindowHandle"))
					Win32.SendMessage(Int32.Parse(componentAttributes["CallbackWindowHandle"].ToString()), MSG_CALLBACKEVENT, 0, 0);
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
			}
		}

		private void UserActivityEvent(object sender, EventArgs e)
		{
			CallBack();
		}

		public string Challenge(string Challenge)
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("Challenge");
			return (string)method.Invoke(connectedClass, new object[]{Challenge});
		}

		public string Authenticate()
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("Authenticate");
			return (string)method.Invoke(connectedClass, new object[]{});
		}

		public int ReAuthenticate(string UserName)
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("ReAuthenticate");
			return (int)method.Invoke(connectedClass, new object[]{UserName});
		}

		public int ChangePassword(string UserName)
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("ChangePassword");
			return (int)method.Invoke(connectedClass, new object[]{UserName});
		}

		public int ResetPassword(string AdminUserName, string ResetUserName)
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("ResetPassword");
			return (int)method.Invoke(connectedClass, new object[]{AdminUserName, ResetUserName});
		}

		public string EstablishCredentials(string UserID)
		{
			if(connectedType == null || connectedClass == null)
				throw new Exception("Not connected to implementation class.");
			System.Reflection.MethodInfo method = connectedType.GetMethod("EstablishCredentials");
			return (string)method.Invoke(connectedClass, new object[]{UserID});
		}
	}
}
