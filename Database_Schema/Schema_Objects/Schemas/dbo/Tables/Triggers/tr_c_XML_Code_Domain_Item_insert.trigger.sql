CREATE TRIGGER tr_c_XML_Code_Domain_Item_insert ON dbo.c_XML_Code_Domain_Item
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

----------------------------------------------------------
-- Make sure the domain and domain item tables are current
----------------------------------------------------------
INSERT INTO c_XML_Code (
		owner_id ,
		code_domain ,
		code_version ,
		code ,
		code_description ,
		epro_domain ,
		created_by ,
		status)
SELECT 	i.owner_id ,
		i.code_domain ,
		i.code_version ,
		i.code ,
		i.code_description ,
		d.epro_domain ,
		'#SYSTEM',
		'Unmapped'
FROM inserted i
	INNER JOIN c_XML_Code_Domain d
	ON d.owner_id = i.owner_id
	AND d.code_domain = i.code_domain
WHERE d.epro_domain IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM [dbo].[c_XML_Code] c
	WHERE c.owner_id = i.owner_id
	AND c.code_domain = i.code_domain
	AND c.code = i.code
	)


UPDATE e
SET status = 'NA'
FROM c_XML_Code_Domain_Item e
	INNER JOIN inserted i
	ON e.owner_id = i.owner_id
	AND e.code_domain = i.code_domain
	AND ISNULL(e.code_version, '!NULL') = ISNULL(i.code_version, '!NULL')
	AND e.code = i.code
WHERE i.status = 'OK'
AND e.status = 'OK'
AND e.code_domain_item_id < i.code_domain_item_id

