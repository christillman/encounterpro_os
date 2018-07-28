CREATE TRIGGER tr_o_Service_insert ON dbo.o_Service
FOR INSERT, UPDATE
AS

UPDATE s
SET owner_id = ds.customer_id,
	definition = COALESCE(i.definition, i.description)
FROM o_Service s
	INNER JOIN inserted i
	ON s.service = i.service
	CROSS JOIN c_Database_Status ds
WHERE i.owner_id = -1


-- Set the default context object if it hasn't been set yet

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
AND s.patient_flag = 'Y'
AND (s.encounter_flag = 'Y'
	OR s.assessment_flag = 'Y'
	OR s.treatment_flag = 'Y'
	OR s.observation_flag = 'Y'
	OR s.attachment_flag = 'Y')

UPDATE s
SET default_context_object = 'Attachment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.attachment_flag = 'Y'

UPDATE s
SET default_context_object = 'Observation'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.observation_flag = 'Y'

UPDATE s
SET default_context_object = 'Treatment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.treatment_flag = 'Y'

UPDATE s
SET default_context_object = 'Assessment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.assessment_flag = 'Y'

UPDATE s
SET default_context_object = 'Encounter'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.encounter_flag = 'Y'

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.Patient_flag = 'Y'

UPDATE s
SET default_context_object = 'General'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL


