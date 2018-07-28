CREATE FUNCTION fn_domain_item_description (
	@ps_domain_id varchar(24),
	@ps_domain_item varchar(40) )
RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_domain_item_description varchar(80)

SELECT @ls_domain_item_description = max(domain_item_description)
FROM c_Domain
WHERE domain_id = @ps_domain_id
AND domain_item = @ps_domain_item

RETURN @ls_domain_item_description

END


