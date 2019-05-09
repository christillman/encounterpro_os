
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_assessment_search]
Print 'Drop Procedure [dbo].[sp_assessment_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_search]
GO

-- Create Procedure [dbo].[sp_assessment_search]
Print 'Create Procedure [dbo].[sp_assessment_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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

IF [dbo].[fn_icd_version]() = 'ICD10-CM' 
	begin
	IF @ps_specialty_id IS NULL
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			a.description,
			a.auto_close,
			a.icd10_code,
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
		AND (a.icd10_code like @ps_icd_code
			-- special exception needed for EncounterPro allergy assessments
			-- (there are very few in ICD10)
			OR (a.assessment_type = 'ALLERGY' AND a.icd10_code IS NULL) )
		
	ELSE
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			a.description,
			a.auto_close,
			a.icd10_code,
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
		AND (a.icd10_code like @ps_icd_code
			-- special exception needed for EncounterPro allergy assessments
			-- (there are very few in ICD10)
			OR (a.assessment_type = 'ALLERGY' AND a.icd10_code IS NULL) )
	end

IF [dbo].[fn_icd_version]() = 'ICD10-WHO' 
	begin
	IF @ps_specialty_id IS NULL
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			w.descr as description,
			a.auto_close,
			w.code as icd10_code,
			a.status,
			a.auto_close_interval_amount,
			a.auto_close_interval_unit,
			t.icon_open,
			selected_flag=0
		FROM c_Assessment_Definition a WITH (NOLOCK)
		INNER JOIN c_Assessment_Type t WITH (NOLOCK)
			ON a.assessment_type = t.assessment_type
		INNER JOIN icd10_who w WITH (NOLOCK)
			ON a.icd10_who_code = w.code
		WHERE a.assessment_type like @ps_assessment_type
		AND a.status like @ps_status
		AND a.description like @ps_description
		AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
		AND (a.icd10_who_code like @ps_icd_code)
		AND w.active = 'Y'
		
	ELSE
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			w.descr as description,
			a.auto_close,
			w.code as icd10_code,
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
		INNER JOIN icd10_who w WITH (NOLOCK)
			ON a.icd10_who_code = w.code
		WHERE a.assessment_type like @ps_assessment_type
		AND c.specialty_id = @ps_specialty_id
		AND a.status like @ps_status
		AND a.description like @ps_description
		AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
		AND (a.icd10_who_code like @ps_icd_code)
		AND w.active = 'Y'
	end

IF [dbo].[fn_icd_version]() = 'Rwanda' 
	begin
	IF @ps_specialty_id IS NULL
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			r.descr as description,
			a.auto_close,
			r.code as icd10_code,
			a.status,
			a.auto_close_interval_amount,
			a.auto_close_interval_unit,
			t.icon_open,
			selected_flag=0
		FROM c_Assessment_Definition a WITH (NOLOCK)
		INNER JOIN c_Assessment_Type t WITH (NOLOCK)
			ON a.assessment_type = t.assessment_type
		INNER JOIN icd10_rwanda r WITH (NOLOCK)
			ON a.icd10_who_code = r.code
		WHERE a.assessment_type like @ps_assessment_type
		AND a.status like @ps_status
		AND a.description like @ps_description
		AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
		AND (a.icd10_who_code like @ps_icd_code)
		
	ELSE
		SELECT a.assessment_id,
			a.assessment_type,
			a.assessment_category_id,
			r.descr as description,
			a.auto_close,
			r.code as icd10_code,
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
		INNER JOIN icd10_rwanda r WITH (NOLOCK)
			ON a.icd10_who_code = r.code
		WHERE a.assessment_type like @ps_assessment_type
		AND c.specialty_id = @ps_specialty_id
		AND a.status like @ps_status
		AND a.description like @ps_description
		AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
		AND (a.icd10_who_code like @ps_icd_code)
	end

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_search]
	TO [cprsystem]
GO

