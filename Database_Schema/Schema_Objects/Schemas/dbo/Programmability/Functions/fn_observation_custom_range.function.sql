CREATE FUNCTION fn_observation_custom_range (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_sex char(1),
	@pdt_date_of_birth datetime,
	@ps_result_value varchar(40) ,
	@ps_result_unit varchar(12),
	@pdt_current_date datetime )

RETURNS @abnormal TABLE (
	[normal_range] [varchar] (40) NULL ,
	[abnormal_flag] [char] (1) NULL ,
	[abnormal_nature] [varchar] (8) NULL ,
	[severity] [smallint] NULL )

AS

BEGIN

DECLARE @ls_result_value varchar(40) ,
		@ls_result_unit varchar(12) ,
		@lr_height real,
		@ll_peak_flow int,
		@ll_ideal int,
		@ls_normal_range varchar(40),
		@ll_green int,
		@ll_yellow int


-- Calculate the Peak Flow normal range using the patient height
IF @ps_observation_id = 'PEAK' AND @pi_result_sequence = -1
	BEGIN
	-- Get the last height
	SELECT @ls_result_value = result_value,
			@ls_result_unit = result_unit
	FROM dbo.fn_patient_observation_last_result(@ps_cpr_id, 'HGT', -1)
	WHERE result_date_time >= DATEADD(year, -1, @pdt_current_date)

	-- If there is no height then we're done
	IF @@ROWCOUNT <> 1 OR ISNUMERIC(@ls_result_value) <> 1
		BEGIN
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			'No Recent Height Available',
			'Y',
			'No Hgt',
			3 )
		
		RETURN
		END

	-- Convert the peak flow value to an integer
	SET @ll_peak_flow = CAST(@ps_result_value AS int)

	-- Convert to a real and then convert to CM
	SET @lr_height = dbo.fn_convert_units(CAST(@ls_result_value AS real), @ls_result_unit, 'CM')

	-- Calculate thresholds
	SET @ll_ideal = (@lr_height - 80) * 5
	SET @ll_green = 0.8 * @ll_ideal
	SET @ll_yellow = 0.5 * @ll_ideal

	-- Create the normal range string
	SET @ls_normal_range = CAST(@ll_green AS varchar(8)) + ' - ' + CAST(@ll_ideal AS varchar(8))
	SET @ls_normal_range = @ls_normal_range + ' (Hgt = ' + CAST(CAST(@lr_height AS decimal(6,1)) as varchar(8)) + 'cm)'
	
	IF @ll_peak_flow >= @ll_green
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'N',
			NULL,
			1 )
	ELSE IF @ll_peak_flow >= @ll_yellow
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'Y',
			'Yellow',
			3 )
	ELSE
		INSERT INTO @abnormal (
			[normal_range] ,
			[abnormal_flag] ,
			[abnormal_nature] ,
			[severity] )
		VALUES (
			@ls_normal_range,
			'Y',
			'Red',
			4 )
	
	END

RETURN
END

