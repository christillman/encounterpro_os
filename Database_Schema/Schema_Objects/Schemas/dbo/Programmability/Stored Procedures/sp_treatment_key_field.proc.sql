CREATE PROCEDURE sp_treatment_key_field (
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(64) OUTPUT)
AS

SELECT @ps_treatment_key = dbo.fn_treatment_type_treatment_key(@ps_treatment_type)

