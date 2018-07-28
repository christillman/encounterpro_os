CREATE TRIGGER tr_p_observation_result_progress_insert ON dbo.p_Observation_Result_Progress
FOR INSERT
AS
IF @@ROWCOUNT = 0
	RETURN


DECLARE
	 @Highlight_flag SMALLINT
	,@Modify_flag SMALLINT


/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @Highlight_flag = SUM( CHARINDEX( 'Highlight', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
FROM inserted


IF @Modify_flag > 0
BEGIN
	UPDATE r
	SET abnormal_flag = CASE i.progress_key WHEN 'abnormal_flag' then CONVERT(varchar(1), i.progress_value) ELSE r.abnormal_flag END,
		abnormal_nature = CASE i.progress_key WHEN 'abnormal_nature' then CONVERT(varchar(8), i.progress_value) ELSE r.abnormal_nature END,
		severity = CASE i.progress_key WHEN 'severity' then CONVERT(smallint, i.progress_value) ELSE r.severity END,
		current_flag = CASE i.progress_key WHEN 'current_flag' then CONVERT(char(1), i.progress_value) ELSE r.current_flag END,
		normal_range = CASE i.progress_key WHEN 'normal_range' then CONVERT(varchar(40), i.progress_value) ELSE r.normal_range END
	FROM p_Observation_Result r
		INNER JOIN inserted i
		ON i.cpr_id = r.cpr_id
		AND i.observation_sequence = r.observation_sequence
		AND i.location_result_sequence = r.location_result_sequence
	WHERE i.progress_type = 'Modify'
END

-- Set the current_flag
UPDATE p1
SET current_flag = 'N'
FROM p_Observation_Result_Progress p1
	INNER JOIN inserted p2
	ON p1.cpr_id = p2.cpr_id
	AND p1.observation_sequence = p2.observation_sequence
	AND p1.location_result_sequence = p2.location_result_sequence
	AND p1.progress_type = p2.progress_type
	AND ISNULL(p1.progress_key, '!NULL') = ISNULL(p2.progress_key, '!NULL')
WHERE p1.result_progress_sequence < p2.result_progress_sequence

-- Set the treatment_id
UPDATE p
SET treatment_id = o.treatment_id
FROM p_Observation_Result_Progress p
	INNER JOIN inserted i
	ON p.cpr_id = i.cpr_id
	AND p.observation_sequence = i.observation_sequence
	AND p.location_result_sequence = i.location_result_sequence
	AND p.result_progress_sequence = i.result_progress_sequence
	INNER JOIN p_Observation o
	ON o.cpr_id = i.cpr_id
	AND o.observation_sequence = i.observation_sequence
WHERE p.treatment_id IS NULL

