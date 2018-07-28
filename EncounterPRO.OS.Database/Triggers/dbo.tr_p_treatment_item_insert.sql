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

-- Drop Trigger [dbo].[tr_p_treatment_item_insert]
Print 'Drop Trigger [dbo].[tr_p_treatment_item_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_treatment_item_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_treatment_item_insert]
GO

-- Create Trigger [dbo].[tr_p_treatment_item_insert]
Print 'Create Trigger [dbo].[tr_p_treatment_item_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_treatment_item_insert ON dbo.p_Treatment_Item
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE t
SET begin_date = COALESCE(t.begin_date, t.created, getdate())
FROM inserted i
	INNER JOIN p_treatment_item t
	ON i.cpr_id = t.cpr_id
	AND i.treatment_id = t.treatment_id

UPDATE t
SET bill_procedure = c.bill_procedure,
	bill_observation_collect = c.bill_observation_collect,
	bill_observation_perform = c.bill_observation_perform,
	bill_children_collect = c.bill_children_collect,
	bill_children_perform = c.bill_children_perform,
	specialty_id = COALESCE(t.specialty_id, c.referral_specialty_id)
FROM inserted i
	INNER JOIN p_Treatment_Item t
	ON i.cpr_id = t.cpr_id
	AND i.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type c
	ON i.treatment_type = c.treatment_type

UPDATE t
SET brand_name_required = COALESCE(t.brand_name_required, 'N'),
	refills = COALESCE(t.refills, 0)
FROM inserted i
	INNER JOIN p_Treatment_Item t
	ON i.cpr_id = t.cpr_id
	AND i.treatment_id = t.treatment_id
WHERE i.treatment_type = 'MEDICATION'

IF UPDATE( treatment_status ) 
	BEGIN
	UPDATE t
	SET open_flag = CASE WHEN t.treatment_status IN ('CLOSED', 'CANCELLED', 'MODIFIED') THEN 'N' ELSE 'Y' END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id

	-- Make sure the end_date is populated if the treatment isn't open
	UPDATE t
	SET end_date = COALESCE(t.end_date, t.begin_date)
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id
	WHERE t.open_flag = 'N'
	AND t.end_date IS NULL
	END

-- Go get the extended treatment_description progress from the original treatment record
IF UPDATE( original_treatment_id ) 
	BEGIN
	INSERT INTO p_Treatment_Progress (
		cpr_id,
		treatment_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		progress,
		risk_level,
		created,
		created_by)
	SELECT i.cpr_id,
		i.treatment_id,
		i.open_encounter_id,
		i.ordered_by,
		getdate(),
		p.progress_type,
		p.progress_key,
		p.progress_value,
		p.progress,
		p.risk_level,
		getdate(),
		i.created_by
	FROM inserted i
		INNER JOIN p_Treatment_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.original_treatment_id = p.treatment_id
	WHERE p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description'
	AND p.current_flag = 'Y'
	AND LEN(i.treatment_description) = 80
	AND i.treatment_description = CAST(p.progress AS varchar(80))
	AND NOT EXISTS (
		SELECT 1
		FROM p_Treatment_Progress p2
		WHERE i.cpr_id = p2.cpr_id
		AND i.treatment_id = p2.treatment_id
		AND p2.progress_type = 'Modify'
		AND p2.progress_key = 'treatment_description'
		AND p2.current_flag = 'Y')
	
	END

DECLARE @ls_cpr_id varchar(12),
		@ll_treatment_id int,
		@ll_encounter_id int,
		@ls_created_by varchar(24)



-- Update the ordered_by_supervisor if the ordered_by user has a supervisor but it wasn't included
UPDATE t
SET ordered_by_supervisor = u.supervisor_user_id
FROM p_Treatment_Item t
	INNER JOIN inserted i
	ON t.cpr_id = i.cpr_id
	AND t.treatment_id = i.treatment_id
	INNER JOIN c_User u
	ON t.ordered_by = u.user_id
WHERE u.supervisor_user_id IS NOT NULL
AND t.ordered_by_supervisor IS NULL

UPDATE t
SET key_field = CASE tt.component_id WHEN 'TREAT_IMMUNIZATION' THEN 'D'
									WHEN 'TREAT_MATERIAL' THEN 'M'
									WHEN 'TREAT_MEDICATION' THEN 'D'
									WHEN 'TREAT_OFFICEMED' THEN 'D'
									WHEN 'TREAT_PROCEDURE' THEN 'P'
									WHEN 'TREAT_TEST' THEN 'O'
									ELSE 'A' END
FROM p_Treatment_Item t
	INNER JOIN inserted i
	ON t.cpr_id = i.cpr_id
	AND t.treatment_id = i.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
WHERE t.key_field IS NULL

UPDATE t
SET treatment_key = CASE t.key_field WHEN 'P' THEN t.procedure_id
											WHEN 'M' THEN CAST(t.material_id AS varchar(40))
											WHEN 'D' THEN t.drug_id
											WHEN 'O' THEN t.observation_id
											ELSE CAST(t.treatment_description AS varchar(40)) END
FROM p_Treatment_Item t
	INNER JOIN inserted i
	ON t.cpr_id = i.cpr_id
	AND t.treatment_id = i.treatment_id
WHERE t.treatment_key IS NULL
GO

