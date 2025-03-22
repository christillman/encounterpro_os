
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_disease]
Print 'Drop Procedure [dbo].[jmj_new_disease]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_disease]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_disease]
GO

-- Create Procedure [dbo].[jmj_new_disease]
Print 'Create Procedure [dbo].[jmj_new_disease]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_disease
	(
	@ps_description varchar(80)
	)
AS

DECLARE @ll_owner_id int,
		@ll_disease_id int

IF @ps_description IS NULL
	BEGIN
	RAISERROR ('Disease description cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_disease_id = max(disease_id)
FROM c_Disease
WHERE description = @ps_description

IF @ll_disease_id IS NOT NULL
	RETURN @ll_disease_id

SELECT @ll_disease_id = max(disease_id)
FROM c_Disease

IF @ll_disease_id IS NULL
	SET @ll_disease_id = 1

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

IF @ll_owner_id <> 0 AND @ll_disease_id < 1000000
	SET @ll_disease_id = @ll_disease_id + 1000000

INSERT INTO [c_Disease]
           ([disease_id]
           ,[description]
           ,[display_flag]
           ,[no_vaccine_after_disease]
           ,[sort_sequence]
           ,[status]
           ,[id]
           ,[owner_id])
     VALUES (
           @ll_disease_id
           ,@ps_description
           ,'N'
           ,'N'
           ,999
           ,'OK'
           ,newid()
           ,@ll_owner_id )

IF @@ERROR <> 0
	RETURN -1

RETURN @ll_disease_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_disease]
	TO [cprsystem]
GO

