
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_setup_integration]
Print 'Drop Procedure [dbo].[sp_setup_integration]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_setup_integration]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_setup_integration]
GO

-- Create Procedure [dbo].[sp_setup_integration]
Print 'Create Procedure [dbo].[sp_setup_integration]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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

IF @ls_billing_id IS NOT NULL
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


GO
GRANT EXECUTE
	ON [dbo].[sp_setup_integration]
	TO [cprsystem]
GO

