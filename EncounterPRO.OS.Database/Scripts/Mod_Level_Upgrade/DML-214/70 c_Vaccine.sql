
-- 03_01_2022_VaccineImmunizationRevRec.xlsx

-- Add to c_disease tab
DELETE FROM c_Disease WHERE [disease_id] = 16
INSERT INTO c_Disease (
	 [disease_id]
      ,[description]
      ,[display_flag]
	  ,[no_vaccine_after_disease]
      ,[status]
)
VALUES (16,	'Polio (OPV)', 'Y', 'N', 'OK')

-- c_procedure revise descriptions tab
update c_Procedure SET description = 'Adenovirus Type 7, Live, Oral Vaccine' where procedure_id = '90477'
update c_Procedure SET description = 'Adenovirus Type 4, Live, Oral Vaccine' where procedure_id = '90476'
update c_Procedure SET description = 'Anthrax Vaccine' where procedure_id = '90581'
update c_Procedure SET description = 'BCG, Live. Children over one year and Adult. Intradermal Injection' where procedure_id = '90728'
update c_Procedure SET description = 'BCG, Live. Infant under one year. Intradermal Injection' where procedure_id = '90728-INF'
update c_Procedure SET description = 'Cholera, Oral Vaccine' where procedure_id = '90625'
update c_Procedure SET description = 'DT Vaccine, under 7 years' where procedure_id = '90702'
update c_Procedure SET description = 'DTaP, Infants and Children under 7 years' where procedure_id = '90700'
update c_Procedure SET description = 'DTaP-HepB-IPV, 3-dose schedule' where procedure_id = 'DEMO7939'
update c_Procedure SET description = 'DTaP-IPV' where procedure_id = 'Quadracel'
update c_Procedure SET description = 'DTaP-IPV/Hib' where procedure_id = 'DEMO8180'
update c_Procedure SET description = 'DTaP-IPV-Hib-HepB' where procedure_id = '90697'
update c_Procedure SET description = 'DTwP, Infants 6 weeks old to preschool children, 3-dose schedule' where procedure_id = '90701'
update c_Procedure SET description = 'DTwP-HepB, Infants 6 weeks old to child less than 6 years, 3-dose schedule' where procedure_id = 'DTPHEPB-3DOSE'
update c_Procedure SET description = 'DTwP-HepB-Hib, Infants 6 weeks old to preschool children, 3-dose schedule' where procedure_id = 'DTPHEPBHIB-3DOSE'
update c_Procedure SET description = 'Hep A, Adult Vaccine' where procedure_id = '90632'
update c_Procedure SET description = 'Hep A, Pediatric, 3-dose schedule' where procedure_id = '90634'
update c_Procedure SET description = 'Hep B, 0-19 years, 3-dose schedule' where procedure_id = '90744'
update c_Procedure SET description = 'Hep B, 0-19 years, Dialysis/Immunosuppressed, 4-dose schedule' where procedure_id = '90747-19'
update c_Procedure SET description = 'Hep B, Adolescent (11-15 years) Vaccine, 2-dose schedule' where procedure_id = 'DEMO5366'
update c_Procedure SET description = 'Hep B, Adult, 3-dose schedule' where procedure_id = '90746'
update c_Procedure SET description = 'Hep B, Adult, Dialysis/Immunosuppressed, 4-dose schedule' where procedure_id = '90747'
update c_Procedure SET description = 'Hep B, High Risk, 3-dose schedule' where procedure_id = 'DEMO5365'
update c_Procedure SET description = 'Hep A, Pediatric, 2-dose schedule' where procedure_id = '90633'
update c_Procedure SET description = 'Hep B (HepB-CpG), Adult, 2-dose schedule' where procedure_id = '90739'
update c_Procedure SET description = 'Hib (PRP-OMP) Conjugate, 3-dose schedule' where procedure_id = 'DEMO3199'
update c_Procedure SET description = 'Hib (PRP-T) Conjugate, 2-dose schedule' where procedure_id = 'HIBPRPT-2DOSE'
update c_Procedure SET description = 'Hib (PRP-T) Conjugate, 3-dose schedule' where procedure_id = 'HIBPRPT-3DOSE'
update c_Procedure SET description = 'Hib (PRP-T) Conjugate, 4-dose schedule' where procedure_id = 'DEMO7080'
update c_Procedure SET description = 'Hib (PRP-T) Conjugate, 4-dose schedule' where procedure_id = '1224'
update c_Procedure SET description = 'Hib-Hep B, Vaccine' where procedure_id = 'DEMO1113'
update c_Procedure SET description = 'HPV 9-valent, 2-dose schedule' where procedure_id = '90651-2DOSE'
update c_Procedure SET description = 'HPV 9-valent, 3-dose schedule' where procedure_id = '90651-3DOSE'
update c_Procedure SET description = 'HPV types 16, 18 Vaccine 3-dose schedule' where procedure_id = '1230'
update c_Procedure SET description = 'HPV types 6, 11, 16, 18 Vaccine, 3-dose schedule' where procedure_id = '15'
update c_Procedure SET description = 'IPV (Inactivated polio virus) Intramuscular Injection' where procedure_id = '90713'
update c_Procedure SET description = 'IPV (Inactivated polio virus) Subcutaneous Injection' where procedure_id = 'DEMO1118'
update c_Procedure SET description = 'Japanese Encephalitis Virus, Inactivated' where procedure_id = '90738'
update c_Procedure SET description = 'DTaP-IPV' where procedure_id = '112'
update c_Procedure SET description = 'Hib-MenCY-TT Conjugate, 4-dose schedule' where procedure_id = '1228'
update c_Procedure SET description = 'Meningococcal A Polysaccharide Vaccine' where procedure_id = 'MENINGA'
update c_Procedure SET description = 'Meningococcal (serogroups A, C, W, Y)-D conjugate Vaccine' where procedure_id = 'DEMO8182'
update c_Procedure SET description = 'Meningococcal (Serogroups A, C, Y, W-135) Polysaccharide Vaccine' where procedure_id = 'DEMO7062'
update c_Procedure SET description = 'MMR Vaccine, Intramuscular Injection' where procedure_id = '90707'
update c_Procedure SET description = 'MMR Vaccine, Subcutaneous Injection' where procedure_id = 'DEMO1122'
update c_Procedure SET description = 'Oral Polio Virus (OPV) Vaccine' where procedure_id = '90712'
update c_Procedure SET description = 'Pneumococcal Conjugate (PCV-13) 4-dose schedule' where procedure_id = '1226'
update c_Procedure SET description = 'Pneumococcal Conjugate (PCV-10) 2-dose schedule' where procedure_id = 'PCV10-2DOSE'
update c_Procedure SET description = 'Pneumococcal Conjugate (PCV-10) 3-dose schedule' where procedure_id = 'PCV10-3DOSE'
update c_Procedure SET description = 'Pneumococcal Conjugate (PCV-10) 4-dose schedule' where procedure_id = 'PCV10-4DOSE'
update c_Procedure SET description = 'Pneumococcal Polysaccharide (PPSV23) Vaccine' where procedure_id = '90732'
update c_Procedure SET description = 'Pneumococcal Polysaccharide (PPSV23) Vaccine' where procedure_id = 'DEMO7065'
update c_Procedure SET description = 'MMRV' where procedure_id = '90710'
update c_Procedure SET description = 'Rabies Vaccine' where procedure_id = 'DEMO2661'
update c_Procedure SET description = 'Rotavirus Live, Monovalent (RV1), Oral Vaccine, 3-dose schedule' where procedure_id = 'ROTAMONO3DOSE'
update c_Procedure SET description = 'Rotavirus Live, Monovalent, (RV1) Oral Vaccine, 2-dose schedule' where procedure_id = '19'
update c_Procedure SET description = 'Rotavirus Live, Pentavalent, (RV5) Oral Vaccine, 3-dose schedule' where procedure_id = '17'
update c_Procedure SET description = 'Td Vaccine, 7 years and above' where procedure_id = '90718'
update c_Procedure SET description = 'Tdap Vaccine, 10 years or older' where procedure_id = 'DEMO8181'
update c_Procedure SET description = 'TdaP-IPV Vaccine' where procedure_id = 'TDAP-IPV'
update c_Procedure SET description = 'Typhoid, live, Oral Vaccine' where procedure_id = '90690'
update c_Procedure SET description = 'Typhoid, Vi capsular polysaccharide (ViCPs)(Typhim Vi) Vaccine, Intramuscular Injection' where procedure_id = '90691'
update c_Procedure SET description = 'Varicella Vaccine, Subcutaneous Injection' where procedure_id = '90716'
update c_Procedure SET description = 'Varicella Vaccine, Intramuscular Injection' where procedure_id = 'DEMO893'
update c_Procedure SET description = 'Yellow Fever Vaccine' where procedure_id = '90717'

