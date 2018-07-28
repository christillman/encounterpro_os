


CREATE PROCEDURE jmjrpt_encounter_notes
	@ps_cpr_id varchar(12),
    @pl_encounter_id Integer
        
AS

SELECT distinct p.progress_date_time
	,' '
	,u.user_full_name
	,' '
	,t.treatment_description
FROM p_treatment_item t WITH (NOLOCK) 
	INNER JOIN p_treatment_progress p WITH (NOLOCK)
	ON t.cpr_id = p.cpr_id
	AND t.treatment_id = p.treatment_id 
	INNER JOIN c_user u WITH (NOLOCK)
	ON u.user_id = p.created_by
WHERE t.cpr_id = @ps_cpr_id 
AND t.open_encounter_id = @pl_encounter_id
AND p.progress_type in ('Reviewed','REVIEWED')