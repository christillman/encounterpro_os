CREATE PROCEDURE sp_maintenance_expire_services (
	@ps_user_id varchar(24) = '#SYSTEM',
	@ps_created_by varchar(24) = '#SYSTEM' )
AS

-- First make sure the expiration date is set
UPDATE i
SET expiration_date = CASE s.default_expiration_unit_id
							WHEN 'Year' THEN dateadd(Year, s.default_expiration_time, i.dispatch_date)
							WHEN 'Month' THEN dateadd(Month, s.default_expiration_time, i.dispatch_date)
							WHEN 'Day' THEN dateadd(Day, s.default_expiration_time, i.dispatch_date)
							WHEN 'Hour' THEN dateadd(Hour, s.default_expiration_time, i.dispatch_date)
							WHEN 'Minute' THEN dateadd(Minute, s.default_expiration_time, i.dispatch_date)
							WHEN 'Second' THEN dateadd(Second, s.default_expiration_time, i.dispatch_date)
							END
FROM p_Patient_WP_Item i
	INNER JOIN o_Service s
	ON i.ordered_service = s.service
	AND i.item_type = 'Service'
WHERE i.active_service_flag = 'Y'
AND i.expiration_date IS NULL
AND s.default_expiration_time > 0
AND s.default_expiration_unit_id IN ('Year', 'Month', 'Day', 'Hour', 'Minute', 'Second')


-- Then expire all the services which are past their expiration date
INSERT INTO p_Patient_WP_Item_Progress (
            patient_workplan_id,
            patient_workplan_item_id,
            cpr_id,
            encounter_id,
            [user_id],
            progress_date_time,
            progress_type,
            created,
            created_by )
SELECT i.patient_workplan_id,
            i.patient_workplan_item_id,
            i.cpr_id,
            i.encounter_id,
            @ps_user_id,
            getdate(),
            'Expired',
            getdate(),
            @ps_created_by
FROM p_Patient_WP_Item i
WHERE i.active_service_flag = 'Y'
AND expiration_date IS NOT NULL
AND expiration_date < getdate()

