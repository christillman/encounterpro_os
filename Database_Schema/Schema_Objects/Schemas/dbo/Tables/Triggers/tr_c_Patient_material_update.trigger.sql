CREATE TRIGGER tr_c_Patient_material_update ON dbo.c_Patient_material
FOR UPDATE
AS

DELETE FROM u_top_20
FROM inserted
WHERE convert(varchar(40),inserted.material_id) = u_top_20.item_id
AND inserted.status = 'NA'

UPDATE e
SET object_key = CAST(m.material_id AS varchar(64)),
	description = ISNULL(m.title, '<No Description>')
FROM c_Equivalence e
	INNER JOIN inserted m
	ON e.object_id = m.id


