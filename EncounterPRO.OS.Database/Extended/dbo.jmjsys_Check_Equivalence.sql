DROP PROCEDURE [jmjsys_Check_Equivalence]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_Check_Equivalence]
AS


DECLARE @ll_error int,
		@ll_rowcount int

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Assessment_Definition c
	ON e.object_type = 'Assessment'
	AND e.object_key = c.assessment_id
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Assessment ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT a.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = a.assessment_id,
	description = ISNULL(a.description, '<No Description>'),
	object_type = 'Assessment'
FROM c_Assessment_Definition a
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE a.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Assessment'

	RETURN -1
	END

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Drug_Definition c
	ON e.object_type = 'Drug'
	AND e.object_key = c.drug_id
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Drug ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT d.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = d.drug_id,
	description = ISNULL(d.common_name, '<No Description>'),
	object_type = 'Drug'
FROM c_Drug_Definition d
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE d.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Drug'

	RETURN -1
	END

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Procedure c
	ON e.object_type = 'Procedure'
	AND e.object_key = c.procedure_id
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Procedure ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT p.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = p.procedure_id,
	description = ISNULL(p.description, '<No Description>'),
	object_type = 'Procedure'
FROM c_Procedure p
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE p.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Procedure'

	RETURN -1
	END

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Patient_Material c
	ON e.object_type = 'Material'
	AND e.object_key = CAST(c.material_id AS varchar(64))
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Material ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT m.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = CAST(m.material_id AS varchar(64)),
	description = ISNULL(m.title, '<No Description>'),
	object_type = 'Material'
FROM c_Patient_Material m
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE m.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Material'

	RETURN -1
	END

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Observation c
	ON e.object_type = 'Observation'
	AND e.object_key = c.observation_id
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Observation ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT o.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = o.observation_id,
	description = ISNULL(o.description, '<No Description>'),
	object_type = 'Observation'
FROM c_Observation o
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE o.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Observation'

	RETURN -1
	END

-- Regenerate ID field for any records that have the same ID but different object_type/object_key
DELETE e
FROM c_Equivalence e
	INNER JOIN c_Observation_Result c
	ON e.object_type = 'Result'
	AND e.object_key = c.observation_id + '|' + CAST(c.result_sequence AS varchar(8))
WHERE c.ID <> e.object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Result ID Check'

	RETURN -1
	END

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT r.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = r.observation_id + '|' + CAST(r.result_sequence AS varchar(8)),
	description = r.result,
	object_type = 'Result'
FROM c_Observation_Result r
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE r.id = e.object_id
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'jmjsys_Check_Equivalence',
			@ps_completion_status = 'Error',
			@ps_action_argument = 'Result'

	RETURN -1
	END

GO
GRANT EXECUTE ON [jmjsys_Check_Equivalence] TO [cprsystem] AS [dbo]
GO
