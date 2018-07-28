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

-- Drop Trigger [dbo].[tr_c_report_definition_insert]
Print 'Drop Trigger [dbo].[tr_c_report_definition_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_report_definition_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_report_definition_insert]
GO

-- Create Trigger [dbo].[tr_c_report_definition_insert]
Print 'Create Trigger [dbo].[tr_c_report_definition_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_report_definition_insert ON dbo.c_report_definition
FOR INSERT
AS

-- Set the report to be locally owned if an owner_id wasn't specified
UPDATE c_report_definition
SET owner_id = c_Database_Status.customer_id
FROM c_report_definition
	INNER JOIN inserted
	ON c_report_definition.report_id = inserted.report_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

-- Add the report to c_Config_Object if it's not already there
INSERT INTO c_Config_Object (
	config_object_id,
	config_object_type,
	context_object,
	description,
	config_object_category,
	installed_version,
	latest_version,
	owner_id,
	owner_description,
	created,
	created_by,
	status)
SELECT i.report_id,
	i.config_object_type,
	r.report_type,
	r.description,
	r.report_category,
	CASE WHEN r.version >= 0 THEN r.version 
							ELSE CASE WHEN r.owner_id = d.customer_id THEN 1 ELSE 0 END
							END,
	CASE WHEN r.version >= 0 THEN r.version 
							ELSE CASE WHEN r.owner_id = d.customer_id THEN 1 ELSE 0 END
							END,
	r.owner_id,
	dbo.fn_owner_description(r.owner_id),
	r.last_updated,
	ISNULL(dbo.fn_current_epro_user(), '#SYSTEM'),
	r.status
FROM c_report_definition r
	INNER JOIN inserted i
	ON r.report_id = i.report_id
	CROSS JOIN c_Database_Status d
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Config_Object c
	WHERE r.report_id = c.config_object_id)




GO

