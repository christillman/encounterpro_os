
UPDATE c_Drug_Generic
SET generic_name = dbo.fn_tallman(generic_name)
WHERE dbo.fn_needs_tallman(generic_name) = 1