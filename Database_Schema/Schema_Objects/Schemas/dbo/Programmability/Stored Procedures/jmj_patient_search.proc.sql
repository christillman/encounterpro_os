CREATE   PROCEDURE jmj_patient_search
(
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_ssn varchar(24) = NULL,
	@pdt_date_of_birth datetime = NULL,
	@ps_phone_number varchar(32) = NULL,
	@ps_employer varchar(40) = NULL,
	@ps_employeeid varchar(24) = NULL,
	@ps_patient_status varchar(24) = NULL,
	@pl_count_only int = 0
)
AS

-- If the @pl_count_only flag is set to a non-zero value, then don't return a result set.  Instead,
-- return a long integer as follows:
--	1	More than zero and less than a thousand rows were found
--	0	No records matching the search criteria were found
--	-1	More than a thousand rows were found

DECLARE @ll_rows int,
		@ll_return int,
		@ls_phone_number_7digit varchar(9) ,
		@ls_area_code_specified char(1)

-- Set every blank criteria to a wildcard
IF ISNULL( @ps_billing_id, '' ) = ''
	SET @ps_billing_id = '%'

IF ISNULL( @ps_ssn, '' ) = ''
	SET @ps_ssn = '%'

IF ISNULL( @ps_last_name, '' ) = ''
	SET @ps_last_name = '%'

IF ISNULL( @ps_first_name, '' ) = ''
	SET @ps_first_name = '%'

SET @ls_area_code_specified = 'N'
IF ISNULL( @ps_phone_number, '' ) = ''
	BEGIN
	SET @ps_phone_number = '%'
	SET @ls_phone_number_7digit = '%'
	END
ELSE
	BEGIN
	SET @ps_phone_number = dbo.fn_pretty_phone(@ps_phone_number)
	IF LEN(@ps_phone_number) >= 14
		BEGIN
		SET @ps_phone_number = LEFT(dbo.fn_pretty_phone(@ps_phone_number), 14) + '%'
		SET @ls_phone_number_7digit = SUBSTRING(@ps_phone_number, 7, 8) + '%'
		SET @ls_area_code_specified = 'Y'
		END
	ELSE IF LEN(@ps_phone_number) >= 8
		BEGIN
		SET @ls_phone_number_7digit = LEFT(@ps_phone_number, 8) + '%'
		SET @ps_phone_number = '%'
		END
	ELSE
		BEGIN
		SET @ls_phone_number_7digit = @ps_phone_number + '%'
		SET @ps_phone_number = '%'
		END
	END

IF ISNULL( @ps_employer, '' ) = ''
	SET @ps_employer = '%'

IF ISNULL( @ps_employeeid, '' ) = ''
	SET @ps_employeeid = '%'

IF ISNULL( @ps_patient_status, '' ) = ''
	SET @ps_patient_status = '%'


DECLARE @patients TABLE (
	[cpr_id] [varchar] (12) NOT NULL ,
	[alias_type] [varchar] (12) NOT NULL ,
	[first_name] [varchar] (20) NULL ,
	[last_name] [varchar] (40) NULL ,
	[middle_name] [varchar] (20) NULL ,
	[name_prefix] [varchar] (12) NULL ,
	[name_suffix] [varchar] (12) NULL ,
	[degree] [varchar] (12) NULL )

SET @ll_rows = 0
SET @ll_return = 0

