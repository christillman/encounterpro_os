CREATE PROCEDURE sp_get_package_id_record (
	@ps_package_id varchar(24) OUTPUT,
	@ps_description varchar(40),
	@ps_administer_method varchar(12),
	@ps_administer_unit varchar(12),
	@ps_dose_unit varchar(12),
	@pr_administer_per_dose real,
	@pr_dose_amount real = 1,
	@ps_dosage_form varchar(24) = NULL,
	@pl_owner_id int )

AS

DECLARE @ll_key_value integer

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

-- See if the package exists
SELECT @ps_package_id = max(package_id)
FROM c_Package
WHERE administer_method = @ps_administer_method
AND administer_unit = @ps_administer_unit
AND dose_unit = @ps_dose_unit
AND administer_per_dose = @pr_administer_per_dose
AND ISNULL(dose_amount, 1) = ISNULL(@pr_dose_amount, 1)
AND description = @ps_description
AND dosage_form = @ps_dosage_form


IF @ps_package_id IS NULL
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'package_ID',
		@pl_key_value = @ll_key_value OUTPUT

	SET @ps_package_id = '!JMJpackage' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_package where package_id = @ps_package_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'package_ID',
			@pl_key_value = @ll_key_value OUTPUT
			
		SET @ps_package_id = '!JMJpackage' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END


	IF @ps_dosage_form IS NULL
		SET @ps_dosage_form = '**'

	INSERT INTO c_package (
		package_id,
		administer_method,
		description,
		administer_unit,
		dose_unit,
		administer_per_dose,
		dose_amount,
		dosage_form,
		id )
	VALUES (
		@ps_package_id,
		@ps_administer_method,
		@ps_description,
		@ps_administer_unit,
		@ps_dose_unit,
		@pr_administer_per_dose,
		@pr_dose_amount,
		@ps_dosage_form,
		newid() )

	END

