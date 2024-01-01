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

-- Drop Trigger [dbo].[tr_o_Service_insert]
Print 'Drop Trigger [dbo].[tr_o_Service_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_Service_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_Service_insert]
GO

-- Create Trigger [dbo].[tr_o_Service_insert]
Print 'Create Trigger [dbo].[tr_o_Service_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_Service_insert ON dbo.o_Service
FOR INSERT
AS

UPDATE s
SET owner_id = ds.customer_id,
	definition = COALESCE(i.definition, i.description)
FROM o_Service s
	INNER JOIN inserted i
	ON s.service = i.service
	CROSS JOIN c_Database_Status ds
WHERE i.owner_id = -1


-- Set the default context object if it hasn't been set yet

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
AND s.patient_flag = 'Y'
AND (s.encounter_flag = 'Y'
	OR s.assessment_flag = 'Y'
	OR s.treatment_flag = 'Y'
	OR s.observation_flag = 'Y'
	OR s.attachment_flag = 'Y')

UPDATE s
SET default_context_object = 'Attachment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.attachment_flag = 'Y'

UPDATE s
SET default_context_object = 'Observation'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.observation_flag = 'Y'

UPDATE s
SET default_context_object = 'Treatment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.treatment_flag = 'Y'

UPDATE s
SET default_context_object = 'Assessment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.assessment_flag = 'Y'

UPDATE s
SET default_context_object = 'Encounter'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.encounter_flag = 'Y'

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.Patient_flag = 'Y'

UPDATE s
SET default_context_object = 'General'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL


GO

