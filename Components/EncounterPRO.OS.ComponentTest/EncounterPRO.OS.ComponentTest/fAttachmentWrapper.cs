using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace EproLibBaseTest
{
	/// <summary>
	/// Summary description for fDocumentWrapper.
	/// </summary>
	public class fAttachmentWrapper : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.RichTextBox tCreateDocumentResult;
		private System.Windows.Forms.Label label3;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;


		private System.Type connectedType = null;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.TabPage tabPage3;
		private System.Windows.Forms.TabPage tabPage4;
		private System.Windows.Forms.TabPage tabPage5;
		private System.Windows.Forms.Button bIs_DisplayableRun;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox tExtension;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.TextBox tExtension2;
		private System.Windows.Forms.Button bIs_EditableRun;
		private System.Windows.Forms.RichTextBox rtResult2;
		private System.Windows.Forms.Label label8;
		private System.Windows.Forms.TextBox tRenderExtension;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Label label10;
		private System.Windows.Forms.TextBox tRenderFile;
		private System.Windows.Forms.Label label11;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.PictureBox pRenderResult;
		private System.Windows.Forms.Button bRenderFile;
		private System.Windows.Forms.TextBox tRenderWidth;
		private System.Windows.Forms.Label label12;
		private System.Windows.Forms.TextBox tRenderHeight;
		private System.Windows.Forms.Label label13;
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
		public fAttachmentWrapper()
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
			this.label4 = new System.Windows.Forms.Label();
			this.tExtension = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.bIs_DisplayableRun = new System.Windows.Forms.Button();
			this.label3 = new System.Windows.Forms.Label();
			this.tCreateDocumentResult = new System.Windows.Forms.RichTextBox();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.label5 = new System.Windows.Forms.Label();
			this.tExtension2 = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.bIs_EditableRun = new System.Windows.Forms.Button();
			this.label7 = new System.Windows.Forms.Label();
			this.rtResult2 = new System.Windows.Forms.RichTextBox();
			this.tabPage3 = new System.Windows.Forms.TabPage();
			this.tabPage4 = new System.Windows.Forms.TabPage();
			this.tabPage5 = new System.Windows.Forms.TabPage();
			this.tRenderHeight = new System.Windows.Forms.TextBox();
			this.label13 = new System.Windows.Forms.Label();
			this.tRenderWidth = new System.Windows.Forms.TextBox();
			this.label12 = new System.Windows.Forms.Label();
			this.panel1 = new System.Windows.Forms.Panel();
			this.pRenderResult = new System.Windows.Forms.PictureBox();
			this.tRenderFile = new System.Windows.Forms.TextBox();
			this.label11 = new System.Windows.Forms.Label();
			this.label8 = new System.Windows.Forms.Label();
			this.tRenderExtension = new System.Windows.Forms.TextBox();
			this.label9 = new System.Windows.Forms.Label();
			this.button1 = new System.Windows.Forms.Button();
			this.label10 = new System.Windows.Forms.Label();
			this.bRenderFile = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.tabControl1.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.tabPage2.SuspendLayout();
			this.tabPage5.SuspendLayout();
			this.panel1.SuspendLayout();
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
			this.tabControl1.Controls.Add(this.tabPage3);
			this.tabControl1.Controls.Add(this.tabPage4);
			this.tabControl1.Controls.Add(this.tabPage5);
			this.tabControl1.Location = new System.Drawing.Point(0, 48);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(444, 356);
			this.tabControl1.TabIndex = 1;
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.label4);
			this.tabPage1.Controls.Add(this.tExtension);
			this.tabPage1.Controls.Add(this.label2);
			this.tabPage1.Controls.Add(this.bIs_DisplayableRun);
			this.tabPage1.Controls.Add(this.label3);
			this.tabPage1.Controls.Add(this.tCreateDocumentResult);
			this.tabPage1.Location = new System.Drawing.Point(4, 22);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Size = new System.Drawing.Size(436, 330);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "Is_Displayable";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(112, 32);
			this.label4.Name = "label4";
			this.label4.TabIndex = 9;
			this.label4.Text = "(ex: bmp)";
			// 
			// tExtension
			// 
			this.tExtension.Location = new System.Drawing.Point(8, 32);
			this.tExtension.Name = "tExtension";
			this.tExtension.TabIndex = 8;
			this.tExtension.Text = "";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 8);
			this.label2.Name = "label2";
			this.label2.TabIndex = 7;
			this.label2.Text = "Extension";
			// 
			// bIs_DisplayableRun
			// 
			this.bIs_DisplayableRun.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.bIs_DisplayableRun.Location = new System.Drawing.Point(352, 296);
			this.bIs_DisplayableRun.Name = "bIs_DisplayableRun";
			this.bIs_DisplayableRun.TabIndex = 6;
			this.bIs_DisplayableRun.Text = "Run";
			this.bIs_DisplayableRun.Click += new System.EventHandler(this.bIs_DisplayableRun_Click);
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 56);
			this.label3.Name = "label3";
			this.label3.TabIndex = 5;
			this.label3.Text = "Result";
			// 
			// tCreateDocumentResult
			// 
			this.tCreateDocumentResult.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tCreateDocumentResult.Location = new System.Drawing.Point(8, 80);
			this.tCreateDocumentResult.Name = "tCreateDocumentResult";
			this.tCreateDocumentResult.Size = new System.Drawing.Size(416, 208);
			this.tCreateDocumentResult.TabIndex = 4;
			this.tCreateDocumentResult.Text = "";
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.label5);
			this.tabPage2.Controls.Add(this.tExtension2);
			this.tabPage2.Controls.Add(this.label6);
			this.tabPage2.Controls.Add(this.bIs_EditableRun);
			this.tabPage2.Controls.Add(this.label7);
			this.tabPage2.Controls.Add(this.rtResult2);
			this.tabPage2.Location = new System.Drawing.Point(4, 22);
			this.tabPage2.Name = "tabPage2";
			this.tabPage2.Size = new System.Drawing.Size(436, 330);
			this.tabPage2.TabIndex = 1;
			this.tabPage2.Text = "Is_Editable";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(112, 32);
			this.label5.Name = "label5";
			this.label5.TabIndex = 15;
			this.label5.Text = "(ex: bmp)";
			// 
			// tExtension2
			// 
			this.tExtension2.Location = new System.Drawing.Point(8, 32);
			this.tExtension2.Name = "tExtension2";
			this.tExtension2.TabIndex = 14;
			this.tExtension2.Text = "";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(8, 8);
			this.label6.Name = "label6";
			this.label6.TabIndex = 13;
			this.label6.Text = "Extension";
			// 
			// bIs_EditableRun
			// 
			this.bIs_EditableRun.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.bIs_EditableRun.Location = new System.Drawing.Point(352, 296);
			this.bIs_EditableRun.Name = "bIs_EditableRun";
			this.bIs_EditableRun.TabIndex = 12;
			this.bIs_EditableRun.Text = "Run";
			this.bIs_EditableRun.Click += new System.EventHandler(this.bIs_EditableRun_Click);
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(8, 56);
			this.label7.Name = "label7";
			this.label7.TabIndex = 11;
			this.label7.Text = "Result";
			// 
			// rtResult2
			// 
			this.rtResult2.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.rtResult2.Location = new System.Drawing.Point(8, 80);
			this.rtResult2.Name = "rtResult2";
			this.rtResult2.Size = new System.Drawing.Size(416, 208);
			this.rtResult2.TabIndex = 10;
			this.rtResult2.Text = "";
			// 
			// tabPage3
			// 
			this.tabPage3.Location = new System.Drawing.Point(4, 22);
			this.tabPage3.Name = "tabPage3";
			this.tabPage3.Size = new System.Drawing.Size(436, 330);
			this.tabPage3.TabIndex = 2;
			this.tabPage3.Text = "Edit";
			// 
			// tabPage4
			// 
			this.tabPage4.Location = new System.Drawing.Point(4, 22);
			this.tabPage4.Name = "tabPage4";
			this.tabPage4.Size = new System.Drawing.Size(436, 330);
			this.tabPage4.TabIndex = 3;
			this.tabPage4.Text = "Display";
			// 
			// tabPage5
			// 
			this.tabPage5.Controls.Add(this.tRenderHeight);
			this.tabPage5.Controls.Add(this.label13);
			this.tabPage5.Controls.Add(this.tRenderWidth);
			this.tabPage5.Controls.Add(this.label12);
			this.tabPage5.Controls.Add(this.panel1);
			this.tabPage5.Controls.Add(this.tRenderFile);
			this.tabPage5.Controls.Add(this.label11);
			this.tabPage5.Controls.Add(this.label8);
			this.tabPage5.Controls.Add(this.tRenderExtension);
			this.tabPage5.Controls.Add(this.label9);
			this.tabPage5.Controls.Add(this.button1);
			this.tabPage5.Controls.Add(this.label10);
			this.tabPage5.Controls.Add(this.bRenderFile);
			this.tabPage5.Location = new System.Drawing.Point(4, 22);
			this.tabPage5.Name = "tabPage5";
			this.tabPage5.Size = new System.Drawing.Size(436, 330);
			this.tabPage5.TabIndex = 4;
			this.tabPage5.Text = "Render";
			// 
			// tRenderHeight
			// 
			this.tRenderHeight.Location = new System.Drawing.Point(120, 80);
			this.tRenderHeight.Name = "tRenderHeight";
			this.tRenderHeight.TabIndex = 28;
			this.tRenderHeight.Text = "150";
			// 
			// label13
			// 
			this.label13.Location = new System.Drawing.Point(120, 56);
			this.label13.Name = "label13";
			this.label13.TabIndex = 27;
			this.label13.Text = "Height";
			// 
			// tRenderWidth
			// 
			this.tRenderWidth.Location = new System.Drawing.Point(8, 80);
			this.tRenderWidth.Name = "tRenderWidth";
			this.tRenderWidth.TabIndex = 26;
			this.tRenderWidth.Text = "400";
			// 
			// label12
			// 
			this.label12.Location = new System.Drawing.Point(8, 56);
			this.label12.Name = "label12";
			this.label12.TabIndex = 25;
			this.label12.Text = "Width";
			// 
			// panel1
			// 
			this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.panel1.AutoScroll = true;
			this.panel1.Controls.Add(this.pRenderResult);
			this.panel1.Location = new System.Drawing.Point(8, 136);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(416, 152);
			this.panel1.TabIndex = 24;
			// 
			// pRenderResult
			// 
			this.pRenderResult.Location = new System.Drawing.Point(8, 8);
			this.pRenderResult.Name = "pRenderResult";
			this.pRenderResult.TabIndex = 0;
			this.pRenderResult.TabStop = false;
			// 
			// tRenderFile
			// 
			this.tRenderFile.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tRenderFile.Location = new System.Drawing.Point(208, 32);
			this.tRenderFile.Name = "tRenderFile";
			this.tRenderFile.Size = new System.Drawing.Size(184, 20);
			this.tRenderFile.TabIndex = 23;
			this.tRenderFile.Text = "";
			// 
			// label11
			// 
			this.label11.Location = new System.Drawing.Point(208, 8);
			this.label11.Name = "label11";
			this.label11.TabIndex = 22;
			this.label11.Text = "File";
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(112, 32);
			this.label8.Name = "label8";
			this.label8.TabIndex = 21;
			this.label8.Text = "(ex: bmp)";
			// 
			// tRenderExtension
			// 
			this.tRenderExtension.Location = new System.Drawing.Point(8, 32);
			this.tRenderExtension.Name = "tRenderExtension";
			this.tRenderExtension.TabIndex = 20;
			this.tRenderExtension.Text = "";
			// 
			// label9
			// 
			this.label9.Location = new System.Drawing.Point(8, 8);
			this.label9.Name = "label9";
			this.label9.TabIndex = 19;
			this.label9.Text = "Extension";
			// 
			// button1
			// 
			this.button1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.button1.Location = new System.Drawing.Point(352, 296);
			this.button1.Name = "button1";
			this.button1.TabIndex = 18;
			this.button1.Text = "Run";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// label10
			// 
			this.label10.Location = new System.Drawing.Point(8, 112);
			this.label10.Name = "label10";
			this.label10.TabIndex = 17;
			this.label10.Text = "Result";
			// 
			// bRenderFile
			// 
			this.bRenderFile.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.bRenderFile.Location = new System.Drawing.Point(400, 32);
			this.bRenderFile.Name = "bRenderFile";
			this.bRenderFile.Size = new System.Drawing.Size(24, 24);
			this.bRenderFile.TabIndex = 1;
			this.bRenderFile.Text = "...";
			this.bRenderFile.Click += new System.EventHandler(this.bRenderFile_Click);
			// 
			// fAttachmentWrapper
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(440, 397);
			this.Controls.Add(this.tabControl1);
			this.Controls.Add(this.label1);
			this.Name = "fAttachmentWrapper";
			this.Text = "Attachment Wrapper";
			this.Load += new System.EventHandler(this.fDocumentWrapper_Load);
			this.tabControl1.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.tabPage2.ResumeLayout(false);
			this.tabPage5.ResumeLayout(false);
			this.panel1.ResumeLayout(false);
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

		private void bIs_DisplayableRun_Click(object sender, System.EventArgs e)
		{
			try
			{
				tCreateDocumentResult.Text = ConnectedType.InvokeMember("Is_Displayable", System.Reflection.BindingFlags.InvokeMethod, null, ConnectedClass, new object[]{tExtension.Text}).ToString();
				MessageBox.Show(this, "Is_Displayable() completed successfully.");
			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling Is_Displayable()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void bIs_EditableRun_Click(object sender, System.EventArgs e)
		{
			try
			{
				rtResult2.Text = ConnectedType.InvokeMember("Is_Editable", System.Reflection.BindingFlags.InvokeMethod, null, ConnectedClass, new object[]{tExtension2.Text}).ToString();
				MessageBox.Show(this, "Is_Editable() completed successfully.");
			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling Is_Editable()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void bRenderFile_Click(object sender, System.EventArgs e)
		{
			openFileDialog1.FileName = tRenderFile.Text;
			if(openFileDialog1.ShowDialog(this)==DialogResult.OK)
				tRenderFile.Text = openFileDialog1.FileName;
		}

		private void button1_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.IO.BinaryReader br = new System.IO.BinaryReader(System.IO.File.OpenRead(tRenderFile.Text));
				byte[] srcdata = br.ReadBytes((int)br.BaseStream.Length);
				br.Close();
				Type[] types = new Type[5];
				types[0] = typeof(byte[]);
				types[1] = typeof(string);
				types[2] = typeof(int);
				types[3] = typeof(int);
				types[4] = Type.GetType("System.String&");
				object[] parm = new object[5];
				parm[0] = srcdata;
				parm[1] = System.IO.Path.GetExtension(tRenderFile.Text);
				parm[2] = Int32.Parse(tRenderWidth.Text);
				parm[3] = Int32.Parse(tRenderHeight.Text);
				parm[4] = tRenderExtension.Text;
				System.Reflection.MethodInfo mi = ConnectedType.GetMethod("Render", types);
				byte[] bmpdata = (byte[])mi.Invoke(ConnectedClass, parm);
				System.IO.MemoryStream ms = new System.IO.MemoryStream();
				ms.Write(bmpdata,0,bmpdata.Length);
				ms.Position=0;
				Image bmp = Bitmap.FromStream(ms);
				pRenderResult.Image = bmp;
				pRenderResult.Width = bmp.Width;
				pRenderResult.Height = bmp.Height;
				tRenderExtension.Text = (string)parm[4];
				MessageBox.Show(this, "Render() completed successfully.");
			}
			catch(Exception exc)
			{
				MessageBox.Show(this, exc.ToString(), "Error calling Render()", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}
	}
}
