CREATE PROCEDURE sp_cancel_in_office_services
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24)
	) 

AS

DECLARE @ll_patient_workplan_item_id int,
		@ls_wp_item_status varchar(12),
		@ldt_progress_date_time datetime


-- First convert the in-office workplan to an out-of-office workplan
UPDATE p_Patient_WP
SET in_office_flag = 'N'
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND in_office_flag = 'Y'
AND (status <> 'Pending' OR workplan_type NOT IN ('Followup', 'Referral'))

-- Then convert the in-office messages to out-of-office messages
UPDATE i
SET in_office_flag = 'N'
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP wp
	ON i.patient_workplan_id = wp.patient_workplan_id
WHERE i.cpr_id = @ps_cpr_id
AND i.encounter_id = @pl_encounter_id
AND i.active_service_flag = 'Y'
AND i.in_office_flag = 'Y'
AND i.item_type = 'Service'
AND i.ordered_service = 'MESSAGE'
AND (wp.status <> 'Pending' OR wp.workplan_type NOT IN ('Followup', 'Referral'))

SET @ldt_progress_date_time = getdate()
SET @ls_wp_item_status = 'Cancelled'

-- Close/Cancel all the workplan items which are still pending
INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	i.encounter_id,
	@ps_ordered_by,
	@ldt_progress_date_time,
	@ls_wp_item_status,
	@ps_created_by
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP wp
	ON i.patient_workplan_id = wp.patient_workplan_id
WHERE i.cpr_id = @ps_cpr_id
AND i.encounter_id = @pl_encounter_id
AND (i.status NOT IN('COMPLETED', 'CANCELLED', 'Skipped') OR i.status IS NULL)
AND i.in_office_flag = 'Y'
AND (wp.status <> 'Pending' OR wp.workplan_type NOT IN ('Followup', 'Referral'))



