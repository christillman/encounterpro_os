CREATE TRIGGER tr_Patient_WP_Insert ON dbo.p_Patient_WP
FOR INSERT 
AS

IF EXISTS(SELECT 1 FROM inserted WHERE workplan_type = 'Attachment')
	BEGIN
	-- If there are any attachment workplans, then update the appropriate key according to
	-- what the attachment is attached to
	UPDATE p
	SET encounter_id = CASE a.context_object WHEN 'Encounter' THEN COALESCE(p.encounter_id, a.object_key) ELSE p.encounter_id END,
		problem_id = CASE a.context_object WHEN 'Assessment' THEN COALESCE(p.problem_id, a.object_key) ELSE p.problem_id END,
		treatment_id = CASE a.context_object WHEN 'Treatment' THEN COALESCE(p.treatment_id, a.object_key) ELSE p.treatment_id END,
		observation_sequence = CASE a.context_object WHEN 'Observation' THEN COALESCE(p.observation_sequence, a.object_key) ELSE p.observation_sequence END
	FROM p_Patient_WP p
		INNER JOIN inserted i
		ON p.patient_workplan_id = i.patient_workplan_id
		INNER JOIN p_Attachment a
		ON p.attachment_id = a.attachment_id
	END

UPDATE p
SET context_object = CASE i.workplan_type WHEN 'Patient' THEN 'Patient'
										WHEN 'Encounter' THEN 'Encounter'
										WHEN 'Assessment' THEN 'Assessment'
										WHEN 'Treatment' THEN 'Treatment'
										WHEN 'Referral' THEN 'Treatment'
										WHEN 'Followup' THEN 'Treatment'
										WHEN 'Attachment' THEN 'Attachment'
										ELSE 'General' END
FROM p_Patient_WP p
	INNER JOIN inserted i
	ON p.patient_workplan_id = i.patient_workplan_id

-------------------------------------------------------------------------------
-- If there is no encounter context, pick one.

-- If there is a treatment context, then use the open encounter of the specified treatment
UPDATE p
SET encounter_id = t.open_encounter_id
FROM p_Patient_WP p
	INNER JOIN inserted i
	ON p.patient_workplan_id = i.patient_workplan_id
	INNER JOIN p_Treatment_Item t
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
WHERE p.encounter_id IS NULL
AND p.treatment_id IS NOT NULL

-- Otherwise, use the last encounter
UPDATE p
SET encounter_id = e.max_encounter_id
FROM p_Patient_WP p
	INNER JOIN 
		(	SELECT i.patient_workplan_id, i.cpr_id, max(pe.encounter_id) as max_encounter_id
			FROM p_Patient_Encounter pe
				INNER JOIN inserted i
				ON pe.cpr_id = i.cpr_id
			GROUP BY i.patient_workplan_id, i.cpr_id ) e
	ON p.cpr_id = e.cpr_id
WHERE p.encounter_id IS NULL
-------------------------------------------------------------------------------

