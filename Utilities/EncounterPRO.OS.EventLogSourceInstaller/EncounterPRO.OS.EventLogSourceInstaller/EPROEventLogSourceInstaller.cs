using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.ComponentModel;
using System.Configuration.Install;

namespace EncounterPRO.OS
{
    [RunInstaller(true)]
    public class EventLogSourceInstaller : Installer
    {
        private EventLogInstaller myEventLogInstaller;
        private string[] mySources = new string[17] { "EncounterPRO", 
                                                        "EncounterPROTransportOut", 
                                                        "EncounterPROTransportIn", 
                                                        "EncounterPROReport", 
                                                        "EncounterPROBilling", 
                                                        "EncounterPROScheduling", 
                                                        "EncounterPROMsgHandler", 
                                                        "EPROServer", 
                                                        "EPRODbmaint", 
                                                        "EPROTest", 
                                                        "EPROIncoming", 
                                                        "EPROReceiver", 
                                                        "EPROCreatedoc", 
                                                        "EPRODocument", 
                                                        "EPROWpitem", 
                                                        "EPROSchedule", 
                                                        "EPROService", };

        public EventLogSourceInstaller()
        {
            for (int i = 0; i < mySources.Length; i++)
            {
                //Create Instance of EventLogInstaller
                myEventLogInstaller = new EventLogInstaller();

                // Set the Log that source is created in
                myEventLogInstaller.Log = "Application";

                // Set the Source of Event Log, to be created.
                myEventLogInstaller.Source = mySources[i];

                // Add myEventLogInstaller to the Installers Collection.
                Installers.Add(myEventLogInstaller);
            }
        }
    }

}
