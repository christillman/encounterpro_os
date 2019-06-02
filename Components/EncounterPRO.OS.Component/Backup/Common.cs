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
using System.Collections;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;

namespace EncounterPRO.OS.Component
{
	/// <summary>
	/// Summary description for Common.
	/// </summary>
	public abstract class Common : MarshalByRefObject
	{
		private EventLog log = null;
        
		protected event EventHandler Initialized = null;

		protected System.Collections.Specialized.ListDictionary ComponentAttributes = null;
		protected string ClinicalContext = null;
		protected ExecuteSql ExecuteSql = null;

		public Common()
		{
			if(log == null)
			{
				System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
				string source = asm.GetName().Name;
				log = new EventLog("Application",".",source);
			}
		}

		public override object InitializeLifetimeService()
		{
			return null;
		}

		
		public void Initialize(ExecuteSql ExecuteSql, System.Collections.Specialized.ListDictionary ComponentAttributes, string ClinicalContext)
		{
			this.ExecuteSql = ExecuteSql;
			this.ComponentAttributes = ComponentAttributes;
			this.ClinicalContext = ClinicalContext;

			if(Initialized!=null)
				Initialized(this, new EventArgs());
		}

		protected void Log(string Message, EventLogEntryType Type)
		{
			log.WriteEntry(Message, Type);
		}

		protected string GetPreference(string preferenceId)
		{
			
			DataSet rtnDs;
			DataRow prefDr;
			string strPrefValue = null;
			// Call the fn_get_global_preference
			System.Collections.ArrayList paramList = new ArrayList();

			
			SqlParameter p1 = new SqlParameter("@ps_preference_id", SqlDbType.VarChar);
			p1.Value = preferenceId;
			paramList.Add(p1);
			if(ComponentAttributes.Contains("CurrentUser"))
			{
				SqlParameter p2 = new SqlParameter("@userId", SqlDbType.VarChar);
				p2.Value = ComponentAttributes["CurrentUser"];
				paramList.Add(p2);
			}
			if(ComponentAttributes.Contains("ComputerID"))
			{
				SqlParameter p3 = new SqlParameter("@computerId", SqlDbType.Int);
				p3.Value = ComponentAttributes["ComputerID"];
				paramList.Add(p3);
			}
			SqlParameter[] userParams = (SqlParameter[])paramList.ToArray(typeof(SqlParameter));

			rtnDs = ExecuteSql("select dbo.fn_get_preference"+
				"(NULL ," +
				"@ps_preference_id," +
				(ComponentAttributes.Contains("CurrentUser")? "@userId," : "NULL,") +
				(ComponentAttributes.Contains("ComputerID")? "@computerId)" : "NULL)")
				,ref userParams);
			if(rtnDs != null && rtnDs.Tables.Count > 0 && rtnDs.Tables[0].Rows.Count > 0 && rtnDs.Tables[0].Rows[0] != null)
			{
				prefDr = rtnDs.Tables[0].Rows[0];
				strPrefValue = prefDr[0].ToString();
			}
			// Then check to see if this is encrypted then decrypt and return
			SqlParameter[] userParams2 = new SqlParameter[1];
			userParams2[0] = new SqlParameter("@ps_preference_id", SqlDbType.VarChar);
			userParams2[0].Value = preferenceId;
			DataSet encFlagDS = ExecuteSql("select encrypted from c_preference where preference_id = @ps_preference_id", ref userParams2);
			if(encFlagDS.Tables.Count>0 && encFlagDS.Tables[0].Rows.Count>0 && !encFlagDS.Tables[0].Rows[0].IsNull(0))
			{
				if(encFlagDS.Tables[0].Rows[0][0].ToString().ToLower()=="y")
				{ // preference is encrypted.  perform decryption using EproLibNET.Utilities class
                    System.Reflection.Assembly epln = System.Reflection.Assembly.LoadWithPartialName("EncounterPRO.OS.Utilities, PublicKeyToken=e3e395c42bd8c0d4");
                    Type utilType = epln.GetType("EncounterPRO.OS.Utilities");
					object util = utilType.GetConstructor(System.Type.EmptyTypes).Invoke(null);
					strPrefValue = (string)utilType.InvokeMember("DecryptString", System.Reflection.BindingFlags.InvokeMethod, null,
						util, new object[]{strPrefValue, resource});
					util = null;
					utilType = null;
					epln = null;
				}
			}
			return strPrefValue;
		}

		private string resource
		{
			get
			{
				System.Reflection.Assembly me = System.Reflection.Assembly.GetExecutingAssembly();
				System.IO.StreamReader sr = new System.IO.StreamReader(me.GetManifestResourceStream("EproLibBase.resource.txt"), System.Text.Encoding.UTF8);
				string source = sr.ReadToEnd();
				sr.Close();
				System.Text.StringBuilder sb = new System.Text.StringBuilder();

				int pos = 0;
				for (int i = 15; i > -1; i--)
				{
					Random r = new Random(i);
					int num = r.Next(16);
					pos += num;
					byte[] buf = new byte[num];
					r.NextBytes(buf);
					int s = r.Next(512);
					byte b = System.Text.Encoding.ASCII.GetBytes(source[pos].ToString())[0];
					pos++;
					b = (byte)((b + (3*255) - s) % 255);
					sb.Insert(0, System.Text.Encoding.ASCII.GetString(new byte[] { b }));
				}
				return sb.ToString();
			}
		}

		public virtual bool PreferLocal()
		{
			return false;
		}
	}
}