IF @ps_billing_id <> '%'
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE p.billing_id like @ps_billing_id
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ps_ssn <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE p.ssn like @ps_ssn
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ls_phone_number_7digit <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE p.phone_number_7digit like @ls_phone_number_7digit
	
	SET @ll_rows = @@ROWCOUNT
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ps_phone_number <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE p.phone_number like @ps_phone_number
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ps_employeeid <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE p.employeeid like @ps_employeeid
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ps_last_name <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		cpr_id ,
		alias_type ,
		first_name ,
		last_name ,
		middle_name ,
		name_prefix ,
		name_suffix ,
		degree
	FROM p_Patient_Alias WITH (NOLOCK)
	WHERE last_name like @ps_last_name
	AND current_flag = 'Y'
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @pdt_date_of_birth IS NOT NULL AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree
	FROM p_Patient p WITH (NOLOCK)
	WHERE date_of_birth = @pdt_date_of_birth
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ll_rows > 0
	BEGIN
	IF @pl_count_only = 0
		BEGIN
		SELECT
			p.cpr_id,
			p.billing_id,
			p.date_of_birth,
			x.alias_type,
			CASE x.alias_type WHEN 'Primary' THEN
								ISNULL(p.last_name, '') 
								+ ', ' + ISNULL(p.first_name, '') 
								+ CASE WHEN p.middle_name IS NULL THEN '' ELSE ' ' + p.middle_name END
								+ CASE WHEN p.nickname IS NULL THEN '' ELSE ' (' + p.nickname + ')' END
							ELSE ISNULL(x.last_name, '') 
								+ ', ' + ISNULL(x.first_name, '') 
								+ ' ' + ISNULL(x.middle_name, '')
								+ ' (' + x.alias_type + ')'
							END
				AS patient_name,
			ISNULL(p.last_name, '') 
				+ ', ' + ISNULL(p.first_name, '') 
				+ CASE WHEN p.middle_name IS NULL THEN '' ELSE ' ' + p.middle_name END
				+ CASE WHEN p.nickname IS NULL THEN '' ELSE ' (' + p.nickname + ')' END
				AS primary_name,
			CASE p.sex WHEN 'M' THEN 'M' ELSE 'F' END as sex,
			p.ssn,
			selected_flag = 0,
			u.color
		FROM @patients x
			INNER JOIN p_Patient p WITH (NOLOCK)
			ON x.cpr_id = p.cpr_id
			LEFT OUTER JOIN c_User u
			ON p.primary_provider_id = u.user_id
		WHERE ISNULL(p.billing_id, '') like @ps_billing_id
		AND	ISNULL(x.last_name,'') like @ps_last_name
		AND	ISNULL(x.first_name,'') like @ps_first_name
		AND	ISNULL(p.ssn,'') like @ps_ssn
		AND	(@pdt_date_of_birth IS NULL OR p.date_of_birth = @pdt_date_of_birth)
		AND	ISNULL(p.phone_number,'') like @ps_phone_number
		AND	(@ls_area_code_specified = 'Y' OR ((@ls_area_code_specified = 'N' OR LEN(p.phone_number) <= 8)) AND ISNULL(p.phone_number_7digit,'') like @ls_phone_number_7digit)
		AND	ISNULL(p.employer,'') like @ps_employer
		AND	ISNULL(p.employeeid,'') like @ps_employeeid
		AND	p.patient_status like @ps_patient_status
	
		IF @@ROWCOUNT > 0
			SET @ll_return = 1
		END
	ELSE
		BEGIN
		SELECT @ll_rows = count(*)
		FROM @patients x
			INNER JOIN p_Patient p WITH (NOLOCK)
			ON x.cpr_id = p.cpr_id
			LEFT OUTER JOIN c_User u
			ON p.primary_provider_id = u.user_id
		WHERE ISNULL(p.billing_id, '') like @ps_billing_id
		AND	ISNULL(x.last_name,'') like @ps_last_name
		AND	ISNULL(x.first_name,'') like @ps_first_name
		AND	ISNULL(p.ssn,'') like @ps_ssn
		AND	(@pdt_date_of_birth IS NULL OR p.date_of_birth = @pdt_date_of_birth)
		AND	ISNULL(p.phone_number,'') like @ps_phone_number
		AND	(@ls_area_code_specified = 'Y' OR ((@ls_area_code_specified = 'N' OR LEN(p.phone_number) <= 8)) AND ISNULL(p.phone_number_7digit,'') like @ls_phone_number_7digit)
		AND	ISNULL(p.employer,'') like @ps_employer
		AND	ISNULL(p.employeeid,'') like @ps_employeeid
		AND	p.patient_status like @ps_patient_status
	
		IF @ll_rows > 0
			SET @ll_return = 1
		END
	END

RETURN @ll_return

