--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_patient_insert]
Print 'Drop Trigger [dbo].[tr_p_patient_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_patient_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_patient_insert]
GO

-- Create Trigger [dbo].[tr_p_patient_insert]
Print 'Create Trigger [dbo].[tr_p_patient_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_patient_insert ON dbo.p_Patient
FOR INSERT
AS


IF @@ROWCOUNT = 0
	RETURN

DECLARE @ll_count int

IF UPDATE(billing_id)
	BEGIN
	SELECT @ll_count = count(*)
	FROM inserted i
	WHERE EXISTS (
		SELECT 1
		FROM p_Patient p
		WHERE p.billing_id = i.billing_id
		AND p.cpr_id <> i.cpr_id)

	IF @ll_count > 0
		BEGIN
		RAISERROR('ERROR:  Duplicate billing_id.  Insert will be aborted', 16, -1)
		ROLLBACK TRANSACTION
		RETURN
		END
	END

INSERT INTO p_Patient_Progress(
	cpr_id,
	user_id,
	progress_date_time,
	progress_type,
	created,
	created_by)
SELECT cpr_id,
	ISNULL(created_by, '#SYSTEM'),
	ISNULL(created, getdate()),
	'Created',
	ISNULL(created, getdate()),
	ISNULL(created_by, '#SYSTEM')
FROM inserted

UPDATE p
SET primary_provider_id = NULL
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.primary_provider_id = ''

DECLARE @ll_sort_sequence smallint,
		@ll_attachment_location_id int

SELECT @ll_sort_sequence = min(sort_sequence)
FROM c_Attachment_Location

IF @ll_sort_sequence IS NULL
	SELECT @ll_attachment_location_id = min(attachment_location_id)
	FROM c_Attachment_Location
ELSE
	SELECT @ll_attachment_location_id = min(attachment_location_id)
	FROM c_Attachment_Location
	WHERE sort_sequence = @ll_sort_sequence

UPDATE p
SET attachment_location_id = @ll_attachment_location_id
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.attachment_location_id IS NULL

UPDATE p
SET attachment_path = dbo.fn_string_to_identifier(i.cpr_id)
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.attachment_path IS NULL


-- Update Alias Table
INSERT INTO [p_Patient_Alias] (
	[cpr_id] ,
	[alias_type] ,
	[first_name] ,
	[last_name] ,
	[middle_name] ,
	[name_prefix] ,
	[name_suffix] ,
	[degree] ,
	[created] ,
	[created_by] ,
	[id] )
SELECT [cpr_id] ,
	'Primary' ,
	[first_name] ,
	[last_name] ,
	[middle_name] ,
	[name_prefix] ,
	[name_suffix] ,
	[degree] ,
	[created] ,
	COALESCE([created_by], '#SYSTEM') ,
	newid()
FROM inserted
WHERE last_name IS NOT NULL


IF UPDATE(phone_number)
	BEGIN
	UPDATE p
	SET phone_number = dbo.fn_pretty_phone(p.phone_number)
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id

	UPDATE p
	SET phone_number_7digit = RIGHT(p.phone_number, 8)
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id

	END
GO

