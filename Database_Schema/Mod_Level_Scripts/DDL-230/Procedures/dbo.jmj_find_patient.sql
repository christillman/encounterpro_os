
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_find_patient]
Print 'Drop Procedure [dbo].[jmj_find_patient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_find_patient]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_find_patient]
GO

-- Create Procedure [dbo].[jmj_find_patient]
Print 'Create Procedure [dbo].[jmj_find_patient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_find_patient (
	@ps_billing_id varchar(24) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(20) = NULL,
	@ps_middle_name varchar(20) = NULL,
	@ps_sex char(1) = NULL,
	@pdt_date_of_birth datetime = NULL,
	@ps_ssn varchar(24) = NULL,
	@ps_phone_number varchar(32) = NULL,
	@ps_address_line_1 varchar (40) = NULL,
	@ps_address_line_2 varchar (40) = NULL,
	@ps_state varchar (2) = NULL,
	@ps_zip varchar (10) = NULL,
	@ps_email_address varchar (40) = NULL,
	@ps_city varchar (40) = NULL,
	@ps_find_multiple char(1) = 'N',
	@ps_return_all_candidates char(1) = 'N'
	)


AS

DECLARE @search_properties TABLE (
	property_name varchar(64) NOT NULL,
	property_value varchar(255) NOT NULL
	)

DECLARE @property_weights TABLE (
	[property_name] varchar(64) NOT NULL,
	[corroboration] [int] NULL,
	[anti_corroboration] [int] NULL
	)

DECLARE @patient_properties TABLE (
	[cpr_id] [varchar] (12) NOT NULL ,
	[property_name] [varchar] (64) NOT NULL ,
	[property_value] [varchar] (255) NOT NULL ,
	[corroboration] [int] NOT NULL DEFAULT (0),
	[anti_corroboration] [int] NOT NULL DEFAULT (0)
	)

DECLARE @patient_weights TABLE (
	[cpr_id] [varchar] (12) NOT NULL ,
	[find_score] [int] NULL
	)

-- We need to make this a #-style temp table because the dynamic INSERT statement won't work with a declared temp table
--		INSERT INTO #found_patients (cpr_id)
--		EXECUTE (@ls_sql)
CREATE TABLE #found_patients (
		cpr_id varchar(12))

DECLARE @ls_condition varchar(2000),
		@ls_sql varchar(2000),
		@ll_count int,
		@ll_match_threshold int,
		@ll_anti_match_threshold int,
		@ls_date_of_birth varchar(32),
		@ll_match_count int

INSERT INTO @property_weights (
	[property_name] ,
	[corroboration] ,
	[anti_corroboration] )
SELECT domain_item,
	CASE WHEN ISNUMERIC(domain_item_description) = 1THEN CAST(domain_item_description AS int) ELSE 0 END,
	CASE WHEN ISNUMERIC(domain_item_bitmap) = 1THEN CAST(domain_item_bitmap AS int) ELSE 0 END
FROM c_Domain
WHERE domain_id = 'PatientFindPropWeight'

SELECT @ll_match_threshold = corroboration,
		@ll_anti_match_threshold = anti_corroboration
FROM @property_weights
WHERE property_name = 'match_threshold'

DELETE FROM @property_weights
WHERE property_name = 'match_threshold'

---------------------------------------------------------------------------------
-- Check to see if any of the params is empty string then set them null
---------------------------------------------------------------------------------
IF @ps_billing_id IS NOT NULL AND @ps_billing_id = ''
	SET @ps_billing_id = NULL

IF	@ps_last_name IS NOT NULL AND @ps_last_name = ''
	SET @ps_last_name = NULL

IF	@ps_first_name IS NOT NULL AND @ps_first_name = ''
	SET @ps_first_name = NULL

IF	@ps_middle_name IS NOT NULL AND @ps_middle_name = ''
	SET @ps_middle_name = NULL

IF	@ps_sex IS NOT NULL AND @ps_sex = ''
	SET @ps_sex = NULL

IF	@pdt_date_of_birth IS NULL OR @pdt_date_of_birth = CAST('' as datetime)
	SET @ls_date_of_birth = NULL
ELSE
	SET @ls_date_of_birth = CONVERT(varchar(10), @pdt_date_of_birth, 101)

IF LEN(@ps_ssn) > 0
	SET @ps_ssn = LTRIM(RTRIM(REPLACE(@ps_ssn, '-', '')))
