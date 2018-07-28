CREATE PROCEDURE jmjdoc_get_assessment (
	@ps_cpr_id varchar(24),
	@ps_context_object varchar(24),
	@pl_object_key int
)

AS

/*****************************************************************************************************
	
		Patient Assessments

	Retrieve all the assessments diagnosed for this given patient instance.
*****************************************************************************************************/

IF @ps_context_object = 'Patient' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd_9_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
        CASE WHEN a.assessment_status IS NULL THEN 'OPEN'
		ELSE a.assessment_status
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate
FROM	p_Assessment a
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE a.cpr_id = @pl_object_key
--AND a.current_flag = 'Y'
AND (ISNULL(assessment_status,'OPEN') <> 'CANCELLED')
END

/*****************************************************************************************************
	
		Specific Assessment

	Retrieve the assessment details for the given assessment instance only.
*****************************************************************************************************/

IF @ps_context_object = 'Assessment' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd_9_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
	CASE WHEN a.assessment_status IS NULL THEN 'OPEN' 
		ELSE a.assessment_status 
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate
FROM	p_Assessment a
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.problem_id = @pl_object_key
AND current_flag = 'Y'
END

/*****************************************************************************************************
	
		Encounter Assessments

 	a) Assessments created in this encounter
	b) Assessments Closed in this encounter
	c) Assessments opened prior to this encounter but yet open or closed later to this encounter
*****************************************************************************************************/
IF @ps_context_object = 'Encounter' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd_9_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
       CASE WHEN a.assessment_status IS NULL THEN 'OPEN'
                  ELSE CASE WHEN a.close_encounter_id > @pl_object_key THEN 'OPEN'
                                          ELSE a.assessment_status
                          END 
        END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate,
	 ea.assessment_sequence as EncAssSequence,
	 ea.created as EncAssCreated
FROM	p_Assessment a
	INNER JOIN p_Encounter_Assessment ea
		ON ea.cpr_id = a.cpr_id
		AND ea.encounter_id = a.open_encounter_id
		AND ea.problem_id = a.problem_id
	INNER JOIN p_Patient_Encounter e
		ON a.cpr_id = e.cpr_id
		AND (e.encounter_id = a.open_encounter_id OR e.encounter_id=a.close_encounter_id
		 OR (a.begin_date <= e.encounter_date and (a.end_date IS NULL OR a.end_date >= e.encounter_date)))
	LEFT OUTER JOIN c_User u
		ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
		ON c.assessment_id = a.assessment_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_object_key
AND (ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED' OR a.close_encounter_id > @pl_object_key)

END

/*****************************************************************************************************
	
			Treatment Assessments

	Retrieve all the assessments associated with the given treatment instance
*****************************************************************************************************/

IF @ps_context_object = 'Treatment' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd_9_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
	CASE WHEN a.assessment_status IS NULL THEN 'OPEN' 
		ELSE a.assessment_status 
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate,
	 at.created as AsstTrtCreated
FROM	p_Assessment_Treatment at
	INNER JOIN p_Assessment a
	ON at.cpr_id = a.cpr_id
	AND at.encounter_id = a.open_encounter_id
	AND at.problem_id = a.problem_id
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE at.cpr_id = @ps_cpr_id
AND at.treatment_id = @pl_object_key
--AND a.current_flag = 'Y'
AND (ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED')
ORDER BY at.created
END



