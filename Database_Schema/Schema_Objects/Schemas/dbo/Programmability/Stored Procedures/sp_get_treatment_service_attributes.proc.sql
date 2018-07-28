CREATE PROCEDURE dbo.sp_get_treatment_service_attributes (
	@ps_treatment_type varchar(24),
	@pl_service_sequence int)
AS

SELECT attribute,value
FROM c_treatment_type_service_attribute
WHERE treatment_type = @ps_treatment_type
AND service_sequence = @pl_service_sequence


