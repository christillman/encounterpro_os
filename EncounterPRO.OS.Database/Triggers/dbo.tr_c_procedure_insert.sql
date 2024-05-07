
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_procedure_insert]
Print 'Drop Trigger [dbo].[tr_c_procedure_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_procedure_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_procedure_insert]
GO

-- Create Trigger [dbo].[tr_c_procedure_insert]
Print 'Create Trigger [dbo].[tr_c_procedure_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_procedure_insert ON dbo.c_procedure
FOR INSERT
AS

UPDATE c_procedure
SET owner_id = c_Database_Status.customer_id,
	definition = COALESCE(inserted.definition, inserted.description)
FROM c_procedure
	INNER JOIN inserted
	ON c_procedure.procedure_id = inserted.procedure_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

IF UPDATE(vaccine_id)
	BEGIN
	UPDATE dd
	SET procedure_id = i.procedure_id
	FROM c_Drug_Definition dd
	INNER JOIN c_Vaccine v ON v.drug_id = v.drug_id
	INNER JOIN inserted i ON v.vaccine_id = i.vaccine_id
	WHERE dd.procedure_id IS NULL
	END

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Procedure'
		OR e.object_key <> i.procedure_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Procedure'
	AND e.object_key = i.procedure_id
WHERE e.object_id <> i.id

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type ,
	owner_id)
SELECT p.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = p.procedure_id,
	description = ISNULL(p.description, '<No Description>'),
	object_type = 'Procedure',
	p.owner_id
FROM inserted p
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE p.id = e.object_id
	)

GO

