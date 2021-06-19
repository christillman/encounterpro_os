
/*
select 'exec sp_add_epro_drug 0, 0, ''KE'', ''' 
	+ [Kenya Drug Retention No] 
	+ ''', ''' + IsNull([Kenya Drug in SBD Version], 'No Brand') 
	+ ''', ''' + [Kenya Drug in SCD or PSN Version] 
	+ ''', ''' + IsNull([Corresponding SCD RXCUI], 'No Corresponding SCD RXCUI')
	+ ''', ''' + Replace(IsNull([Generic Ingredients],'x'),'/',' / ')
	+ ''', ''Vaccine'''
	+ CASE WHEN [Notes] IS NULL THEN '' ELSE ', ''' + [Notes] + '''' END
from [dbo].[02_21_2021 KenyaVaccines]
order by [Kenya Drug Retention No]
*/

exec sp_add_epro_drug 0, 0, 'KE', '10093', 'RotaTeq, Rotavirus, live pentavalent (RV5) Oral Vaccine', 'Rotavirus, live pentavalent (RV5) Oral Vaccine', 'PSN-798297', 'Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '11091', 'Vaxirab N Rabies Vaccine 2.5 IU Injection', 'rabies virus vaccine (generic for VaxiRab N) 2.5 IU Injection', 'No Corresponding SCD RXCUI', 'rabies virus vaccine, inactivated pitman-moore strain propagated in chick embryo fibroblast', 'Vaccine', 'Kenya SCD Version: inactivated rabies virus (Pitman Moore Strain) Vaccine 2.5 IU Injection'
exec sp_add_epro_drug 0, 0, 'KE', '11378', 'Shan-5 Conjugate Vaccine (Adsorbed) Injectable Suspension', 'diphtheria toxoid, tetanus toxoid, B. pertussis (whole cell), hepatitis B (rDNA) and haemophilus influenzae type B Conjugate Vaccine Injectable Suspension', 'No Corresponding SCD RXCUI', 'B.pertussis (whole cell) / diphtheria / haemophilus influenzae type B / hepatitis B surface antigen / tetanus', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '12269', 'Influvac 2019-2020 Influenza Vaccine 0.5 ML Prefilled Syringe', 'influenza virus vaccine 2019-2020 (trivalent - H1n 1 strain / H3N2 strain / B Strain) in 0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'influenza virus vaccine 2019-2020 (trivalent - H1n 1 strain / H3N2 strain / B Strain)', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '12367', 'Nimenrix meningococcal group A, C,W-135,Y Conjugate Vaccine 0.5 ML Injection', 'meningococcal polysaccharide, groups A, C, Y and W-135 conjugate vaccine 0.5 ML Injection', 'PSN-1658226', 'meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y', 'Vaccine', 'Kenya SCD Version: neiserria meningitidis group A polysaccharide 5 MCG / neiserria meningitidis group C polysaccharide 5 MCG / neiserria meningitidis group W-135 5 MCG / neiserria meningitidis group Y 5 MCG per 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '13518', 'No Brand', 'tetanus toxoid vaccine, adsorbed 40 IU/0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'tetanus toxoid vaccine, inactivated', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '13677', 'No Brand', 'poliomyelitis vaccine, live attenuated bivalent type 1 and 3 Oral Suspension', 'No Corresponding SCD RXCUI', 'bivalent oral polio vaccines (types 1 and 3)', 'Vaccine', 'Obsolete generic_rxcui= Kenya SCD Version: poliovirus, live attenuated (sabin) strain type 1 106.0 CCID50 / poliovirus, live attenuated (sabin) strain type 3 105.8 CCID50 per 0.1 ML Oral Suspension'
exec sp_add_epro_drug 0, 0, 'KE', '1381', 'No Brand', 'measles, mumps and rubella vaccine live attenuated (freeze dried) per 0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'measles virus / mumps virus / rubella virus', 'Vaccine', 'Kenya SCD Version: not less than 1000 CCID50 of measles virus / not less than 5000 CCID50 of mumps virus / not less than 1000 CCID50 of rubella virus per 0.5 ML Injectable solution'
exec sp_add_epro_drug 0, 0, 'KE', '1383', 'No Brand', 'measles vaccine live attenuated (freeze dried) 0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'measles virus', 'Vaccine', 'Kenya SCD Version: not less than 1000 CCID50 of measles virus per 0.5 ML Injectable Solution'
exec sp_add_epro_drug 0, 0, 'KE', '1385', 'No Brand', 'haemophilus influenzae type B conjugate vaccine (lyophilized) Injectable Solution', 'No Corresponding SCD RXCUI', 'purified capsular Hib polysaccharide / tetanus toxoid', 'Vaccine', 'Kenya SCD Version: purified capsular polysaccharide of Hib 10 MCG / tetanus toxoid 19-33 MCG per 0.5 ML Injectable Solution'
exec sp_add_epro_drug 0, 0, 'KE', '1386', 'No Brand', 'tetanus toxoid vaccine, adsorbed 40 IU (5 Lf) per 0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'tetanus toxoid vaccine, inactivated', 'Vaccine', 'Kenya SCD Version: tetanus toxoid 40 IU (5 Lf)/0.5 ML Injectable Solution'
exec sp_add_epro_drug 0, 0, 'KE', '14101', 'Rotavac, Rotavirus, live attenuated (116E strain) Oral Vaccine', 'rotavirus, live attenuated (116E strain) Oral Vaccine', 'No Corresponding', 'rotavirus, live attenuated (116E strain)', 'Vaccine', 'Kenya SCD Version: rotavirus, live attenuated (116E strain) 105.0 FFU per 0.5 ML Oral Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1485', 'No Brand', 'diphtheria, tetanus and pertussis Vaccine Adsorbed Injectable Solution', 'No Corresponding SCD RXCUI', 'diphtheria toxoid / tetanus toxoid / B. pertussis', 'Vaccine', 'Kenya SCD Version: diphtheria toxoid 30 IU (25 Lf) / tetanus toxoid 40 IU (5 Lf) / B. pertussis 4 IU (16 OU) per 0.5 ML Injectable Solution'
exec sp_add_epro_drug 0, 0, 'KE', '1489', 'No Brand', 'hepatitis B (rDNA) pediatric Vaccine 10 MCG in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine', 'Kenya SCD Version: hepatitis B surface antigen pediatric vaccine 10 MCG in 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '1509', 'No Brand', 'hepatitis B (rDNA) adult Vaccine 20 MCG in 1 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine', 'Kenya SCD Version: hepatitis B surface antigen adult vaccine 20 MCG in 1 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '1544', 'No Brand', 'BCG, Live, Vaccine between 2 x105 and 8x105 C.F.U per 0.1 ML Injection', 'No Corresponding SCD RXCUI', 'BCG Vaccine', 'Vaccine', 'Obsolete generic_rxcui='
exec sp_add_epro_drug 0, 0, 'KE', '16857', 'ComBE Five Vaccine in 0.5 ML Prefilled Syringe', 'diphtheria, tetanus, B.pertussis (whole cell), hepatitis B (rDNA) and haemophilus type B conjugate vaccine (adsorbed) in 0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'B.pertussis (whole cell) / diphtheria / haemophilus influenzae type B / hepatitis B surface antigen / tetanus', 'Vaccine', 'Kenya SCD Version: diphtheria toxoid 25 Lf (30 IU), tetanus toxoid 5.5 Lf (60 IU), B.pertussis (whole cell) 16 IOU (4 IU), HBsAg (rDNA) 12 MCG, purified capsular Hib polysaccharide conjugated to tetanus toxoid 11 MCG per 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '1767', 'Comvac 4-HB Vaccine in 0.5 ML Injection', 'diphtheria toxoid 20 Lf-25 Lf / tetanus toxoid 5 Lf-7.5 Lf / B. pertussis whole cell inactivated 15 OU-20 OU / hepatitis B Surface Antigen (rDNA) 10 MCG per 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'diphtheria toxoid / tetanus toxoid / B. pertussis whole cell inactivated / hepatitis B Surface Antigen (rDNA)', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1769', 'Indirab Rabies Vaccine 2.5 IU Injection', 'rabies virus vaccine (generic for Indirab) 2.5 IU Injection', 'No Corresponding SCD RXCUI', 'rabies virus vaccine, inactivated pitman-moore strain vero cell derived', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1775', 'Revac-B mcf Pediatric Vaccine 10 MCG in 0.5 ML Injection', 'hepatitis B surface antigen pediatric vaccine 10 MCG in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1777', 'Revac-B+ Adult Vaccine 20 MCG in 1 ML Injection', 'hepatitis B surface antigen adult vaccine 20 MCG in 1 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1921', 'Abhayrab Rabies Vaccine 2.5 IU Injection', 'rabies virus vaccine (generic for Abhayrab) 2.5 IU Injection', 'No Corresponding SCD RXCUI', 'rabies virus vaccine, l.pasteur 2061 / vero rabies strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '2911', 'PreVEnar-13 (Pneumococcal 13-valent) conjugate Vaccine 0.5 ML Prefilled Syringe', 'pneumococcal 13-valent conjugate vaccine (PCV13) 0.5 ML Prefilled Syringe', 'PSN-901640', 'Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '3071', 'Speeda Rabies Vaccine 2.5 IU Injection', 'rabies virus vaccine (generic for Speeda) 2.5 IU Injection', 'No Corresponding SCD RXCUI', 'rabies virus vaccine, l.pasteur PV-2061', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '3612A', 'Cervarix 0.5 ML Prefilled Syringe', 'human papillomavirus bivalent (types 16 and 18) vaccine, recombinant 0.5 ML Prefilled Syringe', 'PSN-1301889', 'L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine', 'Vaccine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3612B', 'Cervarix 0.5 ML Injectable Suspension', 'human papillomavirus bivalent (types 16 and 18) vaccine, recombinant 0.5 ML Injectable Suspension', 'SCD-1301894', 'L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine', 'Vaccine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3627', 'ENGERIX-B Adult Vaccine 20 MCG in 1 ML Injection', 'hepatitis B vaccine (recombinant) adult 20 MCG in 1 ML Injection', 'PSN-1658156', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '3629', 'ENGERIX-B Pediatric Vaccine 10 MCG in 0.5 ML Injection', 'hepatitis B vaccine (recombinant) pediatric/adolescent 10 MCG in 0.5 ML Injection', 'PSN-1658142', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '4495', 'Infanrix Hexa Vaccine 0.5 ML Injection', 'diphtheria, tetanus, acellular pertussis, hepatitis B, inactivated poliomyelitis and haemophilus type B conjugate vaccine adsorbed 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'bordetella pertussis filamentous hemagglutinin vaccine, inactivated / bordetella pertussis pertactin vaccine, inactivated / bordetella pertussis toxoid vaccine, inactivated / diphtheria toxoid vaccine, inactivated / haemophilus influenzae b polysaccharide conjugated to tetanus toxoid as carrier protein / hepatitis B surface antigen vaccine / poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett) / tetanus toxoid vaccine, inactivated', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '500', 'Typbar Vaccine 25 MCG/0.5 ML Injectable Solution', 'typhoid Vi polysaccharide vaccine, (generic for Typbar) 25 MCG/0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'Typhoid Vi Polysaccharide Vaccine, S typhi Ty2 strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6310', 'Verorab Rabies Vaccine 0.5 ML Injection', 'rabies virus vaccine wistar strain PM/W138-1503-3M (human), inactivated 2.5 IU/0.5 ML Injection', 'No Corresponding SCD RXCUI', 'rabies virus vaccine wistar strain PM / W138-1503-3M (human), inactivated', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6341A', 'Typhim Vi Vaccine 0.5 ML Prefilled Syringe', 'typhoid Vi polysaccharide vaccine (generic for Typhim Vi) 0.5 ML Prefilled Syringe', 'PSN-807239', 'Typhoid Vi Polysaccharide Vaccine, S typhi Ty2 strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6341B', 'Typhim Vi Vaccine Injectable Solution', 'typhoid Vi polysaccharide vaccine (generic for Typhim Vi) Injectable Solution', 'PSN-807222', 'Typhoid Vi Polysaccharide Vaccine, S typhi Ty2 strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6343', 'Stamaril Vaccine 0.5 ML Injection', 'yellow fever vaccine (generic for Stamaril) 0.5 ML Injection', 'PSN-1876705', 'yellow fever virus strain 17D-204 live antigen', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6345A', 'Tetavax Vaccine 40 IU/0.5 ML Prefilled Syringe', 'tetanus toxoid vaccine, adsorbed 40 IU/0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'tetanus toxoid vaccine, inactivated', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6345B', 'Tetavax Vaccine 40 IU/0.5 ML Injectable Solution', 'tetanus toxoid vaccine, adsorbed 40 IU/0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'tetanus toxoid vaccine, inactivated', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6553', 'Equirab antirabies serum 200 IU/ML Injectable Solution', 'equine antirabies immunoglobulin fragments 200 IU/ML Injectable Solution', 'No Corresponding SCD RXCUI', 'antirabies serum equine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6554', 'Thymogam 250 MG in 5 ML Injection', 'antithymocyte globulin-equine 250 MG in 5 ML Injection', 'No Corresponding SCD RXCUI', 'lymphocyte immune globulin, anti-thymocyte globulin, equine', 'Vaccine', 'Inpatient drug'
exec sp_add_epro_drug 0, 0, 'KE', '6558', 'Rhoclone 300 MCG Powder for Injection', 'rho(D) immunoglobulin 300 MCG Powder for Injection', 'No Corresponding SCD RXCUI', 'Rho(D) Immune Globulin', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6790', 'Adacel Polio Vaccine 0.5 ML Injection', 'acellular pertussis vaccine and diphtheria toxoid and tetanus toxoid (adsorbed) and poliovirus type 1, 2 and 3 inactivated vaccine 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'acellular pertussis / diphtheria toxoid / poliovirus type 1, 2 and 3 inactivated / tetanus toxoid (adsorbed)', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '6791', 'BCG Vaccine SSI Injectable Suspension', 'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated Injectable Suspension', 'No Corresponding SCD RXCUI', 'mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated', 'Vaccine', 'Kenya SCD Version: mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated between 2-8 x105 bacteria/0.1 ML Injectable Suspension'
exec sp_add_epro_drug 0, 0, 'KE', '6810', 'Avaxim Pediatric 80 EU in 0.5 ML Injection', 'hepatitis A vaccine pediatric 80 EU in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'Hepatitis A Vaccine (Inactivated) Strain GBM', 'Vaccine', 'Kenya SCD version: hepatitis A vaccine (inactivated) strain GBM 80 EU in 0.5 ML'
exec sp_add_epro_drug 0, 0, 'KE', '6812', 'Avaxim Adult 160 EU in 0.5 ML Injection', 'hepatitis A vaccine adult 160 EU in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'Hepatitis A Vaccine (Inactivated) Strain GBM', 'Vaccine', 'Kenya SCD version: hepatitis A vaccine (inactivated) strain GBM 160 EU in 0.5 ML'
exec sp_add_epro_drug 0, 0, 'KE', '6896', 'Menactra Vaccine 0.5 ML Injection', 'meningococcal (groups A, C, Y and W-135) polysaccharide diphtheria toxoid conjugate vaccine (MCV4 generic for Menactra) 0.5 ML Injection', 'PSN-797638', 'Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7058A', 'GARDASIL (Types 6, 11, 16, 18) 0.5 ML Injection', 'human Papillomavirus quadrivalent (types 6,11,16,18) vaccine, recombinant 0.5 ML Injection', 'PSN-798271', 'L1 protein, human papillomavirus type 11 vaccine / L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine / L1 protein, human papillomavirus type 6 vaccine', 'Vaccine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '7058B', 'GARDASIL (Types 6, 11, 16, 18) 0.5 ML Prefilled Syringe', 'human Papillomavirus quadrivalent (types 6,11,16,18) vaccine, recombinant 0.5 ML Prefilled Syringe', 'PSN-798276', 'L1 protein, human papillomavirus type 11 vaccine / L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine / L1 protein, human papillomavirus type 6 vaccine', 'Vaccine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '7601A', 'Havrix Junior Pediatric Vaccine 720 EU in 0.5 ML Injection', 'hepatitis A vaccine pediatric 720 UNT in 0.5 ML Injection', 'PSN-1658065', 'Hepatitis A Vaccine (Inactivated) Strain HM175', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7601B', 'Havrix Junior Pediatric Vaccine 720 EU in 0.5 ML Prefilled Syringe', 'hepatitis A vaccine pediatric 720 UNT in 0.5 ML Prefilled Syringe', 'PSN-798481', 'Hepatitis A Vaccine (Inactivated) Strain HM175', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7608A', 'HAVRIX Adult Vaccine 1440 EU in 1 ML Injection', 'hepatitis A vaccine adult 1440 UNT in 1 ML Injection', 'PSN-1658058', 'Hepatitis A Vaccine (Inactivated) Strain HM175', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7608B', 'HAVRIX Adult Vaccine 1440 EU in 1 ML Prefilled Syringe', 'hepatitis A vaccine adult 1440 UNT in 1 ML Prefilled Syringe', 'PSN-798477', 'Hepatitis A Vaccine (Inactivated) Strain HM175', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7682', 'Priorix Measles, Mumps and Rubella Vaccine Live 0.5 ML Injection', 'measles, mumps and rubella virus vaccine live in 0.5 ML Injection', 'PSN-1292440', 'Measles Virus Live attenuated Schwarz strain / Mumps Virus Live attenuated, RIT 4385 strain derived from Jeryl Lynn strain / Rubella Virus Live attenuated Wistar RA 27-3 Strain', 'Vaccine', 'Kenya SCD Version: Measles Virus Live attenuated Schwarz strain not less than 103.0 CCID50 / Mumps Virus Live attenuated, RIT 4385 strain derived from Jeryl Lynn strain not less than 103.7CCID50 / Rubella Virus Live attenuated Wistar RA 27-3 Strain not less than 103.0CCID50 in 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '7691', 'Rotarix, Rotavirus, live attenuated (RV1) G1P[8] Oral Vaccine', 'rotavirus, live attenuated (RV1) G1P[8] Oral Vaccine', 'PSN-805576', 'Rotavirus Vaccine, Live Attenuated, G1P[8] Human 89-12 strain', 'Vaccine', 'SCD-Rotavirus Vaccine, Live Attenuated, G1P[8] Human 89-12 strain 1000000 UNT/ML Oral Suspension'
exec sp_add_epro_drug 0, 0, 'KE', '7692A', 'Synflorix Pneumococcal 10-valent conjugate Vaccine in 0.5 ML Prefilled Syringe', 'pneumococcal 10-valent polysaccharide conjugate vaccine (adsorbed) in 0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'pneumococcal polysaccharide serotype 23F / pneumococcal polysaccharide serotype 4 / pneumococcal polysaccharide serotype 5 / pneumococcal polysaccharide serotype 6B / pneumococcal polysaccharide serotype 7F / pneumococcal polysaccharide serotype 9V / pneumococcal polysaccharide serotype 1 / pneumococcal polysaccharide serotype 14 / pneumococcal polysaccharide serotype 18C / pneumococcal polysaccharide serotype 19F', 'Vaccine', 'Kenya SCD Version: pneumococcal polysaccharide serotype 23F 1 MCG / pneumococcal polysaccharide serotype 4 3 MCG/ pneumococcal polysaccharide serotype 5 1 MCG / pneumococcal polysaccharide serotype 6B 1 MCG / pneumococcal polysaccharide serotype 7F 1 MCG / pneumococcal polysaccharide serotype 9V 1 MCG / pneumococcal polysaccharide serotype 1 1 MCG / pneumococcal polysaccharide serotype 14 1 MCG / pneumococcal polysaccharide serotype 18C 3 MCG / pneumococcal polysaccharide serotype 19F 3 MCG in 0.5 ML Prefilled Syringe'
exec sp_add_epro_drug 0, 0, 'KE', '7692B', 'Synflorix Pneumococcal 10-valent Conjugate Vaccine in 0.5 ML Injection', 'pneumococcal 10-valent polysaccharide conjugate vaccine (adsorbed) in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'pneumococcal polysaccharide serotype 23F / pneumococcal polysaccharide serotype 4 / pneumococcal polysaccharide serotype 5 / pneumococcal polysaccharide serotype 6B / pneumococcal polysaccharide serotype 7F / pneumococcal polysaccharide serotype 9V / pneumococcal polysaccharide serotype 1 / pneumococcal polysaccharide serotype 14 / pneumococcal polysaccharide serotype 18C / pneumococcal polysaccharide serotype 19F', 'Vaccine', 'Kenya SCD Version: pneumococcal polysaccharide serotype 23F 1 MCG / pneumococcal polysaccharide serotype 4 3 MCG/ pneumococcal polysaccharide serotype 5 1 MCG / pneumococcal polysaccharide serotype 6B 1 MCG / pneumococcal polysaccharide serotype 7F 1 MCG / pneumococcal polysaccharide serotype 9V 1 MCG / pneumococcal polysaccharide serotype 1 1 MCG / pneumococcal polysaccharide serotype 14 1 MCG / pneumococcal polysaccharide serotype 18C 3 MCG / pneumococcal polysaccharide serotype 19F 3 MCG in 0.5 ML Prefilled Syringe'
exec sp_add_epro_drug 0, 0, 'KE', '7697A', 'Twinrix vaccine 1 ML Injection', 'hepatitis A & hepatitis B (recombinant) vaccine (HepA-HepB) 1 ML Injection', 'PSN-803364', 'Hepatitis A Vaccine (Inactivated) Strain HM175 / Hepatitis B Surface Antigen Vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7697B', 'Twinrix Vaccine 1 ML Prefilled Syringe', 'hepatitis A & hepatitis B (recombinant) vaccine (HepA-HepB) 1 ML Prefilled Syringe', 'PSN-803369', 'hepatitis A Vaccine (Inactivated) Strain HM175 / hepatitis B Surface Antigen Vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7699A', 'Euvax B Hepatitis B Vaccine 20 MCG in 1 ML Injection', 'hepatitis B surface antigen adult vaccine 20 MCG in 1 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7699B', 'Euvax B Hepatitis B Vaccine 10 MCG in 0.5 ML Injection', 'hepatitis B surface antigen adult vaccine 10 MCG in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'hepatitis B surface antigen vaccine', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7729A', 'Varilrix Varicella Vaccine 0.5 ML Injection', 'varicella-zoster virus vaccine, live attenuated (Oka strain) 103.3 PFU in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'Varicella-Zoster Virus Vaccine Live (Oka) strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7729B', 'Varilrix Varicella Vaccine 0.5 ML Prefilled Syringe', 'varicella-zoster virus vaccine, live attenuated (Oka strain) 103.3 PFU in 0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'Varicella-Zoster Virus Vaccine Live (Oka) strain', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '7884A', 'Imovax Polio Vaccine 0.5 ML Injection', 'poliomyelitis vaccine, inactivated in 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)', 'Vaccine', 'Kenya SCD-poliovirus vaccine inactivated, type 1 (Mahoney) 40 D-antigen units / poliovirus vaccine inactivated, type 2 (MEF-1) 8 D-antigen units / poliovirus vaccine inactivated, type 3 (Saukett) 32 D-antigen units in 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '7884B', 'Imovax Polio Vaccine 0.5 ML Prefilled Syringe', 'poliomyelitis vaccine, inactivated in 0.5 ML Prefilled Syringe', 'No Corresponding SCD RXCUI', 'poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)', 'Vaccine', 'Kenya SCD-poliovirus vaccine inactivated, type 1 (Mahoney) 40 D-antigen units / poliovirus vaccine inactivated, type 2 (MEF-1) 8 D-antigen units / poliovirus vaccine inactivated, type 3 (Saukett) 32 D-antigen units in 0.5 ML Prefilled Syringe'
exec sp_add_epro_drug 0, 0, 'KE', '8579', 'MenAfriVac Meningococcal A Conjugate Vaccine Lyophilized in 10 MCG/0.5 ML Injectable Solution', 'meningococcal A polysaccharide vaccine lyophilized 10 MCG/0.5 ML Injectable Solution', 'No Corresponding SCD RXCUI', 'meningococcal group A polysaccharide', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '9035', 'No Brand', 'diphtheria, tetanus, B.pertussis (whole cell), hepatitis B and haemophilus influenzae type B Conjugate vaccine adsorbed in 0.5 ML Injection', 'No Corresponding SCD RXCUI. Kenya PSN Version', 'B.pertussis (whole cell) / diphtheria / haemophilus influenzae type B / hepatitis B surface antigen / tetanus', 'Vaccine', 'Kenya SCD Version: diphtheria toxoid 25 Lf (30 IU), tetanus toxoid 2.5 Lf (40 IU), b.pertussis (whole cell) 16 OU (4 IU), HBsAg (rDNA) 10 MCG, purified capsular Hib polysaccharide conjugated to tetanus toxoid 10 MCG per 0.5 ML Injection'
exec sp_add_epro_drug 0, 0, 'KE', '9133', 'Hexaxim Vaccine 0.5 ML Injection', 'diphtheria, tetanus, acellular pertussis, hepatitis B (rDNA), inactivated poliomyelitis, Haemophilus influenzae type b conjugate vaccine 0.5 ML Injection', 'No Corresponding SCD RXCUI', 'acellular pertussis / diptheria / haemophilus influenzae type b / hepatitis B surface antigen / poliomyelitis inactivated / tetanus,', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '9195', 'Shanchol Cholera Vaccine in 1.5 ML Oral Suspension', 'killed bivalent (O1 and O139) whole cell cholera vaccine in 1.5 ML Oral Suspension', 'No Corresponding SCD RXCUI', 'v. cholerae O1 Inaba E1 tor strain phil 6973 formaldehyde killed 600 EU / v.cholerae O1 ogawa classical strain cairo 50 heat killed 300 EU / v.cholerae O1 ogawa classical strain cairo 50 formaldehyde killed 300 EU / v.cholerae O1 inaba classical strain cairo 48 heat killed 300 EU / v.cholerae O139 strain 4260B formaldehyde killed 600 EU', 'Vaccine', 'Kenya SCD Version:[ v. cholerae O1 Inaba E1 tor strain phil 6973 formaldehyde killed 600 EU / v.cholerae O1 ogawa classical strain cairo 50 heat killed 300 EU / v.cholerae O1 ogawa classical strain cairo 50 formaldehyde killed 300 EU / v.cholerae O1 inaba classical strain cairo 48 heat killed 300 EU / v.cholerae O139 strain 4260B formaldehyde killed 600 EU cholera vaccine in 1.5 ML Oral Suspension] OR [v. cholerae O1 Inaba E1 tor strain 600 EU / v.cholerae O1 ogawa classical strain 300 EU / v.cholerae O1 ogawa classical strain 300 EU / v.cholerae O1 inaba classical strain 300 EU / v.cholerae O139 strain 600 EU cholera vaccine] in 1.5 ML Oral Suspension] OR [v. cholerae O1 Inaba E1 tor strain/ v.cholerae O1 ogawa classical strain / v.cholerae O1 ogawa classical strain / v.cholerae O1 inaba classical strain / v.cholerae O139 strain cholera vaccine] in 1.5 ML Oral Suspension'

