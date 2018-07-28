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




