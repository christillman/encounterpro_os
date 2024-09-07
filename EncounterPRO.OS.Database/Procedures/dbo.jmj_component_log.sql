
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_component_log]
Print 'Drop Procedure [dbo].[jmj_component_log]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_component_log]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_component_log]
GO

-- Create Procedure [dbo].[jmj_component_log]
Print 'Create Procedure [dbo].[jmj_component_log]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_component_log (
	@ps_component_id varchar(24) ,
	@pl_version int ,
	@ps_operation varchar(24) ,
	@pdt_operation_date_time datetime ,
	@pl_computer_id int ,
	@ps_operation_as_user varchar(64) ,
	@ps_completion_status varchar(12) ,
	@ps_error_message varchar(max) ,
	@ps_created_by varchar(24)
	)
AS

IF @pdt_operation_date_time IS NULL
	SET @pdt_operation_date_time = dbo.get_client_datetime()

IF @ps_operation_as_user IS NULL
	SET @ps_operation_as_user = ORIGINAL_LOGIN()

IF @pl_version IS NULL
	SET @pl_version = 0

INSERT INTO [dbo].[c_Component_Log] (
	[component_id]
	,[version]
	,[operation]
	,[operation_date_time]
	,[computer_id]
	,[operation_as_user]
	,[completion_status]
	,[error_message]
	,[created_by]
	)
VALUES (
	@ps_component_id ,
	@pl_version ,
	@ps_operation ,
	@pdt_operation_date_time ,
	@pl_computer_id ,
	@ps_operation_as_user ,
	@ps_completion_status ,
	@ps_error_message ,
	@ps_created_by 
	)

GO
GRANT EXECUTE
	ON [dbo].[jmj_component_log]
	TO [cprsystem]
GO

