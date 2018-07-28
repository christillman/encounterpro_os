CREATE FUNCTION fn_config_object_owner (
	@ps_config_object varchar(40),
	@ps_config_object_id varchar(40))

RETURNS int

AS
BEGIN
DECLARE @ll_owner_id int

IF @ps_config_object = 'Report'
	SELECT @ll_owner_id = owner_id
	FROM c_Report_Definition
	WHERE report_id = @ps_config_object_id



RETURN @ll_owner_id

END
