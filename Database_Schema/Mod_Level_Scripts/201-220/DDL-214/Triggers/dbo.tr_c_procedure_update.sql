
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_procedure_update]
Print 'Drop Trigger [dbo].[tr_c_procedure_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_procedure_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_procedure_update]
GO

-- Create Trigger [dbo].[tr_c_procedure_update]
Print 'Create Trigger [dbo].[tr_c_procedure_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_procedure_update ON dbo.c_procedure
FOR UPDATE
AS


IF UPDATE(vaccine_id)
	BEGIN
	UPDATE dd
	SET procedure_id = i.procedure_id
	FROM c_Drug_Definition dd
	INNER JOIN c_Vaccine v ON v.drug_id = v.drug_id
	INNER JOIN inserted i ON v.vaccine_id = i.vaccine_id
	WHERE dd.procedure_id IS NULL
	END

UPDATE e
SET object_key = p.procedure_id,
	description = ISNULL(p.description, '<No Description>')
FROM c_Equivalence e
	INNER JOIN inserted p
	ON e.object_id = p.id


GO

