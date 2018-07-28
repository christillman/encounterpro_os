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

-- Drop Trigger [dbo].[tr_p_assessment_treatment_insert]
Print 'Drop Trigger [dbo].[tr_p_assessment_treatment_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_assessment_treatment_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_assessment_treatment_insert]
GO

-- Create Trigger [dbo].[tr_p_assessment_treatment_insert]
Print 'Create Trigger [dbo].[tr_p_assessment_treatment_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_assessment_treatment_insert ON dbo.p_assessment_treatment
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN





DECLARE @ls_cpr_id varchar(12) ,
		@ll_problem_id int ,
		@ll_treatment_id int ,
		@ll_encounter_id int,
		@ls_created_by varchar(24),
		@ls_bill_flag char(1)

SET @ls_bill_flag = NULL

-- Add a billing record if one doesn't already exist
DECLARE lc_assessments CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
	SELECT DISTINCT cpr_id ,
			encounter_id,
			problem_id,
			treatment_id,
			created_by
	FROM inserted

OPEN lc_assessments

FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ll_treatment_id, @ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Remove the existing billing associations that are for this treatment and this encounter,
	-- but do not have the assessment clinically associated
	DELETE a
	FROM p_Encounter_Assessment_Charge a
		INNER JOIN p_Encounter_Charge c
		ON a.cpr_id = c.cpr_id
		AND a.encounter_id = c.encounter_id
		AND a.encounter_charge_id = c.encounter_charge_id
	WHERE c.cpr_id = @ls_cpr_id
	AND c.encounter_id = @ll_encounter_id
	AND c.treatment_id = @ll_treatment_id
	AND a.problem_id NOT IN (
		SELECT problem_id
		FROM p_assessment_treatment
		WHERE cpr_id = @ls_cpr_id
		AND treatment_id = @ll_treatment_id)

	EXECUTE sp_set_assessment_billing
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@pl_problem_id = @ll_problem_id,
				@ps_bill_flag  = @ls_bill_flag,
				@ps_created_by = @ls_created_by
	
	FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ll_treatment_id, @ls_created_by
	END

CLOSE lc_assessments
DEALLOCATE lc_assessments


-- Create the billing association if it doesn't already exist
INSERT INTO p_Encounter_Assessment_Charge (
	cpr_id,
	encounter_id,
	problem_id,
	encounter_charge_id,
	bill_flag,
	created,
	created_by)
SELECT c.cpr_id,
	c.encounter_id,
	i.problem_id,
	c.encounter_charge_id,
	c.bill_flag,
	i.created,
	i.created_by
FROM inserted i
	INNER JOIN p_Encounter_Charge c
	ON i.cpr_id = c.cpr_id
	AND i.encounter_id = c.encounter_id
	AND i.treatment_id = c.treatment_id
WHERE NOT EXISTS (
	SELECT 1
	FROM p_Encounter_Assessment_Charge c2
	WHERE c2.cpr_id = c.cpr_id
	AND c2.encounter_id = c.encounter_id
	AND c2.problem_id = i.problem_id
	AND c2.encounter_charge_id = c.encounter_charge_id )
	

GO

