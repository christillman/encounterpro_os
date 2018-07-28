CREATE PROCEDURE sp_assessment_search (
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_icd_code varchar(24) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_assessment_type IS NULL
	SELECT @ps_assessment_type = '%'

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_assessment_category_id = '%'
	SET @ps_assessment_category_id = NULL

IF @ps_icd_code IS NULL
	SELECT @ps_icd_code = '%'

IF @ps_specialty_id IS NULL
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd_9_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd_9_code like @ps_icd_code OR a.icd_9_code is null)
ELSE
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd_9_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Common_Assessment c WITH (NOLOCK)
		ON a.assessment_id = c.assessment_id
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND c.specialty_id = @ps_specialty_id
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd_9_code like @ps_icd_code OR a.icd_9_code is null)

