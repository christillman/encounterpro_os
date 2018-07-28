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

-- Drop Trigger [dbo].[tr_Patient_WP_Update]
Print 'Drop Trigger [dbo].[tr_Patient_WP_Update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_Patient_WP_Update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_Patient_WP_Update]
GO

-- Create Trigger [dbo].[tr_Patient_WP_Update]
Print 'Create Trigger [dbo].[tr_Patient_WP_Update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE    TRIGGER tr_Patient_WP_Update ON dbo.p_Patient_WP
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

-- If the workplan is being converted to out-of-office and the parent
-- workplan item has its step_flag = 'N', then convert the 
-- parent workplan_item to out-of-office as well

IF UPDATE( in_office_flag )
BEGIN
	UPDATE wi
	SET 	in_office_flag = 'N'
	FROM 	p_Patient_WP_item wi
	INNER JOIN inserted i
	ON 	wi.patient_workplan_item_id = i.parent_patient_workplan_item_id
	INNER JOIN deleted d
	ON 	i.patient_workplan_id = d.patient_workplan_id
	WHERE 	i.in_office_flag = 'N'
	AND 	d.in_office_flag = 'Y'
	AND 	wi.step_flag = 'N'
END

IF UPDATE( description )
	BEGIN
	-- If the workplan item description is defined to include the workplan description
	-- then change it when the workplan description changes
	DECLARE  @ls_wp_token varchar(32)
	SET @ls_wp_token = '%WP%'

	UPDATE item
	SET	description = 	CAST (
								STUFF
								(		c.description
									,CHARINDEX(@ls_wp_token, c.description)
									,DATALENGTH(@ls_wp_token)
									,inserted.description
								) AS varchar(80) )
	FROM p_Patient_WP_Item item
		INNER JOIN inserted
		ON inserted.patient_workplan_id = item.patient_workplan_id
		INNER JOIN c_Workplan_Item c
		ON item.workplan_id = c.workplan_id
		AND item.item_number = c.item_number
	WHERE
		CHARINDEX(@ls_wp_token, c.description) > 0

	END

IF UPDATE (owned_by) OR UPDATE( parent_patient_workplan_item_id )
BEGIN
	UPDATE wi
	SET 	owned_by = i.owned_by
	FROM inserted AS i 
	INNER JOIN deleted AS d
	ON 	i.patient_workplan_id = d.patient_workplan_id
	AND	ISNULL( d.owned_by, '^NULL^' )<> i.owned_by
	INNER JOIN p_Patient_WP_Item AS wi
	ON 	i.parent_patient_workplan_item_id = wi.patient_workplan_item_id
	AND 	ISNULL( wi.owned_by, '^NULL^' ) <> i.owned_by
	WHERE	i.parent_patient_workplan_item_id IS NOT NULL
	AND	i.owned_by IS NOT NULL
END



GO

