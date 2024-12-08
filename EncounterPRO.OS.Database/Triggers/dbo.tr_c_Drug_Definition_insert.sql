
-- update didn't do anything else, no longer needed
if exists (select * from sys.objects where object_id = object_id('tr_c_Drug_Definition_update') and
	 type = 'TR')
	DROP TRIGGER [dbo].[tr_c_Drug_Definition_update]

-- Drop TRIGGER [dbo].[tr_c_Drug_Definition_insert]
Print 'Drop TRIGGER [dbo].[tr_c_Drug_Definition_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Drug_Definition_insert]') AND ([type]='TR')))
DROP TRIGGER [dbo].[tr_c_Drug_Definition_insert]
GO

-- Create TRIGGER [dbo].[tr_c_Drug_Definition_insert]
Print 'Create TRIGGER [dbo].[tr_c_Drug_Definition_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tr_c_Drug_Definition_insert] ON [dbo].[c_Drug_Definition]
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Drug'
		OR e.object_key <> i.drug_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Drug'
	AND e.object_key = i.drug_id
WHERE e.object_id <> i.id


INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type,
	owner_id )
SELECT d.id,
	NULL,
	dbo.get_client_datetime(),
	'#SYSTEM',
	object_key = d.drug_id,
	description = ISNULL(d.common_name, '<No Description>'),
	object_type = 'Drug',
	d.owner_id
FROM inserted d
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE d.id = e.object_id
	)


GO


