CREATE FUNCTION fn_equivalent_objects (
	@ps_object_type varchar(24),
	@ps_object_key varchar(64))

RETURNS @equivalent_objects TABLE (
	object_id uniqueidentifier NOT NULL,
	object_key varchar(64) NOT NULL,
	description varchar(80) NOT NULL
	)
AS

BEGIN

DECLARE @ll_equivalence_group_id int

-- See if we have an equivalence group for this object
SELECT @ll_equivalence_group_id = equivalence_group_id
FROM c_Equivalence
WHERE object_type = @ps_object_type
AND object_key = @ps_object_key

IF @ll_equivalence_group_id > 0 
	INSERT INTO @equivalent_objects (
		object_id ,
		object_key ,
		description )
	SELECT object_id,
			object_key,
			description
	FROM c_Equivalence
	WHERE equivalence_group_id = @ll_equivalence_group_id
ELSE
	INSERT INTO @equivalent_objects (
		object_id ,
		object_key ,
		description )
	SELECT object_id,
			object_key,
			description
	FROM c_Equivalence e
	WHERE object_type = @ps_object_type
	AND object_key = @ps_object_key



RETURN
END

