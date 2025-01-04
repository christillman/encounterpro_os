
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_context_info]
Print 'Drop Procedure [dbo].[jmj_context_info]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_context_info]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_context_info]
GO

-- Create Procedure [dbo].[jmj_context_info]
Print 'Create Procedure [dbo].[jmj_context_info]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_context_info (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24) = 'Patient',
	@pl_object_key int = NULL,
	@ps_user_id varchar(24))
AS

-- Context Keys
DECLARE @ll_treatment_id int,
		@ll_problem_id int,
		@ll_encounter_id int,
		@ll_observation_sequence int,
		@ll_attachment_id int,
		@ll_location_result_sequence int,
		@test_patient bit

SET @ll_treatment_id = NULL
SET @ll_problem_id = NULL
SET @ll_encounter_id = NULL
SET @ll_observation_sequence = NULL
SET @ll_attachment_id = NULL

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	SET @ll_problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	SET @ll_observation_sequence = @pl_object_key

IF @ps_context_object = 'Attachment'
	SET @ll_attachment_id = @pl_object_key


DECLARE @context TABLE (
	cpr_id varchar(12) NULL,
	context_object varchar(24) NOT NULL,
	object_key varchar(24) NOT NULL,
	attribute varchar(64) NOT NULL,
	value varchar(255) NULL,
	unit_id varchar(24) NULL,
	context_object_sort int NOT NULL )

-- General context attributes
DECLARE @ll_customer_id int,
		@ll_major_release int,
		@ls_database_version varchar(4),
		@ll_modification_level int,
		@ls_provider varchar(64),
		@ls_physician varchar(64),
		@ls_epie_user varchar(64),
		@ls_epie_pwd varchar(64)

-- Patient context attributes
DECLARE @ls_last_name varchar(40),
		@ls_first_name varchar(20),
		@ls_middle_name varchar(20),
		@ls_billing_id varchar(24),
		@ls_sex char(1),
		@ldt_date_of_birth datetime,
		@ls_patient_status varchar(24),
		@ls_race varchar(24)

-- Encounter context attributes
DECLARE @ls_encounter_type varchar(24),
		@ls_encounter_status varchar(8),
		@ldt_encounter_date datetime,
		@ls_encounter_description varchar(80),
		@ls_attending_doctor varchar(24)

-- Assessment context attributes
DECLARE @ls_assessment_type varchar(24),
		@ls_assessment_id varchar(24),
		@ls_assessment varchar(80),
		@ls_location varchar(24),
		@ldt_begin_date datetime,
		@ldt_end_date datetime,
		@ls_diagnosed_by varchar(24),
		@ls_assessment_status varchar(12),
		@ll_assessment_encounter_id int

-- Treatment context attributes
DECLARE @ls_treatment_type varchar(24),
		@ls_treatment_description varchar(80),
--		@ldt_begin_date datetime,
--		@ldt_end_date datetime,
		@ls_ordered_by varchar(24),
		@ls_treatment_status varchar(12),
		@ll_treatment_encounter_id int

-- Observation context attributes
DECLARE @ls_observation_id varchar(24),
		@ls_description varchar(80),
		@ldt_result_expected_date datetime,
		@ls_observation_tag varchar(80),
		@ls_observed_by varchar(24),
		@ll_observation_treatment_id int

-- Attachment context attributes
DECLARE @ls_attachment_type varchar(24),
		@ls_attachment_tag varchar(8),
		@ldt_attachment_date datetime,
		@ls_attachment_folder varchar(80),
		@ls_attached_by varchar(24),
		@ls_attachment_context_object varchar(24),
		@ll_attachment_object_key int

SET @ls_provider = NULL
SET @ls_physician = NULL

SELECT @ll_customer_id = customer_id,
		@ll_major_release = major_release,
		@ls_database_version = database_version,
		@ll_modification_level = modification_level
FROM c_Database_Status

