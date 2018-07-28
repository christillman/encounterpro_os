CREATE PROCEDURE sp_get_todo_list_30
(
	@ps_user_id varchar(24),
	@ps_office_id varchar(4) = NULL,
	@pc_active_service_flag char(1) = 'Y',
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
)
AS

-- The pdt_begin_date and pdt_end_date parameters are ignored if the
-- pc_active_service_flag parameter = 'Y'

IF @ps_office_id = ''
	SET @ps_office_id = NULL

IF @pc_active_service_flag = '%' 
	SET @pc_active_service_flag = 'Y'

IF @ps_office_id IS NULL
	BEGIN
	-- Break it into two queries because the query optimizer isn't selecting a different index based on the value
	-- of @pc_active_service_flag
	IF @pc_active_service_flag = 'Y'
		EXECUTE sp_get_todo_list_null_y
			@ps_user_id = @ps_user_id
	ELSE
		EXECUTE sp_get_todo_list_null_n
			@ps_user_id = @ps_user_id,
			@pdt_begin_date = @pdt_begin_date,
			@pdt_end_date = @pdt_end_date
	END
ELSE
	BEGIN
	-- Break it into two queries because the query optimizer isn't selecting a different index based on the value
	-- of @pc_active_service_flag
	IF @pc_active_service_flag = 'Y'
		BEGIN
		IF @ps_office_id = '%'
			EXECUTE sp_get_todo_list_pct_y
				@ps_user_id = @ps_user_id
		ELSE
			EXECUTE sp_get_todo_list_notpct_y
				@ps_user_id = @ps_user_id,
				@ps_office_id = @ps_office_id
		END
	ELSE
		BEGIN
		IF @ps_office_id = '%'
			EXECUTE sp_get_todo_list_pct_n
				@ps_user_id = @ps_user_id,
				@pdt_begin_date = @pdt_begin_date,
				@pdt_end_date = @pdt_end_date
		ELSE
			EXECUTE sp_get_todo_list_notpct_n
				@ps_user_id = @ps_user_id,
				@ps_office_id = @ps_office_id,
				@pdt_begin_date = @pdt_begin_date,
				@pdt_end_date = @pdt_end_date
		END
	END

