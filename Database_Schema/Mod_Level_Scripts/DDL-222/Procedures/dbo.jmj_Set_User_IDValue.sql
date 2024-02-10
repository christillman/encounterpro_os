
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_Set_User_IDValue]
Print 'Drop Procedure [dbo].[jmj_Set_User_IDValue]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_Set_User_IDValue]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_Set_User_IDValue]
GO

-- Create Procedure [dbo].[jmj_Set_User_IDValue]
Print 'Create Procedure [dbo].[jmj_Set_User_IDValue]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_Set_User_IDValue (
	@ps_user_id varchar(24),
	@pl_owner_id int,
	@ps_IDDomain varchar(30),
	@ps_IDValue varchar(255),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40),
	@ll_customer_id int,
	@ls_current_value varchar(255),
	@ll_rowcount int,
	@ll_error int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain


-- Make sure this represents a change
SELECT @ls_current_value = COALESCE(progress_value, CAST(progress AS varchar(255)))
FROM c_User_Progress
WHERE [user_id] = @ps_user_id
AND progress_type = 'ID'
AND progress_key = @ls_progress_key
AND current_flag = 'Y'

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount > 0 AND @ls_current_value = @ps_IDValue
	RETURN 1


SELECT @ll_length = LEN(@ps_IDValue)

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_IDValue)


	INSERT INTO c_User_Progress (
		[user_id] ,
		[progress_user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[created] ,
		[created_by] )
	VALUES (@ps_user_id,
		@ps_created_by,
		getdate(),
		'ID',
		@ls_progress_key,
		@ls_progress_value,
		getdate(),
		@ps_created_by )
	END
ELSE
	INSERT INTO c_User_Progress (
		[user_id] ,
		[progress_user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress] ,
		[created] ,
		[created_by] )
	VALUES (@ps_user_id,
		@ps_created_by,
		getdate(),
		'ID',
		@ls_progress_key,
		@ps_IDValue,
		getdate(),
		@ps_created_by )



GO
GRANT EXECUTE
	ON [dbo].[jmj_Set_User_IDValue]
	TO [cprsystem]
GO