IF @ll_modification_level IS NULL
	BEGIN
	RAISERROR ('Cannot find database status',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ls_epie_user = preference_value
FROM o_Preferences
WHERE preference_id='epie_user'
and preference_level='global'
and preference_key='global'

INSERT INTO @context (
	cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	context_object_sort)
VALUES (
	@ps_cpr_id,
	'General',
	'General',
	'epie_user',
	@ls_epie_user,
	0)
	
INSERT INTO @context (
	cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	context_object_sort)
VALUES (
	@ps_cpr_id,
	'General',
	'General',
	'customer_id',
	@ll_customer_id,
	0)

INSERT INTO @context (
	cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	context_object_sort)
VALUES (
	@ps_cpr_id,
	'General',
	'General',
	'major_release',
	@ll_major_release,
	0)

INSERT INTO @context (
	cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	context_object_sort)
VALUES (
	@ps_cpr_id,
	'General',
	'General',
	'database_version',
	@ls_database_version,
	0)

INSERT INTO @context (
	cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	context_object_sort)
VALUES (
	@ps_cpr_id,
	'General',
	'General',
	'modification_level',
	@ll_modification_level,
	0)

SELECT @ls_last_name = last_name,
		@ls_first_name = first_name,
		@ls_middle_name = middle_name,
		@ls_billing_id = billing_id,
		@ls_sex = sex,
		@ldt_date_of_birth = date_of_birth,
		@ls_patient_status = patient_status,
		@ls_race = race,
		@test_patient = test_patient
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

IF @test_patient IS NOT NULL
	BEGIN
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'last_name',
		@ls_last_name,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'first_name',
		@ls_first_name,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'middle_name',
		@ls_middle_name,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'billing_id',
		@ls_billing_id,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'sex',
		@ls_sex,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'date_of_birth',
		CONVERT(varchar(40), @ldt_date_of_birth, 126) ,
		1)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'patient_status',
		@ls_patient_status,
		1)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		'race',
		@ls_race,
		1)
	END

IF @ll_attachment_id > 0 AND @ps_cpr_id IS NOT NULL
	BEGIN
	SELECT @ls_attachment_type = attachment_type,
			@ls_attachment_tag = attachment_tag,
			@ldt_attachment_date = attachment_date,
			@ls_attachment_folder = attachment_folder,
			@ls_attached_by = attached_by,
			@ls_attachment_context_object = context_object,
			@ll_attachment_object_key = object_key,
			@test_patient = default_grant
	FROM p_Attachment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @ll_attachment_id

	IF @test_patient IS NULL
		BEGIN
		RAISERROR ('Cannot find attachment %s, %d',16,-1, @ps_cpr_id, @ll_attachment_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'attachment_type',
		@ls_attachment_type,
		6)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'attachment_tag',
		@ls_attachment_tag,
		6)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'attachment_date',
		CONVERT(varchar(40), @ldt_attachment_date, 126) ,
		6)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'attachment_folder',
		@ls_attachment_folder,
		6)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'attached_by',
		@ls_attached_by,
		6)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'context_object',
		@ls_attachment_context_object,
		6)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Attachment',
		@ll_attachment_id,
		'object_key',
		CAST(@ll_attachment_object_key AS varchar(24)),
		6)
		
	IF @ls_attachment_context_object = 'Encounter' AND @ll_encounter_id IS NULL
		SET @ll_encounter_id = @ll_attachment_object_key

	IF @ls_attachment_context_object = 'Assessment' AND @ll_problem_id IS NULL
		SET @ll_problem_id = @ll_attachment_object_key

	IF @ls_attachment_context_object = 'Treatment' AND @ll_treatment_id IS NULL
		SET @ll_treatment_id = @ll_attachment_object_key

	IF @ls_attachment_context_object = 'Observation' AND @ll_observation_sequence IS NULL
		SET @ll_observation_sequence = @ll_attachment_object_key
	
	END

