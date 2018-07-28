CREATE FUNCTION dbo.fn_vaccine_cpt (
	@ps_drug_id varchar(12))

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_procedure_id varchar(24),
		@ls_cpt_code varchar(24),
		@ll_error int,
		@ll_rowcount int


SELECT @ls_procedure_id = procedure_id
FROM c_Drug_Definition
WHERE drug_id = @ps_drug_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN @ls_cpt_code

IF @ll_rowcount = 0
	RETURN @ls_cpt_code

SELECT @ls_cpt_code = cpt_code
FROM c_Procedure
where procedure_id = @ls_procedure_id


RETURN @ls_cpt_code

END