DELETE FROM c_Procedure where procedure_id = 'HPV92DOSE'

-- Suppress Procedures
UPDATE c_Procedure SET status = 'NA' WHERE status = 'NA
NA' OR
procedure_id IN (
'DEMO1120',
'DEMO3200',
'DEMO3198',
'DEMO7060',
'DEMO7059',
'DEMO7061',
'DEMO1126',
'90669',
'90706',
'90721',
'DEMO3197',
'90704',
'DEMO1128',
'DEMO3202',
'110',
'111',
'113',
'114',
'115',
'117',
'118',
'119',
'120',
'1225',
'1227',
'1229',
'1231',
'14',
'16',
'18',
'90669VFC',
'90700VFC',
'90707VFC',
'90713VFC',
'90716VFC',
'90718VFC',
'90720',
'90744VFC',
'90746VFC',
'DEMO1124',
'DEMO3199VFC',
'DEMO7064',
'DEMO8068',
'DEMO8069',
'DEMO8070',
'DEMO8071',
'DEMO8072',
'DEMO8073',
'DEMO8074',
'DEMO8075',
'DEMO8134',
'DEMO8135',
'RABIESIMMUNEQUINE'
)


-- revise VACCINE_ID in c_procedure tab
update c_Procedure SET vaccine_id = 'KEGI1383' where procedure_id = '90705'
update c_Procedure SET vaccine_id = 'KEGI13677' where procedure_id = '90712'
update c_Procedure SET vaccine_id = 'KEBI3612A' where procedure_id = '1230'
update c_Procedure SET vaccine_id = 'KEGI13518' where procedure_id = '90703'
update c_Procedure SET vaccine_id = 'KEBI1767' where procedure_id = 'DTPHEPB-3DOSE'
update c_Procedure SET vaccine_id = 'KEGI1485' where procedure_id = '90701'
update c_Procedure SET vaccine_id = 'HEPB' where procedure_id = '90744'
update c_Procedure SET vaccine_id = 'HEPB' where procedure_id = '90746'
update c_Procedure SET vaccine_id = 'HEPB' where procedure_id = '90739'
update c_Procedure SET vaccine_id = 'HEPB' where procedure_id = '90747-19'
update c_Procedure SET vaccine_id = 'KEBI12367' where procedure_id = '90619'

