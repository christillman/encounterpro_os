-- Processing 05_07_2021_VaccineFormulations_Diseases^0DiseaseGroups.xlsx
/*
DELETE -- select *
from [dbo].[05_07_2021_VaccineFormulations_Diseases]
where [Vaccine/Immunization Display Name] = 'DELETE'
or IsNull([Comments/Notes],'') like 'DELETE%'
or procedure_id = 'DELETE'
*/

-- DELETE in Comments/Notes
UPDATE c_Procedure 
SET STATUS = 'NA'
WHERE [procedure_id] IN ('DEMO1120','H1N1INJ','DEMO8168',
	'DEMO7179','DEMO3197','DEMO1128','DEMO893')
AND STATUS = 'OK'

UPDATE c_Procedure 
SET procedure_category_id = 'MEDICINE'
WHERE procedure_id = 'DEMO3530'

-- TB skin test is not really a vaccine procedure
UPDATE c_Procedure
SET vaccine_id = NULL, procedure_type = 'TESTPERFORM', procedure_category_id = 'CHEMISTRY'
WHERE procedure_id IN ('DEMO7179','DEMO8060')

DELETE FROM c_Drug_Maker
WHERE maker_id IN (
'AstraZeneca','BavNordic','BioNTech','Dynavax','Emergent',
'Janssen','Moderna','Pfizer','Seqirus','Valneva'
)

DELETE FROM [c_Vaccine_Maker]
WHERE maker_id IN (
'AstraZeneca','BavNordic','BioNTech','Dynavax','Emergent',
'Janssen','Moderna','Pfizer','Seqirus','Valneva'
)


INSERT INTO c_Drug_Maker ([maker_id], [maker_name]) VALUES
('AstraZeneca','AstraZeneca'),
('BavNordic','Bavarian Nordic'),
('BioNTech','BioNTech'),
('Dynavax','Dynavax'),
('Emergent','Emergent Biosolutions'),
('Janssen','Janssen (Johnson and Johnson)'),
('Moderna','Moderna'),
('Pfizer','Pfizer'),
('Seqirus','Seqirus USA'),
('Valneva','Valneva')

UPDATE [c_Drug_Maker] SET maker_name = 'GSK Vaccines' WHERE maker_id = 'GSK'
UPDATE [c_Drug_Maker] SET maker_name = 'Merck' WHERE maker_id = 'Merck'

UPDATE [c_Vaccine_Maker] SET maker_id = 'Pfizer' WHERE maker_id = 'Wyeth'

DELETE FROM [c_Vaccine_Maker]
WHERE
(maker_id = 'AstraZeneca' AND vaccine_id = 'FluMist')
OR (maker_id = 'AstraZeneca' AND vaccine_id = 'Covid-19')
OR (maker_id = 'BavNordic' AND vaccine_id = 'Jynneos')
OR (maker_id = 'BioNTech' AND vaccine_id = 'Covid-19')
OR (maker_id = 'Dynavax' AND vaccine_id = 'Heplisav-B')
OR (maker_id = 'Emergent' AND vaccine_id = 'BioThrax')
OR (maker_id = 'Emergent' AND vaccine_id = 'Vaxchora')
OR (maker_id = 'Emergent' AND vaccine_id = 'ACAM 2000')
OR (maker_id = 'Emergent' AND vaccine_id = 'Vivotif')
OR (maker_id = 'GSK' AND vaccine_id = 'Infanrix')
OR (maker_id = 'GSK' AND vaccine_id = 'Havrix')
OR (maker_id = 'GSK' AND vaccine_id = 'Engerix-B')
OR (maker_id = 'GSK' AND vaccine_id = 'Twinrix')
OR (maker_id = 'GSK' AND vaccine_id = 'Fluarix')
OR (maker_id = 'GSK' AND vaccine_id = 'FluLaval')
OR (maker_id = 'GSK' AND vaccine_id = 'Menveo')
OR (maker_id = 'GSK' AND vaccine_id = 'Bexsero')
OR (maker_id = 'GSK' AND vaccine_id = 'RabAvert')
OR (maker_id = 'GSK' AND vaccine_id = 'Shingrix')
OR (maker_id = 'Merck' AND vaccine_id = 'ERVEBO')
OR (maker_id = 'Merck' AND vaccine_id = 'Pneumovax23')
OR (maker_id = 'Merck' AND vaccine_id = 'Zostavax')
OR (maker_id = 'Janssen' AND vaccine_id = 'Covid-19')
OR (maker_id = 'Moderna' AND vaccine_id = 'Covid-19')
OR (maker_id = 'Pfizer' AND vaccine_id = 'Covid-19')
OR (maker_id = 'Pfizer' AND vaccine_id = 'Trumenba')
OR (maker_id = 'Sanofi' AND vaccine_id = 'ActHIB')
OR (maker_id = 'Sanofi' AND vaccine_id = 'Fluzone')
OR (maker_id = 'Sanofi' AND vaccine_id = 'Flublok')
OR (maker_id = 'Sanofi' AND vaccine_id = 'Fluzone High-Dose')
OR (maker_id = 'Sanofi' AND vaccine_id = 'IPOL')
OR (maker_id = 'Sanofi' AND vaccine_id = 'Imovax')
OR (maker_id = 'Sanofi' AND vaccine_id = 'TYPHIM Vi')
OR (maker_id = 'Sanofi' AND vaccine_id = 'YF-Vax')
OR (maker_id = 'Seqirus' AND vaccine_id = 'Afluria Quadrivalent')
OR (maker_id = 'Seqirus' AND vaccine_id = 'Flucelvax Quadrivalent')
OR (maker_id = 'Seqirus' AND vaccine_id = 'Fluad')
OR (maker_id = 'Valneva' AND vaccine_id = 'IXIARO')

