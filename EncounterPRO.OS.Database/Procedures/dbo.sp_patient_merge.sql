
-- Drop Procedure [dbo].[sp_patient_merge]
Print 'Drop Procedure [dbo].[sp_patient_merge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_patient_merge]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[sp_patient_merge]
GO

-- Create Procedure [dbo].[sp_patient_merge]
Print 'Create Procedure [dbo].[sp_patient_merge]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sp_patient_merge]
	 @cpr_id_keep VARCHAR (12)
	,@cpr_id_merge VARCHAR (12)
AS

DECLARE
	 @problem_id_max INT
	,@merge_notice VARCHAR(24)
	,@x INT
	,@ll_count int
	,@ll_error int
	,@ls_tries varchar(12)
	,@ls_new_billing_id_base varchar(24)

SET LOCK_TIMEOUT 2000
SET DEADLOCK_PRIORITY LOW 


DECLARE @ll_sts int,
	@ll_tries int,
	@ll_dummy int

SET @ll_sts = 1
SET @ll_tries = 0

WHILE @ll_sts <> 0 AND @ll_tries < 100
	BEGIN
	SET @ll_tries = @ll_tries + 1

	-- Get an exclusive table lock on every p table
	begin transaction

	select @ll_dummy = 1 from p_Patient_WP_Item WITH (TABLOCKX) where 1 = 2
	SET @ll_sts = @@ERROR

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_WP WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_WP_Item_Attribute WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_WP_Item_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Treatment_Item WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Encounter_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Chart_Alert WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Chart_Alert_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Object_Security WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Relation WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Authority WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Encounter_Assessment WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Encounter_Assessment_Charge WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Encounter_Charge WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Family_History WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Family_Illness WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Lastkey WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Letter WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Material_Used WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Attachment WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Attachment_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Guarantor WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Treatment_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Patient_Encounter WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Observation_Result_Qualifier WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_assessment_Progress WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Observation_Location WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Observation WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Encounter_Charge_Modifier WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Observation_Comment WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Assessment WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Assessment_Treatment WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	IF @ll_sts = 0
		BEGIN
		select @ll_dummy = 1 from p_Observation_Result WITH (TABLOCKX) where 1 = 2
		SET @ll_sts = @@ERROR
		END

	-- If we had an error, release all the locks and try again
	IF @ll_sts <> 0
		ROLLBACK TRANSACTION

	END

