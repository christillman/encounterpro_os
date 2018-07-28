CREATE TRIGGER tr_p_Chart_Alert_Progress_insert ON p_Chart_Alert_Progress
FOR INSERT
AS

UPDATE p
SET alert_status = 'CLOSED',
	end_date = i.progress_date_time,
	close_encounter_id = i.encounter_id
FROM p_Chart_Alert p
	INNER JOIN inserted i
	ON p.cpr_id = i.cpr_id
	AND p.alert_id = i.alert_id


