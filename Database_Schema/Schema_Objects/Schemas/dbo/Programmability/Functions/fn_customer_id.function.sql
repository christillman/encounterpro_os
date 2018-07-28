
		CREATE FUNCTION fn_customer_id ()
		RETURNS int

		AS
		BEGIN

		DECLARE @ll_customer_id int

		SELECT @ll_customer_id = customer_id
		FROM c_Database_Status


		RETURN @ll_customer_id

		END