update c_Procedure SET service = 'IMMUNIZATION' 
WHERE vaccine_id IS NOT NULL 
AND service IS NULL
AND status = 'OK'

exec sp_remove_epro_drug 'KE', '6791A', 'KEBI6791A', 'KEGI6791A', 'KEB6791A', 'KEG6791A'
exec sp_remove_epro_drug 'KE', '6791B', 'KEBI6791B', 'KEGI6791B', 'KEB6791B', 'KEG6791B'
exec sp_add_epro_drug 0, 'KE', 
	'6791A', 
	'BCG Vaccine SSI (Infant under one year) 0.05 ML Injectable Suspension', 
	'No Corresponding SBD RXCUI',
	'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live (Infant under one year) attenuated per 0.05 ML Injectable Suspension',
	'No Corresponding SCD RXCUI', 
	'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated', 
	'',
	'BCG', 
	'Vaccine', 
	''
exec sp_add_epro_drug 0, 'KE', 
	'6791B', 
	'BCG Vaccine SSI (children over one year and adult) 0.1 ML Injectable Suspension', 
	'No Corresponding SBD RXCUI',
	'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live (children over one year and adult) attenuated per 0.1 ML Injectable Suspension',
	'No Corresponding SCD RXCUI', 
	'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated', 
	'',
	'BCG', 
	'Vaccine', 
	''

	
-- revise DRUG_ID in c_vaccine tab
UPDATE c_Vaccine SET drug_id = 'KEBI7058B' WHERE vaccine_id = 'HPV'
UPDATE c_Vaccine SET drug_id = 'RXNG1008837' WHERE vaccine_id = 'HEPAand'


-- Missing vaccine formulations tab
-- Removed in error when duplicate generic KEGI12367 was removed, in DML-213
	exec sp_remove_epro_drug 'KE', '12367', 'KEBI12367', NULL, 'KEB12367'

	DELETE FROM Kenya_Drugs WHERE [Retention_No] = '12367'
	INSERT INTO Kenya_Drugs (
		[Retention_No],
		[SBD_Version],
		[SCD_PSN_Version],
		[Corresponding_RXCUI],
		[Ingredient],
		[generic_only],
		[Notes]
		) VALUES (
		'12367', 
		'Nimenrix meningococcal group A, C,W-135,Y Conjugate vaccine 0.5 ML Injection', 
		'meningococcal polysaccharide, groups A, C, Y and W-135 Conjugate vaccine 0.5 ML Injection', 
		'1658226', 
		'meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y',
		0,
		''
		)
		
	exec sp_add_epro_drug 0, 'KE', 
		'12367', 
		'Nimenrix meningococcal group A, C,W-135,Y Conjugate Vaccine 0.5 ML Injection', 
		'',
		'meningococcal polysaccharide, groups A, C, Y and W-135 conjugate vaccine 0.5 ML Injection', 
		'PSN-1658226', 
		'meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y', 
		'1658226',
		'Nimenrix', 
		'Vaccine', 
		'Kenya SCD Version: neiserria meningitidis group A polysaccharide 5 MCG / neiserria meningitidis group C polysaccharide 5 MCG / neiserria meningitidis group W-135 5 MCG / neiserria meningitidis group Y 5 MCG per 0.5 ML Injection'

