UPDATE c_Drug_Definition
SET generic_name = 'HydraLAZINE'	
WHERE generic_name = 'HydrazalINE'

-- Remove generics which were added into drug_definition as brands
DELETE -- select * 
FROM c_Drug_Definition
WHERE drug_id IN ('KEGI1537','KEGI9849A')

-- updated erroneously to include 20 ml / 30 ml in the name
UPDATE c_Drug_Definition 
SET generic_name = 'lidocaine'  -- select * from c_Drug_Definition
WHERE drug_id IN ('KEBI9849A','RXNG6387')

-- Missing KE generic definitions
INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT g.drug_id, 
	CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
FROM c_Drug_Generic g
WHERE not exists (select 1 from c_Drug_Definition d where d.drug_id = g.drug_id)
AND generic_rxcui LIKE 'KEGI%' -- Only insert rxcui as drug_id for KE drugs, RXNORM need RXN prefix
-- (17 row(s) affected)

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT g.drug_id,
	CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
FROM c_Drug_Generic g
WHERE not exists (select 1 from c_Drug_Definition d where d.drug_id = g.drug_id)
AND generic_rxcui NOT LIKE 'KEGI%' -- RXNORM need RXN prefix
-- (24 row(s) affected)

-- Missing KE brand definitions
INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT b.drug_id, 
	CASE WHEN LEN(b.brand_name) <= 80 THEN b.brand_name ELSE left(b.brand_name,77) + '...' END, 
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE not exists (select 1 from c_Drug_Definition d where d.drug_id = b.drug_id)
AND b.brand_name_rxcui LIKE 'KEBI%' -- Only insert rxcui as drug_id for KE drugs, RXNORM need RXN prefix

UPDATE d
SET generic_name = g.generic_name
-- select b.drug_id, b.brand_name, g.generic_name
from c_Drug_Definition d
join c_Drug_Brand b ON b.drug_id = d.drug_id
join c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
where d.generic_name is null
and drug_type != 'Vaccine'
-- (168 row(s) affected)

UPDATE d
SET generic_name = g.generic_name
-- select g.drug_id, g.generic_name
from c_Drug_Definition d
join c_Drug_Generic g ON g.drug_id = d.drug_id
where d.generic_name is null
and drug_type != 'Vaccine'

UPDATE d
SET generic_name = 	
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END 
-- select g.drug_id, d.generic_name, g.generic_name
from c_Drug_Definition d
join c_Drug_Generic g ON g.drug_id = d.drug_id
where d.generic_name != g.generic_name
and drug_type != 'Vaccine'
-- (465 row(s) affected)


UPDATE d
SET common_name = 	
	CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END 
-- select g.drug_id, d.common_name, g.generic_name
from c_Drug_Definition d
join c_Drug_Generic g ON g.drug_id = d.drug_id
where d.common_name != g.generic_name
and drug_type != 'Vaccine'
-- (565 row(s) affected)
