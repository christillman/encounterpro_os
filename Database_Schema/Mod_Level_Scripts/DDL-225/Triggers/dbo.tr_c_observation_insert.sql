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

-- Drop Trigger [dbo].[tr_c_observation_insert]
Print 'Drop Trigger [dbo].[tr_c_observation_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_observation_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_observation_insert]
GO

-- Create Trigger [dbo].[tr_c_observation_insert]
Print 'Create Trigger [dbo].[tr_c_observation_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_observation_insert ON dbo.c_Observation
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c_observation
SET owner_id = c_Database_Status.customer_id,
	definition = COALESCE(inserted.definition, inserted.description)
FROM c_observation
	INNER JOIN inserted
	ON c_observation.observation_id = inserted.observation_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1


UPDATE t
SET last_updated = i.last_updated
FROM c_Observation_Tree as t
	JOIN inserted as i
		ON t.child_observation_id = i.observation_id

DECLARE @ls_updated_by varchar(24)

SELECT @ls_updated_by = min(updated_by)
FROM inserted

EXECUTE sp_table_update @ps_table_name = 'c_Observation', @ps_updated_by = @ls_updated_by

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Observation'
		OR e.object_key <> i.observation_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Observation'
	AND e.object_key = i.observation_id
WHERE e.object_id <> i.id

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type ,
	owner_id)
SELECT o.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = o.observation_id,
	description = ISNULL(o.description, '<No Description>'),
	object_type = 'Observation',
	o.owner_id
FROM inserted o
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE o.id = e.object_id
	)

GO

