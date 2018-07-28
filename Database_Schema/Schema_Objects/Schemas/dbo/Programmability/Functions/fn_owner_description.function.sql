CREATE FUNCTION fn_owner_description (
	@pl_owner_id int )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_description varchar(80)

IF @pl_owner_id = 0
	SET @ls_description = 'EncounterPRO'
ELSE IF @pl_owner_id = (SELECT customer_id FROM c_Database_Status)
		BEGIN
		SELECT @ls_description = max(user_full_name)
		FROM c_User
		WHERE owner_id = @pl_owner_id
		AND actor_class = 'Organization'

		IF @ls_description IS NULL
			SELECT @ls_description = description
			FROM c_Office o
				INNER JOIN (SELECT min(office_number) as office_number
							FROM c_Office) x
				ON o.office_number = x.office_number

		END

IF @ls_description IS NULL
	SELECT @ls_description = owner
	FROM c_owner
	WHERE owner_id = @pl_owner_id

IF @ls_description IS NULL
	SELECT @ls_description = i.description
	FROM c_Component_Interface i
		INNER JOIN c_Database_Status s
		ON i.subscriber_owner_id = s.customer_id
	WHERE i.interfaceserviceid = @pl_owner_id

IF @ls_description IS NULL
	SET @ls_description = 'Owner ' + CAST(@pl_owner_id AS varchar(10))



RETURN @ls_description 

END

