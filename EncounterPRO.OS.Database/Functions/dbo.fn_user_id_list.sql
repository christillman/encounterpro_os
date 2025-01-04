
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
CREATE FUNCTION dbo.fn_user_id_list (
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
		@ls_actor_class varchar(24)

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
WHERE [user_id] = @ps_user_id

IF @@ERROR <> 0
	RETURN

IF @ls_actor_class IS NULL
	BEGIN
	-- If we didn't find the [user_id] then assume the param is an actor class
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
WHERE [user_id] = @ps_user_id
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
GRANT SELECT ON [dbo].[fn_user_id_list] TO [cprsystem]
GO

