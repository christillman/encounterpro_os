CREATE PROCEDURE jmj_config_object_library_search (
	@ps_config_object_type varchar (24) ,
	@ps_context_object varchar(24) = NULL,
	@ps_description varchar(40) = NULL,
	@ps_category varchar(24) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_include_local char(1) = 'Y',
	@ps_include_library char(1) = 'Y',
	@ps_min_release_status varchar(12) = 'Production')
AS

DECLARE @ls_local_or_library varchar(12)

IF @ps_include_local = 'Y'
	SET @ls_local_or_library = 'Local'
ELSE
	SET @ls_local_or_library = 'Library'

EXECUTE jmj_config_object_search
	@ps_config_object_type = @ps_config_object_type ,
	@ps_context_object = @ps_context_object ,
	@ps_description = @ps_description ,
	@ps_category = @ps_category ,
	@ps_status = @ps_status ,
	@ps_local_or_library = @ls_local_or_library ,
	@ps_min_release_status = @ps_min_release_status

