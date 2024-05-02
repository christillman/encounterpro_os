
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_patient_encounter_merge]
Print 'Drop Procedure [dbo].[sp_patient_encounter_merge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_patient_encounter_merge]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_patient_encounter_merge]
GO

-- Create Procedure [dbo].[sp_patient_encounter_merge]
Print 'Create Procedure [dbo].[sp_patient_encounter_merge]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_patient_encounter_merge
	 @cpr_id VARCHAR (12)
	,@encounter_id_keep int
	,@encounter_id_merge int
AS

DECLARE
	 @merge_notice VARCHAR(24)
	,@x INT

SET @merge_notice = '(Merged Encounter: ' + CAST( @encounter_id_keep AS VARCHAR) + ')'


IF @encounter_id_keep = @encounter_id_merge
BEGIN
	RAISERROR ('Keep and Merge Patients Encounters are the same', 16, 1)
	RETURN(-1)
END

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRANSACTION

PRINT 'Check for valid Patient'

SELECT
	@x = 1
FROM
	p_patient WITH (xlock)
WHERE
	cpr_id = @cpr_id
AND 	patient_status <> 'MERGED'

IF @@rowcount <> 1
BEGIN
	RAISERROR ('Patient does not exist', 16, 1)
	ROLLBACK TRANSACTION
	RETURN(-1)
END

PRINT 'Check for valid KEEP Patient Encounter'

SELECT
	@x = 1
FROM
	p_patient_encounter WITH (xlock)
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_keep
AND 	encounter_status NOT IN ('CANCELLED', 'MERGED')

IF @@rowcount <> 1
BEGIN
	RAISERROR ('Keep Patient Encounter does not exist', 16, 1)
	ROLLBACK TRANSACTION
	RETURN(-1)
END	

PRINT 'Check for valid Merge patient Encounter and Update status to Merged'

UPDATE p_patient_encounter
SET
	 encounter_status = 'MERGED'
	,encounter_description = @merge_notice + encounter_description
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge
AND 	encounter_status NOT IN ('CANCELLED', 'MERGED')


IF @@rowcount <> 1
BEGIN
	RAISERROR ('Merge Patient Encounter does not exist', 16, 1)
	ROLLBACK TRANSACTION
	RETURN(-1)
END
	
PRINT 'Check for Locked patient items'

SELECT DISTINCT
	 @x = 1
FROM
	o_user_service_lock o WITH (xlock)
INNER JOIN p_patient_WP_item i WITH (xlock)
ON
	o.patient_workplan_item_id = i.patient_workplan_item_id
WHERE
	i.cpr_id = @cpr_id

IF @@rowcount > 0
BEGIN
	RAISERROR ('Patient has locked services', 16, 1)
	ROLLBACK TRANSACTION
	RETURN(-1)
END
	


PRINT  'CHANGE encounter_IDs'

PRINT 'Change o_log.encounter_id'

UPDATE o_log
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge

PRINT 'Change o_message_log.encounter_id'

UPDATE o_message_log
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_assessment.close_encounter_id'

UPDATE p_Assessment
SET
	close_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	close_encounter_id = @encounter_id_merge

PRINT 'Change p_assessment.open_encounter_id'

UPDATE p_Assessment
SET
	open_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	open_encounter_id = @encounter_id_merge


PRINT 'Change p_assessment_progress.encounter_id'

UPDATE p_assessment_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_assessment_treatment.encounter_id'

UPDATE p_Assessment_Treatment
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_attachment.encounter_id'

UPDATE p_Attachment
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge



PRINT 'Change p_chart_alert.close_encounter_id'


UPDATE p_Chart_Alert
SET
	close_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	close_encounter_id = @encounter_id_merge

PRINT 'Change p_chart_alert.open_encounter_id'


UPDATE p_Chart_Alert
SET
	open_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	open_encounter_id = @encounter_id_merge


PRINT 'Change p_chart_alert_progress.encounter_id'

UPDATE p_Chart_Alert_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge

PRINT 'Change p_encounter_assessment.encounter_id'

UPDATE p_Encounter_Assessment
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_encounter_assessment_charge.encounter_id'

UPDATE p_Encounter_Assessment_Charge
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_encounter_charge.encounter_id'

UPDATE p_Encounter_Charge
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_encounter_charge_modifier.encounter_id'

UPDATE p_Encounter_Charge_Modifier
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_observation.encounter_id'

UPDATE p_Observation
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_observation_comment.encounter_id'


UPDATE p_Observation_Comment
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_observation_location.encounter_id'

UPDATE p_Observation_Location
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_observation_result.encounter_id'

UPDATE p_Observation_Result
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_patient_enocunter_progress.encounter_id'

UPDATE p_Patient_Encounter_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id

PRINT 'Change p_patient_progress.encounter_id'

UPDATE p_Patient_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_patient_wp.encounter_id'


UPDATE p_Patient_WP
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge

PRINT 'Change p_patient_wp_item.encounter_id'

UPDATE p_Patient_WP_Item
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge

PRINT 'Change p_patient_wp_item_attribute.encounter_id'

UPDATE p_Patient_WP_Item_Attribute
SET
	value_short = CAST( @encounter_id_keep AS VARCHAR(255))
WHERE
	cpr_id = @cpr_id
AND	attribute = 'encounter_id'
AND	CAST( @encounter_id_merge AS VARCHAR(255)) = value_short


PRINT 'Change p_patient_wp_item_progress.encounter_id'

UPDATE p_Patient_WP_Item_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


PRINT 'Change p_treatment_item.close_encounter_id'

UPDATE p_Treatment_Item
SET
	close_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	close_encounter_id = @encounter_id_merge


PRINT 'Change p_treatment_item.open_encounter_id'

UPDATE p_Treatment_Item
SET
	open_encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	open_encounter_id = @encounter_id_merge

PRINT 'Change p_treatment_progress.encounter_id'

UPDATE p_Treatment_Progress
SET
	encounter_id = @encounter_id_keep
WHERE
	cpr_id = @cpr_id
AND	encounter_id = @encounter_id_merge


COMMIT


GO

GRANT EXECUTE
	ON [dbo].[sp_patient_encounter_merge]
	TO [cprsystem]
GO
