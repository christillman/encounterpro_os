CREATE FUNCTION fn_treatment_contraindications (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_treatment_type varchar(24) = NULL,
	@ps_treatment_key varchar(64) = NULL,
	@ps_treatment_description varchar(255) = NULL,
	@ps_treatment_list_user_id varchar(24) = NULL,
	@ps_treatment_list_assessment_id varchar(24) = NULL,
	@pl_care_plan_id int = NULL,
	@pdt_check_date datetime = NULL
	)

RETURNS @contra TABLE (
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	treatment_description varchar(255) NOT NULL,
	treatment_definition_id int NULL,
	contraindicationtype varchar(24) NULL,
	icon varchar(64) NULL,
	severity int NULL,
	shortdescription varchar(255) NULL,
	longdescription text NULL,
	contraindication_warning varchar(255) NULL,
	contraindication_references text NULL)
AS

BEGIN

DECLARE @treatments TABLE (
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	treatment_description varchar(255) NULL,
	treatment_key_property varchar(64) NULL,
	treatment_definition_id int NULL
	)

-- SQL 2000 would not allow a getdate() inside a function so we have to pass in the effective check_date.
-- If NULL is passed in, then use 
IF @pdt_check_date IS NULL
	SELECT @pdt_check_date = log_date_time
	FROM o_Log
	WHERE log_id = (SELECT max(log_id) FROM o_Log)

IF @ps_treatment_type IS NOT NULL AND @ps_treatment_key IS NOT NULL
	INSERT INTO @treatments (
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_key_property)
	VALUES (
		@ps_treatment_type,
		@ps_treatment_key,
		@ps_treatment_description,
		dbo.fn_treatment_type_treatment_key(@ps_treatment_type)
		)

IF @ps_treatment_list_user_id IS NOT NULL AND @ps_treatment_list_assessment_id IS NOT NULL
	INSERT INTO @treatments (
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_key_property,
		treatment_definition_id)
	SELECT d.treatment_type,
		COALESCE(d.treatment_key, CAST(d.treatment_description AS varchar(64))),
		d.treatment_description,
		dbo.fn_treatment_type_treatment_key(d.treatment_type),
		d.definition_id
	FROM u_Assessment_Treat_Definition d
	WHERE d.user_id = @ps_treatment_list_user_id
	AND d.assessment_id = @ps_treatment_list_assessment_id
	AND d.treatment_description IS NOT NULL
	AND d.treatment_type IS NOT NULL

-- Now we have a list of the treatments we want to check

-- Add the allergy contraindications
INSERT INTO @contra (
	treatment_type ,
	treatment_key ,
	treatment_description ,
	treatment_definition_id ,
	contraindicationtype ,
	icon ,
	severity ,
	shortdescription ,
	longdescription ,
	contraindication_warning ,
	contraindication_references )
SELECT x.treatment_type ,
	x.treatment_key ,
	COALESCE(x.treatment_description, dd.common_name) ,
	x.treatment_definition_id ,
	'Drug Allergy' ,
	'bitmap_drug_allergy.bmp' ,
	3 ,
	a.assessment + ' Allergy',
	NULL ,
	'This patient has an allergy (' + a.assessment + ') which may cause an adverse reaction to ' + dd.common_name,
	NULL
FROM @treatments x
	INNER JOIN c_Allergy_Drug ad WITH (NOLOCK)
	ON ad.drug_id = x.treatment_key
	INNER JOIN p_Assessment a WITH (NOLOCK)
	ON a.cpr_id = @ps_cpr_id
	AND a.assessment_id = ad.assessment_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	INNER JOIN c_Drug_Definition dd WITH (NOLOCK)
	ON ad.drug_id = dd.drug_id
WHERE ISNULL(a.assessment_status, 'OPEN') = 'OPEN'
AND x.treatment_key_property = 'drug_id'


-- Add the duplicate treatment check
INSERT INTO @contra (
	treatment_type ,
	treatment_key ,
	treatment_description ,
	treatment_definition_id ,
	contraindicationtype ,
	icon ,
	severity ,
	shortdescription ,
	longdescription ,
	contraindication_warning ,
	contraindication_references )
SELECT x.treatment_type ,
	x.treatment_key ,
	COALESCE(x.treatment_description, dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key)) ,
	x.treatment_definition_id ,
	'Duplicate Therapy' ,
	'bitmap_alert.bmp' ,
	3 ,
	'Duplicate Order - ' + dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key),
	NULL ,
	'The ' + tt.description + ' "' +  dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key) 
		+ '" was ordered for this patient on ' + CONVERT(varchar(10), t.begin_date, 101),
	NULL
FROM @treatments x
	INNER JOIN c_Treatment_Type tt
	ON x.treatment_type = tt.treatment_type
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_type = x.treatment_type
	AND dbo.fn_treatment_key(t.cpr_id, t.treatment_id) = x.treatment_key
WHERE tt.default_duplicate_check_days > 0
AND (t.open_flag = 'Y'
	OR t.begin_date >= DATEADD(day, -tt.default_duplicate_check_days, @pdt_check_date)
	)
AND ISNULL(t.treatment_status, 'OPEN') <> 'Cancelled'

RETURN
END
