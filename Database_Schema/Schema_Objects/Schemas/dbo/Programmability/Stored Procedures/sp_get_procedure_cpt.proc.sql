CREATE PROCEDURE sp_get_procedure_cpt (
	@ps_cpr_id varchar(12),
	@ps_procedure_id varchar(24)
	--, @ps_authority_id varchar(24) OUTPUT,
	--@ps_cpt_code varchar(12) OUTPUT,
	--@ps_modifier varchar(2) OUTPUT,
	--@ps_other_modifiers varchar(12) OUTPUT,
	--@pr_units float OUTPUT,
	--@pdc_charge money OUTPUT
	)
AS


DECLARE @li_authority_sequence smallint
	, @ls_authority_id varchar(24)
	, @ls_cpt_code varchar(12)
	, @ls_modifier varchar(2)
	, @ls_other_modifiers varchar(12)
	, @lr_units float
	, @ldc_charge money
	, @ls_proc_description varchar(80)


SELECT @ls_authority_id = NULL,
	@ls_cpt_code = NULL,
	@ls_modifier = NULL,
	@ls_other_modifiers = NULL,
	@lr_units = NULL,
	@ldc_charge = NULL,
	@ls_proc_description = NULL
	
-- Primary payor has authority_sequence = 1 and authority_type = 'PAYOR'

SELECT @ls_authority_id = i.authority_id,
	@ls_cpt_code = i.cpt_code,
	@ls_modifier = i.modifier,
	@ls_other_modifiers = i.other_modifiers,
	@lr_units = i.units,
	@ldc_charge = i.charge
FROM c_Procedure_Coding i, p_Patient_Authority pi
WHERE pi.cpr_id = @ps_cpr_id
AND pi.authority_sequence = 1
AND pi.authority_type = 'PAYOR'
AND i.procedure_id = @ps_procedure_id
AND pi.authority_id = i.authority_id

IF @@ROWCOUNT = 1
	SELECT @ls_proc_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_procedure_id
ELSE
	SELECT @ls_cpt_code = cpt_code,
		@ls_modifier = modifier,
		@ls_other_modifiers = other_modifiers,
		@lr_units = units,
		@ldc_charge = charge,
		@ls_proc_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_procedure_id

-- Return as a result set
SELECT 
	  @ls_authority_id AS authority_id
	, @ls_cpt_code  AS cpt_code
	, @ls_modifier  AS modifier
	, @ls_other_modifiers  AS other_modifiers
	, @lr_units  AS units
	, @ldc_charge  AS charge
	, @ls_proc_description AS proc_description



