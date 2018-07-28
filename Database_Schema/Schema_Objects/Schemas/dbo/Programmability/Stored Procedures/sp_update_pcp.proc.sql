CREATE PROCEDURE sp_update_pcp
AS

/*	This SP will set the Primary Care Provider for a patient to the Attending Doctor of the last closed Well Encounter that was closed within 2
	days.  The SP looks for a progress Property record where the value of 'keep pcp' is true.  This progress record can be set by a button from
	the soap screen.  
	
	Making the button - new button, Service, Encounter, New Note, context object = Encounter, Special Note Type = Property, 
	Other Note Title or Key = Keep PCP, Note Text = True

*/





DECLARE @tmp_well table(
        	cpr_id varchar(12) NOT NULL ,
            	encounter_id int NOT NULL ,
		assessment_type varchar (12))

            
INSERT INTO @tmp_well 
	SELECT e.cpr_id, max(e.encounter_id) as encounter_id, ad.assessment_type
	FROM p_patient_encounter e
        	INNER JOIN p_patient p 
		ON (e.cpr_id = p.cpr_id)
		INNER JOIN c_user c
		ON e.attending_doctor = c.user_id
		INNER JOIN c_user_role r
		ON c.user_id = r.user_id
		INNER JOIN p_Encounter_Assessment a
		ON e.encounter_id = a.encounter_id
		AND e.cpr_id = a.cpr_id  
        	INNER JOIN c_Assessment_Definition ad
        	ON a.assessment_id = ad.assessment_id 
	WHERE ad.assessment_type = 'WELL'
	AND e.encounter_date > getdate() - 30
      	AND e.encounter_status = 'CLOSED'
	AND r.role_id ='!Physician'
      	GROUP BY e.cpr_id, ad.assessment_type


Update p
SET p.primary_provider_id = y.attending_doctor
FROM p_patient p
      INNER JOIN (
            SELECT DISTINCT e.cpr_id, e.encounter_id, e.attending_doctor
            FROM p_Patient_Encounter e
                  INNER JOIN @tmp_well w
                  ON e.cpr_id = w.cpr_id 
                  AND e.encounter_id = w.encounter_id 
                  
            WHERE NOT EXISTS (Select * FROM p_patient_encounter_progress x 
                                    WHERE e.cpr_id = x.cpr_id
                                    AND e.encounter_id = x.encounter_id
                                    AND x.current_flag = 'Y'
                                    AND x.progress_type = 'Property'
                                    AND x.progress_key = 'Keep PCP'
                                    AND x.progress_value = 'True') ) y
      ON p.cpr_id = y.cpr_id
WHERE (y.attending_doctor <> p.primary_provider_id OR p.primary_provider_id IS NULL)