-- Some of these vaccines are not in c_drug_definition yet
INSERT INTO [c_Vaccine_Maker] (maker_id, vaccine_id) VALUES
('AstraZeneca','FluMist'),
('AstraZeneca','Covid-19'),
('BavNordic','Jynneos'),
('BioNTech','Covid-19'),
('Dynavax','Heplisav-B'),
('Emergent','BioThrax'), -- Anthrax
('Emergent','Vaxchora'), -- Cholera
('Emergent','ACAM 2000'), -- Smallpox
('Emergent','Vivotif'), -- Typhoid
('GSK','Infanrix'),
('GSK','Havrix'),
('GSK','Engerix-B'),
('GSK','Twinrix'),
('GSK','Fluarix'),
('GSK','FluLaval'),
('GSK','Menveo'),
('GSK','Bexsero'),
('GSK','RabAvert'), -- Rabies
('GSK','Shingrix'), -- Zoster Vaccine Recombinant Adjuvanted 
-- Tdap (Boostrix)
('Merck','ERVEBO'), -- Ebola Zaire Vaccine, Live
('Merck','Pneumovax23'), -- Pneumococcal-PPV23
('Merck','Zostavax'), -- Zoster
-- Hepatitis A (VAQTA); Hepatitis B (Recombivax-HB); HPV (Gardasil 9); Measles, Mumps, and Rubella (M-M-R II); MMR+Varicella (ProQuad); 
('Janssen','Covid-19'),
('Moderna','Covid-19'),
('Pfizer','Covid-19'),
('Pfizer','Trumenba'), -- Meningococcal serogroup B 
-- 981^30 Wyeth ('Pfizer','Prevnar13'), -- Pneumococcal-PCV13
('Sanofi','ActHIB'),
('Sanofi','Fluzone'),
('Sanofi','Flublok'),
('Sanofi','Fluzone High-Dose'),
('Sanofi','IPOL'), -- Poliovirus, inactivated
('Sanofi','Imovax'), -- Rabies
-- Td (TENIVAC); Tdap (Adacel); 
('Sanofi','TYPHIM Vi'), -- Typhoid Vi, inactivated, injectable 
('Sanofi','YF-Vax'), -- Yellow Fever 
('Seqirus','Afluria Quadrivalent'),
('Seqirus','Flucelvax Quadrivalent'),
('Seqirus','Fluad'),
('Valneva','IXIARO') -- Japanese encephalitis vaccine

-- Cleanup
DELETE m  -- select *
FROM [c_Vaccine_Maker] m
WHERE NOT EXISTS (select 1 from c_Drug_Maker dm where dm.maker_id = m.maker_id)

DELETE m -- select *
FROM [c_Vaccine_Maker] m
WHERE m.maker_id = 'OTHER'
AND EXISTS (select 1 from [c_Vaccine_Maker] dm	
	WHERE dm.vaccine_id = m.vaccine_id
	AND dm.maker_id NOT IN ('NONE','OTHER')
	)

DELETE m -- select *
FROM [c_Vaccine_Maker] m
WHERE m.maker_id = 'NONE'
AND EXISTS (select 1 from [c_Vaccine_Maker] dm	
	WHERE dm.vaccine_id = m.vaccine_id
	AND dm.maker_id NOT IN ('NONE','OTHER')
	)

DELETE FROM c_Procedure WHERE last_updated > '2021-05-17'

-- SBD_Form Quadracel vaccine 0.5 ML Injection

INSERT INTO [dbo].[c_Procedure]
           ([procedure_id]
           ,[procedure_type]
           ,[procedure_category_id]
           ,[description]
           ,[long_description]
           ,[service]
           ,[cpt_code]
           ,[modifier]
           ,[other_modifiers]
           ,[units]
           ,[charge]
           ,[billing_code]
           ,[billing_id]
           ,[status]
           ,[vaccine_id]
           ,[default_location]
           ,[default_bill_flag]
           ,[location_domain]
           ,[risk_level]
           ,[complexity]
           ,[bill_flag]
           ,[owner_id]
           ,[definition]
           ,[original_cpt_code]
           ,[bill_assessment_id]
           ,[well_encounter_flag])
SELECT 'Quadracel'
           ,[procedure_type]
           ,[procedure_category_id]
           ,'DTaP-IPV (Diphtheria, tetanus toxoids, and acellular pertussis vaccine and inactivated poliovirus vaccine) Intramuscular Injection'
           ,[long_description]
           ,[service]
           ,'D1024Q'
           ,[modifier]
           ,[other_modifiers]
           ,[units]
           ,[charge]
           ,[billing_code]
           ,[billing_id]
           ,[status]
           ,'Quadracel'
           ,[default_location]
           ,[default_bill_flag]
           ,'!IMMUN'
           ,[risk_level]
           ,[complexity]
           ,[bill_flag]
           ,[owner_id]
           ,'Quadracel'
           ,[original_cpt_code]
           ,[bill_assessment_id]
           ,[well_encounter_flag]
FROM c_Procedure
WHERE procedure_id = '000112'

