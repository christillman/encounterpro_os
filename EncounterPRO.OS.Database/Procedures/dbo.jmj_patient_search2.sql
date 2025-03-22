

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_patient_search2]
Print 'Drop Procedure [dbo].[jmj_patient_search2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_search2]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_search2]
GO
/*
 exec [jmj_patient_search2] '981^2',
	@ps_billing_id = NULL,
	@ps_last_name = 'A%',
	@ps_first_name = NULL,
	@ps_ssn = NULL,
	@pdt_date_of_birth = NULL,
	@ps_phone_number = NULL,
	@ps_employer = NULL,
	@ps_employeeid = NULL,
	@ps_patient_status = NULL,
	@ps_id_document = NULL,
	@ps_country = 'Uganda',
	@ps_document_number = NULL,
	@pl_count_only = 0 
	*/

-- Create Procedure [dbo].[jmj_patient_search2]
Print 'Create Procedure [dbo].[jmj_patient_search2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE jmj_patient_search2
(
	@ps_user_id varchar(24) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_ssn varchar(24) = NULL,
	@pdt_date_of_birth datetime = NULL,
	@ps_phone_number varchar(32) = NULL,
	@ps_employer varchar(40) = NULL,
	@ps_employeeid varchar(24) = NULL,
	@ps_patient_status varchar(24) = NULL,
	@ps_id_document varchar(24) = NULL,
	@ps_country varchar(24) = NULL,
	@ps_document_number varchar(24) = NULL,
	@pl_count_only int = 0
)
AS

-- If the @pl_count_only flag is set to a non-zero value, then don't return a result set.  Instead,
-- return a long integer as follows:
--	1	More than zero and less than 2 thousand rows were found
--	0	No records matching the search criteria were found
--	-1	More than 2 thousand rows were found
/* test code
declare @ps_user_id varchar(24) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = 'A%',
	@ps_first_name varchar(20) = NULL,
	@ps_ssn varchar(24) = NULL,
	@pdt_date_of_birth datetime = NULL,
	@ps_phone_number varchar(32) = NULL,
	@ps_employer varchar(40) = NULL,
	@ps_employeeid varchar(24) = NULL,
	@ps_patient_status varchar(24) = NULL,
	@ps_id_document varchar(24) = NULL,
	@ps_country varchar(24) = 'Rwanda',
	@ps_document_number varchar(24) = NULL,
	@pl_count_only int = 0
	*/

DECLARE @ll_rows int,
		@ll_return int,
		@ls_phone_number_7digit varchar(9) ,
		@ls_area_code_specified char(1) ,
		@ls_patient_name_format_list varchar(80)

DECLARE @offices TABLE (
	office_id varchar(4) NOT NULL)

INSERT INTO @offices (
	office_id)
SELECT office_id
FROM dbo.fn_user_privilege_offices(@ps_user_id, 'View Patients')

SET @ls_patient_name_format_list = dbo.fn_get_preference('PREFERENCES', 'Patient Name Format List', @ps_user_id, NULL)
IF @ls_patient_name_format_list IS NULL
	SET @ls_patient_name_format_list = '{Last},{ First}{ M.}{ (Nickname)}{, Suffix}'

-- Set every blank criteria to a wildcard
IF ISNULL( @ps_billing_id, '' ) = ''
	SET @ps_billing_id = '%'

IF ISNULL( @ps_ssn, '' ) = ''
	SET @ps_ssn = '%'

IF ISNULL( @ps_document_number, '' ) = ''
	SET @ps_document_number = '%'

IF ISNULL( @ps_country, '' ) = '' OR @ps_country = 'Issuing Country' OR @ps_country = '<<Blank>>'
	SET @ps_country = '%'

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
	[degree] [varchar] (12) NULL ,
	[office_id] [varchar] (4) NULL )

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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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

