CREATE FUNCTION dbo.fn_lookup_patient_ID (
	@ps_cpr_id varchar(12),
	@pl_ID_owner_id int,
	@ps_IDDomain varchar(40)
	)

RETURNS varchar(255)

AS
BEGIN

DECLARE @ls_IDValue varchar(255),
		@ll_treatment_id int,
		@ll_length int,
		@ls_progress_value varchar(40),
		@ls_progress_key varchar(40),
		@ll_customer_id int,
		@ls_current_value varchar(255),
		@ll_rowcount int,
		@ll_error int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_ID_owner_id IS NULL
	SET @pl_ID_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_ID_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_ID_owner_id AS varchar(9)) + '^' + @ps_IDDomain


-- Check for hard-coded id_domains
IF @pl_ID_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_cpr_id', 'cpr_id')
	SET @ls_IDValue = @ps_cpr_id
ELSE IF @pl_ID_owner_id = @ll_customer_id AND @ps_IDDomain IN ('JMJBILLINGID', 'jmj_billing_id', 'billing_id')
	SELECT @ls_IDValue = billing_id
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id
ELSE IF @pl_ID_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_guid', 'id')
	SELECT @ls_IDValue = CAST(id AS varchar(40))
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id
ELSE IF @pl_ID_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_treatment_id', 'treatment_id') AND ISNUMERIC(@ps_IDDomain) = 1
	SET @ls_IDValue = NULL
ELSE
	SELECT @ls_IDValue = COALESCE(progress_value, CAST(progress AS varchar(255)))
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = @ls_progress_key
	AND current_flag = 'Y'

RETURN @ls_IDValue

END

