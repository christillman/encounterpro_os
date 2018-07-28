CREATE PROCEDURE sp_Set_User_Progress (
	@ps_user_id varchar(24),
	@ps_progress_user_id varchar(24),
	@pdt_progress_date_time datetime = NULL,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL ,
	@ps_created_by varchar(24) )
AS

DECLARE @ll_length int,
	@ls_progress_value varchar(40)



-- If it's a realtime encounter, then use the current datetime.
-- Otherwise, use the encounter date
IF @pdt_progress_date_time IS NULL
	SET @pdt_progress_date_time = getdate()

SELECT @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_progress)

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
		@ps_progress_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
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
		@ps_progress_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		getdate(),
		@ps_created_by )



