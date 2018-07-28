CREATE PROCEDURE sp_new_drug_definition (
	@ps_drug_type varchar(24),
	@ps_common_name varchar(40),
	@ps_generic_name varchar(80),
	@ps_status varchar(12) = 'OK',
	@ps_controlled_substance_flag varchar(12) = 'Y',
	@pr_default_duration_amount real = NULL,
	@ps_default_duration_unit varchar(12) = NULL,
	@ps_default_duration_prn varchar(32) = NULL,
	@pr_max_dose_per_day real = NULL,
	@ps_max_dose_unit varchar(12) = NULL,
	@pl_owner_id int = NULL,
	@ps_drug_id varchar(24) OUTPUT )

AS

DECLARE @ll_key_value integer,
	@ls_drug_id varchar(24),
	@ls_status varchar(12)

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_drug_type IS NULL OR @ps_drug_type = '' OR @ps_drug_type = 'Drug'
	SET @ps_drug_type = 'Single Drug'

IF @ps_common_name IS NULL OR @ps_common_name = ''
	BEGIN
	RAISERROR ('No common name supplied',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- See if drug already exists with drug_type/common_name combination
SELECT TOP 1 @ps_drug_id = drug_id,
			@ls_status = status
FROM c_Drug_Definition
WHERE drug_type = @ps_drug_type
AND common_name = @ps_common_name
ORDER BY status desc

IF @@ROWCOUNT <= 0 OR @ps_drug_id IS NULL
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'DRUG_ID',
		@pl_key_value = @ll_key_value OUTPUT
		
	SET @ls_drug_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_Drug_Definition where drug_id = @ls_drug_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'DRUG_ID',
			@pl_key_value = @ll_key_value OUTPUT
			
		SET @ls_drug_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END


	INSERT INTO c_Drug_Definition (
		drug_id,
		drug_type,
		common_name,
		generic_name,
		status ,
		controlled_substance_flag ,
		default_duration_amount ,
		default_duration_unit ,
		default_duration_prn ,
		max_dose_per_day ,
		max_dose_unit ,
		owner_id )
	VALUES (
		@ls_drug_id,
		@ps_drug_type,
		@ps_common_name,
		@ps_generic_name,
		@ps_status ,
		@ps_controlled_substance_flag ,
		@pr_default_duration_amount ,
		@ps_default_duration_unit ,
		@ps_default_duration_prn ,
		@pr_max_dose_per_day ,
		@ps_max_dose_unit ,
		@pl_owner_id )

	SET @ps_drug_id = @ls_drug_id
	END
ELSE
	BEGIN
	IF @ls_status = 'NA' AND @ps_status = 'OK'
		UPDATE c_Drug_Definition
		SET status = 'OK'
		WHERE drug_id = @ps_drug_id
	
	END
	
