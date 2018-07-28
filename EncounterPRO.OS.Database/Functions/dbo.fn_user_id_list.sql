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

-- Drop Function [dbo].[fn_user_id_list]
Print 'Drop Function [dbo].[fn_user_id_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_id_list]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_id_list]
GO

-- Create Function [dbo].[fn_user_id_list]
Print 'Create Function [dbo].[fn_user_id_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_user_id_list (
	@ps_user_id varchar(24))

RETURNS @ids TABLE (
	[user_id] [varchar](24) NOT NULL,
	[user_progress_sequence] [int] NULL,
	[progress_user_id] [varchar](24) NULL,
	[progress_date_time] [datetime] NULL,
	[progress_type] [varchar](24) NOT NULL,
	[progress_key] [varchar](40) NOT NULL,
	[progress_value] [varchar](40) NULL,
	[display_key] varchar(40) NULL,
	[owner_id] int NULL,
	[created] [datetime] NULL ,
	[created_by] [varchar](24) NULL
	)

AS

BEGIN


DECLARE @ll_owner_id int,
		@ls_dea_number varchar(18) ,
		@ls_license_number varchar(40) ,
		@ls_certification_number varchar(40) ,
		@ls_upin varchar(24) ,
		@ls_npi varchar(40),
		@ll_customer_id int,
		@ls_actor_class varchar(24),
		@ll_error int,
		@ll_rowcount int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ls_dea_number = dea_number,
		@ls_license_number = license_number,
		@ls_certification_number = certification_number,
		@ls_upin = upin,
		@ls_npi = npi,
		@ll_owner_id = COALESCE(owner_id, @ll_customer_id),
		@ls_actor_class = actor_class
FROM c_User
WHERE user_id = @ps_user_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	-- If we didn't find the user_id then assume the param is an actor class
	SET @ll_owner_id = @ll_customer_id
	SET @ls_actor_class = @ps_user_id
	END

INSERT INTO @ids (
			[user_id]
			,[user_progress_sequence]
			,[progress_user_id]
			,[progress_date_time]
			,[progress_type]
			,[progress_key]
			,[progress_value]
			,[display_key] 
			,[created] 
			,[created_by] )
SELECT		[user_id]
			,[user_progress_sequence]
			,[progress_user_id]
			,[progress_date_time]
			,[progress_type]
			,[progress_key]
			,[progress_value]
			,[progress_key]
			,[created] 
			,[created_by] 
FROM c_User_Progress
WHERE user_id = @ps_user_id
AND progress_type = 'ID'
AND current_flag = 'Y'

INSERT INTO @ids (
			[user_id]
           ,[progress_type]
           ,[progress_key]
           ,[progress_value]
           ,[display_key] 
			,[owner_id] )
SELECT		@ps_user_id
           ,'ID'
           ,CAST(d.domain_item AS varchar(32))
           ,NULL
           ,CAST(d.domain_item AS varchar(32))
			,@ll_owner_id
FROM c_domain d
WHERE d.domain_id = 'User ID'
AND NOT EXISTS (
	SELECT 1
	FROM @ids x
	WHERE x.user_id = @ps_user_id
	AND x.progress_type = 'ID'
	AND x.progress_key = CAST(d.domain_item AS varchar(32))
	)

INSERT INTO @ids (
			[user_id]
           ,[progress_type]
           ,[progress_key]
           ,[progress_value]
           ,[display_key])
SELECT	DISTINCT	@ps_user_id
           ,'ID'
           ,CAST(d.owner_id AS varchar(12)) + '^' + d.code_domain
           ,NULL
           ,d.description
FROM c_Component_Interface i
	INNER JOIN c_XML_Code_Domain d
	ON i.owner_id = d.owner_id
	INNER JOIN c_Domain_Master dm
	ON d.epro_domain = dm.domain_id
WHERE i.subscriber_owner_id = @ll_customer_id
AND i.status = 'OK'
AND d.status = 'OK'
AND dm.epro_object = @ls_actor_class -- The actor class equals the corresponding epro object name
AND d.owner_id <> @ll_customer_id
AND NOT EXISTS (
	SELECT 1
	FROM @ids x
	WHERE x.user_id = @ps_user_id
	AND x.progress_type = 'ID'
	AND x.progress_key = CAST(d.owner_id AS varchar(12)) + '^' + d.code_domain
	)

UPDATE @ids
SET display_key = SUBSTRING(progress_key, CHARINDEX('^', progress_key) + 1, 40),
	owner_id = CAST(LEFT(progress_key, CHARINDEX('^', progress_key) - 1) AS int)
WHERE CHARINDEX('^', progress_key) > 0
AND ISNUMERIC(LEFT(progress_key, CHARINDEX('^', progress_key) - 1)) = 1

UPDATE @ids
SET display_key = progress_key,
	owner_id = @ll_owner_id
WHERE owner_id IS NULL


INSERT INTO @ids (
			[user_id]
		   ,[progress_type]
		   ,[progress_key]
		   ,[progress_value]
		   ,[display_key]
		   ,owner_id )
VALUES (
			@ps_user_id
		   ,'MODIFY'
		   ,'dea_number'
		   ,@ls_dea_number
		   ,'DEA Number'
		   ,@ll_owner_id)

INSERT INTO @ids (
			[user_id]
		   ,[progress_type]
		   ,[progress_key]
		   ,[progress_value]
		   ,[display_key]
		   ,owner_id )
VALUES (
			@ps_user_id
		   ,'MODIFY'
		   ,'license_number'
		   ,@ls_license_number
		   ,'License Number'
		   ,@ll_owner_id)

INSERT INTO @ids (
			[user_id]
		   ,[progress_type]
		   ,[progress_key]
		   ,[progress_value]
		   ,[display_key]
		   ,owner_id )
VALUES (
			@ps_user_id
		   ,'MODIFY'
		   ,'certification_number'
		   ,@ls_certification_number
		   ,'Certification Number'
		   ,@ll_owner_id)


INSERT INTO @ids (
			[user_id]
		   ,[progress_type]
		   ,[progress_key]
		   ,[progress_value]
		   ,[display_key]
		   ,owner_id )
VALUES (
			@ps_user_id
		   ,'MODIFY'
		   ,'upin'
		   ,@ls_upin
		   ,'UPIN'
		   ,@ll_owner_id)

INSERT INTO @ids (
			[user_id]
		   ,[progress_type]
		   ,[progress_key]
		   ,[progress_value]
		   ,[display_key]
		   ,owner_id )
VALUES (
			@ps_user_id
		   ,'MODIFY'
		   ,'npi'
		   ,@ls_npi
		   ,'NPI'
		   ,@ll_owner_id)

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_user_id_list]
	TO [cprsystem]
GO

