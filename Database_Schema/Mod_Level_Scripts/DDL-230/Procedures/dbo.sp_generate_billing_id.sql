
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_generate_billing_id]
Print 'Drop Procedure [dbo].[sp_generate_billing_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_generate_billing_id]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_generate_billing_id]
GO

-- Create Procedure [dbo].[sp_generate_billing_id]
Print 'Create Procedure [dbo].[sp_generate_billing_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_generate_billing_id (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
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
	
	IF @ll_test IS NULL
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

SELECT @ls_billing_id as billing_id


GO
GRANT EXECUTE
	ON [dbo].[sp_generate_billing_id]
	TO [cprsystem]
GO

