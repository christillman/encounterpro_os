CREATE PROCEDURE jmj_startup_check
AS

DECLARE @ll_count int

SELECT @ll_count = count(*)
FROM p_Patient_WP
WHERE patient_workplan_id = 0

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_count = 0
	BEGIN
	IF user = 'dbo'
		BEGIN
		SET IDENTITY_INSERT p_Patient_WP ON
		
		INSERT INTO p_Patient_WP (
			patient_workplan_id,
			workplan_id,
			workplan_type,
			description,
			ordered_by,
			status,
			created_by,
			created,
			id)
		VALUES (
			0,
			0,
			'General',
			'General Workplan',
			'#SYSTEM',
			'Current',
			'#SYSTEM',
			getdate(),
			newid() )
		
		SET IDENTITY_INSERT p_Patient_WP OFF
		END
	ELSE
		BEGIN
		RAISERROR ('p_Patient_WP does not have a zero record',16,-1)
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END


RETURN 1
		
