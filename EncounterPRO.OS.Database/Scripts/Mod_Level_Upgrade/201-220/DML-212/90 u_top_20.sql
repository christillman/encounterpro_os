﻿
UPDATE u
SET u.item_text = 
	CASE WHEN d.common_name = d.generic_name 
		THEN d.generic_name  
		WHEN d.generic_name IS NULL THEN d.common_name
	ELSE d.common_name + ' (' + d.generic_name + ')' END
FROM u_top_20 u
JOIN c_Drug_Definition d ON d.drug_id = u.item_id
where item_id in (select drug_id from c_Drug_Definition)
and (top_20_code like '%MED%' 
	) -- or top_20_code like '%VAC%') -- maybe not vaccines? have detailed names
and u.item_text != 
	CASE WHEN d.common_name = d.generic_name 
		THEN d.generic_name  
		WHEN d.generic_name IS NULL THEN d.common_name
	ELSE d.common_name + ' (' + d.generic_name + ')' END
-- (80 row(s) affected)

-- Only the names have been changed ...
UPDATE u
SET item_id = d.drug_id, item_text = CASE WHEN d.common_name = d.generic_name 
		THEN d.generic_name 
	ELSE d.common_name + ' (' + d.generic_name + ')' END
from u_top_20 u
JOIN c_Drug_Definition d ON item_text like '%' + d.common_name + '%'
where  top_20_code = 'MEDICATION'
and item_id is not null
AND NOT EXISTS( Select 1 from c_Drug_Definition d where d.drug_id = u.item_id)
