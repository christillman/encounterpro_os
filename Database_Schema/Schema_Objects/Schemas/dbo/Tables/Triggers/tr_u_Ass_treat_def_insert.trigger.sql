CREATE TRIGGER tr_u_Ass_treat_def_insert ON dbo.u_Assessment_treat_definition
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

-- Check for illegal insert
IF EXISTS(	SELECT 1
			FROM inserted i
				INNER JOIN u_Assessment_treat_definition d
				ON i.parent_definition_id = d.definition_id
			WHERE d.treatment_type <> '!COMPOSITE' )
	BEGIN
	ROLLBACK TRANSACTION
	RAISERROR ('Only Composite treatment definitions are allowed to have child treatments',16,-1)
	RETURN
	END

UPDATE d
SET treatment_description = 'No Description'
FROM u_Assessment_treat_definition d
	INNER JOIN inserted i
	ON d.definition_id = i.definition_id
WHERE i.treatment_description IS NULL
OR i.treatment_description = ''

UPDATE d
SET sort_sequence = 0
FROM u_Assessment_treat_definition d
	INNER JOIN inserted i
	ON d.definition_id = i.definition_id
WHERE i.sort_sequence IS NULL

