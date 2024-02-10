
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_maintenance_frequent]
Print 'Drop Procedure [dbo].[sp_maintenance_frequent]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_maintenance_frequent]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_maintenance_frequent]
GO

-- Create Procedure [dbo].[sp_maintenance_frequent]
Print 'Create Procedure [dbo].[sp_maintenance_frequent]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_maintenance_frequent (
	@pi_encounter_started_days smallint = 0,
	@pi_encounter_not_started_days smallint = 1,
	@ps_user_id varchar(24) = '#SYSTEM',
	@ps_created_by varchar(24) = '#SYSTEM' )
AS

SET NOCOUNT ON

DECLARE @ll_error int,
		@ll_rowcount int


-- Integration Tables (Keep only last 14 days arrivals)
if exists (select * from sysobjects where id = object_id('dbo.x_MedMan_Arrived') )
	DELETE FROM x_MedMan_Arrived
	WHERE encounter_date_time < dateadd(day, -14, getdate())

if exists (select * from sysobjects where id = object_id('dbo.x_EncounterPro_Arrived') )
	DELETE FROM x_EncounterPro_Arrived
	WHERE encounter_date_time < dateadd(day, -14, getdate())

DELETE FROM o_Message_Log
WHERE message_date_time < dateadd(day, -14, getdate())
AND status IN ('SENT', 'RECEIVED')
-- End Of Integration Tables

DELETE FROM o_event_queue
WHERE event_date_time < dateadd(day, -14, getdate())
AND event_status = 'COMPLETE'
-- Clear out o_Log
DELETE FROM o_Log
WHERE log_date_time < dateadd(day, -14, getdate())

-- Cancel All the Pending Billing Services Older than 7 days
INSERT INTO p_Patient_WP_Item_Progress (
            patient_workplan_id,
            patient_workplan_item_id,
            cpr_id,
            encounter_id,
            [user_id],
            progress_date_time,
            progress_type,
            created,
            created_by )
SELECT i.patient_workplan_id,
            i.patient_workplan_item_id,
            i.cpr_id,
            i.encounter_id,
            @ps_user_id,
            getdate(),
            'CANCELLED',
            getdate(),
            @ps_created_by
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_Encounter e
	ON i.cpr_id = e.cpr_id
	AND i.encounter_id = e.encounter_id
WHERE i.active_service_flag = 'Y'
AND i.ordered_service = 'SENDBILLING'
AND e.encounter_status = 'CLOSED'
AND i.created < dateadd(day, -7, getdate())

-- close the open in-office services if an encounter is "Closed"
INSERT INTO p_Patient_WP_Item_Progress (
            patient_workplan_id,
            patient_workplan_item_id,
            cpr_id,
            encounter_id,
            [user_id],
            progress_date_time,
            progress_type,
            created,
            created_by )
SELECT i.patient_workplan_id,
            i.patient_workplan_item_id,
            i.cpr_id,
            i.encounter_id,
            @ps_user_id,
            getdate(),
            'CANCELLED',
            getdate(),
            @ps_created_by
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_Encounter e
	ON i.cpr_id = e.cpr_id
	AND i.encounter_id = e.encounter_id
WHERE i.active_service_flag = 'Y'
AND e.encounter_status = 'CLOSED'
AND i.in_office_flag = 'Y'
AND i.item_type = 'Service'
AND i.ordered_service <> 'MESSAGE'

-- Set the in-office messages to out-of-office if the encounter is closed
UPDATE i
SET in_office_flag = 'N'
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_Encounter e
	ON i.cpr_id = e.cpr_id
	AND i.encounter_id = e.encounter_id
WHERE i.active_service_flag = 'Y'
AND e.encounter_status = 'CLOSED'
AND i.in_office_flag = 'Y'
AND i.item_type = 'Service'
AND i.ordered_service = 'MESSAGE'

-- Close encounters with no pending service
DECLARE @ls_cpr_id varchar(12),
	@ll_encounter_id int

DECLARE lc_open_encounters INSENSITIVE CURSOR FOR
	SELECT e.cpr_id,
		e.encounter_id
	FROM p_Patient_Encounter e
	WHERE encounter_status = 'OPEN'
	AND NOT EXISTS (
		SELECT patient_workplan_item_id
		FROM p_Patient_WP_Item i
		WHERE i.cpr_id = e.cpr_id
		AND i.encounter_id = e.encounter_id
		AND i.in_office_flag = 'Y'
		AND i.status IN ('DISPATCHED', 'STARTED') )

OPEN lc_open_encounters

