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
using System.Runtime.InteropServices;
using System.IO;
using System.Diagnostics;
using System.Threading;
using System.Xml;
using System.DirectoryServices;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Net;
using System.Web;
using System.Text;
using System.Management;
using System.Drawing;
using System.Windows.Forms;
using System.Security;
using System.Security.Principal;


namespace EncounterPRO.OS
{
	public delegate void ProgressUpdate(int Progress, string Status);
	
	/// <summary>
	/// Summary description for Utilities.
	/// </summary>
	[ClassInterface(ClassInterfaceType.AutoDispatch)]
	public class Utilities
	{

		private string EproLibNETFolder = null;
		private EventLog eventLog=null;
		private string epVersion="Ver. NA";
		private string eproLibNETVersion=null;

		public string EPVersion
		{
			get
			{
				return epVersion;
			}
			set
			{
				epVersion=value;
			}
		}
		public Utilities()
		{
			EproLibNETFolder = Environment.GetFolderPath(System.Environment.SpecialFolder.CommonProgramFiles);
			EproLibNETFolder = System.IO.Path.Combine(EproLibNETFolder, "EncounterPRO-OS");
			EproLibNETFolder = System.IO.Path.Combine(EproLibNETFolder, "EncounterPRO.OS.Utilities");

			eproLibNETVersion = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
		}

		/// <summary>
		/// Initializes the Application Event Log
		/// </summary>
		/// <param name="source">The Event Source to show in the Event Log</param>
		/// <returns></returns>
		public int InitializeEventLog(string source)
		{
			try
			{
				eventLog = new EventLog("Application", ".", source);
				return 1;
			}
			catch(Exception)
			{
				return -1;
			}
		}

		/// <summary>
		/// Use to log a System.Exception.
		/// </summary>
		/// <param name="exc">Exception to log</param>
		/// <param name="severity">1,2 = Information; 3 = Warning; 4,5 = Error</param>
		/// <returns></returns>
		internal int LogInternalEvent(Exception exc, int severity)
		{
			if(null==eventLog)
			{
				try
				{
					eventLog = new EventLog("Application", ".", "EncounterPRO");
					eventLog.WriteEntry("EncounterPRO Event Logging initialized automatically because it was not initialized by the caller.", EventLogEntryType.Warning);
				}
				catch(Exception)
				{
					return -1;
				}
			}
			try
			{
				EventLogEntryType eventSeverity = EventLogEntryType.Information;
				string objectName=null, scriptName=null, message=null, helpLink=null;
				objectName = exc.Source;
				if(null!=exc.TargetSite)
					scriptName = exc.TargetSite.Name;
				message = exc.ToString();
				helpLink = exc.HelpLink;
				if(null==objectName)
				{
					objectName = "UnknownObject";
				}
				if(null==scriptName)
				{
					scriptName = "UnknownScript";
				}
				if(null==message)
				{
					message = "UnknownMessage";
				}
				if(null==helpLink)
				{
					helpLink = "";
				}
				switch(severity)
				{
					case 1:
					case 2:
						eventSeverity=EventLogEntryType.Information;
						break;
					case 3:
						eventSeverity=EventLogEntryType.Warning;
						break;
					case 4:
					case 5:
						eventSeverity=EventLogEntryType.Error;
						break;
				}

				eventLog.WriteEntry("EproLibNET version: "+eproLibNETVersion+Environment.NewLine+
					Environment.UserDomainName+"\\"+Environment.UserName+
					" on "+Environment.MachineName+ "\r\n" + EPVersion + " >>> " + objectName+
					" - ("+scriptName+") "+message+Environment.NewLine+helpLink, eventSeverity);
				return 1;
			}
			catch(Exception)
			{
				return -1;
			}
		}

