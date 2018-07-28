CREATE FUNCTION fn_patient_object_property (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(50),
	@pl_object_key int,
	@ps_progress_key varchar(40) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_property varchar(255),
		@ls_foreign_key varchar(40)

SET @ls_property = dbo.fn_patient_object_progress_value(@ps_cpr_id, @ps_context_object, 'PROPERTY', @pl_object_key, @ps_progress_key)

SELECT @ls_foreign_key = foreign_key
FROM c_Property
WHERE property_object = @ps_context_object
AND function_name = @ps_progress_key
AND status = 'OK'

IF @@ROWCOUNT = 1 AND @ls_foreign_key IS NOT NULL
	SET @ls_property = dbo.fn_attribute_description(@ls_foreign_key, @ls_property)

RETURN @ls_property 

END