FETCH lc_open_encounters INTO
	@ls_cpr_id,
	@ll_encounter_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_close_encounter
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Daily Maintenance',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END

	FETCH lc_open_encounters INTO
		@ls_cpr_id,
		@ll_encounter_id
	END

CLOSE lc_open_encounters

DEALLOCATE lc_open_encounters

-- Close encounters older than days specified
-- for the encounters which are started (some of the
-- workplans completed for the encounter but left open )
IF @pi_encounter_started_days > 0
	BEGIN
	EXECUTE sp_close_past_encounters
		@ps_flag = 'S',
		@pi_days = @pi_encounter_started_days,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Daily Maintenance',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END
	END
-- Close encounters older than days specified
-- never started (sitting in waiting room)
IF @pi_encounter_not_started_days > 0
	BEGIN
	EXECUTE sp_close_past_encounters
		@ps_flag = 'N',
		@pi_days = @pi_encounter_not_started_days,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Daily Maintenance',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END
	END
-- Close assessments which need to be auto-closed
EXECUTE sp_assessment_auto_close
	@ps_user_id = @ps_user_id,
	@ps_created_by = @ps_created_by

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Remove any treatment definition records which need an observation_id but don't have one
DELETE d
FROM u_Assessment_Treat_Definition d
	INNER JOIN c_Treatment_Type t
	ON d.treatment_type = t.treatment_type
WHERE t.component_id = 'TREAT_TEST'
AND NOT EXISTS (
	SELECT a.attribute_sequence
	FROM u_Assessment_Treat_Def_Attrib a
	WHERE a.definition_id = d.definition_id
	AND a.attribute = 'observation_id')

-- Remove any treatment definition records which need an drug_id but don't have one
DELETE d
FROM u_Assessment_Treat_Definition d
	INNER JOIN c_Treatment_Type t
	ON d.treatment_type = t.treatment_type
WHERE t.component_id IN ('TREAT_MEDICATION', 'TREAT_OFFICEMED')
AND NOT EXISTS (
	SELECT a.attribute_sequence
	FROM u_Assessment_Treat_Def_Attrib a
	WHERE a.definition_id = d.definition_id
	AND a.attribute = 'drug_id')

-- Remove any treatment definition records which need an procedure_id but don't have one
DELETE d
FROM u_Assessment_Treat_Definition d
	INNER JOIN c_Treatment_Type t
	ON d.treatment_type = t.treatment_type
WHERE t.component_id = 'TREAT_PROCEDURE'
AND NOT EXISTS (
	SELECT a.attribute_sequence
	FROM u_Assessment_Treat_Def_Attrib a
	WHERE a.definition_id = d.definition_id
	AND a.attribute = 'procedure_id')

-- Clean up workplan tables
DELETE s
FROM c_Workplan_Step s
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan w
	WHERE w.workplan_id = s.workplan_id)

DELETE r
FROM c_Workplan_Step_Room r
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan_Step s
	WHERE s.workplan_id = r.workplan_id
	AND s.step_number = r.step_number)

DELETE i
FROM c_Workplan_Item i
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan_Step s
	WHERE s.workplan_id = i.workplan_id
	AND s.step_number = i.step_number)

DELETE a
FROM c_Workplan_Item_Attribute a
WHERE NOT EXISTS (
	SELECT workplan_id
	FROM c_Workplan_Item i
	WHERE a.workplan_id = i.workplan_id
	AND a.item_number = i.item_number)

DELETE r
FROM u_Exam_Default_Results r
WHERE NOT EXISTS (
            SELECT branch_id
            FROM c_Observation_Tree t
            WHERE r.branch_id = t.branch_id)


DELETE
FROM o_treatment_type_default_mode
WHERE treatment_mode not in (
	SELECT treatment_mode
	FROM c_treatment_type_workplan )


DELETE
FROM u_exam_default_results
WHERE [user_id] not in (
	SELECT [user_id] 
	FROM c_user )
AND [user_id] not in (
	SELECT specialty_id 
	FROM c_specialty )
AND [user_id] <> '!DEFAULT'


DELETE
FROM u_top_20
WHERE top_20_code in (
	'ASSESSMENT_SICK',
	'ASSESSMENT_WELL',
	'ASSESSMENT_ALLERGY',
	'ASSESSMENT_OB',
	'ASSESSMENT_PT',
	'ASSESSMENT_VACCINE')
AND item_id not in (
	SELECT assessment_id 
	FROM c_assessment_definition )


DELETE
FROM u_top_20
WHERE top_20_code = 'PROCEDURE_IMMUNIZATION'
AND item_id not in (
	SELECT procedure_id 
	FROM c_procedure )