-- Set the administer_methods
CREATE TABLE #methods ([Kenya Drug Retention No] varchar(20), administer_method varchar(100))
/*
SELECT ',(''' + [Kenya Drug Retention No] + ''', ''' + administer_method + ''')'
FROM [dbo].[02_21_2021 KenyaVaccines]
*/
INSERT INTO #methods VALUES
('6790', 'Intramuscular (IM) Injection')
,('6554', 'Intravenous (IV) Infusion')
,('1544', 'Intradermal (ID) Injection')
,('1767', 'Intramuscular (IM) Injection')
,('11378', 'Intramuscular (IM) Injection')
,('1485', 'Intramuscular (IM) Injection')
,('9133', 'Intramuscular (IM) Injection')
,('4495', 'Intramuscular (IM) Injection')
,('16857', 'Intramuscular (IM) Injection')
,('9035', 'Intramuscular (IM) Injection')
,('6553', 'Intramuscular (IM) Injection / Subcutaneous (SC) Injection')
,('1385', 'Subcutaneous (SC) Injection/ Intramuscular (IM) Injection')
,('7697A', 'Intramuscular (IM) Injection')
,('7697B', 'Intramuscular (IM) Injection')
,('7608A', 'Intramuscular (IM) Injection')
,('7608B', 'Intramuscular (IM) Injection')
,('6812', 'Intramuscular (IM) Injection')
,('7601A', 'Intramuscular (IM) Injection')
,('7601B', 'Intramuscular (IM) Injection')
,('6810', 'Intramuscular (IM) Injection')
,('1509', 'Intramuscular (IM) Injection / SC Injection for thrombocytopenia patients')
,('1489', 'Intramuscular (IM) Injection / SC Injection for thrombocytopenia patients')
,('7699B', 'Intramuscular (IM) Injection')
,('1777', 'Intramuscular (IM) Injection')
,('7699A', 'Intramuscular (IM) Injection')
,('1775', 'Intramuscular (IM) Injection')
,('3627', 'Intramuscular (IM) Injection')
,('3629', 'Intramuscular (IM) Injection')
,('3612B', 'Intramuscular (IM) Injection')
,('3612A', 'Intramuscular (IM) Injection')
,('7058A', 'Intramuscular (IM) Injection')
,('7058B', 'Intramuscular (IM) Injection')
,('12269', 'Intramuscular (IM) Injection')
,('9195', 'Oral')
,('1383', 'Subcutaneous (SC) Injection')
,('1381', 'Subcutaneous (SC) Injection')
,('7682', 'Subcutaneous (SC) Injection/ Intramuscular (IM) Injection')
,('6896', 'Intramuscular (IM) Injection')
,('8579', 'Intramuscular (IM) Injection')
,('12367', 'Intramuscular (IM) Injection')
,('6791', 'Intradermal (ID) Injection')
,('7692B', 'Intramuscular (IM) Injection')
,('7692A', 'Intramuscular (IM) Injection')
,('2911', 'Intramuscular (IM) Injection')
,('7884A', 'Subcutaneous (SC) Injection')
,('7884B', 'Subcutaneous (SC) Injection')
,('13677', 'Oral')
,('1921', 'Intramuscular (IM) Injection /Intradermal (ID) Injection')
,('1769', 'Intradermal (ID) Injection/ Intramuscular (IM) Injection')
,('3071', 'Intramuscular (IM) Injection /Intradermal (ID) Injection')
,('11091', 'Intramuscular (IM) Injection')
,('6310', 'Intramuscular (IM) Injection')
,('6558', 'Intramuscular (IM) Injection')
,('14101', 'Oral')
,('7691', 'Oral')
,('10093', 'Oral')
,('1386', 'Intramuscular (IM) Injection')
,('13518', 'Intramuscular (IM) Injection')
,('6345B', 'Intramuscular (IM) Injection')
,('6345A', 'Intramuscular (IM) Injection')
,('6341A', 'Intramuscular (IM) Injection')
,('6341B', 'Intramuscular (IM) Injection')
,('500', 'Intramuscular (IM) Injection')
,('7729A', 'Subcutaneous (SC) Injection')
,('7729B', 'Subcutaneous (SC) Injection')
,('6343', 'Intramuscular (IM) Injection')

