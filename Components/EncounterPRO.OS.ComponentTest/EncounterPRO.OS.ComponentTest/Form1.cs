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
using System.Reflection;

namespace EncounterPRO.OS.ComponentTest
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : SaveSettingsForm
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.TextBox tAssembly;
		private System.Windows.Forms.TextBox tClass;
		private System.Windows.Forms.Button bComponentAttributes;
		private System.Windows.Forms.Button bCredentialAttributes;
		private System.Windows.Forms.Button bClinicalContext;
		private System.Windows.Forms.Button bConnectClass;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.ComboBox ddlWrapperClass;
		private System.Windows.Forms.RichTextBox tComponentAttributes;
		private System.Windows.Forms.RichTextBox tCredentialAttributes;
		private System.Windows.Forms.RichTextBox tClinicalContext;
		private System.Windows.Forms.Button loadButton;
		private System.Windows.Forms.Button saveButton;
		private System.Windows.Forms.OpenFileDialog openFileDialog2;
		private System.Windows.Forms.SaveFileDialog saveFileDialog1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private string jmjcmptst = null;

		public Form1() : base()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			jmjcmptst = System.IO.Path.Combine(Application.UserAppDataPath, "jmjcmptst");
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
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.ddlWrapperClass = new System.Windows.Forms.ComboBox();
			this.tAssembly = new System.Windows.Forms.TextBox();
			this.tClass = new System.Windows.Forms.TextBox();
			this.bComponentAttributes = new System.Windows.Forms.Button();
			this.bCredentialAttributes = new System.Windows.Forms.Button();
			this.bClinicalContext = new System.Windows.Forms.Button();
			this.bConnectClass = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.tComponentAttributes = new System.Windows.Forms.RichTextBox();
			this.tCredentialAttributes = new System.Windows.Forms.RichTextBox();
			this.tClinicalContext = new System.Windows.Forms.RichTextBox();
			this.loadButton = new System.Windows.Forms.Button();
			this.saveButton = new System.Windows.Forms.Button();
			this.openFileDialog2 = new System.Windows.Forms.OpenFileDialog();
			this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 40);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(100, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "Assembly";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 64);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(100, 16);
			this.label2.TabIndex = 1;
			this.label2.Text = "Class";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 88);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(152, 16);
			this.label3.TabIndex = 2;
			this.label3.Text = "ComponentAttributes XML";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 224);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(152, 16);
			this.label4.TabIndex = 3;
			this.label4.Text = "CredentialAttributes XML";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(8, 360);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(152, 16);
			this.label5.TabIndex = 4;
			this.label5.Text = "ClinicalContext XML";
			// 
			// ddlWrapperClass
			// 
			this.ddlWrapperClass.Items.AddRange(new object[] {
																 "AttachmentWrapper",
																 "DocumentWrapper",
																 "ExtSourceWrapper",
																 "SecurityManagerWrapper",
																 "ServiceWrapper",
                                                                 "RouteWrapper"});
			this.ddlWrapperClass.Location = new System.Drawing.Point(8, 8);
			this.ddlWrapperClass.Name = "ddlWrapperClass";
			this.ddlWrapperClass.Size = new System.Drawing.Size(168, 21);
			this.ddlWrapperClass.TabIndex = 5;
			this.ddlWrapperClass.Text = "Select Wrapper...";
			// 
			// tAssembly
			// 
			this.tAssembly.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tAssembly.Location = new System.Drawing.Point(112, 38);
			this.tAssembly.Name = "tAssembly";
			this.tAssembly.Size = new System.Drawing.Size(400, 20);
			this.tAssembly.TabIndex = 9;
			this.tAssembly.Text = "";
			// 
			// tClass
			// 
			this.tClass.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tClass.Location = new System.Drawing.Point(112, 62);
			this.tClass.Name = "tClass";
			this.tClass.Size = new System.Drawing.Size(400, 20);
			this.tClass.TabIndex = 10;
			this.tClass.Text = "";
			// 
			// bComponentAttributes
			// 
			this.bComponentAttributes.Location = new System.Drawing.Point(152, 88);
			this.bComponentAttributes.Name = "bComponentAttributes";
			this.bComponentAttributes.Size = new System.Drawing.Size(24, 16);
			this.bComponentAttributes.TabIndex = 11;
			this.bComponentAttributes.Text = "...";
			this.bComponentAttributes.Click += new System.EventHandler(this.bComponentAttributes_Click);
			// 
			// bCredentialAttributes
			// 
			this.bCredentialAttributes.Location = new System.Drawing.Point(152, 224);
			this.bCredentialAttributes.Name = "bCredentialAttributes";
			this.bCredentialAttributes.Size = new System.Drawing.Size(24, 16);
			this.bCredentialAttributes.TabIndex = 12;
			this.bCredentialAttributes.Text = "...";
			this.bCredentialAttributes.Click += new System.EventHandler(this.bCredentialAttributes_Click);
			// 
			// bClinicalContext
			// 
			this.bClinicalContext.Location = new System.Drawing.Point(152, 360);
			this.bClinicalContext.Name = "bClinicalContext";
			this.bClinicalContext.Size = new System.Drawing.Size(24, 16);
			this.bClinicalContext.TabIndex = 13;
			this.bClinicalContext.Text = "...";
			this.bClinicalContext.Click += new System.EventHandler(this.bClinicalContext_Click);
			// 
			// bConnectClass
			// 
			this.bConnectClass.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.bConnectClass.Location = new System.Drawing.Point(392, 504);
			this.bConnectClass.Name = "bConnectClass";
			this.bConnectClass.Size = new System.Drawing.Size(120, 23);
			this.bConnectClass.TabIndex = 14;
			this.bConnectClass.Text = "Call ConnectClass";
			this.bConnectClass.Click += new System.EventHandler(this.bConnectClass_Click);
			// 
			// tComponentAttributes
			// 
			this.tComponentAttributes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tComponentAttributes.Location = new System.Drawing.Point(8, 104);
			this.tComponentAttributes.Name = "tComponentAttributes";
			this.tComponentAttributes.Size = new System.Drawing.Size(504, 112);
			this.tComponentAttributes.TabIndex = 15;
			this.tComponentAttributes.Text = "";
			// 
			// tCredentialAttributes
			// 
			this.tCredentialAttributes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tCredentialAttributes.Location = new System.Drawing.Point(8, 240);
			this.tCredentialAttributes.Name = "tCredentialAttributes";
			this.tCredentialAttributes.Size = new System.Drawing.Size(504, 112);
			this.tCredentialAttributes.TabIndex = 16;
			this.tCredentialAttributes.Text = "";
			// 
			// tClinicalContext
			// 
			this.tClinicalContext.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tClinicalContext.Location = new System.Drawing.Point(8, 376);
			this.tClinicalContext.Name = "tClinicalContext";
			this.tClinicalContext.Size = new System.Drawing.Size(504, 112);
			this.tClinicalContext.TabIndex = 17;
			this.tClinicalContext.Text = "";
			// 
			// loadButton
			// 
			this.loadButton.Location = new System.Drawing.Point(352, 8);
			this.loadButton.Name = "loadButton";
			this.loadButton.TabIndex = 18;
			this.loadButton.Text = "&Load";
			this.loadButton.Click += new System.EventHandler(this.loadButton_Click);
			// 
			// saveButton
			// 
			this.saveButton.Location = new System.Drawing.Point(432, 8);
			this.saveButton.Name = "saveButton";
			this.saveButton.TabIndex = 19;
			this.saveButton.Text = "&Save";
			this.saveButton.Click += new System.EventHandler(this.saveButton_Click);
			// 
			// openFileDialog2
			// 
			this.openFileDialog2.DefaultExt = "jmjcmptst";
			this.openFileDialog2.Filter = "JMJ Component Test Files|*.jmjcmptst|All Files (*.*)|*.*";
			// 
			// saveFileDialog1
			// 
			this.saveFileDialog1.DefaultExt = "jmjcmptst";
			this.saveFileDialog1.Filter = "JMJ Component Test Files|*.jmjcmptst|All Files (*.*)|*.*";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(520, 533);
			this.Controls.Add(this.saveButton);
			this.Controls.Add(this.loadButton);
			this.Controls.Add(this.tClinicalContext);
			this.Controls.Add(this.tCredentialAttributes);
			this.Controls.Add(this.tComponentAttributes);
			this.Controls.Add(this.bConnectClass);
			this.Controls.Add(this.bClinicalContext);
			this.Controls.Add(this.bCredentialAttributes);
			this.Controls.Add(this.bComponentAttributes);
			this.Controls.Add(this.tClass);
			this.Controls.Add(this.tAssembly);
			this.Controls.Add(this.ddlWrapperClass);
			this.Controls.Add(this.label5);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Name = "Form1";
			this.Text = "JMJ Component Tester";
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void bComponentAttributes_Click(object sender, System.EventArgs e)
		{
			if(openFileDialog1.ShowDialog(this)==DialogResult.OK)
			{
				System.IO.StreamReader sr = null;
				try
				{
					sr = System.IO.File.OpenText(openFileDialog1.FileName);
					tComponentAttributes.Text = sr.ReadToEnd();
				}
				catch(Exception exc)
				{
					MessageBox.Show(this, exc.ToString(), "Error opening file...", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
				finally
				{
					try
					{
						sr.Close();
					}
					catch{}				
				}
			}
		}

		private void bCredentialAttributes_Click(object sender, System.EventArgs e)
		{
			if(openFileDialog1.ShowDialog(this)==DialogResult.OK)
			{
				System.IO.StreamReader sr = null;
				try
				{
					sr = System.IO.File.OpenText(openFileDialog1.FileName);
					tCredentialAttributes.Text = sr.ReadToEnd();
				}
				catch(Exception exc)
				{
					MessageBox.Show(this, exc.ToString(), "Error opening file...", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
				finally
				{
					try
					{
						sr.Close();
					}
					catch{}				
				}
			}
		}

		private void bClinicalContext_Click(object sender, System.EventArgs e)
		{
			if(openFileDialog1.ShowDialog(this)==DialogResult.OK)
			{
				System.IO.StreamReader sr = null;
				try
				{
					sr = System.IO.File.OpenText(openFileDialog1.FileName);
					tClinicalContext.Text = sr.ReadToEnd();
				}
				catch(Exception exc)
				{
					MessageBox.Show(this, exc.ToString(), "Error opening file...", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
				finally
				{
					try
					{
						sr.Close();
					}
					catch{}				
				}
			}
		}

		private void bConnectClass_Click(object sender, System.EventArgs e)
		{
			try
			{
                System.Reflection.Assembly asm = System.Reflection.Assembly.LoadWithPartialName("EncounterPRO.OS.Utilities");
				MessageBox.Show(this, asm.FullName, "EncounterPRO.OS.Component assembly name");
				System.Type type = asm.GetModules(false)[0].GetType("EncounterPRO.OS.Component." + ddlWrapperClass.Text, true, false);
				object wrapper = type.GetConstructor(System.Type.EmptyTypes).Invoke(null);
				type.InvokeMember("ConnectClass",System.Reflection.BindingFlags.InvokeMethod,null,wrapper,
					new object[]{tAssembly.Text, tClass.Text, tComponentAttributes.Text, tCredentialAttributes.Text,
									tClinicalContext.Text});


				fWrapper fw = new fWrapper();
				fw.ConnectedClass = wrapper;
				fw.Show();

			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling ConnectClass()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void loadButton_Click(object sender, System.EventArgs e)
		{
			if(System.IO.File.Exists(jmjcmptst))
			{
				System.IO.StreamReader sr = new System.IO.StreamReader(jmjcmptst);
				openFileDialog2.InitialDirectory = sr.ReadToEnd();
				sr.Close();
			}
			if(openFileDialog2.ShowDialog(this)!=DialogResult.OK)
				return;

			System.IO.File.Delete(jmjcmptst);
			System.IO.StreamWriter sw = new System.IO.StreamWriter(jmjcmptst);
			sw.Write(System.IO.Path.GetDirectoryName(openFileDialog2.FileName));
			sw.Flush();
			sw.Close();

			System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
			doc.Load(openFileDialog2.FileName);

            string[] ComponentWrapperClassParts = doc.DocumentElement["component_wrapper_class"].InnerText.Split(new char[] { '.' });
			ddlWrapperClass.Text = ComponentWrapperClassParts[ComponentWrapperClassParts.Length - 1];
			tClass.Text = doc.DocumentElement["component_class"].InnerText;
			tAssembly.Text = doc.DocumentElement["component_version"].InnerText;
			tComponentAttributes.Text = doc.DocumentElement["component_attributes_xml"].InnerText;
			tCredentialAttributes.Text = doc.DocumentElement["credential_attributes_xml"].InnerText;
			tClinicalContext.Text = doc.DocumentElement["context_xml"].InnerText;
		}

		private void saveButton_Click(object sender, System.EventArgs e)
		{
			if(System.IO.File.Exists(jmjcmptst))
			{
				System.IO.StreamReader sr = new System.IO.StreamReader(jmjcmptst);
				saveFileDialog1.InitialDirectory = sr.ReadToEnd();
				sr.Close();
			}

			if(saveFileDialog1.ShowDialog(this)!=DialogResult.OK)
				return;

			System.IO.File.Delete(jmjcmptst);
			System.IO.StreamWriter sw = new System.IO.StreamWriter(jmjcmptst);
			sw.Write(System.IO.Path.GetDirectoryName(saveFileDialog1.FileName));
			sw.Flush();
			sw.Close();																   

			sw = new System.IO.StreamWriter(saveFileDialog1.FileName);
			System.Xml.XmlTextWriter xw = new System.Xml.XmlTextWriter(sw);
			xw.WriteStartDocument();
			xw.WriteStartElement("JMJComponentTestCase");
			xw.WriteElementString("component_wrapper_class", "EncounterPRO.OS.Component."+ddlWrapperClass.Text);
			xw.WriteElementString("component_class", tClass.Text);
			xw.WriteElementString("component_version", tAssembly.Text);
			xw.WriteElementString("component_attributes_xml", tComponentAttributes.Text);
			xw.WriteElementString("credential_attributes_xml", tCredentialAttributes.Text);
			xw.WriteElementString("context_xml", tClinicalContext.Text);
			xw.WriteEndElement();
			xw.WriteEndDocument();
			xw.Flush();
			xw.Close();
		}
	}
}
