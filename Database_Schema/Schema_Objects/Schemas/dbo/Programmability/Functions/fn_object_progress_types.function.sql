CREATE FUNCTION fn_object_progress_types ()

RETURNS @progress_type TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	progress_type varchar(24) NOT NULL,
	display_flag char(1) NOT NULL DEFAULT ('Y'),
	display_style varchar(24) NULL,
	soap_display_style varchar(24) NULL,
	progress_key_required_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_enumerated_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_object varchar(24) NULL,
	sort_sequence int NULL
	)

AS

BEGIN


--------------------------------------------------------
-- Patient Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		'Patient' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Patient'

--------------------------------------------------------
-- Encounter Specific Progress Types
--------------------------------------------------------
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

--------------------------------------------------------
-- Encounter Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		e.encounter_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Encounter_Type e
WHERE d.context_object = 'Encounter'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = e.encounter_type
	AND p.progress_type = d.progress_type)


--------------------------------------------------------
-- Assessment Specific Progress Types
--------------------------------------------------------
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

--------------------------------------------------------
-- Assessment Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		a.assessment_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Assessment_Type a
WHERE d.context_object = 'Assessment'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = a.assessment_type
	AND p.progress_type = d.progress_type)


--------------------------------------------------------
-- Treatment Specific Progress Types
--------------------------------------------------------
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


--------------------------------------------------------
-- Treatment Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		t.treatment_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Treatment_Type t
WHERE d.context_object = 'Treatment'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = t.treatment_type
	AND p.progress_type = d.progress_type)





--------------------------------------------------------
-- Observation Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		'Observation' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Observation'


--------------------------------------------------------
-- Attachment Default Progress Types
--------------------------------------------------------
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
SELECT	d.context_object ,
		'Attachment' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Attachment'




RETURN
END

