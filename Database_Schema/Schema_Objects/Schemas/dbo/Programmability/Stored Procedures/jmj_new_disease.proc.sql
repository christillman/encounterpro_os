CREATE PROCEDURE jmj_new_disease
	(
	@ps_description varchar(80)
	)
AS

DECLARE @ll_owner_id int,
		@ll_disease_id int,
		@ll_count int,
		@ll_error int

IF @ps_description IS NULL
	BEGIN
	RAISERROR ('Disease description cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SELECT @ll_disease_id = max(disease_id)
FROM c_Disease
WHERE description = @ps_description

IF @ll_disease_id IS NOT NULL
	RETURN @ll_disease_id

SELECT @ll_disease_id = max(disease_id)
FROM c_Disease

IF @ll_disease_id IS NULL
	SET @ll_disease_id = 1

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

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

RETURN @ll_disease_id

