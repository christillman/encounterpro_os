
-- Correct duplicates found 12/22/2020 e.g. Aranesp
SELECT DISTINCT * 
INTO #dedupe
FROM c_Package_Administration_Method
WHERE package_id IN (
	SELECT package_id 
	FROM c_Package_Administration_Method pm 
	GROUP BY pm.administer_method, package_id
	HAVING count(*) > 1
)
-- (64 row(s) affected)

DELETE FROM c_Package_Administration_Method
WHERE package_id IN (
	SELECT package_id 
	FROM c_Package_Administration_Method pm 
	GROUP BY pm.administer_method, package_id
	HAVING count(*) > 1
)
-- (128 row(s) affected)

INSERT INTO c_Package_Administration_Method
SELECT * FROM #dedupe
-- (64 row(s) affected)