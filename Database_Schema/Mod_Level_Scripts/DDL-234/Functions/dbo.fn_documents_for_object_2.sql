
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_documents_for_object_2]
Print 'Drop Function [dbo].[fn_documents_for_object_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_documents_for_object_2]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_documents_for_object_2]
GO

-- Create Function [dbo].[fn_documents_for_object_2]
Print 'Create Function [dbo].[fn_documents_for_object_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_documents_for_object_2 (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int,
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS @documents TABLE (
	cpr_id varchar(12) NULL,
	encounter_id int NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(255) NOT NULL,
	actor_id int NULL,
	actor_class varchar(24) NULL,
	communication_type varchar(24) NULL,
	description varchar(80) NULL,
	ordered_for varchar(255) NULL,
	user_full_name varchar(64) NULL,
	dispatch_method varchar(24) NULL,
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12) NULL,
	display_status varchar(12) NULL,
	sent_status varchar(12) NULL,
	retries int NULL,
	escalation_date datetime NULL,
	expiration_date datetime NULL,
	report_id varchar(40) NULL,
	attachment_id int NULL,
	via_address varchar(255) NULL,
	via_address_display varchar(255) NULL,
	via_address_choices int NOT NULL DEFAULT 0,
	get_signature varchar(12) NOT NULL DEFAULT ('Optional'),
	get_ordered_for varchar(12) NOT NULL DEFAULT ('Optional'),
	material_id int NULL,
	document_type varchar(12) NULL,
	treatment_id int NULL,
	problem_id int NULL,
	document_context_object varchar(24) NULL,
	document_object_key int NULL,
	error_message varchar(255) NULL,
	purpose varchar(40) NULL)
AS
BEGIN
/* 7.2.1.9: Extract dbo.fn_document_wpi_for_object */

DECLARE @actor_comm TABLE (
	actor_id int NOT NULL,
	communication_type varchar(24) NOT NULL,
	via_address_choices int NOT NULL DEFAULT 0)

DECLARE @attributes TABLE (
	patient_workplan_item_id int NOT NULL,
	attribute_sequence int NOT NULL,
	attribute varchar(64) NOT NULL,
	value varchar(255) NULL)

DECLARE @candidates TABLE (
	patient_workplan_item_id int NOT NULL)

INSERT INTO @candidates (
		patient_workplan_item_id )
SELECT DISTINCT patient_workplan_item_id
FROM dbo.fn_document_wpi_for_object(@ps_context_object, @ps_cpr_id, @pl_object_key, @pdt_begin_date, @pdt_end_date)

INSERT INTO @documents (
	cpr_id,
	encounter_id,
	patient_workplan_item_id,
	ordered_by,
	actor_id,
	actor_class,
	communication_type,
	description,
	ordered_for,
	user_full_name,
	dispatch_method,
	dispatch_date,
	begin_date,
	end_date,
	status,
	display_status,
	sent_status,
	retries,
	escalation_date,
	expiration_date,
	treatment_id)
SELECT
	i.cpr_id,
	i.encounter_id,
	i.patient_workplan_item_id,
	i.ordered_by,
	u.actor_id,
	u.actor_class,
	r.communication_type,
	i.description,
	i.ordered_for,
	u.user_full_name,
	i.dispatch_method,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	CASE i.status	WHEN 'Ready' THEN COALESCE(r.sending_status, i.status) 
					WHEN 'Sent' THEN COALESCE(r.sent_status, i.status) 
					ELSE i.status END as display_status,
	r.sent_status,
	i.retries,
	i.escalation_date,
	i.expiration_date,
	i.treatment_id
FROM @candidates x
	INNER JOIN p_Patient_WP_Item i WITH (NOLOCK)
	ON x.patient_workplan_item_id = i.patient_workplan_item_id
	LEFT OUTER JOIN c_User u
	ON i.ordered_for = u.user_id
	LEFT OUTER JOIN c_Document_Route r
	ON i.dispatch_method = r.document_route

-- Cache the latest value for each attribute
INSERT INTO @attributes (
	patient_workplan_item_id ,
	attribute ,
	attribute_sequence )
SELECT a.patient_workplan_item_id,
		a.attribute,
		max(attribute_sequence)
FROM p_Patient_WP_Item_Attribute a
	INNER JOIN @documents d
	ON a.patient_workplan_item_id = d.patient_workplan_item_id
GROUP BY a.patient_workplan_item_id, a.attribute

UPDATE x
SET value = COALESCE(a.value, CAST(a.message AS varchar(255)))
FROM @attributes x
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON x.patient_workplan_item_id = a.patient_workplan_item_id
	AND x.attribute_sequence = a.attribute_sequence

DELETE x
FROM @attributes x
WHERE value IS NULL

-- populate some documents table fields from the attributes cache
UPDATE d
SET report_id = CAST(a.value as varchar(40)),
	document_type = 'Report'
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'report_id'

UPDATE d
SET material_id = CAST(a.value as int),
	document_type = 'Material'
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'material_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET problem_id = CAST(a.value as int)
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'problem_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET attachment_id = CAST(a.value as int)
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'attachment_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET get_signature = CAST(a.value as varchar(12))
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'get_signature'

