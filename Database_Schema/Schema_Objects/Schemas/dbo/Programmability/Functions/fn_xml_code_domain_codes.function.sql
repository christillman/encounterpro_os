CREATE FUNCTION fn_xml_code_domain_codes (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@pl_document_patient_workplan_item_id int
	 )

RETURNS @codes TABLE (
	code varchar(80) NOT NULL,
	code_description varchar(80) NULL,
	epro_domain varchar(64) NOT NULL,
	default_code_id int NULL,
	default_epro_id varchar(64) NULL,
	default_epro_description varchar(80) NULL,
	default_epro_owner_id int NULL,
	default_mapping_owner_id int NULL,
	default_mapping_owner_status varchar(12) NULL,
	default_status varchar(12) NULL,
	mapping_count int NOT NULL DEFAULT(0),
	exists_in_document bit NOT NULL DEFAULT (0),
	failed_in_document bit NOT NULL DEFAULT (0)
	)
AS
BEGIN

DECLARE @ll_code_id int,
		@ls_code_version varchar(40),
		@ll_error int,
		@ll_rowcount int,
		@ll_customer_id int

DECLARE @candidates TABLE (
	code_sequence int IDENTITY (1, 1) NOT NULL ,
	code varchar(80) NOT NULL,
	epro_domain varchar(64) NOT NULL,
	code_id int NOT NULL,
	[status] varchar(12) NOT NULL,
	unique_flag bit NOT NULL
	)

SET @ls_code_version = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

INSERT INTO @codes (
	code,
	epro_domain)
SELECT DISTINCT code,
	epro_domain
FROM c_XML_Code  
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain
AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
AND [status] IN ('OK', 'Unmapped')
AND code IS NOT NULL
AND epro_domain IS NOT NULL

INSERT INTO @candidates (
	code ,
	epro_domain ,
	code_id ,
	status ,
	unique_flag)
SELECT c.code ,
	c.epro_domain ,
	c.code_id ,
	c.status ,
	c.unique_flag
FROM c_XML_Code c
	INNER JOIN @codes x
	ON c.owner_id = @pl_owner_id
	AND c.code_domain = @ps_code_domain
	AND c.code = x.code
	AND c.epro_domain = x.epro_domain
WHERE c.mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
AND c.[status] IN ('OK', 'Unmapped')
ORDER BY CASE c.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
		CASE c.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END

UPDATE c
SET default_code_id = x2.code_id
FROM @codes c
	INNER JOIN (SELECT code, epro_domain, min_code_sequence = min(code_sequence)
				FROM @candidates
				WHERE unique_flag = 1
				GROUP BY code, epro_domain) x
	ON c.code = x.code
	AND c.epro_domain = x.epro_domain
	INNER JOIN @candidates x2
	ON c.code = x2.code
	AND c.epro_domain = x2.epro_domain
	AND x.min_code_sequence = x2.code_sequence

UPDATE c
SET default_code_id = x2.code_id
FROM @codes c
	INNER JOIN (SELECT code, epro_domain, min_code_sequence = min(code_sequence)
				FROM @candidates
				GROUP BY code, epro_domain) x
	ON c.code = x.code
	AND c.epro_domain = x.epro_domain
	INNER JOIN @candidates x2
	ON c.code = x2.code
	AND c.epro_domain = x2.epro_domain
	AND x.min_code_sequence = x2.code_sequence
WHERE c.default_code_id IS NULL

UPDATE c
SET mapping_count = x.mapping_count
FROM @codes c
	INNER JOIN (SELECT code, epro_domain, mapping_count = count(*)
				FROM @candidates
				WHERE status = 'OK'
				GROUP BY code, epro_domain) x
	ON c.code = x.code
	AND c.epro_domain = x.epro_domain

UPDATE x
SET code_description = c.code_description,
	default_epro_id = c.epro_id,
	default_epro_description = c.epro_description,
	default_epro_owner_id = c.epro_owner_id,
	default_mapping_owner_id = c.mapping_owner_id,
	default_mapping_owner_status = CASE c.mapping_owner_id WHEN @ll_customer_id THEN 'Local' WHEN 0 THEN 'EncounterPRO' ELSE 'Interface' END,
	default_status = c.[status]
FROM @codes x
	INNER JOIN c_XML_Code c
	ON x.default_code_id = c.code_id

UPDATE x
SET exists_in_document = 1,
	failed_in_document = y.failed_in_document
FROM @codes x
	INNER JOIN ( SELECT c.code,
						c.epro_domain,
						failed_in_document = max(CASE WHEN m.map_action = 'Fail' AND c.status = 'Unmapped' THEN 1 ELSE 0 END)
				FROM x_Document_Mapping m
					INNER JOIN c_XML_Code c
					ON m.code_id = c.code_id
				WHERE m.patient_workplan_item_id = @pl_document_patient_workplan_item_id
				GROUP BY c.code,
						c.epro_domain) y
	ON x.code = y.code
	AND x.epro_domain = y.epro_domain


RETURN
END
