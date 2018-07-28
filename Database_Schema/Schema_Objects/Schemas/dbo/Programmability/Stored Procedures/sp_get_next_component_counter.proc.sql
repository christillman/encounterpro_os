CREATE PROCEDURE sp_get_next_component_counter
	(
	@ps_component_id varchar(24),
	@ps_attribute varchar(64),
	@pl_next_counter int OUTPUT
	)
AS

DECLARE @ll_attribute_sequence int,
		@ll_counter int

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM c_Component_Attribute
WHERE component_id = @ps_component_id
AND attribute = @ps_attribute

-- If the record doesn't exist then create it
IF @ll_attribute_sequence IS NULL
	BEGIN
	INSERT INTO c_Component_Attribute (
		component_id,
		attribute,
		value)
	VALUES (
		@ps_component_id,
		@ps_attribute,
		'1')
	
	SELECT @ll_attribute_sequence = @@IDENTITY
	END

SELECT @ll_counter = CONVERT(int, CONVERT(varchar(12),value))
FROM c_Component_Attribute (UPDLOCK)
WHERE component_id = @ps_component_id
AND attribute_sequence = @ll_attribute_sequence

IF @ll_counter > 0
	SET @ll_counter = @ll_counter + 1
ELSE
	SET @ll_counter = 1

UPDATE c_Component_Attribute
SET value = CONVERT(varchar(12), @ll_counter)
WHERE component_id = @ps_component_id
AND attribute_sequence = @ll_attribute_sequence

SELECT @pl_next_counter = @ll_counter


