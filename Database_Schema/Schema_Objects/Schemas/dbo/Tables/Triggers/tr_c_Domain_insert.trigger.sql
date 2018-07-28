CREATE TRIGGER tr_c_Domain_insert ON dbo.c_Domain
FOR INSERT
AS

UPDATE cd
SET domain_item = cd.domain_item_description,
	domain_item_description = NULL
FROM c_Domain cd
	INNER JOIN inserted i
	ON cd.domain_id = i.domain_id
	AND cd.domain_sequence = i.domain_sequence
WHERE cd.domain_id = 'ATTACHMENT_FOLDER'

