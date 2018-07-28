CREATE TRIGGER tr_c_disease_group_delete ON dbo.c_disease_group
FOR DELETE
AS

DELETE c_disease_group_item
WHERE disease_group IN (SELECT disease_group FROM deleted)


