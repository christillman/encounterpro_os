CREATE   PROCEDURE sp_patient_search2
(
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_phone_number varchar(40) = NULL,
	@pdt_date_of_birth datetime = NULL,
	@ps_ssn varchar(24) = NULL
)
WITH RECOMPILE
AS

DECLARE @ls_patient_status varchar(24)

IF @ps_billing_id IS NULL
	SET @ps_billing_id = ''

IF @ps_ssn IS NULL
	SET @ps_ssn = ''

IF @ps_last_name IS NULL
	SET @ps_last_name = ''

IF ISNULL( @ps_first_name, '' ) = ''
	SET @ps_first_name = '%'

IF ISNULL( @ps_phone_number, '' ) = ''
	SET @ps_phone_number = '%'

SET @ls_patient_status = '%'



IF @ps_billing_id <> ''
BEGIN
	IF @ps_ssn = ''
		SET @ps_ssn = '%'

	IF @ps_last_name = ''
		SET @ps_last_name = '%'

	SELECT TOP 100
		cpr_id,
		billing_id,
		date_of_birth,
		dbo.fn_pretty_name(last_name ,
							first_name ,
							middle_name ,
							name_suffix ,
							name_prefix ,
							degree ) as patient_name,
		CASE sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		ssn,
		selected_flag = 0
	FROM p_Patient WITH (NOLOCK)
	WHERE	billing_id like @ps_billing_id
	AND	ISNULL(ssn,'') like @ps_ssn
	AND	ISNULL(last_name,'') like @ps_last_name
	AND	ISNULL(first_name,'') like @ps_first_name
	AND	ISNULL(phone_number,'') like @ps_phone_number
	AND	(@pdt_date_of_birth IS NULL OR date_of_birth = @pdt_date_of_birth)
	AND	patient_status like @ls_patient_status
	ORDER BY patient_name, date_of_birth, billing_id, cpr_id
END
ELSE IF @ps_ssn <> ''
BEGIN
	IF @ps_last_name = ''
		SET @ps_last_name = '%'

	SELECT TOP 100
		cpr_id,
		billing_id,
		date_of_birth,
		dbo.fn_pretty_name(last_name ,
							first_name ,
							middle_name ,
							name_suffix ,
							name_prefix ,
							degree ) as patient_name,
		CASE sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		ssn,
		selected_flag = 0
	FROM p_Patient WITH (NOLOCK)
	WHERE
		ssn like @ps_ssn
	AND	ISNULL(last_name, '') like @ps_last_name
	AND	ISNULL(first_name,'') like @ps_first_name
	AND	ISNULL(phone_number,'') like @ps_phone_number
	AND	(@pdt_date_of_birth IS NULL OR date_of_birth = @pdt_date_of_birth)
	AND	patient_status like @ls_patient_status
	ORDER BY patient_name, date_of_birth, billing_id, cpr_id
END
ELSE IF @ps_last_name <> ''
	SELECT TOP 100
		cpr_id,
		billing_id,
		date_of_birth,
		dbo.fn_pretty_name(last_name ,
							first_name ,
							middle_name ,
							name_suffix ,
							name_prefix ,
							degree ) as patient_name,
		CASE sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		ssn,
		selected_flag = 0
	FROM p_Patient WITH (NOLOCK)
	WHERE
		last_name like @ps_last_name
	AND	ISNULL(first_name,'') like @ps_first_name
	AND	ISNULL(phone_number,'') like @ps_phone_number
	AND	(@pdt_date_of_birth IS NULL OR date_of_birth = @pdt_date_of_birth)
	AND	patient_status like @ls_patient_status
	ORDER BY patient_name, date_of_birth, billing_id, cpr_id
ELSE
	SELECT TOP 100
		cpr_id,
		billing_id,
		date_of_birth,
		dbo.fn_pretty_name(last_name ,
							first_name ,
							middle_name ,
							name_suffix ,
							name_prefix ,
							degree ) as patient_name,
		CASE sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		ssn,
		selected_flag = 0
	FROM p_Patient WITH (NOLOCK)
	WHERE
		ISNULL(first_name,'') like @ps_first_name
	AND	ISNULL(phone_number,'') like @ps_phone_number
	AND	(@pdt_date_of_birth IS NULL OR date_of_birth = @pdt_date_of_birth)
	AND	patient_status like @ls_patient_status
	ORDER BY patient_name, date_of_birth, billing_id, cpr_id



