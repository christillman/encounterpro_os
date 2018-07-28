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

namespace EncounterPRO.OS.ComponentTest
{
	/// <summary>
	/// Summary description for fDocumentWrapper.
	/// </summary>
	public class fDocumentWrapper : SaveSettingsForm
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.RichTextBox tCreateDocumentResult;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Button bCreateDocumentRun;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;


		private System.Type connectedType = null;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.Button bCreateDocument2Run;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.RichTextBox tCreateDocument2Result;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.RichTextBox tCreateDocument2Input;
		private System.Windows.Forms.Button bCreateDocument2Input;
		private object connectedClass = null;

		public System.Type ConnectedType
		{
			get
			{
				return connectedType;
			}
			set
			{
				connectedType = value;
			}
		}

		public object ConnectedClass
		{
			get
			{
				return connectedClass;
			}
			set
			{
				connectedClass = value;
			}
		}
		public fDocumentWrapper() : base()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
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
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.bCreateDocumentRun = new System.Windows.Forms.Button();
			this.label3 = new System.Windows.Forms.Label();
			this.tCreateDocumentResult = new System.Windows.Forms.RichTextBox();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.tCreateDocument2Input = new System.Windows.Forms.RichTextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.bCreateDocument2Run = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.tCreateDocument2Result = new System.Windows.Forms.RichTextBox();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.bCreateDocument2Input = new System.Windows.Forms.Button();
			this.tabControl1.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.tabPage2.SuspendLayout();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(428, 40);
			this.label1.TabIndex = 0;
			this.label1.Text = "Connected: ";
			// 
			// tabControl1
			// 
			this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tabControl1.Controls.Add(this.tabPage1);
			this.tabControl1.Controls.Add(this.tabPage2);
			this.tabControl1.Location = new System.Drawing.Point(0, 48);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(444, 356);
			this.tabControl1.TabIndex = 1;
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.bCreateDocumentRun);
			this.tabPage1.Controls.Add(this.label3);
			this.tabPage1.Controls.Add(this.tCreateDocumentResult);
			this.tabPage1.Location = new System.Drawing.Point(4, 22);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Size = new System.Drawing.Size(436, 330);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "CreateDocument";
			// 
			// bCreateDocumentRun
			// 
			this.bCreateDocumentRun.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.bCreateDocumentRun.Location = new System.Drawing.Point(352, 296);
			this.bCreateDocumentRun.Name = "bCreateDocumentRun";
			this.bCreateDocumentRun.TabIndex = 6;
			this.bCreateDocumentRun.Text = "Run";
			this.bCreateDocumentRun.Click += new System.EventHandler(this.bCreateDocumentRun_Click);
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 8);
			this.label3.Name = "label3";
			this.label3.TabIndex = 5;
			this.label3.Text = "Result";
			// 
			// tCreateDocumentResult
			// 
			this.tCreateDocumentResult.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tCreateDocumentResult.Location = new System.Drawing.Point(8, 32);
			this.tCreateDocumentResult.Name = "tCreateDocumentResult";
			this.tCreateDocumentResult.Size = new System.Drawing.Size(416, 256);
			this.tCreateDocumentResult.TabIndex = 4;
			this.tCreateDocumentResult.Text = "";
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.bCreateDocument2Input);
			this.tabPage2.Controls.Add(this.tCreateDocument2Input);
			this.tabPage2.Controls.Add(this.label4);
			this.tabPage2.Controls.Add(this.bCreateDocument2Run);
			this.tabPage2.Controls.Add(this.label2);
			this.tabPage2.Controls.Add(this.tCreateDocument2Result);
			this.tabPage2.Location = new System.Drawing.Point(4, 22);
			this.tabPage2.Name = "tabPage2";
			this.tabPage2.Size = new System.Drawing.Size(436, 330);
			this.tabPage2.TabIndex = 1;
			this.tabPage2.Text = "CreateDocument2";
			// 
			// tCreateDocument2Input
			// 
			this.tCreateDocument2Input.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tCreateDocument2Input.Location = new System.Drawing.Point(8, 32);
			this.tCreateDocument2Input.Name = "tCreateDocument2Input";
			this.tCreateDocument2Input.Size = new System.Drawing.Size(416, 128);
			this.tCreateDocument2Input.TabIndex = 11;
			this.tCreateDocument2Input.Text = "";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 8);
			this.label4.Name = "label4";
			this.label4.TabIndex = 10;
			this.label4.Text = "Input";
			// 
			// bCreateDocument2Run
			// 
			this.bCreateDocument2Run.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.bCreateDocument2Run.Location = new System.Drawing.Point(352, 296);
			this.bCreateDocument2Run.Name = "bCreateDocument2Run";
			this.bCreateDocument2Run.TabIndex = 9;
			this.bCreateDocument2Run.Text = "Run";
			this.bCreateDocument2Run.Click += new System.EventHandler(this.bCreateDocument2Run_Click);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 168);
			this.label2.Name = "label2";
			this.label2.TabIndex = 8;
			this.label2.Text = "Result";
			// 
			// tCreateDocument2Result
			// 
			this.tCreateDocument2Result.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tCreateDocument2Result.Location = new System.Drawing.Point(8, 192);
			this.tCreateDocument2Result.Name = "tCreateDocument2Result";
			this.tCreateDocument2Result.Size = new System.Drawing.Size(416, 96);
			this.tCreateDocument2Result.TabIndex = 7;
			this.tCreateDocument2Result.Text = "";
			// 
			// bCreateDocument2Input
			// 
			this.bCreateDocument2Input.Location = new System.Drawing.Point(96, 8);
			this.bCreateDocument2Input.Name = "bCreateDocument2Input";
			this.bCreateDocument2Input.Size = new System.Drawing.Size(24, 16);
			this.bCreateDocument2Input.TabIndex = 12;
			this.bCreateDocument2Input.Text = "...";
			this.bCreateDocument2Input.Click += new System.EventHandler(this.bCreateDocument2Input_Click);
			// 
			// fDocumentWrapper
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(440, 397);
			this.Controls.Add(this.tabControl1);
			this.Controls.Add(this.label1);
			this.Name = "fDocumentWrapper";
			this.Text = "Document Wrapper";
			this.Load += new System.EventHandler(this.fDocumentWrapper_Load);
			this.tabControl1.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.tabPage2.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void fDocumentWrapper_Load(object sender, System.EventArgs e)
		{
			if(ConnectedType!=null && ConnectedClass!=null)
			{
				label1.Text += ConnectedType.FullName;
			}
			else
			{
				throw new Exception("ConnectedType and ConnectedClass are not instantiated.");
			}
		}

		private void bCreateDocumentRun_Click(object sender, System.EventArgs e)
		{
			try
			{
				tCreateDocumentResult.Text = ConnectedType.InvokeMember("CreateDocument", System.Reflection.BindingFlags.InvokeMethod, null, ConnectedClass, new object[]{}).ToString();
				MessageBox.Show(this, "CreateDocument() completed successfully.");
			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling CreateDocument()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void bCreateDocument2Run_Click(object sender, System.EventArgs e)
		{
			try
			{
				tCreateDocument2Result.Text = ConnectedType.InvokeMember("CreateDocument2", System.Reflection.BindingFlags.InvokeMethod, null, ConnectedClass, new object[]{tCreateDocument2Input.Text}).ToString();
				MessageBox.Show(this, "CreateDocument2() completed successfully.");
			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling CreateDocument2()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void bCreateDocument2Input_Click(object sender, System.EventArgs e)
		{
			if(openFileDialog1.ShowDialog(this)==DialogResult.OK)
				tCreateDocument2Input.LoadFile(openFileDialog1.FileName, RichTextBoxStreamType.PlainText);
		}
	}
}
