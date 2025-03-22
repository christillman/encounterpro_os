
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_maintenance_schedule]
Print 'Drop Procedure [dbo].[jmj_new_maintenance_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_maintenance_schedule]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_maintenance_schedule]
GO

-- Create Procedure [dbo].[jmj_new_maintenance_schedule]
Print 'Create Procedure [dbo].[jmj_new_maintenance_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_maintenance_schedule (
	@ps_user_id varchar(24),
	@ps_service varchar(24),
	@ps_schedule_type varchar(24),
	@ps_schedule_interval varchar(40),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_service_sequence int

INSERT INTO o_Service_Schedule (
	user_id,
	service,
	schedule_type,
	schedule_interval,
	created_by,
	status )
VALUES (
	@ps_user_id,
	@ps_service,
	@ps_schedule_type,
	@ps_schedule_interval,
	@ps_created_by,
	'NA' )

IF @@ERROR <> 0
	BEGIN
	RETURN -1
	END

SET @ll_service_sequence = SCOPE_IDENTITY()

RETURN @ll_service_sequence

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_maintenance_schedule]
	TO [cprsystem]
GO

