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
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;
using System.Reflection;
using System.Data.SqlClient;
using System.IO;

namespace EncounterPRO.OS.ServerService.Client
{
	/// <summary>
	/// Summary description for fMain.
	/// </summary>
	public class fMain : System.Windows.Forms.Form
	{
		private TcpChannel chan;
		private System.Windows.Forms.Timer timer1;
		private System.Windows.Forms.Button bUpdate;
		private System.Windows.Forms.StatusBar statusBar1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Panel panel1;
		private System.ComponentModel.IContainer components;
		private string[] dbConInfo = null;
		private System.Windows.Forms.CheckBox cbAuto;
		private System.Windows.Forms.ListView lvStatic;
		private System.Windows.Forms.Label lStatic;
		private int RemotingPort = 8089;
		private System.Windows.Forms.Label lPools;
		private System.Windows.Forms.ListView lvPools;
		private System.Windows.Forms.ColumnHeader columnHeader1;
		private System.Windows.Forms.ColumnHeader columnHeader2;
		private System.Windows.Forms.ColumnHeader columnHeader3;
		private System.Windows.Forms.ColumnHeader columnHeader4;
		private System.Windows.Forms.ColumnHeader columnHeader5;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tpShort;
		private System.Windows.Forms.TabPage tpLong;
		private System.Windows.Forms.Splitter splitter1;
		private System.Windows.Forms.ListView lvShortRunning;
		private System.Windows.Forms.ListView lvShortQueue;
		private System.Windows.Forms.ListView lvLongQueue;
		private System.Windows.Forms.Splitter splitter2;
		private System.Windows.Forms.ListView lvLongRunning;
		private System.Xml.XmlDocument doc = null;
		private bool updating = false;


		public fMain(string[] args)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			string databaseEntry = "<Default>";
			if(args.Length>0)
			{
				foreach(string arg in args)
				{
					if(arg.ToLower().StartsWith("database="))
					{
						databaseEntry = arg.Substring("database=".Length);
					}
				}
			}
			try
			{
				dbConInfo = GetDBEntry(databaseEntry);
				GetConfigValue(ref RemotingPort, "RemotingPort");
			}
			catch(Exception exc)
			{
				MessageBox.Show(exc.ToString());
			}
		}

		private static string[] GetDBEntry(string DatabaseEntry)
		{
			string[] dbEntry = new string[2];
			string iniSection = "["+DatabaseEntry+"]";
			iniSection = iniSection.ToLower();
			string[] fields = new string[]{"dbserver","dbname"};
			string path = System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);
			string iniFile = System.IO.Path.Combine(path,"EncounterPRO.ini");
			string iniContents = null;
			System.IO.StreamReader sr = new System.IO.StreamReader(iniFile);
			iniContents = sr.ReadToEnd().ToLower();
			sr.Close();

			int sectionContPos = iniContents.IndexOf(iniSection);
			if(sectionContPos<0)
				goto ERROR;
			sectionContPos += iniSection.Length;
			
			int current=0;
			foreach(string field in fields)
			{
				int fieldPos = iniContents.IndexOf(field,sectionContPos);
				if(fieldPos<0)
					goto ERROR;
				fieldPos = iniContents.IndexOf("=",fieldPos);
				if(fieldPos<0)
					goto ERROR;
				fieldPos+=1;
				dbEntry[current] = iniContents.Substring(fieldPos, iniContents.IndexOf(Environment.NewLine,fieldPos)-fieldPos).Trim();
				current++;
			}
            
			return dbEntry;