UPDATE c_Procedure SET [description] = 'DTaP, Infants and Children under 7 years, Intramuscular Injection' WHERE procedure_id = '90700'
UPDATE c_Procedure SET [description] = 'DTaP-HepB-IPV' WHERE procedure_id = 'DEMO7939'
UPDATE c_Procedure SET [description] = 'DTaP-IPV/Hib' WHERE procedure_id = 'DEMO8180'
UPDATE c_Procedure SET [description] = 'DTP (Diphtheria, tetanus toxoids, and whole cell pertussis vaccine), Infants 6 weeks old to preschool children, 3-dose schedule, Intramuscular Injection' WHERE procedure_id = '90701'
UPDATE c_Procedure SET [description] = 'H1N1 Intranasal' WHERE procedure_id = 'H1N1NAS'
UPDATE c_Procedure SET [description] = 'Hep A, pediatric, 2-dose, IM. 12 months-17 years' WHERE procedure_id = '90633'
UPDATE c_Procedure SET [description] = 'Hep B, 0-19 years 0.5 ML, 3-dose schedule (0-, 1-, and 6-month schedule), Intramuscular' WHERE procedure_id = '90744'
UPDATE c_Procedure SET [description] = 'Hep B, adult 2 ML, 4-dose schedule, Dialysis/Immunosuppressed, (0-, 1-, 2-, 6- month schedule), Intramuscular' WHERE procedure_id = '90747'
UPDATE c_Procedure SET [description] = 'Hep B, adult 1 ML, 3-dose schedule (0-, 1-, and 6 month schedule), Intramuscular' WHERE procedure_id = '90746'
UPDATE c_Procedure SET [description] = 'Hep B, adolescent (11-15 years), 2-dose schedule, (0-, 6- months), Intramuscular' WHERE procedure_id = 'DEMO5366'
UPDATE c_Procedure SET [description] = 'Hep B, high risk, 3 dose series (0-, 1-, and 6 month schedule) Intramuscular Injection' WHERE procedure_id = 'DEMO5365'
UPDATE c_Procedure SET [description] = 'Hep B, high risk, 4-dose schedule (0-, 1-, 2-months and 12-month schedule), Intramuscular' WHERE procedure_id = '90745'
UPDATE c_Procedure SET [description] = 'Hepatitis A vaccine, pediatric/adolescent, 2-dose schedule, Intramuscular Injection' WHERE procedure_id = '90633'
UPDATE c_Procedure SET [description] = 'Hib (Haemophilus influenzae type B) vaccine, 3-dose schedule, Intramuscular Injection' WHERE procedure_id = 'DEMO3199'
UPDATE c_Procedure SET [description] = 'Hib PRP-T (Haemophilus influenzae type B) vaccine, 4-dose schedule, Intramuscular Injection' WHERE procedure_id = '0001224'
UPDATE c_Procedure SET [description] = 'Hib PRP-OMP (Haemophilus influenzae type B) vaccine, 4-dose schedule, Intramuscular Injection' WHERE procedure_id = 'DEMO7080'
UPDATE c_Procedure SET [description] = 'Hib-Hep B, Intramuscular Injection' WHERE procedure_id = 'DEMO1113'
UPDATE c_Procedure SET [description] = 'HPV types 16, 18 (3-dose schedule) Intramuscular' WHERE procedure_id = '0001230'
UPDATE c_Procedure SET [description] = 'HPV types 6, 11, 16, 18 (3-dose schedule) Intramuscular' WHERE procedure_id = '00015'
UPDATE c_Procedure SET [description] = 'Influenza virus vaccine, trivalent, split virus, 0.25 mL dosage, Intramuscular Injection' WHERE procedure_id = 'DEMO6807'
UPDATE c_Procedure SET [description] = 'Influenza virus vaccine, trivalent, split virus, preservative free, 0.5 mL dosage, for intramuscular use' WHERE procedure_id = '000116'
UPDATE c_Procedure SET [description] = 'Meningococcal conjugate vaccine, serogroups A, C, W, Y, quadrivalent, diphtheria toxoid carrier (MenACWY-D) or CRM197 carrier (MenACWY-CRM), intramuscular injection' WHERE procedure_id = 'DEMO8182'
UPDATE c_Procedure SET [description] = 'Meningococcal polysaccharide vaccine, serogroups A, C, Y, W-135, quadrivalent subcutaneous injection' WHERE procedure_id = 'DEMO7062'
UPDATE c_Procedure SET [description] = 'Mumps virus vaccine, live, subcutaneous injection' WHERE procedure_id = 'DEMO1126'
UPDATE c_Procedure SET [description] = 'pneumococcal 13-valent conjugate vaccine (PCV13) Intramuscular Injection' WHERE procedure_id = '0001226'
UPDATE c_Procedure SET [description] = 'Pneumococcal conjugate vaccine (PCV-7), Intramuscular Injection' WHERE procedure_id = '90669'
UPDATE c_Procedure SET [description] = 'Pneumococcal polysaccharide vaccine, 23-valent (PPSV23) Subcutaneous Injection' WHERE procedure_id = 'DEMO7065'
UPDATE c_Procedure SET [description] = 'Rotavirus vaccine, live, monovalent, human (RV1), 2-dose schedule, oral administration' WHERE procedure_id = '00019'
UPDATE c_Procedure SET [description] = 'Rotavirus vaccine, live, pentavalent (RV5), 3 dose schedule, oral administration' WHERE procedure_id = '00017'
UPDATE c_Procedure SET [description] = 'Tdap (Tetanus, Diphtheria, Pertussis), 7 years or older. Intramuscular Injection' WHERE procedure_id = 'DEMO8181'

DELETE -- select *  
FROM c_Procedure
WHERE procedure_id IN (
'90477',
'90476',
'90581',
'90728',
'90728-INF',
'90625',
'90697',
'DTPHEPB-3DOSE',
'DTPHEPBHIB-3DOSE',
'90739',
'90747-19',
'HIBPRPT-2DOSE',
'HIBPRPT-3DOSE',
'90651-2DOSE',
'90651-3DOSE',
'HPV92DOSE',
'90653',
'90674',
'90674-IM',
'90674-S',
'90630',
'90682',
'90672',
'90685',
'90673',
'90686',
'90738',
'90621-2DOSE',
'90621-3DOSE',
'MENINGA',
'90619',
'90620',
'PCV10-2DOSE',
'PCV10-3DOSE',
'PCV10-4DOSE',
'90732',
'RABIESIMMUNEQUINE',
'ROTAMONO3DOSE',
'SMALLPOXLIVE',
'TDAP-IPV',
'90714',
'90690',
'90691',
'90717',
'90736',
'90750',

'RXNB1801078',
'RXNB1928533',
'90674-IMC',
'RXNB1942162',
'RXNB1928313-FreeID',
'RXNB1928313-FreeIM',
'RXNB1928876',
'RXNB1942162-Free',
'RXNB1601403',
'ROTAMONO3DOS',
'TDAPIPV',
'RXNB1190911',
'RXNG807219',
'RXNB1876705',
'RXNB658273',
'RXNB1986825',

'RXNB1799102',	
'RXNB1928325',
'RXNB1858959',	
'RXNB1928313',
'RXNB1799102-Free',	
'RXNB1928313-Free',
'90686-3+',	
'RXNB1928325-Free',
'RXNB1799119-Free',	
'RXNB1928303-Free',
'RXNB1801071-FreeID',
'RXNB1801071-FreeIM',
'RXNB1803020',
'Shan-5'
)


INSERT INTO [dbo].[c_Procedure](
	[procedure_id],[procedure_type],[procedure_category_id],
	[description],[cpt_code],units,status,vaccine_id,default_bill_flag,location_domain,
	risk_level,bill_flag,definition,original_cpt_code,well_encounter_flag) VALUES
