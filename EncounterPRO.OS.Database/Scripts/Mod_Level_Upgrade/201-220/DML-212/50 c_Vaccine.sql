-- https:/ www.cdc.gov/flu/professionals/acip/2020-2021/acip-table.htm
-- https:/ www.tga.gov.au/alert/2021-seasonal-influenza-vaccines

-- na, when we were looking at brands first, but now we want the generic
/*
select distinct d.drug_id, common_name, -- f.form_descr, -- fd.[SBD_RXCUI or Kenya Retention Number],
	g.generic_name, g.drug_id
select distinct ''''+d.drug_id+''','
select distinct 'UPDATE c_Vaccine SET drug_id = '''+b.drug_id+''' WHERE drug_id = '''+d.drug_id+''' -- ',
	b.brand_name
from c_Drug_Definition d
join c_Vaccine v on v.drug_id = d.drug_id
join [05_07_2021_VaccineFormulations_Diseases] fd on fd.[legacy application "vaccine_id"] = d.drug_id
join c_Drug_Formulation f on f.form_rxcui = [SBD_RXCUI or Kenya Retention Number]
join c_Drug_Brand b on b.brand_name_rxcui = f.ingr_rxcui
where d.drug_type = 'Vaccine' and d.status = 'OK'
and not exists (select 1 from c_drug_generic g where g.drug_id = d.drug_id)
and not exists (select 1 from c_drug_brand b where b.drug_id = d.drug_id)
order by b.brand_name
*/

/*
UPDATE c_Vaccine SET drug_id = 'RXNB637866' WHERE drug_id = 'HibActHIB)' -- 	ActHIB
UPDATE c_Vaccine SET drug_id = 'RXNB605718' WHERE drug_id = 'TdaP' -- 	Adacel
UPDATE c_Vaccine SET drug_id = 'RXNB583411' WHERE drug_id = 'TdaP' -- 	Boostrix
UPDATE c_Vaccine SET drug_id = 'RXNB139056' WHERE drug_id = 'HEPBand' -- 	COMVAX
UPDATE c_Vaccine SET drug_id = 'RXNB352572' WHERE drug_id = 'DTAP' -- 	Daptacel
UPDATE c_Vaccine SET drug_id = 'RXNB49610' WHERE drug_id = 'HEPB' -- 	Engerix-B
UPDATE c_Vaccine SET drug_id = 'RXNB203439' WHERE drug_id = 'HEPA' -- 	Havrix
UPDATE c_Vaccine SET drug_id = 'RXNB1994348' WHERE drug_id = 'HEPB' -- 	Heplisav-B
UPDATE c_Vaccine SET drug_id = 'RXNB683648' WHERE drug_id = '981^29' -- 	Hiberix
UPDATE c_Vaccine SET drug_id = 'RXNB1659730' WHERE drug_id = 'RABIES' -- 	Imovax
UPDATE c_Vaccine SET drug_id = 'RXNB287617' WHERE drug_id = 'IPV' -- 	Ipol
UPDATE c_Vaccine SET drug_id = 'RXNB845529' WHERE drug_id = 'Japaneseencephalit' -- 	Ixiaro
UPDATE c_Vaccine SET drug_id = 'RXNB801721' WHERE drug_id = '2209^1' -- 	Kinrix
UPDATE c_Vaccine SET drug_id = 'RXNB218128' WHERE drug_id = 'MMR' -- 	M-M-R II
UPDATE c_Vaccine SET drug_id = 'RXNB596702' WHERE drug_id = 'Menactra' -- 	Menactra
UPDATE c_Vaccine SET drug_id = 'RXNB1437912' WHERE drug_id = '981^31' -- 	MenHibrix
UPDATE c_Vaccine SET drug_id = 'RXNB218313' WHERE drug_id = 'Menningococcus' -- 	Menomune A/C/Y/W-135
UPDATE c_Vaccine SET drug_id = 'RXNB352877' WHERE drug_id = 'Pediarix' -- 	PEDIARIX
UPDATE c_Vaccine SET drug_id = 'RXNB798448' WHERE drug_id = 'HibPedvaxHIB)' -- 	PedvaxHIB
UPDATE c_Vaccine SET drug_id = 'RXNB674453' WHERE drug_id = 'DTaP/Hib/IPV' -- 	Pentacel
UPDATE c_Vaccine SET drug_id = 'RXNB901641' WHERE drug_id = '981^30' -- 	Prevnar 13
UPDATE c_Vaccine SET drug_id = 'RXNB606051' WHERE drug_id = 'MMRV' -- 	ProQuad
UPDATE c_Vaccine SET drug_id = 'RXNB1607804' WHERE drug_id = '2209^1' -- 	Quadracel
UPDATE c_Vaccine SET drug_id = 'RXNB219579' WHERE drug_id = 'RABIES' -- 	RabAvert
UPDATE c_Vaccine SET drug_id = 'RXNB55523' WHERE drug_id = 'HEPB' -- 	Recombivax
UPDATE c_Vaccine SET drug_id = 'RXNB493191' WHERE drug_id = 'ROTAVIRUS2' -- 	Rotarix
UPDATE c_Vaccine SET drug_id = 'RXNB496892' WHERE drug_id = 'ROTAVIRUS' -- 	RotaTeq
UPDATE c_Vaccine SET drug_id = 'RXNB1986826' WHERE drug_id = 'ZosterShingles' -- 	Shingrix
UPDATE c_Vaccine SET drug_id = 'RXNB1876706' WHERE drug_id = 'YELLOW' -- 	Stamaril
UPDATE c_Vaccine SET drug_id = 'RXNB1190911' WHERE drug_id = 'ZADULTTD' -- 	Tenivac
UPDATE c_Vaccine SET drug_id = 'RXNB114883' WHERE drug_id = 'TYPHOID' -- 	Typhim VI
UPDATE c_Vaccine SET drug_id = 'RXNB115386' WHERE drug_id = 'HEPA' -- 	Vaqta
UPDATE c_Vaccine SET drug_id = 'RXNB287578' WHERE drug_id = 'Varivax1' -- 	Varivax
UPDATE c_Vaccine SET drug_id = 'RXNB762599' WHERE drug_id = 'TYPHOID' -- 	Vivotif
UPDATE c_Vaccine SET drug_id = 'RXNB220976' WHERE drug_id = 'YELLOW' -- 	YF-Vax
*/