		/// <summary>
		/// Log a custom event
		/// </summary>
		/// <param name="objectName">The name of the class the event pertains to</param>
		/// <param name="scriptName">The name of the method the event pertains to</param>
		/// <param name="message">The message to log in the event</param>
		/// <param name="severity">1,2 = Information; 3 = Warning; 4,5 = Error</param>
		/// <returns>1 = Success; -1 = Error</returns>
		public int LogEvent(string objectName, string scriptName, string message, int severity)
		{
			if(null==eventLog)
			{
				try
				{
					eventLog = new EventLog("Application", ".", "EncounterPRO");
					eventLog.WriteEntry("EncounterPRO Event Logging initialized automatically because it was not initialized by the caller.", EventLogEntryType.Warning);
				}
				catch(Exception)
				{
					return -1;
				}
			}
			try
			{
				EventLogEntryType eventSeverity = EventLogEntryType.Information;
				if(null==objectName)
				{
					objectName = "UnknownObject";
				}
				if(null==scriptName)
				{
					scriptName = "UnknownScript";
				}
				if(null==message)
				{
					message = "UnknownMessage";
				}
				switch(severity)
				{
					case 1:
					case 2:
						eventSeverity=EventLogEntryType.Information;
						break;
					case 3:
						eventSeverity=EventLogEntryType.Warning;
						break;
					case 4:
					case 5:
						eventSeverity=EventLogEntryType.Error;
						break;
				}

				eventLog.WriteEntry("EproLibNET version: "+eproLibNETVersion+Environment.NewLine+
					Environment.UserDomainName+"\\"+Environment.UserName+" on "+
					Environment.MachineName+ "\r\n" + EPVersion + " >>> " + objectName+
					" - ("+scriptName+") "+message, eventSeverity);
				return 1;
			}
			catch(Exception)
			{
				return -1;
			}
		}

        public bool IsUserAdmin()
        {
            bool rval;
            try
            {
                // Set the principal policy to WindowsPrincipal.
                AppDomain currentDomain = AppDomain.CurrentDomain;
                currentDomain.SetPrincipalPolicy(PrincipalPolicy.WindowsPrincipal);

                rval = Thread.CurrentPrincipal.IsInRole("Administrators");
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, "IsUserAdmin()", exc.ToString(), 4);
                return false;
            }
            return rval;
        }
        public int CloseEventLog(string source)
		{
			try
			{
				eventLog.Close();
				return 1;
			}
			catch(Exception)
			{
				return -1;
			}
		}

		public bool IsDomainUserExists(string User)
		{
			DirectoryEntry rootEntry = new DirectoryEntry("LDAP://"+Environment.UserDomainName);
			DirectorySearcher ADSearcher = new DirectorySearcher(rootEntry);

			ADSearcher.Filter="(&(objectClass=user)(anr="+User+"))";
			SearchResult result = ADSearcher.FindOne();
			if(null==result)
				return false;
			if(result.GetDirectoryEntry().SchemaClassName.ToLower()!="computer")
				return true;
			else
				return false;
		}
		public void DomainRemoveUser(string User)
		{
			DirectoryEntry rootEntry = new DirectoryEntry("LDAP://"+Environment.UserDomainName);
			DirectorySearcher ADSearcher = new DirectorySearcher(rootEntry);

			ADSearcher.Filter="(&(objectClass=user)(anr="+User+"))";
			SearchResult result = ADSearcher.FindOne();
			if(null==result)
				return;
			result.GetDirectoryEntry().DeleteTree();
		}
		public void DomainCreateUser(string User, string Password, bool AdminPrivileges)
		{
		}

