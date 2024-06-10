
 UPDATE [c_Menu_Item]
 SET button_help = 'GreenOlive EHR Report' 
 WHERE button_help = 'EncounterPRO Report'
 
 UPDATE [c_Menu_Item]
 SET button_help = 'View Audit Records' 
 WHERE button_help = 'View EncounterPRO Audit Records'

 UPDATE [c_Menu_Item]
 SET button_help = replace(button_help, 'Encounter', 'Appointment')
 WHERE button_help like '%encounter%'
 

 UPDATE [c_Menu_Item]
 SET [button_title] = 'Report' 
 WHERE [button_title] = 'EncounterPRO Report'

 UPDATE [c_Menu_Item]
 SET [button_title] = replace([button_title], 'Encounter', 'Appointment')
 WHERE [button_title] like '%encounter%'
 
 UPDATE [c_Menu_Item]
 SET [button_title] = 'Edit Appt'
 WHERE [button_title] = 'Edit Appointment'

 
 UPDATE c_Treatment_Type_Service
 SET button_help = 'GreenOlive EHR Report' 
 WHERE button_help = 'EncounterPRO Report'
 
