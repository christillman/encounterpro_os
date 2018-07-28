CREATE PROCEDURE xml_set_default_mapping (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64)
	)
AS

-- Switch
UPDATE c_XML_Code
SET unique_flag = CASE epro_id WHEN @ps_epro_id THEN 1 ELSE 0 END
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain
AND ISNULL(code_version, '!NULL') = ISNULL(@ps_code_version, '!NULL')
AND code = @ps_code
AND epro_domain = @ps_epro_domain
AND unique_flag <> CASE epro_id WHEN @ps_epro_id THEN 1 ELSE 0 END

UPDATE c_XML_Code
SET unique_flag = CASE code WHEN @ps_code THEN 1 ELSE 0 END
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain
AND ISNULL(code_version, '!NULL') = ISNULL(@ps_code_version, '!NULL')
AND epro_domain = @ps_epro_domain
AND epro_id = @ps_epro_id
AND unique_flag <> CASE code WHEN @ps_code THEN 1 ELSE 0 END