IF @@TRANCOUNT < 1
	BEGIN
	RAISERROR ('Unable to get necessary locks', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @@TRANCOUNT > 1
	BEGIN
	RAISERROR ('Unable to get necessary locks', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ls_new_billing_id_base = '(Merged: ' + @cpr_id_keep + ')'
SET @merge_notice = @ls_new_billing_id_base
SET @ll_tries = 1
WHILE 1=1
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient
	WHERE billing_id = @merge_notice

	SET @ll_sts = @@ERROR

	-- If we had an error then rollback and return
	IF @ll_sts <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN
		END

	IF @ll_count = 0
		BREAK

	SET @ll_tries = @ll_tries + 1
	IF @ll_sts > 999999
		BEGIN
		RAISERROR ('Cannot generate unique billing_id for merged patient', 16, -1)
		ROLLBACK TRANSACTION
		RETURN
		END

	SET @ls_tries = CAST(@ll_tries AS varchar(6))
	SET @merge_notice = LEFT(@ls_new_billing_id_base, 24 - LEN(@ls_tries) - 2) + '(' + @ls_tries + ')'

	END

IF @cpr_id_keep = @cpr_id_merge
BEGIN
	RAISERROR ('Keep and Merge Patients are the same', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
END

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @x = 0
SELECT
	@x = 1
FROM
	p_patient WITH (xlock)
WHERE
	cpr_id = @cpr_id_keep
AND 	patient_status <> 'MERGED'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @x = 0
BEGIN
	RAISERROR ('Keep Patient does not exist', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
END
	
-- msc - Allow merged patient to have status of 'MERGED' so that a merge can be re-tried
-- Add update of modified_by when merging (#68)
UPDATE p_patient
SET
	 patient_status = 'MERGED'
	,billing_id = @merge_notice
	,last_name = LEFT(last_name, 40 - LEN(@merge_notice) - 1) + ' ' + @merge_notice
	,modified_by = ORIGINAL_LOGIN()
WHERE cpr_id = @cpr_id_merge

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_count <> 1
BEGIN
	RAISERROR ('Merge Patient does not exist', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
END

-- Add update of modified_by when merging (#68)
UPDATE p_patient
SET		modified_by = ORIGINAL_LOGIN()
WHERE cpr_id = @cpr_id_keep

SET @x = 0
SELECT DISTINCT
	 @x = 1
FROM
	o_user_service_lock o WITH (xlock)
INNER JOIN p_patient_WP_item i WITH (xlock)
ON
	o.patient_workplan_item_id = i.patient_workplan_item_id
WHERE
	i.cpr_id = @cpr_id_merge
AND i.ordered_service <> 'Merge Patients'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @x = 1
BEGIN
	RAISERROR ('Merge Patient is active', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
END

SET @x = 0
SELECT DISTINCT
	 @x = 1
FROM
	o_user_service_lock o WITH (xlock)
INNER JOIN p_patient_WP_item i WITH (xlock)
ON
	o.patient_workplan_item_id = i.patient_workplan_item_id
WHERE
	i.cpr_id = @cpr_id_keep
AND i.ordered_service <> 'Merge Patients'

IF @x = 1
BEGIN
	RAISERROR ('Keep Patient is active', 16, -1)
	ROLLBACK TRANSACTION
	RETURN -1
END

-----------------------------------------------------------------------
-- Renumber the encounters and update all the references
-----------------------------------------------------------------------

-- Make a list of the duplicate encounter ids
DECLARE @x_encounter_ids TABLE (
	old_encounter_id int NOT NULL,
	new_encounter_id int NULL)

INSERT INTO @x_encounter_ids (
	old_encounter_id )
SELECT em.encounter_id
FROM p_Patient_Encounter em
	INNER JOIN p_Patient_Encounter ek
	ON em.encounter_id = ek.encounter_id
WHERE em.cpr_id = @cpr_id_merge
AND ek.cpr_id = @cpr_id_keep

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Copy the encounters into the "keep" patient so that new encounter_id values are generated
-- keep track of the new encounter_ids so we can update the references
DECLARE @ll_old_encounter_id int,
		@ll_new_encounter_id int

DECLARE lc_move_encounters CURSOR LOCAL FAST_FORWARD FOR
	SELECT old_encounter_id
	FROM @x_encounter_ids

OPEN lc_move_encounters
IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

FETCH lc_move_encounters INTO @ll_old_encounter_id
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE @ll_new_encounter_id = jmj_copy_encounter @ps_from_cpr_id = @cpr_id_merge,
														@pl_from_encounter_id = @ll_old_encounter_id,
														@ps_to_cpr_id = @cpr_id_keep
	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	UPDATE @x_encounter_ids
	SET new_encounter_id = @ll_new_encounter_id
	WHERE old_encounter_id = @ll_old_encounter_id
	
	FETCH lc_move_encounters INTO @ll_old_encounter_id
	END

CLOSE lc_move_encounters
DEALLOCATE lc_move_encounters

-- Now update all the references to the encounter_id
UPDATE p
SET encounter_id = x.new_encounter_id
FROM o_Log p
INNER JOIN @x_encounter_ids x
    ON p.encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM o_Message_Log p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET close_encounter_id = x.new_encounter_id
FROM p_Assessment p
INNER JOIN @x_encounter_ids x
    ON close_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET open_encounter_id = x.new_encounter_id
FROM p_Assessment p
INNER JOIN @x_encounter_ids x
    ON open_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_assessment_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Assessment_Treatment p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Attachment p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET close_encounter_id = x.new_encounter_id
FROM p_Chart_Alert p
INNER JOIN @x_encounter_ids x
    ON close_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET open_encounter_id = x.new_encounter_id
FROM p_Chart_Alert p
INNER JOIN @x_encounter_ids x
    ON open_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Chart_Alert_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Encounter_Assessment p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Encounter_Assessment_Charge p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Encounter_Charge p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Encounter_Charge_Modifier p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Family_History p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Family_Illness p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Letter p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Material_Used p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation_Comment p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation_Location p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation_Result p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END

UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation_Result_Progress p
INNER JOIN @x_encounter_ids x
	ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Observation_Result_Qualifier p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Patient_Encounter_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Patient_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Patient_WP p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Patient_WP_Item p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Patient_WP_Item_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET close_encounter_id = x.new_encounter_id
FROM p_Treatment_Item p
INNER JOIN @x_encounter_ids x
    ON close_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET open_encounter_id = x.new_encounter_id
FROM p_Treatment_Item p
INNER JOIN @x_encounter_ids x
    ON open_encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM p_Treatment_Progress p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM x_encounterpro_Arrived p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END


UPDATE p
SET encounter_id = x.new_encounter_id
FROM x_MedMan_Arrived p
INNER JOIN @x_encounter_ids x
    ON encounter_id = x.old_encounter_id
WHERE p.cpr_id = @cpr_id_merge

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END

UPDATE p
SET value_short = CAST(x.new_encounter_id AS varchar(12))
FROM p_Patient_WP_Item_Attribute p
INNER JOIN @x_encounter_ids x
    ON value_short = CAST(x.old_encounter_id AS varchar(12))
WHERE p.cpr_id = @cpr_id_merge
AND p.attribute LIKE '%encounter_id'

IF @@ERROR <> 0
 BEGIN
 ROLLBACK TRANSACTION
 RETURN -1
 END








SET @x = 0
SELECT DISTINCT
	@x = 1
FROM
	p_assessment WITH (XLOCK)
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SELECT
	@problem_id_max = ISNULL( MAX(problem_id), 0 )
FROM
	p_assessment WITH (XLOCK)
WHERE
	cpr_id = @cpr_id_keep


IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Assessment
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_assessment_Progress
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Assessment_Treatment
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Attachment
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Encounter_Assessment
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Encounter_Assessment_Charge
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Observation
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE  p_Patient_WP
SET
	problem_id = problem_id + @problem_id_max
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_patient_WP_item_attribute
SET
	value_short = CAST(
		( CAST( value_short AS INTEGER )+ @problem_id_max ) AS VARCHAR(255) 
			     )
WHERE
	cpr_id = @cpr_id_merge
AND	attribute = 'problem_id'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_treatment_progress
SET
	progress_key = CAST(
		( CAST( progress_value AS INTEGER )+ @problem_id_max ) AS VARCHAR(40) 
			     )
WHERE
	cpr_id = @cpr_id_merge
AND	progress_type = 'ADD_ASSESSMENT'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE o_log
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE o_Message_Log
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Assessment
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_assessment_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Assessment_Treatment
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Attachment
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Attachment_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END


UPDATE p_Chart_Alert
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Chart_Alert_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Encounter_Assessment
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Encounter_Assessment_Charge
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Encounter_Charge
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Encounter_Charge_Modifier
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge


IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Observation
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Observation_Comment
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Observation_Location
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Observation_Result
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge


IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE e
SET cpr_id = @cpr_id_keep
FROM p_Patient_Encounter e
WHERE cpr_id = @cpr_id_merge
AND encounter_id NOT IN (
	SELECT old_encounter_id
	FROM @x_encounter_ids)

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_Encounter_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_WP
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_WP_Item
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_WP_Item_Attribute
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Patient_WP_Item_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Treatment_Item
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_Treatment_Progress
SET
	cpr_id = @cpr_id_keep
WHERE
	cpr_id = @cpr_id_merge

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_patient_authority
SET
	cpr_id = @cpr_id_keep
FROM	p_patient_authority a1
WHERE
	cpr_id = @cpr_id_merge
AND	NOT EXISTS
	( 	select 1 FROM p_patient_authority a2
		WHERE
			a2.cpr_id = @cpr_id_keep
		AND 	a1.authority_type = a2.authority_type
		AND	a1.authority_sequence = a2.authority_sequence
	)


IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_patient_guarantor
SET
	cpr_id = @cpr_id_keep
FROM p_patient_guarantor a1
WHERE
	cpr_id = @cpr_id_merge
AND	NOT EXISTS
	( 	select 1 FROM p_patient_guarantor a2
		WHERE
			a2.cpr_id = @cpr_id_keep
		AND	a1.guarantor_sequence = a2.guarantor_sequence
	)

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_patient_relation
SET
	relation_cpr_id = @cpr_id_keep
FROM p_patient_relation p1
WHERE
	p1.relation_cpr_id = @cpr_id_merge
AND	NOT EXISTS
	( 	select 1 FROM p_patient_relation p2
		WHERE
			p2.cpr_id = p1.cpr_id
		AND	p1.relation_cpr_id = @cpr_id_keep
	)

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_patient_relation
SET
	cpr_id = @cpr_id_keep
FROM p_patient_relation p1
WHERE
	p1.cpr_id = @cpr_id_merge
AND	NOT EXISTS
	( 	select 1 FROM p_patient_relation p2
		WHERE
			p2.cpr_id = @cpr_id_keep
		AND	p2.relation_cpr_id = p1.relation_cpr_id
	)

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SELECT
	@problem_id_max = MAX(problem_id)
FROM
	p_assessment WITH (XLOCK)
WHERE
	cpr_id = @cpr_id_keep

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE p_lastkey
SET
	last_key = @problem_id_max
WHERE
	cpr_id = @cpr_id_keep
AND	key_id = 'PROBLEM_ID'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

EXECUTE jmj_reset_active_services

RETURN 1

GO
GRANT EXECUTE ON [sp_patient_merge] TO [cprsystem] AS [dbo]
GO