/*
Intradermal (ID) Injection
Intramuscular (IM) Injection
Intravenous (IV) Infusion
Oral
Subcutaneous (SC) Injection

Intramuscular (IM) Injection /Intradermal (ID) Injection
Intradermal (ID) Injection/ Intramuscular (IM) Injection

Intramuscular (IM) Injection / SC Injection for thrombocytopenia patients
Intramuscular (IM) Injection / Subcutaneous (SC) Injection
Subcutaneous (SC) Injection/ Intramuscular (IM) Injection
*/
-- One, should pick up all the single ones and IM from the doubles
UPDATE pm SET administer_method = 
		CASE WHEN v.administer_method LIKE '%(IM)%' THEN 'IM'
			WHEN v.administer_method LIKE '%(ID)%' THEN 'INTRADERMAL'
			WHEN v.administer_method LIKE '%(IV)%' THEN 'IV'
			WHEN v.administer_method LIKE '%(SC)%' OR v.administer_method LIKE '% SC %' THEN 'Subcut'
			WHEN v.administer_method LIKE '%Oral%' THEN 'PO'
		END
/* SELECT distinct CASE WHEN v.administer_method LIKE '%(IM)%' THEN 'IM'
			WHEN v.administer_method LIKE '%(ID)%' THEN 'INTRADERMAL'
			WHEN v.administer_method LIKE '%(IV)%' THEN 'IV'
			WHEN v.administer_method LIKE '%(SC)%' OR v.administer_method LIKE '% SC %' THEN 'Subcut'
			WHEN v.administer_method LIKE '%Oral%' THEN 'PO'
		END, v.administer_method */
