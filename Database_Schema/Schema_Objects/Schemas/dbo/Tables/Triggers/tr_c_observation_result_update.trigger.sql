CREATE TRIGGER tr_c_observation_result_update ON dbo.c_Observation_Result
FOR UPDATE
AS


IF NOT UPDATE(last_updated)
	BEGIN
	UPDATE r
	SET last_updated = getdate()
	FROM c_observation_Result as r
		JOIN inserted as i
			ON r.observation_id = i.observation_id
			AND r.result_sequence = i.result_sequence
	END

UPDATE o
SET last_updated = i.last_updated
FROM c_observation as o
	JOIN inserted as i
		ON o.observation_id = i.observation_id

DELETE FROM u_Exam_Default_Results
FROM inserted
WHERE inserted.observation_id = u_Exam_Default_Results.observation_id
AND inserted.result_sequence = u_Exam_Default_Results.result_sequence
AND inserted.status = 'NA'

UPDATE e
SET object_key = r.observation_id + '|' + CAST(r.result_sequence AS varchar(8)),
	description = r.result
FROM c_Equivalence e
	INNER JOIN inserted r
	ON e.object_id = r.id

