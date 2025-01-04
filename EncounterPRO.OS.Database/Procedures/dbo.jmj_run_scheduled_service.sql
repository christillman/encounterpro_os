
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_run_scheduled_service]
Print 'Drop Procedure [dbo].[jmj_run_scheduled_service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_run_scheduled_service]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_run_scheduled_service]
GO

-- Create Procedure [dbo].[jmj_run_scheduled_service]
Print 'Create Procedure [dbo].[jmj_run_scheduled_service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.jmj_run_scheduled_service
(
	@pl_service_sequence int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24)
)
AS

-- This procedure dispatches the specified scheduled service

SET NOCOUNT ON

DECLARE @ll_patient_workplan_item_id int,
		@ll_error int,
		@ll_rowcount int

IF @pl_service_sequence IS NULL
	BEGIN
	RAISERROR ('Null Scheduled Service',16,-1)
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	item_number,
	item_type,
	ordered_service,
	in_office_flag,
	auto_perform_flag,
	description,
	ordered_by,
	ordered_for,
	created_by)
SELECT 0,
	-1,  -- Scheduled Service
	service_sequence,
	'Service',
	[service],
	'N',
	'N',
	description,
	@ps_ordered_by,
	[user_id],
	@ps_created_by
FROM o_Service_Schedule
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_rowcount <> 1
	BEGIN
	ROLLBACK TRANSACTION
	RAISERROR ('Scheduled Service not found (%d)',16,-1, @pl_service_sequence)
	RETURN -1
	END

SELECT @ll_patient_workplan_item_id = @@identity


-- Transfer the attributes
INSERT INTO p_Patient_WP_Item_Attribute
(	 patient_workplan_id
	,patient_workplan_item_id
	,attribute
	,value_short
	,message
	,created_by
)
SELECT		
	 0
	,@ll_patient_workplan_item_id
	,attribute
	,CASE WHEN len(value) <= 50 THEN CAST(value AS varchar(50)) ELSE NULL END
	,CASE WHEN len(value) > 50 THEN value ELSE NULL END
	,@ps_created_by
FROM dbo.o_Service_Schedule_Attribute
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Dispatch workplan item
INSERT INTO p_Patient_WP_Item_Progress (
	patient_workplan_id,
	patient_workplan_item_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
VALUES (
	0,
	@ll_patient_workplan_item_id,
	@ps_ordered_by,
	dbo.get_client_datetime(),
	'DISPATCHED',
	@ps_created_by)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE o_Service_Schedule
SET last_service_date = dbo.get_client_datetime(),
	last_service_status = 'Ordered'
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION


GO
GRANT EXECUTE
	ON [dbo].[jmj_run_scheduled_service]
	TO [cprsystem]
GO

