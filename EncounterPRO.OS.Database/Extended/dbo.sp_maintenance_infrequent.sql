DROP PROCEDURE IF EXISTS [sp_maintenance_infrequent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sp_maintenance_infrequent]
AS

DECLARE @ll_error int,
		@ll_rowcount int

DELETE FROM o_event_queue
WHERE event_date_time < dateadd(day, -14, dbo.get_client_datetime())
AND event_status = 'COMPLETE'

-- Integration Tables (Keep only last two days arrivals)
DELETE FROM x_MedMan_Arrived
WHERE encounter_date_time < dateadd(day, -14, dbo.get_client_datetime())

DELETE FROM x_EncounterPro_Arrived
WHERE encounter_date_time < dateadd(day, -14, dbo.get_client_datetime())

DELETE FROM o_Message_Log
WHERE message_date_time < dateadd(day, -14, dbo.get_client_datetime())
AND status IN ('SENT', 'RECEIVED')

-- End Of Integration Tables
-- Clear out o_Log
DELETE FROM o_Log
WHERE log_date_time < dateadd(day, -365, dbo.get_client_datetime())

-- Close open treatments if the parent assessment is closed
INSERT INTO p_Treatment_Progress (
	cpr_id,
	treatment_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created,
	created_by)
SELECT t.cpr_id,
	t.treatment_id,
	a.close_encounter_id,
	'!SYSTEM',
	a.end_date,
	'CLOSED',
	dbo.get_client_datetime(),
	'!SYSTEM'
FROM p_Assessment a
JOIN p_Treatment_Item t ON a.cpr_id = t.cpr_id
JOIN p_Assessment_Treatment atr ON a.problem_id = atr.problem_id
AND t.treatment_id = atr.treatment_id
WHERE a.end_date IS NOT NULL
AND t.end_date IS NULL

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Nullify the admin number from the u_assessment treatment list when admin rule no longer associated with drug
--UPDATE  u_assessment_treatment
--SET administration_sequence = NULL
--WHERE drug_id IS NOT NULL
--AND administration_sequence IS NOT NULL
--AND NOT EXISTS (
--	SELECT drug_id
--	FROM c_Drug_Administration
--	WHERE c_Drug_Administration.drug_id = u_Assessment_Treatment.drug_id
--	AND c_Drug_Administration.administration_sequence = u_Assessment_Treatment.administration_sequence
--		)

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'sp_maintenance_infrequent',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END

---- Delete all the treatment  list records if dosage form is no longer associated with drug
--DELETE FROM u_Assessment_Treatment
--WHERE drug_id is not Null
--AND dosage_form is not Null
--AND Not Exists (
--	SELECT dosage_form
--	FROM c_Package,c_Drug_Package
--	WHERE c_Package.dosage_form = u_Assessment_Treatment.dosage_form
--	AND c_Drug_Package.package_id = c_Package.package_id
--	AND c_Drug_Package.drug_id = u_Assessment_Treatment.drug_id)

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'sp_maintenance_infrequent',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END

-- if the shortlist & treatment list are no longer matching with
-- active records[Observations,Assessments,Procedures,Drugs] then delete them.
-- OBSERVATION
--DELETE FROM u_Assessment_Treatment
--WHERE treatment_type = 'TEST'
--AND NOT EXISTS (
--	SELECT observation_id
--	FROM c_Observation
--	WHERE c_Observation.observation_id = u_Assessment_Treatment.observation_id
--	AND c_Observation.status = 'OK'
--	)

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'sp_maintenance_infrequent',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END

DELETE FROM u_Top_20
WHERE top_20_code like 'TEST%'
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation
	WHERE c_Observation.observation_id = u_Top_20.item_id
	AND c_Observation.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DELETE FROM u_Top_20
WHERE top_20_code like 'REFERRALTEST%'
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation
	WHERE c_Observation.observation_id = u_Top_20.item_id
	AND c_Observation.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DELETE FROM u_Top_20
WHERE top_20_code like 'FOLLOWUPTEST%'
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation
	WHERE c_Observation.observation_id = u_Top_20.item_id
	AND c_Observation.status = 'OK'
	)
-- PROCEDURE
--DELETE FROM u_Assessment_Treatment
--WHERE procedure_id IS NOT NULL
--AND NOT EXISTS (
--	SELECT procedure_id
--	FROM c_Procedure
--	WHERE c_Procedure.procedure_id = u_Assessment_Treatment.procedure_id
--	AND c_Procedure.status = 'OK'
--	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DELETE FROM u_Top_20
WHERE top_20_code like 'PROCEDURE%'
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation
	WHERE c_Observation.observation_id = u_Top_20.item_id
	AND c_Observation.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- ASSESSMENTS
--DELETE FROM u_Assessment_Treatment
--WHERE assessment_id IS NOT NULL
--AND NOT EXISTS (
--	SELECT assessment_id
--	FROM c_Assessment_Definition
--	WHERE c_Assessment_Definition.assessment_id = u_Assessment_Treatment.assessment_id
--	AND c_Assessment_Definition.status = 'OK'
--	)

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'sp_maintenance_infrequent',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END

DELETE FROM u_Top_20
WHERE top_20_code like 'ASS%'
AND NOT EXISTS (
	SELECT assessment_id
	FROM c_Assessment_Definition
	WHERE c_Assessment_Definition.assessment_id = u_Top_20.item_id
	AND c_Assessment_Definition.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- DRUGS
DELETE FROM u_Top_20
WHERE top_20_code like 'MEDICATION%'
AND NOT EXISTS (
	SELECT drug_id
	FROM c_Drug_Definition
	WHERE c_Drug_Definition.drug_id = u_Top_20.item_id
	AND c_Drug_Definition.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DELETE FROM u_Top_20
WHERE top_20_code like 'OFFICEMED%'
AND NOT EXISTS (
	SELECT drug_id
	FROM c_Drug_Definition
	WHERE c_Drug_Definition.drug_id = u_Top_20.item_id
	AND c_Drug_Definition.status = 'OK'
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'sp_maintenance_infrequent',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

--DELETE FROM u_Assessment_Treatment
--WHERE drug_id IS NOT NULL
--AND NOT EXISTS (
--	SELECT drug_id
--	FROM c_Drug_Definition
--	WHERE c_Drug_Definition.drug_id = u_Assessment_Treatment.drug_id
--	AND c_Drug_Definition.status = 'OK'
--	)

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'sp_maintenance_infrequent',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END

EXECUTE jmj_log_database_maintenance
		@ps_action = 'sp_maintenance_infrequent',
		@ps_completion_status = 'OK'

GO
GRANT EXECUTE ON [sp_maintenance_infrequent] TO [cprsystem] AS [dbo]
GO
