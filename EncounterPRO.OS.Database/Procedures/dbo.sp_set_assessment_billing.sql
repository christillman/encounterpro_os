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

-- Drop Procedure [dbo].[sp_set_assessment_billing]
Print 'Drop Procedure [dbo].[sp_set_assessment_billing]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_assessment_billing]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_assessment_billing]
GO

-- Create Procedure [dbo].[sp_set_assessment_billing]
Print 'Create Procedure [dbo].[sp_set_assessment_billing]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_assessment_billing (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_problem_id integer,
	@ps_assessment_id varchar(24) = NULL,
	@ps_bill_flag char(1) = NULL,
	@ps_created_by varchar(24),
	@ps_exclusive_link char(1) = 'N' )
AS

-- @ps_bill_flag = 'Y' = Bill the assessment in this encounter
--                 'N' = Don't bill the assessment in this encounter
--                 'X' = Don't change the billing if p_Encounter_Assessment record
--                       already exists.  Don't bill the assessment if
--                       p_Encounter_Assessment record doesn't already exist.
--                Null = Don't change the billing if p_Encounter_Assessment record
--                       already exists.  Use c_Assessment_Type.default_bill_flag if
--                       p_Encounter_Assessment record doesn't already exist.


DECLARE @ls_bill_flag char(1),
	@ls_default_bill_flag char(1),
	@ls_assessment_id varchar(24),
	@li_diagnosis_sequence smallint,
	@ls_icd_9_code varchar(12),
	@ll_encounter_charge_id int,
	@ls_assessment_type varchar(24),
	@ll_record_added int

-- Initialize record added flag
SET @ll_record_added = 0

-- If there is no encounter_id, then we have nothing to do here
IF @pl_encounter_id IS NULL
	RETURN

IF @pl_problem_id IS NULL
	BEGIN
	-- If the problem_id isn't supplied then this assessment-billing record isn't
	-- associated with an actual assessment.  We will generate a negative problem_id so that
	-- the joins through p_Encounter_Assessment_Charge will work and to be backward compatible
	
	IF @ps_assessment_id IS NULL
		RETURN
	
	SET @ls_assessment_id = @ps_assessment_id
	SET @li_diagnosis_sequence = NULL
	
	SELECT @ls_icd_9_code = a.icd_9_code,
			@ls_default_bill_flag = t.default_bill_flag,
			@ls_assessment_type = a.assessment_type
	FROM c_Assessment_Definition a
		INNER JOIN c_Assessment_Type t
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_id = @ps_assessment_id
	
	IF @@ROWCOUNT = 0
		BEGIN
		RAISERROR ('Cannot find assessment_id (%s)',16,-1, @ps_assessment_id)
		RETURN
		END
	
	-- See if this assessment_id is already billed
	SELECT @pl_problem_id = problem_id
	FROM p_Encounter_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND assessment_id = @ps_assessment_id
	
	IF @@ROWCOUNT = 0
		BEGIN
		SELECT @pl_problem_id = min(problem_id) - 1
		FROM p_Encounter_Assessment
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND problem_id < 0
		
		IF @pl_problem_id IS NULL
			SET @pl_problem_id = -1
		END
	
	
	END
ELSE
	BEGIN
	-- If we were passed in a problem_id, then look it up and get some info about it
	SELECT @ls_icd_9_code = a.icd_9_code,
			@li_diagnosis_sequence = p.diagnosis_sequence,
			@ls_assessment_id = p.assessment_id,
			@ls_default_bill_flag = t.default_bill_flag,
			@ls_assessment_type = a.assessment_type
	FROM p_Assessment p
		INNER JOIN c_Assessment_Definition a
		ON p.assessment_id = a.assessment_id
		INNER JOIN c_Assessment_Type t
		ON p.assessment_type = t.assessment_type
	WHERE p.cpr_id = @ps_cpr_id
	AND p.problem_id = @pl_problem_id
	AND p.current_flag = 'Y'

	IF @@ROWCOUNT = 0
		RETURN
	END


-- If there is no icd_9_code, then don't bill the assessment
IF @ls_icd_9_code IS NULL
	SELECT @ps_bill_flag = 'N'

-- Find out if there's a record already, and if so, what is the current bill_flag
SELECT @ls_bill_flag = bill_flag
FROM p_Encounter_Assessment
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND problem_id = @pl_problem_id

IF @@ROWCOUNT = 0
	BEGIN
	-- If the billing record doesn't exist and the bill_flag was not provided
	-- then use the default
	if @ps_bill_flag IS NULL
		SET @ps_bill_flag = @ls_default_bill_flag

	if @ps_bill_flag = 'X'
		SET @ps_bill_flag = 'N'
		
	INSERT INTO p_Encounter_Assessment (
		cpr_id,
		encounter_id,
		problem_id,
		assessment_id,
		bill_flag,
		created_by,
		exclusive_link )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@pl_problem_id,
		@ls_assessment_id,
		@ps_bill_flag,
		@ps_created_by,
		@ps_exclusive_link )

	-- Indicate to later logic that this operation resulted in a new assessment billing record
	SET @ll_record_added = 0
	END
