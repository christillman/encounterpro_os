--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_Drug_Definition_update]
Print 'Drop Trigger [dbo].[tr_c_Drug_Definition_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Drug_Definition_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_Drug_Definition_update]
GO

-- Create Trigger [dbo].[tr_c_Drug_Definition_update]
Print 'Create Trigger [dbo].[tr_c_Drug_Definition_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_Drug_Definition_update ON dbo.c_Drug_Definition
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(status)
	UPDATE v
	SET status = i.status
	FROM c_Vaccine v
		INNER JOIN inserted i
		ON v.drug_id = i.drug_id
		INNER JOIN deleted d
		ON i.drug_id = d.drug_id
	WHERE i.drug_type = 'Vaccine'
	AND i.status <> d.status


GO

