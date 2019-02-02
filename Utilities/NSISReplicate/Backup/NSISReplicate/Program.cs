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
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace NSISReplicate
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length < 3)
            {
                Console.Error.WriteLine("You must supply a source, destination, and command string.");
                Console.Error.WriteLine("EX. NSISReplicate.exe \"C:\\SourceFiles\\*.*\" \"$INSTDIR\"");
                return;
            }

            Console.WriteLine("Push $0");
            Console.WriteLine("StrCpy $0 $OUTDIR");
            process(args[0], args[1], args[2]);
            Console.WriteLine("SetOutPath $0");
            Console.WriteLine("Pop $0");
        }

        private static void process(string Source, string Dest, string Command)
        {
            string dir;
            string search = "*.*";
            if (Directory.Exists(Source))
                dir = Source;
            else
            {
                dir = Path.GetDirectoryName(Source);
                search = Path.GetFileName(Source);
            }

            if (!Directory.Exists(dir))
                return;
            Console.WriteLine("SetDetailsPrint none");
            //Console.WriteLine("CreateDirectory \"" + Dest + "\"");
            string[] files = Directory.GetFiles(dir, search);
            if (files.Length > 0)
                Console.WriteLine("SetOutPath \"" + Dest + "\"");
            Console.WriteLine("SetDetailsPrint both");
            foreach (string file in files)
            {
                string destFile = Path.Combine(Dest, Path.GetFileName(file));
                Console.WriteLine(Command.Replace("%SOURCE%", file).Replace("%DEST%", destFile).Replace("\\r","\r").Replace("\\n","\n"));
            }
            string[] subdirs = Directory.GetDirectories(dir);
            foreach (string subdir in subdirs)
            {
                process(Path.Combine(subdir, search), Path.Combine(Dest, Path.GetFileName(subdir)), Command);
            }
        }
    }
}