-- pick only the first one for update, the rest will need to be added
/*
select distinct 'UPDATE c_Vaccine SET description = ''' + [Vaccine/Immunization Display Name] + ''' WHERE vaccine_id = ' ,
 '''' + [legacy application "vaccine_id"] + ''''
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
left join c_Vaccine v2 on v2.vaccine_id = [legacy application "vaccine_id"]
where [Vaccine/Immunization Display Name] is not null
and [legacy application "vaccine_id"] not like 'NA%'
and v2.vaccine_id IS NOT NULL
order by 2, 1
*/
UPDATE c_Vaccine SET description = 'PCV-10 (Pneumococcal 10-valent conjugate vaccine)' WHERE vaccine_id = 	'KEGI7692A'
UPDATE c_Vaccine SET description = 'TdaP-IPV (Tetanus Toxoid, Reduced Diphtheria Toxoid and Acellular Pertussis vaccine combine with Inactivated Poliomyelitis vaccine)' WHERE vaccine_id = 	'KEGI6790'
UPDATE c_Vaccine SET description = 'Varicella vaccine' WHERE vaccine_id = 	'KEGI7729A'

UPDATE c_Vaccine SET description = 'DTaP-IPV (DTaP and inactivated poliovirus vaccine)' WHERE vaccine_id = 	'2209^1'
UPDATE c_Vaccine SET description = 'Haemophilus influenzae type b (Hib (PRP-T))' WHERE vaccine_id = 	'981^29'
UPDATE c_Vaccine SET description = 'PCV-13 (Pneumococcal 13-valent conjugate vaccine)' WHERE vaccine_id = 	'981^30'
UPDATE c_Vaccine SET description = 'Meningococcal serogroups C and  Y and Haemophilus influenzae type b (MenCY-Hib) vaccine' WHERE vaccine_id = 	'981^31'
UPDATE c_Vaccine SET description = 'HPV, bivalent (HPV2)' WHERE vaccine_id = 	'981^32'
UPDATE c_Vaccine SET description = 'Adenovirus vaccine, type 4, Oral' WHERE vaccine_id = 	'Adenovirus'
UPDATE c_Vaccine SET description = 'Cholera (bivalent 01 and 0139 whole cell oral vaccine)' WHERE vaccine_id = 	'CHOLERA'
UPDATE c_Vaccine SET description = 'DTAP (Diphtheria, tetanus and acellular pertussis vaccine)' WHERE vaccine_id = 	'DTAP'
UPDATE c_Vaccine SET description = 'DTaP-IPV-Hib (DTAP and inactivated poliovirus and haemophilus influenzae type B)' WHERE vaccine_id = 	'DTaP/Hib/IPV'
UPDATE c_Vaccine SET description = 'DTaP-Hib' WHERE vaccine_id = 	'DTAPHIB'
UPDATE c_Vaccine SET description = 'DTAP (Diphtheria, tetanus and acellular pertussis vaccine)' WHERE vaccine_id = 	'DTaPInfanrix)'
UPDATE c_Vaccine SET description = 'DTwP (Diphtheria, tetanus toxoids, and whole cell pertussis vaccine)' WHERE vaccine_id = 	'DTP'
UPDATE c_Vaccine SET description = 'Influenza trivalent (IIV3) Injection' WHERE vaccine_id = 	'H1N1INJ'
UPDATE c_Vaccine SET description = 'Hepatitis A vaccine' WHERE vaccine_id = 	'HEPA'
UPDATE c_Vaccine SET description = 'Hepatitis A-Hepatitis B vaccine, Adult' WHERE vaccine_id = 	'HEPAand'
UPDATE c_Vaccine SET description = 'Hepatitis B vaccine' WHERE vaccine_id = 	'HEPB'
UPDATE c_Vaccine SET description = 'Hib-HepB (Hepatitis B and Haemophilus influenzae type b vaccine)' WHERE vaccine_id = 	'HEPBand'
UPDATE c_Vaccine SET description = 'Haemophilus influenzae type b (Hib (PRP-OMP))' WHERE vaccine_id = 	'HibActHIB)'
UPDATE c_Vaccine SET description = 'Haemophilus influenzae type b (Hib (PRP-OMP))' WHERE vaccine_id = 	'HibPedvaxHIB)'
UPDATE c_Vaccine SET description = 'Haemophilus Influenzae B (Hib) PRP-D Conjugate Booster' WHERE vaccine_id = 	'HibProHIBit)'
UPDATE c_Vaccine SET description = 'HPV Quadrivalent (Human Papillomavirus Quadrivalent) (HPV4)' WHERE vaccine_id = 	'HPV'
UPDATE c_Vaccine SET description = 'IPV (Inactivated poliovirus)' WHERE vaccine_id = 	'IPV'
UPDATE c_Vaccine SET description = 'Japanese encephalitis virus vaccine, inactivated' WHERE vaccine_id = 	'Japaneseencephalit'
UPDATE c_Vaccine SET description = 'Measles virus vaccine, live' WHERE vaccine_id = 	'Measles'
UPDATE c_Vaccine SET description = 'Meningococcal serogroups A,C,W,Y vaccine' WHERE vaccine_id = 	'Menactra'
UPDATE c_Vaccine SET description = 'Meningococcal serogroups A,C,W,Y vaccine' WHERE vaccine_id = 	'Menningococcus'
UPDATE c_Vaccine SET description = 'MMR (Measles, mumps and rubella vaccine)' WHERE vaccine_id = 	'MMR'
UPDATE c_Vaccine SET description = 'MMRV (Measles, mumps, rubella and varicella vaccine)' WHERE vaccine_id = 	'MMRV'
UPDATE c_Vaccine SET description = 'OPV (Oral poliovirus)' WHERE vaccine_id = 	'OPV'
UPDATE c_Vaccine SET description = 'DT (Diphtheria, tetanus vaccine)' WHERE vaccine_id = 	'PEDDT'
UPDATE c_Vaccine SET description = 'DTaP-HepB-IPV' WHERE vaccine_id = 	'Pediarix'
UPDATE c_Vaccine SET description = 'Rabies vaccine' WHERE vaccine_id = 	'RABIES'
UPDATE c_Vaccine SET description = 'Rotavirus pentavalent oral vaccine' WHERE vaccine_id = 	'ROTAVIRUS'
UPDATE c_Vaccine SET description = 'Rotavirus monovalent oral vaccine' WHERE vaccine_id = 	'ROTAVIRUS2'
UPDATE c_Vaccine SET description = 'Tdap (Tetanus, diphtheria and acellular pertussis vaccine)' WHERE vaccine_id = 	'TdaP'
UPDATE c_Vaccine SET description = 'Tetanus Toxoid' WHERE vaccine_id = 	'TETANUS'
UPDATE c_Vaccine SET description = 'Typhoid vaccine' WHERE vaccine_id = 	'TYPHOID'
UPDATE c_Vaccine SET description = 'Varicella vaccine' WHERE vaccine_id = 	'Varivax1'
UPDATE c_Vaccine SET description = 'Yellow fever vaccine' WHERE vaccine_id = 	'YELLOW'
UPDATE c_Vaccine SET description = 'Td (Tetanus and diphtheria vaccine)' WHERE vaccine_id = 	'ZADULTTD'
UPDATE c_Vaccine SET description = 'Zoster vaccine (Shingles) (HZV) recombinant' WHERE vaccine_id = 	'ZosterShingles'

