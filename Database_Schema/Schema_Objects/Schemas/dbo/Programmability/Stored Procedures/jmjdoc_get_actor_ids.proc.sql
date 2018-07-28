CREATE PROCEDURE jmjdoc_get_actor_ids (
	@ps_user_id Varchar(24),
	@pl_customer_id int = NULL,
	@pl_recipient_owner_id int = NULL
	)
AS

-- If a recipient_owner_id is supplied then return only IDs owned by the customer and the recipient
-- Otherwise return all IDs
IF @pl_customer_id IS NULL
	SELECT @pl_customer_id = customer_id
	FROM c_Database_Status

-- If no recipient is supplied then get all IDs
IF @pl_recipient_owner_id IS NULL
	SELECT display_key as IDDomain,
			progress_value as IDValue,
			owner_id as OwnerID
	FROM dbo.fn_user_id_list(@ps_user_id)
	WHERE progress_value IS NOT NULL
ELSE
	SELECT display_key as IDDomain,
			progress_value as IDValue,
			owner_id as OwnerID
	FROM dbo.fn_user_id_list(@ps_user_id)
	WHERE progress_value IS NOT NULL
	AND owner_id IN (@pl_customer_id, @pl_recipient_owner_id)

