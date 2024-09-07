
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_new_assessment]
Print 'Drop Procedure [dbo].[sp_new_assessment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_assessment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_assessment]
GO

-- Create Procedure [dbo].[sp_new_assessment]
Print 'Create Procedure [dbo].[sp_new_assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_new_assessment (
	@ps_assessment_type varchar(24),
	@ps_icd10_code varchar(12) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_location_domain varchar(12) = NULL,
	@ps_auto_close char(1) = 'N',
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description varchar(max) = NULL ,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL,
	@ps_assessment_id varchar(24) OUTPUT,
	@ps_allow_dup_icd10_code char(1) = 'Y' )
AS

DECLARE @ll_key_value integer ,
	@ls_assessment_id varchar(24) ,
	@ls_old_status varchar(12) ,
	@ll_rows int,
	@ll_count int,
	@ls_trimmed_description varchar(80),
	@ls_key varchar(20),
	@ll_key_suffix int,
	@ls_long_description_varchar nvarchar(max)

IF @ps_description IS NULL OR @ps_description = ''
	BEGIN
	RAISERROR ('New assessment must have a description',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_allow_dup_icd10_code IS NULL
	SET @ps_allow_dup_icd10_code = 'Y'

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

SET @ls_long_description_varchar = CAST(@ps_long_description AS nvarchar(max))

SELECT TOP 1 @ps_assessment_id = assessment_id,
			@ls_old_status = status
FROM c_Assessment_Definition
WHERE assessment_type = @ps_assessment_type
AND description = @ps_description
AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
AND ISNULL(CAST(long_description AS nvarchar(max)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
ORDER BY status desc, last_updated desc

SET @ll_rows = @@ROWCOUNT

-- We didn't find an exact match so see if there's a unique match on icd10_code
IF @ll_rows = 0 AND @ps_icd10_code IS NOT NULL AND @ps_allow_dup_icd10_code <> 'Y'
	BEGIN
	SELECT @ll_count = COUNT(*)
	FROM c_Assessment_Definition
	WHERE icd10_code = @ps_icd10_code
	AND status = 'OK'

	IF @ll_count = 1
		BEGIN
		SELECT TOP 1 @ps_assessment_id = assessment_id,
					@ls_old_status = status
		FROM c_Assessment_Definition
		WHERE icd10_code = @ps_icd10_code
		AND status = 'OK'

		SET @ll_rows = @@ROWCOUNT
		END

	END

-- We didn't find a match yet so see if there's match with commas and spaces removed
IF @ll_rows = 0
	BEGIN
	SET @ls_trimmed_description = REPLACE(@ps_description, ',', '')
	SET @ls_trimmed_description = REPLACE(@ls_trimmed_description, ' ', '')

	SELECT TOP 1 @ps_assessment_id = assessment_id,
				@ls_old_status = status
	FROM c_Assessment_Definition
	WHERE REPLACE(REPLACE(description, ',', ''), ' ', '') = @ls_trimmed_description
	AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
	AND ISNULL(CAST(long_description AS nvarchar(max)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
	ORDER BY status desc, last_updated desc

	SET @ll_rows = @@ROWCOUNT

	END

IF @ll_rows = 1
	BEGIN
	IF @ls_old_status <> 'OK' AND @ps_status = 'OK'
		UPDATE c_Assessment_Definition
		SET status = @ps_status
		WHERE assessment_id = @ps_assessment_id
	END
ELSE
	BEGIN
	SET @ls_key = CAST(@pl_owner_id AS varchar(12)) + '^'
	
	IF LEN(@ps_icd10_code) >= 3
		SET @ls_key = @ls_key + @ps_icd10_code
	ELSE
		SET @ls_key = @ls_key + CAST(@ps_description AS varchar(12))
	
	SET @ls_key = @ls_key + '^'
	
	
	create table #temp (value varchar(100))
	insert into #temp
	EXECUTE sp_get_char_key 'c_Assessment', 'assessment_id', @ls_key
	
	SELECT top 1 @ls_assessment_id = value from #temp

	INSERT INTO c_Assessment_Definition (
		assessment_id,
		assessment_type,
		icd10_code,
		assessment_category_id,
		description,
		location_domain,
		auto_close,
		auto_close_interval_amount,
		auto_close_interval_unit,
		risk_level,
		complexity,
		owner_id,
		status,
		definition )
	VALUES (
		@ls_assessment_id,
		@ps_assessment_type,
		@ps_icd10_code,
		@ps_assessment_category_id,
		@ps_description,
		@ps_location_domain,
		@ps_auto_close,
		@pi_auto_close_interval_amount,
		@ps_auto_close_interval_unit,
		@pl_risk_level,
		@pl_complexity,
		@pl_owner_id,
		@ps_status,
		@ps_description)

	IF @ps_long_description IS NOT NULL
		UPDATE c_Assessment_Definition
		SET long_description = @ps_long_description
		WHERE assessment_id = @ls_assessment_id

	SET @ps_assessment_id = @ls_assessment_id
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_new_assessment]
	TO [cprsystem]
GO