DELETE
FROM p_Attachment
WHERE status = 'DELETED'
AND cpr_id IS NULL
AND created < DATEADD(DAY, -14, getdate())

-- Delete invalid records from o_User_Service_Lock
DELETE
FROM o_User_Service_Lock
WHERE computer_id NOT IN (
	SELECT computer_id
	FROM o_Computers)

EXECUTE sp_maintenance_expire_services
	@ps_user_id = @ps_user_id,
	@ps_created_by = @ps_created_by

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END


-- Delete workplan item records that were skipped
DELETE i
FROM p_Patient_WP_Item i
WHERE i.status = 'Skipped'
AND i.created < dateadd(day, -14, getdate())

-- Clean up p_patient name_prefix field
UPDATE p_patient 
SET name_prefix = NULL
WHERE name_prefix = ''

-- Remove Orphaned Records from c_Observation_Tree 
DELETE t
FROM c_Observation_Tree t
WHERE not exists (
	SELECT 1 
	FROM c_Observation o
	WHERE t.child_observation_id = o.observation_id)

-- Purge the fretext lists
EXECUTE jmj_purge_freetext_picklists

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DECLARE @ls_workflow_model_standard_date varchar(64),
		@ls_workflow_model varchar(64)

SET @ls_workflow_model = dbo.fn_get_preference('SYSTEM', 'Workflow Model', NULL, NULL)
SET @ls_workflow_model_standard_date = dbo.fn_get_preference('SYSTEM', 'Workflow Model Standard Date', NULL, NULL)
IF ISDATE(@ls_workflow_model_standard_date) = 1 AND @ls_workflow_model IS NULL
	BEGIN
	IF CAST(@ls_workflow_model_standard_date AS datetime) <= getdate()
		EXEC sp_set_preference 'SYSTEM', 'Global', 'Global', 'Workflow Model', 'Standard'

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Daily Maintenance',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END
	END


-- Purge scheduled service records back to 30 days
DECLARE @svcs TABLE (
	patient_workplan_item_id int NOT NULL )

INSERT INTO @svcs (
	patient_workplan_item_id)
SELECT DISTINCT TOP 100000 patient_workplan_item_id
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN (SELECT DISTINCT [user_id], [service]
				FROM o_Service_Schedule ) s
	ON i.[owned_by] = s.[user_id]
	AND i.[ordered_service] = s.[service]
	AND i.active_service_flag = 'N'
	AND i.dispatch_date < DATEADD(day, -30, getdate())
WHERE i.patient_workplan_id = 0
AND workplan_id = 0

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

DELETE i
FROM p_Patient_WP_Item i
	INNER JOIN @svcs s
	ON i.patient_workplan_item_id = s.patient_workplan_item_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

EXECUTE jmjsys_Check_Equivalence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

EXECUTE jmj_log_backups

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END


DECLARE @ls_sync varchar(24)

SET @ls_sync = dbo.fn_get_preference('PREFERENCES', 'Daily Sync', NULL, NULL)
IF @ls_sync IS NULL
	BEGIN
	IF EXISTS (	SELECT 1
				FROM o_Service_Schedule s
					INNER JOIN o_Service_Schedule_Attribute a
					ON s.service_sequence = a.service_sequence
				WHERE s.service = 'Database Maintenance'
				AND s.status = 'OK'
				AND a.attribute = 'Sync Content'
				AND LEFT(a.value, 1) IN ('T', 'Y')
				)
		SET @ls_sync = 'N'
	ELSE
		SET @ls_sync = 'Y'
	END	

--IF LEFT(@ls_sync, 1) IN ('T', 'Y')
--	EXECUTE jmjsys_daily_sync

--SELECT @ll_error = @@ERROR,
--		@ll_rowcount = @@ROWCOUNT

--IF @ll_error <> 0
--	BEGIN
--	EXECUTE jmj_log_database_maintenance
--			@ps_action = 'Daily Maintenance',
--			@ps_completion_status = 'Error'
	
--	RETURN -1
--	END



INSERT INTO c_XML_Code (
		owner_id ,
		code_domain ,
		code_version ,
		code ,
		code_description ,
		epro_domain ,
		created_by ,
		status)
SELECT 	i.owner_id ,
		i.code_domain ,
		i.code_version ,
		i.code ,
		i.code_description ,
		d.epro_domain ,
		'#SYSTEM',
		'Unmapped'
FROM c_XML_Code_Domain_Item i
	INNER JOIN c_XML_Code_Domain d
	ON d.owner_id = i.owner_id
	AND d.code_domain = i.code_domain
