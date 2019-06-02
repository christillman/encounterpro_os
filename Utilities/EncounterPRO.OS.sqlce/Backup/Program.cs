using System;
using System.Collections.Specialized;
using System.Text;
using System.Data;
using System.IO;
using System.Data.SqlClient;

namespace EncounterPRO.OS
{
	class Program
	{
		static Options options;
		static void Main(string[] args)
		{
			options = new Options(args);
			if (args.Length == 0 || options.Help)
			{
				printHelp();
				Environment.Exit(0);
			}

			SqlConnection con = new SqlConnection(options.ConnectionString);
			try
			{
				con.Open();
			}
			catch (Exception exc)
			{
				Console.Error.WriteLine("Error connecting to data source.");
				Console.Error.WriteLine(exc.Message);
				Environment.Exit(-1);
			}

			try
			{
				StringCollection commands = new StringCollection();
				string sqlText;
				sqlText = options.SqlText;
				StringReader sr = new StringReader(sqlText);
				StringBuilder sb = new StringBuilder();
				string line = sr.ReadLine();
				while (line != null)
				{
					if (line.Trim().ToLower() == "go" && sb.Length > 0)
					{
						commands.Add(sb.ToString());
						sb = new StringBuilder();
					}
					else if (line.Trim().Length > 0)
						sb.Append(line + Environment.NewLine);
					line = sr.ReadLine();
				}
				if (sb.Length > 0)
					commands.Add(sb.ToString());
				foreach(string c in commands)
				{
					SqlCommand cmd = new SqlCommand(c, con);
					TextWriter output;
					System.Xml.XmlTextWriter x = null;
					if (options.Output != null)
						output = new System.IO.StreamWriter(File.Create(options.Output));
					else
						output = Console.Out;

					if (options.Xml)
					{
						x = new System.Xml.XmlTextWriter(output);
						x.WriteStartDocument();
						x.WriteStartElement("SQLResults");
					}
                    
					SqlDataReader r = cmd.ExecuteReader();
					try
					{
						int currentSet = 0;
						int affected = r.RecordsAffected;
						if (options.Verbose)
							output.WriteLine(affected.ToString() + " record(s) affected.");
						do
						{
							if (r.FieldCount > 0)
							{
								if (!options.Xml)
								{
									for (int f = 0; f < r.FieldCount; f++)
									{
										output.Write((r.GetName(f).Length == 0 ? "field" + f.ToString() : r.GetName(f)));
										if (f < r.FieldCount - 1)
											output.Write("\t");
										else
											output.WriteLine();
									}
								}

								while (r.Read())
								{
									if (options.Xml)
										x.WriteStartElement("Results" + currentSet.ToString());
									for (int f = 0; f < r.FieldCount; f++)
									{
										if (!options.Xml)
										{
											output.Write((r.IsDBNull(f) ? "NULL" : r[f].ToString()));
											if (f < r.FieldCount - 1)
												output.Write("\t");
											else
												output.WriteLine();
										}
										else
										{
											x.WriteStartElement((r.GetName(f).Length == 0 ? "field" + f.ToString() : r.GetName(f)));
											if (!r.IsDBNull(f))
												x.WriteString(r[f].ToString());
											x.WriteEndElement();
										}
									}
									if (options.Xml)
										x.WriteEndElement();
								}
							}
							currentSet++;
						} while (r.NextResult());
					}
					catch (Exception exc)
					{
						Console.Error.WriteLine("Error in SQL Command.");
						Console.Error.WriteLine(exc.Message);
					}
					finally { r.Close(); }

					if (options.Xml)
					{
						x.WriteEndElement();
						x.WriteEndDocument();
						x.Flush();
					}
					if (options.Output != null)
					{
						output.Flush();
						output.Close();
					}
				}
			}
			catch (Exception exc)
			{
				Console.Error.WriteLine("Error in SQL command.");
				Console.Error.WriteLine(exc.Message);
				Environment.Exit(-1);
			}
		}

		private static void printHelp()
		{
			System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
			StreamReader sr = new StreamReader(asm.GetManifestResourceStream("sqlce.help.txt"));
			string helpString = sr.ReadToEnd();
			sr.Close();
			Console.WriteLine(helpString);
		}
	}
}