ELSE
	BEGIN
	-- If the billing record already exists then use the bill flag from it if none was provided
	IF @ps_bill_flag IS NULL OR @ps_bill_flag = 'X'
		SET @ps_bill_flag = @ls_bill_flag
	
	UPDATE p_Encounter_Assessment
	SET	bill_flag = @ps_bill_flag,
		assessment_id = @ls_assessment_id
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND problem_id = @pl_problem_id
	END

-- Billing Algorithm 13-b
-- If assessment is billed and the assessment_type is WELL and there are charges 
-- associated with other assessment-billing records where the well_encounter_flag = Y 
-- and not associated with any assessment-billing records where the assessment_type = WELL, 
-- then associate such charges with this new assessment-billing record.
IF @ps_bill_flag = 'Y' AND @pl_problem_id > 0 AND @ls_assessment_type = 'WELL'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by )
	SELECT DISTINCT c.cpr_id,
		c.encounter_id,
		@pl_problem_id,
		c.encounter_charge_id,
		c.bill_flag,
		@ps_created_by
	FROM p_Encounter_Charge c
		INNER JOIN p_Encounter_Assessment_Charge ac1
		ON c.cpr_id = ac1.cpr_id
		AND c.encounter_id = ac1.encounter_id
		AND c.encounter_charge_id = ac1.encounter_charge_id
		INNER JOIN p_Encounter_Assessment pa
		ON pa.cpr_id = ac1.cpr_id
		AND pa.encounter_id = ac1.encounter_id
		AND pa.problem_id = ac1.problem_id
		INNER JOIN c_Assessment_Definition ad
		ON pa.assessment_id = ad.assessment_id
		INNER JOIN c_Assessment_Type at
		ON ad.assessment_type = at.assessment_type
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.bill_flag = 'Y'
	AND at.well_encounter_flag = 'Y'
	AND at.assessment_type <> 'WELL'
	AND pa.problem_id <> @pl_problem_id
	AND pa.bill_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac2
			INNER JOIN p_Encounter_Assessment pa2
			ON pa2.cpr_id = ac2.cpr_id
			AND pa2.encounter_id = ac2.encounter_id
			AND pa2.problem_id = ac2.problem_id
			INNER JOIN c_Assessment_Definition ad2
			ON pa2.assessment_id = ad2.assessment_id
		WHERE c.cpr_id = ac2.cpr_id
		AND c.encounter_id = ac2.encounter_id
		AND c.encounter_charge_id = ac2.encounter_charge_id
		AND ad2.assessment_type = 'WELL'
		AND pa2.bill_flag = 'Y'
		)
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac
		WHERE ac.cpr_id = c.cpr_id
		AND ac.encounter_id = c.encounter_id
		AND ac.problem_id = @pl_problem_id
		AND ac.encounter_charge_id = c.encounter_charge_id)

-- Billing Algorithm 13-c
-- If assessment is billed and there are billed charges not associated with 
-- an assessment-billing record, then associate them with this assessment-billing record.
IF @ps_bill_flag = 'Y' AND @pl_problem_id > 0
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by )
	SELECT DISTINCT @ps_cpr_id,
		@pl_encounter_id,
		@pl_problem_id,
		c.encounter_charge_id,
		c.bill_flag,
		@ps_created_by
	FROM p_Encounter_Charge c
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.bill_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac
		WHERE ac.cpr_id = @ps_cpr_id
		AND ac.encounter_id = @pl_encounter_id
		AND ac.encounter_charge_id = c.encounter_charge_id)

IF @ll_record_added = 1
	BEGIN
	-- Billing Algorithm 13-d
	-- If there are any non-treatment charges where the procedure_type is Primary or Secondary, 
	-- then disassociate each such charge from all assessment-billing records and apply the logic
	-- in Rule 12 to re-associate each such charge
	DECLARE lc_non_treatment_charges CURSOR LOCAL FAST_FORWARD FOR
		SELECT encounter_charge_id
		FROM p_Encounter_Charge
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND treatment_id IS NULL
		AND bill_flag = 'Y'

	OPEN lc_non_treatment_charges

	FETCH lc_non_treatment_charges INTO @ll_encounter_charge_id

	WHILE @@FETCH_STATUS = 0
		BEGIN
		EXECUTE jmj_link_non_treatment_charge
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_encounter_charge_id = @ll_encounter_charge_id,
			@ps_created_by = @ps_created_by
		
		FETCH lc_non_treatment_charges INTO @ll_encounter_charge_id
		END

	CLOSE lc_non_treatment_charges
	DEALLOCATE lc_non_treatment_charges

	END
	

GO
GRANT EXECUTE
	ON [dbo].[sp_set_assessment_billing]
	TO [cprsystem]
GO