('90477','IMMUNIZATION','IMMUNE','adenovirus vaccine type 7 vaccine, live, oral','V90477',1,'OK','90477','Y','!IMMUN',2,'Y','adenovirus vaccine type 7 vaccine, live, oral','90477','A'),
('90476','IMMUNIZATION','IMMUNE','adenovirus vaccine, type 4, live, oral','V90476',1,'OK','Adenovirus','Y','!IMMUN',2,'Y','adenovirus vaccine, type 4, live, oral','90476','A'),
('90581','IMMUNIZATION','IMMUNE','Anthrax vaccine subcutaneous','V90581',1,'OK','RXNG404774','Y','!IMMUN',2,'Y','Anthrax vaccine subcutaneous','90581','A'),
('90728','IMMUNIZATION','IMMUNE','BCG, Live, vaccine (serum institute of India). Children over one year and adult. Intradermal Injection','V90728',1,'OK','KEGI1544A','Y','!IMMUN',2,'Y','BCG, Live, vaccine (serum institute of India). Children over one year and adult. Intradermal Injection','90728','A'),
('90728-INF','IMMUNIZATION','IMMUNE','BCG, Live, vaccine (statens serum institut). Infant under one year. Intradermal Injection','V90728A',1,'OK','KEGI1544B','Y','!IMMUN',2,'Y','BCG, Live, vaccine (statens serum institut). Infant under one year. Intradermal Injection','90728','A'),
('90625','IMMUNIZATION','IMMUNE','Cholera vaccine, live, adult dosage, 1 dose schedule, for oral use','V90625',1,'OK','90625','Y','!IMMUN',2,'Y','Cholera vaccine, live, adult dosage, 1 dose schedule, for oral use','90625','A'),
('90697','IMMUNIZATION','IMMUNE','DTaP-IPV-Hib-HepB, Intramuscular Injection','V90697',1,'OK','KEGI4495','Y','!IMMUN',2,'Y','DTaP-IPV-Hib-HepB, Intramuscular Injection','90697','A'),
('DTPHEPB-3DOSE','IMMUNIZATION','IMMUNE','DTP-HepB, 3 dose schedule, Intramuscular Injection DTP-HepB, from 6 weeks infant to child less than 6 years, 3-dose schedule, Intramuscular Injection','VDTPHEPB3DOSE',1,'OK','KEGI11378','Y','!IMMUN',2,'Y','DTP-HepB, 3 dose schedule, Intramuscular Injection DTP-HepB, from 6 weeks infant to child less than 6 years, 3-dose schedule, Intramuscular Injection','DTPHEPB3DOSE','A'),
('DTPHEPBHIB-3DOSE','IMMUNIZATION','IMMUNE','DTP-HepB-Hib, 3 dose schedule, Intramuscular Injection DTP-HepB-Hib, from 6 weeks infant to preschool children, 3-dose schedule, Intramuscular Injection','VDTPHEPBHIB3DOSE',1,'OK','KEGI11378','Y','!IMMUN',2,'Y','DTP-HepB-Hib, 3 dose schedule, Intramuscular Injection DTP-HepB-Hib, from 6 weeks infant to preschool children, 3-dose schedule, Intramuscular Injection','DTPHEPBHIB3DOSE','A'),
('90739','IMMUNIZATION','IMMUNE','Hepatitis B vaccine (HepB), adult, 2 dose schedule (HepB-CpG) Intramuscular Injection','V90739',1,'OK','RXNG797752','Y','!IMMUN',2,'Y','Hepatitis B vaccine (HepB), adult, 2 dose schedule (HepB-CpG) Intramuscular Injection','90739','A'),
('90747-19','IMMUNIZATION','IMMUNE','Hep B, 0-19 years 4-dose schedule, Dialysis/Immunosuppressed, (0-, 1-, 2-, 12- month schedule), Intramuscular','D1733',1,'OK','RXNG797752','Y','!IMMUN',2,'Y','Hep B, high risk, 4-dose, IM','90747','A'),
('HIBPRPT-2DOSE','IMMUNIZATION','IMMUNE','Hib (Haemophilus influenzae type B), PRP-T conjugate vaccine, 2-dose schedule, Intramuscular Injection','VHIBPRPT',1,'OK','KEGI1385','Y','!IMMUN',2,'Y','Hib (Haemophilus influenzae type B), PRP-T conjugate vaccine, 2-dose schedule, Intramuscular Injection','HIBPRPT','A'),
('HIBPRPT-3DOSE','IMMUNIZATION','IMMUNE','Hib (Haemophilus influenzae type B), PRP-T conjugate vaccine, 3-dose schedule, Intramuscular Injection','VHIBPRPT',1,'OK','KEGI1385','Y','!IMMUN',2,'Y','Hib (Haemophilus influenzae type B), PRP-T conjugate vaccine, 3-dose schedule, Intramuscular Injection','HIBPRPT','A'),
('90651-2DOSE','IMMUNIZATION','IMMUNE','HPV 9-valent (2-dose schedule) Intramuscular Injection','V90651',1,'OK','RXNG1597093','Y','!IMMUN',2,'Y','HPV 9-valent (2-dose schedule) Intramuscular Injection','90651','A'),
('90651-3DOSE','IMMUNIZATION','IMMUNE','HPV 9-valent (3-dose schedule) Intramuscular Injection','V90651',1,'OK','RXNG1597093','Y','!IMMUN',2,'Y','HPV 9-valent (3-dose schedule) Intramuscular Injection','90651','A'),
('HPV92DOSE','IMMUNIZATION','IMMUNE','HPV 9-valent 2 dose Intramuscular','VHPV92DOSE',1,'OK','RXNG1597093','Y','!IMMUN',2,'Y','HPV 9-valent 2 dose Intramuscular','HPV92DOSE','A'),
('90653','IMMUNIZATION','IMMUNE','Influenza vaccine, inactivated (IIV), subunit, adjuvanted. Intramuscular injection. Adults 65 years of age and older.','V90653',1,'OK','RXNB1801078','Y','!IMMUN',2,'Y','Influenza vaccine, inactivated (IIV), subunit, adjuvanted. Intramuscular injection. Adults 65 years of age and older.','90653','A'),
('90674','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quad (ccIIV4), derived from cell cultures, subunit, preservative and antibiotic free, 0.5 mL','V90674',1,'OK','90674','Y','!IMMUN',2,'Y','Influenza virus vaccine, quad (ccIIV4), derived from cell cultures, subunit, preservative and antibiotic free, 0.5 mL','90674','A'),
('90674-IM','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quad (ccIIV4), derived from cell cultures, subunit, preservative and antibiotic free, 0.5 mL dosage, IM','V90674',1,'OK','90674-IM','Y','!IMMUN',2,'Y','Influenza virus vaccine, quad (ccIIV4), derived from cell cultures, subunit, preservative and antibiotic free, 0.5 mL dosage, IM','90674','A'),
('90674-S','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quadrivalent (IIV4), split virus, 0.5 ML dose for intramuscular use','V90674',1,'OK','90674-S','Y','!IMMUN',2,'Y','Influenza virus vaccine, quadrivalent (IIV4), split virus, 0.5 ML dose for intramuscular use','90674','A'),
('90630','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quadrivalent (IIV4), split virus, preservative free, for intradermal use','V90630',1,'OK','RXNB1801071','Y','!IMMUN',2,'Y','Influenza virus vaccine, quadrivalent (IIV4), split virus, preservative free, for intradermal use','90630','A'),
('90682','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quadrivalent (RIV4), derived from recombinant DNA, hemagglutinin (HA) protein only, preservative and antibiotic free, for intramuscular use','V90682',1,'OK','RXNB1928347','Y','!IMMUN',2,'Y','Influenza virus vaccine, quadrivalent (RIV4), derived from recombinant DNA, hemagglutinin (HA) protein only, preservative and antibiotic free, for intramuscular use','90682','A'),
('90672','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quadrivalent, live (LAIV4), for intranasal use','V90672',1,'OK','90672','Y','!IMMUN',2,'Y','Influenza virus vaccine, quadrivalent, live (LAIV4), for intranasal use','90672','A'),
('90685','IMMUNIZATION','IMMUNE','Influenza virus vaccine, quadrivalent, split virus, preservative free, 0.25 mL dosage when administered to children 6 through 35 months of age, for intramuscular use','V90685',1,'OK','RXNB1801071','Y','!IMMUN',2,'Y','Influenza virus vaccine, quadrivalent, split virus, preservative free, 0.25 mL dosage when administered to children 6 through 35 months of age, for intramuscular use','90685','A'),
('90673','IMMUNIZATION','IMMUNE','Influenza virus vaccine, trivalent (RIV3), derived from recombinant DNA, hemagglutinin (HA) protein only, preservative and antibiotic free, for intramuscular use','V90673',1,'OK','90673','Y','!IMMUN',2,'Y','Influenza virus vaccine, trivalent (RIV3), derived from recombinant DNA, hemagglutinin (HA) protein only, preservative and antibiotic free, for intramuscular use','90673','A'),
('90686','IMMUNIZATION','IMMUNE','Influenza, split virus, >= 3 yrs (Influenza virus vaccine, quad (IIV4), split virus, preservative free, 0.5ml dosage, for IM use)','V90686',1,'OK','90686','Y','!IMMUN',2,'Y','Influenza, split virus, >= 3 yrs (Influenza virus vaccine, quad (IIV4), split virus, preservative free, 0.5ml dosage, for IM use)','90686','A'),
('90738','IMMUNIZATION','IMMUNE','Japanese encephalitis virus vaccine, inactivated, for intramuscular use','V90738',1,'OK','Japaneseencephalit','Y','!IMMUN',2,'Y','Japanese encephalitis virus vaccine, inactivated, for intramuscular use','90738','A'),
('90621-2DOSE','IMMUNIZATION','IMMUNE','Meningococcal serogroup B, 2 dose schedule Intramuscular','V90621',1,'OK','RXNB1593136','Y','!IMMUN',2,'Y','Meningococcal serogroup B, 2 dose schedule Intramuscular','90621','A'),
('90621-3DOSE','IMMUNIZATION','IMMUNE','Meningococcal serogroup B, 3 dose schedule Intramuscular','V90621',1,'OK','RXNB1593136','Y','!IMMUN',2,'Y','Meningococcal serogroup B, 3 dose schedule Intramuscular','90621','A'),
('MENINGA','IMMUNIZATION','IMMUNE','meningococcal A polysaccharide intramuscular vaccine','VMENINGA',1,'OK','KEGI8579','Y','!IMMUN',2,'Y','meningococcal A polysaccharide intramuscular vaccine','MENINGA','A'),
('90619','IMMUNIZATION','IMMUNE','Meningococcal conjugate vaccine, serogroups A, C, W, Y, quadrivalent, tetanus toxoid carrier, intramuscular injection','V90619',1,'OK','RXNG1008034','Y','!IMMUN',2,'Y','Meningococcal conjugate vaccine, serogroups A, C, W, Y, quadrivalent, tetanus toxoid carrier, intramuscular injection','90619','A'),
('90620','IMMUNIZATION','IMMUNE','Meningococcal vaccine serogroup B (MenB-4C), 2 dose schedule, Intramuscular','V90620',1,'OK','90620','Y','!IMMUN',2,'Y','Meningococcal vaccine serogroup B (MenB-4C), 2 dose schedule, Intramuscular','90620','A'),
('PCV10-2DOSE','IMMUNIZATION','IMMUNE','Pneumococcal conjugate vaccine (PCV10) 2-dose schedule, Intramuscular Injection','VPCV102DOSE',1,'OK','KEGI7692A','Y','!IMMUN',2,'Y','Pneumococcal conjugate vaccine (PCV10) 2-dose schedule, Intramuscular Injection','PCV102DOSE','A'),
('PCV10-3DOSE','IMMUNIZATION','IMMUNE','Pneumococcal conjugate vaccine (PCV10) 3-dose schedule, Intramuscular Injection','VPCV103DOSE',1,'OK','KEGI7692A','Y','!IMMUN',2,'Y','Pneumococcal conjugate vaccine (PCV10) 3-dose schedule, Intramuscular Injection','PCV103DOSE','A'),
('PCV10-4DOSE','IMMUNIZATION','IMMUNE','Pneumococcal conjugate vaccine (PCV10) 4-dose schedule, Intramuscular Injection','VPCV104DOSE',1,'OK','KEGI7692A','Y','!IMMUN',2,'Y','Pneumococcal conjugate vaccine (PCV10) 4-dose schedule, Intramuscular Injection','PCV104DOSE','A'),
('90732','IMMUNIZATION','IMMUNE','Pneumococcal polysaccharide vaccine, 23-valent (PPSV23) Intramuscular Injection','V90732',1,'OK','90732','Y','!IMMUN',2,'Y','Pneumococcal polysaccharide vaccine, 23-valent (PPSV23) Intramuscular Injection','90732','A'),	
('RABIESIMMUNEQUINE','IMMUNIZATION','IMMUNE','rabies immunoglobulin, equine','VRABIESIMMUNEQUINE',1,'OK','KEGI6553','Y','!IMMUN',2,'Y','rabies immunoglobulin, equine','RABIESIMMUNEQUINE','A'),
('ROTAMONO3DOSE','IMMUNIZATION','IMMUNE','Rotavac monovalent, Oral vaccine, 3 dose schedule','VROTAMONO3DOSE',1,'OK','KEGI14101','Y','!IMMUN',2,'Y','Rotavac monovalent, Oral vaccine, 3 dose schedule','ROTAMONO3DOSE','A'),
('SMALLPOXLIVE','IMMUNIZATION','IMMUNE','smallpox (vaccinia) vaccine, live Injectable Solution','VSMALLPOXLIVE',1,'OK','SMALLPOXLIVE','Y','!IMMUN',2,'Y','smallpox (vaccinia) vaccine, live Injectable Solution','SMALLPOXLIVE','A'),
('TDAP-IPV','IMMUNIZATION','IMMUNE','TdaP-IPV, Intramuscular Injection','VTDAPIPV',1,'OK','KEGI6790','Y','!IMMUN',2,'Y','TdaP-IPV, Intramuscular Injection','TDAPIPV','A'),
('90714','IMMUNIZATION','IMMUNE','Tetanus and diphtheria toxoids (Td) adsorbed, preservative free, 7yrs +, Intramuscular Injection','V90714',1,'OK','RXNG1007589','Y','!IMMUN',2,'Y','Tetanus and diphtheria toxoids (Td) adsorbed, preservative free, 7yrs +, Intramuscular Injection','90714','A'),
('90690','IMMUNIZATION','IMMUNE','Typhoid vaccine, live, oral','V90690',1,'OK','90690','Y','!IMMUN',2,'Y','Typhoid vaccine, live, oral','90690','A'),
('90691','IMMUNIZATION','IMMUNE','Typhoid vaccine, Vi capsular polysaccharide (ViCPs)(Typhim Vi), for intramuscular use','V90691',1,'OK','TYPHOID','Y','!IMMUN',2,'Y','Typhoid vaccine, Vi capsular polysaccharide (ViCPs)(Typhim Vi), for intramuscular use','90691','A'),
('90717','IMMUNIZATION','IMMUNE','Yellow fever vaccine, Subcutaneous Injection','V90717',1,'OK','RXNG804187','Y','!IMMUN',2,'Y','Yellow fever vaccine, Subcutaneous Injection','90717','A'),
('90736','IMMUNIZATION','IMMUNE','Zoster (shingles) vaccine (HZV), live, Subcutaneous Injection','V90736',1,'OK','RXNB658273','Y','!IMMUN',2,'Y','Zoster (shingles) vaccine (HZV), live, Subcutaneous Injection','90736','A'),
('90750','IMMUNIZATION','IMMUNE','Zoster (shingles) vaccine (HZV), recombinant,adjuvanted, Intramuscular Injection','V90750',1,'OK','RXNG1986821','Y','!IMMUN',2,'Y','Zoster (shingles) vaccine (HZV), recombinant,adjuvanted, Intramuscular Injection','90750','A')

