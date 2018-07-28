CREATE PROCEDURE [dbo].[jmj_upload_module] (
	@ps_module_type [varchar] (24) ,
	@ps_context_object [varchar] (24) ,
	@ps_object_id [varchar] (36) ,
	@ps_module_data [text] ,
	@ps_user_id [varchar] (24) )
AS

DECLARE @lui_module_id uniqueidentifier ,
		@ls_module_name [varchar] (80) ,
		@ll_module_owner_id [int] ,
		@ls_module_category [varchar] (24) ,
		@ll_version [int] ,
		@ll_min_build [int] ,
		@ll_last_version [int] ,
		@ll_current_owner_id [int] ,
		@ll_last_owner_id [int] ,
		@ls_long_description [varchar] (8000)

SELECT @ll_module_owner_id = customer_id
FROM c_Database_Status


IF @ps_module_type = 'Report'
	BEGIN
	SET @lui_module_id = CAST(@ps_object_id AS uniqueidentifier)
	
	SELECT @ls_module_name = CAST(description AS varchar(80)),
			@ls_module_category = report_category,
			@ll_version = version ,
			@ll_current_owner_id = owner_id ,
			@ls_long_description = CAST(long_description AS varchar(8000))
	FROM c_Report_Definition
	WHERE report_id = @ps_object_id
	
	SET @ll_min_build = 40000
	END

IF @ll_module_owner_id <> @ll_current_owner_id
	BEGIN
	RAISERROR ('Cannot export module that is not locally owned.  Make a copy of the module and export the copy.',16,-1)
	RETURN
	END


SELECT @ll_last_version = MAX(version),
		@ll_last_owner_id = MAX(module_owner_id)
FROM jmjtech.eproupdates.dbo.m_Module_Library
WHERE module_id = @lui_module_id

IF @ll_module_owner_id <> @ll_last_owner_id
	BEGIN
	RAISERROR ('A version of this module has already been uploaded by another owner.  Make a copy of the module and export the copy.',16,-1)
	RETURN
	END


IF @ll_version IS NULL
	BEGIN
	IF @ll_last_version IS NULL
		SET @ll_version = 1
	ELSE
		SET @ll_version = @ll_last_version + 1
	END

UPDATE jmjtech.eproupdates.dbo.m_Module_Library
SET status = 'NA'
WHERE module_id = @lui_module_id
AND version = @ll_version

INSERT INTO jmjtech.eproupdates.dbo.m_Module_Library (
	[module_id] ,
	[module_type] ,
	[context_object] ,
	[module_name] ,
	[module_owner_id] ,
	[version] ,
	[min_build] ,
	[module_data] ,
	[module_category] ,
	[created_by],
	[long_description])
VALUES (
	@lui_module_id ,
	@ps_module_type ,
	@ps_context_object ,
	@ls_module_name ,
	@ll_module_owner_id ,
	@ll_version ,
	@ll_min_build ,
	@ps_module_data ,
	@ls_module_category ,
	CAST(@ll_module_owner_id AS varchar(12)) + '/' + @ps_user_id,
	@ls_long_description	)




