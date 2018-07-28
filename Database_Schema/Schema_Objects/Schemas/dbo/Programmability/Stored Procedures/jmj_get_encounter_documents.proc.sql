CREATE PROCEDURE jmj_get_encounter_documents (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS

DECLARE @documents TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(24) NOT NULL,
	actor_id int NULL,
	actor_class varchar(12) NULL,
	communication_type varchar(24) NULL,
	description varchar(80) NULL,
	ordered_for varchar(24) NULL,
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
	via_address_choices int NOT NULL DEFAULT 0,
	get_signature varchar(12) NOT NULL DEFAULT ('Optional'),
	get_ordered_for varchar(12) NOT NULL DEFAULT ('Optional'),
	material_id int NULL,
	document_type varchar(12) NULL)

DECLARE @actor_comm TABLE (
	actor_id int NOT NULL,
	communication_type varchar(24) NOT NULL,
	via_address_choices int NOT NULL DEFAULT 0)

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
	expiration_date)
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
	CASE i.status WHEN 'Sent' THEN COALESCE(r.sent_status, i.status) ELSE i.status END as display_status,
	r.sent_status,
	i.retries,
	i.escalation_date,
	i.expiration_date
FROM p_Patient_WP_Item i WITH (NOLOCK)
	LEFT OUTER JOIN c_User u
	ON i.ordered_for = u.user_id
	LEFT OUTER JOIN c_Document_Route r
	ON i.dispatch_method = r.document_route
WHERE 	i.cpr_id = @ps_cpr_id
AND		i.encounter_id = @pl_encounter_id
AND 	i.item_type = 'Document'

UPDATE d
SET report_id = CAST(a.value as varchar(40)),
	document_type = 'Report'
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'report_id'

UPDATE d
SET material_id = CAST(a.value as int),
	document_type = 'Material'
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'material_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET attachment_id = CAST(a.value as int)
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'attachment_id'
AND ISNUMERIC(a.value) = 1


UPDATE d
SET get_signature = CAST(a.value as varchar(12))
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'get_signature'

UPDATE d
SET get_ordered_for = CAST(a.value as varchar(12))
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'get_ordered_for'


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
	INNER JOIN p_Patient_WP_Item_Attribute a
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
	FROM p_Patient_WP_Item_Attribute
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
	via_address_choices = 2
FROM @documents d
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE d.via_address IS NULL
AND d.dispatch_method = 'Printer'
AND a.attribute = 'Printer'



SELECT patient_workplan_item_id,
	ordered_by,
	description,
	ordered_for,
	actor_id,
	actor_class,
	user_full_name,
	dispatch_method,
	communication_type,
	dispatch_date,
	begin_date,
	end_date,
	status,
	display_status,
	sent_status,
	retries,
	escalation_date,
	expiration_date,
	report_id,
	selected_flag=0,
	attachment_id,
	via_address,
	via_address_choices,
	get_signature,
	get_ordered_for,
	material_id,
	document_type
FROM @documents
	


