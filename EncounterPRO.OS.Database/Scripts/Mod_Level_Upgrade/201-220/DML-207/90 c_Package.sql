-- These package descriptions need to be standardized so they can be found 
-- when searching by RXNORM standards

UPDATE c_Package SET [description] = REPLACE([description], '/',' / ')
WHERE patindex('%[^ ]/[^ ]%', description) > 0

UPDATE c_Package SET [description] = 'Allergen 0.79 mg / 1 ml' WHERE package_id = 'Antigen 0.79 mg/ 1ml'
UPDATE c_Package SET [description] = 'Mini-melts 100 mg' WHERE package_id = 'Mini-melts 100mg'
UPDATE c_Package SET [description] = 'Tabs (160 mg / 25 mg)' WHERE package_id = '0001ATAB17x'
UPDATE c_Package SET [description] = 'Caps (133.3 mg Lopinavir / 33.3 mg Ritonavir)' WHERE package_id = 'DEMOACAP1098'
UPDATE c_Package SET [description] = 'Inj (IM) 100 mg / 1 ml' WHERE package_id = 'DEMOINJ100/1'
UPDATE c_Package SET [description] = 'Inj (SQ) 200 U / 1 ml' WHERE package_id = 'DEMOINJSQ200U/1'
UPDATE c_Package SET [description] = 'Inj (SQ) 6 mg / 0.5 ml' WHERE package_id = 'DEMOINJSQ6/0.5'
UPDATE c_Package SET [description] = 'Solution (80 mg Lopinavir / 20 mg Ritonavir / 1 ml)' WHERE package_id = 'DEMOSOLN1099'
UPDATE c_Package SET [description] = 'Liquid (2.5 / 5 ml)' WHERE package_id = 'Liquid (2.5/5ml)'
UPDATE c_Package SET [description] = 'Liquid (5 / 2.5 per 5 ml)' WHERE package_id = 'Liquid (5/2.5 per 5ml)'
UPDATE c_Package SET [description] = 'Nasal Spray (27.5 mcg)' WHERE package_id = 'Nasal Spray (27.5mcg)'
UPDATE c_Package SET [description] = 'Twisthaler (110 mcg)' WHERE package_id = 'Twisthaler (110mcg)'
UPDATE c_Package SET [description] = 'Twisthaler (220 mcg)' WHERE package_id = 'Twisthaler (220mcg)'
UPDATE c_Package SET [description] = 'Diskhaler with Rotadisks' WHERE package_id = 'DEMODISKUS1074'
UPDATE c_Package SET [description] = 'Caps (10 / 20)' WHERE package_id = '0001ACAP13x'
UPDATE c_Package SET [description] = 'Patches (21 mg / 24 hr)' WHERE package_id = 'DEMOPATCH452'
