CREATE FUNCTION fn_lookup_user_billingid (
	@ps_office_id varchar(4),
	@ps_id varchar(24))

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_external_id varchar(24)

SELECT @ls_external_id = external_id
FROM b_Provider_Translation
WHERE office_id = @ps_office_id
AND epro_id = @ps_id

RETURN @ls_external_id

END

