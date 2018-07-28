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

-- Drop Trigger [dbo].[tr_c_XML_Code_insert]
Print 'Drop Trigger [dbo].[tr_c_XML_Code_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_XML_Code_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_XML_Code_insert]
GO

-- Create Trigger [dbo].[tr_c_XML_Code_insert]
Print 'Create Trigger [dbo].[tr_c_XML_Code_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_XML_Code_insert ON dbo.c_XML_Code
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ll_owner_id int,
		@ls_code varchar(80),
		@ls_code_domain varchar(40),
		@ls_epro_domain varchar(64),
		@ls_epro_id varchar(64),
		@ls_progress_key varchar(40),
		@ls_status varchar(12)

----------------------------------------------------------
-- Make sure the domain and domain item tables are current
----------------------------------------------------------
INSERT INTO [dbo].[c_XML_Code_Domain]
           ([owner_id]
           ,[code_domain]
           ,[description]
           ,[created_by])
SELECT DISTINCT [owner_id]
           ,[code_domain]
           ,[code_domain]
			,'#SYSTEM'
FROM inserted c
WHERE NOT EXISTS (
	SELECT 1
	FROM [dbo].[c_XML_Code_Domain] d
	WHERE c.owner_id = d.owner_id
	AND c.code_domain = d.code_domain
	)

UPDATE d
SET epro_domain = c.epro_domain
FROM c_XML_Code_Domain d
	INNER JOIN inserted c
	ON c.owner_id = d.owner_id
	AND c.code_domain = d.code_domain
WHERE d.epro_domain IS NULL
AND c.epro_domain IS NOT NULL

INSERT INTO [dbo].[c_XML_Code_Domain_Item]
           ([owner_id]
           ,[code_domain]
           ,[code_version]
           ,[code]
           ,[code_description]
           ,[created_by]
           ,[code_domain_item_owner_id])
SELECT DISTINCT [owner_id]
           ,[code_domain]
           ,[code_version]
           ,[code]
           ,[code_description]
			,'#SYSTEM'
			,mapping_owner_id
FROM inserted c
WHERE code IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM [dbo].[c_XML_Code_Domain_Item] x
	WHERE c.owner_id = x.owner_id
	AND c.code_domain = x.code_domain
	AND c.code = x.code
	)


DECLARE lc_updated CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.owner_id ,
			i.code_domain ,
			i.code ,
			i.epro_domain ,
			i.epro_id ,
			i.status
	FROM inserted i
		INNER JOIN deleted d
		ON i.code_id = d.code_id

OPEN lc_updated
FETCH lc_updated INTO @ll_owner_id ,
						@ls_code_domain ,
						@ls_code ,
						@ls_epro_domain ,
						@ls_epro_id,
						@ls_status

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ls_epro_domain = 'user_id' OR @ls_epro_domain LIKE '%.user_id'
		BEGIN
		SET @ls_progress_key = CAST(CAST(@ll_owner_id AS varchar(12)) + '^' + @ls_code_domain AS varchar(40))
		EXECUTE sp_Set_User_Progress
			@ps_user_id = @ls_epro_id,
			@ps_progress_user_id = '#SYSTEM',
			@ps_progress_type = 'ID',
			@ps_progress_key = @ls_progress_key,
			@ps_progress = @ls_code,
			@ps_created_by = 'SYSTEM'
		END

	FETCH lc_updated INTO @ll_owner_id ,
							@ls_code_domain ,
							@ls_code ,
							@ls_epro_domain ,
							@ls_epro_id,
							@ls_status
	END

CLOSE lc_updated
DEALLOCATE lc_updated




GO

