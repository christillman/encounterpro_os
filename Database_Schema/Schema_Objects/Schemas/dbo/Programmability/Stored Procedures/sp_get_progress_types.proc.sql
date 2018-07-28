/****** Object:  Stored Procedure dbo.sp_get_progress_types    Script Date: 7/25/2000 8:43:46 AM ******/
CREATE PROCEDURE sp_get_progress_types (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )
AS

DECLARE @li_diagnosis_sequence smallint

DECLARE @progress_type TABLE (
	progress_type varchar(24) NOT NULL,
	display_flag char(1) NOT NULL DEFAULT ('Y'),
	display_style varchar(24) NULL,
	soap_display_style varchar(24) NULL,
	progress_key_required_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_enumerated_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_object varchar(24) NULL,
	sort_sequence int NULL
	)


IF @ps_context_object = 'Patient'
	INSERT INTO @progress_type (	
		progress_type )
	SELECT domain_item
	FROM c_Domain
	WHERE domain_id = 'PATIENT_PROGRESS_TYPE'


IF @ps_context_object = 'Encounter'
	INSERT INTO @progress_type (	
		progress_type ,
		display_flag ,
		progress_key_required_flag ,
		progress_key_enumerated_flag ,
		progress_key_object ,
		sort_sequence )
	SELECT pt.progress_type ,
			ISNULL(pt.display_flag, 'N') ,
			pt.progress_key_required_flag ,
			pt.progress_key_enumerated_flag ,
			pt.progress_key_object ,
			pt.sort_sequence 
	FROM p_Patient_Encounter pe
		INNER JOIN c_Encounter_Type_Progress_Type pt
		ON pe.encounter_type = pt.encounter_type
	WHERE pe.cpr_id = @ps_cpr_id
	AND pe.encounter_id = @pl_object_key
	AND pt.display_flag = 'Y'

IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @li_diagnosis_sequence = max(diagnosis_sequence)
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	
	INSERT INTO @progress_type (	
		progress_type ,
		display_flag ,
		progress_key_required_flag ,
		progress_key_enumerated_flag ,
		progress_key_object ,
		sort_sequence )
	SELECT pt.progress_type ,
			ISNULL(pt.display_flag, 'N') ,
			pt.progress_key_required_flag ,
			pt.progress_key_enumerated_flag ,
			pt.progress_key_object ,
			pt.sort_sequence 
	FROM p_Assessment pa
		INNER JOIN c_Assessment_Type_Progress_Type pt
		ON pa.assessment_type = pt.assessment_type
	WHERE pa.cpr_id = @ps_cpr_id
	AND pa.problem_id = @pl_object_key
	AND pa.diagnosis_sequence = @li_diagnosis_sequence
	AND pt.display_flag = 'Y'
	END

IF @ps_context_object = 'Treatment'
	INSERT INTO @progress_type (	
		progress_type ,
		display_flag ,
		display_style ,
		soap_display_style ,
		progress_key_required_flag ,
		progress_key_enumerated_flag ,
		progress_key_object ,
		sort_sequence )
	SELECT pt.progress_type ,
			ISNULL(pt.display_flag, 'N') ,
			pt.display_style ,
			pt.soap_display_style ,
			pt.progress_key_required_flag ,
			pt.progress_key_enumerated_flag ,
			pt.progress_key_object ,
			pt.sort_sequence 
	FROM p_Treatment_Item t
		INNER JOIN c_Treatment_Type_Progress_Type pt
		ON t.treatment_type = pt.treatment_type
	WHERE t.cpr_id = @ps_cpr_id
	AND t.treatment_id = @pl_object_key
	AND pt.display_flag = 'Y'

IF @ps_context_object = 'Observation'
	INSERT INTO @progress_type (	
		progress_type )
	SELECT domain_item
	FROM c_Domain
	WHERE domain_id = 'OBSERVATION_PROGRESS_TYPE'

IF @ps_context_object = 'Attachment'
	INSERT INTO @progress_type (	
		progress_type )
	SELECT domain_item
	FROM c_Domain
	WHERE domain_id = 'ATTACHMENT_PROGRESS_TYPE'


SELECT progress_type ,
		display_flag ,
		display_style ,
		soap_display_style ,
		progress_key_required_flag ,
		progress_key_enumerated_flag ,
		progress_key_object ,
		sort_sequence 
FROM @progress_type