FROM [dbo].[c_Package_Administration_Method] pm
JOIN #methods v 
	ON (pm.package_id = 'PKKEB' + v.[Kenya Drug Retention No]
		OR pm.package_id = 'PKKEG' + v.[Kenya Drug Retention No])
WHERE pm.administer_method IS NULL
-- (93 row(s) affected)

-- An INSERT to pick up the rest of the doubles ... leaving out the first case 
--	WHEN v.administer_method LIKE '%(IM)%' THEN 'IM'
-- which would have been taken care of above
INSERT INTO [c_Package_Administration_Method] (package_id, administer_method)
SELECT DISTINCT pm.package_id, 
		CASE 
			WHEN v.administer_method LIKE '%(ID)%' THEN 'INTRADERMAL'
			WHEN v.administer_method LIKE '%(IV)%' THEN 'IV'
			WHEN v.administer_method LIKE '%(SC)%' OR v.administer_method LIKE '% SC %' THEN 'Subcut'
		END
FROM [dbo].[c_Package_Administration_Method] pm
JOIN #methods v 
	ON (pm.package_id = 'PKKEB' + v.[Kenya Drug Retention No]
		OR pm.package_id = 'PKKEG' + v.[Kenya Drug Retention No])
WHERE pm.administer_method = 'IM' -- all have IM
AND ( v.administer_method LIKE '%(ID)%' 
		OR v.administer_method LIKE '%(IV)%' 
		OR v.administer_method LIKE '%(SC)%' 
		OR v.administer_method LIKE '% SC %'
		)
AND NOT EXISTS (SELECT 1 FROM [c_Package_Administration_Method] pm2
	WHERE pm2.package_id = pm.package_id
		AND pm2.administer_method = CASE 
			WHEN v.administer_method LIKE '%(ID)%' THEN 'INTRADERMAL'
			WHEN v.administer_method LIKE '%(IV)%' THEN 'IV'
			WHEN v.administer_method LIKE '%(SC)%' OR v.administer_method LIKE '% SC %' THEN 'Subcut'
		END
		)
-- 12 rows

UPDATE c_Drug_Definition
SET drug_type = 'Vaccine' 
WHERE (common_name like '%vaccine%'
or common_name like '%antigen%'
or common_name like '%globulin%'
or common_name like '%BCG%'
or common_name like '%virus%'
or generic_name like '%vaccine%'
or generic_name like '%antigen%'
or generic_name like '%globulin%'
)
AND drug_type != 'Vaccine' 
-- (189 row(s) affected)