/*
select distinct 'UPDATE c_Procedure SET vaccine_id = '''+g.drug_id+''' WHERE vaccine_id = '''+d.drug_id+''' -- ',
	g.generic_name
from c_Drug_Definition d
join c_Vaccine v on v.drug_id = d.drug_id
join [05_07_2021_VaccineFormulations_Diseases] fd on fd.[legacy application "vaccine_id"] = d.drug_id
join c_Drug_Formulation f on f.form_rxcui = SCD_RXCUI
join c_Drug_Generic g on g.generic_rxcui = f.ingr_rxcui
join c_Procedure p on p.vaccine_id = v.drug_id
where d.drug_type = 'Vaccine' and d.status = 'OK'
and not exists (select 1 from c_drug_generic g where g.drug_id = d.drug_id)
and not exists (select 1 from c_drug_brand b where b.drug_id = d.drug_id)
order by g.generic_name
*/

-- c_Procedure should point to c_Vaccine
-- c_Vaccine then points to generic drug_id / form_rxcui
-- User chooses specific drug_id (usually branded) 
--	which is recorded in p_Treatment_Item drug_id / form_rxcui 
--	(also package_id, maker_id, lot_number, expiration)

/* 
select distinct 'UPDATE c_Procedure SET vaccine_id = '''+g.drug_id+''' WHERE vaccine_id = '''+d.drug_id+''' -- ',
	g.generic_name
from c_Drug_Definition d
join c_Procedure p on p.vaccine_id = d.drug_id
join [05_07_2021_VaccineFormulations_Diseases] fd 
	on fd.[instead use new alternative definition] = p.description
join c_Drug_Formulation f on f.form_rxcui = SCD_RXCUI
join c_Drug_Generic g on g.generic_rxcui = f.ingr_rxcui
where d.drug_type = 'Vaccine' and d.status = 'OK'
and not exists (select 1 from c_drug_generic g where g.drug_id = d.drug_id)
and not exists (select 1 from c_drug_brand b where b.drug_id = d.drug_id)
order by g.generic_name
*/