ELSE
	SET @ps_ssn = NULL

IF	LEN(@ps_phone_number) > 0
	SET @ps_phone_number = dbo.fn_pretty_phone(@ps_phone_number)
ELSE
	SET @ps_phone_number = NULL

IF	@ps_address_line_1 IS NOT NULL AND @ps_address_line_1 = ''
	SET @ps_address_line_1 = NULL

IF	@ps_address_line_2 IS NOT NULL AND @ps_address_line_2 = ''
	SET @ps_address_line_2 = NULL

IF	@ps_state IS NOT NULL AND @ps_state = ''
	SET @ps_state = NULL

IF	@ps_zip IS NOT NULL AND @ps_zip = ''
	SET @ps_zip = NULL

IF	@ps_email_address IS NOT NULL AND @ps_email_address = ''
	SET @ps_email_address = NULL

IF	@ps_city IS NOT NULL AND @ps_city = ''
	SET @ps_city = NULL



IF @ps_billing_id IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'billing_id',
		@ps_billing_id)

IF @ps_last_name IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'last_name',
		@ps_last_name)

IF @ps_first_name IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'first_name',
		@ps_first_name)

IF @ps_middle_name IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'middle_name',
		@ps_middle_name)

IF @ps_billing_id IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'billing_id',
		@ps_billing_id)

IF @ps_sex IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'sex',
		@ps_sex)

IF @ls_date_of_birth IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'date_of_birth',
		@ls_date_of_birth)

IF @ps_ssn IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'ssn',
		@ps_ssn)

IF @ps_phone_number IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'phone_number',
		@ps_phone_number)

IF @ps_address_line_1 IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'address_line_1',
		@ps_address_line_1)

IF @ps_address_line_2 IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'address_line_2',
		@ps_address_line_2)

IF @ps_state IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'state',
		@ps_state)

IF @ps_zip IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'zip',
		@ps_zip)

IF @ps_email_address IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'email_address',
		@ps_email_address)

IF @ps_city IS NOT NULL
	INSERT INTO @search_properties (
		property_name,
		property_value)
	VALUES (
		'city',
		@ps_city)


---------------------------------------------------------------------------------
-- Get the candidates from the data elements that are reasonably selective
---------------------------------------------------------------------------------
IF LEN(@ps_billing_id) > 0
	BEGIN
	SET @ls_sql = 'billing_id = ''' + REPLACE(@ps_billing_id, '''', '''''') + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END

IF LEN(@ps_last_name) > 0 AND LEN(@ps_first_name) > 0
	BEGIN
	SET @ls_sql = 'last_name = ''' + REPLACE(@ps_last_name, '''', '''''') + ''''
	SET @ls_sql = @ls_sql + ' AND first_name = ''' + REPLACE(@ps_first_name, '''', '''''') + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END

IF LEN(@ps_ssn) > 0
	BEGIN
	SET @ls_sql = 'ssn = ''' + REPLACE(@ps_ssn, '''', '''''') + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END

IF LEN(@ps_phone_number) > 0
	BEGIN
	SET @ls_sql = 'phone_number = ''' + dbo.fn_pretty_phone(@ps_phone_number) + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END

IF LEN(@ps_email_address) > 0
	BEGIN
	SET @ls_sql = 'email_address = ''' + REPLACE(@ps_email_address, '''', '''''') + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END

/*
-- Commented out because address_line_1 is not indexed yet.  After ML141 this section will be enabled
IF LEN(@ps_address_line_1) > 0 AND LEN(@ps_city) > 0
	BEGIN
	SET @ls_sql = 'address_line_1 = ''' + REPLACE(@ps_address_line_1, '''', '''''') + ''''
	SET @ls_sql = @ls_sql + ' AND city = ''' + REPLACE(@ps_city, '''', '''''') + ''''
	SET @ls_sql = 'SELECT cpr_id FROM p_Patient WHERE ' + @ls_sql

	INSERT INTO #found_patients (cpr_id)
	EXECUTE (@ls_sql)
	END
*/

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'billing_id',
	p.billing_id
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.billing_id) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'last_name',
	p.last_name
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.last_name) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'first_name',
	p.first_name
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.first_name) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'middle_name',
	p.middle_name
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.middle_name) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'sex',
	p.sex
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.sex) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'date_of_birth',
	CONVERT(varchar(10), p.date_of_birth, 101)
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE p.date_of_birth IS NOT NULL

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'ssn',
	LTRIM(RTRIM(REPLACE(p.ssn, '-', '')))
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.ssn) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'phone_number',
	dbo.fn_pretty_phone(p.phone_number)
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.phone_number) > 0


INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'address_line_1',
	p.address_line_1
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.address_line_1) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'address_line_2',
	p.address_line_2
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.address_line_2) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'state',
	p.state
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.state) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'zip',
	p.zip
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.zip) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'email_address',
	p.email_address
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.email_address) > 0

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT p.cpr_id,
	'city',
	p.city
FROM p_Patient p
	INNER JOIN #found_patients x
	ON p.cpr_id = x.cpr_id
WHERE LEN(p.city) > 0

DROP TABLE #found_patients

----------------------------------------------------------------------------------------------------------------------
-- Synthesize special 'Address' property is really a combination of address_line_1, address_line_2, city, state, zip
----------------------------------------------------------------------------------------------------------------------
INSERT INTO @search_properties (
	property_name,
	property_value)
VALUES (
	'address',
	'Matched')

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT x.cpr_id,
	'address',
	'Not Matched'
FROM @patient_properties x
WHERE x.property_name IN ('address_line_1', 'address_line_2', 'city', 'state', 'zip')
AND EXISTS (
	SELECT 1
	FROM @search_properties s2
	WHERE x.property_name = s2.property_name
	AND x.property_value <> s2.property_value)

INSERT INTO @patient_properties (
	cpr_id,
	property_name,
	property_value)
SELECT DISTINCT x.cpr_id,
	'address',
	'Matched'
FROM @patient_properties x
WHERE x.property_name IN ('address_line_1', 'address_line_2', 'city', 'state', 'zip')
AND EXISTS (
	SELECT 1
	FROM @search_properties s1
	WHERE x.property_name = s1.property_name
	AND x.property_value = s1.property_value)
AND NOT EXISTS (
	SELECT 1
	FROM @patient_properties p
	WHERE p.cpr_id = x.cpr_id
	AND p.property_name = 'address')
---------------------------------------------------------------------------------------------------------------

UPDATE x
SET corroboration = w.corroboration
FROM @patient_properties x
	INNER JOIN @property_weights w
	ON x.property_name = w.property_name
	INNER JOIN @search_properties s
	ON x.property_name = s.property_name
WHERE x.property_value = s.property_value

UPDATE x
SET anti_corroboration = w.anti_corroboration
FROM @patient_properties x
	INNER JOIN @property_weights w
	ON x.property_name = w.property_name
	INNER JOIN @search_properties s
	ON x.property_name = s.property_name
WHERE x.property_value <> s.property_value

INSERT INTO @patient_weights (
	cpr_id,
	find_score)
SELECT cpr_id,
	SUM(corroboration) - SUM(anti_corroboration)
FROM @patient_properties
GROUP BY cpr_id
HAVING SUM(anti_corroboration) < @ll_anti_match_threshold

SELECT @ll_match_count = count(*)
FROM @patient_weights w
WHERE w.find_score >= @ll_match_threshold

SELECT 	p.cpr_id ,
	dbo.fn_pretty_name(p.last_name ,
						p.first_name ,
						p.middle_name ,
						p.name_suffix ,
						p.name_prefix ,
						p.degree ) as patient_name,
	p.date_of_birth ,
	p.sex ,
	p.billing_id ,
	p.ssn ,
	p.first_name ,
	p.last_name ,
	p.degree ,
	p.name_prefix ,
	p.middle_name ,
	p.name_suffix ,
	p.maiden_name ,
	p.primary_provider_id ,
	p.secondary_provider_id ,
	p.phone_number ,
	p.patient_status ,
	p.referring_provider_id ,
	p.address_line_1 ,
	p.address_line_2 ,
	p.state ,
	p.zip ,
	p.country ,
	p.secondary_phone_number ,
	p.email_address ,
	p.city ,
	w.find_score
FROM p_Patient p
	INNER JOIN @patient_weights w
	ON p.cpr_id = w.cpr_id
WHERE (@ll_match_count = 1 OR @ps_find_multiple = 'Y')
AND (@ps_return_all_candidates = 'Y' OR w.find_score >= @ll_match_threshold)


GO
GRANT EXECUTE
	ON [dbo].[jmj_find_patient]
	TO [cprsystem]
GO

