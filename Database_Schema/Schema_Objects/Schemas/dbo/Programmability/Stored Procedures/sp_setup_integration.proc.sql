CREATE PROCEDURE sp_setup_integration
	(
	@ps_billing_system varchar(20),
	@ps_office_id varchar(4)
	)
AS

DECLARE @ls_billing_id VARCHAR(20),
	@ls_schedule_id VARCHAR(20)
	

SELECT @ls_billing_id = billing_id,
	@ls_schedule_id = schedule_id
FROM x_Integrations
WHERE billing_system = @ps_billing_system

IF @@rowcount = 1
BEGIN
DELETE FROM o_Server_Component
WHERE component_id = @ls_schedule_id

INSERT INTO o_Server_Component
(
 component_id,
 system_user_id,
 start_order,
 status
)
VALUES
(
 @ls_schedule_id,
 '#SCHED',
 1,
 'OK'
)

UPDATE c_Office
SET billing_component_id = @ls_billing_id
WHERE office_id = @ps_office_id
END

-- Set Preference
EXECUTE sp_set_preference 'PREFERENCES', 'Global', 'Global', 'default_billing_system', @ps_billing_system