UPDATE c_Vaccine SET drug_id = 'RXNG1008933' WHERE drug_id = 'DTaP/Hib/IPV' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1007545' WHERE drug_id = 'Pediarix' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / Hepatitis B Surface Antigen Vaccine / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1007290' WHERE drug_id = '2209^1' -- 	acellular pertussis vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1607802' WHERE drug_id = 'Quadracel' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis fimbriae 2/3 vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1300188' WHERE drug_id = 'DTAP' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis fimbriae 2/3 vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1657884' WHERE drug_id = 'Kinrix' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1300367' WHERE drug_id = 'TdaP' -- 	Bordetella pertussis filamentous hemagglutinin vaccine, inactivated / Bordetella pertussis pertactin vaccine, inactivated / Bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1007589' WHERE drug_id = 'PEDDT' -- 	diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1007589' WHERE drug_id = 'ZADULTTD' -- 	diphtheria toxoid vaccine, inactivated / tetanus toxoid vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG798444' WHERE drug_id = 'HibPedvaxHIB)' -- 	Haemophilus influenzae b (Ross strain) capsular polysaccharide Meningococcal Protein Conjugate Vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG1007556' WHERE drug_id = 'HEPBand' -- 	Haemophilus influenzae b (Ross strain) capsular polysaccharide Meningococcal Protein Conjugate Vaccine / Hepatitis B Surface Antigen Vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG798279' WHERE drug_id = '981^29' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG798279' WHERE drug_id = 'HibActHIB)' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG1437910' WHERE drug_id = '981^31' -- 	Haemophilus influenzae type b, capsular polysaccharide inactivated tetanus toxoid conjugate vaccine / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
UPDATE c_Vaccine SET drug_id = 'RXNG798361' WHERE drug_id = 'Havrix' -- 	Hepatitis A Vaccine (Inactivated) Strain HM175
UPDATE c_Vaccine SET drug_id = 'RXNG253174' WHERE drug_id = 'HEPA' -- 	Hepatitis A Vaccine, Inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG797752' WHERE drug_id = 'HEPB' -- 	Hepatitis B Surface Antigen Vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG1007640' WHERE drug_id = 'ROTAVIRUS' -- 	Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine
UPDATE c_Vaccine SET drug_id = 'RXNB845529' WHERE drug_id = 'Japaneseencephalit' -- 	Japanese encephalitis virus vaccine, inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG1007534' WHERE drug_id = 'MMR' -- 	Measles Virus Vaccine Live, Enders' attenuated Edmonston strain / Mumps Virus Vaccine Live, Jeryl Lynn Strain / Rubella Virus Vaccine Live (Wistar RA 27-3 Strain)
UPDATE c_Vaccine SET drug_id = 'RXNG1292439' WHERE drug_id = 'MMRV' -- 	Measles Virus Vaccine Live, Enders' attenuated Edmonston strain / Mumps Virus Vaccine Live, Jeryl Lynn Strain / Rubella Virus Vaccine Live (Wistar RA 27-3 Strain) / Varicella-Zoster Virus Vaccine Live (Oka-Merck) strain
UPDATE c_Vaccine SET drug_id = 'RXNG1008395' WHERE drug_id = 'Menningococcus' -- 	meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
UPDATE c_Vaccine SET drug_id = 'RXNG1008034' WHERE drug_id = 'Menactra' -- 	Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG1006915' WHERE drug_id = 'IPV' -- 	poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)
UPDATE c_Vaccine SET drug_id = 'RXNG830457' WHERE drug_id = 'RabAvert' -- 	rabies virus vaccine flury-lep strain
UPDATE c_Vaccine SET drug_id = 'RXNG830464' WHERE drug_id = 'RABIES' -- 	rabies virus vaccine wistar strain PM-1503-3M (Human), Inactivated
UPDATE c_Vaccine SET drug_id = 'RXNG805573' WHERE drug_id = 'ROTAVIRUS2' -- 	Rotavirus Vaccine, Live Attenuated, G1P[8] Human 89-12 strain
UPDATE c_Vaccine SET drug_id = 'RXNG762595' WHERE drug_id = 'Vivotif' -- 	Salmonella typhi Ty21a live antigen
UPDATE c_Vaccine SET drug_id = 'RXNG1008803' WHERE drug_id = '981^30' -- 	Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine
UPDATE c_Vaccine SET drug_id = 'RXNG807219' WHERE drug_id = 'TYPHOID' -- 	Typhoid Vi Polysaccharide Vaccine, S typhi Ty2 strain
UPDATE c_Vaccine SET drug_id = 'RXNG1292422' WHERE drug_id = 'Varivax1' -- 	Varicella-Zoster Virus Vaccine Live (Oka-Merck) strain
UPDATE c_Vaccine SET drug_id = 'RXNG804187' WHERE drug_id = 'YELLOW' -- 	yellow fever virus strain 17D-204 live antigen

