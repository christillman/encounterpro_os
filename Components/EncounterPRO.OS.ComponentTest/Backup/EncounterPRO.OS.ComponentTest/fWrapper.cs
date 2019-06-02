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
    /// Summary description for fWrapper.
    /// </summary>
    public class fWrapper : System.Windows.Forms.Form
    {
        private System.Windows.Forms.TabControl tabControl1;
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.Container components = null;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;

        private object connectedClass = null;
        public object ConnectedClass
        {
            get { return connectedClass; }
            set { connectedClass = value; }
        }

        public fWrapper()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();
        }

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(0, 0);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(456, 309);
            this.tabControl1.TabIndex = 0;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.Filter = "XML Files|*.xml|All Files (*.*)|*.*";
            // 
            // fWrapper
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(456, 309);
            this.Controls.Add(this.tabControl1);
            this.Name = "fWrapper";
            this.Text = "fWrapper";
            this.Load += new System.EventHandler(this.fWrapper_Load);
            this.ResumeLayout(false);

        }
        #endregion

        private void b_Click(object sender, EventArgs e)
        {
            Button b = (Button)sender;
            TabPage tp = (TabPage)b.Tag;

            System.Reflection.MethodInfo mi = (System.Reflection.MethodInfo)tp.Tag;
            System.Collections.ArrayList list = new ArrayList();
            foreach (Control c in tp.Controls)
            {
                if (c is RichTextBox)
                {
                    RichTextBox t = (RichTextBox)c;
                    list.Add(t.Text);
                }
            }
            try
            {
                object result = mi.Invoke(connectedClass, (object[])list.ToArray(typeof(object)));
                if (result == null)
                    MessageBox.Show(this, "Method invocation successful with null return.", "Success");
                else
                {
                    fResult fr = new fResult();
                    fr.Result = result.ToString();
                    fr.Show();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show(this, exc.ToString(), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void fWrapper_Load(object sender, System.EventArgs e)
        {
            System.Reflection.MethodInfo[] baseMethods = connectedClass.GetType().BaseType.GetMethods();
            foreach (System.Reflection.MethodInfo mi in connectedClass.GetType().GetMethods())
            {
                if (!mi.IsPublic)
                    continue;
                bool cont = false;
                foreach (System.Reflection.MethodInfo bmi in baseMethods)
                {
                    if (bmi.Name == mi.Name)
                    {
                        cont = true;
                        continue;
                    }
                }
                if (cont)
                    continue;
                TabPage tp = new TabPage(mi.Name);
                tp.Tag = mi;

                Button b = new Button();
                b.Tag = tp;
                b.Click += new EventHandler(b_Click);
                b.Text = "Go";
                tp.Controls.Add(b);
                b.Location = new Point(tp.Right - 4 - b.Width, 4);
                b.Anchor = AnchorStyles.Top | AnchorStyles.Right;
                int yPos = b.Bottom;

                tabControl1.TabPages.Add(tp);
                foreach (System.Reflection.ParameterInfo pi in mi.GetParameters())
                {
                    yPos += 4;
                    Label l = new Label();
                    l.Text = pi.Name;
                    tp.Controls.Add(l);
                    l.Location = new Point(4, yPos);
                    l.AutoSize = true;

                    Button b2 = new Button();
                    b2.Text = "...";
                    b2.Width = 24;
                    tp.Controls.Add(b2);
                    b2.Location = new Point(tp.Width - 4 - b2.Width, yPos);
                    b2.Height = l.Height;
                    b2.Anchor = AnchorStyles.Top | AnchorStyles.Right;
                    b2.Click += new EventHandler(openFile_Click);

                    yPos = l.Bottom;

                    yPos += 4;
                    RichTextBox t = new RichTextBox();
                    b2.Tag = t;
                    t.Tag = pi;
                    t.Multiline = true;
                    t.ScrollBars = RichTextBoxScrollBars.Both;
                    t.Height = 150;
                    tp.Controls.Add(t);
                    t.Location = new Point(4, yPos);
                    t.Width = tp.Width - 8;
                    t.Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right;

                    yPos = t.Bottom;
                }
            }
        }

        private void openFile_Click(object sender, EventArgs e)
        {
            Button b = (Button)sender;
            RichTextBox t = (RichTextBox)b.Tag;

            if (openFileDialog1.ShowDialog(this) == DialogResult.OK)
            {
                t.Text = System.IO.File.ReadAllText(openFileDialog1.FileName);
            }
        }
    }
}
