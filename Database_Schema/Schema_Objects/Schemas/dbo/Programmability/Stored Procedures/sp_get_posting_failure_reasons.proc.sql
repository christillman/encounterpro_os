CREATE PROCEDURE sp_get_posting_failure_reasons (
	 @ps_cpr_id varchar(12),
	 @pl_encounter_id int
)
AS

DECLARE @li_count int,
		@ls_billing_posted char(1),
		@ll_patient_workplan_item_id int

DECLARE @failure_reasons TABLE (
	date_time varchar(12) NOT NULL ,
	[reason] [varchar] (1024)  NULL
	)

SELECT @ls_billing_posted = billing_posted
FROM p_Patient_Encounter WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

-- if no billing erros then return blank row
IF @ls_billing_posted = 'E'
	BEGIN
	INSERT INTO @failure_reasons
	(
	date_time,
	reason
	)
	SELECT distinct convert(varchar(12),log_date_time,1),
	caller + ',' + message
	FROM o_log WITH (NOLOCK)
	WHERE user_id in ('#BILL','#TRANOUT')
	AND cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id

	INSERT INTO @failure_reasons
	(
	date_time,
	reason
	)
	SELECT distinct convert(varchar(12),message_date_time,1),
	coalesce(comments,status,comments) as reason
	FROM o_message_log WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND direction = 'O'
	AND status = 'ACK_REJECT'


	-- Get the last 'Billing Data' Document that got sent
	SELECT @ll_patient_workplan_item_id = max(i.patient_workplan_item_id)
	FROM p_Patient_WP_Item i WITH (NOLOCK)
		INNER JOIN p_Patient_WP_Item_Attribute a
		ON i.patient_workplan_item_id = a.patient_workplan_item_id
	WHERE i.cpr_id = @ps_cpr_id
	AND i.encounter_id = @pl_encounter_id
	AND i.item_type = 'Document'
	AND a.attribute = 'Purpose'
	AND a.value = 'Billing Data'

	INSERT INTO @failure_reasons (
		date_time,
		reason )
	SELECT convert(varchar(12),created,1), COALESCE(CAST(message AS varchar(1024)), value_short)
	FROM p_Patient_WP_Item_Attribute
	WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
	AND attribute = 'error_message'
	AND LEN(COALESCE(CAST(message AS varchar(1024)), value_short)) > 0
	END

SELECT date_time,
reason
FROM @failure_reasons