WHERE d.epro_domain IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM [dbo].[c_XML_Code] c
	WHERE c.owner_id = i.owner_id
	AND c.code_domain = i.code_domain
	AND c.code = i.code
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END



DECLARE @ls_computername varchar(40)

DECLARE lc_nodistiller CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT c.computername
	FROM o_computers c
		INNER JOIN o_user_logins l
		ON l.computer_id = c.computer_id
	WHERE l.action_time > DATEADD(DAY, -7, getdate())
	AND NOT EXISTS (
		SELECT 1
		FROM o_computer_printer p
		WHERE p.computer_id = c.computer_id
		AND p.printer = 'Sybase Datawindow PS'
		AND p.last_discovered > DATEADD(DAY, -1, l.action_time)
		)

OPEN lc_nodistiller

FETCH lc_nodistiller INTO @ls_computername

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE dbo.jmj_log_database_maintenance
		@ps_action = 'Check ''Sybase Datawindow PS''',
		@ps_completion_status = 'Error'

	FETCH lc_nodistiller INTO @ls_computername
	END

CLOSE lc_nodistiller
DEALLOCATE lc_nodistiller

---------------------------------------------------------------------------
-- Find and reparir problems with the config object tables
---------------------------------------------------------------------------

-- If the owner_id's disagree then the config_object table overrides
UPDATE r
SET owner_id = c.owner_id
FROM c_Report_Definition r
	INNER JOIN c_Config_Object c
	ON c.config_object_id = r.report_id
WHERE c.owner_id <> r.owner_id

-- Remove invalid version records
DELETE
FROM c_config_object_version
WHERE owner_id = 0
AND (objectdata IS NULL OR datalength(objectdata) = 0)

-- Fix the latest_version
UPDATE c
SET latest_version = NULL,
	latest_version_date = NULL,
	latest_version_status = NULL
FROM c_Config_Object c
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Config_Object_Version v
	WHERE c.config_object_id = v.config_object_id)
AND latest_version > 0

-- Reports get a special zero version
UPDATE c
SET latest_version = 0,
	latest_version_date = r.last_updated,
	latest_version_status = 'CheckedIn'
FROM c_Config_Object c
	INNER JOIN c_Report_Definition r
	ON c.config_object_id = r.report_id
WHERE c.latest_version IS NULL

-- For any JMJ report that doesn't have a version record and the version # is greater than zero, set the version # to zero
UPDATE r
SET version = 0
FROM c_report_definition r
WHERE owner_id = 0
AND r.version > 0
AND NOT EXISTS (
	select 1
	from c_config_object_version v
	where v.config_object_id = r.report_id
	and v.version = r.version)

UPDATE c
SET installed_version = r.version,
	installed_version_date = r.last_updated
FROM c_Config_Object c
	INNER JOIN c_Report_Definition r
	ON c.config_object_id = r.report_id
WHERE (c.installed_version IS NULL OR c.installed_version <> r.version)

-- Remove locally owned version that are checked in but empty
DELETE v
FROM c_Config_Object_Version v
	INNER JOIN c_Database_Status d
	ON v.owner_id = d.customer_id
WHERE (v.objectdata IS NULL OR datalength(v.objectdata) = 0)
AND v.status = 'CheckedIn'

-- Remove locally owned report objects that have no version record and no entry in c_report_definition
DELETE c
FROM c_Config_Object c
	INNER JOIN c_Database_Status d
	ON c.owner_id = d.customer_id
WHERE NOT EXISTS (
	select 1
	from c_config_object_version v
	where v.config_object_id = c.config_object_id)
AND NOT EXISTS (
	select 1
	from c_Report_Definition r
	where c.config_object_id = r.report_id)

-------------------------------------------------------------------------------------------------
-- Turn off component debug modes
-------------------------------------------------------------------------------------------------
DECLARE @ls_component_debug_mode_reset varchar(64)

SET @ls_component_debug_mode_reset = dbo.fn_get_preference('SYSTEM', 'Component Debug Mode Reset', NULL, NULL)
IF @ls_component_debug_mode_reset IS NULL
	SET @ls_component_debug_mode_reset = 'Y'

IF LEFT(@ls_component_debug_mode_reset, 1) IN ('T', 'Y')
	UPDATE c_Component_Attribute
	SET value = 'False'
	WHERE attribute = 'debug_mode'

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Daily Maintenance',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END
-------------------------------------------------------------------------------------------------


EXECUTE jmj_log_database_maintenance
		@ps_action = 'Daily Maintenance',
		@ps_completion_status = 'OK'
GO
GRANT EXECUTE
	ON [dbo].[sp_maintenance_frequent]
	TO [cprsystem]
GO