UPDATE d
SET get_ordered_for = CAST(a.value as varchar(12))
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'get_ordered_for'

UPDATE d
SET document_context_object = CAST(a.value as varchar(24))
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'context_object'

UPDATE d
SET error_message = a.value
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'error_message'

UPDATE d
SET document_object_key = CASE document_context_object WHEN 'General' THEN NULL
														WHEN 'Patient' THEN NULL
														WHEN 'Encounter' THEN encounter_id
														WHEN 'Assessment' THEN problem_id
														WHEN 'Treatment' THEN treatment_id
														WHEN 'Attachment' THEN attachment_id END
FROM @documents d

UPDATE d
SET purpose = a.value
FROM @documents d
	INNER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'purpose'

-------------------------------------------------------------------------------
-- Calculate the via_address and via_address_choices for the non-patient actors
-------------------------------------------------------------------------------

INSERT INTO @actor_comm (
	actor_id,
	communication_type )
SELECT DISTINCT actor_id,
				communication_type
FROM @documents
WHERE actor_id IS NOT NULL
AND communication_type IS NOT NULL
AND actor_class <> 'Patient'

UPDATE r
SET via_address_choices = x.via_address_choices
FROM @actor_comm r
	INNER JOIN (SELECT actor_id,
						communication_type,
						count(*) as via_address_choices
				FROM c_Actor_Communication
				GROUP BY actor_id, communication_type) x
	ON r.actor_id = x.actor_id
	AND r.communication_type = x.communication_type

UPDATE d
SET via_address_choices = r.via_address_choices
FROM @documents d
	INNER JOIN @actor_comm r
	ON d.actor_id = r.actor_id
	AND d.communication_type = r.communication_type

UPDATE d
SET via_address = a.value
FROM @documents d
	INNER JOIN @attributes a
	ON a.patient_workplan_item_id = d.patient_workplan_item_id
	AND a.attribute = d.communication_type

UPDATE d
SET via_address = a.communication_value
FROM @documents d
	INNER JOIN c_Actor_Communication a
	ON a.actor_id = d.actor_id
	AND a.communication_type = d.communication_type
WHERE d.via_address_choices = 1
AND d.via_address IS NULL


-------------------------------------------------------------------------------
-- Calculate the via_address and via_address_choices for the patient actors
-------------------------------------------------------------------------------
DECLARE @ls_cpr_id varchar(12),
		@ls_communication_type varchar(24),
		@ll_via_address_choices int,
		@ls_progress_type varchar(24),
		@ls_via_address varchar(255),
		@ll_patient_workplan_item_id int

DECLARE lc_patient_comm CURSOR LOCAL FAST_FORWARD FOR
	SELECT patient_workplan_item_id,
					cpr_id,
					communication_type
	FROM @documents
	WHERE cpr_id IS NOT NULL
	AND communication_type IS NOT NULL
	AND actor_class = 'Patient'

OPEN lc_patient_comm

FETCH lc_patient_comm INTO @ll_patient_workplan_item_id, @ls_cpr_id, @ls_communication_type

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- For Patient actors, the communication options are stored as patient progress records
	-- with a progress type constructed from the communication_type
	SET @ls_progress_type = 'Communication ' + @ls_communication_type
	
	-- Count the number of communication options this patient has for the given communication_type
	SELECT @ll_via_address_choices = count(DISTINCT progress_key)
	FROM p_Patient_Progress
	WHERE cpr_id = @ls_cpr_id
	AND progress_type = @ls_progress_type
	AND current_flag = 'Y'

	-- Get the current setting for this document for this communication_type
	SELECT @ls_via_address = value
	FROM @attributes
	WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
	AND attribute = @ls_communication_type
	
	-- If the current setting is null and there is only one choice for this
	-- communication_type, then assume the only choice will be the setting
	IF @ls_via_address IS NULL AND @ll_via_address_choices = 1
		SELECT @ls_via_address = max(progress_value)
		FROM p_Patient_Progress
		WHERE cpr_id = @ls_cpr_id
		AND progress_type = @ls_progress_type
		AND current_flag = 'Y'

	-- Set the values in the temp table
	UPDATE @documents
	SET via_address = @ls_via_address,
		via_address_choices = @ll_via_address_choices
	WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
	
	FETCH lc_patient_comm INTO @ll_patient_workplan_item_id, @ls_cpr_id, @ls_communication_type
	END

CLOSE lc_patient_comm
DEALLOCATE lc_patient_comm

-------------------------------------------------------------------------------
-- Calculate the via_address and via_address_choices for printers
-------------------------------------------------------------------------------
UPDATE d
SET via_address = a.value,
	via_address_display = COALESCE(p.display_name, a.value),
	via_address_choices = 2
FROM @documents d
	LEFT OUTER JOIN @attributes a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
	AND a.attribute = 'Printer'
	LEFT OUTER JOIN o_Computer_Printer p
	ON p.computer_id = 0
	AND p.printer = a.value
WHERE d.via_address IS NULL
AND d.dispatch_method = 'Printer'

UPDATE d
SET via_address_display = via_address
FROM @documents d
WHERE via_address_display IS NULL

RETURN

END
GO
GRANT SELECT ON [dbo].[fn_documents_for_object_2] TO [cprsystem]
GO

