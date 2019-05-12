# encounterpro-os
EncounterPro Open Source Electronic Health Record EHR/EMR and Physician Workflow

IDE / app dev notes

The Release Notes for EncounterPro_OS are linked in the Wiki homepage: 

https://github.com/christillman/encounterpro_os/wiki

Use  the latest binary installer to install the compiled EncounterPro. 
The "Full" installer will install SQL Server Express and the database. The SQL Server name will be 

localhost\encounterpro_os

and the tables are in the dbo schema.

I use the JDBC URL 

jdbc:jtds:sqlserver://localhost/encounterpro_os;ainstance=encounterpro_os;namedPipe=true;useCursors=true

This works because the I'm logged in the same way as when I installed EncounterPro and SQL Server
Express.

To start using the application after a full install, you can use the PIN (access code) 0222. 
In the data (c_user) this is Dr. Pat Pedia's access code. You need office ID 0001 in the startup
DB dialog. "encounterpro_os" is the database in that dialog.

For images to show when you're running in the IDE, you need to put the IconFiles image folder 
on your system path (I use the System control panel). You need to restart the IDE.

Attachment locations are in c_Attachment_Location. You'll need to populate a server and share. For
development, I use localhost and a file share named attachments.

UPDATE c_Attachment_Location 
SET attachment_server = 'localhost', attachment_share = 'attachments'
WHERE attachment_location_id = 2