-- Procedure missing in c_Procedure tab
DELETE FROM [c_Procedure] WHERE [procedure_id] = '90745'
INSERT INTO [c_Procedure]
( [procedure_id]
      ,[procedure_type]
      ,[procedure_category_id]
      ,[description]
      ,[service]
      ,[cpt_code]
      ,[units]
      ,[status]
      ,[vaccine_id]
      ,[default_bill_flag]
      ,[location_domain]
      ,[bill_flag]
      ,[definition]
      ,[original_cpt_code]
	  ,[bill_assessment_id]
	  )
VALUES (
	'90745'
      ,'IMMUNIZATION'
      ,'IMMUNE'
      ,'Hep B, High risk , 4-dose schedule (0-, 1-, 2-months and 12-month schedule)'
      ,'IMMUNIZATION'
      ,'V90745'
      ,1
      ,'OK'
      ,'HEPB'
      ,'Y'
      ,'!IMMUN'
      ,'Y'
      ,'Hep B, pediatric or adolescent (HepB)'
      ,'90745'
	  ,'DEMO713'
)

DELETE FROM [c_Vaccine]
WHERE [vaccine_id] IN ('Quadracel','H1N1INJPF')

INSERT INTO [c_Vaccine] ([vaccine_id],[drug_id],[description],[status],[sort_sequence]) VALUES
('Quadracel','RXNB1607804','DTaP-IPV (DTaP and inactivated poliovirus vaccine) (Quadracel)','OK',0),
('H1N1INJPF','H1N1INJ','Novel influenza-H1N1-09 trivalent (IIV3) Injection Preservative Free','OK',0)


-- procedure has >2 generic drugs tabs
-- Handled by selecting vaccines instead



-- revise vaccine formulations tab
UPDATE c_Drug_Formulation 
SET form_descr = 'GARDASIL (Types 6, 11, 16, 18) 0.5 ML Injection' 
WHERE form_rxcui = 'KEB7058'

-- 10. NoFormulations_No reason
-- Unclear what's needed

-- B. Additional revisions (in the doc)
-- Remove duplicate A. In c_drug_generic table
DELETE from c_Drug_Generic WHERE drug_id = 'KEGI7058B'

-- B. In c_drug_brand table 
UPDATE c_Drug_Brand SET brand_name = 'GARDASIL' WHERE brand_name_rxcui = 'KEBI7058'
DELETE FROM c_Drug_Brand WHERE brand_name_rxcui = 'KEBI7058B'

DELETE FROM c_Drug_Definition WHERE drug_id IN ('KEGI7058B', 'KEBI7058B')
-- number the injection and prefilled syringe correlatedly
UPDATE f SET form_rxcui = 'KEG7058B' FROM c_Drug_Formulation f WHERE form_rxcui = 'KEG7058' 
	AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f2 WHERE f2.form_rxcui = 'KEG7058B')
UPDATE c_Drug_Formulation SET form_rxcui = 'KEG7058', ingr_rxcui = 'KEGI7058' WHERE form_rxcui = 'KEG7058A'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7058' WHERE form_rxcui = 'KEB7058B'
UPDATE c_Vaccine SET drug_id = 'KEBI7058' WHERE drug_id = 'KEB7058B'
UPDATE c_Vaccine SET drug_id = 'KEGI7058' WHERE drug_id = 'KEGI7058A'
DELETE FROM c_Vaccine WHERE drug_id = 'KEBI7058A'

-- C. In c_drug_formulation table
DELETE FROM c_Drug_Formulation WHERE form_rxcui = 'KEG9133'

-- D. In  c_drug_generic table 
DELETE FROM c_Drug_Generic WHERE generic_rxcui = 'KEGI9133'
UPDATE c_Drug_Brand 
SET generic_rxcui = 'KEGI4495'
WHERE brand_name_rxcui = 'KEBI9133'



