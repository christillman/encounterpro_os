CREATE TRIGGER tr_c_observation_tree_delete ON dbo.c_observation_tree
FOR DELETE
AS

DELETE r
FROM u_Exam_Default_Results r
	INNER JOIN deleted d
	ON r.branch_id = d.branch_id


