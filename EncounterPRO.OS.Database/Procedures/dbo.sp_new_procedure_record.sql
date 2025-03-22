
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_new_procedure_record]
Print 'Drop Procedure [dbo].[sp_new_procedure_record]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_procedure_record]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_procedure_record]
GO

-- Create Procedure [dbo].[sp_new_procedure_record]
Print 'Create Procedure [dbo].[sp_new_procedure_record]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_new_procedure_record (
	@ps_procedure_id varchar(24) OUTPUT,
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@pdc_charge decimal = NULL,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_service varchar(24) = NULL,
	@ps_vaccine_id varchar(24) = NULL,
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL,
	@ps_allow_dup_cpt_code char(1) = 'Y',
	@ps_long_description varchar(max) = NULL,
	@ps_default_location varchar(24)= NULL,
	@ps_bill_assessment_id varchar(24) = NULL,
	@ps_well_encounter_flag char(1) = NULL
	)
AS

DECLARE @ll_key_value integer,
	@ls_old_status varchar(12) ,
	@ll_rows int,
	@ll_count int,
	@ls_trimmed_description varchar(80)

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_allow_dup_cpt_code IS NULL
	SET @ps_allow_dup_cpt_code = 'Y'

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

SELECT TOP 1 @ps_procedure_id = procedure_id,
			@ls_old_status = status
FROM c_Procedure
WHERE procedure_type = @ps_procedure_type
AND description = @ps_description
AND ISNULL(cpt_code, '<Null>') = ISNULL(@ps_cpt_code, '<Null>')
ORDER BY status desc, last_updated desc

-- We didn't find an exact match so see if there's a unique match on cpt_code
IF @ps_procedure_id IS NULL AND @ps_cpt_code IS NOT NULL AND @ps_allow_dup_cpt_code <> 'Y'
	BEGIN
	SELECT @ll_count = COUNT(*)
	FROM c_Procedure
	WHERE cpt_code = @ps_cpt_code
	AND status = 'OK'

	IF @ll_count = 1
		BEGIN
		SELECT TOP 1 @ps_procedure_id = procedure_id,
					@ls_old_status = status
		FROM c_Procedure
		WHERE cpt_code = @ps_cpt_code
		AND status = 'OK'
		END

	END

-- We didn't find a match yet so see if there's match with commas and spaces removed
IF @ps_procedure_id IS NULL
	BEGIN
	SET @ls_trimmed_description = REPLACE(@ps_description, ',', '')
	SET @ls_trimmed_description = REPLACE(@ls_trimmed_description, ' ', '')

	SELECT TOP 1 @ps_procedure_id = procedure_id,
				@ls_old_status = status
	FROM c_Procedure
	WHERE REPLACE(REPLACE(description, ',', ''), ' ', '') = @ls_trimmed_description
	AND ISNULL(cpt_code, '<Null>') = ISNULL(@ps_cpt_code, '<Null>')
	ORDER BY status desc, last_updated desc

	END

IF @ps_procedure_id IS NOT NULL
	BEGIN
	IF @ls_old_status <> 'OK' AND @ps_status = 'OK'
		UPDATE c_Procedure
		SET status = @ps_status
		WHERE procedure_id = @ps_procedure_id
	END
ELSE
	BEGIN

	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'PROCEDURE_ID',
		@pl_key_value = @ll_key_value OUTPUT
	SELECT @ps_procedure_id = office_id + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
	FROM o_Office
	WHILE exists(select * from c_Procedure where procedure_id = @ps_procedure_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'PROCEDURE_ID',
			@pl_key_value = @ll_key_value OUTPUT
		SELECT @ps_procedure_id = office_id + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		FROM o_Office
		END

	IF @ps_default_bill_flag IS NULL
		SET @ps_default_bill_flag = 'Y'

	INSERT INTO c_Procedure (
		procedure_id,
		procedure_type,
		cpt_code,
		charge,
		procedure_category_id,
		description,
		service,
		vaccine_id,
		units,
		modifier,
		other_modifiers,
		billing_id,
		location_domain,
		risk_level,
		status,
		default_bill_flag,
		owner_id,
		definition,
		original_cpt_code,
		long_description,
		default_location,
		bill_assessment_id,
		well_encounter_flag
 )
	VALUES (
		@ps_procedure_id,
		@ps_procedure_type,
		@ps_cpt_code,
		CAST(@pdc_charge AS money),
		@ps_procedure_category_id,
		@ps_description,
		@ps_service,
		@ps_vaccine_id,
		@pr_units,
		@ps_modifier,
		@ps_other_modifiers,
		@ps_billing_id,
		@ps_location_domain,
		@pi_risk_level,
		@ps_status,
		@ps_default_bill_flag,
		@pl_owner_id,
		@ps_description,
		@ps_cpt_code,
		@ps_long_description,
		@ps_default_location,
		@ps_bill_assessment_id,
		@ps_well_encounter_flag
		 )
	END


GO
GRANT EXECUTE
	ON [dbo].[sp_new_procedure_record]
	TO [cprsystem]
GO

