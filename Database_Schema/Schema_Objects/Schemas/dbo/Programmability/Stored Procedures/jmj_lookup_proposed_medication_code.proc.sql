CREATE PROCEDURE dbo.jmj_lookup_proposed_medication_code (
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(24),
	@pl_code_owner_id int,
	@ps_dosage_form varchar(24) = NULL,
	@ps_package_id varchar(24) = NULL)
AS

IF @ps_treatment_type IS NULL
	BEGIN
	RAISERROR ('Nul treatment_type',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ps_treatment_key IS NULL
	BEGIN
	RAISERROR ('Nul treatment_key',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END


DECLARE @treatmentlist TABLE (
		definition_id int NULL,
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NULL,
		drug_id varchar(24) NULL,
		package_id varchar(24) NULL,
		dosage_form varchar(24) NULL,
		drug_code varchar(80) NULL,
		drug_package_code varchar(80) NULL,
		drug_dosage_form_code varchar(80) NULL,
		drug_common_name varchar(40))

IF @ps_package_id IS NOT NULL
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND dp.package_id = @ps_package_id
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'
ELSE IF @ps_dosage_form IS NOT NULL
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND p.dosage_form = @ps_dosage_form
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'
ELSE
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'

UPDATE t
SET drug_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id
	AND x.epro_domain = 'drug_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_name_id'
WHERE t.drug_id IS NOT NULL

UPDATE t
SET drug_package_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id + '|' + t.package_id
	AND x.epro_domain = 'drug_id|package_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_id'


UPDATE t
SET drug_dosage_form_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.dosage_form
	AND x.epro_domain = 'dosage_form'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_dosage_form_abbr'

UPDATE t
SET drug_common_name = d.common_name
FROM @treatmentlist t
	INNER JOIN c_Drug_Definition d
	ON t.drug_id = d.drug_id

SELECT	definition_id,
		treatment_type ,
		treatment_key ,
		treatment_description ,
		drug_id ,
		package_id ,
		dosage_form ,
		drug_code ,
		drug_package_code ,
		drug_dosage_form_code,
		drug_common_name
FROM @treatmentlist