-- Change to brand drug reference based on vaccine description
UPDATE c_Vaccine SET drug_id = 'KEBI6345A' WHERE drug_id = 'KEGI13518' 
UPDATE c_Vaccine SET drug_id = 'KEBI6812' WHERE drug_id = 'KEGI6810' 

/*
SELECT distinct '(''' + drug_id + ''',''' 
	+ [Vaccine/Immunization Display Name] + ''',''' 
	+ 'OK'',0),', [Vaccine/Immunization Display Name]
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
WHERE [Vaccine/Immunization Display Name] IN (
'Adenovirus vaccine, type 7, Oral',
'Hepatitis A Pediatric- 2 dose',
'Hep B, Dialysis/Immunosuppressed',
'Hepatitis B vaccine, Adolescent',
'Hepatitis B vaccine, Pediatric',
'Hepatitis B, pediatric or adolescent (HepB)',
'Typhoid vaccine, live, oral'
)
and [legacy application "vaccine_id"] not like 'NA%'
order by 2
*/

DELETE 
-- select *
FROM c_Vaccine
WHERE vaccine_id IN (
-- possibly inserted before
'RXNG1099937',
'RXNG797752',
'RXNG253174',
'RXNB55523',
'RXNB762599',
'90697',
'DTPHEPB3DOSE',
'DTPHEPBHIB3DOSE',
'90747',
'90634',
'RXNB1928533',
'RXNB1801153',
'RXNB1799102',
'RXNB1799102PF',
'RXNB1803020',
'RXNB1799399',
'RXNB1801179',
'90657',
'90660',
'RXNG1801823',
'90659',
'RXNB1928347',
'RXNB1801078',
'RXNB901515',
'90704',
'90668',
'90666',
'90669',
'DEMO7065',
'90706',
'RXNB833083',
-- being inserted now
'90620',
'90621-2DOSE',
'90621-3DOSE',
'90630',
'90653',
'90673',
'90682',
'90685',
'DEMO7064',

'KEGI1544A',
'KEGI1544B',
'RXNG404774',
'RXNG1597093',
'RXNB1593136',
'RXNB658273',
'90477',
'RXNB1601403',
'90625',
'RXNB1801071',
'90686',
'90672',
'RXNB1801078',
'RXNB1803020',
'90674',
'90674-IM',
'90674-S',
'RXNB1928313',
'RXNB1928347',
'90690',
'90732',
'SMALLPOXLIVE',
'90747',
'DTPHEPB3DOSE',
'DEMO7065',
'90634'
)
INSERT INTO [c_Vaccine] ([vaccine_id],[drug_id],[description],[status],[sort_sequence]) VALUES
('KEGI1544A','KEGI1544A','BCG Vaccine Adult','OK',0),
('KEGI1544B','KEGI1544B','BCG Vaccine Infant','OK',0),
('RXNG404774','RXNG404774','Anthrax','OK',0),
('RXNG1597093','RXNG1597093','HPV 9-valent (Human Papillomavirus 9-valent vaccine)','OK',0),
('RXNB1593136','RXNB1593136','Meningococcal serogroup B vaccine','OK',0),
('RXNB658273','RXNB658273','Zoster vaccine (Shingles) (HZV), live','OK',0),
('90477','RXNG1099937','Adenovirus vaccine, type 7, Oral', 'OK',0),
('RXNB1601403','RXNG1601401','Meningococcal vaccine serogroup B (MenB-4C)','OK',0),
('90625','RXNB1812946','Cholera Vaccine','OK',0),
('RXNB1801071','RXNB1801071','Influenza (IIV4) Quadrivalent, Preservative free','OK',0),
('90686','RXNG1794433','influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Brisbane/60/2008 / Phuket/3073/2013 antigen','OK',0),
('90672','RXNG1946968','influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza A virus A/Slovenia/2903/2015 (H1N1) / Brisbane/60/2008 / Phuket/3073/2013 antigen','OK',0),
('RXNB1801078','RXNB1801078','Influenza, trivalent, adjuvanted, preservative free','OK',0),
('RXNB1803020','RXNB1803020','Influenza RIV3 (Recombinant HA Trivalent) Preservative free Injection','OK',0),
('90674','RXNG1928531','influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza A virus A/Singapore/GP2050/2015 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen','OK',0),
('90674-IM','RXNG2177392','influenza A virus A/Brisbane/10/2010 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen','OK',0),
('90674-S','RXNG1942160','influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) / Brisbane/46/2015 / Phuket/3073/2013 antigen','OK',0),
('RXNB1928313','RXNG1928311','Influenza, Quadrivalent, Preservative free, Intradermal','OK',0),
('RXNB1928347','RXNG1928311','Influenza, recombinant quadrivalent Injection','OK',0),
('90690','RXNG762595','Salmonella typhi Ty21a live antigen','OK',0),
('90732','RXNG1008785','Streptococcus pneumoniae type 1 / 10A / 11A / 12F / 14 / 15B / 17F / 18C / 19A / 19F / 2 / 20 / 22F / 23F / 3 capsular polysaccharid','OK',0),
('SMALLPOXLIVE','RXNB833083','smallpox vaccine live vaccinia virus','OK',0),

