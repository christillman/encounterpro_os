CREATE PROCEDURE sp_lock_service (
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@pl_computer_id int
	)
AS

DECLARE @ls_locked_by_user_id varchar(24), @ll_locked_by_computer_id int --CWW

-- Find out if a user is already performing this service, take an exclusive lock on the record
SELECT @ls_locked_by_user_id = [user_id],
	@ll_locked_by_computer_id = computer_id
FROM o_User_Service_Lock (UPDLOCK)
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @@ROWCOUNT = 0
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


