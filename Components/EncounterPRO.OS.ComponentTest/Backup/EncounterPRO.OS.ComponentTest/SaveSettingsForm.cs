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

namespace EncounterPRO.OS.ComponentTest
{
	/// <summary>
	/// Summary description for SaveSettingsForm.
	/// </summary>
	public class SaveSettingsForm : System.Windows.Forms.Form
	{
		private string configFile = null;

		public SaveSettingsForm() : base()
		{
			configFile = System.IO.Path.Combine(Application.UserAppDataPath, this.GetType().FullName+".config.xml");
			this.Load+=new EventHandler(SaveSettingsForm_Load);
			this.Closed+=new EventHandler(SaveSettingsForm_Closed);
		}

		private System.Windows.Forms.Control FindControl(string Name, System.Windows.Forms.Control.ControlCollection Controls)
		{
			for(int i=0; i<Controls.Count; i++)
			{
				if(Controls[i].Name==Name)
					return Controls[i];
				if(Controls[i].Controls.Count>0)
				{
					Control c = FindControl(Name,Controls[i].Controls);
					if(c!=null)
						return c;
				}
			}
			return null;
		}

		private void SaveSettingsForm_Closed(object sender, EventArgs e)
		{
			// Save Settings
			System.Xml.XmlTextWriter tw = new System.Xml.XmlTextWriter(configFile, System.Text.Encoding.UTF8);
			tw.WriteStartDocument();
			tw.WriteStartElement("Form");

			WriteControlSettings(tw,this.Controls);

			tw.WriteEndElement();
			tw.WriteEndDocument();
			tw.Flush();
			tw.Close();
		}

		private void WriteControlSettings(System.Xml.XmlTextWriter tw, System.Windows.Forms.Control.ControlCollection controls)
		{
			foreach(Control c in controls)
			{
				switch (c.GetType().ToString())
				{
					case "System.Windows.Forms.TextBox":
						tw.WriteStartElement("Control");
						tw.WriteAttributeString("Name", c.Name);
						if(c.Text!=null)
							tw.WriteString(c.Text);
						tw.WriteEndElement();
						break;
					case "System.Windows.Forms.RichTextBox":
						tw.WriteStartElement("Control");
						tw.WriteAttributeString("Name", c.Name);
						if(c.Text!=null)
							tw.WriteString(c.Text);
						tw.WriteEndElement();
						break;
					case "System.Windows.Forms.ComboBox":
						tw.WriteStartElement("Control");
						tw.WriteAttributeString("Name", c.Name);
						if(c.Text!=null)
							tw.WriteString(c.Text);
						tw.WriteEndElement();
						break;
				}
				if(c.Controls.Count>0)
					WriteControlSettings(tw,c.Controls);
			}
		}

		private void SaveSettingsForm_Load(object sender, EventArgs e)
		{
			// Load Settings
			try
			{
				if(System.IO.File.Exists(configFile))
				{
					System.Xml.XmlDocument configDoc = new System.Xml.XmlDocument();
					configDoc.Load(configFile);
					foreach(System.Xml.XmlNode node in configDoc.DocumentElement.ChildNodes)
					{
						if(node.Name!="Control")
							continue;
						string controlName = node.Attributes["Name"].Value;
						Control control = FindControl(controlName, this.Controls);
						if(control==null)
							continue;

						control.Text = node.InnerText;
					}
					try
					{
						configDoc.Load(configFile);
					}
					catch(Exception exc)
					{
						MessageBox.Show(exc.ToString());
					}
				}
			}
			catch(Exception exc)
			{
				MessageBox.Show(exc.ToString());
			}
		}
	}
}