--UPDATE c_Procedure SET vaccine_id = 'RXNG1007545' WHERE vaccine_id = 'Pediarix' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / Hepatitis B Surface Antigen Vaccine / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1607802' WHERE vaccine_id = 'Quadracel' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis fimbriae 2/3 vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Procedure SET vaccine_id = 'RXNG1657884' WHERE vaccine_id = 'Kinrix' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG798444' WHERE vaccine_id = 'HibPedvaxHIB)' -- 	Haemophilus influenzae b (Ross strain) capsular polysaccharide Meningococcal Protein Conjugate Vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007556' WHERE vaccine_id = 'HEPBand' -- 	Haemophilus influenzae b (Ross strain) capsular polysaccharide Meningococcal Protein Conjugate Vaccine / Hepatitis B Surface Antigen Vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG798279' WHERE vaccine_id = 'HibActHIB)' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine
UPDATE c_Procedure SET vaccine_id = 'RXNG798361' WHERE vaccine_id = 'Havrix' -- 	Hepatitis A Vaccine (Inactivated) Strain HM175
--UPDATE c_Procedure SET vaccine_id = 'RXNG797752' WHERE vaccine_id = 'HEPB' -- 	Hepatitis B Surface Antigen Vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007640' WHERE vaccine_id = 'ROTAVIRUS' -- 	Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG1008395' WHERE vaccine_id = 'Menningococcus' -- 	meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
--UPDATE c_Procedure SET vaccine_id = 'RXNG1008034' WHERE vaccine_id = 'Menactra' -- 	Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine
UPDATE c_Procedure SET vaccine_id = 'RXNG1008495' WHERE vaccine_id = 'Menveo' -- 	Neisseria meningitidis serogroup A oligosaccharide diphtheria CRM197 protein conjugate vaccine / Neisseria meningitidis serogroup C oligosaccharide diphtheria CRM197 protein conjugate vaccine / Neisseria meningitidis serogroup W-135 oligosaccharide diphtheria CRM197 protein conjugate vaccine / Neisseria meningitidis serogroup Y oligosaccharide diphtheria CRM197 protein conjugate vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG805573' WHERE vaccine_id = 'ROTAVIRUS2' -- 	Rotavirus Vaccine, Live Attenuated, G1P[8] Human 89-12 strain
--UPDATE c_Procedure SET vaccine_id = 'RXNG1008803' WHERE vaccine_id = '981^30' -- 	Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG1008785' WHERE vaccine_id = 'Pneumococcus' -- 	Streptococcus pneumoniae type 1 capsular polysaccharide antigen / Streptococcus pneumoniae type 10A capsular polysaccharide antigen / Streptococcus pneumoniae type 11A capsular polysaccharide antigen / Streptococcus pneumoniae type 12F capsular polysaccharide antigen / Streptococcus pneumoniae type 14 capsular polysaccharide antigen / Streptococcus pneumoniae type 15B capsular polysaccharide antigen / Streptococcus pneumoniae type 17F capsular polysaccharide antigen / Streptococcus pneumoniae type 18C capsular polysaccharide antigen / Streptococcus pneumoniae type 19A capsular polysaccharide antigen / Streptococcus pneumoniae type 19F capsular polysaccharide antigen / Streptococcus pneumoniae type 2 capsular polysaccharide antigen / Streptococcus pneumoniae type 20 capsular polysaccharide antigen / Streptococcus pneumoniae type 22F capsular polysaccharide antigen / Streptococcus pneumoniae type 23F capsular polysaccharide antigen / Streptococcus pneumoniae type 3 capsular polysaccharid

