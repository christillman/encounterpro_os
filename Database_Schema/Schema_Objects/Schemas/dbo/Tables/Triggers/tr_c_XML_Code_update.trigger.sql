CREATE TRIGGER tr_c_XML_Code_update ON dbo.c_XML_Code
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @lui_id uniqueidentifier,
		@ls_description varchar(80),
		@ls_from_status varchar(12),
		@ls_to_status varchar(12),
		@ll_owner_id int,
		@ls_code varchar(80),
		@ls_code_domain varchar(40),
		@ls_epro_domain varchar(64),
		@ls_epro_id varchar(64),
		@ls_progress_key varchar(40),
		@ls_current_code varchar(80)

DECLARE lc_updated CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.id,
			description = CAST(i.owner_id AS varchar(12)) + '/' + i.code_domain + '/' + i.code,
			d.status as from_status,
			i.status as to_status,
			i.owner_id ,
			i.code_domain ,
			i.code ,
			i.epro_domain ,
			i.epro_id 
	FROM inserted i
		INNER JOIN deleted d
		ON i.code_id = d.code_id

OPEN lc_updated
FETCH lc_updated INTO @lui_id, 
						@ls_description, 
						@ls_from_status, 
						@ls_to_status,
						@ll_owner_id ,
						@ls_code_domain ,
						@ls_code ,
						@ls_epro_domain ,
						@ls_epro_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ls_from_status <> @ls_to_status
	EXECUTE config_log
		@pui_config_object_id = @lui_id ,
		@ps_config_object_type = 'Code Mapping' ,
		@ps_description = @ls_description ,
		@ps_operation = 'Update' ,
		@ps_property = 'Status' ,
		@ps_from_value = @ls_from_status ,
		@ps_to_value = @ls_to_status

	IF @ls_to_status = 'OK' AND (@ls_epro_domain = 'user_id' OR @ls_epro_domain LIKE '%.user_id')
		BEGIN
		SET @ls_progress_key = CAST(CAST(@ll_owner_id AS varchar(12)) + '^' + @ls_code_domain AS varchar(40))

		-- Look it up so we don't get in an infinite loop
		SET @ls_current_code = dbo.fn_lookup_user_ID(@ls_epro_id, @ll_owner_id, @ls_code_domain)
		IF @ls_current_code IS NULL OR @ls_current_code <> @ls_code
			EXECUTE sp_Set_User_Progress
				@ps_user_id = @ls_epro_id,
				@ps_progress_user_id = '#SYSTEM',
				@ps_progress_type = 'ID',
				@ps_progress_key = @ls_progress_key,
				@ps_progress = @ls_code,
				@ps_created_by = 'SYSTEM'
		END

	FETCH lc_updated INTO @lui_id, 
							@ls_description, 
							@ls_from_status, 
							@ls_to_status,
							@ll_owner_id ,
							@ls_code_domain ,
							@ls_code ,
							@ls_epro_domain ,
							@ls_epro_id
	END

CLOSE lc_updated
DEALLOCATE lc_updated

