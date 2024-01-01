-- Remove duplicate keys from c_Drug_Generic
select * into #g_dupe 
from c_Drug_Generic where generic_rxcui in
	(select generic_rxcui from c_Drug_Generic group by generic_rxcui having count(*) > 1)
if @@rowcount > 0
	BEGIN
		DELETE FROM c_Drug_Generic where generic_rxcui in
				(select generic_rxcui from c_Drug_Generic group by generic_rxcui having count(*) > 1)
		INSERT INTO c_Drug_Generic 
		SELECT DISTINCT * FROM #g_dupe
	END

-- Generics needing to come in from RXNORM_FULL, replacing Kenya ones
DELETE FROM c_Drug_Generic WHERE generic_rxcui IN ('KEGI11997','203218','KEGI1093')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('Pyrimethamine / Sulfadoxine', '203218', 0, 'RXNG203218'),
-- IN from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
('aceclofenac', '16689', 1, 'RXNG16689'),
('Cephradine', '2239', 1, 'RXNG2239'),
('Cinnarizine', '2549', 1, 'RXNG2549'),
('Cloxacillin', '2625', 1, 'RXNG2625'),
('Dexketoprofen', '237162', 1, 'RXNG237162'),
('ebastine', '23796', 1, 'RXNG23796'),
('Ethamsylate', '4112', 1, 'RXNG4112'),
('etofenamate', '24608', 1, 'RXNG24608'),
('etoricoxib', '307296', 1, 'RXNG307296'),
('Gliclazide', '4816', 1, 'RXNG4816'),
('gliquidone', '25793', 1, 'RXNG25793'),
('lornoxicam', '20890', 1, 'RXNG20890'),
('Piracetam', '8351', 1, 'RXNG8351'),
('Silymarin', '9794', 1, 'RXNG9794'),
('thiocolchicoside', '38085', 1, 'RXNG38085'),
('zopiclone', '40001', 1, 'RXNG40001'),
-- PIN from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
('Ambroxol', '438399', 1, 'RXNG438399'),
('butylscopolamine bromide', '1851', 1, 'RXNG1851'),
('Calcium Dobesilate', '1904', 1, 'RXNG1904'),
('diloxanide furoate', '23203', 1, 'RXNG23203'),
('Mefenamic Acid', '6693', 1, 'RXNG6693'),
('Nalidixic Acid', '7240', 1, 'RXNG7240'),
('Ursodiol', '11065', 1, 'RXNG11065'),
-- MIN from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
('Atenolol / Nifedipine', '392475', 0, 'RXNG392475'),
('Clotrimazole / Hydrocortisone', '262272', 0, 'RXNG262272'),
('Fluphenazine / Nortriptyline', '644529', 0, 'RXNG644529'),
('Ibuprofen / LEVOMENTHOL', '687386', 0, 'RXNG687386'),
('Indapamide / Perindopril', '388499', 0, 'RXNG388499'),
('Ampicillin / Cloxacillin', '106846', 0, 'RXNG106846')
-- (32 row(s) affected)

-- Remove resulting duplicates of generic names 
SELECT DISTINCT g1.generic_rxcui, g2.generic_rxcui as ke
INTO #excess_generic
FROM c_Drug_Generic g1
JOIN c_Drug_Generic g2 
	ON g1.generic_name = g2.generic_name
	AND g1.generic_rxcui != g2.generic_rxcui
WHERE g2.generic_rxcui like 'KEG%'

UPDATE f
SET ingr_rxcui = e.generic_rxcui
-- select ingr_rxcui, e.generic_rxcui
FROM c_Drug_Formulation f
JOIN #excess_generic e ON e.ke = f.ingr_rxcui
-- (32 row(s) affected)

UPDATE b
SET generic_rxcui = e.generic_rxcui
-- select b.generic_rxcui, e.generic_rxcui
FROM c_Drug_Brand b
JOIN #excess_generic e ON e.ke = b.generic_rxcui

-- delete the excess ones
DELETE g2
-- SELECT DISTINCT g1.generic_rxcui, g2.generic_rxcui
FROM c_Drug_Generic g1
JOIN c_Drug_Generic g2 
	ON g1.generic_name = g2.generic_name
	AND g1.generic_rxcui != g2.generic_rxcui
WHERE g2.generic_rxcui like 'KEG%'

-- Remove drug_definitions which were added with extra bits like HCl and sulfate
DELETE d
-- SELECT d.drug_id,  d.common_name, d.generic_name
FROM c_Drug_Definition d
WHERE d.common_name = d.generic_name
AND drug_id LIKE 'KEGI%'
AND NOT EXISTS (SELECT 1 FROM
	c_Drug_Generic g where g.drug_id = d.drug_id
	)
-- (123 row(s) affected)