('90747','90747','Hep B, Dialysis/Immunosuppressed','OK',0),
('DTPHEPB3DOSE','DTPHEPB3DOSE','DTwP-HepB (Diphtheria, tetanus and B.pertussis whole cell and Hepatitis B vaccine)','OK',0),
('DEMO7065','DEMO7065','PPSV23 (Pneumococcal 23-valent polysaccharide vaccine)','OK',0),
('90634','90634','Hepatitis A Pediatric - 3 dose','OK',0)

/*
SELECT distinct '(''' + min(IsNULL(drug_id,[original_cpt_code]))+ ''',''' 
	+ min(IsNULL(drug_id,[original_cpt_code])) + ''',''' 
	+ [Vaccine/Immunization Display Name] + ''',''' 
	+ 'OK'',0),', [Vaccine/Immunization Display Name]
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
WHERE [legacy application "vaccine_id"] like 'NA%'
group by [Vaccine/Immunization Display Name]
order by 1

alter table c_Vaccine alter column description varchar(200)
*/
/*
INSERT INTO [c_Vaccine] ([vaccine_id],[drug_id],[description],[status],[sort_sequence]) VALUES
('90697','90697','DTaP-IPV-Hib-HepB (DTAP and inactivated poliovirus and haemophilus influenzae type B and hepatitis B)','OK',0),
('DTPHEPBHIB3DOSE','DTPHEPBHIB3DOSE','DTwP-HepB-Hib (DTwP and hepatitis B and haemophilus influenzae type B)','OK',0),
('RXNB1928533','RXNB1928533','Influenza (ccIIV4) Quadrivalent, preservative free','OK',0),
('RXNB1801153','RXNB1801153','Influenza (IIV3) (Preservative Free) Injection','OK',0),
('RXNB1799102','RXNB1799102','Influenza Quadrivalent (IIV4) Injectable','OK',0),
('RXNB1799102PF','RXNB1799102','Influenza quadrivalent (IIV4) Preservative Free Injection','OK',0),
('RXNB1799399','RXNB1799399','Influenza trivalent (IIV3) (Preservative Free) Injection','OK',0),
('RXNB1801179','RXNB1801179','Influenza trivalent (IIV3) High Dose','OK',0),
('90657','90657','Influenza trivalent (IIV3) Injection','OK',0),
('90660','90660','Influenza trivalent live (LAIV3) Intranasal','OK',0),
('RXNG1801823','RXNG1801823','Influenza vaccine (live attenuated) LAIV4','OK',0),
('90659','90659','Influenza whole','OK',0),
('RXNB901515','RXNB901515','Meningococcal serogroups A,C,W,Y vaccine','OK',0),
('90704','90704','Mumps virus vaccine, live','OK',0),
('90668','90668','Novel influenza-H1N1-09','OK',0),
('90666','90666','Novel influenza-H1N1-09, preservative-free','OK',0),
('90669','90669','PCV-7 (Pneumococcal 7-valent conjugate vaccine)','OK',0),
('90706','90706','Rubella virus vaccine','OK',0),
('RXNB833083','RXNB833083','Smallpox vaccine, live','OK',0),
*/
/*
('RXNB1799102','RXNB1799102','Influenza Quadrivalent (IIV4) Injectable','OK',0),	Influenza Quadrivalent (IIV4) Injectable
('RXNB1799102','RXNB1799102','Influenza quadrivalent (IIV4) Preservative Free Injection','OK',0),	Influenza quadrivalent (IIV4) Preservative Free Injection
*/

