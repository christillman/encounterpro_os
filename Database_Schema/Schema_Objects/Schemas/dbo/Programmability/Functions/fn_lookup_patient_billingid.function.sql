CREATE FUNCTION fn_lookup_patient_billingid (
	@ps_id_domain varchar(40),
	@ps_id varchar(12))

RETURNS varchar(12)

AS
BEGIN

DECLARE @ls_billing_id varchar(12)

IF @ps_id_domain = 'JMJBILLINGID'
	SELECT @ls_billing_id = min(billing_id)
	FROM p_Patient
	WHERE cpr_id = @ps_id
ELSE
	SELECT @ls_billing_id = min(progress_value)
	FROM p_Patient_Progress
	WHERE progress_type = 'ID'
	AND progress_key = @ps_id_domain
	AND cpr_id = @ps_id
	AND current_flag = 'Y'

RETURN @ls_billing_id

END

