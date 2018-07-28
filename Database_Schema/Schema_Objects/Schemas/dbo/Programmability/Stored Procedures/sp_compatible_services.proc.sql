CREATE PROCEDURE sp_compatible_services
	(
	@ps_context_object varchar(24)
	)
AS

DECLARE @compatible TABLE (
	context_object varchar(24) NOT NULL,
	general_flag char(1) NOT NULL,
	patient_flag char(1) NOT NULL,
	encounter_flag char(1) NOT NULL,
	assessment_flag char(1) NOT NULL,
	treatment_flag char(1) NOT NULL,
	observation_flag char(1) NOT NULL,
	attachment_flag char(1) NOT NULL)

-- First get a list of the compatible context objects
INSERT INTO @compatible (
	context_object,
	general_flag,
	patient_flag,
	encounter_flag,
	assessment_flag,
	treatment_flag,
	observation_flag,
	attachment_flag)
VALUES (
	@ps_context_object,
	CASE @ps_context_object WHEN 'General' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Patient' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Encounter' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Assessment' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Treatment' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Observation' THEN 'Y' ELSE 'N' END,
	CASE @ps_context_object WHEN 'Attachment' THEN 'Y' ELSE 'N' END )

-- Then get the services which are compatible
SELECT DISTINCT s.service,
	s.description,
	s.button,
	s.icon,
	selected_flag = CAST(0 as int)
FROM o_Service s
	CROSS JOIN @compatible c
WHERE s.status = 'OK'
AND ((s.general_flag = 'Y' and c.general_flag = 'Y')
or (s.patient_flag = 'Y' and c.patient_flag = 'Y')
or (s.encounter_flag = 'Y' and c.encounter_flag = 'Y')
or (s.assessment_flag = 'Y' and c.assessment_flag = 'Y')
or (s.treatment_flag = 'Y' and c.treatment_flag = 'Y')
or (s.observation_flag = 'Y' and c.observation_flag = 'Y')
or (s.attachment_flag = 'Y' and c.attachment_flag = 'Y'))


