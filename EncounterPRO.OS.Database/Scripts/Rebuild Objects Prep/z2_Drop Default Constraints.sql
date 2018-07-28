--- Drop All Constraints
DECLARE @ConstraintName varchar(120)
DECLARE @TableName varchar(120)

/* DROP Foreign Key Constraints First*/
DECLARE c_constraint CURSOR LOCAL FAST_FORWARD FOR
	SELECT d.name, o.name
	FROM sys.default_constraints d
	INNER JOIN sys.objects o
	ON d.parent_object_id = o.object_id
	WHERE o.type = 'U'
	ORDER BY o.name, d.name

OPEN c_constraint

FETCH NEXT FROM c_constraint INTO @ConstraintName, @TableName
WHILE (@@fetch_status<>-1)
BEGIN
	EXEC ('ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName)
	FETCH NEXT FROM c_constraint INTO @ConstraintName, @TableName
END

DEALLOCATE c_constraint
GO
