
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_observations]
Print 'Drop Function [dbo].[fn_patient_observations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_observations]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_observations]
GO

-- Create Function [dbo].[fn_patient_observations]
Print 'Create Function [dbo].[fn_patient_observations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION dbo.fn_patient_observations (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer = NULL,
	@pl_treatment_id integer = NULL)

RETURNS @patient_observations TABLE (
		cpr_id varchar(12) NOT NULL,
		observation_sequence int NOT NULL,
		observation_id varchar(24) NOT NULL,
		parent_observation_sequence int NULL,
		treatment_id int NULL,
		result_count int NULL)

AS

BEGIN

DECLARE @ll_depth int,
	@ll_count int,
	@ls_treatment_status varchar(12)

DECLARE @patient_results TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location varchar(24) NOT NULL,
	result_sequence smallint NOT NULL,
	location_result_sequence int NOT NULL,
	result_date_time datetime NULL)

DECLARE @patient_comments TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	comment_title varchar(48) NULL,
	observation_comment_id int NOT NULL,
	deleted_flag char(1) NULL DEFAULT ('N'))

DECLARE @tmp_encounter_observations TABLE (
		cpr_id varchar(12) NOT NULL,
		observation_sequence int NOT NULL,
		observation_id varchar(24) NOT NULL,
		parent_observation_sequence int NULL,
		treatment_id int NULL,
		result_count int NULL,
		depth int NULL)

IF @pl_treatment_id IS NOT NULL
	BEGIN
	SELECT @ls_treatment_status = ISNULL(treatment_status, 'OPEN')
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	
	IF @ls_treatment_status = 'CANCELLED'
		RETURN
	END

-- Get all the distinct results
IF @pl_encounter_id IS NULL
	BEGIN
	INSERT INTO @patient_results (
		cpr_id,
		observation_sequence,
		location,
		result_sequence,
		location_result_sequence )
	SELECT r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence,
		max(r.location_result_sequence) as location_result_sequence
	FROM p_Observation_Result r
	WHERE r.cpr_id = @ps_cpr_id	
	AND r.treatment_id = @pl_treatment_id
	GROUP BY r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence

	INSERT INTO @patient_comments (
		cpr_id,
		observation_sequence,
		comment_title,
		observation_comment_id )
	SELECT c.cpr_id,
		c.observation_sequence,
		c.comment_title,
		max(c.observation_comment_id) as observation_comment_id
	FROM p_Observation_Comment c
	WHERE c.cpr_id = @ps_cpr_id	
	AND c.treatment_id = @pl_treatment_id
	GROUP BY c.cpr_id,
		c.observation_sequence,
		c.comment_title
	END
ELSE IF @pl_treatment_id IS NULL
	BEGIN
	INSERT INTO @patient_results (
		cpr_id,
		observation_sequence,
		location,
		result_sequence,
		location_result_sequence )
	SELECT r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence,
		max(r.location_result_sequence) as location_result_sequence
	FROM p_Observation_Result r
		INNER JOIN p_Treatment_Item i
		ON r.cpr_id = i.cpr_id
		AND r.treatment_id = i.treatment_id
	WHERE r.cpr_id = @ps_cpr_id	
	AND r.encounter_id = @pl_encounter_id
	AND ISNULL(i.treatment_status, 'OPEN') <> 'CANCELLED'
	GROUP BY r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence

	INSERT INTO @patient_comments (
		cpr_id,
		observation_sequence,
		comment_title,
		observation_comment_id )
	SELECT c.cpr_id,
		c.observation_sequence,
		c.comment_title,
		max(c.observation_comment_id) as observation_comment_id
	FROM p_Observation_Comment c
		INNER JOIN p_Treatment_Item i
		ON c.cpr_id = i.cpr_id
		AND c.treatment_id = i.treatment_id
	WHERE c.cpr_id = @ps_cpr_id	
	AND c.encounter_id = @pl_encounter_id
	AND ISNULL(i.treatment_status, 'OPEN') <> 'CANCELLED'
	GROUP BY c.cpr_id,
		c.observation_sequence,
		c.comment_title
	END
ELSE
	BEGIN
	INSERT INTO @patient_results (
		cpr_id,
		observation_sequence,
		location,
		result_sequence,
		location_result_sequence )
	SELECT r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence,
		max(r.location_result_sequence) as location_result_sequence
	FROM p_Observation_Result r
	WHERE r.cpr_id = @ps_cpr_id	
	AND r.encounter_id = @pl_encounter_id
	AND r.treatment_id = @pl_treatment_id
	GROUP BY r.cpr_id,
		r.observation_sequence,
		r.location,
		r.result_sequence

	INSERT INTO @patient_comments (
		cpr_id,
		observation_sequence,
		comment_title,
		observation_comment_id )
	SELECT c.cpr_id,
		c.observation_sequence,
		c.comment_title,
		max(c.observation_comment_id) as observation_comment_id
	FROM p_Observation_Comment c
	WHERE c.cpr_id = @ps_cpr_id	
	AND c.encounter_id = @pl_encounter_id
	AND c.treatment_id = @pl_treatment_id
	GROUP BY c.cpr_id,
		c.observation_sequence,
		c.comment_title
	END


