CREATE FUNCTION fn_lookup_user (
	@ps_office_id varchar(4),
	@ps_id varchar(24))

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_epro_id varchar(24)

SELECT @ls_epro_id = epro_id
FROM b_Provider_Translation
WHERE office_id = @ps_office_id
AND external_id = @ps_id

RETURN @ls_epro_id

END

