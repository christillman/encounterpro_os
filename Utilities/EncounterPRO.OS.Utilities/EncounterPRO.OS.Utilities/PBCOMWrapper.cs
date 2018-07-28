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
using System.Runtime.InteropServices;
using System.Runtime.Serialization.Formatters;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;

namespace EncounterPRO.OS.Component
{
	[Serializable]
	public abstract class PBCOMWrapper
	{
		private EventLog log = null;

		private static System.Data.SqlClient.SqlConnection con = null;
		protected event EventHandler ClassConnected = null;
		protected object connectedClass = null;
		protected Type connectedType = null;
		protected System.Collections.Specialized.ListDictionary credentialAttributes = null;
		protected System.Collections.Specialized.ListDictionary componentAttributes = null;
//		private EPRemoting.RemoteService r = null;

		public PBCOMWrapper()
		{
			if(log == null)
			{
				System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
				string source = asm.GetName().Name;
				log = new EventLog("Application",".",source);
			}
		}

		public void ConnectClass(string Assembly, string Type, string ComponentAttributes, string CredentialAttributes, string ClinicalContext)
		{
			try
			{
				System.Xml.XmlDocument credDoc = new System.Xml.XmlDocument();
				credDoc.LoadXml(CredentialAttributes);
				System.Xml.XmlDocument compDoc = new System.Xml.XmlDocument();
				compDoc.LoadXml(ComponentAttributes);

				System.Reflection.Assembly asm = System.Reflection.Assembly.Load(Assembly);
				connectedType = asm.GetModules(false)[0].GetType(Type, true, false);
				System.Reflection.ConstructorInfo constructor = connectedType.GetConstructor(System.Type.EmptyTypes);
				connectedClass = constructor.Invoke(null);

                //try
                //{
                //    // Check PreferLocal
                //    if( (bool)connectedClass.GetType().InvokeMember("PreferLocal",
                //        System.Reflection.BindingFlags.InvokeMethod, null, connectedClass, null) )
                //    {
                //        System.IntPtr buffer = IntPtr.Zero;
                //        uint bytesReturned;

                //        bool isRdpSession = false;

                //        // Determine whether this code is running in an RDP session
                //        int sessionId = -1;
                //        try
                //        {
                //            WTSQuerySessionInformation((IntPtr)WTS_CURRENT_SERVER_HANDLE, WTS_CURRENT_SESSION, WTSInfoClass.WTSSessionId, out buffer, out bytesReturned);
                //            sessionId = Marshal.ReadInt32(buffer);
                //        }
                //        catch(Exception exc)
                //        {
                //            throw new Exception("Error getting SessionID", exc);
                //        }
                //        finally
                //        {
                //            WTSFreeMemory(buffer);
                //            buffer = IntPtr.Zero;
                //        }

                //        if (sessionId != WTSGetActiveConsoleSessionId())
                //            isRdpSession = true;

                //        if (isRdpSession)
                //        {
                //            string machine = null;
                //            string user = null;

                //            try
                //            {
                //                WTSQuerySessionInformation((IntPtr)WTS_CURRENT_SERVER_HANDLE, WTS_CURRENT_SESSION, WTSInfoClass.WTSClientName, out buffer, out bytesReturned);
                //                machine = Marshal.PtrToStringAnsi(buffer);
                //            }
                //            catch(Exception exc)
                //            {
                //                throw new Exception("Error getting WTSClientName.", exc);
                //            }
                //            finally
                //            {
                //                WTSFreeMemory(buffer);
                //                buffer = IntPtr.Zero;
                //            }

                //            try
                //            {
                //                WTSQuerySessionInformation((IntPtr)WTS_CURRENT_SERVER_HANDLE, WTS_CURRENT_SESSION, WTSInfoClass.WTSUserName, out buffer, out bytesReturned);
                //                user = Marshal.PtrToStringAnsi(buffer);
                //            }
                //            catch(Exception exc)
                //            {
                //                throw new Exception("Error getting WTSUserName.", exc);
                //            }
                //            finally
                //            {
                //                WTSFreeMemory(buffer);
                //                buffer = IntPtr.Zero;
                //            }

                //            try
                //            {
                //                // Create a channel for communicating w/ the remote object
                //                // Notice no port is specified on the client
                //                BinaryClientFormatterSinkProvider clientProvider = 
                //                    new BinaryClientFormatterSinkProvider();
                //                BinaryServerFormatterSinkProvider serverProvider = 
                //                    new BinaryServerFormatterSinkProvider();
                //                serverProvider.TypeFilterLevel = 

                //                    System.Runtime.Serialization.Formatters.TypeFilterLevel.Full;
                
                //                IDictionary props = new Hashtable();
                //                props["port"] = 0;
                //                string s = System.Guid.NewGuid().ToString();
                //                props["name"] = s;
                //                props["typeFilterLevel"] = TypeFilterLevel.Full;
                //                TcpChannel chan = new TcpChannel(
                //                    props,clientProvider,serverProvider);

                //                ChannelServices.RegisterChannel(chan);
                //            }
                //            catch(Exception exc)
                //            {
                //                throw new Exception("Error setting up remoting channel.", exc);
                //            }

                //            try
                //            {
                //                r = (EPRemoting.RemoteService) Activator.GetObject(typeof(EPRemoting.RemoteService), "tcp://localhost:14863/RemoteService");
                //                object ret = r.RequestObject(new EPRemoting.ClientIdentity(machine, user), Assembly, Type);
                //                if(null!=ret)
                //                    connectedClass = ret;
                //                else
                //                    Log("Request for client-side object returned null.", System.Diagnostics.EventLogEntryType.Information);
                //            }
                //            catch(Exception exc)
                //            {
                //                throw new Exception("Error getting RemoteService object from Remoting service.",exc);
                //            }
                //        }
                //    }
                //}
                //catch(Exception exc)
                //{
                //    Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Warning);
                //}

				System.Type executeSqlDelegateType = null;
				System.Reflection.ConstructorInfo esConstructor = null;
				object executeSqlDelegateObject = null;
				System.Version baseVersion = new Version(1,3,0,0);

				try
				{
					foreach(System.Reflection.AssemblyName assembly in asm.GetReferencedAssemblies())
					{
						if(assembly.Name!="EncounterPRO.OS.Component")
							continue;
						System.Reflection.Assembly asm2 = System.Reflection.Assembly.Load(assembly);
						baseVersion = asm2.GetName().Version;
                        executeSqlDelegateType = asm2.GetModules(false)[0].GetType("EncounterPRO.OS.Component.ExecuteSql", true, false);
						esConstructor = executeSqlDelegateType.GetConstructors()[0];
						System.IntPtr methodHandle = this.GetType().GetMethod("ExecuteSql").MethodHandle.GetFunctionPointer();
						executeSqlDelegateObject = esConstructor.Invoke(new object[]{this, methodHandle});
					}
				}
				catch(Exception exc)
				{
					throw new Exception("Error getting ExecuteSql for connectedClass.", exc);
				}

				credentialAttributes = (System.Collections.Specialized.ListDictionary)new System.Collections.Specialized.ListDictionary();
				foreach(System.Xml.XmlNode node in credDoc.DocumentElement.ChildNodes)
				{
					if(node.Name!="Attribute")
						continue;
					if(node.Attributes["name"]==null)
						continue;
					credentialAttributes.Add(node.Attributes["name"].Value, node.InnerText);
				}

				componentAttributes = (System.Collections.Specialized.ListDictionary)new System.Collections.Specialized.ListDictionary();
				foreach(System.Xml.XmlNode node in compDoc.DocumentElement.ChildNodes)
				{
					if(node.Name!="Attribute")
						continue;
					if(node.Attributes["name"]==null)
						continue;
					componentAttributes.Add(node.Attributes["name"].Value, node.InnerText);
				}
		
				try
				{
					connectedClass.GetType().InvokeMember("Initialize", System.Reflection.BindingFlags.InvokeMethod, null, connectedClass, 
						new object[]{executeSqlDelegateObject, componentAttributes, ClinicalContext});
				}
				catch(Exception exc)
				{
					foreach(System.Reflection.MethodInfo mi in connectedClass.GetType().GetMethods())
					{
						System.Text.StringBuilder sb = new System.Text.StringBuilder();
						sb.Append(mi.Name + " method is supported by connectedClass."+Environment.NewLine);
						foreach(System.Reflection.ParameterInfo pi in mi.GetParameters())
						{
							sb.Append(pi.ParameterType.ToString() + " " +pi.Name+Environment.NewLine);
						}
						
						Log(sb.ToString(), System.Diagnostics.EventLogEntryType.Information);
					}
					throw new Exception("Error calling Initialize on connectedClass.", exc);

				}

				if(null!=ClassConnected)
					try
					{
						ClassConnected(this, new EventArgs());
					}
					catch(Exception exc)
					{
						Log("Error firing ClassConnected event."+
							Environment.NewLine + exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
					}
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
		}

		public System.Data.DataSet ExecuteSql(string SqlText, ref System.Data.SqlClient.SqlParameter[] Params)
		{
			try
			{
				System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
				System.Data.SqlClient.SqlDataAdapter da = new System.Data.SqlClient.SqlDataAdapter();
				System.Data.DataSet ds = new System.Data.DataSet();
				if (con==null)
				{
					con = new System.Data.SqlClient.SqlConnection("Server="+credentialAttributes["servername"].ToString()+
						";Database="+credentialAttributes["database"].ToString()+";Integrated Security=SSPI;Pooling=False");
					con.Open();
					cmd.Connection=con;
					cmd.CommandText="EXEC sp_setapprole '" + credentialAttributes["approle"].ToString() +
						"', '" + credentialAttributes["approlepwd"].ToString() + "'";
					cmd.ExecuteNonQuery();
				}

				cmd.Connection = con;
				cmd.CommandText = SqlText;
				if(Params!=null)
					foreach(System.Data.SqlClient.SqlParameter parm in Params)
					{
						cmd.Parameters.Add(parm);
					}
				da.SelectCommand = cmd;
				da.Fill(ds);
				return ds;
			}
			catch(Exception exc)
			{
				Log(exc.ToString(), System.Diagnostics.EventLogEntryType.Error);
				throw exc;
			}
		}

		protected void Log(string Message, EventLogEntryType Type)
		{
			try
			{
				log.WriteEntry(Message, Type);
			}
			catch{}
		}

        //public enum WTSInfoClass
        //{
        //    WTSInitialProgram,
        //    WTSApplicationName,
        //    WTSWorkingDirectory,
        //    WTSOEMId,
        //    WTSSessionId,
        //    WTSUserName,
        //    WTSWinStationName,
        //    WTSDomainName,
        //    WTSConnectState,
        //    WTSClientBuildNumber,
        //    WTSClientName,
        //    WTSClientDirectory,
        //    WTSClientProductId,
        //    WTSClientHardwareId,
        //    WTSClientAddress,
        //    WTSClientDisplay,
        //    WTSClientProtocolType
        //}

        ///// <summary>
        ///// The WTSQuerySessionInformation function retrieves session information for the specified
        ///// session on the specified terminal server.
        ///// It can be used to query session information on local and remote terminal servers.
        ///// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/termserv/termserv/wtsquerysessioninformation.asp
        ///// </summary>
        ///// <param name="hServer">Handle to a terminal server. Specify a handle opened by the WTSOpenServer function,
        ///// or specify <see cref="WTS_CURRENT_SERVER_HANDLE"/> to indicate the terminal server on which your application is running.</param>
        ///// <param name="sessionId">A Terminal Services session identifier. To indicate the session in which the calling application is running
        ///// (or the current session) specify <see cref="WTS_CURRENT_SESSION"/>. Only specify <see cref="WTS_CURRENT_SESSION"/> when obtaining session information on the
        ///// local server. If it is specified when querying session information on a remote server, the returned session
        ///// information will be inconsistent. Do not use the returned data in this situation.</param>
        ///// <param name="wtsInfoClass">Specifies the type of information to retrieve. This parameter can be one of the values from the <see cref="WTSInfoClass"/> enumeration type. </param>
        ///// <param name="ppBuffer">Pointer to a variable that receives a pointer to the requested information. The format and contents of the data depend on the information class specified in the <see cref="WTSInfoClass"/> parameter.
        ///// To free the returned buffer, call the <see cref="WTSFreeMemory"/> function. </param>
        ///// <param name="pBytesReturned">Pointer to a variable that receives the size, in bytes, of the data returned in ppBuffer.</param>
        ///// <returns>If the function succeeds, the return value is a nonzero value.
        ///// If the function fails, the return value is zero. To get extended error information, call GetLastError.
        ///// </returns>
        //[DllImport("Wtsapi32.dll")]
        //public static extern bool WTSQuerySessionInformation(
        //    System.IntPtr hServer, int sessionId, WTSInfoClass wtsInfoClass, out System.IntPtr ppBuffer, out uint pBytesReturned);

        //// http://msdn.microsoft.com/library/default.asp?url=/library/en-us/termserv/termserv/wtsgetactiveconsolesessionid.asp
        ///// <summary>
        ///// The WTSGetActiveConsoleSessionId function retrieves the
        ///// Terminal Services session currently attached to the physical console.
        ///// The physical console is the monitor, keyboard, and mouse.
        ///// </summary>
        ///// <returns>An <see cref="int"/> equal to 0 indicates that the current session is attached to the physical console.</returns>
        ///// <remarks>It is not necessary that Terminal Services be running for this function to succeed.</remarks>
        //[DllImport("Kernel32.dll")]
        //public static extern int WTSGetActiveConsoleSessionId();

        ///// <summary>
        ///// The WTSFreeMemory function frees memory allocated by a Terminal Services function.
        ///// </summary>
        ///// <param name="memory">Pointer to the memory to free.</param>
        //[DllImport("wtsapi32.dll", ExactSpelling = true, SetLastError = false)]
        //public static extern void WTSFreeMemory(IntPtr memory);

        //public const int WTS_CURRENT_SERVER_HANDLE = 0;
        //public const int WTS_CURRENT_SESSION = -1;
	}

}