IF @ll_observation_sequence > 0 AND @ps_cpr_id IS NOT NULL
	BEGIN
	SELECT @ls_observation_id = observation_id,
			@ls_description = description,
			@ldt_result_expected_date = result_expected_date,
			@ls_observation_tag = observation_tag,
			@ls_observed_by = observed_by,
			@ll_observation_treatment_id = treatment_id
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @ll_observation_sequence

	IF @ls_description IS NULL
		BEGIN
		RAISERROR ('Cannot find observation %s, %d',16,-1, @ps_cpr_id, @ll_observation_sequence)
		ROLLBACK TRANSACTION
		RETURN
		END
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'observation_id',
		@ls_observation_id,
		5)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'description',
		@ls_description,
		5)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'result_expected_date',
		CONVERT(varchar(40), @ldt_result_expected_date, 126) ,
		5)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'observation_tag',
		@ls_observation_tag,
		5)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'observed_by',
		@ls_observed_by,
		5)
		
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Observation',
		@ll_observation_sequence,
		'treatment_id',
		CAST(@ll_observation_treatment_id AS varchar(24)),
		5)
		
	IF @ll_observation_treatment_id IS NOT NULL AND @ll_treatment_id IS NULL
		SET @ll_treatment_id = @ll_observation_treatment_id

	END

IF @ll_treatment_id > 0 AND @ps_cpr_id IS NOT NULL
	BEGIN
	SELECT @ls_treatment_type = treatment_type,
			@ls_treatment_description = treatment_description,
			@ldt_begin_date = begin_date,
			@ldt_end_date = end_date,
			@ls_ordered_by = ordered_by,
			@ls_treatment_status = treatment_status,
			@ll_treatment_encounter_id = open_encounter_id
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_treatment_id

	IF @ll_treatment_encounter_id IS NULL
		BEGIN
		RAISERROR ('Cannot find treatment %s, %d',16,-1, @ps_cpr_id, @ll_treatment_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'treatment_type',
		@ls_treatment_type,
		4)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'treatment_description',
		@ls_treatment_description,
		4)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'begin_date',
		CONVERT(varchar(40), @ldt_begin_date, 126) ,
		4)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'end_date',
		CONVERT(varchar(40), @ldt_end_date, 126) ,
		4)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'ordered_by',
		@ls_ordered_by,
		4)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Treatment',
		@ll_treatment_id,
		'treatment_status',
		@ls_treatment_status,
		4)

	DECLARE @ll_assessment_count int
	
	SELECT @ll_assessment_count = count(*)
	FROM p_Assessment_Treatment
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_treatment_id
	
	IF @ll_assessment_count = 1
		SELECT @ll_problem_id = problem_id
		FROM p_Assessment_Treatment
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @ll_treatment_id 

	IF @ll_treatment_encounter_id IS NOT NULL AND @ll_encounter_id IS NULL
		SET @ll_encounter_id = @ll_treatment_encounter_id

	END
	
IF @ll_problem_id > 0 AND @ps_cpr_id IS NOT NULL
	BEGIN
-- Assessment context attributes
	SELECT @ls_assessment_type = assessment_type,
			@ls_assessment_id = assessment_id,
			@ls_assessment = assessment,
			@ls_location = location,
			@ldt_begin_date = begin_date,
			@ldt_end_date = end_date,
			@ls_diagnosed_by = diagnosed_by,
			@ls_assessment_status = assessment_status,
			@ll_assessment_encounter_id = open_encounter_id
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @ll_problem_id

	IF @ls_assessment_id IS NULL
		BEGIN
		RAISERROR ('Cannot find assessment %s, %d',16,-1, @ps_cpr_id, @ll_problem_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'assessment_type',
		@ls_assessment_type,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'assessment_id',
		@ls_assessment_id,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'assessment',
		@ls_assessment,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'location',
		@ls_location,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'begin_date',
		CONVERT(varchar(40), @ldt_begin_date, 126) ,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'end_date',
		CONVERT(varchar(40), @ldt_end_date, 126) ,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'diagnosed_by',
		@ls_diagnosed_by,
		3)

	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Assessment',
		@ll_problem_id,
		'assessment_status',
		@ls_assessment_status,
		3)

	IF @ll_assessment_encounter_id IS NOT NULL AND @ll_encounter_id IS NULL
		SET @ll_encounter_id = @ll_assessment_encounter_id

	END
	
