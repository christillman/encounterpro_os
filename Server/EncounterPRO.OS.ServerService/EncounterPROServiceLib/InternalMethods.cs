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

namespace EncounterPRO.OS.ServerService.Lib
{
	/// <summary>
	/// Summary description for InternalMethods.
	/// </summary>
	public class InternalMethods
	{
		public InternalMethods()
		{
			//
			// TODO: Add constructor logic here
			//
		}
		static internal string BytesToHexString(byte[] bytes)
		{
			System.Text.StringBuilder buffer = new System.Text.StringBuilder();
			int length = bytes.Length;
			for(int i = 0; i < length; i++) 
			{
				buffer.Append(S_tableau[bytes[i] >> 4]);
				buffer.Append(S_tableau[bytes[i] & 15]);
			}
			return buffer.ToString().ToUpper();
		}
		private static char[] S_tableau = new char[]{'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};

		static internal byte[] HexStringToBytes(string hexString)
		{
			byte[] result=new byte[hexString.Length/2];
			for(int i=0, j=0;i<result.Length;i++,j+=2)
			{
				result[i]=Convert.ToByte(hexString.Substring(j,2),16);
			}
			return result;
		}

		static internal SqlConnection GetNewConnection(string Server, string Database)
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
				if(null==dbValue || dbValue.ToString().Length < 1)
				{
					ls_approlecred = "applesauce28";
				}
				else
				{
					ls_pref = dbValue.ToString(); 
					ls_approlecred = DecryptString(ls_pref);
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

		static internal string DecryptString(string value)
		{
			try
			{
				byte[] resultBA=new byte[value.Length/2], valueBA=new byte[value.Length/2];
				byte[] iv = new byte[]{0x14, 0xD7, 0x5B, 0xA2, 0x47, 0x83, 0x0F, 0xC4};
				System.Text.ASCIIEncoding ascEncoding = new System.Text.ASCIIEncoding();
				byte[] key = new byte[24]{0x21, 0x24, 0x25, 0x23, 0x34, 0x32, 0x37, 0x34, 0x38, 0x6A, 0x73, 0x54, 0x54, 0x4C, 0x7A, 0X51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

				MemoryStream memStream = new MemoryStream();
				byte[] tempBA=InternalMethods.HexStringToBytes(value);
				memStream.Write(tempBA,0,tempBA.Length);
				memStream.Position=0;

				System.Security.Cryptography.TripleDES 
					cryptoServiceProvider = System.Security.Cryptography.TripleDESCryptoServiceProvider.Create();

				System.Security.Cryptography.ICryptoTransform 
					decryptor = cryptoServiceProvider.CreateDecryptor(key,iv);

				System.Security.Cryptography.CryptoStream 
					cStream = new System.Security.Cryptography.CryptoStream(
					memStream,
					decryptor,
					System.Security.Cryptography.CryptoStreamMode.Read);

				cStream.Read(resultBA,0,resultBA.Length);
				cStream.Close();

				// Find the first zero
				int i = 0;
				for (; i < resultBA.GetLength(0); i++)
					if (resultBA[i] == 0)
						break;
				return ascEncoding.GetString(resultBA, 0, i);
			}
			catch(Exception exc)
			{
				EPSEventLog.WriteEntry("Decryption failure.  Returning original value"+Environment.NewLine + exc.Source,EventLogEntryType.Error);
				return value;
			}
		}

	}
}