IF @ps_document_number <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
	FROM p_Patient p WITH (NOLOCK)
	JOIN p_Patient_List_Item li ON p.cpr_id = li.cpr_id
	WHERE li.list_id = 'ID Document'
	AND li.list_item = @ps_id_document
	AND li.list_item_patient_data like @ps_document_number
	
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		a.cpr_id ,
		a.alias_type ,
		a.first_name ,
		a.last_name ,
		a.middle_name ,
		a.name_prefix ,
		a.name_suffix ,
		a.degree ,
		p.office_id
	FROM p_Patient_Alias a WITH (NOLOCK)
		INNER JOIN p_Patient p
		ON a.cpr_id = p.cpr_id
	WHERE a.last_name like @ps_last_name
	AND a.current_flag = 'Y'
	
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
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
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

IF @ps_first_name <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree],
		[office_id] )
	SELECT TOP 2000
		a.cpr_id ,
		a.alias_type ,
		a.first_name ,
		a.last_name ,
		a.middle_name ,
		a.name_prefix ,
		a.name_suffix ,
		a.degree ,
		p.office_id
	FROM p_Patient_Alias a WITH (NOLOCK)
		INNER JOIN p_Patient p
		ON a.cpr_id = p.cpr_id
	WHERE a.first_name like @ps_first_name
	AND a.current_flag = 'Y'
	
	SET @ll_rows = @@ROWCOUNT
	
	IF @ll_rows = 2000
		BEGIN
		DELETE FROM @patients
		SET @ll_rows = 0
		SET @ll_return = -1
		END
END

IF @ps_country <> '%' AND @ll_rows = 0
BEGIN
	INSERT INTO @patients (
		[cpr_id] ,
		[alias_type] ,
		[first_name] ,
		[last_name] ,
		[middle_name] ,
		[name_prefix] ,
		[name_suffix] ,
		[degree],
		[office_id] )
	SELECT TOP 2000
		p.cpr_id ,
		'Primary' ,
		p.first_name ,
		p.last_name ,
		p.middle_name ,
		p.name_prefix ,
		p.name_suffix ,
		p.degree ,
		p.office_id
	FROM p_Patient p WITH (NOLOCK)
	JOIN p_Patient_List_Item li ON p.cpr_id = li.cpr_id
	WHERE li.list_id = 'Country'
	AND li.list_item = @ps_country

	SET @ll_rows = @@ROWCOUNT

END
	
IF @ps_country <> '%' AND @ll_rows > 0
BEGIN
	DELETE p 
	FROM @patients p
	JOIN p_Patient_List_Item li ON p.cpr_id = li.cpr_id
	WHERE li.list_id = 'Country'
	AND li.list_item != @ps_country
END

IF @ll_rows = 2000
BEGIN
	DELETE FROM @patients
	SET @ll_rows = 0
	SET @ll_return = -1
END

DELETE x
FROM @patients x
WHERE office_id IS NOT NULL
AND office_id NOT IN (SELECT office_id FROM @offices)

SELECT @ll_rows = count(*) FROM @patients

IF @ll_rows > 0
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

	IF @pl_count_only = 0
		BEGIN
		SELECT
			p.cpr_id,
			p.billing_id,
			p.date_of_birth,
			x.alias_type,
			CASE x.alias_type WHEN 'Primary' THEN
					dbo.fn_pretty_name_formatted(p.first_name, p.middle_name, p.last_name, p.nickname, p.name_suffix, p.name_prefix, p.degree, @ls_patient_name_format_list)
				ELSE
					dbo.fn_pretty_name_formatted(x.first_name, x.middle_name, x.last_name, NULL, NULL, NULL, NULL, @ls_patient_name_format_list)
					+ ' (' + x.alias_type + ')'
				END AS patient_name,
			dbo.fn_pretty_name_formatted(p.first_name, p.middle_name, p.last_name, p.nickname, p.name_suffix, p.name_prefix, p.degree, @ls_patient_name_format_list) as primary_name,
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
		END
	END

RETURN @ll_return

GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_search2]
	TO [cprsystem]
GO

