
-- Tidy up
UPDATE c_Drug_Pack
SET descr = REPLACE(descr, '  ', ' ')
WHERE descr like '%  %'
UPDATE c_Drug_Pack
SET descr = REPLACE(descr, ' )', ')')
WHERE descr like '% )%'
UPDATE c_Drug_Pack
SET descr = '"Co-Arinate FDC Junior" { 3 (artesunate 100 MG / sulfamethoxypyrazine 250 MG / pyrimethamine 12.5 MG Oral Tablet) } Pack'
WHERE descr = '"Co-Arinate FDC Junior{ 3 (artesunate 100 MG / sulfamethoxypyrazine 250 MG / pyrimethamine 12.5 MG Oral Tablet) } Pack'

