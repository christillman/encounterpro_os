  
-- Correct duplicates
SELECT DISTINCT * 
INTO #dedupe
FROM c_Package_Administration_Method
WHERE package_id IN (
	SELECT package_id 
	FROM c_Package_Administration_Method pm 
	GROUP BY pm.administer_method, package_id
	HAVING count(*) > 1
)
AND administer_method IS NOT NULL
-- (107 row(s) affected)

DELETE FROM c_Package_Administration_Method
WHERE package_id IN (
	SELECT package_id 
	FROM c_Package_Administration_Method pm 
	GROUP BY pm.administer_method, package_id
	HAVING count(*) > 1
)
-- (295 row(s) affected)

INSERT INTO c_Package_Administration_Method
SELECT * FROM #dedupe
-- (107 row(s) affected)
-- The original admin methods had been retained when we added the injectables

DELETE FROM [c_Package_Administration_Method]
WHERE administer_method IN ('ASDIR','IN OFFICE')
AND package_id IN (
select distinct a.package_id
from [c_Package_Administration_Method] a 
join [c_Package_Administration_Method] a2
	on a2.package_id = a.package_id
where a.administer_method in 
('IV', 'IM', 'Subcut', 'IM ONLY','IV INFUSION', 'IV ONLY', 
	'IV INFUSION ONLY', 'NERVE BLOCK', 'Subcut ONLY',
	'INTRA-ARTICULAR','INTRAVITREAL', 'CAVERNOSAL', 
	'INTRAOCULAR','LESIONAL','TRIGGER PT','INTRADERMAL')
and a2.administer_method not in 
('IV', 'IM', 'Subcut', 'IM ONLY','IV INFUSION', 'IV ONLY', 
	'IV INFUSION ONLY', 'NERVE BLOCK', 'Subcut ONLY',
	'INTRA-ARTICULAR','INTRAVITREAL', 'CAVERNOSAL', 
	'INTRAOCULAR','LESIONAL','TRIGGER PT','INTRADERMAL')
	)
-- (76 row(s) affected)

-- Remove duplicate less specific administer_methods retained when we 
-- updated administer_method in vw_dose_unit 
DELETE a
-- SELECT distinct a.administer_method, a2.administer_method
FROM [c_Package_Administration_Method] a
join [c_Package_Administration_Method] a2
	on a2.package_id = a.package_id
	and a2.administer_method != a.administer_method
where a.administer_method IN ('APPLY', 'ASDIR', 'PO')
and a2.administer_method NOT IN ('APPLY', 'ASDIR', 'PO')
-- (1133 row(s) affected)

DELETE a
-- SELECT distinct a.administer_method, a2.administer_method
FROM [c_Package_Administration_Method] a
join [c_Package_Administration_Method] a2
	on a2.package_id = a.package_id
	and a2.administer_method != a.administer_method
where (a.administer_method = 'EACH NOSTRIL'
	and a2.administer_method IN ('AFFECTED NOSTRIL', 'SPRAYNOSTRIL'))
or (a.administer_method = 'IN OFFICE'
	and a2.administer_method LIKE 'IMPLANT%')
or (a.administer_method = 'INHALE'
	and a2.administer_method = 'NEBULIZER')
or (a.administer_method = 'APPLY'
	and a2.administer_method = 'PO')
or (a.administer_method IN ('APPLY', 'PO')
	and a2.administer_method = 'ASDIR')
or (a.administer_method = 'SPRAY'
	and a2.administer_method IN ('SPRAYORAL', 'SL'))
or (a.administer_method = 'NEBULIZER'
	and a2.administer_method = 'VAPORIZER')
-- (165 row(s) affected)