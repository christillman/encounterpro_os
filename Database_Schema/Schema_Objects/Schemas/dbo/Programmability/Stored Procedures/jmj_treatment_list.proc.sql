CREATE PROCEDURE dbo.jmj_treatment_list (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24),
	@ps_user_id varchar(24),
	@pl_care_plan_id int = 0)
AS

DECLARE @treatmentlist TABLE (
		definition_id int NOT NULL,   
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NOT NULL,
		treatment_mode varchar(24) NULL,
		treatment_sort_sequence int NULL,
		parent_definition_id int NULL,   
		instructions varchar(50) NULL,
		child_flag char(1) NULL,   
		followup_workplan_id int NULL,   
		treatment_type_description varchar(80) NULL,
		in_office_flag char(1) NULL,
		button varchar(64) NULL,
		icon varchar(64) NULL,
		efficacy_rating int NULL,
		contraindication_icon_1 varchar(64) NULL,
		contraindication_icon_2 varchar(64) NULL,
		contraindication_icon_3 varchar(64) NULL,
		contraindication_icon_4 varchar(64) NULL,
		contraindication_icon_5 varchar(64) NULL,
		treatment_type_sort_sequence int NULL,
		selected_flag int NOT NULL DEFAULT(0),
		sort_parent_definition_id int NULL,
		sort_parent_sort_sequence int NULL,
		followup_flag char(1) NOT NULL,
		contraindication_index int IDENTITY(1,1) NOT NULL,
		new_treatment_index int NULL)

INSERT INTO @treatmentlist (
		definition_id,   
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_mode,
		treatment_sort_sequence,
		parent_definition_id,   
		instructions,   
		child_flag,   
		followup_workplan_id,   
		treatment_type_description,
		in_office_flag,
		button,
		icon,
		efficacy_rating,
		treatment_type_sort_sequence,
		followup_flag,
		sort_parent_definition_id,
		sort_parent_sort_sequence)
SELECT	d.definition_id,   
		d.treatment_type,
		d.treatment_key,
		d.treatment_description,
		d.treatment_mode,
		d.sort_sequence,
		d.parent_definition_id,   
		d.instructions,   
		d.child_flag,   
		d.followup_workplan_id,   
		t.description as treatment_type_description,
		t.in_office_flag,
		t.button,
		CASE d.treatment_type WHEN '!COMPOSITE' THEN 'iconcomposite.bmp' ELSE t.icon END,
		CAST(e.rating AS int) AS efficacy_rating,
		t.sort_sequence as treatment_type_sort_sequence,
		COALESCE(t.followup_flag, 'N'),
		COALESCE(parent_definition_id, definition_id),
		d.sort_sequence
FROM u_assessment_treat_definition d
	LEFT OUTER JOIN c_Treatment_Type t
	ON d.treatment_type = t.treatment_type
	LEFT OUTER JOIN r_Assessment_Treatment_Efficacy e
	ON d.assessment_id = e.assessment_id
	AND d.treatment_type = e.treatment_type
	AND d.treatment_key = e.treatment_key
WHERE d.user_id = @ps_user_id
AND d.assessment_id = @ps_assessment_id
AND d.treatment_description IS NOT NULL

UPDATE c
SET sort_parent_sort_sequence = p.treatment_sort_sequence
FROM @treatmentlist c
	INNER JOIN @treatmentlist p
	ON c.parent_definition_id = p.definition_id

SELECT	definition_id,   
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_sort_sequence,
		parent_definition_id,   
		instructions,   
		child_flag,   
		followup_workplan_id,   
		treatment_type_description,
		in_office_flag,
		button,
		icon,
		efficacy_rating,
		contraindication_icon_1,
		contraindication_icon_2,
		contraindication_icon_3,
		contraindication_icon_4,
		contraindication_icon_5,
		treatment_type_sort_sequence,
		selected_flag,
		sort_parent_definition_id,
		sort_parent_sort_sequence,
		followup_flag,
		contraindication_index,
		new_treatment_index,
		treatment_mode
FROM @treatmentlist