			ERROR:
				throw new Exception("Error getting "+DatabaseEntry+" information from "+iniFile);
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.timer1 = new System.Windows.Forms.Timer(this.components);
			this.bUpdate = new System.Windows.Forms.Button();
			this.statusBar1 = new System.Windows.Forms.StatusBar();
			this.cbAuto = new System.Windows.Forms.CheckBox();
			this.label1 = new System.Windows.Forms.Label();
			this.panel1 = new System.Windows.Forms.Panel();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tpShort = new System.Windows.Forms.TabPage();
			this.lvShortQueue = new System.Windows.Forms.ListView();
			this.splitter1 = new System.Windows.Forms.Splitter();
			this.lvShortRunning = new System.Windows.Forms.ListView();
			this.tpLong = new System.Windows.Forms.TabPage();
			this.lvLongQueue = new System.Windows.Forms.ListView();
			this.splitter2 = new System.Windows.Forms.Splitter();
			this.lvLongRunning = new System.Windows.Forms.ListView();
			this.lPools = new System.Windows.Forms.Label();
			this.lvPools = new System.Windows.Forms.ListView();
			this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
			this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
			this.columnHeader3 = new System.Windows.Forms.ColumnHeader();
			this.columnHeader4 = new System.Windows.Forms.ColumnHeader();
			this.columnHeader5 = new System.Windows.Forms.ColumnHeader();
			this.lStatic = new System.Windows.Forms.Label();
			this.lvStatic = new System.Windows.Forms.ListView();
			this.panel1.SuspendLayout();
			this.tabControl1.SuspendLayout();
			this.tpShort.SuspendLayout();
			this.tpLong.SuspendLayout();
			this.SuspendLayout();
			// 
			// timer1
			// 
			this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
			// 
			// bUpdate
			// 
			this.bUpdate.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.bUpdate.Location = new System.Drawing.Point(476, 8);
			this.bUpdate.Name = "bUpdate";
			this.bUpdate.TabIndex = 2;
			this.bUpdate.Text = "Update";
			this.bUpdate.Click += new System.EventHandler(this.bUpdate_Click);
			// 
			// statusBar1
			// 
			this.statusBar1.Location = new System.Drawing.Point(0, 531);
			this.statusBar1.Name = "statusBar1";
			this.statusBar1.Size = new System.Drawing.Size(560, 22);
			this.statusBar1.TabIndex = 4;
			// 
			// cbAuto
			// 
			this.cbAuto.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.cbAuto.Location = new System.Drawing.Point(384, 8);
			this.cbAuto.Name = "cbAuto";
			this.cbAuto.Size = new System.Drawing.Size(88, 24);
			this.cbAuto.TabIndex = 5;
			this.cbAuto.Text = "Auto-Update";
			this.cbAuto.CheckedChanged += new System.EventHandler(this.cbAuto_CheckedChanged);
			// 
			// label1
			// 
			this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.label1.Location = new System.Drawing.Point(144, 160);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(264, 219);
			this.label1.TabIndex = 6;
			this.label1.Text = "Services Not Found!";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// panel1
			// 
			this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.panel1.Controls.Add(this.tabControl1);
			this.panel1.Controls.Add(this.lPools);
			this.panel1.Controls.Add(this.lvPools);
			this.panel1.Controls.Add(this.lStatic);
			this.panel1.Controls.Add(this.lvStatic);
			this.panel1.Location = new System.Drawing.Point(0, 32);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(560, 492);
			this.panel1.TabIndex = 7;
			// 
			// tabControl1
			// 
			this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tabControl1.Controls.Add(this.tpShort);
			this.tabControl1.Controls.Add(this.tpLong);
			this.tabControl1.Location = new System.Drawing.Point(8, 240);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(544, 244);
			this.tabControl1.TabIndex = 4;
			// 
			// tpShort
			// 
			this.tpShort.Controls.Add(this.lvShortQueue);
			this.tpShort.Controls.Add(this.splitter1);
			this.tpShort.Controls.Add(this.lvShortRunning);
			this.tpShort.Location = new System.Drawing.Point(4, 22);
			this.tpShort.Name = "tpShort";
			this.tpShort.Size = new System.Drawing.Size(536, 218);
			this.tpShort.TabIndex = 0;
			this.tpShort.Text = "Short";
			// 
			// lvShortQueue
			// 
			this.lvShortQueue.Dock = System.Windows.Forms.DockStyle.Fill;
			this.lvShortQueue.FullRowSelect = true;
			this.lvShortQueue.HideSelection = false;
			this.lvShortQueue.Location = new System.Drawing.Point(0, 91);
			this.lvShortQueue.MultiSelect = false;
			this.lvShortQueue.Name = "lvShortQueue";
			this.lvShortQueue.Size = new System.Drawing.Size(536, 127);
			this.lvShortQueue.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvShortQueue.TabIndex = 3;
			this.lvShortQueue.View = System.Windows.Forms.View.Details;
			// 
			// splitter1
			// 
			this.splitter1.Dock = System.Windows.Forms.DockStyle.Top;
			this.splitter1.Location = new System.Drawing.Point(0, 88);
			this.splitter1.Name = "splitter1";
			this.splitter1.Size = new System.Drawing.Size(536, 3);
			this.splitter1.TabIndex = 2;
			this.splitter1.TabStop = false;
			// 
			// lvShortRunning
			// 
			this.lvShortRunning.Dock = System.Windows.Forms.DockStyle.Top;
			this.lvShortRunning.FullRowSelect = true;
			this.lvShortRunning.HideSelection = false;
			this.lvShortRunning.Location = new System.Drawing.Point(0, 0);
			this.lvShortRunning.MultiSelect = false;
			this.lvShortRunning.Name = "lvShortRunning";
			this.lvShortRunning.Size = new System.Drawing.Size(536, 88);
			this.lvShortRunning.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvShortRunning.TabIndex = 1;
			this.lvShortRunning.View = System.Windows.Forms.View.Details;
			// 
			// tpLong
			// 
			this.tpLong.Controls.Add(this.lvLongQueue);
			this.tpLong.Controls.Add(this.splitter2);
			this.tpLong.Controls.Add(this.lvLongRunning);
			this.tpLong.Location = new System.Drawing.Point(4, 22);
			this.tpLong.Name = "tpLong";
			this.tpLong.Size = new System.Drawing.Size(536, 218);
			this.tpLong.TabIndex = 1;
			this.tpLong.Text = "Long";
			// 
			// lvLongQueue
			// 
			this.lvLongQueue.Dock = System.Windows.Forms.DockStyle.Fill;
			this.lvLongQueue.FullRowSelect = true;
			this.lvLongQueue.HideSelection = false;
			this.lvLongQueue.Location = new System.Drawing.Point(0, 91);
			this.lvLongQueue.MultiSelect = false;
			this.lvLongQueue.Name = "lvLongQueue";
			this.lvLongQueue.Size = new System.Drawing.Size(536, 127);
			this.lvLongQueue.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvLongQueue.TabIndex = 6;
			this.lvLongQueue.View = System.Windows.Forms.View.Details;
			// 
			// splitter2
			// 
			this.splitter2.Dock = System.Windows.Forms.DockStyle.Top;
			this.splitter2.Location = new System.Drawing.Point(0, 88);
			this.splitter2.Name = "splitter2";
			this.splitter2.Size = new System.Drawing.Size(536, 3);
			this.splitter2.TabIndex = 5;
			this.splitter2.TabStop = false;
			// 
			// lvLongRunning
			// 
			this.lvLongRunning.Dock = System.Windows.Forms.DockStyle.Top;
			this.lvLongRunning.FullRowSelect = true;
			this.lvLongRunning.HideSelection = false;
			this.lvLongRunning.Location = new System.Drawing.Point(0, 0);
			this.lvLongRunning.MultiSelect = false;
			this.lvLongRunning.Name = "lvLongRunning";
			this.lvLongRunning.Size = new System.Drawing.Size(536, 88);
			this.lvLongRunning.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvLongRunning.TabIndex = 4;
			this.lvLongRunning.View = System.Windows.Forms.View.Details;
			// 
			// lPools
			// 
			this.lPools.Location = new System.Drawing.Point(8, 128);
			this.lPools.Name = "lPools";
			this.lPools.Size = new System.Drawing.Size(100, 16);
			this.lPools.TabIndex = 3;
			this.lPools.Text = "Process Pools:";
			// 
			// lvPools
			// 
			this.lvPools.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.lvPools.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
																					  this.columnHeader1,
																					  this.columnHeader2,
																					  this.columnHeader3,
																					  this.columnHeader4,
																					  this.columnHeader5});
			this.lvPools.FullRowSelect = true;
			this.lvPools.HideSelection = false;
			this.lvPools.Location = new System.Drawing.Point(8, 144);
			this.lvPools.MultiSelect = false;
			this.lvPools.Name = "lvPools";
			this.lvPools.Size = new System.Drawing.Size(544, 88);
			this.lvPools.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvPools.TabIndex = 2;
			this.lvPools.View = System.Windows.Forms.View.Details;
			this.lvPools.SelectedIndexChanged += new System.EventHandler(this.lvPools_SelectedIndexChanged);
			// 
			// columnHeader1
			// 
			this.columnHeader1.Text = "Pool";
			this.columnHeader1.Width = 140;
			// 
			// columnHeader2
			// 
			this.columnHeader2.Text = "Short Queue";
			this.columnHeader2.Width = 90;
			// 
			// columnHeader3
			// 
			this.columnHeader3.Text = "Short Running";
			this.columnHeader3.Width = 90;
			// 
			// columnHeader4
			// 
			this.columnHeader4.Text = "Long Queue";
			this.columnHeader4.Width = 90;
			// 
			// columnHeader5
			// 
			this.columnHeader5.Text = "Long Running";
			this.columnHeader5.Width = 90;
			// 
			// lStatic
			// 
			this.lStatic.Location = new System.Drawing.Point(8, 16);
			this.lStatic.Name = "lStatic";
			this.lStatic.Size = new System.Drawing.Size(100, 16);
			this.lStatic.TabIndex = 1;
			this.lStatic.Text = "Static Services:";
			// 
			// lvStatic
			// 
			this.lvStatic.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.lvStatic.FullRowSelect = true;
			this.lvStatic.HideSelection = false;
			this.lvStatic.Location = new System.Drawing.Point(8, 32);
			this.lvStatic.MultiSelect = false;
			this.lvStatic.Name = "lvStatic";
			this.lvStatic.Size = new System.Drawing.Size(544, 88);
			this.lvStatic.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.lvStatic.TabIndex = 0;
			this.lvStatic.View = System.Windows.Forms.View.Details;
			// 
			// fMain
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(560, 553);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.cbAuto);
			this.Controls.Add(this.statusBar1);
			this.Controls.Add(this.bUpdate);
			this.Name = "fMain";
			this.Text = "EncounterPROService Monitor";
			this.Load += new System.EventHandler(this.fMain_Load);
			this.panel1.ResumeLayout(false);
			this.tabControl1.ResumeLayout(false);
			this.tpShort.ResumeLayout(false);
			this.tpLong.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args) 
		{
			Application.Run(new fMain(args));
		}

		private void fMain_Load(object sender, System.EventArgs e)
		{
			chan = new TcpChannel();
			ChannelServices.RegisterChannel(chan);
			timer1.Enabled=true;
		}

		private void timer1_Tick(object sender, System.EventArgs e)
		{
			if(cbAuto.Checked)
			{
				timer1.Interval = 5000;
				try
				{
					updateInfo();
				}
				catch(Exception exc)
				{
					cbAuto.Checked=false;
					MessageBox.Show(exc.ToString());
				}
			}
		}

		private void updateInfo()
		{
			if(updating)
				return;
			try
			{
				updating = true;
				DateTime updateStart = DateTime.Now;
				int RemotingPort = 8089;
				GetConfigValue(ref RemotingPort, "RemotingPort");
				string url = "tcp://localhost:" + RemotingPort.ToString() + "/EncounterPROService";
				EncounterPRO.OS.ServerService.Lib.RemotingObject obj = (EncounterPRO.OS.ServerService.Lib.RemotingObject) Activator.GetObject(typeof(EncounterPRO.OS.ServerService.Lib.RemotingObject),url);
			
				if(obj.Equals(null))
				{
					statusBar1.Text = "Error: unable to locate server";
					panel1.Visible=false;
				}
				else
				{
					statusBar1.Text = "Updated "+DateTime.Now.ToString();
					string result = obj.GetInfo();
					if(null==result)
					{
						panel1.Visible=false;
						return;
					}
					doc = new System.Xml.XmlDocument();
					doc.LoadXml(result);
					
					// clear lvStatic rows
					lvStatic.Items.Clear();
					// update lvStatic columns
					if(lvStatic.Columns.Count==0)
						foreach(System.Xml.XmlNode c in doc["ServiceInfo"]["Service"])
						{
							ColumnHeader ch = new ColumnHeader();
							ch.Text = c.Name;
							if(!lvStatic.Columns.Contains(ch))
								lvStatic.Columns.Add(ch);
						}

					// update lvStatic list
					foreach(System.Xml.XmlNode svc in doc["ServiceInfo"])
					{
						if(svc.Name!="Service")
							continue;

						System.Collections.ArrayList strings = new ArrayList();
						foreach(System.Xml.XmlNode d in svc.ChildNodes)
						{
							strings.Add(d.InnerText);
						}
						lvStatic.Items.Add(new ListViewItem((string[])strings.ToArray(typeof(string))));
					}

					// update lvPools list
					int[] totals = new int[4];
					foreach(System.Xml.XmlNode pools in doc["ServiceInfo"])
					{
						if(pools.Name!="ProcessPools")
							continue;
						string[] values = new string[5];
						values[0] = pools["User"].InnerText;
						if(values[0].Length==0)
							values[0] = "Scheduled";
						else
							values[0] = "WPItem: " + values[0];


						foreach(System.Xml.XmlNode pool in pools)
						{
							int offset;
							if(pool.Name!="ProcessPool")
								continue;
							if(pool.Attributes["type"].Value.ToLower()=="short")
								offset = 1;
							else if(pool.Attributes["type"].Value.ToLower()=="long")
								offset = 3;
							else
								continue;
							values[offset+0] = pool["QueuedProcesses"].ChildNodes.Count.ToString();
							values[offset+1] = pool["RunningProcesses"].ChildNodes.Count.ToString() + 
								"/" + pool["MaxProcesses"].InnerText;
							totals[offset-1] += pool["QueuedProcesses"].ChildNodes.Count;
							totals[offset] += pool["RunningProcesses"].ChildNodes.Count;
						}

						bool found=false;
						foreach(ListViewItem lvi in lvPools.Items)
						{
							if(lvi.SubItems[0].Text == values[0])
							{
								found=true;
								for(int i=1; i<5; i++)
								{
									lvi.SubItems[i].Text = values[i];
								}
								break;
							}
						}
						if(!found)
						{
							lvPools.Items.Add(new ListViewItem(values)).Tag = pools["User"].InnerText;
						}

						// Update the <All> row
						int allIndex=-1;
						foreach(ListViewItem lvi in lvPools.Items)
						{
							if(lvi.SubItems[0].Text=="<All>")
							{
								allIndex = lvi.Index;
								break;
							}
						}
						if(allIndex==-1)
						{
							allIndex = lvPools.Items.Add(new ListViewItem(new string[]{"<All>","","","",""})).Index;
							lvPools.Items[allIndex].Selected=true;
						}

						for(int i=1; i<5; i++)
						{
							lvPools.Items[allIndex].SubItems[i].Text = totals[i-1].ToString();
						}

						updateDetails();
					}
					if(!cbAuto.Checked && ((TimeSpan)DateTime.Now.Subtract(updateStart)).TotalSeconds > 3.0)
					{
						cbAuto.Checked=false;
						MessageBox.Show("AutoUpdating has been turned off because it took a long time to get the result set.");
					}
					panel1.Visible=true;
				}
			}
			catch(Exception exc)
			{
				panel1.Visible=false;
				throw exc;
			}
			finally
			{
				updating = false;
			}
		}

		private void updateDetails()
		{
			lvShortRunning.Items.Clear();
			lvShortQueue.Items.Clear();
			lvLongRunning.Items.Clear();
			lvLongQueue.Items.Clear();

			if(lvPools.SelectedItems.Count==0)
				return;

			foreach(System.Xml.XmlNode pools in doc["ServiceInfo"])
			{
				if (pools.Name!="ProcessPools")
					continue;
				if (lvPools.SelectedItems[0].Tag!=null)
					if(pools["User"].InnerText!=lvPools.SelectedItems[0].Tag.ToString())
						continue;
				foreach(System.Xml.XmlNode pool in pools)
				{
					ListView lvR = null;
					ListView lvQ = null;
					if (pool.Name!="ProcessPool")
						continue;
					if(pool.Attributes["type"].Value.ToLower()=="short")
					{
						lvR = lvShortRunning;
						lvQ = lvShortQueue;
					}
					else if(pool.Attributes["type"].Value.ToLower()=="long")
					{
						lvR = lvLongRunning;
						lvQ = lvLongQueue;
					}
					else
						continue;
					foreach(System.Xml.XmlNode q in pool["QueuedProcesses"])
					{
						if(lvQ.Columns.Count==0)
							foreach(System.Xml.XmlNode node in q)
							{
								ColumnHeader ch = new ColumnHeader();
								ch.Text = node.Name;
								if(!lvQ.Columns.Contains(ch))
									lvQ.Columns.Add(ch);
							}
						string[] items = new string[q.ChildNodes.Count];
						for(int i=0; i<items.Length; i++)
						{
							items[i] = q.ChildNodes[i].InnerText;
						}
						lvQ.Items.Add(new ListViewItem(items));
					}
					foreach(System.Xml.XmlNode r in pool["RunningProcesses"])
					{
						if(lvR.Columns.Count==0)
							foreach(System.Xml.XmlNode node in r)
							{
								ColumnHeader ch = new ColumnHeader();
								ch.Text = node.Name;
								if(!lvR.Columns.Contains(ch))
									lvR.Columns.Add(ch);
							}
						string[] items = new string[r.ChildNodes.Count];
						for(int i=0; i<items.Length; i++)
						{
							items[i] = r.ChildNodes[i].InnerText;
						}
						lvR.Items.Add(new ListViewItem(items));
					}
				}
			}
		}

 		private void bUpdate_Click(object sender, System.EventArgs e)
		{
			try
			{
				updateInfo();
			}
			catch{}
		}

		private void GetConfigValue(ref int Value, string ConfigEntry)
		{
			SqlConnection con = GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT domain_item_description "+
				"FROM c_Domain WHERE domain_id = 'EPROSERVERSERVICE' AND domain_item ='"+ConfigEntry+"'",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			Value = Int32.Parse(dbValue.ToString());
		}
		private void GetConfigValue(ref long Value, string ConfigEntry)
		{
			SqlConnection con = GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT domain_item_description "+
				"FROM c_Domain WHERE domain_id = 'EPROSERVERSERVICE' AND domain_item ='"+ConfigEntry+"'",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			Value = Int64.Parse(dbValue.ToString());
		}
		private void GetConfigValue(ref string Value, string ConfigEntry)
		{
			SqlConnection con = GetNewConnection(dbConInfo[0],dbConInfo[1]);
			SqlCommand cmd = new SqlCommand("SELECT domain_item_description "+
				"FROM c_Domain WHERE domain_id = 'EPROSERVERSERVICE' AND domain_item ='"+ConfigEntry+"'",con);
			object dbValue = cmd.ExecuteScalar();
			con.Close();
			if(null==dbValue)
				return;
			Value = dbValue.ToString(); 
		}
		private SqlConnection GetNewConnection(string Server, string Database)
		{
			/*
			SqlConnection con = new SqlConnection("Server="+Server+";Database="+Database+";Integrated Security=SSPI;POOLING=FALSE");
			con.Open();
			try
			{
				SqlCommand com = new SqlCommand("sp_setapprole 'cprsystem', 'applesauce28'",con);
				com.ExecuteNonQuery();
			}
			catch(Exception exc)
			{
				MessageBox.Show(exc.ToString());
			}
			return con;
			*/
			SqlConnection con = new SqlConnection("Server="+Server+";Database="+Database+";Integrated Security=SSPI;POOLING=FALSE");
			con.Open();
			try
			{
				string ls_pref;
				string ls_approlecred;
				string ls_sql;

				SqlCommand cmd = new SqlCommand("SELECT dbo.fn_get_global_preference('SYSTEM', 'system_bitmap') FROM c_1_Record",con);
				object dbValue = cmd.ExecuteScalar();
				if(null==dbValue)
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
				MessageBox.Show(exc.ToString());
			}
			return con;
		}

		private byte[] HexStringToBytes(string hexString)
		{
			byte[] result=new byte[hexString.Length/2];
			for(int i=0, j=0;i<result.Length;i++,j+=2)
			{
				result[i]=Convert.ToByte(hexString.Substring(j,2),16);
			}
			return result;
		}

		private string DecryptString(string value)
		{
			try
			{
				byte[] resultBA=new byte[value.Length/2], valueBA=new byte[value.Length/2];
				byte[] iv = new byte[]{0x14, 0xD7, 0x5B, 0xA2, 0x47, 0x83, 0x0F, 0xC4};
				System.Text.ASCIIEncoding ascEncoding = new System.Text.ASCIIEncoding();
				byte[] key = new byte[24]{0x21, 0x24, 0x25, 0x23, 0x34, 0x32, 0x37, 0x34, 0x38, 0x6A, 0x73, 0x54, 0x54, 0x4C, 0x7A, 0X51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

				MemoryStream memStream = new MemoryStream();
				byte[] tempBA= HexStringToBytes(value);
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
				MessageBox.Show("Decryption failure.  " + exc.ToString());
				return value;
			}
		}

		private void cbAuto_CheckedChanged(object sender, System.EventArgs e)
		{
			bUpdate.Enabled=!cbAuto.Checked;
			if(!cbAuto.Checked)
				timer1.Interval=100;
		}

		private void lvPools_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			updateDetails();
		}
	}
}
