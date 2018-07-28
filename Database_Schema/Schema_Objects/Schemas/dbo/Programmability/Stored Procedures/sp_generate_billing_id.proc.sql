CREATE PROCEDURE sp_generate_billing_id (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	--CWW, 01/13/03, dblib to oledb project
	--,@ps_billing_id varchar(24) OUTPUT 
	)
AS

DECLARE @ll_billing_id int,
		@ll_test int,
		@ls_billing_id varchar(24),
		@ll_last_key int

-- Take a lock on the cpr_id lastkey because we might want to update it later
SELECT @ll_last_key = last_key
FROM p_Lastkey (UPDLOCK)
WHERE cpr_id = '!CPR'
AND key_id = 'CPR_ID'

SET @ll_billing_id = CONVERT(int, @ps_cpr_id)

IF @ll_billing_id < 0 or @ll_billing_id IS NULL
	SET @ll_billing_id = 1

WHILE 1 = 1
	BEGIN
	SET @ls_billing_id = CONVERT(varchar(24), @ll_billing_id)
	
	SELECT @ll_test = 1
	WHERE EXISTS (
		SELECT cpr_id
		FROM p_Patient
		WHERE billing_id = @ls_billing_id )
	
	IF @@ROWCOUNT <> 1
		BREAK
	
	SET @ll_billing_id = @ll_billing_id + 1
	END

EXECUTE sp_Set_Patient_Progress
	@ps_cpr_id = @ps_cpr_id,
	@ps_progress_type = 'Modify',
	@ps_progress_key = 'billing_id',
	@ps_progress = @ls_billing_id ,
	@ps_user_id = @ps_user_id,
	@ps_created_by = @ps_created_by

IF @ll_billing_id > @ll_last_key
	UPDATE p_Lastkey
	SET last_key = @ll_billing_id
	WHERE cpr_id = '!CPR'
	AND key_id = 'CPR_ID'

--SET @ps_billing_id = @ls_billing_id

--CWW, 01/13/03, dblib to oledb project
SELECT @ls_billing_id as billing_id


