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

namespace EncounterPRO.OS
{
    /// <summary>
    /// This is the entry class for CSharpGACTool,
    /// a program for installing and removing assemblies
    /// from the GAC as well as registering and unregistering
    /// assemblies for COM-Interop.
    /// </summary>
    class Program
    {

        /// <summary>
        /// Entry point for CSharpGACTool
        /// </summary>
        /// <param name="args">Expects a switch argument and
        /// an AssemblyPath argument.  See CSharpGACTool.ProgramHelp.txt
        /// for details.</param>
        static void Main(string[] args)
        {
            string swtch = "/i", assemblyPath = null;
            if (args.Length == 0)
            {
                Console.WriteLine(GetHelpText());
                return;
            }
            foreach (string arg in args)
            {
                if (arg == "/?")
                {
                    Console.WriteLine(GetHelpText());
                    return;
                }

                if (arg.StartsWith("/"))
                { // argument starting with "/" is a switch
                    swtch = arg;
                }
                else
                { // Otherwise, treat argument as AssemblyPath
                    assemblyPath = arg;
                }
            }
            
            // If file in assemblyPath does not exist, exit
            if(!System.IO.File.Exists(assemblyPath))
            {
                Console.Error.WriteLine("Could not find assembly: "+
                    assemblyPath);
                return;
            }

            try
            {
                switch (swtch.ToLower())
                {
                    case "/i":  // Install to GAC
                        Console.WriteLine("Attempting to install to GAC:\n{0}", assemblyPath);
                        GacTools.GacInstall(assemblyPath);
                        break;
                    case "/u":  // Remove from GAC
                        Console.WriteLine("Attempting to remove from GAC:\n{0}", assemblyPath);
                        GacTools.GacRemove(assemblyPath);
                        break;
                    case "/r":  // Register for COM-Interop
                        Console.WriteLine("Attempting to register for COM-Interop:\n{0}", assemblyPath);
                        GacTools.RegisterAssembly(assemblyPath);
                        break;
                    case "/ur": // UnRegister for COM-Interop
                        Console.WriteLine("Attempting to unregister for COM-Interop:\n{0}", assemblyPath);
                        GacTools.UnRegisterAssembly(assemblyPath);
                        break;
                    default:
                        Console.Error.WriteLine("Unrecognized switch: {0}", swtch);
                        return;
                }
                Console.WriteLine("Success!");
            }
            catch (Exception exc)
            {
                Console.Error.WriteLine(exc.Message);
                return;
            }
        }

        /// <summary>
        /// Gets the contents of the embedded resource
        /// CSharpGACTool.ProgramHelp.txt
        /// </summary>
        /// <returns>String containing help text for program</returns>
        static string GetHelpText()
        {
            System.Reflection.Assembly me = 
                System.Reflection.Assembly.GetExecutingAssembly();
            System.IO.Stream resourceStream =
                me.GetManifestResourceStream("EncounterPRO.OS.ProgramHelp.txt");
            System.IO.StreamReader sr =
                new System.IO.StreamReader(resourceStream);
            string helpText = sr.ReadToEnd();
            sr.Close();
            return helpText;
        }
    }
}