-- Get the result_date_time for each results.  We do this because any location/result
-- combination where the latest record has a null result_date_time is considered deleted
UPDATE t
SET result_date_time = r.result_date_time
FROM @patient_results t 
INNER JOIN p_Observation_Result r
	ON t.cpr_id = r.cpr_id
	AND t.observation_sequence = r.observation_sequence
	AND t.location_result_sequence = r.location_result_sequence
WHERE	r.cpr_id = @ps_cpr_id	

-- Set the deleted_flag for any comment which has no attachment_id and a null comment value
UPDATE c
SET deleted_flag = 'Y'
FROM @patient_comments c 
INNER JOIN p_Observation_Comment p
	ON c.cpr_id = p.cpr_id
	AND c.observation_sequence = p.observation_sequence
	AND c.observation_comment_id = p.observation_comment_id
WHERE p.comment IS NULL
AND p.short_comment IS NULL
AND p.attachment_id IS NULL
AND	p.cpr_id = @ps_cpr_id

-- Now get a list of the observation which had non-deleted results
INSERT INTO @tmp_encounter_observations (
	cpr_id,
	observation_sequence,
	observation_id,
	parent_observation_sequence,
	treatment_id,
	result_count,
	depth)
SELECT o.cpr_id,
	o.observation_sequence,
	o.observation_id,
	o.parent_observation_sequence,
	o.treatment_id,
	count(r.location_result_sequence) as result_count,
	1 as depth
FROM @patient_results r
JOIN p_Observation o ON r.cpr_id = o.cpr_id
	AND r.observation_sequence = o.observation_sequence
WHERE r.location_result_sequence IS NOT NULL
AND r.result_date_time IS NOT NULL
AND o.cpr_id = @ps_cpr_id
GROUP BY o.cpr_id,
	o.observation_sequence,
	o.observation_id,
	o.parent_observation_sequence,
	o.treatment_id

-- Add the list of the observation which had non-deleted comments
INSERT INTO @tmp_encounter_observations (
	cpr_id,
	observation_sequence,
	observation_id,
	parent_observation_sequence,
	treatment_id,
	result_count,
	depth)
SELECT o.cpr_id,
	o.observation_sequence,
	o.observation_id,
	o.parent_observation_sequence,
	o.treatment_id,
	count(c.observation_comment_id) as result_count,
	1 as depth
FROM @patient_comments c
JOIN p_Observation o ON c.cpr_id = o.cpr_id
	AND c.observation_sequence = o.observation_sequence
WHERE c.deleted_flag = 'N'
AND o.cpr_id = @ps_cpr_id
AND NOT EXISTS (
	SELECT observation_sequence
	FROM @tmp_encounter_observations t
	WHERE c.cpr_id = t.cpr_id
	AND c.observation_sequence = t.observation_sequence)
GROUP BY o.cpr_id,
	o.observation_sequence,
	o.observation_id,
	o.parent_observation_sequence,
	o.treatment_id

-- Then go up the tree and gather all the parents
SET @ll_count = 1
SET @ll_depth = 1
WHILE @ll_count > 0 AND @ll_depth < 20
BEGIN
	SET @ll_depth = @ll_depth + 1

	INSERT INTO @tmp_encounter_observations (
		cpr_id,
		observation_sequence,
		observation_id,
		parent_observation_sequence,
		treatment_id,
		depth)
	SELECT DISTINCT o.cpr_id,
		o.observation_sequence,
		o.observation_id,
		o.parent_observation_sequence,
		o.treatment_id,
		@ll_depth as depth
	FROM 		@tmp_encounter_observations t 
	INNER JOIN 	p_Observation o
	ON 	t.cpr_id = o.cpr_id
	AND t.parent_observation_sequence = o.observation_sequence
	WHERE o.cpr_id = @ps_cpr_id
	AND t.depth = @ll_depth - 1
	AND t.parent_observation_sequence IS NOT NULL
	AND NOT EXISTS (	SELECT 1
				FROM @tmp_encounter_observations t2
				WHERE o.cpr_id = t2.cpr_id
				AND 	o.observation_sequence = t2.observation_sequence
			)


	SET @ll_count = @@ROWCOUNT
END

INSERT INTO @patient_observations (
	cpr_id,
	observation_sequence,
	observation_id,
	parent_observation_sequence,
	treatment_id,
	result_count
	)
SELECT cpr_id,
	observation_sequence,
	observation_id,
	parent_observation_sequence,
	treatment_id,
	result_count
FROM @tmp_encounter_observations

RETURN
END



GO
GRANT SELECT ON [dbo].[fn_patient_observations] TO [cprsystem]
GO