--UPDATE c_Procedure SET vaccine_id = 'RXNG253174' WHERE vaccine_id = 'HEPA' -- 	Hepatitis A Vaccine, Inactivated

--UPDATE c_Procedure SET vaccine_id = 'RXNG1008933' WHERE vaccine_id = 'DTaP/Hib/IPV' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007290' WHERE vaccine_id = '2209^1' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1300188' WHERE vaccine_id = 'DTAP' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis fimbriae 2/3 vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1300367' WHERE vaccine_id = 'TdaP' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007589' WHERE vaccine_id = 'PEDDT' -- 	diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007589' WHERE vaccine_id = 'ZADULTTD' -- 	diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG798279' WHERE vaccine_id = '981^29' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine
--UPDATE c_Procedure SET vaccine_id = 'RXNG1437910' WHERE vaccine_id = '981^31' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
--UPDATE c_Procedure SET vaccine_id = 'RXNG1007534' WHERE vaccine_id = 'MMR' -- 	Measles Virus Vaccine Live, Enders' attenuated Edmonston strain / Mumps Virus Vaccine Live, Jeryl Lynn Strain / Rubella Virus Vaccine Live (Wistar RA 27-3 Strain)
--UPDATE c_Procedure SET vaccine_id = 'RXNG1292439' WHERE vaccine_id = 'MMRV' -- 	Measles Virus Vaccine Live, Enders' attenuated Edmonston strain / Mumps Virus Vaccine Live, Jeryl Lynn Strain / Rubella Virus Vaccine Live (Wistar RA 27-3 Strain) / Varicella-Zoster Virus Vaccine Live (Oka-Merck) strain
--UPDATE c_Procedure SET vaccine_id = 'RXNG1006915' WHERE vaccine_id = 'IPV' -- 	poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)
UPDATE c_Procedure SET vaccine_id = 'RXNG830457' WHERE vaccine_id = 'RabAvert' -- 	rabies virus vaccine flury-lep strain
--UPDATE c_Procedure SET vaccine_id = 'RXNG830464' WHERE vaccine_id = 'RABIES' -- 	rabies virus vaccine wistar strain PM-1503-3M (Human), Inactivated
--UPDATE c_Procedure SET vaccine_id = 'RXNG1292422' WHERE vaccine_id = 'Varivax1' -- 	Varicella-Zoster Virus Vaccine Live (Oka-Merck) strain

select description, status, min(procedure_id), max(procedure_id), count(*) 
from c_Procedure
where vaccine_id is not null
group by description, status
having count(*) > 1

