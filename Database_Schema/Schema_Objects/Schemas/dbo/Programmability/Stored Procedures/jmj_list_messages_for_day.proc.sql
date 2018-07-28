CREATE PROCEDURE jmj_list_messages_for_day (
	@ps_ordered_by varchar(24),
	@pdt_message_date datetime )
AS

DECLARE @ldt_begin_date datetime,
	@ldt_end_date datetime 

-- Set day boundaries
SET @ldt_begin_date = convert(datetime, convert(varchar(10),@pdt_message_date, 101))
SET @ldt_end_date = convert(datetime, convert(varchar(10),@pdt_message_date, 101) + ' 23:59:59.999')


DECLARE @msgs TABLE (
	patient_workplan_item_id int NOT NULL,
	description varchar(80) NULL,
	ordered_for varchar(24) NOT NULL,
	cpr_id varchar(12) NULL,
	encounter_id int NULL,
	to_user varchar(80) NULL,
	dispatch_date datetime)

INSERT INTO @msgs (
	patient_workplan_item_id,
	description,
	ordered_for,
	cpr_id,
	encounter_id,
	dispatch_date )
SELECT patient_workplan_item_id,
	description,
	ordered_for,
	cpr_id,
	encounter_id,
	dispatch_date
FROM p_Patient_WP_Item
WHERE ordered_by = @ps_ordered_by
AND ordered_service = 'MESSAGE'
AND dispatch_date >= @ldt_begin_date
AND dispatch_date <= @ldt_end_date


UPDATE t
SET to_user = u.user_full_name
FROM @msgs t
	INNER JOIN c_User u
	ON t.ordered_for = u.user_id
WHERE t.to_user IS NULL

UPDATE t
SET to_user = r.role_name
FROM @msgs t
	INNER JOIN c_Role r
	ON t.ordered_for = r.role_id
WHERE t.to_user IS NULL


SELECT t.patient_workplan_item_id,
	t.to_user,
	subject = t.description,
	sent_date_time = t.dispatch_date,
	patient = dbo.fn_patient_full_name(t.cpr_id)
FROM @msgs t