-- Now on my own initiative
-- Update previously truncated names
UPDATE v SET description = g.generic_name 
-- select g.drug_id, g.generic_name, len(g.generic_name)
from c_Drug_Generic g
join c_Vaccine v ON v.drug_id = g.drug_id
where generic_rxcui in (
'KEGI11091',
'KEGI12269',
'KEGI3612A',
'KEGI6791',
'KEGI7884A',
'KEGI9133' --,
-- 'KEGI9195'
-- 338 characters, only 200 avail
-- v. cholerae O1 Inaba E1 tor strain phil 6973 formaldehyde killed 600 EU / v.cholerae O1 ogawa classical strain cairo 50 heat killed 300 EU / v.cholerae O1 ogawa classical strain cairo 50 formaldehyde killed 300 EU / v.cholerae O1 inaba classical strain cairo 48 heat killed 300 EU / v.cholerae O139 strain 4260B formaldehyde killed 600 EU
)

-- Vaccine names
UPDATE c_Vaccine SET description = 'BCG Tivr (bladder cancer)' WHERE vaccine_id = 'BCG'
UPDATE c_Vaccine SET description = 'BCG, TB, Percutaneous live' WHERE vaccine_id = 'BCGTB'
UPDATE c_Vaccine SET description = 'BCG, live vaccine - Children over one year and adult' WHERE vaccine_id = 'KEGI1544A'
UPDATE c_Vaccine SET description = 'BCG, live vaccine - Infant under one year' WHERE vaccine_id = 'KEGI1544B'
UPDATE c_Vaccine SET description = 'Cholera (bivalent 01 and 0139 whole cell oral vaccine)' WHERE vaccine_id = '90625'
UPDATE c_Vaccine SET description = 'DTaP-IPV-Hib-HepB (DTAP and inactivated poliovirus and haemophilus influenzae type B and hepatitis B)' WHERE vaccine_id = 'KEGI4495'
UPDATE c_Vaccine SET description = 'DTwP-HepB (DTwP and hepatitis B)' WHERE vaccine_id = 'KEGI1767'
UPDATE c_Vaccine SET description = 'DTwP-HepB-Hib (DTwP and hepatitis B and haemophilus influenzae type B)' WHERE vaccine_id = 'KEGI11378'
UPDATE c_Vaccine SET description = 'Novel influenza-H1N1-09 trivalent (IIV3) Injection' WHERE vaccine_id = 'H1N1INJ'

/*
UPDATE v
SET status = 'NA'
-- select * 
FROM c_Vaccine v
where not exists (select 1 from c_Drug_Generic d where d.drug_id = v.drug_id)
and not exists (select 1 from c_Drug_Brand b where b.drug_id = v.drug_id)
and not exists (select 1 from c_Drug_Definition n where n.drug_id = v.drug_id)
and status = 'OK'
-- order by vaccine_id

vaccine_id	drug_id	description	status	sort_sequence
90634	90634	Hepatitis A Pediatric - 3 dose	OK	0
90672	RXNG1946968	influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza A virus A/Slovenia/2903/2015 (H1N1) / Brisbane/60/2008 / Phuket/3073/2013 antigen	OK	0
90674	RXNG1928531	influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza A virus A/Singapore/GP2050/2015 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen	OK	0
90674-S	RXNG1942160	influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) / Brisbane/46/2015 / Phuket/3073/2013 antigen	OK	0
90686	RXNG1794433	influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Brisbane/60/2008 / Phuket/3073/2013 antigen	OK	0
90747	90747	Hep B, Dialysis/Immunosuppressed	OK	0
DEMO7065	DEMO7065	PPSV23 (Pneumococcal 23-valent polysaccharide vaccine)	OK	0
DTPHEPB3DOSE	DTPHEPB3DOSE	DTwP-HepB (Diphtheria, tetanus and B.pertussis whole cell and Hepatitis B vaccine)	OK	0
KEBI2911	KEBI2911	PreVEnar-13 (Pneumococcal	OK	999
KEBI7884A	KEBI7884A	Imovax Polio Vaccine	OK	999
KEGI7884A	KEGI7884A	poliovirus vaccine inactivated, type 1 (Mahoney)  /  poliovirus vaccine inact...	OK	999
RXNB1801071	RXNB1801071	Influenza (IIV4) Quadrivalent, Preservative free	OK	0
RXNB1801078	RXNB1801078	Influenza, trivalent, adjuvanted, preservative free	OK	0
RXNB1803020	RXNB1803020	Influenza RIV3 (Recombinant HA Trivalent) Preservative free Injection	OK	0
RXNB1928313	RXNG1928311	Influenza, Quadrivalent, Preservative free, Intradermal	OK	0
RXNB1928347	RXNG1928311	Influenza, recombinant quadrivalent Injection	OK	0
*/