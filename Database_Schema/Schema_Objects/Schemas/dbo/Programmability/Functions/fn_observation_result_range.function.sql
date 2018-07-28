CREATE FUNCTION fn_observation_result_range (
	@ps_cpr_id varchar(12),
	@ps_ordered_by varchar(24),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_sex char(1),
	@pdt_date_of_birth datetime,
	@ps_result_value varchar(40),
	@ps_result_unit varchar(12),
	@pdt_current_date datetime )

RETURNS @abnormal TABLE (
	[normal_range] [varchar] (40) NULL ,
	[abnormal_flag] [char] (1) NULL ,
	[abnormal_nature] [varchar] (8) NULL ,
	[severity] [smallint] NULL,
	[workplan_id] [int] NULL )

AS

BEGIN

DECLARE @ls_unit_id varchar (12) ,
	@lr_low_limit real ,
	@lr_low_normal real ,
	@lr_high_normal real ,
	@lr_high_limit real ,
	@ls_inclusive_flag char (1) ,
	@ls_low_nature varchar (8) ,
	@ls_high_nature varchar (8) ,
	@li_low_severity smallint ,
	@li_high_severity smallint ,
	@ls_normal_range varchar (40) ,
	@ll_reference_material_id int ,
	@lr_original_value real ,
	@lr_result_value real ,
	@ll_workplan_id int

IF ISNUMERIC(@ps_result_value) <> 1 OR LTRIM(RTRIM(@ps_result_value)) = '.'
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

-- See if there's a custom range rule for this result
INSERT INTO @abnormal (
	[normal_range] ,
	[abnormal_flag] ,
	[abnormal_nature] ,
	[severity] )
SELECT [normal_range] ,
	[abnormal_flag] ,
	[abnormal_nature] ,
	[severity]
FROM dbo.fn_observation_custom_range(@ps_cpr_id,
									@ps_observation_id ,
									@pi_result_sequence ,
									@ps_sex ,
									@pdt_date_of_birth ,
									@ps_result_value ,
									@ps_result_unit ,
									@pdt_current_date )

IF @@ROWCOUNT > 0
	RETURN

SET @lr_original_value = CAST(@ps_result_value AS real)
SET @ps_cpr_id = ISNULL(@ps_cpr_id, '@')
SET @ps_ordered_by = ISNULL(@ps_ordered_by, '@')
SET @ps_sex = ISNULL(@ps_sex, '@')

SELECT 	TOP 1 @ls_unit_id = unit_id,
		@lr_low_limit = low_limit,
		@lr_low_normal = low_normal,
		@lr_high_normal = high_normal,
		@lr_high_limit = high_limit,
		@ls_inclusive_flag = inclusive_flag,
		@ls_low_nature = low_nature,
		@ls_high_nature = high_nature,
		@li_low_severity = low_severity,
		@li_high_severity = high_severity,
		@ls_normal_range = normal_range,
		@ll_reference_material_id = reference_material_id,
		@ll_workplan_id = abnormal_workplan_id
FROM c_Observation_Result_Range
WHERE observation_id = @ps_observation_id
AND result_sequence = @pi_result_sequence
AND (cpr_id IS NULL OR ISNULL(cpr_id, '@') = @ps_cpr_id)
AND (ordered_by IS NULL OR ISNULL(ordered_by, '@') = @ps_ordered_by)
AND (sex IS NULL OR ISNULL(sex, '@') = @ps_sex)
AND (age_range_id IS NULL OR dbo.fn_age_range_compare(age_range_id, @pdt_date_of_birth, @pdt_current_date) = 0)
AND dbo.fn_is_unit_convertible (unit_id, @ps_result_unit) = 1
ORDER BY search_sequence

-- If we don't find a record then just return nulls
IF @@ROWCOUNT = 0
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

SET @lr_result_value = dbo.fn_convert_units(@lr_original_value, @ps_result_unit, @ls_unit_id)

-- If we can't make the conversion then return nulls
IF @lr_result_value IS NULL
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		NULL,
		NULL,
		NULL,
		NULL )
	
	RETURN
	END

IF @lr_result_value < @lr_low_normal
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] ,
		[workplan_id] )
	VALUES (
		@ls_normal_range,
		'Y',
		@ls_low_nature,
		@li_low_severity,
		@ll_workplan_id )
	END
ELSE IF @lr_result_value > @lr_high_normal
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] ,
		[workplan_id] )
	VALUES (
		@ls_normal_range,
		'Y',
		@ls_high_nature,
		@li_high_severity,
		@ll_workplan_id )
	END
ELSE
	BEGIN
	INSERT INTO @abnormal (
		[normal_range] ,
		[abnormal_flag] ,
		[abnormal_nature] ,
		[severity] )
	VALUES (
		@ls_normal_range,
		'N',
		NULL ,
		NULL )
	END


RETURN
END

