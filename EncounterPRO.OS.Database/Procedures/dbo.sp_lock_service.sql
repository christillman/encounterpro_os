
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_lock_service]
Print 'Drop Procedure [dbo].[sp_lock_service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_lock_service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_lock_service]
GO

-- Create Procedure [dbo].[sp_lock_service]
Print 'Create Procedure [dbo].[sp_lock_service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_lock_service (
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@pl_computer_id int
	)
AS

DECLARE @ls_locked_by_user_id varchar(24), @ll_locked_by_computer_id int

-- Find out if a user is already performing this service, take an exclusive lock on the record
SELECT @ls_locked_by_user_id = [user_id],
	@ll_locked_by_computer_id = computer_id
FROM o_User_Service_Lock (UPDLOCK)
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ls_locked_by_user_id IS NULL
	BEGIN
	-- If we didn't find a record for this service, then make one, thereby locking this service
	INSERT INTO o_User_Service_Lock (
		patient_workplan_item_id,
		[user_id],
		computer_id)
	VALUES (
		@pl_patient_workplan_item_id,
		@ps_user_id,
		@pl_computer_id )

	SET @ls_locked_by_user_id = @ps_user_id
	SET @ll_locked_by_computer_id = @pl_computer_id
	END

SELECT @ls_locked_by_user_id as locked_by_user_id, @ll_locked_by_computer_id as locked_by_computer_id


GO
GRANT EXECUTE
	ON [dbo].[sp_lock_service]
	TO [cprsystem]
GO

