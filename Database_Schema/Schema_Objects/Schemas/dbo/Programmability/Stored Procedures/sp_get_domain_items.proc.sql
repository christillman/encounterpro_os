CREATE PROCEDURE sp_get_domain_items (
	@ps_domain_id varchar(24) )
AS
SELECT	domain_sequence,
	domain_item,
	domain_item_description = COALESCE(domain_item_description, domain_item),
	domain_item_bitmap,
	selected_flag = 0
FROM c_Domain (NOLOCK)
WHERE domain_id = @ps_domain_id
ORDER BY domain_sequence

