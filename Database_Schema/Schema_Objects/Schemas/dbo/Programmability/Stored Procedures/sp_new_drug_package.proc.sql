CREATE PROCEDURE sp_new_drug_package (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24),
	@ps_prescription_flag char(1) = 'Y',
	@pr_default_dispense_amount real = NULL,
	@ps_default_dispense_unit varchar(12) = NULL,
	@ps_take_as_directed char(1) = 'N',
	@pi_sort_order smallint = NULL )
AS
DECLARE @li_sort_order smallint
IF @pi_sort_order IS NULL
	BEGIN
	SELECT @li_sort_order = max(sort_order)
	FROM c_Drug_Package
	WHERE drug_id = @ps_drug_id
	AND package_id = @ps_package_id
	IF @li_sort_order IS NULL
		SELECT @li_sort_order = 1
	ELSE
		SELECT @li_sort_order = @li_sort_order + 1
	END
ELSE
	SELECT @li_sort_order = @pi_sort_order

IF @ps_default_dispense_unit IS NULL
	SELECT @ps_default_dispense_unit = dose_unit
	FROM c_Package
	WHERE package_id = @ps_package_id

INSERT INTO c_Drug_Package (
	drug_id,
	package_id,
	prescription_flag,
	default_dispense_amount,
	default_dispense_unit,
	take_as_directed,
	sort_order )
VALUES (
	@ps_drug_id,
	@ps_package_id,
	@ps_prescription_flag,
	@pr_default_dispense_amount,
	@ps_default_dispense_unit,
	@ps_take_as_directed,
	@pi_sort_order )

