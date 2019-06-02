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
	/// Summary description for SecurityManager.
	/// </summary>
	public abstract class SecurityManager : Common
	{
		public event EventHandler UserActivity;

		public SecurityManager():base()
		{
		}

		protected void OnUserActivity(EventArgs e)
		{
			if(null!=UserActivity)
				UserActivity(this, e);
		}

		/// <summary>
		/// </summary>
		/// <param name="Challenge">Text encrypted using public key of
		/// security manager component</param>
		/// <returns>Unencrypted text of Challenge parameter</returns>
		public string Challenge(string Challenge)
		{
			string val = null;
			try
			{
				val = challenge(Challenge);
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
			if(val==null)
				return string.Empty;	// Can't pass null through Com-interop to PB
			return val;
		}
		/// <summary>
		/// </summary>
		/// <param name="Challenge">Text encrypted using public key of
		/// security manager component</param>
		/// <returns>Unencrypted text of Challenge parameter</returns>
		protected abstract string challenge(string challenge);

		/// <summary>
		/// Called when user authentication is required.
		/// </summary>
		/// <returns>UserName of user who successfully authenticated.
		/// Empty string if no user was authenticated.</returns>
		public string Authenticate()
		{
			string val = null;
			try
			{
				val = authenticate();
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
			if(val==null)
				return string.Empty;	// Can't pass null through Com-interop to PB
			return val;
		}
		/// <summary>
		/// Called when user authentication is required.
		/// </summary>
		/// <returns>UserName of user who successfully authenticated.
		/// Empty string if no user was authenticated.</returns>
		protected abstract string authenticate();

		/// <summary>
		/// ReAuthenticate is called by EncounterPRO to make sure that the previously 
		/// authenticated user is still the same user who is currently engaging EncounterPRO.
		/// A user-switch is not allowed at this point so the Security Manager should make 
		/// it clear to the user who is being authenticated.
		/// </summary>
		/// <param name="UserName">UserName of the user who needs to re-authenticate</param>
		/// <returns>1 if user successfully re-authenticates.  Otherwise 0.</returns>
		public int ReAuthenticate(string UserName)
		{
			return reAuthenticate(UserName);
		}
		/// <summary>
		/// ReAuthenticate is called by EncounterPRO to make sure that the previously 
		/// authenticated user is still the same user who is currently engaging EncounterPRO.
		/// A user-switch is not allowed at this point so the Security Manager should make 
		/// it clear to the user who is being authenticated.
		/// </summary>
		/// <param name="UserName">UserName of the user who needs to re-authenticate</param>
		/// <returns>1 if user successfully re-authenticates.  Otherwise 0.</returns>
		protected abstract int reAuthenticate(string UserName);

		/// <summary>
		/// ChangePassword is called by a logged-in user to change their own password.  
		/// The Security Manager should re-authenticate user before allowing the password change.
		/// </summary>
		/// <param name="UserName">UserName of the user who wishes to change their password</param>
		/// <returns>1 if user successfully changed password.  Otherwise 0.</returns>
		public int ChangePassword(string UserName)
		{
			return changePassword(UserName);
		}
		/// <summary>
		/// ChangePassword is called by a logged-in user to change their own password.  
		/// The Security Manager should re-authenticate user before allowing the password change.
		/// </summary>
		/// <param name="UserName">UserName of the user who wishes to change their password</param>
		/// <returns>1 if user successfully changed password.  Otherwise 0.</returns>
		protected abstract int changePassword(string UserName);

		/// <summary>
		/// ResetPassword is called by an administrator to reset the password of another user.  
		/// The Security Manager should re-authenticate the administrator before allowing the 
		/// password reset.
		/// </summary>
		/// <param name="AdminUserName">UserName of the administrator who wishes to reset 
		/// someone’s password</param>
		/// <param name="ResetUserName">UserName of the user who’s password is to be reset</param>
		/// <returns>1 if user successfully reset password.  Otherwise 0.</returns>
		public int ResetPassword(string AdminUserName, string ResetUserName)
		{
			return resetPassword(AdminUserName, ResetUserName);
		}
		/// <summary>
		/// ResetPassword is called by an administrator to reset the password of another user.  
		/// The Security Manager should re-authenticate the administrator before allowing the 
		/// password reset.
		/// </summary>
		/// <param name="AdminUserName">UserName of the administrator who wishes to reset 
		/// someone’s password</param>
		/// <param name="ResetUserName">UserName of the user who’s password is to be reset</param>
		/// <returns>1 if user successfully reset password.  Otherwise 0.</returns>
		protected abstract int resetPassword(string AdminUserName, string ResetUserName);

		/// <summary>
		/// EstablishCredentials is called by EncounterPRO when a new user is created or the
		/// first time any existing user attempts to use EncounterPRO.
		/// </summary>
		/// <param name="UserID">EncounterPRO userID of the user whose credentials need to be 
		/// established</param>
		/// <returns>Returns new UserName.  Returns empty string if user did not establish 
		/// credentials.</returns>
		public string EstablishCredentials(string UserID)
		{
			string val = null;
			try
			{
				val = establishCredentials(UserID);
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
			if(val==null)
				return string.Empty;	// Can't pass null through Com-interop to PB
			return val;
		}
		/// <summary>
		/// EstablishCredentials is called by EncounterPRO when a new user is created or the
		/// first time any existing user attempts to use EncounterPRO.
		/// </summary>
		/// <param name="UserID">EncounterPRO userID of the user whose credentials need to be 
		/// established</param>
		/// <returns>Returns new UserName.  Returns empty string if user did not establish 
		/// credentials.</returns>
		protected abstract string establishCredentials(string UserID);
	}
}