		public int ConvertImage(string sourceFile, string destFile)
		{
			string imageUtil = System.IO.Path.Combine(EproLibNETFolder,"EPImageUtil.exe");
			try
			{
				System.Diagnostics.Process p = new System.Diagnostics.Process();
				p.StartInfo = new System.Diagnostics.ProcessStartInfo(imageUtil,"\"s="+sourceFile+"\" \"d="+destFile+"\"");
				p.Start();
				p.WaitForExit();
				return 1;
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}


		public void ZIP(string SourcePath, string DestFile, int Compression, bool Subdir)
		{
			string[] fileList = GetFileList(SourcePath, Subdir);

			if( !Directory.Exists( Path.GetDirectoryName( DestFile ) ) )
				Directory.CreateDirectory( Path.GetDirectoryName(DestFile));
			FileStream fs = File.Create(DestFile);
			ICSharpCode.SharpZipLib.Zip.ZipOutputStream s = new ICSharpCode.SharpZipLib.Zip.ZipOutputStream(fs);
			s.SetLevel(Compression);
			foreach(string fileName in fileList)
			{
				FileStream fs2 = File.OpenRead(fileName);
            			
				byte[] buffer = new byte[fs2.Length];
				fs2.Read(buffer, 0, buffer.Length);
				fs2.Close();
		
				ICSharpCode.SharpZipLib.Zip.ZipEntry entry = new ICSharpCode.SharpZipLib.Zip.ZipEntry(fileName);
            			
				s.PutNextEntry(entry);
            			
				s.Write(buffer, 0, buffer.Length);

			}
			s.Finish();
			s.Close();
		}

		public string[] GetFileList(string SourcePath, bool Subdir)
		{
			SourcePath = SourcePath.Trim().TrimEnd(new char[] {Path.DirectorySeparatorChar});
			string sourceDir = null;
			string fileFilter = "*";
			if(Directory.Exists(SourcePath))
			{ // Source is a Directory
				sourceDir = SourcePath;
			}
			else if(Directory.Exists(Path.GetDirectoryName(SourcePath)))
			{ // Source is a File Filter
				sourceDir = Path.GetDirectoryName(SourcePath);
				fileFilter = Path.GetFileName(SourcePath);
			}
			else
			{ // Source not found
				throw new DirectoryNotFoundException("Cannot find \""+Path.GetDirectoryName(SourcePath)+"\".");
			}

			System.Collections.ArrayList fileList = new System.Collections.ArrayList();
			fileList.AddRange(System.IO.Directory.GetFiles(sourceDir,fileFilter));
			if(Subdir)
			{
				foreach(string subDir in System.IO.Directory.GetDirectories(sourceDir))
				{
					fileList.AddRange(GetFileList(Path.Combine(subDir, fileFilter),Subdir));
				}
			}

			return (string[]) fileList.ToArray(Type.GetType("System.String"));
		}

		public void UnZIP(string SourceFile, string DestPath, bool PreservePath, string[] ZipEntry)
		{
			FileStream fs = File.OpenRead(SourceFile);
			ICSharpCode.SharpZipLib.Zip.ZipInputStream s = new ICSharpCode.SharpZipLib.Zip.ZipInputStream(fs);
			ICSharpCode.SharpZipLib.Zip.ZipEntry theEntry;
			while ((theEntry = s.GetNextEntry()) != null) 
			{
				if(theEntry.IsDirectory)
					continue;

				if(null!=ZipEntry && ZipEntry.Length>0 && Array.BinarySearch(ZipEntry,Path.GetFileName(theEntry.Name),System.Collections.CaseInsensitiveComparer.Default)<0)
					continue;

				int size = 2048;
				byte[] data = new byte[2048];
                
				string outputFileName = null;
				if(PreservePath)
					outputFileName = Path.Combine(DestPath,theEntry.Name);
				else
					outputFileName = Path.Combine(DestPath,Path.GetFileName(theEntry.Name));
				if(!Directory.Exists(Path.GetDirectoryName(outputFileName)))
					Directory.CreateDirectory(Path.GetDirectoryName(outputFileName));

				FileStream destFS = new FileStream(outputFileName,FileMode.Create);

				while(s.Available>0)
				{
					int readLen = s.Read(data,0,size);
					destFS.Write(data,0,readLen);
				}
				destFS.Flush();
				destFS.Close();
			}
			s.Close();
		}

		public string[] ZIPContents(string SourceFile)
		{
			System.Collections.ArrayList contents = new System.Collections.ArrayList();
			ICSharpCode.SharpZipLib.Zip.ZipFile zip = new ICSharpCode.SharpZipLib.Zip.ZipFile(SourceFile);
			for(int i=0; i<zip.Size; i++)
			{
				if(!zip[i].IsDirectory)
					contents.Add(zip[i].Name);
			}
			return (string[])contents.ToArray(Type.GetType("System.String"));
		}


		public byte[] ConvertHexToBinary(string hex_text)
		{
			try
			{
				return InternalMethods.HexStringToBytes(hex_text);
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public string ConvertBinaryToHex(byte[] binary)
		{
			try
			{
				return InternalMethods.BytesToHexString(binary);
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public byte[] ConvertBase64ToBinary(string base64_text)
		{
			try
			{
				return Convert.FromBase64String(base64_text);
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public string ConvertBinaryToBase64(byte[] binary)
		{
			try
			{
				return Convert.ToBase64String(binary);
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public void SetDefaultPrinter(string NewDefaultPrinter)
		{
			try
			{
				int ret = 0;
				string path;
            
				path = "win32_printer.DeviceId='" + NewDefaultPrinter + "'";

				using (ManagementObject printer = new ManagementObject(path))
				{
					ManagementBaseObject outParams = printer.InvokeMethod("SetDefaultPrinter", null, null);
					ret = (int)(uint)outParams.Properties["ReturnValue"].Value;
				}
            
				if (ret != 0)
				{
					throw new Exception("Setting New Default Printer Failed (" + NewDefaultPrinter + ")");
				}
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public string GetDefaultPrinter()
		{
			try
			{
				ObjectQuery query = new ObjectQuery("SELECT * FROM Win32_Printer WHERE Default = True");
				ManagementObjectSearcher oSearcher = new ManagementObjectSearcher(query);
				foreach (ManagementObject mo in oSearcher.Get())
				{
					return mo["Name"] as string;
				}
				return "";
			}
			catch(Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
		}

		public void ExecuteProgram(string executable, string arguments)
		{
			ExecuteProgramAs(executable, arguments, null, null);
		}

        private SecureString ConvertToSecureString(string str)
        {
            SecureString secureString = new SecureString();
            foreach (char c in str)
            {
                secureString.AppendChar(c);
            }
            return secureString;
        }

        public void ExecuteProgramAs(string executable, string arguments, string asusername, string aspassword)
		{
            char[] uid_delim = {'\\'};
            string[] myuid;

			ProcessStartInfo starter = new ProcessStartInfo(executable, arguments);
			starter.CreateNoWindow = true;
			starter.RedirectStandardOutput = true;
			starter.UseShellExecute = false;
            starter.WorkingDirectory = Path.GetDirectoryName(executable);
            if (asusername.Length > 0 && aspassword.Length > 0)
            {
                myuid = asusername.Split(uid_delim, 2);
                if (myuid.Length == 1)
                {
                    starter.UserName = asusername;
                }
                else if (myuid.Length == 2)
                {
                    starter.Domain = myuid[0];
                    starter.UserName = myuid[1];
                }
                starter.Password = ConvertToSecureString(aspassword);
            }
			Process process = new Process();
			process.StartInfo = starter;
            try
            {
    			process.Start();
			}
			catch(Exception exc)
			{
                LogInternalEvent(exc, 4);
                throw exc;
			}
			StringBuilder buffer = new StringBuilder();
			using (StreamReader reader = process.StandardOutput) 
			{
				string line = reader.ReadLine();
				while (line != null) 
				{
					buffer.Append(line);
					buffer.Append(Environment.NewLine);
					line = reader.ReadLine();
					Thread.Sleep(100);
				}
			}
			if (process.ExitCode != 0) 
			{
				throw new Exception(string.Format(@"""{0}"" exited with ExitCode {1}. Output: {2}", executable, process.ExitCode, buffer.ToString()));
			}
		}

		public void ExecuteProgramTimeout(string executable, string arguments, int timeout_milliseconds)
		{
			int sleep_interval = 100;
			int total_sleep = 0;

			if (timeout_milliseconds <= 0)
				timeout_milliseconds = 30000; // 30 second default timeout

			ProcessStartInfo starter = new ProcessStartInfo(executable, arguments);
			starter.CreateNoWindow = true;
			starter.RedirectStandardOutput = true;
			starter.UseShellExecute = false;
			Process process = new Process();
			process.StartInfo = starter;
			process.Start();
			while (!process.HasExited)
			{
				if (total_sleep >= timeout_milliseconds)
				{
					process.Kill();
					throw new Exception(string.Format(@"Timeout exceeded:  ""{0}"" ""{1}""", executable, arguments));
				}
				Thread.Sleep(sleep_interval);
				total_sleep += sleep_interval;
			}
			if (process.ExitCode != 0) 
			{
				throw new Exception(string.Format(@"""{0}"" exited with ExitCode {1}.", executable, process.ExitCode));
			}
		}

		public int BytesToFile(string filename, byte[] data)
		{
			FileStream stream = null;
			try
			{
				try
				{
					if(!Directory.Exists(Path.GetDirectoryName(filename)))
						Directory.CreateDirectory(Path.GetDirectoryName(filename));
				}
				catch(Exception exc1)
				{
					LogEvent(exc1.Source, "BytesToFile(string, object)",exc1.ToString(),3);
				}
				stream = new FileStream(filename,FileMode.CreateNew,FileAccess.ReadWrite,FileShare.None);
				stream.Write((byte[])data,0,((byte[])data).Length);
				stream.Flush();
				stream.Close();
				return 1;
			}
			catch(Exception exc)
			{
				try
				{
					stream.Close();
				}
				catch{}
				LogEvent(exc.Source, "BytesToFile(string, object)",exc.ToString(),4);
				return -1;
			}
		}

		public byte[] FileToBytes(string filename)
		{
			byte[] data = null;
			FileStream stream = null;
			int buffersize=500;
			long buffercount=0;
			int remainder=0;
			int currentpos=0;
			try
			{
				stream=File.OpenRead(filename);
				
				buffercount=stream.Length/buffersize;
				remainder=(int)(stream.Length%buffersize);

				data = new byte[stream.Length];
				
				stream.Read((byte[])data,currentpos,remainder);
				currentpos+=remainder;

				while(buffercount>0)
				{
					stream.Read((byte[])data,currentpos,buffersize);
					currentpos+=buffersize;
					buffercount--;
				}

				stream.Close();
				
				return data;
			}
			catch(Exception exc)
			{
				LogEvent(exc.Source,"FileToBytes(string, ref object)",exc.ToString(),4);
				return new byte[]{};
			}
		}

		public int SaveClipboardToFile(string ps_file)
		{
			if (Clipboard.GetDataObject() != null)
			{
				IDataObject data = Clipboard.GetDataObject();

				if (data.GetDataPresent(DataFormats.Bitmap))
				{
					Image image = (Image)data.GetData(DataFormats.Bitmap,true);

					string ls_extension = ps_file.Substring(ps_file.Length - 3, 3).ToLower();

					if (ls_extension == "bmp")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Bmp);
					else if (ls_extension == "emf")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Emf);
					else if (ls_extension == "jpg")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Jpeg);
					else if (ls_extension == "gif")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Gif);
					else if (ls_extension == "png")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Png );
					else if (ls_extension == "wmf")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Wmf );
					else if (ls_extension == "tif")
						image.Save(ps_file,System.Drawing.Imaging.ImageFormat.Tiff );
					else
						return 0;

					return 1;
				}
				else
				{
					return 0;
				}
			}
			else
			{
				return 0;
			}
		}

		public int GetMainWindowHandle(int PID)
		{
			int rval = 0;
			try
			{
				rval= System.Diagnostics.Process.GetProcessById(PID).MainWindowHandle.ToInt32();
			}
			catch(Exception exc)
			{
				LogEvent(exc.Source,"GetMainWindowHandle(int)",exc.ToString(),4);
				return -1;
			}
			return rval;
		}

        public int screen_resolution_x()
        {
            int rval = 96;
            return rval;
        }

        public int screen_resolution_y()
        {
            int rval = 96;
            return rval;
        }

        public int printer_resolution_x()
        {
            int rval = 1200;
            return rval;
        }

        public int printer_resolution_y()
        {
            int rval = 1200;
            return rval;
        }

        public bool CloseMainWindow(int PID, int timeout)
		{
			int timer=0;
			int sleeptime = 500;
			System.Diagnostics.Process p=null;
			bool rval;
			try
			{
				p = System.Diagnostics.Process.GetProcessById(PID);
				rval = p.CloseMainWindow();
				if(!rval)
				{
					return rval;
				}
				else
				{
					while(timer<timeout && !p.HasExited)
					{
						System.Threading.Thread.Sleep(sleeptime);
						timer+=sleeptime;
					}
					if(p.HasExited)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			catch(Exception exc)
			{
				LogEvent(exc.Source,"CloseMainWindow(int, int)", exc.ToString(),4);
				return false;
			}
		}
		public string TransformXML(string xml, string xsl)
		{
			System.IO.StringReader stringReader = null;
			System.Xml.Xsl.XslCompiledTransform xslTransform = null;
			System.Xml.XmlTextReader xmlTextReader = null;
			System.IO.MemoryStream xmlTextWriterStream = null;
			System.Xml.XmlTextWriter xmlTextWriter = null;
			System.Xml.XmlDocument xmlDocument = null;
			System.IO.StreamReader streamReader = null;
			//System.Security.Policy.Evidence evidence = null;
			try
			{
				stringReader = new System.IO.StringReader(xsl);
				xslTransform = new System.Xml.Xsl.XslCompiledTransform();
				xmlTextReader = new System.Xml.XmlTextReader(stringReader);
				xmlTextWriterStream = new System.IO.MemoryStream();
				xmlTextWriter = new System.Xml.XmlTextWriter(xmlTextWriterStream, System.Text.Encoding.Default);
				xmlDocument = new System.Xml.XmlDocument();

				//evidence =  new System.Security.Policy.Evidence();
				//evidence.AddAssembly(this);
				xmlDocument.LoadXml(xml);
				xslTransform.Load(xmlTextReader);
				xslTransform.Transform(xmlDocument, null, xmlTextWriter, null);
				xmlTextWriter.Flush();

				xmlTextWriterStream.Position=0;
				streamReader = new System.IO.StreamReader(xmlTextWriterStream);
				return streamReader.ReadToEnd();
			}
			catch(Exception exc)
			{
				LogEvent(exc.Source, "TransformXML()", exc.ToString(), 4);
				return "";
			}
			finally
			{
				streamReader.Close();
				xmlTextWriter.Close();
				xmlTextWriterStream.Close();
				xmlTextReader.Close();
				stringReader.Close();
				GC.Collect();
			}
		}
		public string EncryptString(string value, string keyString)
		{
			try
			{
				byte[] resultBA=new byte[value.Length], valueBA=new byte[value.Length];
				byte[] iv = new byte[]{0x14, 0xD7, 0x5B, 0xA2, 0x47, 0x83, 0x0F, 0xC4};
				System.Text.ASCIIEncoding ascEncoding = new System.Text.ASCIIEncoding();
				byte[] key = new byte[24];
				ascEncoding.GetBytes(keyString,0,keyString.Length<24?keyString.Length:24,key,0);
			
				MemoryStream memStream = new MemoryStream();
				byte[] tempBA = new byte[value.Length];
				ascEncoding.GetBytes(value,0,value.Length,tempBA,0);
				System.Security.Cryptography.CryptoStream cStream = new System.Security.Cryptography.CryptoStream(memStream,System.Security.Cryptography.TripleDESCryptoServiceProvider.Create().CreateEncryptor(key,iv),System.Security.Cryptography.CryptoStreamMode.Write);
				cStream.Write(tempBA,0,tempBA.Length);
				cStream.FlushFinalBlock();
				resultBA = memStream.ToArray();
				cStream.Close();

			
				return InternalMethods.BytesToHexString(resultBA);
			}
			catch(Exception exc)
			{
				LogEvent(exc.Source, "EncryptString()", exc.ToString(), 4);
				return "";
			}
			
		}
		public string DecryptString(string value, string keyString)
		{
			try
			{

				byte[] resultBA=new byte[value.Length/2], valueBA=new byte[value.Length/2];
				byte[] iv = new byte[]{0x14, 0xD7, 0x5B, 0xA2, 0x47, 0x83, 0x0F, 0xC4};
				System.Text.ASCIIEncoding ascEncoding = new System.Text.ASCIIEncoding();
				byte[] key = new byte[24];
				ascEncoding.GetBytes(keyString,0,keyString.Length<24?keyString.Length:24,key,0);

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

				return ascEncoding.GetString(resultBA);
			}
			catch(Exception exc)
			{
				LogEvent("Decryption failure.  Returning original value"+
					Environment.NewLine + exc.Source, "DecryptString()", exc.ToString(), 3);
				return value;
			}
		}
		public SqlConnection GetNewConnection(string Server, string Database, string AppRolePwd)
		{
			SqlConnection con = new SqlConnection("Server="+Server+";Database="+Database+";Integrated Security=SSPI;Pooling=FALSE");
			con.Open();
			SqlCommand cmd = new SqlCommand("exec sp_SetAppRole 'cprsystem', '"+AppRolePwd+"'",con);
			cmd.ExecuteNonQuery();
			return con;
		}

		public string PutHTTPRequest(string Address, ICredentials Credentials, IDictionary Variables)
		{
			WebClient client = new WebClient();
			if(Credentials!=null)
				client.Credentials = Credentials;

			try
			{
				foreach(DictionaryEntry entry in Variables)
				{
					client.QueryString.Add(entry.Key.ToString(), entry.Value.ToString());
				}
				StreamReader sr = new StreamReader(client.OpenRead(Address));
				string response = sr.ReadToEnd();
				return response;
			}
			catch(Exception exc)
			{
				LogInternalEvent(new Exception("Error in HTTP Request",exc),4);
				throw exc;
			}
			finally
			{
				client.Dispose();
			}
		}

        public string PutHTTPForm(string Address, ICredentials Credentials, IDictionary Variables)
		{
			WebClient client = new WebClient ();
			if (Credentials != null)
			{
				client.Credentials = Credentials;
			}
			string uploadString = "";
			string response = "";
			IDictionaryEnumerator myEnumerator = Variables.GetEnumerator();
			int count = 0;
			while (myEnumerator.MoveNext())
			{
				if (count > 0) /* then */ uploadString += "&";
				else count ++;
				uploadString += myEnumerator.Key;
				uploadString += "=" + myEnumerator.Value;
			}
			try	
			{
				//Console.WriteLine("uploadString = " + uploadString);
				byte[] byteArray = Encoding.UTF8.GetBytes(uploadString);
				byte [] responseArray = client.UploadData(Address,"POST", byteArray);
				response = Encoding.ASCII.GetString(responseArray);
				return response;
			}
			catch (Exception exc)
			{
				LogInternalEvent(exc,4);
				throw exc;
			}
			finally
			{
				client.Dispose();
			}
		}

		internal static string GetFromResources(string resourceName)
		{  
			System.Reflection.Assembly assem = System.Reflection.Assembly.GetExecutingAssembly();
			using( Stream stream = assem.GetManifestResourceStream(resourceName) )   
			{
				try      
				{ 
					using( StreamReader reader = new StreamReader(stream) )         
					{
						return reader.ReadToEnd();         
					}
				}     
				catch(Exception e)      
				{
					throw new Exception("Error retrieving from Resources. Tried '" 
						+ resourceName+"'\r\n"+e.ToString());      
				}
			}
		}
	}
}