IF @ll_encounter_id > 0 AND @ps_cpr_id IS NOT NULL
	BEGIN
	SELECT @ls_encounter_type = encounter_type,
			@ls_encounter_status = encounter_status,
			@ldt_encounter_date = encounter_date,
			@ls_encounter_description = encounter_description,
			@ls_attending_doctor = attending_doctor,
			@test_patient = default_grant
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @test_patient IS NULL
		BEGIN
		RAISERROR ('Cannot find encounter %s, %d',16,-1, @ps_cpr_id, @ll_encounter_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Encounter',
		@ll_encounter_id,
		'encounter_type',
		@ls_encounter_type,
		2)
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Encounter',
		@ll_encounter_id,
		'encounter_status',
		@ls_encounter_status,
		2)
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Encounter',
		@ll_encounter_id,
		'encounter_date',
		CONVERT(varchar(40), @ldt_encounter_date, 126) ,
		2)
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Encounter',
		@ll_encounter_id,
		'encounter_description',
		@ls_encounter_description,
		2)
	
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'Encounter',
		@ll_encounter_id,
		'attending_doctor',
		@ls_attending_doctor,
		2)
	
	IF @ls_physician IS NULL
		SELECT @ls_physician = user_full_name
		FROM c_User
		WHERE [user_id] = @ls_attending_doctor
	END

IF @ls_physician IS NOT NULL
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		context_object_sort)
	VALUES (
		@ps_cpr_id,
		'General',
		'General',
		'physician',
		@ls_physician,
		0)

IF @ps_user_id IS NOT NULL
	BEGIN
	SELECT @ls_provider = user_full_name, @ls_encounter_status = status
	FROM c_User
	WHERE [user_id] = @ps_user_id
	
	IF @ls_encounter_status IS NOT NULL
		BEGIN
		INSERT INTO @context (
			cpr_id,
			context_object,
			object_key ,
			attribute ,
			value,
			context_object_sort)
		VALUES (
			@ps_cpr_id,
			'General',
			'General',
			'provider',
			@ls_provider,
			0)
		END
	END

SELECT @ll_location_result_sequence = max(location_result_sequence)
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id
AND observation_id = 'WGT'
AND result_sequence = -1
AND current_flag = 'Y'

IF @ll_location_result_sequence IS NOT NULL
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		unit_id,
		context_object_sort)
	SELECT
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		result,
		result_value,
		result_unit,
		1
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND location_result_sequence = @ll_location_result_sequence
 
	
SELECT @ll_location_result_sequence = max(location_result_sequence)
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id
AND observation_id = 'HGT'
AND result_sequence = -1
AND current_flag = 'Y'

IF @ll_location_result_sequence IS NOT NULL
	INSERT INTO @context (
		cpr_id,
		context_object,
		object_key ,
		attribute ,
		value,
		unit_id,
		context_object_sort)
	SELECT
		@ps_cpr_id,
		'Patient',
		@ps_cpr_id,
		result,
		result_value,
		result_unit,
		1
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND location_result_sequence = @ll_location_result_sequence
	

SELECT cpr_id,
	context_object,
	object_key ,
	attribute ,
	value,
	unit_id,
	context_object_sort
FROM @context
WHERE value IS NOT NULL

GO
GRANT EXECUTE
	ON [dbo].[jmj_context_info]
	TO [cprsystem]
GO