DELETE 
-- select *
FROM c_Vaccine_Disease
WHERE last_updated > '2010-01-01'

INSERT INTO c_Vaccine_Disease (
	[disease_id],
	[vaccine_id],
	[units]
	)
VALUES
(256,'DEMO3201',1), -- 	Bladder Cancer
(456,'ZADULTTD',1), -- 	Diphtheria (7 years or older)
(2,'DTPHEPB3DOSE',1), -- 	Diphtheria (Pediatric)
(2,'DTwP',1), -- 	Diphtheria (Pediatric)
(7,'90634',1), -- 	Hep A
(8,'90747',1), -- 	Hep B
(4,'DTwP',1), -- 	Pertussis (Pediatric)
(4,'DTPHEPB3DOSE',1), -- 	Pertussis (Pediatric)
(450,'DEMO7065',1), -- 	Pnemococcus
(449,'DEMO3202',1), -- 	TB (Tuberculosis)
(457,'TETANUS',1), -- 	Tetanus (7 years or older)
(457,'ZADULTTD',1), -- 	Tetanus (7 years or older)
(3,'DTwP',1), -- 	Tetanus (Pediatric)
(3,'DTPHEPB3DOSE',1), -- 	Tetanus (Pediatric)

(64,'KEBI1921',1), -- Abhayrab Rabies Vaccine
(6,'KEBI6790',1), -- Adacel Polio Vaccine
(224,'90477',1), -- Adenovirus vaccine, type 7, Oral
(15,'RXNG404774',1), -- Anthrax
(64,'KEGI6553',1), -- antirabies serum equine
(7,'KEBI6810',1), -- Avaxim Pediatric
(448,'KEGI11378',1), -- B.pertussis (whole cell)  /  diphtheria  /  haemophilus influenzae type B  / ...
(449,'KEBI6791',1), -- BCG
(449,'BCGTB',1), -- BCG (TB)
(449,'KEGI1544',1), -- BCG Vaccine
(449,'KEGI1544A',1), -- BCG Vaccine Adult
(449,'KEGI1544B',1), -- BCG Vaccine Infant
(6,'KEGI13677',1), -- bivalent oral polio vaccines (types 1 and 3)
(16,'KEGI13677',1), -- bivalent oral polio vaccines (types 1 and 3)
(454,'KEBI3612A',1), -- Cervarix
(160,'90625',1), -- Cholera Vaccine
(2,'KEBI1767',1), -- Comvac
(3,'KEBI1767',1), -- Comvac
(4,'KEBI1767',1), -- Comvac
(8,'KEBI1767',1), -- Comvac
(456,'KEGI1485',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis
(456,'KEGI1767',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis whole cell inactivated ...
(457,'KEGI1485',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis
(457,'KEGI1767',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis whole cell inactivated ...
(458,'KEGI1485',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis
(458,'KEGI1767',1), -- diphtheria toxoid  /  tetanus toxoid  /  B. pertussis whole cell inactivated ...
(64,'KEBI6553',1), -- Equirab antirabies serum
(454,'KEBI7058A',1), -- GARDASIL (Types
-- (,'HBIG',1), -- HBIG ??
(7,'KEBI6812',1), -- Hepatitis A Vaccine (Inactivated) Strain GBM
-- (,'KEGI9133',1), -- Hexaxim generic
(2,'KEBI9133',1), -- Hexaxim Vaccine
(3,'KEBI9133',1), -- Hexaxim Vaccine
(4,'KEBI9133',1), -- Hexaxim Vaccine
(5,'KEBI9133',1), -- Hexaxim Vaccine
(6,'KEBI9133',1), -- Hexaxim Vaccine
(8,'KEBI9133',1), -- Hexaxim Vaccine
(454,'RXNG1597093',1), -- HPV 9-valent (Human Papillomavirus 9-valent vaccine)
(6,'KEBI7884A',1), -- Imovax Polio Vaccine
(64,'KEBI1769',1), -- Indirab Rabies Vaccine
-- (,'KEGI4495',1), -- Infanrix Hexa generic
(2,'KEBI4495',1), -- Infanrix Hexa Vaccine
(3,'KEBI4495',1), -- Infanrix Hexa Vaccine
(4,'KEBI4495',1), -- Infanrix Hexa Vaccine
(5,'KEBI4495',1), -- Infanrix Hexa Vaccine
(6,'KEBI4495',1), -- Infanrix Hexa Vaccine
(8,'KEBI4495',1), -- Infanrix Hexa Vaccine 
(453,'RXNB1801078',1), -- Influenza, trivalent, adjuvanted, preservative free
(453,'90673',1), -- Influenza RIV3 (Recombinant HA Trivalent) Preservative free Injection
(453,'90674-IM',1), -- influenza A virus A/Brisbane/10/2010 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen
(453,'90686',1), -- influenza A virus A/California/7/2009 (H1N1) antigen / influenza A virus A/Hong Kong/4801/2014 (H3N2) / Brisbane/60/2008 / Phuket/3073/2013 antigen
(453,'90630',1),
(453,'RXNB1928313',1), -- influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Michigan/45/2015 (H1N1) / Brisbane/60/2008 / Phuket/3073/2013 antigen
(453,'RXNB1928347',1), 
(453,'RXNB1801071',1),
(453,'90653',1),
(453,'90674-S',1), -- influenza A virus A/Hong Kong/4801/2014 (H3N2) antigen / influenza A virus A/Singapore/GP1908/2015 (H1N1) / Brisbane/46/2015 / Phuket/3073/2013 antigen
(453,'90672',1), -- influenza A virus A/New Caledonia/71/2014 (H3N2) antigen / influenza A virus A/Slovenia/2903/2015 (H1N1) / Brisbane/60/2008 / Phuket/3073/2013 antigen
(453,'90674',1), -- influenza A virus A/Singapore/GP1908/2015 (H1N1) antigen / influenza A virus A/Singapore/GP2050/2015 (H3N2) / Hong Kong/259/2010 / Utah/9/2014 antigen
(453,'KEGI12269',1), -- influenza virus vaccine 2019-2020 (trivalent - H1n 1 strain  /  H3N2 strain  ...
(453,'KEBI12269',1), -- Influvac
(454,'KEGI7058A',1), -- L1 protein, human papillomavirus type 11 vaccine  /  L1 protein, human papill...
(454,'KEGI3612A',1), -- L1 protein, human papillomavirus type 16 vaccine  /  L1 protein, human papill...
(10,'KEGI1383',1), -- measles virus
(10,'KEGI1381',1), -- measles virus  /  mumps virus  /  rubella virus
(11,'KEGI1381',1), -- measles virus  /  mumps virus  /  rubella virus
(12,'KEGI1381',1), -- measles virus  /  mumps virus  /  rubella virus
(352,'KEBI8579',1), -- MenAfriVac Meningococcal A Conjugate Vaccine Lyophilized
(352,'KEGI8579',1), -- meningococcal group A polysaccharide
(352,'RXNB1601403',1), -- meningococcal group B vaccine / Neisseria meningitidis serogroup B recombinant FHBP / NHBA / strain NZ98/254 outer membrane vesicle
(352,'RXNB1593136',1), -- Meningococcal serogroup B vaccine
(449,'KEGI6791',1), -- mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live ...
(352,'KEBI12367',1), -- Nimenrix meningococcal group A, C,W-135,Y Conjugate Vaccine
(450,'KEGI7692A',1), -- PCV-10 (Pneumococcal 10-valent conjugate vaccine)
(6,'KEGI7884A',1), -- poliovirus vaccine inactivated, type 1 (Mahoney)  /  poliovirus vaccine inact...
(450,'KEBI2911',1), -- PreVEnar-13 (Pneumococcal
(10,'KEBI7682',1), -- Priorix Measles, Mumps and Rubella Vaccine Live
(11,'KEBI7682',1), -- Priorix Measles, Mumps and Rubella Vaccine Live
(12,'KEBI7682',1), -- Priorix Measles, Mumps and Rubella Vaccine Live
(457,'KEGI1385',1), -- purified capsular Hib polysaccharide  /  tetanus toxoid
(64,'KEGI6310',1), -- rabies virus vaccine wistar strain PM  /  W138-1503-3M (human), inactivated
(64,'KEGI11091',1), -- rabies virus vaccine, inactivated pitman-moore strain propagated in chick emb...
(64,'KEGI1769',1), -- rabies virus vaccine, inactivated pitman-moore strain vero cell derived
(64,'KEGI1921',1), -- rabies virus vaccine, l.pasteur 2061  /  vero rabies strain
(64,'KEGI3071',1), -- rabies virus vaccine, l.pasteur PV-2061
(455,'KEBI14101',1), -- Rotavac,
(455,'KEGI14101',1), -- rotavirus, live attenuated (116E strain)
(128,'90690',1), -- Salmonella typhi Ty21a live antigen
(160,'KEBI11378',1), -- Shan-5
(160,'KEBI9195',1), -- Shanchol Cholera Vaccine
(14,'SMALLPOXLIVE',1), -- smallpox vaccine live vaccinia virus
(64,'KEBI3071',1), -- Speeda Rabies Vaccine
--(,'90732',1), -- Streptococcus pneumoniae type 1 / 10A / 11A / 12F / 14 / 15B / 17F / 18C / 19A / 19F / 2 / 20 / 22F / 23F / 3 capsular polysaccharid
(450,'KEBI7692A',1), -- Synflorix Pneumococcal
(456,'KEGI6790',1), -- TdaP-IPV (Tetanus Toxoid, Reduced Diphtheria Toxoid and Acellular Pertussis vaccine combine with Inactivated Poliomyelitis vaccine)
(457,'KEGI6790',1), -- TdaP-IPV (Tetanus Toxoid, Reduced Diphtheria Toxoid and Acellular Pertussis vaccine combine with Inactivated Poliomyelitis vaccine)
(458,'KEGI6790',1), -- TdaP-IPV (Tetanus Toxoid, Reduced Diphtheria Toxoid and Acellular Pertussis vaccine combine with Inactivated Poliomyelitis vaccine)
(6,'KEGI6790',1), -- TdaP-IPV (Tetanus Toxoid, Reduced Diphtheria Toxoid and Acellular Pertussis vaccine combine with Inactivated Poliomyelitis vaccine)
(457,'KEGI13518',1), -- tetanus toxoid vaccine, inactivated
(160,'KEGI9195',1), -- v. cholerae O1 Inaba E1 tor strain phil 6973 formaldehyde killed 600 EU  /  v...
(9,'KEGI7729A',1), -- Varicella vaccine
(9,'KEBI7729A',1), -- Varilrix Varicella Vaccine
(64,'KEBI11091',1), -- Vaxirab N Rabies Vaccine
(64,'KEBI6310',1), -- Verorab Rabies Vaccine
(9,'ZosterShingles',1), -- Zoster vaccine (Shingles) (HZV) recombinant
(9,'RXNB658273',1) -- Zoster vaccine (Shingles) (HZV), live\

