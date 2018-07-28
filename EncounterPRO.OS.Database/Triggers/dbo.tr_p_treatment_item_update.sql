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

-- Drop Trigger [dbo].[tr_p_treatment_item_update]
Print 'Drop Trigger [dbo].[tr_p_treatment_item_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_treatment_item_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_treatment_item_update]
GO

-- Create Trigger [dbo].[tr_p_treatment_item_update]
Print 'Create Trigger [dbo].[tr_p_treatment_item_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_treatment_item_update ON dbo.p_Treatment_Item
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(treatment_description)
BEGIN
	UPDATE p_Patient_WP
	SET description = inserted.treatment_description
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_WP.cpr_id
	AND inserted.open_encounter_id = p_Patient_WP.encounter_id
	AND inserted.treatment_id = p_Patient_WP.treatment_id
END

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

IF UPDATE(procedure_id) OR UPDATE(material_id) OR UPDATE(drug_id) OR UPDATE(observation_id) OR UPDATE(treatment_description)
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
	OR t.treatment_key <> CASE t.key_field WHEN 'P' THEN t.procedure_id
												WHEN 'M' THEN CAST(t.material_id AS varchar(40))
												WHEN 'D' THEN t.drug_id
												WHEN 'O' THEN t.observation_id
												ELSE CAST(t.treatment_description AS varchar(40)) END
GO

