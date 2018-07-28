CREATE FUNCTION fn_lookup_patient2 (
	@pl_owner_id int,
	@ps_IDDomain varchar(40),
	@ps_IDValue varchar(255)
	)

RETURNS varchar(12)

AS
BEGIN

DECLARE @ls_cpr_id varchar(12),
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

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain


-- Check for hard-coded id_domains
IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_cpr_id', 'cpr_id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE cpr_id = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('JMJBILLINGID', 'jmj_billing_id', 'billing_id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE billing_id = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_guid', 'id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE CAST(id AS varchar(40)) = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_treatment_id', 'treatment_id') AND ISNUMERIC(@ps_IDValue) = 1
	BEGIN
	SET @ll_treatment_id = CAST(@ps_IDValue AS int)

	SELECT @ls_cpr_id = cpr_id
	FROM p_Treatment_Item
	WHERE treatment_id = @ll_treatment_id
	END
ELSE
	SELECT @ls_cpr_id = min(cpr_id)
	FROM p_Patient_Progress
	WHERE progress_type = 'ID'
	AND progress_key = @ls_progress_key
	AND progress_value = @ps_IDValue
	AND current_flag = 'Y'

RETURN @ls_cpr_id

END

