CREATE PROCEDURE sp_drug_prescription_flag (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24) = NULL,
	@ps_prescription_flag char(1) OUTPUT)
AS
DECLARE @li_count smallint
IF @ps_package_id IS NULL
	BEGIN
	-- If there are any packages for this drug which don't require a prescription, then return prescription_flag = 'N'
	SELECT @li_count = count(*)
	FROM c_Drug_Package
	WHERE drug_id = @ps_drug_id
	AND NOT (prescription_flag = 'Y')
	IF @li_count > 0
		SELECT @ps_prescription_flag = 'N'
	ELSE
		SELECT @ps_prescription_flag = 'Y'
	END
ELSE
	SELECT @ps_prescription_flag = prescription_flag
	FROM c_Drug_Package
	WHERE drug_id = @ps_drug_id
	AND package_id = @ps_package_id

