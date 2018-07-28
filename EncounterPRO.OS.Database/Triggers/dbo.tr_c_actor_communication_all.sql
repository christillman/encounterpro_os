--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_actor_communication_all]
Print 'Drop Trigger [dbo].[tr_c_actor_communication_all]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_actor_communication_all]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_actor_communication_all]
GO

-- Create Trigger [dbo].[tr_c_actor_communication_all]
Print 'Create Trigger [dbo].[tr_c_actor_communication_all]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_actor_communication_all ON dbo.c_actor_communication
FOR INSERT, UPDATE
AS

-- Update consultant columns
UPDATE c
SET phone = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Phone'
AND communication_name = 'Phone'
AND ISNULL(c.phone, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET phone2 = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Phone'
AND communication_name = 'Phone2'
AND ISNULL(c.phone2, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET fax = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Fax'
AND communication_name = 'Fax'
AND ISNULL(c.fax, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET email = CAST(i.communication_value AS varchar(64))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Email'
AND communication_name = 'Email'
AND ISNULL(c.email, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

-----------------------------------------------------------------------------
-- Update the authority phone number
-----------------------------------------------------------------------------
DECLARE @ls_progress_key varchar(40)

SELECT @ls_progress_key = CASE WHEN customer_id > 0 THEN CAST(customer_id AS varchar(12)) + '^authority_id'
													ELSE 'authority_id' END
FROM c_Database_Status

DECLARE @authorities TABLE (
	user_id varchar(24) NOT NULL,
	actor_id int NOT NULL,
	authority_id varchar(24) NOT NULL)

INSERT INTO @authorities (
	user_id,
	actor_id,
	authority_id)
SELECT u.user_id,
		u.actor_id,
		CAST(p.progress_value AS varchar(24))
FROM inserted i
	INNER JOIN c_User u
	ON i.actor_id = u.actor_id
	INNER JOIN c_User_Progress p
	ON p.user_id = u.user_id
WHERE p.progress_type = 'ID'
AND p.progress_key = @ls_progress_key
AND p.current_flag = 'Y'
AND i.status = 'OK'

UPDATE a
SET authority_phone_number = CAST(i.communication_value AS varchar(16))
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.communication_type = 'Phone'
AND i.communication_name = 'Phone'
AND ISNULL(a.authority_phone_number, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE u
SET email_address = CAST(i.communication_value AS varchar(64))
FROM c_User u
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Email'
AND i.communication_name = 'Email'
AND ISNULL(u.email_address, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'


-- Update office columns

UPDATE o
SET phone = CAST(i.communication_value AS varchar(14))
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Phone'
AND i.communication_name = 'Phone'
AND u.actor_class = 'Office'
AND ISNULL(o.phone, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE o
SET fax = CAST(i.communication_value AS varchar(14))
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Fax'
AND i.communication_name = 'Fax'
AND u.actor_class = 'Office'
AND ISNULL(o.fax, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'


GO

