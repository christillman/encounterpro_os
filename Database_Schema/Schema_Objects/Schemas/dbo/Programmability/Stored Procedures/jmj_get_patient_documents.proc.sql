CREATE PROCEDURE jmj_get_patient_documents (
	@ps_cpr_id varchar(12))
AS

DECLARE @documents TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	treatment_id int NOT NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(24) NOT NULL,
	description varchar(80) NULL,
	user_id varchar(24) NULL,
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
	document_category varchar(24) NULL )

INSERT INTO @documents (
	cpr_id,
	encounter_id,
	treatment_id,
	patient_workplan_item_id,
	ordered_by,
	description,
	user_id,
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
	i.treatment_id,
	i.patient_workplan_item_id,
	i.ordered_by,
	i.description,
	i.ordered_for as user_id,
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
AND 	i.item_type = 'Document'

UPDATE d
SET report_id = CAST(a.value as varchar(40))
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'report_id'

UPDATE d
SET attachment_id = CAST(a.value as int)
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'attachment_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET document_category = CAST(a.value as varchar(24))
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'document_category'

SELECT cpr_id,
	encounter_id,
	treatment_id,
	patient_workplan_item_id,
	ordered_by,
	description,
	user_id,
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
	report_id,
	attachment_id,
	document_category,
	selected_flag=0
FROM @documents
	


