CREATE PROCEDURE sp_get_object_progress_types
AS

DECLARE @li_diagnosis_sequence smallint

DECLARE @progress_type TABLE (
	context_object varchar(24),
	context_object_type varchar(24),
	progress_type varchar(24) NOT NULL,
	display_flag char(1) NOT NULL DEFAULT ('Y'),
	display_style varchar(24) NULL,
	soap_display_style varchar(24) NULL,
	progress_key_required_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_enumerated_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_object varchar(24) NULL,
	sort_sequence int NULL
	)


INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type )
SELECT 'Patient',
		'Patient',
		domain_item
FROM c_Domain
WHERE domain_id = 'PATIENT_PROGRESS_TYPE'
AND domain_item IS NOT NULL


INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Encounter' ,
		pt.encounter_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Encounter_Type_Progress_Type pt

INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Assessment' ,
		pt.assessment_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Assessment_Type_Progress_Type pt

INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Treatment' ,
		pt.treatment_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		pt.display_style ,
		pt.soap_display_style ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Treatment_Type_Progress_Type pt

INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type )
SELECT 'Observation',
		'Observation',
		domain_item
FROM c_Domain
WHERE domain_id = 'OBSERVATION_PROGRESS_TYPE'
AND domain_item IS NOT NULL

INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type )
SELECT 'Attachment',
		'Attachment',
		domain_item
FROM c_Domain
WHERE domain_id = 'ATTACHMENT_PROGRESS_TYPE'
AND domain_item IS NOT NULL


SELECT	context_object,
		context_object_type,
		progress_type ,
		display_flag ,
		display_style ,
		soap_display_style ,
		progress_key_required_flag ,
		progress_key_enumerated_flag ,
		progress_key_object ,
		sort_sequence 
FROM @progress_type

