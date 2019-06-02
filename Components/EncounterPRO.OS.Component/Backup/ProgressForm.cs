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

namespace EncounterPRO.OS.Component
{
	/// <summary>
	/// Summary description for ProgressForm.
	/// </summary>
	public class ProgressForm : System.Windows.Forms.Form
	{
		private static ProgressForm me = null;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ProgressBar progressBar1;
		private System.ComponentModel.IContainer components;
		private System.Windows.Forms.Timer timer1;
		private System.Windows.Forms.Panel panel1;

		private string Title
		{
			get{return Text;}
			set{Text =value;}
		}

		private string Info
		{
			get{return label1.Text;}
			set{label1.Text=value;}
		}
		
		private int Progress
		{
			get{return progressBar1.Value;}
			set{progressBar1.Value = value;}
		}

		private ProgressType progressType = ProgressType.Standard;
		private ProgressType ProgressType
		{
			get{return progressType;}
			set
			{
				progressType=value;
				switch(progressType)
				{
					case ProgressType.Standard:
						timer1.Stop();
						panel1.Hide();
						progressBar1.Show();
						break;
					case ProgressType.Marquee:
						progressBar1.Hide();
						panel1.Show();
						timer1.Start();
						break;
				}
			}
		}
		
		private ProgressForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		public static void ShowProgress(string Title, ProgressType Type)
		{
			System.Threading.Thread showProgressThread = new System.Threading.Thread(new System.Threading.ThreadStart(showProgress));
			tmpTitle = Title;
			tmpType = Type;
			showProgressThread.Start();
		}

		private static string tmpTitle;
		private static ProgressType tmpType;
		private static void showProgress()
		{
			if(me!=null)
				try{me.Dispose();}
				catch{}
			me = new ProgressForm();
			me.Title = tmpTitle;
			me.ProgressType = tmpType;
			me.ShowDialog();
		}

		public static void UpdateProgress(int Value, string Info)
		{
			System.Threading.Thread updateProgressThread = new System.Threading.Thread(new System.Threading.ThreadStart(updateProgress));
			tmpValue = Value;
			tmpInfo = Info;
			updateProgressThread.Start();
		}

		private static int tmpValue;
		private static string tmpInfo;
		private static void updateProgress()
		{
			if(me==null)
				return;
			if(tmpValue>=0 && tmpValue<=100)
				me.progressBar1.Value = tmpValue;
			me.Info = tmpInfo;
		}

		public static void CloseProgress()
		{
			if(me!=null)
				try{me.Close();}
				catch{}
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
			this.components = new System.ComponentModel.Container();
			this.label1 = new System.Windows.Forms.Label();
			this.progressBar1 = new System.Windows.Forms.ProgressBar();
			this.timer1 = new System.Windows.Forms.Timer(this.components);
			this.panel1 = new System.Windows.Forms.Panel();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 72);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(312, 32);
			this.label1.TabIndex = 0;
			this.label1.Text = "Please wait...";
			// 
			// progressBar1
			// 
			this.progressBar1.Location = new System.Drawing.Point(8, 8);
			this.progressBar1.Name = "progressBar1";
			this.progressBar1.Size = new System.Drawing.Size(312, 56);
			this.progressBar1.TabIndex = 1;
			// 
			// timer1
			// 
			this.timer1.Interval = 250;
			this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
			// 
			// panel1
			// 
			this.panel1.Location = new System.Drawing.Point(8, 8);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(312, 56);
			this.panel1.TabIndex = 2;
			this.panel1.Visible = false;
			this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
			// 
			// ProgressForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(330, 110);
			this.ControlBox = false;
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.progressBar1);
			this.Controls.Add(this.label1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Name = "ProgressForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "ProgressForm";
			this.ResumeLayout(false);

		}
		#endregion

		private void timer1_Tick(object sender, System.EventArgs e)
		{
			panel1.Refresh();
		}

		int marqueeStep=15;
		int maxStuff=5;
		int stuffWidth=15;
		System.Collections.ArrayList movingStuff = new ArrayList();
		Color barColor = Color.Blue;
		private void panel1_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
			e.Graphics.FillRectangle(Brushes.White, panel1.ClientRectangle);
			if(movingStuff.Count<maxStuff)
			{
				if(movingStuff.Count==0)
					movingStuff.Add(stuffWidth*-1);
				else
				{
					int lastThing=Int32.MaxValue;
					foreach(int thing in movingStuff)
					{
						lastThing=Math.Min(thing,lastThing);
					}
					if(lastThing>=stuffWidth)
						movingStuff.Add(stuffWidth*-1);
				}

			}
			foreach(int thing in movingStuff)
			{
				e.Graphics.FillEllipse(
					Brushes.Blue, 
					thing, 
					(panel1.ClientRectangle.Height/2)-(stuffWidth/2),
					stuffWidth,
					stuffWidth);
			}
			for(int i=movingStuff.Count-1; i>-1; i--)
			{
				movingStuff[i] = marqueeStep + (int)movingStuff[i];
				if(((int)movingStuff[i])>panel1.ClientRectangle.Right)
					movingStuff.RemoveAt(i);
			}		
		}
	}
	public enum ProgressType
	{
		Standard, Marquee
	}
}
