CREATE PROCEDURE sp_highlighted_results_for_assessment (
	@ps_cpr_id varchar(12),
	@pl_problem_id int )

AS

DECLARE @results TABLE (
	cpr_id varchar(12) NULL
	,begin_date datetime NULL
	,treatment_type varchar(24) NULL
	,observation_type_abbreviation varchar(4) NULL
	,treatment_description varchar(80) NULL
	,observation_sequence int NULL
	,observation_id varchar(24) NULL
	,observation_description varchar(80) NULL
	,location varchar(24) NULL
	,result_sequence smallint NULL
	,location_result_sequence int NULL
	,result_date_time datetime NULL
	,result varchar(40) NULL
	,result_value varchar(40) NULL
	,result_unit varchar(24) NULL
	,abnormal_flag char(1) NULL
	,severity int NULL
	,result_type varchar(12) NULL
	,unit_preference varchar(24) NULL
	,display_mask varchar(40) NULL
	,sort_sequence int NULL
	,result_amount_flag char(1) NULL
	,print_result_flag char(1) NULL
	,print_result_separator varchar(8) NULL
	,location_description varchar(80) NULL
	,treatment_id int NULL
	,encounter_id int NULL
	,default_view char(1) NULL
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
	,selected_flag int NULL
	,result_description  varchar(255) NULL
	,allergen_exists int NULL
	,vial varchar(80) NULL )


INSERT INTO @results (
	cpr_id
	,begin_date
	,treatment_type
	,observation_type_abbreviation
	,treatment_description
	,observation_sequence
	,observation_id
	,observation_description
	,location
	,result_sequence
	,location_result_sequence
	,result_date_time
	,result
	,result_value
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,unit_preference
	,display_mask
	,sort_sequence
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,location_description
	,treatment_id
	,encounter_id
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
	,selected_flag 
	,result_description
	,allergen_exists )
SELECT p.cpr_id
	,t.begin_date
	,t.treatment_type
	,cot.abbreviation
	,t.treatment_description
	,p.observation_sequence
	,p.observation_id
	,po.description as observation_description
	,p.location
	,p.result_sequence
	,p.location_result_sequence
	,p.result_date_time
	,p.result
	,p.result_value
	,p.result_unit
	,p.abnormal_flag
	,p.severity
	,p.result_type
	,c.unit_preference
	,c.display_mask
	,c.sort_sequence
	,c.result_amount_flag
	,c.print_result_flag
	,c.print_result_separator
	,l.description as location_description
	,p.treatment_id
	,p.encounter_id
	,co.default_view
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
	,selected_flag = 0
	,CAST(NULL AS varchar(255)) as result_description
	,allergen_exists = 0
FROM p_Treatment_Item t
	INNER JOIN p_Assessment_Treatment a
	ON t.cpr_id = a.cpr_id
	AND t.treatment_id = a.treatment_id
	INNER JOIN p_Observation_Result p
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
	INNER JOIN p_Observation_Result_Progress rp
	ON p.cpr_id = rp.cpr_id
	AND p.observation_sequence = rp.observation_sequence
	AND p.location_result_sequence = rp.location_result_sequence
	INNER JOIN p_Observation po
	ON p.cpr_id = po.cpr_id
	AND p.observation_sequence = po.observation_sequence
	INNER JOIN c_Observation co
	ON p.observation_id = co.observation_id
	INNER JOIN c_Observation_Result c
	ON p.observation_id = c.observation_id
	AND p.result_sequence = c.result_sequence
	INNER JOIN c_Observation_Type cot
	ON co.observation_type = cot.observation_type
	INNER JOIN c_Location l
	ON p.location = l.location
WHERE t.cpr_id = @ps_cpr_id
AND a.problem_id = @pl_problem_id
AND p.current_flag = 'Y'
AND rp.current_flag = 'Y'
AND rp.progress_type = 'Highlight'
AND rp.progress_key = 'Highlight'
AND LEFT(rp.progress_value, 1) IN ('T', 'Y')

UPDATE r
SET allergen_exists = CASE WHEN c.allergen_count > 0 THEN 1 ELSE 0 END
FROM @results r
	INNER JOIN (SELECT r.observation_id, count(*) as allergen_count
				FROM @results r
					INNER JOIN c_XML_Code x
					ON r.observation_id = x.code
					AND x.owner_id = 0
					AND x.code_domain = 'allergen_observation_id'
					AND x.epro_domain = 'allergen_drug_id'
					INNER JOIN c_Drug_Definition d
					ON x.epro_id = d.drug_id
				GROUP BY r.observation_id ) c
	ON r.observation_id = c.observation_id


UPDATE r
SET vial = c.vial
FROM @results r
	INNER JOIN (SELECT r.observation_id, max(t.treatment_description) as vial
				FROM @results r
					INNER JOIN c_XML_Code x
					ON r.observation_id = x.code
					AND x.owner_id = 0
					AND x.code_domain = 'allergen_observation_id'
					AND x.epro_domain = 'allergen_drug_id'
					INNER JOIN p_Treatment_Item t
					ON x.epro_id = t.drug_id
					AND t.cpr_id = @ps_cpr_id
					AND t.treatment_type = 'AllergyVialDefinition'
					INNER JOIN p_Treatment_Item tp
					ON t.cpr_id = tp.cpr_id
					AND t.parent_treatment_id = tp.treatment_id
				WHERE ISNULL(t.treatment_status, 'OPEN') = 'OPEN'
				AND ISNULL(tp.treatment_status, 'OPEN') = 'OPEN'
				GROUP BY r.observation_id ) c
	ON r.observation_id = c.observation_id


SELECT	cpr_id
	,begin_date
	,treatment_description
	,observation_sequence
	,observation_id
	,observation_description
	,location
	,result_sequence
	,location_result_sequence
	,result_date_time
	,result
	,result_value
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,unit_preference
	,display_mask
	,sort_sequence
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,location_description
	,treatment_id
	,encounter_id
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
	,selected_flag 
	,result_description
	,allergen_exists
	,vial
	,treatment_type
	,observation_type_abbreviation
FROM @results


