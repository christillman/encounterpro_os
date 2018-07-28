CREATE PROCEDURE jmj_check_contraindications (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_treatment_type varchar(24) = NULL,
	@ps_treatment_key varchar(64) = NULL,
	@ps_treatment_description varchar(255) = NULL,
	@ps_treatment_list_user_id varchar(24) = NULL,
	@ps_treatment_list_assessment_id varchar(24) = NULL,
	@pl_care_plan_id int = NULL
)
AS

DECLARE @ldt_check_date datetime

SET @ldt_check_date = getdate()

-- Epro is expecting an 80-character treatment_description in the datawindow dw_jmj_check_contraindications.  If the full
-- 255 character description is needed then call the fn_treatment_contraindications function directly
SELECT treatment_type ,
	treatment_key ,
	treatment_description = CAST(treatment_description AS varchar(80)),
	treatment_definition_id ,
	contraindicationtype ,
	icon ,
	severity ,
	shortdescription ,
	longdescription ,
	contraindication_warning ,
	contraindication_references
FROM dbo.fn_treatment_contraindications(@ps_cpr_id ,
										@ps_user_id ,
										@ps_treatment_type ,
										@ps_treatment_key ,
										@ps_treatment_description ,
										@ps_treatment_list_user_id ,
										@ps_treatment_list_assessment_id ,
										@pl_care_plan_id ,
										@ldt_check_date )
