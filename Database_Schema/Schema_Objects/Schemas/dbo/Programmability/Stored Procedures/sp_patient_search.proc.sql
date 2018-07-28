CREATE   PROCEDURE sp_patient_search
(
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_employer varchar(40) = NULL,
	@ps_employeeid varchar(24) = NULL,
	@ps_ssn varchar(24) = NULL,
	@ps_patient_status varchar(24) = NULL
)
WITH RECOMPILE
AS

IF ISNULL( @ps_billing_id, '' ) = ''
	SET @ps_billing_id = '%'

IF ISNULL( @ps_ssn, '' ) = ''
	SET @ps_ssn = '%'

IF ISNULL( @ps_last_name, '' ) = ''
	SET @ps_last_name = '%'

IF ISNULL( @ps_first_name, '' ) = ''
	SET @ps_first_name = '%'

IF ISNULL( @ps_employer, '' ) = ''
	SET @ps_employer = '%'

IF ISNULL( @ps_employeeid, '' ) = ''
	SET @ps_employeeid = '%'

IF ISNULL( @ps_patient_status, '' ) = ''
	SET @ps_patient_status = '%'



IF @ps_billing_id <> '%'
BEGIN
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE	p.billing_id like @ps_billing_id
	AND	ISNULL(p.ssn,'') like @ps_ssn
	AND	ISNULL(p.last_name,'') like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
END
ELSE IF @ps_ssn <> '%'
BEGIN
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE p.ssn like @ps_ssn
	AND	ISNULL(p.last_name, '') like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
END
ELSE IF @ps_last_name <> '%'
	SELECT
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		INNER JOIN (SELECT TOP 100 cpr_id FROM p_Patient WITH (NOLOCK) WHERE last_name like @ps_last_name AND first_name like @ps_first_name ORDER BY last_name) x
		ON p.cpr_id = x.cpr_id
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE p.last_name like @ps_last_name
	AND	ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
ELSE
	SELECT TOP 100
		p.cpr_id,
		p.billing_id,
		p.date_of_birth,
		dbo.fn_pretty_name(p.last_name ,
							p.first_name ,
							p.middle_name ,
							p.name_suffix ,
							p.name_prefix ,
							p.degree ) as patient_name,
		CASE p.sex WHEN 'M' THEN 'Male' ELSE 'Female' END as sex,
		p.ssn,
		selected_flag = 0,
		u.color
	FROM p_Patient p WITH (NOLOCK)
		LEFT OUTER JOIN c_User u
		ON p.primary_provider_id = u.user_id
	WHERE ISNULL(p.first_name,'') like @ps_first_name
	AND	ISNULL(p.employer,'') like @ps_employer
	AND	ISNULL(p.employeeid,'') like @ps_employeeid
	AND	p.patient_status like @ps_patient_status
