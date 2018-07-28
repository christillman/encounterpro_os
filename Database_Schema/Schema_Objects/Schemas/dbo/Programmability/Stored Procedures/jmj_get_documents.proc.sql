CREATE PROCEDURE jmj_get_documents (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12) = NULL,
	@pl_object_key int = NULL,
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL)
AS



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
	document_type,
	document_context_object,
	document_object_key,
	error_message,
	purpose,
	message_subject = CAST(NULL AS varchar(120)),
	message = CAST(NULL AS text),
	message_sender = CAST(NULL AS varchar(80)),
	via_address_display
FROM dbo.fn_documents_for_object_2(@ps_context_object, @ps_cpr_id, @pl_object_key, @pdt_begin_date, @pdt_end_date)
	