/*
SELECT distinct '(''' + min(IsNULL(drug_id,[original_cpt_code]))+ ''',''' 
	+ min(IsNULL(drug_id,[original_cpt_code])) + ''',''' 
	+ [Vaccine/Immunization Display Name] + ''',''' 
	+ 'OK'',0),', [Vaccine/Immunization Display Name]
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
WHERE [legacy application "vaccine_id"] like 'NA%'
group by [Vaccine/Immunization Display Name]
order by 1
*/
/*
-- Check that procedure vaccine_ids connect to c_Vaccine where drug_id used as vaccine_id
SELECT distinct '(''' + p.procedure_id + ''',''' + p.vaccine_id + ''',''' 
	+ g.generic_name + ''',''' 
	+ 'OK'',0),'
 FROM c_Procedure p
 JOIN c_Drug_Generic g ON g.drug_id = p.vaccine_id
WHERE procedure_type = 'IMMUNIZATION' 
	AND NOT EXISTS (SELECT 1 
	FROM c_Vaccine v
	WHERE v.drug_id = p.vaccine_id) 

-- ('90750','RXNG1986821','Varicella zoster virus glycoprotein E','OK',0),

-- Check that procedure vaccine_ids connect to c_Vaccine
SELECT distinct '(''' + p.procedure_id + ''',''' + p.vaccine_id + ''',''' 
	+ p.definition + ''',''' 
	+ 'OK'',0),'
 FROM c_Procedure p
WHERE procedure_type = 'IMMUNIZATION' 
	AND NOT EXISTS (SELECT 1 
	FROM c_Vaccine v
	WHERE v.vaccine_id = p.vaccine_id)
-- 15, need help

-- Check that all vaccine drug_ids connect to c_Drug_Definition
SELECT * FROM c_Vaccine v
 JOIN c_Drug_Generic g ON g.drug_id = v.drug_id
WHERE NOT EXISTS (SELECT 1 
	FROM c_Drug_Definition d
	WHERE d.drug_id = v.drug_id
	AND d.drug_type = 'Vaccine')
-- 2, need help

-- Check that all vaccine type drug_ids connect back to c_Vaccine
SELECT * FROM c_Drug_Definition d
--JOIN c_Vaccine v ON v.description = d.generic_name
WHERE d.drug_type = 'Vaccine'
AND NOT EXISTS (SELECT 1 
	FROM c_Vaccine v
	WHERE d.drug_id = v.drug_id)
-- 5, might be Ok
*/
/*
-- 5 shown, commented in 50 c_Vaccine
select '(,'''+vaccine_id+''',1), -- ' + description 
from c_Vaccine v
where not exists (select 1 
	from c_Vaccine_disease d 
	where v.vaccine_id = d.vaccine_id)
order by description
*/
/*
select * from c_Drug_Brand where brand_name like '%quadri%' order by brand_name

brand_name	brand_name_rxcui	generic_rxcui
Afluria Quadrivalent 2019-2020	2178781	2177392
Afluria Quadrivalent 2020-2021	2380596	2380594
Fluad Quadrivalent 2020-2021	2382435	2380594
Fluarix Quadrivalent 2019-2020	2177394	2177392
Fluarix Quadrivalent 2020-2021	2379634	2379632
Flublok Quadrivalent 2019-2020	2178082	2177392
Flublok Quadrivalent 2020-2021	2380859	2380857
Flucelvax Quadrivalent 2016-2017	1801607	1801605
Flucelvax Quadrivalent 2019-2020	2180402	2180400
Flucelvax Quadrivalent 2020-2021	2380844	2380842
Flulaval Quadrivalent 2019-2020	2177790	2177392
Flulaval Quadrivalent 2020-2021	2379732	2379632
Flumist Quadrivalent 2016-2017	1801825	1801823
Flumist Quadrivalent 2017-2018	1946970	1946968
Flumist Quadrivalent 2020-2021	2389314	2389311
Fluzone Quadrivalent 2019-2020	2177491	2177392
Fluzone Quadrivalent 2020 Southern Hemisphere	2280743	2280741
Fluzone Quadrivalent 2020-2021	2380577	2379632
Fluzone Quadrivalent 2021 Southern Hemisphere	2479031	2479044
Gardasil Human Papillomavirus Quadrivalent (types	KEBI7058	KEGI7058

SELECT drug_id, common_name FROM c_Drug_Definition d
JOIN c_Vaccine v ON v.description = d.generic_name
WHERE d.drug_type = 'Vaccine'
and d.common_name like '%flu%'
AND NOT EXISTS (SELECT 1 
	FROM c_Vaccine v
	WHERE d.drug_id = v.drug_id)
order by common_name

RXNB2178781	Afluria Quadrivalent 2019-2020
RXNB2380596	Afluria Quadrivalent 2020-2021
RXNB2178358	Fluad 2019-2020
RXNB2381146	Fluad 2020-2021
RXNB2382435	Fluad Quadrivalent 2020-2021
RXNB2177394	Fluarix Quadrivalent 2019-2020
RXNB2379634	Fluarix Quadrivalent 2020-2021
RXNB2178082	Flublok Quadrivalent 2019-2020
RXNB2380859	Flublok Quadrivalent 2020-2021
RXNB1801607	Flucelvax Quadrivalent 2016-2017
RXNB2180402	Flucelvax Quadrivalent 2019-2020
RXNB2380844	Flucelvax Quadrivalent 2020-2021
RXNB2177790	Flulaval Quadrivalent 2019-2020
RXNB2379732	Flulaval Quadrivalent 2020-2021
RXNB1801825	Flumist Quadrivalent 2016-2017
RXNB1946970	Flumist Quadrivalent 2017-2018
RXNB2389314	Flumist Quadrivalent 2020-2021
RXNB2177693	Fluzone 2019-2020
RXNB2177491	Fluzone Quadrivalent 2019-2020
RXNB2280743	Fluzone Quadrivalent 2020 Southern Hemisphere
RXNB2380577	Fluzone Quadrivalent 2020-2021
RXNB2479031	Fluzone Quadrivalent 2021 Southern Hemisphere
RXNG2177392	influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Kan...
RXNG2280741	influenza A virus A/Brisbane/02/2018 (H1N1) antigen / influenza A virus A/Sou...
RXNG2380842	influenza A virus A/Delaware/39/2019 (H3N2) antigen / influenza A virus A/Neb...
RXNG2379632	influenza A virus A/Guangdong-Maonan/SWL1536/2019 (H1N1) antigen / influenza ...
RXNG2389311	influenza A virus A/Hawaii/66/2019 (H1N1) antigen / influenza A virus A/Hong ...
RXNG2380857	influenza A virus A/Hawaii/70/2019 (H1N1) antigen / influenza A virus A/Minne...
RXNG2479044	influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/...
RXNG2380594	influenza A virus A/Hong Kong/2671/2019 (H3N2) antigen / influenza A virus A/...
RXNG2180400	influenza A virus A/Idaho/07/2018 (H1N1) antigen / influenza A virus A/Indian...
RXNG830457	rabies virus vaccine flury-lep strain

SELECT v.drug_id, v.description
FROM c_Vaccine v
--JOIN c_Drug_Brand b ON b.drug_id = v.drug_id
WHERE NOT EXISTS (SELECT 1 
	FROM c_Drug_Definition d
	WHERE d.drug_id = v.drug_id
	AND d.drug_type = 'Vaccine')
and v.description like '%flu%'
order by v.description

RXNB1801071	Influenza (IIV4) Quadrivalent, Preservative free
RXNG1801605	influenza A virus A/Brisbane/10/2010 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen
RXNG1794433	influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Brisbane/60/2008 / Phuket/3073/2013 antigen
RXNG1942160	influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) / Brisbane/46/2015 / Phuket/3073/2013 antigen
RXNG1946968	influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza A virus A/Slovenia/2903/2015 (H1N1) / Brisbane/60/2008 / Phuket/3073/2013 antigen
RXNG1928531	influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza A virus A/Singapore/GP2050/2015 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen
RXNB1803020	Influenza RIV3 (Recombinant HA Trivalent) Preservative free Injection
RXNG1928311	Influenza, Quadrivalent, Preservative free, Intradermal
RXNG1928311	Influenza, recombinant quadrivalent Injection
RXNB1801078	Influenza, trivalent, adjuvanted, preservative free
*/