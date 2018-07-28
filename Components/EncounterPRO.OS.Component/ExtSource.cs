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
	public abstract class ExtSource : Common
	{
		public event EventHandler Updated;
		public event EventHandler Connected;
		public event EventHandler Disconnected;

		private string input=null;

		protected string Input
		{
			get { return input; }
		}

		public ExtSource() : base()
		{
		}

		/// <summary>
		/// Collects integration results
		/// </summary>
		/// <returns>Returns result string on success.
		/// Throws Exception on failure.
		/// Returns empty string if no results.</returns>
		public string Do_Source()
		{
			try
			{
				string result = doSource();
				if(null == result)
					return string.Empty; // Can't pass null through COM-interop to PB
				else
					return result;
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
		}

		/// <summary>
		/// Determines whether integration interface is connected.
		/// </summary>
		/// <returns>True if connected.
		/// False if not connected.</returns>
		public bool Is_Connected()
		{
			try
			{
				return isConnected();
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
		}

		/// <summary>
		/// Notifies integration interface that message was processed.
		/// </summary>
		/// <param name="id">ID of processed message</param>
		/// <param name="status">Status of processed message</param>
		/// <returns>1 on success.
		/// -1 on failure.
		/// 0 if no change.</returns>
		public StdEproReturn Set_Processed(string id, int status)
		{
			try
			{
				return setProcessed(id, status);
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				return StdEproReturn.Error;
			}
		}


		/// <summary>
		/// Receives context XML and initilizes object.
		/// </summary>
		/// <param name="xml">Context XML Document</param>
		/// <returns>1 on success.
		/// -1 on failure.
		/// 0 if no change.</returns>
		protected virtual StdEproReturn initialize(string xml)
		{
			return StdEproReturn.Success;
		}

		/// <summary>
		/// Collects integration results
		/// </summary>
		/// <returns>Returns result string on success.
		/// Throws Exception on failure.
		/// Returns empty string if no results.</returns>
		protected virtual string doSource()
		{
			throw new Exception("Method not implemented.");
		}

		/// <summary>
		/// Determines whether integration interface is connected.
		/// </summary>
		/// <returns>True if connected.
		/// False if not connected.</returns>
		protected abstract bool isConnected();

		/// <summary>
		/// Notifies integration interface that message was processed.
		/// </summary>
		/// <param name="id">ID of processed message</param>
		/// <param name="status">Status of processed message</param>
		/// <returns>1 on success.
		/// -1 on failure.
		/// 0 if no change.</returns>
		protected virtual StdEproReturn setProcessed(string id, int status)
		{
			throw new Exception("Method not implemented.");
		}

		protected void fireUpdated()
		{
			if(null!=Updated)
				Updated(this, new EventArgs());
		}

		protected void fireConnected()
		{
			if(null!=Connected)
				Connected(this, new EventArgs());
		}

		protected void fireDisconnected()
		{
			if(null!=Disconnected)
				Disconnected(this, new EventArgs());
		}
	}
}

