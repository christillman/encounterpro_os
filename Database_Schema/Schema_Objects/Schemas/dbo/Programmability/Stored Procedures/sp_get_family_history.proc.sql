CREATE PROCEDURE sp_get_family_history (
	@ps_cpr_id varchar(12) )
AS
SELECT	p_Family_History.family_history_sequence,
	p_Family_History.name,
	p_Family_History.relation,
	p_Family_History.birth_year,
	p_Family_History.age_at_death,
	p_Family_History.cause_of_death,
	p_Family_History.comment,
	p_Family_History.attachment_id,
	p_Family_Illness.family_illness_sequence,
	p_Family_Illness.assessment_id,
	p_Family_Illness.age,
	illness_comment=p_Family_Illness.comment,
	illness_attachment_id=p_Family_Illness.attachment_id
INTO #family_history
FROM	p_Family_History
	LEFT OUTER JOIN p_Family_Illness
	ON p_Family_History.cpr_id = p_Family_Illness.cpr_id
	AND	p_Family_History.family_history_sequence = p_Family_Illness.family_history_sequence
WHERE	p_Family_History.cpr_id = @ps_cpr_id

SELECT	#family_history.family_history_sequence,
	#family_history.name,
	#family_history.relation,
	#family_history.birth_year,
	#family_history.age_at_death,
	#family_history.cause_of_death,
	#family_history.comment,
	#family_history.attachment_id,
	#family_history.family_illness_sequence,
	#family_history.assessment_id,
	#family_history.age,
	#family_history.illness_comment,
	#family_history.illness_attachment_id,
	c_Assessment_Definition.description,
	selected_flag=0
FROM	#family_history
	LEFT OUTER JOIN c_Assessment_Definition
	ON #family_history.assessment_id = c_Assessment_Definition.assessment_id

