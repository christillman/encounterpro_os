CREATE PROCEDURE sp_get_pm_attributes (
	@ps_billing_system varchar(24)
	)
AS

DECLARE @ls_scheduler varchar(50),
	@ls_billing varchar(50),
	@ls_message_in varchar(50),
	@ls_message_out varchar(50)

-- get the component id's from x_integration
SELECT @ls_scheduler = schedule_id,
	@ls_billing = billing_id,
	@ls_message_in = message_in,
	@ls_message_out = message_out
FROM x_Integrations
WHERE billing_system = @ps_billing_system

SELECT component_id,
	attribute_sequence,
	attribute,
	value
FROM c_Component_Attribute
WHERE component_id IN (@ls_billing,@ls_scheduler,@ls_message_in,@ls_message_out)
ORDER BY component_id asc

