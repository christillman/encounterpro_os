CREATE PROCEDURE sp_add_property_results_to_treatment_type
	(
	@ps_treatment_type varchar(24),
	@ps_result varchar(80)
	)
AS


DECLARE @ll_property_id int

DECLARE @result_sequence TABLE (
	observation_id varchar(24),
	result_sequence smallint)

SELECT @ll_property_id = property_id
FROM c_Property
WHERE property_object = 'Treatment'
AND function_name = @ps_result

IF @@ROWCOUNT <> 1
	BEGIN
	INSERT INTO c_Property (
		property_type,
		property_object,
		description,
		function_name,
		status )
	VALUES (
		'User Defined',
		'Treatment',
		@ps_result,
		@ps_result,
		'OK' )

	SET @ll_property_id = @@IDENTITY
	END

INSERT INTO @result_sequence (
	observation_id ,
	result_sequence)
SELECT t.observation_id,
	CASE WHEN max(r.result_sequence) IS NULL THEN 1 ELSE max(r.result_sequence) + 1 END as result_sequence
FROM c_Observation_Treatment_Type t
	LEFT OUTER JOIN c_Observation_Result r
	ON r.observation_id = t.observation_id
WHERE t.treatment_type = @ps_treatment_type
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation_Result r2
	WHERE t.observation_id = r2.observation_id
	AND r2.result_type = 'PROPERTY'
	AND r2.result = @ps_result )
AND (NOT EXISTS (
		SELECT tree.child_observation_id
		FROM c_Observation_Tree tree
		WHERE t.observation_id = tree.child_observation_id )
	OR EXISTS (
		SELECT item_id
		FROM u_top_20
		WHERE t.observation_id = u_top_20.item_id ) )
GROUP BY t.observation_id

-- Add the property result
INSERT INTO c_Observation_Result (
	[observation_id] ,
	[result_sequence] ,
	[result_type] ,
	[result_unit] ,
	[result] ,
	[result_amount_flag] ,
	[print_result_flag] ,
	[severity] ,
	[abnormal_flag] ,
	[property_id] ,
	[service] ,
	[print_result_separator] ,
	[status] ,
	[last_updated] ,
	[updated_by] )
SELECT [observation_id] ,
	[result_sequence] ,
	'PROPERTY' ,
	NULL ,
	@ps_result ,
	'N' ,
	'Y' ,
	0 ,
	'N' ,
	@ll_property_id ,
	'REFER_TREATMENT' ,
	'=' ,
	'OK' ,
	getdate() ,
	'#SYSTEM'
FROM @result_sequence

-- Fix any orphans
UPDATE c_Observation_Result
SET property_id = @ll_property_id
WHERE result_type = 'PROPERTY'
AND result = @ps_result
AND property_id IS NOT NULL
AND NOT EXISTS (
	SELECT property_id
	FROM c_Property
	WHERE c_Property.property_id = c_Observation_Result.property_id)


