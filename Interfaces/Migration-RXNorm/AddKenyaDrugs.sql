delete from c_Drug_Formulation where form_rxcui like 'KE%'
delete from c_Drug_Brand where brand_name_rxcui like 'KE%'
delete from c_Drug_Generic where generic_rxcui like 'KE%'
delete from c_Drug_Pack where rxcui like 'KE%'
delete from c_Drug_Addition

/*	 alter table c_Drug_Formulation alter column form_rxcui varchar(20) NOT NULL
	 
	 alter table c_Drug_Formulation alter column ingr_rxcui varchar(20) 
	 
alter table c_Drug_Brand alter column brand_name_rxcui varchar(20)

alter table c_Drug_Brand alter column generic_rxcui varchar(20)
alter table c_Drug_Addition alter column rxcui varchar(20)
alter table c_Drug_Addition alter column country_drug_id varchar(24)

'MCG/ ACT' -> 'MCG/ACT'
'MG/ ' -> 'MG / '
'  ' -> ' '
' /{[^M0-9 ]}' -> '/ \1'
' /{[0-9]}'
'{[A-Z]}-{[0-9]* MG}' -> '\1 \2'
*/

 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15219','Ace 500 MG Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15219','Ace 500 MG Rectal Suppository','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15219','SCD-250651')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11830','Acecor 1 % w/w Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11830','Acecor 1 % w/w Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11830','aceclofenac 1 % w/w Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11830','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11828','Acecor P 100/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11828','Acecor P 100/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11828','aceclofenac 100 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11828','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11889','Acepar Plus 100 MG / 4 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11889','Acepar Plus 100 MG / 4 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11889','aceclofenac 100 MG / thiocolchicoside 4 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11889','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9825','Acepar-SP Oral Caplet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9825','Acepar-SP Oral Caplet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9825','aceclofenac 100 MG / paracetamol 500 MG / serratiopeptidase 15 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9825','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11518','Aclofre-P 100/375 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11518','Aclofre-P 100/375 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11518','aceclofenac 100 MG / paracetamol 375 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11518','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13360','Aclosara-MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13360','Aclosara-MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13360','aceclofenac BP 100 MG / paracetamol BP 325 MG / chlorzoxazone USP 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13360','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14362','Actidrox 250 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14362','Actidrox 250 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14362','SCD-309048')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI214','ACTrapid 100 UNITS/ML Insulin Human, Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB214','ACTrapid 100 UNITS/ML Insulin Human, Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE214','SCD-311034')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI282Pen','ACTrapid FlexPen 100 UNITS/ML Insulin Human, Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB282Pen','ACTrapid FlexPen 100 UNITS/ML Insulin Human, Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG282Pen','soluble insulin, human 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE282Pen','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI282','ACTrapid Penfill 100 UNITS/ML Insulin Human, Solution for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB282','ACTrapid Penfill 100 UNITS/ML Insulin Human, Solution for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG282','soluble insulin, human 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE282','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11842','Acufen XP 100/325 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11842','Acufen XP 100/325 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11842','aceclofenac 100 MG / paracetamol 325 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11842','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5940','Acular 0.5 % Opthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5940','Acular 0.5 % Opthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5940','SCD-860107')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11190','Aderan 32 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11190','Aderan 32 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11190','SCD-639537')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14370','Adol Infants'' Drops 100 MG/ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14370','Adol Infants'' Drops 100 MG/ML Oral Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14370','SCD-238159')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1819','Advant 16 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1819','Advant 16 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1819','SCD-577776')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1818','Advant 8 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1818','Advant 8 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1818','SCD-153823')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3268','Advantec 16/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3268','Advantec 16/12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3268','SCD-578325')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8719','Aerovent Metered Dose Inhaler, 200 Metered Doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8719','Aerovent Metered Dose Inhaler, 200 Metered Doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8719','beclometasone 50 MCG /ACTUAT / salbutamol 100 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8719','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10053','Aflodor 16 Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10053','Aflodor 16 Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10053','aceclofenac 200 MG / thiocolchicoside 16 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10053','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10052','Aflodor 8 Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10052','Aflodor 8 Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10052','aceclofenac 200 MG / thiocolchicoside 8 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10052','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1426','Airtal 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1426','Airtal 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1426','SCD-152544')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12200','Akudinir 250 MG Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12200','Akudinir 250 MG Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12200','cefdinir 250 MG Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12200','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12202','Akudinir 300 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12202','Akudinir 300 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12202','SCD-200346')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI280','Albasol 200 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB280','Albasol 200 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG280','albendazole 200 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE280','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2372','Albuzol 200 MG Chewable Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2372','Albuzol 200 MG Chewable Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2372','SCD-333832')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11169','Aldomet 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11169','Aldomet 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11169','SCD-197956')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11170','Aldomet 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11170','Aldomet 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11170','SCD-197958')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5080','Amaryl 3 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5080','Amaryl 3 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5080','SCD-153842')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5176','Amaryl M 2/500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5176','Amaryl M 2/500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5176','glimepiride 2 MG / metFORMIN HCl 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5176','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5199','Amaryl M SR 2/500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5199','Amaryl M SR 2/500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5199','glimepiride 2 MG / metFORMIN HCl HCl 500 MG Sustained Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5199','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2166','Amdocal Plus 25 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2166','Amdocal Plus 25 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2166','amLODIPine besilate BP 5 MG / atenolol BP 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2166','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2170','Amdocal Plus 50 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2170','Amdocal Plus 50 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2170','amLODIPine besilate BP 5 MG / atenolol BP 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2170','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5214','Amlibon 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5214','Amlibon 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5214','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2535','Amlibon 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2535','Amlibon 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2535','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8746','Amlocip NB 5/5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8746','Amlocip NB 5/5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8746','amLODIPine 5 MG / nebivolol 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8746','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3060','Amlo-Denk 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3060','Amlo-Denk 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3060','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3092','Amlo-Denk 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3092','Amlo-Denk 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3092','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9820','Amlostar 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9820','Amlostar 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9820','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI937','Amlovas 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB937','Amlovas 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE937','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI934','Amlovas 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB934','Amlovas 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE934','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI227','Amlozaar 50 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB227','Amlozaar 50 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG227','amLODIPine besilate 5 MG / losartan potassium IP 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE227','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6087','Amlozaar-H 5/50/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6087','Amlozaar-H 5/50/12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6087','amLODIPine 5 MG / losartan potassium 50 MG / hydrochlorothiazide 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6087','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13094','Amoklavin ES 600/42.9 MG Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13094','Amoklavin ES 600/42.9 MG Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13094','amoxicillin 600 MG / clavulanic acid 42.9 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13094','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9598','Amoxiclav-Denk 1000/125 Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9598','Amoxiclav-Denk 1000/125 Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9598','amoxicillin 1000 MG / clavulanic acid 125 MG Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9598','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10752','AmoxiClav-Denk 500/62.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10752','AmoxiClav-Denk 500/62.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10752','amoxicillin 500 MG / clavulanate potassium 62.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10752','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3146','Amoxi-Denk 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3146','Amoxi-Denk 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3146','SCD-308192')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12375','Ampcare 500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12375','Ampcare 500 MG Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12375','SCD-1721474')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI822','Ampecin 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB822','Ampecin 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE822','SCD-313799')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2027','Ampicen 500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2027','Ampicen 500 MG Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2027','SCD-1721474')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6142','Ampiclomed 500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6142','Ampiclomed 500 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6142','ampicillin 250 MG / cloxacillin 250 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6142','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2700','Ampiclox 250 MG Powder for Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2700','Ampiclox 250 MG Powder for Oral Solution ','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2700','ampicillin 125 MG / cloxacillin 125 MG in 5 ML Powder for Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2700','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2676','Ampiclox 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2676','Ampiclox 500 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2676','ampicillin 250 MG / cloxacillin 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2676','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2682','Ampiclox 90 MG Neonatal Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2682','Ampiclox 90 MG Neonatal Drops','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2682','ampicillin 60 MG / cloxacillin 30 MG in 0.6 ML Neonatal Drops','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2682','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7602','Ampoxin 1 GM Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7602','Ampoxin 1 GM Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7602','ampicillin 500 MG / cloxacillin 500 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7602','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7580','Ampoxin 500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7580','Ampoxin 500 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7580','ampicillin 250 MG / cloxacillin 250 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7580','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5310','Amqunate Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5310','Amqunate Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5310','artesunate 50 MG / amodiaquine 153 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5310','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11742','Amqunate Forte Combipack',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11742','Amqunate Forte Combipack','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11742','artesunate 200 MG / amodiaquine 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11742','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6023','Amqunate P Dispersible Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6023','Amqunate P Dispersible Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6023','artesunate 25 MG / amodiaquine 76.5 MG Dispersible Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6023','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5739','Amtas 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5739','Amtas -10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5739','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5740','Amtas-AT Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5740','Amtas-AT Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5740','amLODIPine besylate IP 5 MG / atenolol IP 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5740','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2646','Amtel 40 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2646','Amtel 40 MG / 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2646','SCD-876524')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10270','Amtel 80 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10270','Amtel 80 MG / 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10270','SCD-876519')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10266','Amtel 80 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10266','Amtel 80 MG / 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10266','SCD-876529')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1827','Anadol 100 MG in 2 ML Injectable Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1827','Anadol 100 MG in 2 ML Injectable Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1827','traMADol HCL 100 MG in 2 ML Injectable Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1827','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1825','Anadol 50 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1825','Anadol 50 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1825','SCD-836466')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9380','Anamint Oral Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9380','Anamint Oral Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9380','metroNIDAZOLE 10 MG / chlorhexidine gluconate 0.25 % w/w in 1 GM Oral Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9380','Dental')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2622','Anginal 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2622','Anginal 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2622','SCD-381056')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3192','APC Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3192','APC Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3192','paracetamol BP 250 MG / aspirin BP 250 MG / caffeine BP 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3192','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11726','Apflu Syrup Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11726','Apflu Syrup Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11726','paracetamol BP 120 MG / chlorpheniramine maleate BP 0.5 MG / vitamin C BP 50 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11726','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12233','Apidra Solostar 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12233','Apidra Solostar 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12233','SCD-847259')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9006','Aprovasc 150 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9006','Aprovasc 150 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9006','irbesartan 150 MG / amLODIPine besylate 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9006','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7742','Aprovasc 150 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7742','Aprovasc 150 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7742','irbesartan 150 MG / amLODIPine besylate 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7742','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9009','Aprovasc 300 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9009','Aprovasc 300 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9009','irbesartan 300 MG / amLODIPine besylate 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9009','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9008','Aprovasc 300 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9008','Aprovasc 300 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9008','irbesartan 300 MG / amLODIPine besylate 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9008','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5298','Aprovel 150 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5298','Aprovel 150 mg Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5298','SCD-200095')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5374','Aprovel 300 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5374','Aprovel 300 mg Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5374','SCD-200096')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9889','Arbitel-AV 40/10 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9889','Arbitel-AV 40/10 mg Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9889','telmisartan IP 40 MG / atorvastatin calcium IP 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9889','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1293','Artefan Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1293','Artefan Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1293','artemether 180 MG / lumefantrine 1080 MG in 60 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1293','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1358','Artefan Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1358','Artefan Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1358','artemether 20 MG / lumefantrine 120 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1358','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1270','Artefan 20 MG / 120 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1270','Artefan 20 MG / 120 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1270','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15615','Artefan 60 MG / 360 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15615','Artefan 60 MG / 360 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15615','artemether 60 MG / lumefantrine 360 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15615','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1360','Artequick',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1360','Artequick','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1360','artemisinin 62.5 MG / piperaquine 375 MG','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1360','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1445','Artesiane 20 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1445','Artesiane 20 MG/ML Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1445','artemether 20 MG/ML Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1445','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12227','Artesiane 300 MG Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12227','Artesiane 300 MG Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12227','artemether 300 MG in 3 mL Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12227','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI129','Artesun 30 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB129','Artesun 30 MG/ML Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG129','artesunate 30 MG Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE129','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI130','Artesun 60 MG Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB130','Artesun 60 MG Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG130','artesunate 60 MG Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE130','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5419','Artesunate Amodiaquine Winthrop 100 MG / 270 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5419','Artesunate Amodiaquine Winthrop 100 MG / 270 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5419','artesunate 100 MG / amodiaquine 270 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5419','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5376','Artesunate Amodiaquine Winthrop 25 MG / 67.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5376','Artesunate Amodiaquine Winthrop 25 MG / 67.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5376','artesunate 25 MG / amodiaquine 67.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5376','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5413','Artesunate Amodiaquine Winthrop 50/135 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5413','Artesunate Amodiaquine Winthrop 50/135 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5413','artesunate 50 MG / amodiaquine 135 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5413','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7937','Asomex-LT 2.5 MG / 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7937','Asomex-LT 2.5 MG / 50 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7937','s (-) amlodipine besylate 2.5 MG / losartan potassium 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7937','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7938','Asomex 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7938','Asomex 2.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7938','s (-) amlodipine besylate IP 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7938','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7939','Asomex 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7939','Asomex 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7939','s (-) amlodipine besylate IP 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7939','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6417','ASP 81 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6417','ASP 81 MG Oral Tablet','SBD_KE') 	
 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3733','aspirin 300 MG Oral Tablet','SCD_KE') 	
 
 
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14983','Aspro 324 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14983','Aspro 324 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14983','aspirin 324 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14983','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5690','Atacand Plus 16/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5690','Atacand Plus 16/12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5690','SCD-578325')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2612','SCD-197380')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3139','Atenolol Denk 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3139','Atenolol Denk 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3139','SCD-197381')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI511','ATM 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB511','ATM 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE511','SCD-308460')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9700','Atorem 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9700','Atorem 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9700','SCD-617311')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8637','Atorlip EZ 10/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8637','Atorlip EZ 10/10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8637','SCD-1422086')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2758','Augmentin 312 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2758','Augmentin 312 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2758','SCD-617322')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2759','Augmentin 375 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2759','Augmentin 375 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2759','SCD-562251')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2761','Augmentin 625 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2761','Augmentin 625 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2761','SCD-617296')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2739','Augmentin ES 600/42.9 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2739','Augmentin ES 600/42.9 MG in 5 ML Powder for Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2739','SCD-617993')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10376','Auroliza-H 10 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10376','Auroliza-H 10 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10376','SCD-197885')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1738','Aurozil 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1738','Aurozil 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1738','SCD-309080')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1739','Aurozil 250 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1739','Aurozil 250 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1739','SCD-309081')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1737','Aurozil 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1737','Aurozil 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1737','SCD-197453')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8176','Avas 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8176','Avas 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8176','SCD-617312')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9559','Avastatin 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9559','Avastatin 40 MG Oral Tablet ','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9559','SCD-617311')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13271','Aveza 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13271','Aveza 20 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13271','teneLIGLiptin 20 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13271','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11136','Avsar 160 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11136','Avsar 160 MG / 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11136','SCD-722134')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11137','Avsar 160/10 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11137','Avsar 160/10 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11137','SCD-722126')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11135','Avsar 80 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11135','Avsar 80 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11135','amLODIPine 5 MG / valsartan 80 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11135','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4392','Axylin Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4392','Axylin Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4392','ampicillin 125 MG / cloxacillin 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4392','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6822','Azarga Eye Drops Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6822','Azarga Eye Drops Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6822','brinzolamide 10 MG / timolol maleate 5 MG in 1 mL Eye Drops Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6822','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11916','Azidawa 100 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11916','Azidawa 100 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11916','azithromycin 100 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11916','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2307','Azmasol HFA Inhaler, 200 Metered Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2307','Azmasol HFA Inhaler, 200 Metered Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2307','salbutamol sulphate 100 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2307','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7523','Aztor EZ 10/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7523','Aztor EZ 10/10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7523','SCD-1422086')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4409','Baby Gripe Water',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4409','Baby Gripe Water','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4409','sodium bicarbonate 1.2 % / sodium citrate 0.5 % / dill oil 0.58% / anise oil 0.12 % / ginger tincture 0.5 %','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4409','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1839','Beclomin 250 HFA Inhaler, 200 Puffs',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1839','Beclomin 250 HFA Inhaler, 200 Puffs','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1839','beclometasone diproprionate 250 MCG/ Puff HFA Inhaler, 200 Puffs','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1839','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11447','Bedranol 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11447','Bedranol 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11447','SCD-856448')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11446','Bedranol 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11446','Bedranol 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11446','SCD-856519')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10856','Benaworm 400 MG in 10 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10856','Benaworm 400 MG in 10 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10856','albendazole 400 MG in 10 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10856','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1161','Benduric 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1161','Benduric 2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1161','SCD-308614')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1126','Benduric 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1126','Benduric 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1126','bendroflumethiazide 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1126','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4138','Benylin Daytime Flu Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4138','Benylin Daytime Flu Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4138','SCD-1299021')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1035','Benylin Four Flu Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1035','Benylin Four Flu Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1035','paracetamol 1000 MG / diphenhydramine HCL 25 MG / pseudoephedrine HCL 45 MG in 20 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1035','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3172','Benylin Original 12.5 MG / 125 MG in 5 ML Cough Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3172','Benylin Original 12.5 MG / 125 MG in 5 ML Cough Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3172','diphenhydrAMINE HCl 12.5 MG / ammonium chloride 125 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3172','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI938','Benylin Paediatric 7 MG in 5 ML Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB938','Benylin Paediatric 7 MG in 5 ML Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG938','diphenhydrAMINE HCl 7 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE938','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12154','Beta Cool Double Action Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12154','Beta Cool Double Action Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12154','sodium alginate 500 MG / sodium bicarbonate 265 MG in 10 mL','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12154','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7106','Betafen Plus Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7106','Betafen Plus Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7106','ibuprofen 100 MG / paracetamol 120 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7106','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6689','Betaloc ZoK 100 MG Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6689','Betaloc ZoK 100 MG Controlled Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6689','SCD-866412')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6354','Betaloc Zok 25 MG Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6354','Betaloc Zok 25 MG Controlled Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6354','SCD-866427')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6685','Betaloc ZoK 50 MG Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6685','Betaloc ZoK 50 MG Controlled Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6685','SCD-866436')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8159','Betapyn Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8159','Betapyn Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8159','codeine phosphate 10 MG / doxylamine succinate 5 MG / paracetamol 450 MG / caffeine 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8159','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7081','Betrozole Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7081','Betrozole Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7081','metroNIDAZOLE benzoate 160 MG / diloxanide furoate 125 MG / simethicone 25 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7081','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15702Ear','Beuflox-D 0.3 % / 0.1 % Ear Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15702Ear','Beuflox-D 0.3 % / 0.1 % Ear Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15702Ear','SCD-403908')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15702','Beuflox-D 0.3 % / 0.1 % Eye Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15702','Beuflox-D 0.3 % / 0.1 % Eye Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15702','ciprofloxacin 0.3 % / dexamethasone 0.1 % Ophthalmic Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15702','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2315','Bexitrol -F HFA Inhaler 25/125, 120 Metered Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2315','Bexitrol -F HFA Inhaler 25/125, 120 Metered Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2315','salmeterol 25 MCG/ACTUAT / fluticasone propionate 125 MCG/ACTUAT Metered Dose Inhaler, 120 Metered Inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2315','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2318','Bexitrol -F HFA Inhaler 25/250, 120 Metered Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2318','Bexitrol -F HFA Inhaler 25/250, 120 Metered Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2318','salmeterol 25 MCG/ACTUAT / fluticasone propionate 250 MCG/ACTUAT Metered Dose Inhaler, 120 Metered Inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2318','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7385','bi Preterax 10 MG/2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7385','bi Preterax 10 MG/2.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7385','perindopril arginine 10 MG / indapamide 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7385','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7387','bi Preterax 5 MG / 1.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7387','bi Preterax 5 MG / 1.25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7387','perindopril arginine 5 MG / indapamide 1.25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7387','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9416','Bifril 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9416','Bifril 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9416','zofenopril calcium 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9416','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11560','Bifril Plus 30 MG/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11560','Bifril Plus 30 MG/12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11560','zofenopril calcium 30 MG / hydrochlorothiazide 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11560','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6901','Bimonate 8.4 % w/v 10 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6901','Bimonate 8.4 % w/v 10 ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6901','SCD-1923484')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI246','Biodroxil 1000 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB246','Biodroxil 1000 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE246','SCD-309047')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI247','Biodroxil 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB247','Biodroxil 125 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG247','cefadroxil 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE247','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI248','Biodroxil 250 MG in 5 ML Granules for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB248','Biodroxil 250 MG in 5 ML Granules for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG248','cefadroxil 250 MG in 5 ML Granules for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE248','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI245','Biodroxil 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB245','Biodroxil 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE245','SCD-309049')
 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12434','bisoprolol 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12434','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12435','SCD-854905')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1432','Blokium 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1432','Blokium 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1432','SCD-197379')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1429','Blokium 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1429','Blokium 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1429','SCD-197381')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1433','Blokium DIU 100/25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1433','Blokium DIU 100/25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1433','SCD-197382')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6722','Brilinta 90 mg Tablets',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6722','Brilinta 90 mg Tablets','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6722','SCD-1116635')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6198','Bromodel 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6198','Bromodel 2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6198','SCD-197411')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6458','Bromsal Expectorant, Bronchodilator Mucolytic Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6458','Bromsal Expectorant, Bronchodilator Mucolytic Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6458','salbutamol sulphate 1 MG / bromhexine hydrochloride 2 MG / guaifenesin 50 MG / menthol 0.5 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6458','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8169','BronchoPed Expectorant and Bronchodilator Oral Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8169','BronchoPed Expectorant and Bronchodilator Oral Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8169','terbutaline sulphate 1.25 MG / ammonium chloride 60 MG / sodium citrate 25 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8169','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2611','Bro-Zedex Cough Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2611','Bro-Zedex Cough Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2611','terbutaline sulphate 2.5 MG / bromhexine hydrochloride 8 MG / guaifenesin 100 MG / menthol 5 MG in 10 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2611','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2981','Brustan 100/125 Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2981','Brustan 100/125 Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2981','ibuprofen 100 MG / paracetamol 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2981','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8541','Budecort 100 Metered Dose Inhaler, 200 Doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8541','Budecort 100 Metered Dose Inhaler, 200 Doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8541','budesonide IP 100 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8541','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8540','Budecort 200 Metered Dose Inhaler, 200 Metered Doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8540','Budecort 200 Metered Dose Inhaler, 200 Metered Doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8540','budesonide IP 200 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8540','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI429','Buscopan 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB429','Buscopan 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE429','SCD-199442')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI424','Buscopan 20 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB424','Buscopan 20 MG/ML Solution for Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE424','SCD-1094495')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3203','Buscopan Plus 10/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3203','Buscopan Plus 10/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3203','hyoscine butylbromide 10 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3203','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1577','Caduet 10/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1577','Caduet 10/10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1577','SCD-597987')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16250','Camox 1000 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16250','Camox 1000 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG16250','amoxicillin 1000 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16250','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9040','Candez 16 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9040','Candez 16 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9040','SCD-577776')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI731','Candez 8 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB731','Candez 8 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE731','SCD-153823')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3144','Captopril Denk 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3144','Captopril Denk 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3144','SCD-317173')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3145','Captopril+HCT Denk 50/25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3145','Captopril+HCT Denk 50/25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3145','SCD-197439')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5743','Carca 3.125 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5743','Carca 3.125 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5743','SCD-686924')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5744','Carca 6.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5744','Carca 6.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5744','SCD-200031')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3225','Cardi 80 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3225','Cardi 80 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3225','aspirin 80 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3225','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5720','Cardinol 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5720','Cardinol 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5720','SCD-197379')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1172','Cardinol 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1172','Cardinol 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1172','SCD-197380')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6352','Cardinol 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6352','Cardinol 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6352','SCD-197381')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11683','Cardisprin 75 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11683','Cardisprin 75 MG Dispersible Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11683','SCD-104475')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2223','Cardisprin 75 MG Enteric Coated Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2223','Cardisprin 75 MG Enteric Coated Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2223','SCD-104474')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1074','Carditan 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1074','Carditan 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1074','SCD-979492')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7644','Carditan AM 50/5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7644','Carditan AM 50/5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7644','amLODIPine 5 MG / losartan potassium 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7644','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4928','Carditan H 50/125 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4928','Carditan H 50/125 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4928','SCD-979468')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7500','Cardivas 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7500','Cardivas 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7500','SCD-200032')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2333','Cardopril 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2333','Cardopril 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2333','SCD-317173')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9600','Carvedi-Denk 25 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9600','Carvedi-Denk 25 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9600','SCD-200033')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9599','Carvedi-Denk 6.25 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9599','Carvedi-Denk 6.25 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9599','SCD-200031')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13284','Ceclonec-S 200 MG / 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13284','Ceclonec-S 200 MG / 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13284','aceclofenac 200 MG / serratiopeptidase 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13284','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7293','Cefacure 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7293','Cefacure 250 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7293','SCD-309112')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7292','Cefacure 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7292','Cefacure 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7292','SCD-309114')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11149','Cef-Clave 50 MG / 31.25 MG in 5 ML Powder for Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11149','Cef-Clave 50 MG / 31.25 MG in 5 ML Powder for Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11149','cefixime 50 MG / clavulanic acid 31.25 MG in 5 ML Powder for Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11149','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12395','Cefo-bact 1 GM Intravenous/Intramuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12395','Cefo-bact 1 GM Intravenous/Intramuscular Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12395','cefoperazone 500 MG / sulbactam 500 MG Intravenous/Intramuscular Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12395','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11705','Cefo-L Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11705','Cefo-L Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11705','cefixime 50 MG / lactic acid bacillus 60 million spores in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11705','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11704','Cefo-L 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11704','Cefo-L 200 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11704','cefixime 200 MG / lactic acid bacillus 60 million spores Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11704','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3770','Cefpodox 100 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3770','Cefpodox 100 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3770','cefpodoxime 100 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3770','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9740','CEFzole 1 GM Intramuscular/Intravenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9740','CEFzole 1 GM Intramuscular/Intravenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9740','SCD-1665050')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2186','Cemet 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2186','Cemet 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2186','SCD-197505')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2196','Cemet 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2196','Cemet 400 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2196','SCD-197507')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI516','Ceprolen 0.3 % Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB516','Ceprolen 0.3 % Eye Drops','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG516','ciprofloxacin 0.3 % Ophthalmic Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE516','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI515','Ceprolen-D 0.3 % / 0.1 % Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB515','Ceprolen-D 0.3 % / 0.1 % Eye Drops','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG515','ciprofloxacin 0.3 % / dexamethasone 0.1 % Ophthalmic Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE515','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI428','Cetamol 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB428','Cetamol 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE428','SCD-198440')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10647','CEzol 1 GM Intramuscular/Intravenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10647','CEzol 1 GM Intramuscular/Intravenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10647','SCD-1665050')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI693','Cholergol 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB693','Cholergol 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG693','nicergoline 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE693','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12228','Cholestrom 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12228','Cholestrom 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12228','SCD-617312')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12229','Cholestrom 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12229','Cholestrom 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12229','SCD-617310')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8853','Ciclohale 160 MCG/Dose Inhaler',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8853','Ciclohale 160 MCG/Dose Inhaler','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8853','ciclesonide 160 MCG/INHAL Metered Dose Inhaler, 120 Actuations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8853','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8854','Ciclohale 80 MCG/Dose Inhaler',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8854','Ciclohale 80 MCG/Dose Inhaler','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8854','ciclesonide 80 MCG/INHAL Metered Dose Inhaler, 120 Actuations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8854','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15490','Cilneed 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15490','Cilneed 10 MG Oral Tablet ','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15490','cilnidipine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15490','Needs TMSY')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1580','Ciloxan 0.3 % Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1580','Ciloxan 0.3 % Eye Drops','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1580','SCD-309307')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15189','Cilvas 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15189','Cilvas 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15189','cilnidipine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15189','Needs TMSY')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9377','Cinepar Kid Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9377','Cinepar Kid Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9377','ibuprofen BP 100 MG / paracetamol BP 162.5 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9377','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI963','Ciprobay 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB963','Ciprobay 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE963','SCD-309309')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI166','Ciprobay 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB166','Ciprobay 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE166','SCD-197512')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1581','Ciprobay HC Otic Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1581','Ciprobay HC Otic Drops','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1581','SCD-309305')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1184','Cipro-Cent 0.3 % Eye Ointment',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1184','Cipro-Cent 0.3 % Eye Ointment','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1184','SCD-309306')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3233','Cipro-Denk 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3233','Cipro-Denk 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3233','SCD-309309')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11983','Cipro-Denk 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11983','Cipro-Denk 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11983','SCD-197512')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1457','Cipronat 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1457','Cipronat 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1457','SCD-197511')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1460','Cipronat 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1460','Cipronat 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1460','SCD-197512')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8921','Cipro-T 500 MG / 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8921','Cipro-T 500 MG / 600 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8921','ciprofloxacin 500 MG / tinidazole 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8921','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8170','Citro-Soda Gastric Antacid Effervescent Granules 60 Grams',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8170','Citro-Soda Gastric Antacid Effervescent Granules 60 Grams','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8170','sodium bicarbonate 1716 MG / tartaric acid 858 MG / citric acid 702 MG / sodium citrate 613 MG in 4 Grams','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8170','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2812','Clavulin 875 MG / 125 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2812','Clavulin 875 MG / 125 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2812','SCD-562508')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2806','Clavulin 228.5 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2806','Clavulin 228.5 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2806','SCD-617423')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2802','Clavulin 400 MG / 57 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2802','Clavulin 400 MG / 57 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2802','SCD-617430')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2810','Clavulin 625 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2810','Clavulin 625 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2810','SCD-617296')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6931','Clear-T Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6931','Clear-T Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6931','clindamycin phosphate 1 % / tretinoin 0.025 % Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6931','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9591','Cledomox DT 228.5 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9591','Cledomox DT 228.5 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9591','amoxicillin 200 MG / clavulanate potassium 28.5 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9591','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5870','Clexane 20 MG / 0.2 ML Prefilled Syringe',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5870','Clexane 20 MG / 0.2 ML Prefilled Syringe','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5870','enoxaparin sodium 20 MG in 0.2 ML Prefilled Syringe','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5870','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5877','Clexane 40 MG / 0.4 ML Prefilled Syringe',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5877','Clexane 40 MG / 0.4 ML Prefilled Syringe','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5877','SCD-854235')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5879','Clexane 60 MG / 0.6 ML Prefilled Syringe',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5879','Clexane 60 MG / 0.6 ML Prefilled Syringe','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5879','SCD-854238')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5880','Clexane 80 MG / 0.8 ML Prefilled Syringe',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5880','Clexane 80 MG / 0.8 ML Prefilled Syringe','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5880','SCD-854241')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5642','Clindar-T 1% Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5642','Clindar-T 1% Topical Gel','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5642','SCD-309332')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4991','Clindar-T Plus Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4991','Clindar-T Plus Topical Gel','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4991','SCD-882548')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5293','Clindar-V 2 % Vaginal Cream',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5293','Clindar-V 2 % Vaginal Cream','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5293','SCD-309337')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8917','Clopid ASP 75/75 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8917','Clopid ASP 75/75 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8917','clopidogrel 75 MG / aspirin 75 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8917','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10737','Clopi-Denk 75 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10737','Clopi-Denk 75 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10737','SCD-309362')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5336','CoAprovel 150/12.5 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5336','CoAprovel 150/12.5 mg Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5336','SCD-310792')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5428','CoAprovel 300/12.5 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5428','CoAprovel 300/12.5 mg Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5428','SCD-310793')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5426','CoAprovel 300/25 mg Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5426','CoAprovel 300/25 mg Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5426','SCD-485471')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2470','Coartem Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2470','Coartem Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2470','artemether 20 MG / lumefantrine 120 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2470','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1505','Co-Artesiane Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1505','Co-Artesiane Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1505','artemether 180 MG / lumefantrine 1080 MG in 60 mL Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1505','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15190','Cocoflu Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15190','Cocoflu Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15190','SCD-1297288')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10329','Co-Corither Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10329','Co-Corither Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10329','artemether 180 MG / lumefantrine 1080 MG in 60 mL Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10329','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6920','SCD-997285')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2814','Co-Diovan 160 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2814','Co-Diovan 160 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2814','SCD-200285')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2804','Co-Diovan 80 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2804','Co-Diovan 80 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2804','SCD-200284')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5478','Colastin-L 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5478','Colastin-L 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5478','SCD-617310')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2996','Coldcap Daytime Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2996','Coldcap Daytime Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2996','paracetamol 500 MG / caffeine 30 MG / pseudoephedrine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2996','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI496','Coldcap Night Time Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB496','Coldcap Night Time Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG496','paracetamol 500 MG / chlorpheniramine maleate 2 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE496','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI510','Coldcap Original Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB510','Coldcap Original Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG510','paracetamol 400 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE510','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI588','Coldcap Syrup Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB588','Coldcap Syrup Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG588','paracetamol 120 MG / chlorpheniramine maleate 2 MG / pseudoephedrine HCl 10 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE588','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3287','ColdFlu Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3287','ColdFlu Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3287','paracetamol 400 MG / chlorpheniramine maleate 4 MG / phenylephrine HCL 5 MG / caffeine anhydrous 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3287','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11124','Coldril Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11124','Coldril Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11124','paracetamol BP 120 MG / chlorpheniramine maleate BP 1 MG / pseudoephedrine HCl BP 10 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11124','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11122','Coldril Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11122','Coldril Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11122','paracetamol 500 MG / chlorpheniramine maleate 2 MG / pseudoephedrine HCL 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11122','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9552','Colestop 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9552','Colestop 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9552','SCD-617310')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10088','CoLosar-Denk 100/12.5 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10088','CoLosar-Denk 100/12.5 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10088','SCD-979464')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7162','Co-Malather Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7162','Co-Malather Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7162','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11125','Co-Malather Compact Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11125','Co-Malather Compact Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11125','artemether 80 MG / lumefantrine 480 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11125','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2246','Co-Max Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2246','Co-Max Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2246','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2566','Comax DPS Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2566','Comax DPS Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2566','artemether 15 MG / lumefantrine 90 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2566','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3715','Combiart Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3715','Combiart Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3715','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6235','Combigan Ophthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6235','Combigan Ophthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6235','SCD-861635')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12610','Combisun 400/500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12610','Combisun 400/500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12610','ibuprofen 400 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12610','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2421','Combivent UDV inhalation solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2421','Combivent UDV inhalation solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2421','ipratropium bromide 0.5 MG / salbutamol 2.5 MG in 2.5 ML inhalation solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2421','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1154','Co-Micardis 40 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1154','Co-Micardis 40 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1154','SCD-283316')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1175','Co-Micardis 80 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1175','Co-Micardis 80 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1175','SCD-283317')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10203','Concor 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10203','Concor 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10203','SCD-854901')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10202','Concor 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10202','Concor 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10202','SCD-854905')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI146','Contus Plus Paediatric Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB146','Contus Plus Paediatric Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG146','paracetamol BP 160 MG / chlorphenamine maleate BP 1 MG / phenylephrine HCl BP 5 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE146','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7547','Corbis 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7547','Corbis 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7547','SCD-854901')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7576','Corbis-H 10 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7576','Corbis-H 10 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7576','SCD-854908')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7550','Corbis-H 5 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7550','Corbis-H 5 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7550','SCD-854919')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12301','Corither 100 MG Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12301','Corither 100 MG Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12301','artemether 100 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12301','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10316','Corither AB 75 MG/ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10316','Corither AB 75 MG/ML Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10316','alpha-beta arteether 75 MG in 1 mL Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10316','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5283','Cortec 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5283','Cortec 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5283','SCD-858813')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5289','Cortec Plus 10/25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5289','Cortec Plus 10/25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5289','SCD-858828')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7346','Coscof CD Linctus Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7346','Coscof CD Linctus Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7346','codeine phosphate 6 MG / chlorpheniramine maleate 2 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7346','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11751','Coveram 10 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11751','Coveram 10 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11751','amLODIPine besilate 10 MG / perindopril arginine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11751','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11748','Coveram 10 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11748','Coveram 10 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11748','amLODIPine besilate 5 MG / perindopril arginine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11748','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11752','Coveram 5 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11752','Coveram 5 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11752','amLODIPine besilate 10 MG / perindopril arginine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11752','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11744','Coveram 5 MG / 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11744','Coveram 5 MG / 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11744','amLODIPine besilate 5 MG / perindopril arginine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11744','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7405','Coversyl 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7405','Coversyl 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7405','perindopril arginine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7405','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7402','Coversyl 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7402','Coversyl 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7402','perindopril arginine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7402','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6744','SCD-859747')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7649','SCD-859751')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7650','SCD-859419')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6743','SCD-859424')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI241','Curam 1000 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB241','Curam 1000 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE241','SCD-562508')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI267','Curam 156.25 MG in 5 ML',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB267','Curam 156.25 MG in 5 ML','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE267','SCD-617302')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15791','Curam 457 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15791','Curam 457 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15791','amoxicillin 400 MG / clavulanic acid 57 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15791','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI237','Curam 625 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB237','Curam 625 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE237','SCD-617296')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1493','Curamol Plus 500/60 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1493','Curamol Plus 500/60 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1493','paracetamol 500 MG / caffeine 60 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1493','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI743','Curaquin Syrup 100 MG/5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB743','Curaquin Syrup 100 MG/5 ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG743','quiNINE HCI equivalent to quiNINE 100 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE743','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI532','Cyclopam-P 20/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB532','Cyclopam-P 20/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG532','dicycloverine HCl 20 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE532','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1517','Dacof Mucolytic Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1517','Dacof Mucolytic Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1517','salbutamol sulphate BP 2 MG / bromhexine hydrochloride BP 4 MG / guaifenesin BP 100 MG / menthol BP 1 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1517','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2565','Dalacin C 150 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2565','Dalacin C 150 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2565','SCD-197518')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2567','Dalacin C 300 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2567','Dalacin C 300 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2567','SCD-284215')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3307','Dalacin C 75 MG in 5 ML Granules for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3307','Dalacin C 75 MG in 5 ML Granules for Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3307','SCD-562266')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5883','Daonil 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5883','Daonil 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5883','SCD-310537')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI58','D-Artepp 40 MG / 320 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB58','D-Artepp 40 MG / 320 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG58','dihydroartemisinin 40 MG / piperaquine phosphate 320 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE58','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1917','Dawadoxyn 100 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1917','Dawadoxyn 100 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1917','doxycycline HCl 100 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1917','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8193','Dawanol 200 / 300 / 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8193','Dawanol 200 / 300 / 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8193','paracetamol 200 MG / aspirin 300 MG / caffeine 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8193','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8432','Dawasprin 300 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8432','Dawasprin 300 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8432','SCD-199281')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13035','Dawasprin 75 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13035','Dawasprin 75 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13035','SCD-104474')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1500','Deep Relief Anti-Inflammatory Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1500','Deep Relief Anti-Inflammatory Topical Gel','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1500','SCD-392668')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI149','De-Spas 20/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB149','De-Spas 20/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG149','dicyclomine 20 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE149','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9583','Dexpure 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9583','Dexpure 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9583','dexrabeprazole 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9583','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3623','DF118 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3623','DF118 Oral Tablet ','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3623','SCD-1236182')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3091','DHC 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3091','DHC 30 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3091','SCD-1236182')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2382','Diactin 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2382','Diactin 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2382','SCD-310490')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3475','Diagluc 80 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3475','Diagluc 80 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3475','SCD-199825')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7412','Diamicron MR 60 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7412','Diamicron MR 60 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7412','gliclazide 60 MG Modified Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7412','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6996','Diapride Plus 1 MG / 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6996','Diapride Plus 1 MG / 500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6996','glimepiride 1 MG / metFORMIN HCl HCl 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6996','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5240','Diasix 10 MG/ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5240','Diasix 10 MG/ML Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5240','furosemide 10 MG in 1 ML Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5240','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5810','Dibonis 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5810','Dibonis 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5810','SCD-197496')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13296','Dichlor 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13296','Dichlor 12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13296','chlorthalidone USP 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13296','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13297','Dichlor 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13297','Dichlor 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13297','SCD-197499')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12635','Digitalis 0.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12635','Digitalis 0.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12635','SCD-197606')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2924','Digomet 125 MCG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2924','Digomet 125 MCG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2924','SCD-197604')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7116','Dilatrend 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7116','Dilatrend 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7116','SCD-200033')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7111','Dilatrend 6.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7111','Dilatrend 6.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7111','SCD-200031')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7183','Dilcontin XL 120 Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7183','Dilcontin XL 120 Controlled Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7183','SCD-830874')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7256','Dilcontin XL 90 Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7256','Dilcontin XL 90 Controlled Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7256','SCD-830869')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2135','Diltigesic Organogel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2135','Diltigesic Organogel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2135','diltiazem hydrochloride IP 2% w/w organogel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2135','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12705','Dilur 2 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12705','Dilur 2 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12705','SCD-197626')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12707','Dilur 4 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12707','Dilur 4 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12707','SCD-197627')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8661','Diracip-M 100 MG / 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8661','Diracip-M 100 MG / 125 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8661','metroNIDAZOLE benzoate 100 MG / diloxanide furoate 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8661','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8659','Diracip-M 200 MG / 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8659','Diracip-M 200 MG / 250 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8659','metroNIDAZOLE 200 MG / diloxanide 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8659','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8660','Diracip-M DS 400 MG / 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8660','Diracip-M DS 400 MG / 500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8660','metroNIDAZOLE 400 MG / diloxanide 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8660','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3698','Diuride 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3698','Diuride 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3698','SCD-198369')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11906','Dolafree 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11906','Dolafree 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11906','SCD-835603')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5791','Doloact-MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5791','Doloact-MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5791','diclofenac potassium 50 MG / paracetamol 500 MG / chlorzoxazone 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5791','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7202','Dolomed MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7202','Dolomed MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7202','ibuprofen 400 MG / paracetamol 500 MG / chlorzoxazone 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7202','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5191','Dompan OD 40/30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5191','Dompan OD 40/30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5191','pantoprazole USP 40 MG / domperidone BP 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5191','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11443','Doxylag 100 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11443','Doxylag 100 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11443','SCD-1649988')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI150','Drez Topical Ointment',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB150','Drez Topical Ointment','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG150','iodinated povidone 5 % / metroNIDAZOLE 1 % Topical Ointment','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE150','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI151','Drez Topical Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB151','Drez Topical Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG151','iodinated povidone 5 % / metroNIDAZOLE 1 % Topical Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE151','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6957','Drez-V Vaginal Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6957','Drez-V Vaginal Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6957','miconazole nitrate 2 % / metroNIDAZOLE 1 % Vaginal Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6957','GYN')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1600','Duotrav 40 MCG/ 5 MG per 5 mL Eye Drops Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1600','Duotrav 40 MCG/ 5 MG per 5 mL Eye Drops Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1600','travoprost 40 MCG / timolol maleate 5MG in 1 mL','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1600','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2674','Duovent HFA Metered Dose Inhaler, 200 Metered Doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2674','Duovent HFA Metered Dose Inhaler, 200 Metered Doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2674','ipratropium bromide 0.021 MG /ACTUAT / fenoterol hydrobromide 0.05 MG / ACTUAT Metered Dose Inhaler, 200 Metered Doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2674','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10511','Ecofree Plus Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10511','Ecofree Plus Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10511','etoricoxib 60 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10511','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1048','Eflaron 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1048','Eflaron 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1048','SCD-199326')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1057','Eflaron Plus 200 MG / 250 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1057','Eflaron Plus 200 MG / 250 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1057','metroNIDAZOLE benzoate 200 MG / diloxanide furoate 250 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1057','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4372','Emal 150 MG/2 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4372','Emal 150 MG/2 ML Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4372','alpha-beta arteether 150 MG in 2 mL Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4372','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3143','Ena+HCT-Denk 20 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3143','Ena+HCT-Denk 20 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3143','SCD-858921')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3140','Ena-Denk 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3140','Ena-Denk 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3140','SCD-858817')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3141','Ena-Denk 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3141','Ena-Denk 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3141','SCD-858810')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5758','Enapril 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5758','Enapril 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5758','SCD-858810')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5759','Enapril-20H 20 / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5759','Enapril-20H 20 / 25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5759','enalapril maleate 20 MG / hydrochlorothiazide 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5759','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2385','Enaril 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2385','Enaril 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2385','SCD-858813')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4377','Eno Lemon',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4377','Eno Lemon','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4377','sodium bicarbonate 55.76 % / citric acid 43.14 %','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4377','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2584','Enril 20H Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2584','Enril 20H Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2584','SCD-858921')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16158','Entamaxin Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16158','Entamaxin Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG16158','metroNIDAZOLE benzoate 200 MG / diloxanide furoate 250 MG / dicyclomine HCl 10 MG in 10 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16158','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4311','Entasid 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4311','Entasid 600 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4311','SCD-104020')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5630','Enzoflam Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5630','Enzoflam Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5630','diclofenac sodium 50 MG / paracetamol 500 MG / serratiopeptidase 15 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5630','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3748','Ephicol Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3748','Ephicol Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3748','paracetamol 500 MG / chlorpheniramine maleate 2 MG / phenylephrine HCL 5 MG / caffeine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3748','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10378','Epnone 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10378','Epnone 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10378','SCD-351256')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9704','Epnone 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9704','Epnone 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9704','SCD-351257')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14179','Esofag D 40 MG / 30 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14179','Esofag D 40 MG / 30 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14179','esomeprazole magnesium 40 MG / domperidone 30 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14179','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13571','Esonix 40 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13571','Esonix 40 MG Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13571','SCD-486501')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6289','Esose 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6289','Esose 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6289','SCD-389175')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5571','Esose 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5571','Esose 40 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5571','esomeprazole magnesium USP 40 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5571','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13531','Etofix-P Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13531','Etofix-P Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13531','etodoloac 400 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13531','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3037','Exforge 10 MG/160 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3037','Exforge 10 MG/160 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3037','SCD-722126')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2994','Exforge 5 MG/160 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2994','Exforge 5 MG/160 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2994','SCD-722134')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3564','Exforge HCT 10/160/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3564','Exforge HCT 10/160/12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3564','SCD-848131')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3566','Exforge HCT 5/160/12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3566','Exforge HCT 5/160/12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3566','SCD-848140')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI364','Extacef-DT 100 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB364','Extacef-DT 100 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG364','cefixime 100 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE364','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI256','Extacef-DT 200 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB256','Extacef-DT 200 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG256','cefixime 200 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE256','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10598','Ezetrol 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10598','Ezetrol 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10598','SCD-349556')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10850','Falcimon 25/67.5MG B/L Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10850','Falcimon 25/67.5MG B/L Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10850','artesunate 25 MG / amodiaquine 67.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10850','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10843','Falcimon 50/135 B/L Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10843','Falcimon 50/135 B/L Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10843','artesunate 50 MG / amodiaquine 135 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10843','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1093','Fanlar',0)  	INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1093','Fanlar 500 MG / 25 MG Oral Tablet','SBD_KE')	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1093','SCD-198229')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4701','Fasygin 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4701','Fasygin 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4701','SCD-199519')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI719','Febricol Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB719','Febricol Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE719','SCD-1251928')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16185','Felaxin 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16185','Felaxin 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16185','SCD-309110')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5332','Feveral Intramuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5332','Feveral Intramuscular Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5332','paracetamol 300 MG / lidocaine 20 MG in 2 ML Intramuscular Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5332','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11013','Fimabute-DT 100 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11013','Fimabute-DT 100 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11013','cefixime 100 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11013','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI375','Finmol tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB375','Finmol tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG375','ibuprofen BP 300 MG / paracetamol BP 400 MG','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE375','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13761','Fixime 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13761','Fixime 400 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13761','SCD-197451')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5641','Flagyl 200 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5641','Flagyl 200 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5641','metroNIDAZOLE benzoate 200 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5641','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5897','Flagyl 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5897','Flagyl 400 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5897','SCD-199327')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11831','Flamacor MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11831','Flamacor MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11831','diclofenac sodium BP 50 MG / paracetamol BP 325 MG / chlorzoxazone 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11831','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2473','Flamoryl-S Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2473','Flamoryl-S Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2473','diclofenac sodium 50 MG / paracetamol 325 MG / chlorzoxane 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2473','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7623','Flamox 250 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7623','Flamox 250 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7623','amoxicillin 125 MG / flucloxacillin magnesium 125 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7623','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6014','Fleming 228.5 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6014','Fleming 228.5 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6014','SCD-617423')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14279','Flexon 400/500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14279','Flexon 400/500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14279','ibuprofen 400 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14279','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3201','Flucoldex-E Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3201','Flucoldex-E Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3201','paracetamol BP 125 MG / chlorphenamine maleate BP 2 MG / phenylephrine HCl BP 1 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3201','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3832','Flu-Gone C+F Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3832','Flu-Gone C+F Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3832','paracetamol 600 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 60 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3832','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3815','Flu-Gone Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3815','Flu-Gone Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3815','paracetamol 300 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3815','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3861','Flu-Gone-P Plus Syrup Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3861','Flu-Gone-P Plus Syrup Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3861','paracetamol 120 MG / chlorpheniramine maleate 1 MG / pseudoephedrine HCL 15 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3861','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8592','Foralin 100 Metered Dose Inhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8592','Foralin 100 Metered Dose Inhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8592','budesonide 100 MCG /ACTUAT / formoterol fumarate 6 MCG/ACTUAT Metered Dose Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8592','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8591','Foralin 200 Metered Dose Inhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8591','Foralin 200 Metered Dose Inhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8591','budesonide 200 MCG /ACTUAT / formoterol fumarate 6 MCG/ACTUAT Metered Dose Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8591','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8593','Foralin 400 Metered Dose Inhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8593','Foralin 400 Metered Dose Inhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8593','budesonide 400 MCG /ACTUAT / formoterol fumarate 6 MCG/ACTUAT Metered Dose Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8593','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2042','Formonide 200 Metered Dose Inhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2042','Formonide 200 Metered Dose Inhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2042','budesonide 200 MCG /ACTUAT / formoterol fumarate 6 MCG/ACTUAT Metered Dose Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2042','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2044','Formonide 400 Metered Dose Inhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2044','Formonide 400 Metered Dose Inhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2044','budesonide BP 400 MCG /ACTUAT / formoterol fumarate 6 MCG/ACTUAT Metered Dose Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2044','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4166','Fortan-P 25/300 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4166','Fortan-P 25/300 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4166','camylofin dihydrochloride 25 MG / paracetamol BP 300 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4166','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3057','Fortum 1 GM Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3057','Fortum 1 GM Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3057','SCD-1659283')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3064','Fortum 2 GM Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3064','Fortum 2 GM Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3064','SCD-1659287')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11073','Forxiga 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11073','Forxiga 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11073','SCD-1488569')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11066','Forxiga 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11066','Forxiga 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11066','SCD-1488574')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13679','Frusemide 20 MG / 2 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13679','Frusemide 20 MG / 2 ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13679','SCD-1719290')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2989','Furo-Denk 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2989','Furo-Denk 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2989','SCD-313988')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12605','Furomark 1500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12605','Furomark 1500 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12605','cefuroxime 1500 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12605','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6309','Furomed 10 Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6309','Furomed 10 Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6309','furosemide 10 MG in 1 ML Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6309','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15924','Furoxiclav 625 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15924','Furoxiclav 625 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15924','cefuroxime 500 MG / clavulanic acid 125 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15924','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2080','Fusid 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2080','Fusid 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2080','SCD-313988')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13074','Fytobact 2 GM Intravenous/Intramuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13074','Fytobact 2 GM Intravenous/Intramuscular Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13074','cefoperazone 1000 MG / sulbactam 1000 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13074','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI418','Gacet 1000 MG Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB418','Gacet 1000 MG Rectal Suppository','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG418','acetaminophen 1000 MG Rectal Suppository','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE418','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI404','Gacet 500 MG Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB404','Gacet 500 MG Rectal Suppository','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE404','SCD-250651')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16548','Galaxy''s Labelol 5 MG / ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16548','Galaxy''s Labelol 5 MG / ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16548','SCD-896771')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI441','G-Alfenac 100 MG Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB441','G-Alfenac 100 MG Rectal Suppository','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG441','aceclofenac 100 MG Rectal Suppository','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE441','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3035','Galvus 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3035','Galvus 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3035','SCD-757712')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3056','Galvus Met 50/1000 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3056','Galvus Met 50/1000 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3056','VILDAgliptin 50 MG / metFORMIN HCl 1000 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3056','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3051','Galvus Met 50/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3051','Galvus Met 50/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3051','VILDAgliptin 50 MG / metFORMIN HCl 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3051','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3055','Galvus Met 50/850 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3055','Galvus Met 50/850 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3055','VILDAgliptin 50 MG / metFORMIN HCl 850 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3055','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6247','Ganfort Eye Drops Opthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6247','Ganfort Eye Drops Opthalmic Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6247','bimatoprost 0.3 MG / timolol maleate 6.8 MG (equivalent to timolol 5 MG ) in 1 mL Ophthalmic Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6247','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI108','Gaviscon Double Action Liquid Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB108','Gaviscon Double Action Liquid Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG108','calcium carbonate BP 325 MG / sodium alginate BP 500 MG / sodium bicarbonate BP 213 MG Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE108','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI118','Gaviscon Double Action Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB118','Gaviscon Double Action Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG118','calcium carbonate BP 187.5 MG / sodium alginate BP 250 MG / sodium bicarbonate BP 106.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE118','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI235','Gaviscon Original Liquid Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB235','Gaviscon Original Liquid Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG235','calcium carbonate 160 MG / sodium alginate 500 MG / sodium bicarbonate 267 MG Oral Suspension Sachet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE235','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3004','Gaviscon Original Liquid Oral Suspension in 10 ML Sachet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3004','Gaviscon Original Liquid Oral Suspension in 10 ML Sachet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3004','calcium carbonate 160 MG / sodium alginate 500 MG / sodium bicarbonate 267 MG Oral Suspension in 10 ML Sachet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3004','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI231','Gaviscon Original Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB231','Gaviscon Original Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG231','calcium carbonate BP 80 MG / sodium alginate 250 MG / sodium bicarbonate 133.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE231','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3318','Getryl 1 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3318','Getryl 1 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3318','SCD-199245')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3319','Getryl 2 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3319','Getryl 2 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3319','SCD-199246')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3321','Getryl 4 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3321','Getryl 4 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3321','SCD-199247')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9111','Git 150 MG Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9111','Git 150 MG Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9111','itopride hydrochloride 150 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9111','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI564','Glibomet 2.5/400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB564','Glibomet 2.5/400 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG564','glibenclamide 2.5 MG / metFORMIN HCl 400 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE564','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4168','Gliclaz-M 80/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4168','Gliclaz-M 80/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4168','gliclazide BP 80 MG / metFORMIN HCl BP 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4168','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3009','Glimepiride Denk 2 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3009','Glimepiride Denk 2 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3009','SCD-199246')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3023','Glimepiride Denk 3 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3023','Glimepiride Denk 3 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3023','SCD-153842')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3022','Glimiday M1 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3022','Glimiday M1 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3022','glimepiride 1 MG / metFORMIN HCl HCl 500 MG Sustained Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3022','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI144','Glinther 80 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB144','Glinther 80 MG/ML Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG144','artemether 80 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE144','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2670','GlipiSTIN 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2670','GlipiSTIN 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2670','SCD-310490')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13846','Glucodip 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13846','Glucodip 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13846','SCD-665038')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3276','GlucoMET 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3276','GlucoMET 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3276','SCD-861007')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4497','GlucoMET 850 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4497','GlucoMET 850 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4497','SCD-861010')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10529','GlucoMET XR 1000 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10529','GlucoMET XR 1000 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10529','SCD-1807888')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4535','GlucoMET XR 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4535','GlucoMET XR 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4535','SCD-1807915')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13625','GlucoMET XR 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13625','GlucoMET XR 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13625','SCD-860981')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10483','SCD-861004')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10481','SCD-861007')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10482','SCD-861010')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10484','GlucoPHAGE XR 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10484','GlucoPHAGE XR 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10484','SCD-1807915')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10485','GlucoPHAGE XR 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10485','GlucoPHAGE XR 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10485','SCD-860981')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1190','Glucotim 0.5% Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1190','Glucotim 0.5% Eye Drops','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1190','SCD-1992299')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10486','GlucoVANCE 1.25/250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10486','GlucoVANCE 1.25/250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10486','SCD-861743')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10487','GlucoVANCE 2.5/500 MG MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10487','GlucoVANCE 2.5/500 MG MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10487','SCD-861748')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10488','GlucoVANCE 5/500 MG MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10488','GlucoVANCE 5/500 MG MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10488','SCD-861753')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI590','Glurenor 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB590','Glurenor 30 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE590','SCD-105374')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI673','Glycinorm MR 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB673','Glycinorm MR 30 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE673','SCD-4333856')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10796','Gramocef-CV Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10796','Gramocef-CV Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10796','cefixime 200 MG / clavulanic acid 125 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10796','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6948','Gramocef-O 50 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6948','Gramocef-O 50 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6948','cefixime 50 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6948','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11503','Grilinctus - BM Syrup Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11503','Grilinctus - BM Syrup Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11503','terbutaline sulphate 2.5 MG / bromhexine hydrochloride 8 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11503','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1123','Gripe Water Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1123','Gripe Water Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1123','sodium bicarbonate 50 MG / dill seed oil terpenless 2.15 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1123','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15001','Gsunate-50 Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15001','Gsunate-50 Rectal Suppository','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15001','artesunate 50 MG Rectal Suppository','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15001','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI444','Gvither Forte 80 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB444','Gvither Forte 80 MG/ML Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG444','artemether 80 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE444','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI470','Gvither 20 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB470','Gvither 20 MG/ML Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG470','artemether 20 MG/ML Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE470','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI464','Gvither 40 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB464','Gvither 40 MG/ML Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG464','artemether 40 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE464','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10412','Gynanfort Vaginal Pessary',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10412','Gynanfort Vaginal Pessary','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10412','metroNIDAZOLE 500 MG / neomycin sulphate 65,000 UNITS / nystatin 100,000 UNITS Vaginal Pessary','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10412','GYN')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI670','HCQS 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB670','HCQS 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE670','SCD-979092')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3505','Hedapan 250 / 300 / 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3505','Hedapan 250 / 300 / 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3505','paracetamol 250 MG / aspirin 300 MG / caffeine 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3505','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2728','Hedex 200 / 400/ 50 MG Oral Caplet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2728','Hedex 200 / 400/ 50 MG Oral Caplet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2728','paracetamol BP 200 MG / aspirin BP 400 MG / caffeine BP 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2728','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11962','Homacure Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11962','Homacure Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11962','paracetamol 300 MG / chlorpheniramine maleate 4 MG / phenylephrine HCL 10 MG / caffeine anhydrous 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11962','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3785','Homagon Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3785','Homagon Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3785','paracetamol 350 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3785','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1148','HumaLOG 100 UNITS/ML Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1148','HumaLOG 100 UNITS/ML Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1148','SCD-242120')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1202','HumaLOG 100 UNITS/ML Solution for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1202','HumaLOG 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1202','SCD-1652644')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1207','HumaLOG Mix-25 100 UNITS/ML Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1207','HumaLOG Mix-25 100 UNITS/ML Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1207','SCD-259111')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1211','HumaLOG Mix-25 100 UNITS/ML Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1211','HumaLOG Mix-25 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1211','insulin lispro 25 UNITS/ML / insulin lispro protamine 75 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1211','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1213','HumaLOG Mix-50 100 UNITS/ML Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1213','HumaLOG Mix-50 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1213','insulin lispro 50 UNITS/ML / insulin lispro protamine 50 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1213','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1217','HumuLIN 70/30 Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1217','HumuLIN 70/30 Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1217','isophane (NPH) insulin, human 70 UNITS/ML / soluble insulin, human 30 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1217','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1239','HumuLIN N 100 UNITS/ML Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1239','HumuLIN N 100 UNITS/ML Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1239','SCD-311028')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1235','HumuLIN N 100 UNITS/ML Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1235','HumuLIN N 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1235','isophane (NPH) insulin, human 100 UNITS/ML Suspension for injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1235','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1239-4ML','HumuLIN N 100 UNITS/ML Suspension for Injection in 4 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1239-4ML','HumuLIN N 100 UNITS/ML Suspension for Injection in 4 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1239-4ML','SCD-311028')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1246','HumuLIN R 100 UNITS/ML Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1246','HumuLIN R 100 UNITS/ML Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1246','SCD-311034')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1241','HumuLIN R 100 UNITS/ML Solution for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1241','HumuLIN R 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1241','soluble insulin, human 100 UNITS/ML Solution for injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1241','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1246-4ML','HumuLIN R 100 UNITS/ML Solution for Injection in 4 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1246-4ML','HumuLIN R 100 UNITS/ML Solution for Injection in 4 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1246-4ML','SCD-311034')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1147','Hycin Syrup 5 MG / ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1147','Hycin Syrup 5 MG / ML Oral Solution ','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1147','hyoscine-N-butylbromide 5 MG / ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1147','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6340','SCD-905225')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2245','SCD-966571')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12489','SCD-310798')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13349','Hymet 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13349','Hymet 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13349','SCD-197770')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1150','Hyspar 10/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1150','Hyspar 10/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1150','hyoscine-N-butylbromide 10 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1150','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1156','Hyspar Oral Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1156','Hyspar Oral Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1156','hyoscine-N-butylbromide 5 MG / paracetamol 120 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1156','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6024','Ibex Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6024','Ibex Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6024','ibuprofen 200 MG / paracetamol 250 MG / caffeine 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6024','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3539','Ibufen 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3539','Ibufen 400 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3539','SCD-197805')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3957','Ibuflam Plus Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3957','Ibuflam Plus Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3957','ibuprofen 100 MG / paracetamol 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3957','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10890','Ibuprofen Denk 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10890','Ibuprofen Denk 600 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10890','SCD-197806')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6359','Indowin 25 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6359','Indowin 25 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6359','SCD-197817')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10516','Induric 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10516','Induric 2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10516','SCD-197816')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11606','Induric SR 1.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11606','Induric SR 1.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11606','SCD-433844')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11582','Inegy 10/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11582','Inegy 10/10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11582','SCD-476345')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11585','Inegy 10/20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11585','Inegy 10/20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11585','SCD-476349')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11586','Inegy 10/40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11586','Inegy 10/40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11586','SCD-476350')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10723','Infa-V Vaginal Ointment',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10723','Infa-V Vaginal Ointment','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10723','metroNIDAZOLE 10 % / clotrimazole 2 % Vaginal Ointment','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10723','GYN')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12379','Injlin 1000 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12379','Injlin 1000 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12379','cefoperazone 1000 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12379','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11139','Inosita Plus 50/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11139','Inosita Plus 50/500 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11139','SCD-861819')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10243','Inoxime 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10243','Inoxime 100 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10243','cefixime 100 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10243','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4782','SCD-351256')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI217','InSULAtard 100 UNITS/ML Insulin Human Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB217','InSULAtard 100 UNITS/ML Insulin Human Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE217','SCD-311028')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI229Pen','InSULAtard FlexPen 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB229Pen','InSULAtard FlexPen 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE229Pen','SCD-1654862')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI229','InSULAtard Penfill 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB229','InSULAtard Penfill 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG229','isophane (NPH) insulin, human Ph.Eur 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE229','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5907Vial','InSUMan basal 100 UNITS/ML Insulin Human, Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5907Vial','InSUMan basal 100 UNITS/ML Insulin Human, Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5907Vial','SCD-311028')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5907','InSUMan basal 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5907','InSUMan basal 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5907','isophane (NPH) insulin, human 100 UNITS/ML Suspension for injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5907','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10906','InSUMan Comb-30 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10906','InSUMan Comb-30 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10906','soluble insulin 30 UNITS/ML / crystalline protamine insulin 70 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10906','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10907','InSUMan Rapid 100 UNITS/ML Insulin Human, Solution for injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10907','InSUMan Rapid 100 UNITS/ML Insulin Human, Solution for injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10907','SCD-311034')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5399','INTRAcef 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5399','INTRAcef 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5399','SCD-197456')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14874','SCD-1373463')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14875','SCD-1373471')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5308','Isoptin 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5308','Isoptin 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5308','SCD-897722')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10528','Itoprid 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10528','Itoprid 50 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10528','itopride hydrochloride 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10528','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2490','Ivyzoxan 0.3 % Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2490','Ivyzoxan 0.3 % Eye Drops','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2490','ciprofloxacin 0.3 % Ophthalmic Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2490','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9539','Janumet 50/1000 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9539','Janumet 50/1000 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9539','SCD-861769')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9535','Janumet 50/850 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9535','Janumet 50/850 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9535','sitaGLIPtin 50 MG / metFORMIN HCl 850 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9535','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10609','SCD-665033')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10604','SCD-665038')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10607','SCD-665042')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI929','Junior Sonadol 120 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB929','Junior Sonadol 120 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG929','paracetamol 120 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE929','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1862','Kelvin-P Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1862','Kelvin-P Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1862','paracetamol 125 MG / promethazine 6.25 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1862','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12275','Kemoxyl DT 250 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12275','Kemoxyl DT 250 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12275','amoxicillin 250 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12275','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4015','Kemoyl Plus F Dry Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4015','Kemoyl Plus F Dry Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4015','amoxicillin 125 MG / flucloxacillin magnesium 125 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4015','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5970','Ketolac 0.5 % Opthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5970','Ketolac 0.5 % Opthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5970','SCD-860107')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6493','Klenzit 0.1 % Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6493','Klenzit 0.1 % Topical Gel','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6493','SCD-307731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6491','Klenzit-C Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6491','Klenzit-C Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6491','adapalene 0.1 % / clindamycin phosphate 1 % Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6491','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1754','Koact 312.5 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1754','Koact 312.5 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1754','SCD-617322')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4069','Kofed Compound Linctus Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4069','Kofed Compound Linctus Oral Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4069','SCD-996640')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7696','Kombiglyze 5/500 24 HR Extended Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7696','Kombiglyze 5/500 24 HR Extended Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7696','SCD-1043570')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12059','Komefan 140 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12059','Komefan 140 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12059','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12060','Komefan 280 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12060','Komefan 280 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12060','artemether 40 MG / lumefantrine 240 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12060','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4217','Labclor 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4217','Labclor 250 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4217','SCD-309045')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15491','Labnir 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15491','Labnir 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15491','SCD-309054')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15506','Labnir 300 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15506','Labnir 300 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15506','SCD-200346')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4350','Lacillin 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4350','Lacillin 250 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4350','SCD-313800')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4385','Lacillin 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4385','Lacillin 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4385','SCD-308212')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13777','Lacoma - T Eye Drops',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13777','Lacoma - T Eye Drops','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13777','SCD-388054')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6898','Lactone 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6898','Lactone 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6898','SCD-198222')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13123','Lactor 25 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13123','Lactor 25 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13123','spironolactone 25 MG / torsemide 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13123','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4396','Laefin Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4396','Laefin Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4396','sulfametopyrazine 500 MG / pyrimethamine 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4396','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14708','Lamitar AM Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14708','Lamitar AM Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14708','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3129','Lanoxin 0.05 MG per mL Elixir',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3129','Lanoxin 0.05 MG per mL Elixir','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3129','SCD-393245')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3131','Lanoxin 0.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3131','Lanoxin 0.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3131','SCD-197606')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3130','Lanoxin 0.5 MG per 2 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3130','Lanoxin 0.5 MG per 2 ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3130','SCD-104208')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5912','Lantus 100 UNITS/ML Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5912','Lantus 100 UNITS/ML Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5912','SCD-311041')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5916','Lantus Insulin 100 UNITS/ML Solution for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5916','Lantus Insulin 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5916','insulin glargine 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5916','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5916Pen','Lantus Solostar 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5916Pen','Lantus Solostar 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5916Pen','SCD-847230')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8684','Lanzol DT Junior 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8684','Lanzol DT Junior 15 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8684','SCD-351261')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8654','Lanzol 30 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8654','Lanzol 30 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8654','SCD-311277')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10218','Larinate 60 MG Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10218','Larinate 60 MG Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10218','artesunate 60 MG Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10218','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI718','Larither 40 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB718','Larither 40 MG/ML Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG718','artemether 40 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE718','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10575','Lartem Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10575','Lartem Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10575','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5459','Lasix 20 MG / 2 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5459','Lasix 20 MG / 2 ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5459','SCD-1719290')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4419','Lastmol 2 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4419','Lastmol 2 MG in 5 ML Oral Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4419','SCD-755497')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI215','Lemsip Max Cold & Flu Powder for Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB215','Lemsip Max Cold & Flu Powder for Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG215','paracetamol 1000 MG / phenylephrine HCL 12.2 MG Powder for Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE215','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13116','Lercapil 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13116','Lercapil 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13116','SCD-153680')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12630','Lercapil 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12630','Lercapil 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12630','SCD-349485')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8645','Levaform Respules 1.25 MG in 2.5 ML Inhalation Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8645','Levaform Respules 1.25 MG in 2.5 ML Inhalation Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8645','levosalbutamol sulphate respules 1.25 MG in 2.5 ML Inhalation Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8645','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI297Vial','Levemir 100 UNITS/ML Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB297Vial','Levemir 100 UNITS/ML Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE297Vial','SCD-484322')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI297Pen','Levemir FlexPen 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB297Pen','Levemir FlexPen 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE297Pen','SCD-847239')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI297','Levemir Penfill 100 UNITS/ML Solution for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB297','Levemir Penfill 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG297','insulin detemir 100 UNITS/ML Solution for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE297','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6112','Levobact 750 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6112','Levobact 750 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6112','SCD-311296')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11911','Levo-Denk 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11911','Levo-Denk 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11911','SCD-199884')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10614','Levo-OZ 250 MG / 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10614','Levo-OZ 250 MG / 500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10614','levofloxacin 250 MG / ornidazole 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10614','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2097','Levostar Oral Syrup',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2097','Levostar Oral Syrup','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2097','levosalbutamol 1 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2097','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2096','Levostar 1 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2096','Levostar 1 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2096','levosalbutamol 1 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2096','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13784','Levotop 0.5 % Ophthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13784','Levotop 0.5 % Ophthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13784','SCD-314080')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13778','Levotop-PF 1.5 % Ophthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13778','Levotop-PF 1.5 % Ophthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13778','SCD-545118')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI601','Lioton 1000 IU per 1 gram Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB601','Lioton 1000 IU per 1 gram Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG601','heparin sodium 1000 Units in 1 gram Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE601','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3339','Lipiget 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3339','Lipiget 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3339','SCD-617311')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4809','SCD-617312')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4859','SCD-617310')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4871','SCD-617311')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4884','SCD-259255')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4635','Lisace 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4635','Lisace 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4635','SCD-314076')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5819','Lisace 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5819','Lisace 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5819','SCD-311354')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI452','Lofnac P 50/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB452','Lofnac P 50/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG452','diclofenac sodium 50 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE452','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2316','Lofral 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2316','Lofral 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2316','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2353','Lofral 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2353','Lofral 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2353','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7701','Logimax 5/50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7701','Logimax 5/50 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7701','felodipine 5 MG / metoprolol succinate 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7701','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI405','Lonart Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB405','Lonart Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG405','artemether 20 MG / lumefantrine 120 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE405','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI397','Lonart Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB397','Lonart Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG397','artemether 20 MG / lumefantrine 120 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE397','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI439','Lonart Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB439','Lonart Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE439','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2394','Lonet 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2394','Lonet 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2394','SCD-197381')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11641','Lornex Forte 8/325 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11641','Lornex Forte 8/325 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11641','lornoxicam 8 MG / paracetamol 325 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11641','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11642','Lornex Plus 4/325 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11642','Lornex Plus 4/325 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11642','lornoxicam 4 MG / paracetamol 325 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11642','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9602','Losar-Denk 100 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9602','Losar-Denk 100 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9602','SCD-979480')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10089','Losar-Denk 25 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10089','Losar-Denk 25 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10089','SCD-979485')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7705','Losec MUPS 10 MG Delayed Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7705','Losec MUPS 10 MG Delayed Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7705','SCD-402013')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7706','Losec MUPS 20 MG Delayed Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7706','Losec MUPS 20 MG Delayed Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7706','SCD-402014')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8162','Lotem Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8162','Lotem Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8162','ibuprofen 200 MG / paracetamol 250 MG in 10 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8162','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9672','Loxiam Plus 8/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9672','Loxiam Plus 8/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9672','lornoxicam 8 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9672','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5430','Lufanate Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5430','Lufanate Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5430','artemether 20 MG / lumefantrine 120 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5430','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5434','Lufanate Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5434','Lufanate Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5434','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1165','Lum-Artem Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1165','Lum-Artem Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1165','artemether 15 MG / lumefantrine 90 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1165','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1177','Lum-Artem 20/120 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1177','Lum-Artem 20/120 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1177','B-artemether 20 MG / lumefantrine 120 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1177','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13036','Lum-Artem Forte Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13036','Lum-Artem Forte Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13036','B-artemether 80 MG / lumefantrine 480 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13036','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8376','Lumet Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8376','Lumet Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8376','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1912','Lumiter Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1912','Lumiter Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1912','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2098','Luteriam Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2098','Luteriam Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2098','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14953','Lysodol MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14953','Lysodol MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14953','aceclofenac BP 100 MG / paracetamol BP 500 MG / chlorzoxazone USP 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14953','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4920','Lysoflam Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4920','Lysoflam Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4920','diclofenac potassium 50 MG / paracetamol 500 MG / serratiopeptidase 15 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4920','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3975','Magnocid Mixture Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3975','Magnocid Mixture Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3975','magnesium carbonate BP 250 MG / sodium bicarbonate BP 250 MG / magnesium trisilicate BP 250 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3975','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2253','Malacide 500 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2253','Malacide 500 MG / 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2253','SCD-198229')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3132','Malanil Adult Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3132','Malanil Adult Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3132','SCD-864675')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3133','Malanil Paediatric Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3133','Malanil Paediatric Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3133','SCD-864681')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1301','Malgo 80 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1301','Malgo 80 MG/ML Injection Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1301','artemether 80 MG/ML Injection Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1301','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2253R','Malodar 500 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2253R','Malodar 500 MG / 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2253R','SCD-198229')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7936','Mazit 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7936','Mazit 250 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7936','azithromycin 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7936','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12494','Medisart 300H Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12494','Medisart 300H Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12494','SCD-310793')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14001','Medisart H Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14001','Medisart H Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14001','SCD-310792')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8133','Medomox DT 125 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8133','Medomox DT 125 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8133','amoxicillin 125 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8133','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6057','Medopress 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6057','Medopress 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6057','SCD-197956')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3550','SCD-829500')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1391','Mefpar 250/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1391','Mefpar 250/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1391','mefenamic acid 250 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1391','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12612','Mefsun 50 MG/5ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12612','Mefsun 50 MG/5ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12612','mefenamic acid 50 MG/5ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12612','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI274','Meftal-Forte 500/450 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB274','Meftal-Forte 500/450 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG274','mefenamic acid 500 MG / paracetamol 450 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE274','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI243','Meftal-P 100 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB243','Meftal-P 100 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG243','mefenamic acid 100 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE243','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI358','Meftal-Spas 250/10 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB358','Meftal-Spas 250/10 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG358','mefenamic acid 250 MG / dicyclomine HCl 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE358','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7501','Melonac 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7501','Melonac 15 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7501','SCD-152695')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8280','Melonac 7.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8280','Melonac 7.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8280','SCD-311486')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1279','Met XL 100 MG Extended Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1279','Met XL 100 MG Extended Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1279','SCD-866412')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1277','Met XL 50 MG Extended Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1277','Met XL 50 MG Extended Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1277','SCD-866436')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9606','Metformin Denk 1000 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9606','Metformin Denk 1000 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9606','SCD-861004')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3085','Metformin Denk 500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3085','Metformin Denk 500 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3085','SCD-861007')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10767','Metformin Denk 850 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10767','Metformin Denk 850 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10767','SCD-861010')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3390','Methomine - S 500 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3390','Methomine - S 500 MG / 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3390','SCD-198229')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1365','Metoz 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1365','Metoz 2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1365','SCD-197979')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1366','Metoz 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1366','Metoz 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1366','SCD-311671')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7960','Metpure -XL 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7960','Metpure -XL 25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7960','S (-) metoprolol succinate 25 MG Extended Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7960','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7961','Metpure -XL 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7961','Metpure -XL 50 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7961','S (-) metoprolol succinate 50 MG Extended Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7961','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8261','Metrogyl Denta Oral Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8261','Metrogyl Denta Oral Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8261','metroNIDAZOLE 10 MG / chlorhexidine gluconate 0.5 MG in 1 GM Oral Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8261','Dental')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7193','Metrogyl Vaginal Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7193','Metrogyl Vaginal Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7193','metroNIDAZOLE 10 MG Vaginal Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7193','GYN')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6253','Metrozol 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6253','Metrozol 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6253','SCD-314106')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6239','Metrozol 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6239','Metrozol 400 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6239','SCD-199327')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2628','Mexic 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2628','Mexic 15 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2628','SCD-152695')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2626','Mexic 7.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2626','Mexic 7.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2626','SCD-311486')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3551','Mifupen Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3551','Mifupen Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3551','aspirin 350 MG / caffeine 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3551','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6517','Minoxin 2% Topical Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6517','Minoxin 2% Topical Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6517','SCD-311723')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6494','Minoxin Plus Topical Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6494','Minoxin Plus Topical Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6494','SCD-311724')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI191','MIXTArd-30 100 UNITS/ML Insulin Human, Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB191','MIXTArd-30 100 UNITS/ML Insulin Human, Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE191','SCD-311048')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI281Pen','MIXTArd-30 FlexPen 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Pre-filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB281Pen','MIXTArd-30 FlexPen 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Pre-filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE281Pen','SCD-847187')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI281','MIXTArd-30 Penfill 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB281','MIXTArd-30 Penfill 100 UNITS/ML Insulin Human, Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG281','soluble insulin, human 30 UNITS/ML / isophane (NPH) insulin, human 70 UNITS/ML Suspension for Injection in 3 ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE281','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1133','Mobic 15 MG in 1.5 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1133','Mobic 15 MG in 1.5 ML Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1133','meloxicam 15 MG in 1.5 ML Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1133','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2973','SCD-152695')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2943','SCD-311486')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6951','Moduretic 5 MG / 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6951','Moduretic 5 MG / 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6951','SCD-977883')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5480','Mono-Tildiem SR 200 MG Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5480','Mono-Tildiem SR 200 MG Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5480','diltiazem hydrochloride 200 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5480','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5477','Mono-Tildiem SR 300 MG Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5477','Mono-Tildiem SR 300 MG Sustained Release Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5477','SCD-830801')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1404','Moxacil 125 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1404','Moxacil 125 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1404','amoxicillin 125 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1404','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1402','Moxacil DS 250 MG in 5 ML Granules for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1402','Moxacil DS 250 MG in 5 ML Granules for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1402','amoxicillin 250 MG in 5 ML Granules for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1402','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11829','Myocor Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11829','Myocor Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11829','chlorzoxazone 250 MG / paracetamol 325 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11829','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4459','Myolgin Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4459','Myolgin Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4459','chlorzoxazone 250 MG / paracetamol 300 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4459','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16179','Myonac MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16179','Myonac MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG16179','aceclofenac BP 100 MG / paracetamol BP 325 MG / chlorzoxazone USP 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16179','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7228','Myospaz Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7228','Myospaz Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7228','chlorzoxazone 250 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7228','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8163','Mypaid Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8163','Mypaid Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8163','ibuprofen 200 MG / paracetamol 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8163','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8217','Myprodol Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8217','Myprodol Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8217','codeine phosphate 10 MG / ibuprofen 200 MG / paracetamol 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8217','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7414','Natrilix SR 1.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7414','Natrilix SR 1.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7414','SCD-433844')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12068','Natrixam 1.5 MG / 10 MG Modified Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12068','Natrixam 1.5 MG / 10 MG Modified Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12068','indapamide 1.5 MG / amLODIPine 10 MG Modified Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12068','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12069','Natrixam 1.5 MG / 5 MG Modified Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12069','Natrixam 1.5 MG / 5 MG Modified Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12069','indapamide 1.5 MG / amLODIPine 5 MG Modified Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12069','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12488','Naxpar APC 250 / 150 / 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12488','Naxpar APC 250 / 150 / 30 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12488','paracetamol BP 250 MG / aspirin BP 150 MG / caffeine BP 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12488','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10776','Nebilet Plus 5 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10776','Nebilet Plus 5 MG / 12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10776','nebivolol 5 MG / hydrochlorothiazide 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10776','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10780','Nebilet Plus 5 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10780','Nebilet Plus 5 MG / 25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10780','nebivolol 5 MG / hydrochlorothiazide 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10780','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13140','Nebilong-2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13140','Nebilong-2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13140','SCD-751618')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6127','Nebilong 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6127','Nebilong 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6127','SCD-387013')
		
		
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI891','Neosanmag Fast Chewable Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB891','Neosanmag Fast Chewable Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE891','SCD-283641')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11484','Nesmox 125 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11484','Nesmox 125 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11484','amoxicillin 125 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11484','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7720','SCD-861568')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7718','SCD-433733')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7719','NexIUM 40 MG Delayed Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7719','NexIUM 40 MG Delayed Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7719','esomeprazole magnesium 40 MG Delayed Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7719','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7721','NexIUM 40 MG IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7721','NexIUM 40 MG IntraVenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7721','SCD-486501')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4102','Nifedi-Denk 10 Retard',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4102','Nifedi-Denk 10 Retard','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4102','SCD-248708')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3979','Nifedi-Denk 20 Retard',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3979','Nifedi-Denk 20 Retard','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3979','SCD-249620')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5858','Nilol 20 MG / 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5858','Nilol 20 MG / 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5858','SCD-393275')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14086','Niredil 10 MG Transdermal Patch',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14086','Niredil 10 MG Transdermal Patch','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14086','24HR nitroglycerine 10 MG Transdermal Patch','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14086','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14087','Niredil 15 MG Transdermal Patch',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14087','Niredil 15 MG Transdermal Patch','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14087','24HR nitroglycerine 15 MG Transdermal Patch','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14087','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14085','Niredil 5 MG Transdermal Patch',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14085','Niredil 5 MG Transdermal Patch','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14085','24HR nitroglycerine 5 MG Transdermal Patch','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14085','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7264','Nitrocontin 2.6 MG Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7264','Nitrocontin 2.6 MG Controlled Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7264','diluted nitroglycerin USP (equivalent to nitroglycerin 2.6 MG) Controlled Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7264','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7265','Nitrocontin 6.4 MG Controlled Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7265','Nitrocontin 6.4 MG Controlled Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7265','diluted nitroglycerin USP (equivalent to nitroglycerin 6.4 MG) Controlled Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7265','')
 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6244','nitrofurantoin 100 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6244','')
		
		
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13071','Nodon 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13071','Nodon 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13071','SCD-751612')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11049','Nolgripp Junior Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11049','Nolgripp Junior Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11049','paracetamol BP 125 MG / chlorpheniramine maleate BP 1 MG / phenylephrine HCl BP 5 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11049','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11050','Nolgripp Plus Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11050','Nolgripp Plus Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11050','paracetamol 500 MG / chlorpheniramine maleate 2 MG / phenylephrine HCL 10 MG / caffeine 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11050','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3347','Norplat-S 75 MG / 75 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3347','Norplat-S 75 MG / 75 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3347','clopidogrel 75 MG / aspirin 75 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3347','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI201','Nortiz 400 MG / 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB201','Nortiz 400 MG / 600 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG201','norfloxacin 400 MG / tinidazole 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE201','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5113','SCD-308135')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3158','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5229','Norzole 400 MG / 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5229','Norzole 400 MG / 600 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5229','norfloxacin 400 MG / tinidazole 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5229','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI283Vial','NovoMIX-30 100 UNITS/ML Suspension for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB283Vial','NovoMIX-30 100 UNITS/ML Suspension for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE283Vial','SCD-351297')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI283Pen','NovoMIX-30 FlexPen 100 UNITS/ML Suspension for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB283Pen','NovoMIX-30 FlexPen 100 UNITS/ML Suspension for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE283Pen','SCD-847191')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI283','NovoMIX-30 Penfill 100 UNITS/ML Suspension for Injection in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB283','NovoMIX-30 Penfill 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG283','insulin aspart 30 UNITS/ML / insulin aspart protamine crystals 70 UNITS/ML Suspension for Injection in 3ML Cartridge','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE283','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI299','NovoNorm 0.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB299','NovoNorm 0.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE299','SCD-200257')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI301','NovoNorm 1 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB301','NovoNorm 1 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE301','SCD-200256')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI304','NovoNorm 2 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB304','NovoNorm 2 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE304','SCD-200258')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI289Vial','NovoRAPID 100 UNITS/ML Solution for Injection in 10 ML Vial',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB289Vial','NovoRAPID 100 UNITS/ML Solution for Injection in 10 ML Vial','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE289Vial','SCD-311040')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI289Pen','NovoRAPID FlexPen 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB289Pen','NovoRAPID FlexPen 100 UNITS/ML Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE289Pen','SCD-1653202')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI289','NovoRAPID Penfill 100 UNITS/ML in 3 ML Cartridge',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB289','NovoRAPID Penfill 100 UNITS/ML in 3 ML Cartridge','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE289','SCD-1653196')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10561','nuclin-V Vaginal Pessary',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10561','nuclin-V Vaginal Pessary','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10561','clindamycin phosphate 100 MG / clotrimazole 200 MG Vaginal Pessary','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10561','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16472','Nurofen 100 MG / 5 ML Oral Suspension Orange Flavour',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16472','Nurofen 100 MG / 5 ML Oral Suspension Orange Flavour','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16472','SCD-197803')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI122','Nurofen 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB122','Nurofen 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE122','SCD-310965')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI16475','Nurofen Migraine Pain 342 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB16475','Nurofen Migraine Pain 342 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG16475','ibuprofen lysine 342 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE16475','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13150','Olme 20 AH Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13150','Olme 20 AH Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13150','SCD-999967')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13149','Olme 40 AH Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13149','Olme 40 AH Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13149','SCD-999996')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10822','Olmesar 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10822','Olmesar 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10822','SCD-349401')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10823','Olmesar 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10823','Olmesar 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10823','SCD-349405')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10827','Olmesar H 20 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10827','Olmesar H 20 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10827','SCD-403853')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10828','Olmesar H 40 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10828','Olmesar H 40 MG / 12.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10828','SCD-403854')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6432','Omizec 20 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6432','Omizec 20 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6432','omeprazole 20 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6432','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11724','ONEcef SB 1000 MG / 500 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11724','ONEcef SB 1000 MG / 500 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11724','cefTRIAXone 1000 MG / sulbactam 500 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11724','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7722','SCD-858042')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9208','SCD-858036')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1420','ORAcef 125 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1420','ORAcef 125 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1420','cefalexin 125 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1420','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1422','ORAcef 250 MG in 5 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1422','ORAcef 250 MG in 5 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1422','cefalexin 250 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1422','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1414','ORAcef 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1414','ORAcef 250 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1414','SCD-309112')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1418','ORAcef 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1418','ORAcef 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1418','SCD-309114')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5696','Orelox 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5696','Orelox 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5696','SCD-309076')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7242','Orelox 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7242','Orelox 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7242','SCD-309078')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5698','Orelox 40 MG in 5 ML Granules for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5698','Orelox 40 MG in 5 ML Granules for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5698','cefpodoxime 40 MG in 5 ML Granules for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5698','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12012','Oxifast P 4/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12012','Oxifast P 4/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12012','lornoxicam 4 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12012','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI646','Oxipod 100 MG DT Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB646','Oxipod 100 MG DT Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG646','cefpodoxime 100 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE646','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI591','Oxipod 50 MG Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB591','Oxipod 50 MG Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG591','cefpodoxime 50 MG in 5 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE591','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13634','Painact 100 MG / 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13634','Painact 100 MG / 250 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13634','aceclofenac 100 MG / chlorzoxazone 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13634','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6917','Painotab Analgesic Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6917','Painotab Analgesic Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6917','paracetamol 650 MG / caffeine anhydrous 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6917','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI449','P-Alaxin 40 MG / 320 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB449','P-Alaxin 40 MG / 320 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG449','dihydroartemisinin 40 MG / piperaquine phosphate 320 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE449','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI342','P-Alaxin 80 MG / 640 MG in 80 ML Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB342','P-Alaxin 80 MG / 640 MG in 80 ML Powder for Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG342','dihydroartemisinin 80 MG / piperaquine phosphate 640 MG in 80 ML Powder for Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE342','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5603','Pan IV 40 MG IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5603','Pan IV 40 MG IntraVenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5603','SCD-283669')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4005','Panadol Actifast 500 MG Soluble Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4005','Panadol Actifast 500 MG Soluble Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4005','SCD-1536880')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4110','Panadol Baby & Infant 120 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4110','Panadol Baby & Infant 120 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4110','paracetamol 120 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4110','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9594','Panadol Cold and Flu Day Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9594','Panadol Cold and Flu Day Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9594','paracetamol 500 MG / phenylephrine HCL 5 MG / caffeine 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9594','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI432','Panadol Elixir 240 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB432','Panadol Elixir 240 MG in 5 ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG432','paracetamol 240 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE432','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4376','Panadol Extra 500 MG / 65 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4376','Panadol Extra 500 MG / 65 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4376','SCD-307686')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10334','Panpure 20 MG IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10334','Panpure 20 MG IntraVenous Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10334','S(-) pantoprazole sodium 20 MG IntraVenous Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10334','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7998','Panpure 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7998','Panpure 20 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7998','S(-) pantoprazole sodium 20 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7998','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7590','Pantocid 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7590','Pantocid 20 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7590','pantoprazole sodium 20 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7590','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7591','Pantocid 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7591','Pantocid 40 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7591','pantoprazole sodium 40 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7591','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7594','Pantocid-D 20 MG / 10 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7594','Pantocid-D 20 MG / 10 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7594','pantoprazole 20 MG / domperidone 10 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7594','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5358','Pantoloc 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5358','Pantoloc 20 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5358','pantoprazole sodium 20 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5358','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5361','Pantoloc 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5361','Pantoloc 40 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5361','pantoprazole sodium 40 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5361','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11610','ParaCo-Denk 1000/60 Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11610','ParaCo-Denk 1000/60 Rectal Suppository','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11610','paracetamol 1000 MG / codeine phosphate 60 MG (equivalent to 44.2 MG codeine) Rectal Suppository','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11610','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4095','Para-Denk 125 Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4095','Para-Denk 125 Rectal Suppository','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4095','SCD-307666')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4081','Para-Denk 250 Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4081','Para-Denk 250 Rectal Suppository','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4081','SCD-249875')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10644','Parafast ET 1000 MG Effervescent Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10644','Parafast ET 1000 MG Effervescent Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10644','paracetamol 1000 MG Effervescent Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10644','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI401','Parafen Rectal Suppository',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB401','Parafen Rectal Suppository','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG401','paracetamol 80 MG / ibuprofen 50 MG Rectal Suppository','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE401','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6026','Paraflam 400/325 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6026','Paraflam 400/325 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6026','ibuprofen 400 MG / paracetamol 325 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6026','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7304','Parcoten 500 MG / 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7304','Parcoten 500 MG / 10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7304','paracetamol 500 MG / codeine phosphate 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7304','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7481','Pariet 10 MG Delayed Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7481','Pariet 10 MG Delayed Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7481','SCD-854872')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7483','Pariet 20 MG Delayed Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7483','Pariet 20 MG Delayed Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7483','SCD-854868')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3332','Penamox 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3332','Penamox 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3332','SCD-313797')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3333','Penamox 250 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3333','Penamox 250 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3333','SCD-239191')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3328','Penamox 250 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3328','Penamox 250 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3328','SCD-308182')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3329','Penamox 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3329','Penamox 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3329','SCD-308191')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5232','Pentalink - D 40/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5232','Pentalink - D 40/10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5232','pantoprazole sodium 40 MG / domperidone BP 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5232','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2673','Pioday 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2673','Pioday 15 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2673','SCD-317573')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2677','Pioday 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2677','Pioday 30 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2677','SCD-312440')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2680','Pioday M 15/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2680','Pioday M 15/500 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2680','SCD-861783')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15479','SCD-198108')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7724','Plendil 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7724','Plendil 2.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7724','felodipine 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7724','Extended Release?')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7725','Plendil 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7725','Plendil 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7725','felodipine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7725','Extended Release?')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2974','Ponstan Forte 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2974','Ponstan Forte 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2974','SCD-829613')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3234','POWERcef 250 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3234','POWERcef 250 MG Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3234','SCD-309092')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11297','Powerdol Plus 200/325 Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11297','Powerdol Plus 200/325 Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11297','ibuprofen 200 MG / paracetamol 325 MG in 10 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11297','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1949','Powergesic MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1949','Powergesic MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1949','diclofenac sodium 50 MG / paracetamol 500 MG / chlorzoxazone 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1949','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3040','SCD-1723476')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3065','SCD-1037045')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3039','SCD-1037179')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11717','Prasu 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11717','Prasu 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11717','SCD-855812')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI522','Prasusafe 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB522','Prasusafe 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE522','SCD-855812')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9706','Prasusafe 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9706','Prasusafe 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9706','SCD-855818')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2458','Proceptin 20 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2458','Proceptin 20 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2458','omeprazole 20 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2458','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15892','Pro-Fantrine Forte Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15892','Pro-Fantrine Forte Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15892','artemether 80 MG / lumefantrine 480 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15892','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11092','Profenazone Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11092','Profenazone Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11092','ibuprofen 200 MG / chlorzoxazone 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11092','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4738','Proguanil-BP 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4738','Proguanil-BP 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4738','SCD-864686')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5130','Proximexa 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5130','Proximexa 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5130','SCD-309098')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8218','Pynstop Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8218','Pynstop Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8218','codeine phosphate 10 MG / doxylamine succinate 5 MG / paracetamol 450 MG / caffeine 45 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8218','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13066','Pyramax 160 MG / 60 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13066','Pyramax 160 MG / 60 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13066','pyronaridine tetraphosphate 180 MG / artesunate 60 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13066','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI461','Quadrajel Oral Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB461','Quadrajel Oral Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG461','metroNIDAZOLE 1 % / chlorhexidine gluconate 1 % / lidocaine 2 % Oral Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE461','Dental')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6884','Quimed 600 MG in 2 ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6884','Quimed 600 MG in 2 ML Solution for Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6884','SCD-251135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3583','Quinaquin Mixture 50 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3583','Quinaquin Mixture 50 MG in 5 ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3583','quiNINE bisulphate 50 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3583','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI276','Quinas 300 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB276','Quinas 300 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG276','quiNINE sulphate 300 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE276','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4030','Quinidil 300 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4030','Quinidil 300 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4030','SCD-199282')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4721','quiNINE Mixture 50 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4721','quiNINE Mixture 50 MG in 5 ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4721','quiNINE bisulphate 50 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4721','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10420','Rabtune-D 20 MG / 30 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10420','Rabtune-D 20 MG / 30 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10420','rabeprazole sodium 20 MG / domperidone 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10420','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14876','Ramizid 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14876','Ramizid 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14876','SCD-401968')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11351','Ramizid 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11351','Ramizid 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11351','SCD-251857')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13712','Rapiclav 250 MG / 62.5 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13712','Rapiclav 250 MG / 62.5 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13712','amoxicillin 250 MG / clavulanate potassium 62.5 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13712','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11031','RAZ 20 MG (Lyophilised) IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11031','RAZ 20 MG (Lyophilised) IntraVenous Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11031','rabeprazole sodium 20 MG (Lyophilised) IntraVenous Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11031','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3664','Razid-M Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3664','Razid-M Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3664','rabeprazole sodium 20 MG / mosapride citrate 15 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3664','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10555','Relvar Ellipta 100/25 Inhalation Powder, 30 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10555','Relvar Ellipta 100/25 Inhalation Powder, 30 doses','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10555','SCD-1424889')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10556','Relvar Ellipta 200/25 Inhalation Powder, 30 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10556','Relvar Ellipta 200/25 Inhalation Powder, 30 doses','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10556','SCD-1648788')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI637','Revelol XL 25 MG Prolonged Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB637','Revelol XL 25 MG Prolonged Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE637','SCD-866427')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI639','Revelol XL 50 MG Prolonged Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB639','Revelol XL 50 MG Prolonged Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE639','SCD-866436')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3557','RiLIF MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3557','RiLIF MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3557','aceclofenac BP 100 MG / paracetamol BP 500 MG / chlorzoxazone USP 375 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3557','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4327','Rilif 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4327','Rilif 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4327','SCD-152544')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3349','Risek 20 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3349','Risek 20 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3349','omeprazole 20 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3349','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3351','Risek 40 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3351','Risek 40 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3351','omeprazole 40 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3351','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3350','Risek 40 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3350','Risek 40 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3350','omeprazole 40 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3350','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9721','Risek Insta 20/1680 Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9721','Risek Insta 20/1680 Powder for Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9721','SCD-753562')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9720','Risek Insta 40/1680 Powder for Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9720','Risek Insta 40/1680 Powder for Oral Suspension ','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9720','SCD-753557')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13672','Rito SR 20 MG / 150 MG Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13672','Rito SR 20 MG / 150 MG Sustained Release Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13672','rabeprazole sodium 20 MG / itopride hydrochloride 150 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13672','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11129','Rivaxime 400 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11129','Rivaxime 400 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11129','SCD-409823')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11597','Robi-D 20 MG / 100 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11597','Robi-D 20 MG / 100 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11597','rabeprazole sodium 20 MG / diclofenac sodium 100 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11597','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7808','Rocephin 1 GM IntraMuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7808','Rocephin 1 GM IntraMuscular Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7808','SCD-1665021')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7807','Rocephin 1 GM IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7807','Rocephin 1 GM IntraVenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7807','SCD-1665021')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7809','Rocephin 2 GM IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7809','Rocephin 2 GM IntraVenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7809','SCD-1665046')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7806','Rocephin 500 MG IntraMuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7806','Rocephin 500 MG IntraMuscular Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7806','SCD-1665005')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7805','Rocephin 500 MG IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7805','Rocephin 500 MG IntraVenous Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7805','SCD-1665005')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5255','Rolac 10 MG in 1 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5255','Rolac 10 MG in 1 ML Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5255','ketorolac tromethamine 10 MG in 1 ML Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5255','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1245','Rolac 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1245','Rolac 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1245','SCD-834022')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1247','Rolac 30 MG in 1 ML Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1247','Rolac 30 MG in 1 ML Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1247','SCD-1665461')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI205','Rostat 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB205','Rostat 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE205','SCD-859747')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11802','Rostat 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11802','Rostat 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11802','SCD-859751')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI204','Rostat 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB204','Rostat 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE204','SCD-859424')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3353','Rovista 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3353','Rovista 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3353','SCD-859747')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3354','Rovista 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3354','Rovista 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3354','SCD-859751')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3352','Rovista 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3352','Rovista 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3352','SCD-859424')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10362','Roxicam 20 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10362','Roxicam 20 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10362','SCD-198108')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1431','Sabulin 2 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1431','Sabulin 2 MG in 5 ML Oral Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1431','SCD-755497')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1435','Sabulin Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1435','Sabulin Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1435','SCD-197318')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3456','Salcof Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3456','Salcof Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3456','salbutamol B.P 1 MG / bromhexine B.P 2 MG / guaifenesin B.P 50 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3456','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14277','S-Amlosafe 2.5 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14277','S-Amlosafe 2.5 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14277','s (-) amlodipine besylate IP 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14277','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14278','S-Amlosafe 5 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14278','S-Amlosafe 5 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14278','s (-) amlodipine besylate IP 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14278','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12560','Sanmol 120 MG Child Effervescent Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12560','Sanmol 120 MG Child Effervescent Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG12560','paracetamol 120 MG Effervescent Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12560','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12561','Sanmol 500 MG Effervescent Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12561','Sanmol 500 MG Effervescent Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12561','SCD-1536880')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3509','Seretide Accuhaler/ Diskus 100/50, 60 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3509','Seretide Accuhaler/ Diskus 100/50, 60 Inhalations','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3509','SCD-896184')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3496','Seretide Accuhaler/ Diskus 250/50, 60 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3496','Seretide Accuhaler/ Diskus 250/50, 60 Inhalations','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3496','SCD-896209')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3488','Seretide Accuhaler/ Diskus 500/50, 60 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3488','Seretide Accuhaler/ Diskus 500/50, 60 Inhalations','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3488','SCD-896228')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3504','Seretide Evohaler 125/25 Metered Dose Inhaler, 120 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3504','Seretide Evohaler 125/25 Metered Dose Inhaler, 120 Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3504','fluticasone propionate 125 MCG/ACTUAT / salmeterol 25 MCG/ACTUAT Metered Dose Inhaler, 120 inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3504','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3506','Seretide Evohaler 250/ 25 Metered Dose Inhaler, 120 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3506','Seretide Evohaler 250/ 25 Metered Dose Inhaler, 120 Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3506','fluticasone propionate 250 MCG/ACTUAT / salmeterol 25 MCG/ACTUAT Metered Dose Inhaler, 120 inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3506','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3501','Seretide Evohaler 50/ 25 Metered Dose Inhaler, 120 Inhalations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3501','Seretide Evohaler 50/ 25 Metered Dose Inhaler, 120 Inhalations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3501','fluticasone propionate 50 MCG/ACTUAT / salmeterol 25 MCG/ACTUAT Metered Dose Inhaler, 120 inhalations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3501','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9548','Serviflox 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9548','Serviflox 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9548','SCD-197511')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9411','Shal''artem Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9411','Shal''artem Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9411','SCD-847731')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9414','Shal''artem Forte Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9414','Shal''artem Forte Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9414','artemether 80 MG / lumefantrine 480 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9414','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9410','Shalcip-TZ 500 MG / 600 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9410','Shalcip-TZ 500 MG / 600 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9410','ciprofloxacin 500 MG / tinidazole 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9410','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13946','SCD-312961')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12505','SCD-198211')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8308','S-Numlo 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8308','S-Numlo 2.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8308','s (-) amlodipine besylate IP 2.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8308','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8309','S-Numlo 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8309','S-Numlo 5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8309','s (-) amlodipine besylate IP 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8309','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4895','Sodamint 300 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4895','Sodamint 300 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4895','sodium bicarbonate 300 MG / peppermint oil 0.003 ml Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4895','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7642','Sompraz IT 40 MG / 150 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7642','Sompraz IT 40 MG / 150 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7642','esomeprazole magnesium 40 MG / itopride hydrochloride 150 MG Sustained Release Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7642','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI995','Sona Moja 300 / 600 / 50 MG Oral Caplet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB995','Sona Moja 300 / 600 / 50 MG Oral Caplet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG995','paracetamol 300 MG / aspirin 600 MG / caffeine 50 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE995','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10677','Sonacold with Vitamin C Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10677','Sonacold with Vitamin C Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10677','paracetamol 500 MG / phenylephrine HCL 5 MG / terpine hydrate 20 MG / caffeine 25 MG / vitamin C 30 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10677','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI993','Sonadol Extra 500/65 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB993','Sonadol Extra 500/65 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE993','SCD-307686')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI978','Sonapen Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB978','Sonapen Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG978','aspirin 350 MG / caffeine 30 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE978','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2831','Spasmocare Plus Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2831','Spasmocare Plus Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2831','drotaverine HCl 80 MG / mefenamic acid 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2831','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15340','Spirolac 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15340','Spirolac 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15340','SCD-313096')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4638','Spirolon 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4638','Spirolon 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4638','SCD-313096')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8302','S-Quin 300 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8302','S-Quin 300 MG/ML Solution for Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8302','quiNINE dihydrochloride 300 MG/ML Solution for Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8302','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2613','Starval 160 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2613','Starval 160 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2613','SCD-349201')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2640','Starval 80 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2640','Starval 80 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2640','SCD-349199')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13589','Stednac Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13589','Stednac Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13589','aceclofenac 1.5 % / linseed oil 3 % / methyl salicylate 10 % / menthol 5 % / benzyl alcohol 1 % Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13589','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10027','Steriject Hydralazine 20 MG/ML Injection Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10027','Steriject Hydralazine 20 MG/ML Injection Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10027','SCD-966571')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13580','Strirab-D 20/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13580','Strirab-D 20/10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13580','rabeprazole sodium 20 MG / domperidone 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13580','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5235','Strom P 50/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5235','Strom P 50/500 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5235','traMADol HCl 50 MG / paracetamol 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5235','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5233','Strom SR 100 MG Sustained Release Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5233','Strom SR 100 MG Sustained Release Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5233','SCD-1148478')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13529','Sulbacin 1.5 GM Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13529','Sulbacin 1.5 GM Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13529','SCD-1659592')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3517','Suprapen 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3517','Suprapen 500 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3517','amoxicillin 250 MG / flucloxacillin sodium 250 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3517','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3518','Suprapen Syrup 250 MG in 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3518','Suprapen Syrup 250 MG in 5 ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3518','amoxicillin 125 MG / flucloxacillin magnesium 125 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3518','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7758-120','Symbicort 160/4.5 Turbuhaler, 120 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7758-120','Symbicort 160/4.5 Turbuhaler, 120 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7758-120','budesonide 160 MCG/INHAL / formoterol fumarate dihydrate 4.5 MCG/INHAL Dry Powder Inhaler, 120 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7758-120','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7758-60','Symbicort 160/4.5 Turbuhaler, 60 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7758-60','Symbicort 160/4.5 Turbuhaler, 60 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7758-60','budesonide 160 MCG/INHAL / formoterol fumarate dihydrate 4.5 MCG/INHAL Dry Powder Inhaler, 60 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7758-60','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7759','Symbicort 320/9 Turbuhaler, 60 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7759','Symbicort 320/9 Turbuhaler, 60 doses','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7759','budesonide 320 MCG/INHAL / formoterol fumarate dihydrate 9 MCG/INHAL Dry Powder Inhaler, 60 doses','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7759','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7750','Symbicort 80/4.5 Turbuhaler, 60 doses',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7750','Symbicort 80/4.5 Turbuhaler, 60 doses','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7750','SCD-1246314')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5931','Tavanic 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5931','Tavanic 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5931','SCD-199885')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14405','Tazid 250 MG Intramuscular/Intravenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14405','Tazid 250 MG Intramuscular/Intravenous Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14405','cefTAZidime 250 MG Intramuscular/Intravenous Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14405','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6211','Teltas-40 H 40/12.5 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6211','Teltas-40 H 40/12.5 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6211','SCD-283316')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6210','Teltas 40 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6210','Teltas 40 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6210','SCD-205304')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6216','Teltas-80 H 80/25 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6216','Teltas-80 H 80/25 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6216','SCD-477130')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6214','Teltas 80 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6214','Teltas 80 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6214','SCD-205305')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10794','Tenadol 100 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10794','Tenadol 100 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10794','traMADol HCL 100 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10794','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7763','Tenoret 50 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7763','Tenoret 50 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7763','SCD-152916')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15406','Theotaz 281.25 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15406','Theotaz 281.25 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG15406','ceftriaxone 250 MG / tazobactam 31.25 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15406','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13185','Ticagre 60 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13185','Ticagre 60 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13185','SCD-1666332')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2286','Ticamet 250 HFA Inhaler 120 Puffs',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2286','Ticamet 250 HFA Inhaler 120 Puffs','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2286','salmeterol 25 MCG/ACTUAT / fluticasone propionate 250 MCG/ACTUAT Metered Dose Inhaler, 120 Puffs','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2286','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9944','Tinilox-MPS Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9944','Tinilox-MPS Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9944','tinidazole 75 MG / diloxanide 62.5 MG / simethicone 12.5 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9944','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7916','Tinilox-MPS Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7916','Tinilox-MPS Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7916','tinidazole 300 MG / diloxanide 250 MG / dimeticone 25 MG / homatropine methylbromide 1 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7916','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5237','Toflox TZ Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5237','Toflox TZ Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5237','ofloxacin 200 MG / tinidazole 600 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5237','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12382','Tolvat 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12382','Tolvat 15 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12382','SCD-849827')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI12386','Tolvat 30 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB12386','Tolvat 30 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE12386','SCD-849833')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1463','Topquine 200 MG/ML Paediatric Drops Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1463','Topquine 200 MG/ML Paediatric Drops Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG1463','quiNINE dihydrochloride 200 MG/ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1463','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10766','Toras-Denk 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10766','Toras-Denk 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10766','SCD-198369')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10765','Toras-Denk 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10765','Toras-Denk 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10765','SCD-198372')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13141','Torsinex 20 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13141','Torsinex 20 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13141','SCD-198371')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4640','Trabilin 100 MG in 2 ML Injectable Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4640','Trabilin 100 MG in 2 ML Injectable Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4640','traMADol HCL 100 MG in 2 ML Injectable Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4640','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4644','Trabilin 50 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4644','Trabilin 50 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4644','SCD-836466')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9697','SCD-1100702')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4892','Tramacetal Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4892','Tramacetal Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4892','SCD-836395')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14909','Tramacetamol 37.5/325 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14909','Tramacetamol 37.5/325 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14909','SCD-836395')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10964','Tramadol Denk 50 MG Effervescent Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10964','Tramadol Denk 50 MG Effervescent Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG10964','traMADol HCl 50 MG Effervescent Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10964','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7890','Tramal 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7890','Tramal 100 MG Oral Tablet ','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7890','SCD-2179635')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7892','Tramal SR 100 MG Sustained Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7892','Tramal SR 100 MG Sustained Release Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7892','SCD-833709')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7219','Tramed 500/250 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7219','Tramed 500/250 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7219','tranexamic acid 500 MG / mefenamic acid 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7219','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5082','Traxol-S 1.5 GM IntraMuscular/IntraVenous Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5082','Traxol-S 1.5 GM IntraMuscular/IntraVenous Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5082','cefTRIAXone 500 MG / sulbactam 500 MG IntraMuscular/IntraVenous Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5082','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1197','Trevia 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB1197','Trevia 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1197','SCD-665033')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI950','Trevia 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB950','Trevia 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE950','SCD-665042')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3361','Treviamet 50/1000 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3361','Treviamet 50/1000 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3361','SCD-861769')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3360','Treviamet 50/500 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3360','Treviamet 50/500 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3360','SCD-861819')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5188','Tricozole 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5188','Tricozole 125 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5188','metroNIDAZOLE benzoate 125 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5188','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11753','Triplixam 10/2.5/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11753','Triplixam 10/2.5/10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11753','amLODIPine 10 MG / indapamide 2.5 MG / perindopril arginine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11753','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11727','Triplixam 10/2.5/5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11727','Triplixam 10/2.5/5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11727','amLODIPine 5 MG / indapamide 2.5 MG / perindopril arginine 10 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11727','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11755','Triplixam 5/1.25/10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11755','Triplixam 5/1.25/10 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11755','amLODIPine 10 MG / indapamide 1.25 MG / perindopril arginine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11755','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11743','Triplixam 5/1.25/5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11743','Triplixam 5/1.25/5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG11743','amLODIPine 5 MG / indapamide 1.25 MG / perindopril arginine 5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11743','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI6121','Tripride 2/15/500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB6121','Tripride 2/15/500 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG6121','glimepiride 2 MG / pioglitazone HCL 15 MG / metFORMIN HCl HCL Sustained-Release 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE6121','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5933','Tritace 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5933','Tritace 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5933','SCD-401968')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5835','Tritace 2.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5835','Tritace 2.5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5835','SCD-251856')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5932','Tritace 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5932','Tritace 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5932','SCD-251857')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7308','Tritazide 10 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7308','Tritazide 10 MG / 12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7308','ramipril 10 MG / hydrochlorothiazide 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7308','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5952','Tritazide 10 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5952','Tritazide 10 MG / 25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5952','ramipril 10 MG / hydrochlorothiazide 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5952','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5950','Tritazide 5 MG / 12.5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5950','Tritazide 5 MG / 12.5 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5950','ramipril 5 MG / hydrochlorothiazide 12.5 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5950','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5947','Tritazide 5 MG / 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5947','Tritazide 5 MG / 25 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5947','ramipril 5 MG / hydrochlorothiazide 25 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5947','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9513','Trixon-S 750 MG Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9513','Trixon-S 750 MG Injection','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG9513','cefTRIAXone 500 MG / sulbactam 250 MG Injection','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9513','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5808','TX-MF 500/250 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5808','TX-MF 500/250 Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG5808','tranexamic acid 500 MG / mefenamic acid 250 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5808','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4645','SCD-1729578')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4648','SCD-1729584')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4630','SCD-1729710')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5216','Unasyn 1.5 GM Intravenous/Intramuscular Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5216','Unasyn 1.5 GM Intravenous/Intramuscular Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5216','SCD-1659592')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9482','Unitram 50 MG/ML Injectable Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB9482','Unitram 50 MG/ML Injectable Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9482','SCD-849329')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13806','Uperio 100 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13806','Uperio 100 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13806','SCD-1656349')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13803','Uperio 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13803','Uperio 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13803','SCD-1656354')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13804','Uperio 50 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13804','Uperio 50 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13804','SCD-1656340')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7247','Urgendol 50 MG/ML Injectable Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7247','Urgendol 50 MG/ML Injectable Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7247','SCD-849329')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI14720','Vagiclin Vaginal Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB14720','Vagiclin Vaginal Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG14720','clindamycin phosphate 100 MG / clotrimazole 100 MG Vaginal Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14720','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11921','Valsar-Denk 160 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11921','Valsar-Denk 160 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11921','SCD-349201')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10774','Valsar-Denk 320 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10774','Valsar-Denk 320 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10774','SCD-349200')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11919','Valsar-Denk 80 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11919','Valsar-Denk 80 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11919','SCD-349199')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5937','Valvas 5 MG / 160 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5937','Valvas 5 MG / 160 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5937','SCD-722134')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10965','Varinil 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10965','Varinil 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10965','SCD-308135')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3259','Varinil 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3259','Varinil 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3259','SCD-197361')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2287','Vasopril 10 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2287','Vasopril 10 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2287','SCD-858817')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5811','Vastor 20-EZ Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5811','Vastor 20-EZ Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5811','SCD-1422093')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI644','Vedrox 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB644','Vedrox 500 MG Oral Capsule','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE644','SCD-309049')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4584','Ventolin 0.5 MG/ML Solution for Injection',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4584','Ventolin 0.5 MG/ML Solution for Injection','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4584','SCD-199924')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4598','Ventolin Evohaler 100 MCG Metered Dose Inhaler, 200 Actuations',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4598','Ventolin Evohaler 100 MCG Metered Dose Inhaler, 200 Actuations','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4598','salbutamol 100 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Actuations','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4598','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4567','Ventolin Respirator Solution 5 MG/ML',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4567','Ventolin Respirator Solution 5 MG/ML','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4567','SCD-245314')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4558','Ventolin Rotacaps Hard Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4558','Ventolin Rotacaps Hard Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4558','salbutamol 200 MCG Inhalant Powder Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4558','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4552','Ventolin Syrup 2 MG per 5 ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4552','Ventolin Syrup 2 MG per 5 ML Oral Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4552','SCD-755497')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3630','Ventosal-4 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3630','Ventosal-4 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3630','SCD-197318')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4661','Vera-Denk 240 Retard',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4661','Vera-Denk 240 Retard','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4661','SCD-897649')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2800','VERcef 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2800','VERcef 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2800','SCD-309044')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3934','SCD-105347')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4044','Vermox 100 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4044','Vermox 100 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG4044','mebendazole 100 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4044','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4027','SCD-1855385')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10719','Victoza 6 MG/ML Solution for Injection in 3 ML Pre-Filled Pen',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10719','Victoza 6 MG/ML Solution for Injection in 3 ML Pre-Filled Pen','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10719','SCD-897122')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2960','Warexx 5 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2960','Warexx 5 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2960','SCD-855332')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11999','Wombit 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11999','Wombit 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11999','SCD-199672')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI7134','Woodwards Gripe Water Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB7134','Woodwards Gripe Water Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG7134','sodium bicarbonate 10 MG / dill seed oil 2.15 MG in 5 ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE7134','')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1043','SCD-1114198')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1044','SCD-1232082')
 INSERT INTO c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1042','SCD-1232086')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5786','Xime 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5786','Xime 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5786','SCD-197450')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11678','Xoprim 25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB11678','Xoprim 25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11678','SCD-198182')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10825','Zamadol P 37.5/325 Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10825','Zamadol P 37.5/325 Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10825','SCD-836395')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3675','Zentel 100 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3675','Zentel 100 MG in 5 ML Oral Suspension','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3675','albendazole 100 MG in 5 ML Oral Suspension','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3675','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3681','Zentel 400 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3681','Zentel 400 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3681','albendazole 400 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3681','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8009','Zerover Paediatric Paracetamol 30 MG/ML Oral Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8009','Zerover Paediatric Paracetamol 30 MG/ML Oral Solution','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8009','paracetamol 30 MG / ML Oral Solution','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8009','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15512','Zetoren 200 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15512','Zetoren 200 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15512','SCD-351127')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3363','Zetro 500 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3363','Zetro 500 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3363','SCD-248656')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10479','Ziak 10/6.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10479','Ziak 10/6.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10479','SCD-854908')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10367','Ziak 2.5/6.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10367','Ziak 2.5/6.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10367','SCD-854916')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10477','Ziak 5/6.25 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10477','Ziak 5/6.25 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10477','SCD-854919')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI15516','Zilab 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB15516','Zilab 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE15516','SCD-197452')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4096','Zinnat 125 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4096','Zinnat 125 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4096','SCD-309096')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4087','Zinnat 250 MG in 5 ML Oral Suspension',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB4087','Zinnat 250 MG in 5 ML Oral Suspension','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4087','SCD-313926')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3684','Zinnat 250 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3684','Zinnat 250 MG Oral Tablet','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3684','SCD-309097')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8616','Ziprax-DT 200 MG Dispersible Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8616','Ziprax-DT 200 MG Dispersible Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8616','cefixime 200 MG Dispersible Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8616','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5120','Zithromax 200 MG in 5 ML',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB5120','Zithromax 200 MG in 5 ML','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5120','SCD-141963')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8947','Zithroriv 500 MG Oral Capsule',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB8947','Zithroriv 500 MG Oral Capsule','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG8947','azithromycin 500 MG Oral Capsule','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8947','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10905','Zolichek - T Ophthalmic Solution',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB10905','Zolichek - T Ophthalmic Solution','SBD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10905','SCD-1923432')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3632','ZyrTAL MR Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3632','ZyrTAL MR Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3632','aceclofenac 100 MG / paracetamol 500 MG / chlorzoxazone 500 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3632','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2921','Zyrtal OD 200 MG Sustained Release Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB2921','Zyrtal OD 200 MG Sustained Release Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG2921','aceclofenac 200 MG Sustained Release Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2921','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13411','Zyrtal Topical Gel',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB13411','Zyrtal Topical Gel','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG13411','aceclofenac 1.5 % / menthol 5 % in 1 GM Topical Gel','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13411','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI3704','Zyrtal-SP 100 MG / 15 MG Oral Tablet',0) 	 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEB3704','Zyrtal-SP 100 MG / 15 MG Oral Tablet','SBD_KE') 		 INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty) VALUES ('KEG3704','aceclofenac 100 MG / serratiopeptidase 15 MG Oral Tablet','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE3704','')

 
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amLODIPine / losartan', 'KEGI8746', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amLODIPine / hydroCHLOROthiazide / losartan', 'KEGI6087', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amLODIPine / nebivolol', 'KEGI7644', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('adapalene / clindamycin', 'KEGI6491', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amLODIPine / indapamide / Perindopril', 'KEGI11755', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amLODIPine / atenolol', 'KEGI2166', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('amoxicillin / flucloxacillin', 'KEGI3518', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ampicillin / cloxacillin', 'KEGI4392', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('calcium carbonate / sodium alginate/ sodium bicarbonate', 'KEGI3004', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ciprofloxacin / tinidazole', 'KEGI9410', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('diclofenac / paracetamol / chlorzoxazone', 'KEGI11831', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('diclofenac / paracetamol / serratiopeptidase', 'KEGI452', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('diclofenac / paracetamol', 'KEGI5630', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('diclofenac / paracetamol / chlorzoxane', 'KEGI2473', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('diphenhydrAMINE / ammonium chloride', 'KEGI3172', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('esomeprazole magnesium / domperidone', 'KEGI14179', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('esomeprazole magnesium / itopride', 'KEGI7642', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('glimepiride / metFORMIN HCl', 'KEGI6996', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ibuprofen / paracetamol', 'KEGI7106', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ibuprofen / chlorzoxazone', 'KEGI11092', 0)


INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ipratropium bromide / salbutamol', 'KEGI2421', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ipratropium / fenoterol', 'KEGI2674', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('magnesium carbonate / sodium bicarbonate / magnesium trisilicate', 'KEGI3975', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('miconazole / metroNIDAZOLE', 'KEGI6957', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('nebivolol / hydrochlorothiazide', 'KEGI10776', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium bicarbonate / sodium citrate / dill / anise / ginger', 'KEGI4409', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium bicarbonate / dill', 'KEGI7134', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium bicarbonate / tartaric acid / citric acid / sodium citrate', 'KEGI8170', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium bicarbonate / peppermint', 'KEGI1600', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium bicarbonate / citric acid', 'KEGI4377', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('travoprost / timolol maleate', 'KEGI1123', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('codeine / doxylamine / paracetamol / caffeine', 'KEGI8218', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('codeine / ibuprofen / paracetamol', 'KEGI8217', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('codeine / chlorpheniramine', 'KEGI7346', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('insulin aspart / insulin aspart protamine', 'KEGI283', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sulfametopyrazine / pyrimethamine', 'KEGI4396', 0)


INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('alpha-beta arteether', 'KEGI4372', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sodium alginate / sodium bicarbonate', 'KEGI12154', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('artemisinin / piperaquine', 'KEGI1360', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('chlorzoxazone / paracetamol', 'KEGI4459', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('dexrabeprazole', 'KEGI9583', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('hyoscine butylbromide / paracetamol', 'KEGI3203', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('hyoscine-N-butylbromide', 'KEGI1147', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('iodinated povidone / metroNIDAZOLE', 'KEGI150', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('artesunate / amodiaquine', 'KEGI5419', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefalexin', 'KEGI1420', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefoperazone', 'KEGI12379', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefTRIAXone / sulbactam', 'KEGI11724', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ceftriaxone / tazobactam', 'KEGI15406', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('clopidogrel / aspirin', 'KEGI3347', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('isophane (NPH) insulin, human', 'KEGI5907', 1)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('levofloxacin / ornidazole', 'KEGI10614', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('levosalbutamol', 'KEGI2097', 1)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol', 'KEGI432', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('teneLIGLiptin', 'KEGI13271', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('tranexamic acid / mefenamic acid', 'KEGI5808', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('pantoprazole / domperidone', 'KEGI5235', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('pyronaridine tetraphosphate / artesunate', 'KEGI282', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('salbutamol', 'KEGI2315', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('salmeterol / fluticasone', 'KEGI4598', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('soluble insulin, human', 'KEGI13066', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('traMADol HCl / paracetamol', 'KEGI5191', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac', 'KEGI11830', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('salbutamol / bromhexine hydrochloride / guaifenesin / menthol', 'KEGI1517', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('salbutamol / bromhexine / guaifenesin', 'KEGI3456', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / linseed oil / methyl salicylate / menthol / benzyl alcohol', 'KEGI13589', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / menthol', 'KEGI13411', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / chlorzoxazone', 'KEGI13634', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / paracetamol', 'KEGI11842', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / paracetamol / chlorzoxazone', 'KEGI3632', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / paracetamol / serratiopeptidase', 'KEGI9825', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / thiocolchicoside', 'KEGI11889', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('aceclofenac / serratiopeptidase', 'KEGI3704', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('artemether 100 MG/ML Injection Solution', 'KEGI12301', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('camylofin / paracetamol', 'KEGI4166', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefixime / clavulanic acid', 'KEGI10796', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefixime / lactic acid bacillus', 'KEGI11704', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('artesunate', 'KEGI129', 1)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefoperazone / sulbactam', 'KEGI13074', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cefuroxime / clavulanic acid', 'KEGI15924', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('cilnidipine', 'KEGI15490', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('dicyclomine / paracetamol', 'KEGI149', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('dicycloverine HCl / paracetamol', 'KEGI532', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('drotaverine HCl / mefenamic acid', 'KEGI2831', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('glibenclamide / metFORMIN HCl', 'KEGI564', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('gliclazide', 'KEGI7412', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('gliclazide / metFORMIN HCl', 'KEGI4168', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('lornoxicam / paracetamol', 'KEGI11642', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('metroNIDAZOLE / chlorhexidine gluconate / lidocaine', 'KEGI461', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('metroNIDAZOLE% / clotrimazole', 'KEGI10723', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('metroNIDAZOLE / chlorhexidine gluconate', 'KEGI9380', 0)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('metroNIDAZOLE / diloxanide', 'KEGI8659', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('metroNIDAZOLE / neomycin / nystatin', 'KEGI10412', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('nicergoline', 'KEGI693', 1)


INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('B-artemether / lumefantrine', 'KEGI13036', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('beclometasone / salbutamol', 'KEGI8719', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('bimatoprost / timolol maleate', 'KEGI6247', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('dihydroartemisinin / piperaquine phosphate', 'KEGI342', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('etodoloac / paracetamol', 'KEGI13531', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('etoricoxib / paracetamol', 'KEGI10511', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('felodipine / metoprolol succinate', 'KEGI7701', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('indapamide / amLODIPine', 'KEGI12069', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('irbesartan / amLODIPine besylate', 'KEGI9008', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('itopride hydrochloride', 'KEGI10528', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('mefenamic acid / dicyclomine HCl', 'KEGI358', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('mefenamic acid / paracetamol', 'KEGI274', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('norfloxacin / tinidazole', 'KEGI5229', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ofloxacin / tinidazole', 'KEGI5237', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / codeine', 'KEGI11610', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / diphenhydramine HCL / pseudoephedrine HCL', 'KEGI1035', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / phenylephrine HCL', 'KEGI215', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / promethazine', 'KEGI1862', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / lidocaine', 'KEGI5332', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorpheniramine maleate / pseudoephedrine HCL / caffeine', 'KEGI510', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / caffeine / pseudoephedrine', 'KEGI2996', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine', 'KEGI11050', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorpheniramine maleate', 'KEGI496', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / phenylephrine HCL / caffeine', 'KEGI9594', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / phenylephrine HCL / terpine hydrate / caffeine / vitamin C', 'KEGI10677', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorpheniramine maleate / pseudoephedrine HCL', 'KEGI3832', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / caffeine', 'KEGI6917', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / ibuprofen', 'KEGI401', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorpheniramine maleate / vitamin C', 'KEGI11726', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / chlorphenamine maleate / phenylephrine HCl', 'KEGI146', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('paracetamol / aspirin / caffeine', 'KEGI3192', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('perindopril arginine / indapamide', 'KEGI7387', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('rabeprazole sodium / diclofenac sodium', 'KEGI11597', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('rabeprazole sodium / domperidone', 'KEGI10420', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('rabeprazole sodium / itopride hydrochloride', 'KEGI13672', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('rabeprazole sodium / mosapride citrate', 'KEGI3664', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('ramipril / hydrochlorothiazide', 'KEGI5947', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('sitaGLIPtin / metFORMIN HCl', 'KEGI9535', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('soluble insulin 30 UNITS/ML / crystalline protamine insulin', 'KEGI10906', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('soluble insulin, human 30 UNITS/ML / isophane (NPH) insulin, human', 'KEGI281', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('spironolactone / torsemide', 'KEGI13123', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('telmisartan / atorvastatin calcium', 'KEGI9889', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('terbutaline sulphate / ammonium chloride / sodium citrate', 'KEGI8169', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('terbutaline sulphate / bromhexine hydrochloride / guaifenesin / menthol', 'KEGI2611', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('terbutaline sulphate / bromhexine hydrochloride', 'KEGI11503', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('tinidazole / diloxanide / dimeticone / homatropine methylbromide', 'KEGI7916', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('tinidazole / diloxanide / simethicone', 'KEGI9944', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('VILDAgliptin / metFORMIN HCl', 'KEGI3055', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('zofenopril calcium / hydrochlorothiazide', 'KEGI11560', 0)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('zofenopril calcium', 'KEGI9416', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('S-amlodipine besylate', 'KEGI14277', 1)


INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('S-metoprolol succinate', 'KEGI7960', 1)
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient) VALUES ('S-pantoprazole sodium', 'KEGI10334', 1)

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6491', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6491'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11755', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11755'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11755', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11753'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11755', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11743'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11755', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11727'
UPDATE c_Drug_Formulation SET ingr_rxcui = '729455', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11135'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6087', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6087'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7644', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8746', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8746'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8746', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7937'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11752'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8746', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG227'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11751'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11748'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11744'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2166', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2166'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2166', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2170'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2166', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5740'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9598'
UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG16250'

UPDATE c_Drug_Formulation SET ingr_rxcui = '161', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG418'
UPDATE c_Drug_Formulation SET ingr_rxcui = '430', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3675'
UPDATE c_Drug_Formulation SET ingr_rxcui = '430', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG280'
UPDATE c_Drug_Formulation SET ingr_rxcui = '430', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10856'
UPDATE c_Drug_Formulation SET ingr_rxcui = '430', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3681'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11752'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3518', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3518'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3518', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4015'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3518', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7623'

UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8133'
UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1404'
UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG11484'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9591'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13712'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3518', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3517'
UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12275'
UPDATE c_Drug_Formulation SET ingr_rxcui = '723', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1402'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15791'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10752'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13094'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4392'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2700'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6142'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7580'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2676'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7602'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4392', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2682'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2566'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1165'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10329'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1293'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1505'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1358'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5430'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG405'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2470'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG397'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12060'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15615'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15892'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11125'
UPDATE c_Drug_Formulation SET ingr_rxcui = '282448', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9414'
UPDATE c_Drug_Formulation SET ingr_rxcui = '18631', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG11916'
UPDATE c_Drug_Formulation SET ingr_rxcui = '18631', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7936'
UPDATE c_Drug_Formulation SET ingr_rxcui = '18631', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8947'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1369', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1126'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19484', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12434'
UPDATE c_Drug_Formulation SET ingr_rxcui = '194881', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG6822'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8592'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7758-120'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7758-60'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2042'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8591'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7759'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8593'
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2044'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19831', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8541'
UPDATE c_Drug_Formulation SET ingr_rxcui = '19831', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8540'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3004', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3004'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3004', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG118'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3004', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG231'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3004', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3004', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG108'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2177', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG247'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2177', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG247'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2177', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG248'
UPDATE c_Drug_Formulation SET ingr_rxcui = '20489', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG646'
UPDATE c_Drug_Formulation SET ingr_rxcui = '20489', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3770'
UPDATE c_Drug_Formulation SET ingr_rxcui = '20489', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5698'
UPDATE c_Drug_Formulation SET ingr_rxcui = '20489', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG591'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2191', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14405'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2194', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12605'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2409', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG13296'
UPDATE c_Drug_Formulation SET ingr_rxcui = '274964', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8853'
UPDATE c_Drug_Formulation SET ingr_rxcui = '274964', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8854'

UPDATE c_Drug_Formulation SET ingr_rxcui = '465397', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8921'
UPDATE c_Drug_Formulation SET ingr_rxcui = '465397', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG515'
UPDATE c_Drug_Formulation SET ingr_rxcui = '465397', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15702'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2551', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG516'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2551', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2490'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9410', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9410'
UPDATE c_Drug_Formulation SET ingr_rxcui = '687144', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6931'
UPDATE c_Drug_Formulation SET ingr_rxcui = '687144', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG14720'
UPDATE c_Drug_Formulation SET ingr_rxcui = '687144', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10561'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11831', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5791'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI452', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4920'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2473', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2473'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11831', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1949'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI452', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5630'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5630', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG452'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11831', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11831'
UPDATE c_Drug_Formulation SET ingr_rxcui = '3443', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5480'
UPDATE c_Drug_Formulation SET ingr_rxcui = '3443', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2135'
UPDATE c_Drug_Formulation SET ingr_rxcui = '3498', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG938'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3172', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3172'
UPDATE c_Drug_Formulation SET ingr_rxcui = '3640', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1917'
UPDATE c_Drug_Formulation SET ingr_rxcui = '214536', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5759'
UPDATE c_Drug_Formulation SET ingr_rxcui = '67108', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5870'
UPDATE c_Drug_Formulation SET ingr_rxcui = '283742', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7719'
UPDATE c_Drug_Formulation SET ingr_rxcui = '283742', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5571'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14179', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG14179'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7642', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7642'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4316', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7724'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4316', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7725'
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3506'
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3501'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4603', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG6309'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4603', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5240'
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3504'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6996'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3022'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5176'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5199'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6121'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7106'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2981'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3957'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6024'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8162'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8163'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11297'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6026'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7202'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12610'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG14279'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9377'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7106', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG375'



UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11092', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11092'
UPDATE c_Drug_Formulation SET ingr_rxcui = '5640', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG16475'
UPDATE c_Drug_Formulation SET ingr_rxcui = '139825', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG297'
UPDATE c_Drug_Formulation SET ingr_rxcui = '274783', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5916'
UPDATE c_Drug_Formulation SET ingr_rxcui = '816726', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1211'
UPDATE c_Drug_Formulation SET ingr_rxcui = '816726', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1213'
UPDATE c_Drug_Formulation SET ingr_rxcui = '35827', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5255'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2421', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2421'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2421', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2674'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3975', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3975'
UPDATE c_Drug_Formulation SET ingr_rxcui = '6672', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4044'
UPDATE c_Drug_Formulation SET ingr_rxcui = '41493', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1133'
UPDATE c_Drug_Formulation SET ingr_rxcui = '6922', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7193'
UPDATE c_Drug_Formulation SET ingr_rxcui = '6922', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5188'
UPDATE c_Drug_Formulation SET ingr_rxcui = '6922', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5641'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6957', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6957'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7454', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG6244'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7646', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3349'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7646', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG6432'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7646', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2458'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7646', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3351'
UPDATE c_Drug_Formulation SET ingr_rxcui = '7646', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3350'
UPDATE c_Drug_Formulation SET ingr_rxcui = '40790', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7590'
UPDATE c_Drug_Formulation SET ingr_rxcui = '40790', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5358'
UPDATE c_Drug_Formulation SET ingr_rxcui = '40790', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5361'
UPDATE c_Drug_Formulation SET ingr_rxcui = '40790', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7591'
UPDATE c_Drug_Formulation SET ingr_rxcui = '40790', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7591'
UPDATE c_Drug_Formulation SET ingr_rxcui = '54552', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7405'
UPDATE c_Drug_Formulation SET ingr_rxcui = '54552', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7402'
UPDATE c_Drug_Formulation SET ingr_rxcui = '114979', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG11031'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1798280', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10776'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1798280', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10780'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4409', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4409'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7134', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7134'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8170', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8170'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1600', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1600'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7134', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1123'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1123', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4377'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1600', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4895'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8218', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8159'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8218', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8218'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8217', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7346', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7346'
UPDATE c_Drug_Formulation SET ingr_rxcui = '5224', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG601'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4721'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3583'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1463'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8302'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG743'
UPDATE c_Drug_Formulation SET ingr_rxcui = '9071', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG276'



UPDATE c_Drug_Formulation SET ingr_rxcui = '1191', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3733'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1191', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14983'
UPDATE c_Drug_Formulation SET ingr_rxcui = '214250', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3551'
UPDATE c_Drug_Formulation SET ingr_rxcui = '214250', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG978'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1191', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG3225'

UPDATE c_Drug_Formulation SET ingr_rxcui = '1347', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1839'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25037', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12200'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG11013'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG364'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10243'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG256'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8616'
UPDATE c_Drug_Formulation SET ingr_rxcui = '25033', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG6948'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI283', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG283'
UPDATE c_Drug_Formulation SET ingr_rxcui = '10689', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4640'
UPDATE c_Drug_Formulation SET ingr_rxcui = '10689', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1827'
UPDATE c_Drug_Formulation SET ingr_rxcui = '10689', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10794'
UPDATE c_Drug_Formulation SET ingr_rxcui = '10689', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10964'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4396', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4396'

UPDATE c_Drug_Formulation SET ingr_rxcui = '257844', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG243'
UPDATE c_Drug_Formulation SET ingr_rxcui = '257844', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12612'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4372', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4372'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4372', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10316'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12154', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12154'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1360', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1360'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4459', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4459'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4459', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11829'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4459', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7228'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9583', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG9583'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3203', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3203'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3203', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1150'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3203', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1156'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1147', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1147'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI150', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG150'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5419'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10850'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6023'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10843'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5310'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11742'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1420', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1420'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1420', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1422'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12379', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12379'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11724', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11724'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1597614', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15406'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11724', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9513'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11724', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5082'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5413'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5419', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5376'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3347', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3347'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI150', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG151'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3347', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8917'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5907', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5907', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG229'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5907', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG5907'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5907', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1217'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10614', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10614'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2097', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2097'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2097', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2096'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2097', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8645'



UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12560'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4110'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG929'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8009'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG432'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI432', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13271', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG13271'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5808', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5808'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5808', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7219'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5191', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13066', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1241'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4598', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2286'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2315', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2307'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13066', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG282'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13066', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG282Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4598', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2318'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4598', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2315'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2315', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4558'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2315', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4598'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11830', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG11830'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1517', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1517'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1517', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6458'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13589', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13589'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13411', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13411'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3456', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3456'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13634', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13634'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11842', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11842'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3632', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3632'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11842', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11518'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11842', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11828'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9825', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9825'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11889'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11830', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG441'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10053'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10052'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11830', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG2921'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3632', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13360'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3704', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3704'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3704', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13284'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3632', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG16179'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3632', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG14953'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3632', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3557'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12301'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG470'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1445'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG12227'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG718'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG464'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG444'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG1301'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12301', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG144'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10796', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10796'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11704', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11704'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10796', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11149'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11704', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11705'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4166', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG4166'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI129', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG129'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI129', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG15001'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI129', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG130'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI129', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10218'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13074', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13074'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13074', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12395'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI15924', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG15924'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI15490', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG15490'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI15490', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG15189'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI149', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG149'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI532', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG532'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2831', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2831'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI564', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG564'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7412', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7412'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4168', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG4168'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11642', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11642'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11642', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12012'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11642', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11641'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11642', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9672'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI461', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG461'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10723', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10723'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9380', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9380'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9380', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8261'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8659'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10412', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10412'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8661'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG16158'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI693', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG693'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8660'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7081'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8659', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1057'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5235', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7594'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5235', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5232'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5235', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5191'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI282', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13066'

UPDATE c_Drug_Formulation SET ingr_rxcui = '4917', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7264'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4917', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7265'

UPDATE c_Drug_Formulation SET ingr_rxcui = '4917', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14085'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4917', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14086'
UPDATE c_Drug_Formulation SET ingr_rxcui = '4917', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14087'


UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13036', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1177'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13036', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13036'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8719', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8719'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6247', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6247'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI342', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG449'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI342', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG58'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI342', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG342'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13531', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13531'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10511', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10511'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7701', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7701'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12069', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12068'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12069', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12069'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9008', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9006'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9008', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7742'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9008', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9009'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9008', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9008'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10528', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG9111'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10528', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10528'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI358', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG358'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI274', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1391'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI274', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG274'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5229', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG201'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5237', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5237'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11610', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11610'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1035', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1035'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI215', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG215'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3861'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI146', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG588'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG588'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1862', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1862'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8193'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3505'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG995'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11962'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI510', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3815'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5332', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5332'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI510', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3785'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3287'


UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5229', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5229'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI510', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG510'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2996', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2996'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6917', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG1493'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11050'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3748'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11122'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI496', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG496'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11610', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7304'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9594', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9594'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10677', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10677'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3832'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6917', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG6917'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI401', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG401'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11726', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11726'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11124'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI146', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3201'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI146', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11049'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI146', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG146'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2728'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG12488'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3192', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3192'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7387', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7385'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7387', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7387'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11597', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11597'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10420', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13580'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10420', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10420'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13672', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13672'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3664', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3664'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5952'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5950'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG5947'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9535', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9535'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13123', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG13123'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9889', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9889'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8169', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG8169'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2611', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG2611'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11503', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11503'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7916', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7916'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9944', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG9944'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3055', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3056'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3055', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3051'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3055', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG3055'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11560', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG11560'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9416', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG9416'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG7308'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10906', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG10906'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI281', ingr_tty = 'MIN_KE' WHERE form_rxcui = 'KEG281'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14277'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8309'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7938'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG8308'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG14278'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI14277', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7939'


UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7960', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7960'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7960', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7961'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10334', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG10334'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10334', ingr_tty = 'IN_KE' WHERE form_rxcui = 'KEG7998'

-- Brands


UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15219', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15219'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11830', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11830'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11828', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11828'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11889', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11889'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11518', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11518'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14362', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14362'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI282Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB282Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI282', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB282'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11842', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11842'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5940', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5940'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11190', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11190'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14370', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14370'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1819', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1819'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1818', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1818'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3268', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3268'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8719', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8719'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10053', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10053'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10052', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10052'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1426', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1426'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12200', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12200'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12202', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12202'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI280', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB280'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11169', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11169'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11170', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11170'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5080', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5080'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5176', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5176'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5199', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5199'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2166', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2166'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2170', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2170'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5214', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5214'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2535', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2535'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3060', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3060'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3092', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3092'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8746', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8746'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10943', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10943'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10938', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10938'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9820', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9820'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI227', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB227'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13094', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13094'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3146', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3146'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9598', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9598'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10752', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10752'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12375', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12375'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI822', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB822'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2027', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2027'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6142', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6142'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2700', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2700'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2676', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2676'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2682', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2682'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7602', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7602'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7580', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7580'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2646', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2646'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10270', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10270'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1827', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1827'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1825', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1825'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12233', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12233'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5298', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5298'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5374', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5374'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9889', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9889'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1270', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1270'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15615', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15615'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1445', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1445'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12227', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12227'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI129', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB129'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI130', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB130'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5419', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5419'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5376', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5376'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5413', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5413'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7937', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7937'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14983', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14983'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5690', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5690'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3139', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3139'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9700', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9700'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8637', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8637'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2758', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2758'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2759', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2759'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2761', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2761'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2739', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2739'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10376', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10376'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1738', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1738'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1739', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1739'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1737', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1737'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9559', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9559'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13271', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13271'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11136', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11136'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11137', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11137'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11135', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11135'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11916', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11916'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7523', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7523'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1839', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1839'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11447', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11447'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11446', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11446'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10856', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10856'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1161', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1161'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1126', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1126'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3172', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3172'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI938', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB938'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6689', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6689'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6354', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6354'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6685', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6685'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15702Ear', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15702Ear'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15702', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15702'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2315', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2315'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2318', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2318'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7385', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7385'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7387', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7387'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9416', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9416'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11560', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11560'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6901', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6901'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI246', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB246'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI247', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB247'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI248', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB248'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI245', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB245'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1432', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1432'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1429', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1429'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1433', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1433'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6722', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6722'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6198', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6198'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2981', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2981'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8541', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8541'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI429', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB429'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI424', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB424'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3203', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3203'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1577', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1577'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16250', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16250'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9040', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9040'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI731', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB731'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3144', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3144'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3145', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3145'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5743', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5743'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5744', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5744'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5720', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5720'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1172', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1172'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6352', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6352'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11683', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11683'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2223', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2223'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1074', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1074'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7644', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4928', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4928'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7500', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7500'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2333', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2333'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9600', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9600'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9599', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9599'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13284', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13284'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11149', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11149'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7293', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7293'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7292', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7292'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12395', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12395'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11704', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11704'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3770', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3770'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9740', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9740'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2186', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2186'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2196', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2196'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI516', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB516'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI515', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB515'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI428', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB428'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10647', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10647'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI693', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB693'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12228', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12228'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12229', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12229'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8853', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8853'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8854', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8854'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1580', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1580'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1184', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1184'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3233', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3233'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11983', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11983'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8921', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8921'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI963', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB963'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI166', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB166'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1457', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1457'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1460', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1460'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8170', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8170'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2806', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2806'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2802', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2802'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2810', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2810'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2812', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2812'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9591', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9591'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5870', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5870'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5877', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5877'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5879', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5879'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5880', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5880'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5642', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5642'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10737', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10737'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8917', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8917'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2814', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2814'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5336', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5336'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5428', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5428'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5426', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5426'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5478', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5478'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9552', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9552'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10088', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10088'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12610', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12610'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10203', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10203'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10202', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10202'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7547', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7547'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7576', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7576'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7550', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7550'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12301', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12301'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10316', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10316'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5283', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5283'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5289', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5289'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11751', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11751'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11748', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11748'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11752', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11752'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11744', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11744'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7405', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7405'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7402', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7402'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI241', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB241'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI267', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB267'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15791', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15791'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI237', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB237'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1493', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1493'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI743', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB743'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI532', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB532'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI58', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB58'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2565', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2565'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2567', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2567'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3307', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3307'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5883', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5883'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1917', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1917'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8193', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8193'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8432', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8432'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13035', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13035'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI149', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB149'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9583', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9583'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3091', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3091'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2382', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2382'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3475', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3475'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7412', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7412'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6996', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6996'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5240', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5240'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5810', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5810'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13296', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13296'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13297', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13297'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12635', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12635'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2924', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2924'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7116', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7116'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7111', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7111'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7183', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7183'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7256', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7256'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12705', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12705'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12707', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12707'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8661', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8661'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8659', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8659'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8660', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8660'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5191', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5191'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11443', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11443'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1600', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1600'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2674', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2674'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1048', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1048'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1057', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1057'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4372', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4372'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3143', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3143'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3140', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3140'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3141', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3141'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5758', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5758'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5759', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5759'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2385', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2385'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2584', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2584'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4311', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4311'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10378', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10378'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9704', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9704'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14179', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14179'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13571', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13571'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6289', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6289'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5571', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5571'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3037', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3037'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2994', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2994'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3564', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3564'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3566', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3566'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI364', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB364'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI256', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB256'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10598', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10598'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10850', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10850'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10843', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10843'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4701', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4701'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16185', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16185'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11013', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11013'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13761', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13761'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5641', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5641'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5897', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5897'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7623', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7623'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6014', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6014'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14279', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14279'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8592', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8592'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8591', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8591'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8593', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8593'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2042', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2042'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2044', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2044'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4166', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4166'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3057', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3057'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3064', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3064'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11073', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11073'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11066', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11066'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13679', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13679'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2989', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2989'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12605', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12605'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6309', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6309'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15924', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15924'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2080', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2080'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13074', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13074'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI441', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB441'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI418', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB418'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI404', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB404'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3035', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3035'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3056', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3056'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3051', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3051'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3055', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3055'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3004', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3004'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3318', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3318'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3319', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3319'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3321', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3321'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9111', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9111'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI564', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB564'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4168', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4168'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3009', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3009'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3023', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3023'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI144', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB144'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2670', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2670'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3276', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3276'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4497', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4497'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10529', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10529'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4535', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4535'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13625', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13625'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10484', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10484'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10485', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10485'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1190', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1190'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10486', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10486'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10487', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10487'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10488', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10488'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI590', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB590'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI673', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB673'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6948', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6948'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI444', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB444'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3505', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3505'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2728', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2728'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1148', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1148'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1202', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1202'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1207', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1207'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1211', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1211'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1213', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1213'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1217', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1239', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1239'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1235', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1239-4ML', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1239-4ML'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1246', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1246'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1241', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1241'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1246-4ML', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1246-4ML'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13349', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13349'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1150', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1150'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10890', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10890'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6359', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6359'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10516', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10516'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11606', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11606'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11582', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11582'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11585', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11585'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11586', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11586'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12379', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12379'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11139', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11139'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10243', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10243'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI217', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI229Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB229Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI229', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB229'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5907Vial', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5907Vial'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5907', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5907'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10907', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10907'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5399', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5399'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5308', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5308'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10528', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10528'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2490', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2490'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9539', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9539'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9535', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9535'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI929', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB929'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12275', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12275'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5970', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5970'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6493', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6493'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7696', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7696'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12059', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12059'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12060', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12060'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4217', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15491', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15491'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15506', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15506'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4350', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4350'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4385', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4385'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6898', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6898'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13123', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13123'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3129', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3129'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3131', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3131'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3130', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3130'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5912', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5912'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5916', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5916'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5916Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5916Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8684', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8684'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10218', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10218'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5459', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5459'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4419', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4419'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13116', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13116'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12630', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12630'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8645', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8645'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI297Vial', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB297Vial'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI297Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB297Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI297', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB297'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11911', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11911'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10614', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10614'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2096', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2096'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13784', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13784'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13778', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13778'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI601', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB601'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3339', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3339'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4635', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4635'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5819', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5819'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI452', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB452'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2316', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2316'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2353', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2353'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7701', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7701'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2394', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2394'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11641', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11641'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11642', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11642'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9602', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9602'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10089', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10089'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7705', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7705'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7706', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7706'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9672', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9672'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1177', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1177'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2253', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2253'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1301', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1301'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2253R', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2253R'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7936', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7936'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12494', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12494'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8133', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8133'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6057', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6057'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1391', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1391'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12612', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12612'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI274', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB274'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI243', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB243'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI358', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB358'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7501', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7501'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8280', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8280'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1279', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1279'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9606', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9606'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3085', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3085'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10767', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10767'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1365', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1365'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1366', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1366'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7960', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7960'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7961', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7961'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6253', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6253'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6239', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6239'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2628', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2628'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2626', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2626'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6517', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6517'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI281Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB281Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI281', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB281'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1133', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1133'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5480', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5480'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5477', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5477'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1404', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1404'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1402', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1402'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7414', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7414'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12068', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12068'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12069', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12069'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12488', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12488'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10776', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10776'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10780', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10780'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11484', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11484'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7719', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7719'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7721', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7721'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4102', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4102'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3979', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3979'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5858', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5858'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14086', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14086'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14087', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14087'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14085', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14085'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7264', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7264'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7265', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7265'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13071', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13071'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3347', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3347'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI201', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB201'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5229', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5229'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI283Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB283Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI283', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB283'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI299', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB299'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI301', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB301'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI304', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB304'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI289Vial', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB289Vial'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI289Pen', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB289Pen'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI289', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB289'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16472', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16472'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI122', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB122'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16475', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16475'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13150', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13150'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13149', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13149'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10822', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10822'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10823', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10823'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10827', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10827'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10828', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10828'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6432', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6432'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11724', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11724'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1420', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1420'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1422', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1422'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1414', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1414'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1418', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1418'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5696', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5696'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7242', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7242'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5698', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5698'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12012', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12012'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI646', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB646'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI449', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB449'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI342', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB342'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13634', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13634'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5603', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5603'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4005', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4005'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4110', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4110'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI432', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB432'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4376', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4376'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10334', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10334'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7998', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7998'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7590', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7590'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7591', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7591'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7594', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7594'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5358', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5358'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5361', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5361'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4095', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4095'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4081', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4081'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11610', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11610'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10644', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6026', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6026'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7304', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7304'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7481', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7481'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7483', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7483'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3332', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3332'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3333', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3333'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3328', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3328'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3329', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3329'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5232', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5232'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2673', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2673'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2677', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2677'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2680', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2680'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7724', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7724'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7725', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7725'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2974', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2974'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3234', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3234'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11297', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11297'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11717', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11717'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI522', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB522'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9706', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9706'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2458', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2458'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4738', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4738'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5130', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5130'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13066', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13066'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6884', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6884'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3583', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3583'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI276', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB276'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4030', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4030'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4721', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4721'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10420', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10420'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14876', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14876'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11351', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11351'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13712', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13712'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11031', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11031'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10555', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10555'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10556', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10556'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI637', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB637'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI639', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB639'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3349', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3349'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3351', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3351'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3350', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3350'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9721', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9721'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9720', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9720'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13672', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13672'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11129', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11129'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11597', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11597'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7808', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7808'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7807', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7807'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7809', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7809'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7806', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7806'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7805', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7805'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5255', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5255'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1245', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1245'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1247', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1247'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3353', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3353'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3354', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3354'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3352', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3352'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10362', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10362'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14277', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14277'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14278', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14278'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8302', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8302'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1431', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1431'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12560', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12560'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12561', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12561'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3509', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3509'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3496', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3496'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3488', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3488'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3504', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3504'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3506', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3506'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3501', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3501'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9548', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9548'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4895', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4895'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7642', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7642'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI995', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB995'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI993', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB993'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4638', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4638'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2613', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2613'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2640', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2640'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10027', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10027'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13580', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13580'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5235', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5233', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5233'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13529', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13529'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3517', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3517'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3518', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3518'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7758-120', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7758-120'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7758-60', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7758-60'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7759', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7759'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7750', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7750'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5931', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5931'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14405', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14405'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6211', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6211'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6216', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6216'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10794', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10794'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7763', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7763'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15406', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15406'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13185', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13185'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2286', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2286'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12382', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12382'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12386', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12386'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1463', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1463'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10766', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10766'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10765', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10765'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4640', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4640'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14909', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14909'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10964', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10964'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7890', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7890'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7892', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7892'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7219', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7219'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5082', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5082'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1197', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1197'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI950', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB950'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3361', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3361'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3360', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3360'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5188', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5188'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11753', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11753'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11727', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11727'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11755', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11755'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11743', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11743'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6121', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6121'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5933', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5933'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5835', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5835'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5932', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5932'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7308', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7308'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5952', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5952'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5950', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5950'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5947', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5947'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9513', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9513'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5808', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5808'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5216', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5216'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9482', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9482'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13806', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13806'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13803', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13803'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13804', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13804'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7247', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7247'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11921', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11921'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10774', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10774'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11919', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11919'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5937', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5937'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10965', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10965'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3259', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3259'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2287', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2287'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5811', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5811'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI644', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4584', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4584'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4567', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4567'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4552', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4552'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4661', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4661'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2800', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2800'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4044', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4044'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10719', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10719'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11999', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11999'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5786', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5786'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11678', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11678'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10825', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10825'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3675', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3675'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3681', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3681'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8009', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8009'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15512', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15512'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3363', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3363'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10479', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10479'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10367', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10367'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10477', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10477'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15516', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15516'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4096', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4096'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4087', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4087'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3684', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3684'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8616', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8616'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5120', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5120'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8947', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8947'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2921', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2921'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3704', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3704'

UPDATE c_Drug_Brand SET brand_name = 'Ace' WHERE brand_name_rxcui = 'KEBI15219'
UPDATE c_Drug_Brand SET brand_name = 'Acecor' WHERE brand_name_rxcui = 'KEBI11830'
UPDATE c_Drug_Brand SET brand_name = 'Acecor P' WHERE brand_name_rxcui = 'KEBI11828'
UPDATE c_Drug_Brand SET brand_name = 'Acepar Plus' WHERE brand_name_rxcui = 'KEBI11889'
UPDATE c_Drug_Brand SET brand_name = 'Aclofre-P' WHERE brand_name_rxcui = 'KEBI11518'
UPDATE c_Drug_Brand SET brand_name = 'Actidrox' WHERE brand_name_rxcui = 'KEBI14362'
UPDATE c_Drug_Brand SET brand_name = 'ACTrapid FlexPen' WHERE brand_name_rxcui = 'KEBI282Pen'
UPDATE c_Drug_Brand SET brand_name = 'ACTrapid Penfill' WHERE brand_name_rxcui = 'KEBI282'
UPDATE c_Drug_Brand SET brand_name = 'Acufen XP' WHERE brand_name_rxcui = 'KEBI11842'
UPDATE c_Drug_Brand SET brand_name = 'Acular' WHERE brand_name_rxcui = 'KEBI5940'
UPDATE c_Drug_Brand SET brand_name = 'Aderan' WHERE brand_name_rxcui = 'KEBI11190'
UPDATE c_Drug_Brand SET brand_name = 'Adol Infants'' Drops' WHERE brand_name_rxcui = 'KEBI14370'
UPDATE c_Drug_Brand SET brand_name = 'Advant' WHERE brand_name_rxcui = 'KEBI1819'
UPDATE c_Drug_Brand SET brand_name = 'Advant' WHERE brand_name_rxcui = 'KEBI1818'
UPDATE c_Drug_Brand SET brand_name = 'Advantec' WHERE brand_name_rxcui = 'KEBI3268'
UPDATE c_Drug_Brand SET brand_name = 'Aerovent Metered Dose Inhaler,' WHERE brand_name_rxcui = 'KEBI8719'
UPDATE c_Drug_Brand SET brand_name = 'Aflodor' WHERE brand_name_rxcui = 'KEBI10053'
UPDATE c_Drug_Brand SET brand_name = 'Aflodor' WHERE brand_name_rxcui = 'KEBI10052'
UPDATE c_Drug_Brand SET brand_name = 'Airtal' WHERE brand_name_rxcui = 'KEBI1426'
UPDATE c_Drug_Brand SET brand_name = 'Akudinir' WHERE brand_name_rxcui = 'KEBI12200'
UPDATE c_Drug_Brand SET brand_name = 'Akudinir' WHERE brand_name_rxcui = 'KEBI12202'
UPDATE c_Drug_Brand SET brand_name = 'Albasol' WHERE brand_name_rxcui = 'KEBI280'
UPDATE c_Drug_Brand SET brand_name = 'Aldomet' WHERE brand_name_rxcui = 'KEBI11169'
UPDATE c_Drug_Brand SET brand_name = 'Aldomet' WHERE brand_name_rxcui = 'KEBI11170'
UPDATE c_Drug_Brand SET brand_name = 'Amaryl' WHERE brand_name_rxcui = 'KEBI5080'
UPDATE c_Drug_Brand SET brand_name = 'Amaryl M' WHERE brand_name_rxcui = 'KEBI5176'
UPDATE c_Drug_Brand SET brand_name = 'Amaryl M SR' WHERE brand_name_rxcui = 'KEBI5199'
UPDATE c_Drug_Brand SET brand_name = 'Amdocal Plus' WHERE brand_name_rxcui = 'KEBI2166'
UPDATE c_Drug_Brand SET brand_name = 'Amdocal Plus' WHERE brand_name_rxcui = 'KEBI2170'
UPDATE c_Drug_Brand SET brand_name = 'Amlibon' WHERE brand_name_rxcui = 'KEBI5214'
UPDATE c_Drug_Brand SET brand_name = 'Amlibon' WHERE brand_name_rxcui = 'KEBI2535'
UPDATE c_Drug_Brand SET brand_name = 'Amlo-Denk' WHERE brand_name_rxcui = 'KEBI3060'
UPDATE c_Drug_Brand SET brand_name = 'Amlo-Denk' WHERE brand_name_rxcui = 'KEBI3092'
UPDATE c_Drug_Brand SET brand_name = 'Amlocip NB' WHERE brand_name_rxcui = 'KEBI8746'
UPDATE c_Drug_Brand SET brand_name = 'Amlodipine' WHERE brand_name_rxcui = 'KEBI10943'
UPDATE c_Drug_Brand SET brand_name = 'Amlodipine' WHERE brand_name_rxcui = 'KEBI10938'
UPDATE c_Drug_Brand SET brand_name = 'Amlostar' WHERE brand_name_rxcui = 'KEBI9820'
UPDATE c_Drug_Brand SET brand_name = 'Amlozaar' WHERE brand_name_rxcui = 'KEBI227'
UPDATE c_Drug_Brand SET brand_name = 'Amoklavin ES' WHERE brand_name_rxcui = 'KEBI13094'
UPDATE c_Drug_Brand SET brand_name = 'Amoxi-Denk' WHERE brand_name_rxcui = 'KEBI3146'
UPDATE c_Drug_Brand SET brand_name = 'Amoxiclav-Denk' WHERE brand_name_rxcui = 'KEBI9598'
UPDATE c_Drug_Brand SET brand_name = 'AmoxiClav-Denk' WHERE brand_name_rxcui = 'KEBI10752'
UPDATE c_Drug_Brand SET brand_name = 'Ampcare' WHERE brand_name_rxcui = 'KEBI12375'
UPDATE c_Drug_Brand SET brand_name = 'Ampecin' WHERE brand_name_rxcui = 'KEBI822'
UPDATE c_Drug_Brand SET brand_name = 'Ampicen' WHERE brand_name_rxcui = 'KEBI2027'
UPDATE c_Drug_Brand SET brand_name = 'Ampiclomed' WHERE brand_name_rxcui = 'KEBI6142'
UPDATE c_Drug_Brand SET brand_name = 'Ampiclox' WHERE brand_name_rxcui = 'KEBI2700'
UPDATE c_Drug_Brand SET brand_name = 'Ampiclox' WHERE brand_name_rxcui = 'KEBI2676'
UPDATE c_Drug_Brand SET brand_name = 'Ampiclox' WHERE brand_name_rxcui = 'KEBI2682'
UPDATE c_Drug_Brand SET brand_name = 'Ampoxin' WHERE brand_name_rxcui = 'KEBI7602'
UPDATE c_Drug_Brand SET brand_name = 'Ampoxin' WHERE brand_name_rxcui = 'KEBI7580'
UPDATE c_Drug_Brand SET brand_name = 'Amtel' WHERE brand_name_rxcui = 'KEBI2646'
UPDATE c_Drug_Brand SET brand_name = 'Amtel' WHERE brand_name_rxcui = 'KEBI10270'
UPDATE c_Drug_Brand SET brand_name = 'Anadol' WHERE brand_name_rxcui = 'KEBI1827'
UPDATE c_Drug_Brand SET brand_name = 'Anadol' WHERE brand_name_rxcui = 'KEBI1825'
UPDATE c_Drug_Brand SET brand_name = 'Apidra Solostar' WHERE brand_name_rxcui = 'KEBI12233'
UPDATE c_Drug_Brand SET brand_name = 'Aprovel' WHERE brand_name_rxcui = 'KEBI5298'
UPDATE c_Drug_Brand SET brand_name = 'Aprovel' WHERE brand_name_rxcui = 'KEBI5374'
UPDATE c_Drug_Brand SET brand_name = 'Arbitel-AV' WHERE brand_name_rxcui = 'KEBI9889'
UPDATE c_Drug_Brand SET brand_name = 'Artefan' WHERE brand_name_rxcui = 'KEBI1270'
UPDATE c_Drug_Brand SET brand_name = 'Artefan' WHERE brand_name_rxcui = 'KEBI15615'
UPDATE c_Drug_Brand SET brand_name = 'Artesiane' WHERE brand_name_rxcui = 'KEBI1445'
UPDATE c_Drug_Brand SET brand_name = 'Artesiane' WHERE brand_name_rxcui = 'KEBI12227'
UPDATE c_Drug_Brand SET brand_name = 'Artesun' WHERE brand_name_rxcui = 'KEBI129'
UPDATE c_Drug_Brand SET brand_name = 'Artesun' WHERE brand_name_rxcui = 'KEBI130'
UPDATE c_Drug_Brand SET brand_name = 'Artesunate Amodiaquine Winthrop' WHERE brand_name_rxcui = 'KEBI5419'
UPDATE c_Drug_Brand SET brand_name = 'Artesunate Amodiaquine Winthrop' WHERE brand_name_rxcui = 'KEBI5376'
UPDATE c_Drug_Brand SET brand_name = 'Artesunate Amodiaquine Winthrop' WHERE brand_name_rxcui = 'KEBI5413'
UPDATE c_Drug_Brand SET brand_name = 'Asomex-LT' WHERE brand_name_rxcui = 'KEBI7937'
UPDATE c_Drug_Brand SET brand_name = 'Aspro' WHERE brand_name_rxcui = 'KEBI14983'
UPDATE c_Drug_Brand SET brand_name = 'Atacand Plus' WHERE brand_name_rxcui = 'KEBI5690'
UPDATE c_Drug_Brand SET brand_name = 'Atenolol Denk' WHERE brand_name_rxcui = 'KEBI3139'
UPDATE c_Drug_Brand SET brand_name = 'Atorem' WHERE brand_name_rxcui = 'KEBI9700'
UPDATE c_Drug_Brand SET brand_name = 'Atorlip EZ' WHERE brand_name_rxcui = 'KEBI8637'
UPDATE c_Drug_Brand SET brand_name = 'Augmentin' WHERE brand_name_rxcui = 'KEBI2758'
UPDATE c_Drug_Brand SET brand_name = 'Augmentin' WHERE brand_name_rxcui = 'KEBI2759'
UPDATE c_Drug_Brand SET brand_name = 'Augmentin' WHERE brand_name_rxcui = 'KEBI2761'
UPDATE c_Drug_Brand SET brand_name = 'Augmentin ES' WHERE brand_name_rxcui = 'KEBI2739'
UPDATE c_Drug_Brand SET brand_name = 'Auroliza-H' WHERE brand_name_rxcui = 'KEBI10376'
UPDATE c_Drug_Brand SET brand_name = 'Aurozil' WHERE brand_name_rxcui = 'KEBI1738'
UPDATE c_Drug_Brand SET brand_name = 'Aurozil' WHERE brand_name_rxcui = 'KEBI1739'
UPDATE c_Drug_Brand SET brand_name = 'Aurozil' WHERE brand_name_rxcui = 'KEBI1737'
UPDATE c_Drug_Brand SET brand_name = 'Avastatin' WHERE brand_name_rxcui = 'KEBI9559'
UPDATE c_Drug_Brand SET brand_name = 'Aveza' WHERE brand_name_rxcui = 'KEBI13271'
UPDATE c_Drug_Brand SET brand_name = 'Avsar' WHERE brand_name_rxcui = 'KEBI11136'
UPDATE c_Drug_Brand SET brand_name = 'Avsar' WHERE brand_name_rxcui = 'KEBI11137'
UPDATE c_Drug_Brand SET brand_name = 'Avsar' WHERE brand_name_rxcui = 'KEBI11135'
UPDATE c_Drug_Brand SET brand_name = 'Azidawa' WHERE brand_name_rxcui = 'KEBI11916'
UPDATE c_Drug_Brand SET brand_name = 'Aztor EZ' WHERE brand_name_rxcui = 'KEBI7523'
UPDATE c_Drug_Brand SET brand_name = 'Beclomin' WHERE brand_name_rxcui = 'KEBI1839'
UPDATE c_Drug_Brand SET brand_name = 'Bedranol' WHERE brand_name_rxcui = 'KEBI11447'
UPDATE c_Drug_Brand SET brand_name = 'Bedranol' WHERE brand_name_rxcui = 'KEBI11446'
UPDATE c_Drug_Brand SET brand_name = 'Benaworm' WHERE brand_name_rxcui = 'KEBI10856'
UPDATE c_Drug_Brand SET brand_name = 'Benduric' WHERE brand_name_rxcui = 'KEBI1161'
UPDATE c_Drug_Brand SET brand_name = 'Benduric' WHERE brand_name_rxcui = 'KEBI1126'
UPDATE c_Drug_Brand SET brand_name = 'Benylin Original' WHERE brand_name_rxcui = 'KEBI3172'
UPDATE c_Drug_Brand SET brand_name = 'Benylin Paediatric' WHERE brand_name_rxcui = 'KEBI938'
UPDATE c_Drug_Brand SET brand_name = 'Betaloc ZoK' WHERE brand_name_rxcui = 'KEBI6689'
UPDATE c_Drug_Brand SET brand_name = 'Betaloc Zok' WHERE brand_name_rxcui = 'KEBI6354'
UPDATE c_Drug_Brand SET brand_name = 'Betaloc ZoK' WHERE brand_name_rxcui = 'KEBI6685'
UPDATE c_Drug_Brand SET brand_name = 'Beuflox-D' WHERE brand_name_rxcui = 'KEBI15702Ear'
UPDATE c_Drug_Brand SET brand_name = 'Beuflox-D' WHERE brand_name_rxcui = 'KEBI15702'
UPDATE c_Drug_Brand SET brand_name = 'Bexitrol -F HFA Inhaler' WHERE brand_name_rxcui = 'KEBI2315'
UPDATE c_Drug_Brand SET brand_name = 'Bexitrol -F HFA Inhaler' WHERE brand_name_rxcui = 'KEBI2318'
UPDATE c_Drug_Brand SET brand_name = 'bi Preterax' WHERE brand_name_rxcui = 'KEBI7385'
UPDATE c_Drug_Brand SET brand_name = 'bi Preterax' WHERE brand_name_rxcui = 'KEBI7387'
UPDATE c_Drug_Brand SET brand_name = 'Bifril' WHERE brand_name_rxcui = 'KEBI9416'
UPDATE c_Drug_Brand SET brand_name = 'Bifril Plus' WHERE brand_name_rxcui = 'KEBI11560'
UPDATE c_Drug_Brand SET brand_name = 'Bimonate' WHERE brand_name_rxcui = 'KEBI6901'
UPDATE c_Drug_Brand SET brand_name = 'Biodroxil' WHERE brand_name_rxcui = 'KEBI246'
UPDATE c_Drug_Brand SET brand_name = 'Biodroxil' WHERE brand_name_rxcui = 'KEBI247'
UPDATE c_Drug_Brand SET brand_name = 'Biodroxil' WHERE brand_name_rxcui = 'KEBI248'
UPDATE c_Drug_Brand SET brand_name = 'Biodroxil' WHERE brand_name_rxcui = 'KEBI245'
UPDATE c_Drug_Brand SET brand_name = 'Blokium' WHERE brand_name_rxcui = 'KEBI1432'
UPDATE c_Drug_Brand SET brand_name = 'Blokium' WHERE brand_name_rxcui = 'KEBI1429'
UPDATE c_Drug_Brand SET brand_name = 'Blokium DIU' WHERE brand_name_rxcui = 'KEBI1433'
UPDATE c_Drug_Brand SET brand_name = 'Brilinta' WHERE brand_name_rxcui = 'KEBI6722'
UPDATE c_Drug_Brand SET brand_name = 'Bromodel' WHERE brand_name_rxcui = 'KEBI6198'
UPDATE c_Drug_Brand SET brand_name = 'Brustan' WHERE brand_name_rxcui = 'KEBI2981'
UPDATE c_Drug_Brand SET brand_name = 'Budecort' WHERE brand_name_rxcui = 'KEBI8541'
UPDATE c_Drug_Brand SET brand_name = 'Buscopan' WHERE brand_name_rxcui = 'KEBI429'
UPDATE c_Drug_Brand SET brand_name = 'Buscopan' WHERE brand_name_rxcui = 'KEBI424'
UPDATE c_Drug_Brand SET brand_name = 'Buscopan Plus' WHERE brand_name_rxcui = 'KEBI3203'
UPDATE c_Drug_Brand SET brand_name = 'Caduet' WHERE brand_name_rxcui = 'KEBI1577'
UPDATE c_Drug_Brand SET brand_name = 'Camox' WHERE brand_name_rxcui = 'KEBI16250'
UPDATE c_Drug_Brand SET brand_name = 'Candez' WHERE brand_name_rxcui = 'KEBI9040'
UPDATE c_Drug_Brand SET brand_name = 'Candez' WHERE brand_name_rxcui = 'KEBI731'
UPDATE c_Drug_Brand SET brand_name = 'Captopril Denk' WHERE brand_name_rxcui = 'KEBI3144'
UPDATE c_Drug_Brand SET brand_name = 'Captopril+HCT Denk' WHERE brand_name_rxcui = 'KEBI3145'
UPDATE c_Drug_Brand SET brand_name = 'Carca' WHERE brand_name_rxcui = 'KEBI5743'
UPDATE c_Drug_Brand SET brand_name = 'Carca' WHERE brand_name_rxcui = 'KEBI5744'
UPDATE c_Drug_Brand SET brand_name = 'Cardinol' WHERE brand_name_rxcui = 'KEBI5720'
UPDATE c_Drug_Brand SET brand_name = 'Cardinol' WHERE brand_name_rxcui = 'KEBI1172'
UPDATE c_Drug_Brand SET brand_name = 'Cardinol' WHERE brand_name_rxcui = 'KEBI6352'
UPDATE c_Drug_Brand SET brand_name = 'Cardisprin' WHERE brand_name_rxcui = 'KEBI11683'
UPDATE c_Drug_Brand SET brand_name = 'Cardisprin' WHERE brand_name_rxcui = 'KEBI2223'
UPDATE c_Drug_Brand SET brand_name = 'Carditan' WHERE brand_name_rxcui = 'KEBI1074'
UPDATE c_Drug_Brand SET brand_name = 'Carditan AM' WHERE brand_name_rxcui = 'KEBI7644'
UPDATE c_Drug_Brand SET brand_name = 'Carditan H' WHERE brand_name_rxcui = 'KEBI4928'
UPDATE c_Drug_Brand SET brand_name = 'Cardivas' WHERE brand_name_rxcui = 'KEBI7500'
UPDATE c_Drug_Brand SET brand_name = 'Cardopril' WHERE brand_name_rxcui = 'KEBI2333'
UPDATE c_Drug_Brand SET brand_name = 'Carvedi-Denk' WHERE brand_name_rxcui = 'KEBI9600'
UPDATE c_Drug_Brand SET brand_name = 'Carvedi-Denk' WHERE brand_name_rxcui = 'KEBI9599'
UPDATE c_Drug_Brand SET brand_name = 'Ceclonec-S' WHERE brand_name_rxcui = 'KEBI13284'
UPDATE c_Drug_Brand SET brand_name = 'Cef-Clave' WHERE brand_name_rxcui = 'KEBI11149'
UPDATE c_Drug_Brand SET brand_name = 'Cefacure' WHERE brand_name_rxcui = 'KEBI7293'
UPDATE c_Drug_Brand SET brand_name = 'Cefacure' WHERE brand_name_rxcui = 'KEBI7292'
UPDATE c_Drug_Brand SET brand_name = 'Cefo-bact' WHERE brand_name_rxcui = 'KEBI12395'
UPDATE c_Drug_Brand SET brand_name = 'Cefo-L' WHERE brand_name_rxcui = 'KEBI11704'
UPDATE c_Drug_Brand SET brand_name = 'Cefpodox' WHERE brand_name_rxcui = 'KEBI3770'
UPDATE c_Drug_Brand SET brand_name = 'CEFzole' WHERE brand_name_rxcui = 'KEBI9740'
UPDATE c_Drug_Brand SET brand_name = 'Cemet' WHERE brand_name_rxcui = 'KEBI2186'
UPDATE c_Drug_Brand SET brand_name = 'Cemet' WHERE brand_name_rxcui = 'KEBI2196'
UPDATE c_Drug_Brand SET brand_name = 'Ceprolen' WHERE brand_name_rxcui = 'KEBI516'
UPDATE c_Drug_Brand SET brand_name = 'Ceprolen-D' WHERE brand_name_rxcui = 'KEBI515'
UPDATE c_Drug_Brand SET brand_name = 'Cetamol' WHERE brand_name_rxcui = 'KEBI428'
UPDATE c_Drug_Brand SET brand_name = 'CEzol' WHERE brand_name_rxcui = 'KEBI10647'
UPDATE c_Drug_Brand SET brand_name = 'Cholergol' WHERE brand_name_rxcui = 'KEBI693'
UPDATE c_Drug_Brand SET brand_name = 'Cholestrom' WHERE brand_name_rxcui = 'KEBI12228'
UPDATE c_Drug_Brand SET brand_name = 'Cholestrom' WHERE brand_name_rxcui = 'KEBI12229'
UPDATE c_Drug_Brand SET brand_name = 'Ciclohale' WHERE brand_name_rxcui = 'KEBI8853'
UPDATE c_Drug_Brand SET brand_name = 'Ciclohale' WHERE brand_name_rxcui = 'KEBI8854'
UPDATE c_Drug_Brand SET brand_name = 'Ciloxan' WHERE brand_name_rxcui = 'KEBI1580'
UPDATE c_Drug_Brand SET brand_name = 'Cipro-Cent' WHERE brand_name_rxcui = 'KEBI1184'
UPDATE c_Drug_Brand SET brand_name = 'Cipro-Denk' WHERE brand_name_rxcui = 'KEBI3233'
UPDATE c_Drug_Brand SET brand_name = 'Cipro-Denk' WHERE brand_name_rxcui = 'KEBI11983'
UPDATE c_Drug_Brand SET brand_name = 'Cipro-T' WHERE brand_name_rxcui = 'KEBI8921'
UPDATE c_Drug_Brand SET brand_name = 'Ciprobay' WHERE brand_name_rxcui = 'KEBI963'
UPDATE c_Drug_Brand SET brand_name = 'Ciprobay' WHERE brand_name_rxcui = 'KEBI166'
UPDATE c_Drug_Brand SET brand_name = 'Cipronat' WHERE brand_name_rxcui = 'KEBI1457'
UPDATE c_Drug_Brand SET brand_name = 'Cipronat' WHERE brand_name_rxcui = 'KEBI1460'
UPDATE c_Drug_Brand SET brand_name = 'Citro-Soda Gastric Antacid Effervescent Granules' WHERE brand_name_rxcui = 'KEBI8170'
UPDATE c_Drug_Brand SET brand_name = 'Clavulin' WHERE brand_name_rxcui = 'KEBI2806'
UPDATE c_Drug_Brand SET brand_name = 'Clavulin' WHERE brand_name_rxcui = 'KEBI2802'
UPDATE c_Drug_Brand SET brand_name = 'Clavulin' WHERE brand_name_rxcui = 'KEBI2810'
UPDATE c_Drug_Brand SET brand_name = 'Clavulin' WHERE brand_name_rxcui = 'KEBI2812'
UPDATE c_Drug_Brand SET brand_name = 'Cledomox DT' WHERE brand_name_rxcui = 'KEBI9591'
UPDATE c_Drug_Brand SET brand_name = 'Clexane' WHERE brand_name_rxcui = 'KEBI5870'
UPDATE c_Drug_Brand SET brand_name = 'Clexane' WHERE brand_name_rxcui = 'KEBI5877'
UPDATE c_Drug_Brand SET brand_name = 'Clexane' WHERE brand_name_rxcui = 'KEBI5879'
UPDATE c_Drug_Brand SET brand_name = 'Clexane' WHERE brand_name_rxcui = 'KEBI5880'
UPDATE c_Drug_Brand SET brand_name = 'Clindar-T' WHERE brand_name_rxcui = 'KEBI5642'
UPDATE c_Drug_Brand SET brand_name = 'Clopi-Denk' WHERE brand_name_rxcui = 'KEBI10737'
UPDATE c_Drug_Brand SET brand_name = 'Clopid ASP' WHERE brand_name_rxcui = 'KEBI8917'
UPDATE c_Drug_Brand SET brand_name = 'Co-Diovan' WHERE brand_name_rxcui = 'KEBI2814'
UPDATE c_Drug_Brand SET brand_name = 'CoAprovel' WHERE brand_name_rxcui = 'KEBI5336'
UPDATE c_Drug_Brand SET brand_name = 'CoAprovel' WHERE brand_name_rxcui = 'KEBI5428'
UPDATE c_Drug_Brand SET brand_name = 'CoAprovel' WHERE brand_name_rxcui = 'KEBI5426'
UPDATE c_Drug_Brand SET brand_name = 'Colastin-L' WHERE brand_name_rxcui = 'KEBI5478'
UPDATE c_Drug_Brand SET brand_name = 'Colestop' WHERE brand_name_rxcui = 'KEBI9552'
UPDATE c_Drug_Brand SET brand_name = 'CoLosar-Denk' WHERE brand_name_rxcui = 'KEBI10088'
UPDATE c_Drug_Brand SET brand_name = 'Combisun' WHERE brand_name_rxcui = 'KEBI12610'
UPDATE c_Drug_Brand SET brand_name = 'Concor' WHERE brand_name_rxcui = 'KEBI10203'
UPDATE c_Drug_Brand SET brand_name = 'Concor' WHERE brand_name_rxcui = 'KEBI10202'
UPDATE c_Drug_Brand SET brand_name = 'Corbis' WHERE brand_name_rxcui = 'KEBI7547'
UPDATE c_Drug_Brand SET brand_name = 'Corbis-H' WHERE brand_name_rxcui = 'KEBI7576'
UPDATE c_Drug_Brand SET brand_name = 'Corbis-H' WHERE brand_name_rxcui = 'KEBI7550'
UPDATE c_Drug_Brand SET brand_name = 'Corither' WHERE brand_name_rxcui = 'KEBI12301'
UPDATE c_Drug_Brand SET brand_name = 'Corither AB' WHERE brand_name_rxcui = 'KEBI10316'
UPDATE c_Drug_Brand SET brand_name = 'Cortec' WHERE brand_name_rxcui = 'KEBI5283'
UPDATE c_Drug_Brand SET brand_name = 'Cortec Plus' WHERE brand_name_rxcui = 'KEBI5289'
UPDATE c_Drug_Brand SET brand_name = 'Coveram' WHERE brand_name_rxcui = 'KEBI11751'
UPDATE c_Drug_Brand SET brand_name = 'Coveram' WHERE brand_name_rxcui = 'KEBI11748'
UPDATE c_Drug_Brand SET brand_name = 'Coveram' WHERE brand_name_rxcui = 'KEBI11752'
UPDATE c_Drug_Brand SET brand_name = 'Coveram' WHERE brand_name_rxcui = 'KEBI11744'
UPDATE c_Drug_Brand SET brand_name = 'Coversyl' WHERE brand_name_rxcui = 'KEBI7405'
UPDATE c_Drug_Brand SET brand_name = 'Coversyl' WHERE brand_name_rxcui = 'KEBI7402'
UPDATE c_Drug_Brand SET brand_name = 'Curam' WHERE brand_name_rxcui = 'KEBI241'
UPDATE c_Drug_Brand SET brand_name = 'Curam' WHERE brand_name_rxcui = 'KEBI267'
UPDATE c_Drug_Brand SET brand_name = 'Curam' WHERE brand_name_rxcui = 'KEBI15791'
UPDATE c_Drug_Brand SET brand_name = 'Curam' WHERE brand_name_rxcui = 'KEBI237'
UPDATE c_Drug_Brand SET brand_name = 'Curamol Plus' WHERE brand_name_rxcui = 'KEBI1493'
UPDATE c_Drug_Brand SET brand_name = 'Curaquin Syrup' WHERE brand_name_rxcui = 'KEBI743'
UPDATE c_Drug_Brand SET brand_name = 'Cyclopam-P' WHERE brand_name_rxcui = 'KEBI532'
UPDATE c_Drug_Brand SET brand_name = 'D-Artepp' WHERE brand_name_rxcui = 'KEBI58'
UPDATE c_Drug_Brand SET brand_name = 'Dalacin C' WHERE brand_name_rxcui = 'KEBI2565'
UPDATE c_Drug_Brand SET brand_name = 'Dalacin C' WHERE brand_name_rxcui = 'KEBI2567'
UPDATE c_Drug_Brand SET brand_name = 'Dalacin C' WHERE brand_name_rxcui = 'KEBI3307'
UPDATE c_Drug_Brand SET brand_name = 'Daonil' WHERE brand_name_rxcui = 'KEBI5883'
UPDATE c_Drug_Brand SET brand_name = 'Dawadoxyn' WHERE brand_name_rxcui = 'KEBI1917'
UPDATE c_Drug_Brand SET brand_name = 'Dawanol' WHERE brand_name_rxcui = 'KEBI8193'
UPDATE c_Drug_Brand SET brand_name = 'Dawasprin' WHERE brand_name_rxcui = 'KEBI8432'
UPDATE c_Drug_Brand SET brand_name = 'Dawasprin' WHERE brand_name_rxcui = 'KEBI13035'
UPDATE c_Drug_Brand SET brand_name = 'De-Spas' WHERE brand_name_rxcui = 'KEBI149'
UPDATE c_Drug_Brand SET brand_name = 'Dexpure' WHERE brand_name_rxcui = 'KEBI9583'
UPDATE c_Drug_Brand SET brand_name = 'DHC' WHERE brand_name_rxcui = 'KEBI3091'
UPDATE c_Drug_Brand SET brand_name = 'Diactin' WHERE brand_name_rxcui = 'KEBI2382'
UPDATE c_Drug_Brand SET brand_name = 'Diagluc' WHERE brand_name_rxcui = 'KEBI3475'
UPDATE c_Drug_Brand SET brand_name = 'Diamicron MR' WHERE brand_name_rxcui = 'KEBI7412'
UPDATE c_Drug_Brand SET brand_name = 'Diapride Plus' WHERE brand_name_rxcui = 'KEBI6996'
UPDATE c_Drug_Brand SET brand_name = 'Diasix' WHERE brand_name_rxcui = 'KEBI5240'
UPDATE c_Drug_Brand SET brand_name = 'Dibonis' WHERE brand_name_rxcui = 'KEBI5810'
UPDATE c_Drug_Brand SET brand_name = 'Dichlor' WHERE brand_name_rxcui = 'KEBI13296'
UPDATE c_Drug_Brand SET brand_name = 'Dichlor' WHERE brand_name_rxcui = 'KEBI13297'
UPDATE c_Drug_Brand SET brand_name = 'Digitalis' WHERE brand_name_rxcui = 'KEBI12635'
UPDATE c_Drug_Brand SET brand_name = 'Digomet' WHERE brand_name_rxcui = 'KEBI2924'
UPDATE c_Drug_Brand SET brand_name = 'Dilatrend' WHERE brand_name_rxcui = 'KEBI7116'
UPDATE c_Drug_Brand SET brand_name = 'Dilatrend' WHERE brand_name_rxcui = 'KEBI7111'
UPDATE c_Drug_Brand SET brand_name = 'Dilcontin XL' WHERE brand_name_rxcui = 'KEBI7183'
UPDATE c_Drug_Brand SET brand_name = 'Dilcontin XL' WHERE brand_name_rxcui = 'KEBI7256'
UPDATE c_Drug_Brand SET brand_name = 'Dilur' WHERE brand_name_rxcui = 'KEBI12705'
UPDATE c_Drug_Brand SET brand_name = 'Dilur' WHERE brand_name_rxcui = 'KEBI12707'
UPDATE c_Drug_Brand SET brand_name = 'Diracip-M' WHERE brand_name_rxcui = 'KEBI8661'
UPDATE c_Drug_Brand SET brand_name = 'Diracip-M' WHERE brand_name_rxcui = 'KEBI8659'
UPDATE c_Drug_Brand SET brand_name = 'Diracip-M DS' WHERE brand_name_rxcui = 'KEBI8660'
UPDATE c_Drug_Brand SET brand_name = 'Dompan OD' WHERE brand_name_rxcui = 'KEBI5191'
UPDATE c_Drug_Brand SET brand_name = 'Doxylag' WHERE brand_name_rxcui = 'KEBI11443'
UPDATE c_Drug_Brand SET brand_name = 'Duotrav' WHERE brand_name_rxcui = 'KEBI1600'
UPDATE c_Drug_Brand SET brand_name = 'Duovent HFA Metered Dose Inhaler,' WHERE brand_name_rxcui = 'KEBI2674'
UPDATE c_Drug_Brand SET brand_name = 'Eflaron' WHERE brand_name_rxcui = 'KEBI1048'
UPDATE c_Drug_Brand SET brand_name = 'Eflaron Plus' WHERE brand_name_rxcui = 'KEBI1057'
UPDATE c_Drug_Brand SET brand_name = 'Emal' WHERE brand_name_rxcui = 'KEBI4372'
UPDATE c_Drug_Brand SET brand_name = 'Ena+HCT-Denk' WHERE brand_name_rxcui = 'KEBI3143'
UPDATE c_Drug_Brand SET brand_name = 'Ena-Denk' WHERE brand_name_rxcui = 'KEBI3140'
UPDATE c_Drug_Brand SET brand_name = 'Ena-Denk' WHERE brand_name_rxcui = 'KEBI3141'
UPDATE c_Drug_Brand SET brand_name = 'Enapril' WHERE brand_name_rxcui = 'KEBI5758'
UPDATE c_Drug_Brand SET brand_name = 'Enapril-20H' WHERE brand_name_rxcui = 'KEBI5759'
UPDATE c_Drug_Brand SET brand_name = 'Enaril' WHERE brand_name_rxcui = 'KEBI2385'
UPDATE c_Drug_Brand SET brand_name = 'Enril' WHERE brand_name_rxcui = 'KEBI2584'
UPDATE c_Drug_Brand SET brand_name = 'Entasid' WHERE brand_name_rxcui = 'KEBI4311'
UPDATE c_Drug_Brand SET brand_name = 'Epnone' WHERE brand_name_rxcui = 'KEBI10378'
UPDATE c_Drug_Brand SET brand_name = 'Epnone' WHERE brand_name_rxcui = 'KEBI9704'
UPDATE c_Drug_Brand SET brand_name = 'Esofag D' WHERE brand_name_rxcui = 'KEBI14179'
UPDATE c_Drug_Brand SET brand_name = 'Esonix' WHERE brand_name_rxcui = 'KEBI13571'
UPDATE c_Drug_Brand SET brand_name = 'Esose' WHERE brand_name_rxcui = 'KEBI6289'
UPDATE c_Drug_Brand SET brand_name = 'Esose' WHERE brand_name_rxcui = 'KEBI5571'
UPDATE c_Drug_Brand SET brand_name = 'Exforge' WHERE brand_name_rxcui = 'KEBI3037'
UPDATE c_Drug_Brand SET brand_name = 'Exforge' WHERE brand_name_rxcui = 'KEBI2994'
UPDATE c_Drug_Brand SET brand_name = 'Exforge HCT' WHERE brand_name_rxcui = 'KEBI3564'
UPDATE c_Drug_Brand SET brand_name = 'Exforge HCT' WHERE brand_name_rxcui = 'KEBI3566'
UPDATE c_Drug_Brand SET brand_name = 'Extacef-DT' WHERE brand_name_rxcui = 'KEBI364'
UPDATE c_Drug_Brand SET brand_name = 'Extacef-DT' WHERE brand_name_rxcui = 'KEBI256'
UPDATE c_Drug_Brand SET brand_name = 'Ezetrol' WHERE brand_name_rxcui = 'KEBI10598'
UPDATE c_Drug_Brand SET brand_name = 'Falcimon' WHERE brand_name_rxcui = 'KEBI10850'
UPDATE c_Drug_Brand SET brand_name = 'Falcimon' WHERE brand_name_rxcui = 'KEBI10843'
UPDATE c_Drug_Brand SET brand_name = 'Fanlar' WHERE brand_name_rxcui = 'KEBI1093'
UPDATE c_Drug_Brand SET brand_name = 'Fasygin' WHERE brand_name_rxcui = 'KEBI4701'
UPDATE c_Drug_Brand SET brand_name = 'Felaxin' WHERE brand_name_rxcui = 'KEBI16185'
UPDATE c_Drug_Brand SET brand_name = 'Fimabute-DT' WHERE brand_name_rxcui = 'KEBI11013'
UPDATE c_Drug_Brand SET brand_name = 'Fixime' WHERE brand_name_rxcui = 'KEBI13761'
UPDATE c_Drug_Brand SET brand_name = 'Flagyl' WHERE brand_name_rxcui = 'KEBI5641'
UPDATE c_Drug_Brand SET brand_name = 'Flagyl' WHERE brand_name_rxcui = 'KEBI5897'
UPDATE c_Drug_Brand SET brand_name = 'Flamox' WHERE brand_name_rxcui = 'KEBI7623'
UPDATE c_Drug_Brand SET brand_name = 'Fleming' WHERE brand_name_rxcui = 'KEBI6014'
UPDATE c_Drug_Brand SET brand_name = 'Flexon' WHERE brand_name_rxcui = 'KEBI14279'
UPDATE c_Drug_Brand SET brand_name = 'Foralin' WHERE brand_name_rxcui = 'KEBI8592'
UPDATE c_Drug_Brand SET brand_name = 'Foralin' WHERE brand_name_rxcui = 'KEBI8591'
UPDATE c_Drug_Brand SET brand_name = 'Foralin' WHERE brand_name_rxcui = 'KEBI8593'
UPDATE c_Drug_Brand SET brand_name = 'Formonide' WHERE brand_name_rxcui = 'KEBI2042'
UPDATE c_Drug_Brand SET brand_name = 'Formonide' WHERE brand_name_rxcui = 'KEBI2044'
UPDATE c_Drug_Brand SET brand_name = 'Fortan-P' WHERE brand_name_rxcui = 'KEBI4166'
UPDATE c_Drug_Brand SET brand_name = 'Fortum' WHERE brand_name_rxcui = 'KEBI3057'
UPDATE c_Drug_Brand SET brand_name = 'Fortum' WHERE brand_name_rxcui = 'KEBI3064'
UPDATE c_Drug_Brand SET brand_name = 'Forxiga' WHERE brand_name_rxcui = 'KEBI11073'
UPDATE c_Drug_Brand SET brand_name = 'Forxiga' WHERE brand_name_rxcui = 'KEBI11066'
UPDATE c_Drug_Brand SET brand_name = 'Frusemide' WHERE brand_name_rxcui = 'KEBI13679'
UPDATE c_Drug_Brand SET brand_name = 'Furo-Denk' WHERE brand_name_rxcui = 'KEBI2989'
UPDATE c_Drug_Brand SET brand_name = 'Furomark' WHERE brand_name_rxcui = 'KEBI12605'
UPDATE c_Drug_Brand SET brand_name = 'Furomed' WHERE brand_name_rxcui = 'KEBI6309'
UPDATE c_Drug_Brand SET brand_name = 'Furoxiclav' WHERE brand_name_rxcui = 'KEBI15924'
UPDATE c_Drug_Brand SET brand_name = 'Fusid' WHERE brand_name_rxcui = 'KEBI2080'
UPDATE c_Drug_Brand SET brand_name = 'Fytobact' WHERE brand_name_rxcui = 'KEBI13074'
UPDATE c_Drug_Brand SET brand_name = 'G-Alfenac' WHERE brand_name_rxcui = 'KEBI441'
UPDATE c_Drug_Brand SET brand_name = 'Gacet' WHERE brand_name_rxcui = 'KEBI418'
UPDATE c_Drug_Brand SET brand_name = 'Gacet' WHERE brand_name_rxcui = 'KEBI404'
UPDATE c_Drug_Brand SET brand_name = 'Galvus' WHERE brand_name_rxcui = 'KEBI3035'
UPDATE c_Drug_Brand SET brand_name = 'Galvus Met' WHERE brand_name_rxcui = 'KEBI3056'
UPDATE c_Drug_Brand SET brand_name = 'Galvus Met' WHERE brand_name_rxcui = 'KEBI3051'
UPDATE c_Drug_Brand SET brand_name = 'Galvus Met' WHERE brand_name_rxcui = 'KEBI3055'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon Original Liquid Oral Suspension in' WHERE brand_name_rxcui = 'KEBI3004'
UPDATE c_Drug_Brand SET brand_name = 'Getryl' WHERE brand_name_rxcui = 'KEBI3318'
UPDATE c_Drug_Brand SET brand_name = 'Getryl' WHERE brand_name_rxcui = 'KEBI3319'
UPDATE c_Drug_Brand SET brand_name = 'Getryl' WHERE brand_name_rxcui = 'KEBI3321'
UPDATE c_Drug_Brand SET brand_name = 'Git' WHERE brand_name_rxcui = 'KEBI9111'
UPDATE c_Drug_Brand SET brand_name = 'Glibomet' WHERE brand_name_rxcui = 'KEBI564'
UPDATE c_Drug_Brand SET brand_name = 'Gliclaz-M' WHERE brand_name_rxcui = 'KEBI4168'
UPDATE c_Drug_Brand SET brand_name = 'Glimepiride Denk' WHERE brand_name_rxcui = 'KEBI3009'
UPDATE c_Drug_Brand SET brand_name = 'Glimepiride Denk' WHERE brand_name_rxcui = 'KEBI3023'
UPDATE c_Drug_Brand SET brand_name = 'Glinther' WHERE brand_name_rxcui = 'KEBI144'
UPDATE c_Drug_Brand SET brand_name = 'GlipiSTIN' WHERE brand_name_rxcui = 'KEBI2670'
UPDATE c_Drug_Brand SET brand_name = 'GlucoMET' WHERE brand_name_rxcui = 'KEBI3276'
UPDATE c_Drug_Brand SET brand_name = 'GlucoMET' WHERE brand_name_rxcui = 'KEBI4497'
UPDATE c_Drug_Brand SET brand_name = 'GlucoMET XR' WHERE brand_name_rxcui = 'KEBI10529'
UPDATE c_Drug_Brand SET brand_name = 'GlucoMET XR' WHERE brand_name_rxcui = 'KEBI4535'
UPDATE c_Drug_Brand SET brand_name = 'GlucoMET XR' WHERE brand_name_rxcui = 'KEBI13625'
UPDATE c_Drug_Brand SET brand_name = 'GlucoPHAGE XR' WHERE brand_name_rxcui = 'KEBI10484'
UPDATE c_Drug_Brand SET brand_name = 'GlucoPHAGE XR' WHERE brand_name_rxcui = 'KEBI10485'
UPDATE c_Drug_Brand SET brand_name = 'Glucotim' WHERE brand_name_rxcui = 'KEBI1190'
UPDATE c_Drug_Brand SET brand_name = 'GlucoVANCE' WHERE brand_name_rxcui = 'KEBI10486'
UPDATE c_Drug_Brand SET brand_name = 'GlucoVANCE' WHERE brand_name_rxcui = 'KEBI10487'
UPDATE c_Drug_Brand SET brand_name = 'GlucoVANCE' WHERE brand_name_rxcui = 'KEBI10488'
UPDATE c_Drug_Brand SET brand_name = 'Glurenor' WHERE brand_name_rxcui = 'KEBI590'
UPDATE c_Drug_Brand SET brand_name = 'Glycinorm MR' WHERE brand_name_rxcui = 'KEBI673'
UPDATE c_Drug_Brand SET brand_name = 'Gramocef-O' WHERE brand_name_rxcui = 'KEBI6948'
UPDATE c_Drug_Brand SET brand_name = 'Gvither Forte' WHERE brand_name_rxcui = 'KEBI444'
UPDATE c_Drug_Brand SET brand_name = 'Hedapan' WHERE brand_name_rxcui = 'KEBI3505'
UPDATE c_Drug_Brand SET brand_name = 'Hedex' WHERE brand_name_rxcui = 'KEBI2728'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' WHERE brand_name_rxcui = 'KEBI1148'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' WHERE brand_name_rxcui = 'KEBI1202'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG Mix-25' WHERE brand_name_rxcui = 'KEBI1207'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG Mix-25' WHERE brand_name_rxcui = 'KEBI1211'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG Mix-50' WHERE brand_name_rxcui = 'KEBI1213'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN' WHERE brand_name_rxcui = 'KEBI1217'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN N' WHERE brand_name_rxcui = 'KEBI1239'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN N' WHERE brand_name_rxcui = 'KEBI1235'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN N' WHERE brand_name_rxcui = 'KEBI1239-4ML'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN R' WHERE brand_name_rxcui = 'KEBI1246'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN R' WHERE brand_name_rxcui = 'KEBI1241'
UPDATE c_Drug_Brand SET brand_name = 'HumuLIN R' WHERE brand_name_rxcui = 'KEBI1246-4ML'
UPDATE c_Drug_Brand SET brand_name = 'Hymet' WHERE brand_name_rxcui = 'KEBI13349'
UPDATE c_Drug_Brand SET brand_name = 'Hyspar' WHERE brand_name_rxcui = 'KEBI1150'
UPDATE c_Drug_Brand SET brand_name = 'Ibuprofen Denk' WHERE brand_name_rxcui = 'KEBI10890'
UPDATE c_Drug_Brand SET brand_name = 'Indowin' WHERE brand_name_rxcui = 'KEBI6359'
UPDATE c_Drug_Brand SET brand_name = 'Induric' WHERE brand_name_rxcui = 'KEBI10516'
UPDATE c_Drug_Brand SET brand_name = 'Induric SR' WHERE brand_name_rxcui = 'KEBI11606'
UPDATE c_Drug_Brand SET brand_name = 'Inegy' WHERE brand_name_rxcui = 'KEBI11582'
UPDATE c_Drug_Brand SET brand_name = 'Inegy' WHERE brand_name_rxcui = 'KEBI11585'
UPDATE c_Drug_Brand SET brand_name = 'Inegy' WHERE brand_name_rxcui = 'KEBI11586'
UPDATE c_Drug_Brand SET brand_name = 'Injlin' WHERE brand_name_rxcui = 'KEBI12379'
UPDATE c_Drug_Brand SET brand_name = 'Inosita Plus' WHERE brand_name_rxcui = 'KEBI11139'
UPDATE c_Drug_Brand SET brand_name = 'Inoxime' WHERE brand_name_rxcui = 'KEBI10243'
UPDATE c_Drug_Brand SET brand_name = 'InSULAtard' WHERE brand_name_rxcui = 'KEBI217'
UPDATE c_Drug_Brand SET brand_name = 'InSULAtard FlexPen' WHERE brand_name_rxcui = 'KEBI229Pen'
UPDATE c_Drug_Brand SET brand_name = 'InSULAtard Penfill' WHERE brand_name_rxcui = 'KEBI229'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan basal' WHERE brand_name_rxcui = 'KEBI5907Vial'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan basal' WHERE brand_name_rxcui = 'KEBI5907'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan Rapid' WHERE brand_name_rxcui = 'KEBI10907'
UPDATE c_Drug_Brand SET brand_name = 'INTRAcef' WHERE brand_name_rxcui = 'KEBI5399'
UPDATE c_Drug_Brand SET brand_name = 'Isoptin' WHERE brand_name_rxcui = 'KEBI5308'
UPDATE c_Drug_Brand SET brand_name = 'Itoprid' WHERE brand_name_rxcui = 'KEBI10528'
UPDATE c_Drug_Brand SET brand_name = 'Ivyzoxan' WHERE brand_name_rxcui = 'KEBI2490'
UPDATE c_Drug_Brand SET brand_name = 'Janumet' WHERE brand_name_rxcui = 'KEBI9539'
UPDATE c_Drug_Brand SET brand_name = 'Janumet' WHERE brand_name_rxcui = 'KEBI9535'
UPDATE c_Drug_Brand SET brand_name = 'Junior Sonadol' WHERE brand_name_rxcui = 'KEBI929'
UPDATE c_Drug_Brand SET brand_name = 'Kemoxyl DT' WHERE brand_name_rxcui = 'KEBI12275'
UPDATE c_Drug_Brand SET brand_name = 'Ketolac' WHERE brand_name_rxcui = 'KEBI5970'
UPDATE c_Drug_Brand SET brand_name = 'Klenzit' WHERE brand_name_rxcui = 'KEBI6493'
UPDATE c_Drug_Brand SET brand_name = 'Kombiglyze' WHERE brand_name_rxcui = 'KEBI7696'
UPDATE c_Drug_Brand SET brand_name = 'Komefan' WHERE brand_name_rxcui = 'KEBI12059'
UPDATE c_Drug_Brand SET brand_name = 'Komefan' WHERE brand_name_rxcui = 'KEBI12060'
UPDATE c_Drug_Brand SET brand_name = 'Labclor' WHERE brand_name_rxcui = 'KEBI4217'
UPDATE c_Drug_Brand SET brand_name = 'Labnir' WHERE brand_name_rxcui = 'KEBI15491'
UPDATE c_Drug_Brand SET brand_name = 'Labnir' WHERE brand_name_rxcui = 'KEBI15506'
UPDATE c_Drug_Brand SET brand_name = 'Lacillin' WHERE brand_name_rxcui = 'KEBI4350'
UPDATE c_Drug_Brand SET brand_name = 'Lacillin' WHERE brand_name_rxcui = 'KEBI4385'
UPDATE c_Drug_Brand SET brand_name = 'Lactone' WHERE brand_name_rxcui = 'KEBI6898'
UPDATE c_Drug_Brand SET brand_name = 'Lactor' WHERE brand_name_rxcui = 'KEBI13123'
UPDATE c_Drug_Brand SET brand_name = 'Lanoxin' WHERE brand_name_rxcui = 'KEBI3129'
UPDATE c_Drug_Brand SET brand_name = 'Lanoxin' WHERE brand_name_rxcui = 'KEBI3131'
UPDATE c_Drug_Brand SET brand_name = 'Lanoxin' WHERE brand_name_rxcui = 'KEBI3130'
UPDATE c_Drug_Brand SET brand_name = 'Lantus' WHERE brand_name_rxcui = 'KEBI5912'
UPDATE c_Drug_Brand SET brand_name = 'Lantus Insulin' WHERE brand_name_rxcui = 'KEBI5916'
UPDATE c_Drug_Brand SET brand_name = 'Lantus Solostar' WHERE brand_name_rxcui = 'KEBI5916Pen'
UPDATE c_Drug_Brand SET brand_name = 'Lanzol DT Junior' WHERE brand_name_rxcui = 'KEBI8684'
UPDATE c_Drug_Brand SET brand_name = 'Larinate' WHERE brand_name_rxcui = 'KEBI10218'
UPDATE c_Drug_Brand SET brand_name = 'Lasix' WHERE brand_name_rxcui = 'KEBI5459'
UPDATE c_Drug_Brand SET brand_name = 'Lastmol' WHERE brand_name_rxcui = 'KEBI4419'
UPDATE c_Drug_Brand SET brand_name = 'Lercapil' WHERE brand_name_rxcui = 'KEBI13116'
UPDATE c_Drug_Brand SET brand_name = 'Lercapil' WHERE brand_name_rxcui = 'KEBI12630'
UPDATE c_Drug_Brand SET brand_name = 'Levaform Respules' WHERE brand_name_rxcui = 'KEBI8645'
UPDATE c_Drug_Brand SET brand_name = 'Levemir' WHERE brand_name_rxcui = 'KEBI297Vial'
UPDATE c_Drug_Brand SET brand_name = 'Levemir FlexPen' WHERE brand_name_rxcui = 'KEBI297Pen'
UPDATE c_Drug_Brand SET brand_name = 'Levemir Penfill' WHERE brand_name_rxcui = 'KEBI297'
UPDATE c_Drug_Brand SET brand_name = 'Levo-Denk' WHERE brand_name_rxcui = 'KEBI11911'
UPDATE c_Drug_Brand SET brand_name = 'Levo-OZ' WHERE brand_name_rxcui = 'KEBI10614'
UPDATE c_Drug_Brand SET brand_name = 'Levostar' WHERE brand_name_rxcui = 'KEBI2096'
UPDATE c_Drug_Brand SET brand_name = 'Levotop' WHERE brand_name_rxcui = 'KEBI13784'
UPDATE c_Drug_Brand SET brand_name = 'Levotop-PF' WHERE brand_name_rxcui = 'KEBI13778'
UPDATE c_Drug_Brand SET brand_name = 'Lioton' WHERE brand_name_rxcui = 'KEBI601'
UPDATE c_Drug_Brand SET brand_name = 'Lipiget' WHERE brand_name_rxcui = 'KEBI3339'
UPDATE c_Drug_Brand SET brand_name = 'Lisace' WHERE brand_name_rxcui = 'KEBI4635'
UPDATE c_Drug_Brand SET brand_name = 'Lisace' WHERE brand_name_rxcui = 'KEBI5819'
UPDATE c_Drug_Brand SET brand_name = 'Lofnac P' WHERE brand_name_rxcui = 'KEBI452'
UPDATE c_Drug_Brand SET brand_name = 'Lofral' WHERE brand_name_rxcui = 'KEBI2316'
UPDATE c_Drug_Brand SET brand_name = 'Lofral' WHERE brand_name_rxcui = 'KEBI2353'
UPDATE c_Drug_Brand SET brand_name = 'Logimax' WHERE brand_name_rxcui = 'KEBI7701'
UPDATE c_Drug_Brand SET brand_name = 'Lonet' WHERE brand_name_rxcui = 'KEBI2394'
UPDATE c_Drug_Brand SET brand_name = 'Lornex Forte' WHERE brand_name_rxcui = 'KEBI11641'
UPDATE c_Drug_Brand SET brand_name = 'Lornex Plus' WHERE brand_name_rxcui = 'KEBI11642'
UPDATE c_Drug_Brand SET brand_name = 'Losar-Denk' WHERE brand_name_rxcui = 'KEBI9602'
UPDATE c_Drug_Brand SET brand_name = 'Losar-Denk' WHERE brand_name_rxcui = 'KEBI10089'
UPDATE c_Drug_Brand SET brand_name = 'Losec MUPS' WHERE brand_name_rxcui = 'KEBI7705'
UPDATE c_Drug_Brand SET brand_name = 'Losec MUPS' WHERE brand_name_rxcui = 'KEBI7706'
UPDATE c_Drug_Brand SET brand_name = 'Loxiam Plus' WHERE brand_name_rxcui = 'KEBI9672'
UPDATE c_Drug_Brand SET brand_name = 'Lum-Artem' WHERE brand_name_rxcui = 'KEBI1177'
UPDATE c_Drug_Brand SET brand_name = 'Malacide' WHERE brand_name_rxcui = 'KEBI2253'
UPDATE c_Drug_Brand SET brand_name = 'Malgo' WHERE brand_name_rxcui = 'KEBI1301'
UPDATE c_Drug_Brand SET brand_name = 'Malodar' WHERE brand_name_rxcui = 'KEBI2253R'
UPDATE c_Drug_Brand SET brand_name = 'Mazit' WHERE brand_name_rxcui = 'KEBI7936'
UPDATE c_Drug_Brand SET brand_name = 'Medisart' WHERE brand_name_rxcui = 'KEBI12494'
UPDATE c_Drug_Brand SET brand_name = 'Medomox DT' WHERE brand_name_rxcui = 'KEBI8133'
UPDATE c_Drug_Brand SET brand_name = 'Medopress' WHERE brand_name_rxcui = 'KEBI6057'
UPDATE c_Drug_Brand SET brand_name = 'Mefpar' WHERE brand_name_rxcui = 'KEBI1391'
UPDATE c_Drug_Brand SET brand_name = 'Mefsun' WHERE brand_name_rxcui = 'KEBI12612'
UPDATE c_Drug_Brand SET brand_name = 'Meftal-Forte' WHERE brand_name_rxcui = 'KEBI274'
UPDATE c_Drug_Brand SET brand_name = 'Meftal-P' WHERE brand_name_rxcui = 'KEBI243'
UPDATE c_Drug_Brand SET brand_name = 'Meftal-Spas' WHERE brand_name_rxcui = 'KEBI358'
UPDATE c_Drug_Brand SET brand_name = 'Melonac' WHERE brand_name_rxcui = 'KEBI7501'
UPDATE c_Drug_Brand SET brand_name = 'Melonac' WHERE brand_name_rxcui = 'KEBI8280'
UPDATE c_Drug_Brand SET brand_name = 'Met XL' WHERE brand_name_rxcui = 'KEBI1279'
UPDATE c_Drug_Brand SET brand_name = 'Metformin Denk' WHERE brand_name_rxcui = 'KEBI9606'
UPDATE c_Drug_Brand SET brand_name = 'Metformin Denk' WHERE brand_name_rxcui = 'KEBI3085'
UPDATE c_Drug_Brand SET brand_name = 'Metformin Denk' WHERE brand_name_rxcui = 'KEBI10767'
UPDATE c_Drug_Brand SET brand_name = 'Metoz' WHERE brand_name_rxcui = 'KEBI1365'
UPDATE c_Drug_Brand SET brand_name = 'Metoz' WHERE brand_name_rxcui = 'KEBI1366'
UPDATE c_Drug_Brand SET brand_name = 'Metpure -XL' WHERE brand_name_rxcui = 'KEBI7960'
UPDATE c_Drug_Brand SET brand_name = 'Metpure -XL' WHERE brand_name_rxcui = 'KEBI7961'
UPDATE c_Drug_Brand SET brand_name = 'Metrozol' WHERE brand_name_rxcui = 'KEBI6253'
UPDATE c_Drug_Brand SET brand_name = 'Metrozol' WHERE brand_name_rxcui = 'KEBI6239'
UPDATE c_Drug_Brand SET brand_name = 'Mexic' WHERE brand_name_rxcui = 'KEBI2628'
UPDATE c_Drug_Brand SET brand_name = 'Mexic' WHERE brand_name_rxcui = 'KEBI2626'
UPDATE c_Drug_Brand SET brand_name = 'Minoxin' WHERE brand_name_rxcui = 'KEBI6517'
UPDATE c_Drug_Brand SET brand_name = 'MIXTArd-30 FlexPen' WHERE brand_name_rxcui = 'KEBI281Pen'
UPDATE c_Drug_Brand SET brand_name = 'MIXTArd-30 Penfill' WHERE brand_name_rxcui = 'KEBI281'
UPDATE c_Drug_Brand SET brand_name = 'Mobic' WHERE brand_name_rxcui = 'KEBI1133'
UPDATE c_Drug_Brand SET brand_name = 'Mono-Tildiem SR' WHERE brand_name_rxcui = 'KEBI5480'
UPDATE c_Drug_Brand SET brand_name = 'Mono-Tildiem SR' WHERE brand_name_rxcui = 'KEBI5477'
UPDATE c_Drug_Brand SET brand_name = 'Moxacil' WHERE brand_name_rxcui = 'KEBI1404'
UPDATE c_Drug_Brand SET brand_name = 'Moxacil DS' WHERE brand_name_rxcui = 'KEBI1402'
UPDATE c_Drug_Brand SET brand_name = 'Natrilix SR' WHERE brand_name_rxcui = 'KEBI7414'
UPDATE c_Drug_Brand SET brand_name = 'Natrixam' WHERE brand_name_rxcui = 'KEBI12068'
UPDATE c_Drug_Brand SET brand_name = 'Natrixam' WHERE brand_name_rxcui = 'KEBI12069'
UPDATE c_Drug_Brand SET brand_name = 'Naxpar APC' WHERE brand_name_rxcui = 'KEBI12488'
UPDATE c_Drug_Brand SET brand_name = 'Nebilet Plus' WHERE brand_name_rxcui = 'KEBI10776'
UPDATE c_Drug_Brand SET brand_name = 'Nebilet Plus' WHERE brand_name_rxcui = 'KEBI10780'
UPDATE c_Drug_Brand SET brand_name = 'Nesmox' WHERE brand_name_rxcui = 'KEBI11484'
UPDATE c_Drug_Brand SET brand_name = 'NexIUM' WHERE brand_name_rxcui = 'KEBI7719'
UPDATE c_Drug_Brand SET brand_name = 'NexIUM' WHERE brand_name_rxcui = 'KEBI7721'
UPDATE c_Drug_Brand SET brand_name = 'Nifedi-Denk' WHERE brand_name_rxcui = 'KEBI4102'
UPDATE c_Drug_Brand SET brand_name = 'Nifedi-Denk' WHERE brand_name_rxcui = 'KEBI3979'
UPDATE c_Drug_Brand SET brand_name = 'Nilol' WHERE brand_name_rxcui = 'KEBI5858'
UPDATE c_Drug_Brand SET brand_name = 'Niredil' WHERE brand_name_rxcui = 'KEBI14086'
UPDATE c_Drug_Brand SET brand_name = 'Niredil' WHERE brand_name_rxcui = 'KEBI14087'
UPDATE c_Drug_Brand SET brand_name = 'Niredil' WHERE brand_name_rxcui = 'KEBI14085'
UPDATE c_Drug_Brand SET brand_name = 'Nitrocontin' WHERE brand_name_rxcui = 'KEBI7264'
UPDATE c_Drug_Brand SET brand_name = 'Nitrocontin' WHERE brand_name_rxcui = 'KEBI7265'
UPDATE c_Drug_Brand SET brand_name = 'Nodon' WHERE brand_name_rxcui = 'KEBI13071'
UPDATE c_Drug_Brand SET brand_name = 'Norplat-S' WHERE brand_name_rxcui = 'KEBI3347'
UPDATE c_Drug_Brand SET brand_name = 'Nortiz' WHERE brand_name_rxcui = 'KEBI201'
UPDATE c_Drug_Brand SET brand_name = 'Norzole' WHERE brand_name_rxcui = 'KEBI5229'
UPDATE c_Drug_Brand SET brand_name = 'NovoMIX-30 FlexPen' WHERE brand_name_rxcui = 'KEBI283Pen'
UPDATE c_Drug_Brand SET brand_name = 'NovoMIX-30 Penfill' WHERE brand_name_rxcui = 'KEBI283'
UPDATE c_Drug_Brand SET brand_name = 'NovoNorm' WHERE brand_name_rxcui = 'KEBI299'
UPDATE c_Drug_Brand SET brand_name = 'NovoNorm' WHERE brand_name_rxcui = 'KEBI301'
UPDATE c_Drug_Brand SET brand_name = 'NovoNorm' WHERE brand_name_rxcui = 'KEBI304'
UPDATE c_Drug_Brand SET brand_name = 'NovoRAPID' WHERE brand_name_rxcui = 'KEBI289Vial'
UPDATE c_Drug_Brand SET brand_name = 'NovoRAPID FlexPen' WHERE brand_name_rxcui = 'KEBI289Pen'
UPDATE c_Drug_Brand SET brand_name = 'NovoRAPID Penfill' WHERE brand_name_rxcui = 'KEBI289'
UPDATE c_Drug_Brand SET brand_name = 'Nurofen' WHERE brand_name_rxcui = 'KEBI16472'
UPDATE c_Drug_Brand SET brand_name = 'Nurofen' WHERE brand_name_rxcui = 'KEBI122'
UPDATE c_Drug_Brand SET brand_name = 'Nurofen Migraine Pain' WHERE brand_name_rxcui = 'KEBI16475'
UPDATE c_Drug_Brand SET brand_name = 'Olme' WHERE brand_name_rxcui = 'KEBI13150'
UPDATE c_Drug_Brand SET brand_name = 'Olme' WHERE brand_name_rxcui = 'KEBI13149'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar' WHERE brand_name_rxcui = 'KEBI10822'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar' WHERE brand_name_rxcui = 'KEBI10823'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar H' WHERE brand_name_rxcui = 'KEBI10827'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar H' WHERE brand_name_rxcui = 'KEBI10828'
UPDATE c_Drug_Brand SET brand_name = 'Omizec' WHERE brand_name_rxcui = 'KEBI6432'
UPDATE c_Drug_Brand SET brand_name = 'ONEcef SB' WHERE brand_name_rxcui = 'KEBI11724'
UPDATE c_Drug_Brand SET brand_name = 'ORAcef' WHERE brand_name_rxcui = 'KEBI1420'
UPDATE c_Drug_Brand SET brand_name = 'ORAcef' WHERE brand_name_rxcui = 'KEBI1422'
UPDATE c_Drug_Brand SET brand_name = 'ORAcef' WHERE brand_name_rxcui = 'KEBI1414'
UPDATE c_Drug_Brand SET brand_name = 'ORAcef' WHERE brand_name_rxcui = 'KEBI1418'
UPDATE c_Drug_Brand SET brand_name = 'Orelox' WHERE brand_name_rxcui = 'KEBI5696'
UPDATE c_Drug_Brand SET brand_name = 'Orelox' WHERE brand_name_rxcui = 'KEBI7242'
UPDATE c_Drug_Brand SET brand_name = 'Orelox' WHERE brand_name_rxcui = 'KEBI5698'
UPDATE c_Drug_Brand SET brand_name = 'Oxifast P' WHERE brand_name_rxcui = 'KEBI12012'
UPDATE c_Drug_Brand SET brand_name = 'Oxipod' WHERE brand_name_rxcui = 'KEBI646'
UPDATE c_Drug_Brand SET brand_name = 'P-Alaxin' WHERE brand_name_rxcui = 'KEBI449'
UPDATE c_Drug_Brand SET brand_name = 'P-Alaxin' WHERE brand_name_rxcui = 'KEBI342'
UPDATE c_Drug_Brand SET brand_name = 'Painact' WHERE brand_name_rxcui = 'KEBI13634'
UPDATE c_Drug_Brand SET brand_name = 'Pan IV' WHERE brand_name_rxcui = 'KEBI5603'
UPDATE c_Drug_Brand SET brand_name = 'Panadol Actifast' WHERE brand_name_rxcui = 'KEBI4005'
UPDATE c_Drug_Brand SET brand_name = 'Panadol Baby & Infant' WHERE brand_name_rxcui = 'KEBI4110'
UPDATE c_Drug_Brand SET brand_name = 'Panadol Elixir' WHERE brand_name_rxcui = 'KEBI432'
UPDATE c_Drug_Brand SET brand_name = 'Panadol Extra' WHERE brand_name_rxcui = 'KEBI4376'
UPDATE c_Drug_Brand SET brand_name = 'Panpure' WHERE brand_name_rxcui = 'KEBI10334'
UPDATE c_Drug_Brand SET brand_name = 'Panpure' WHERE brand_name_rxcui = 'KEBI7998'
UPDATE c_Drug_Brand SET brand_name = 'Pantocid' WHERE brand_name_rxcui = 'KEBI7590'
UPDATE c_Drug_Brand SET brand_name = 'Pantocid' WHERE brand_name_rxcui = 'KEBI7591'
UPDATE c_Drug_Brand SET brand_name = 'Pantocid-D' WHERE brand_name_rxcui = 'KEBI7594'
UPDATE c_Drug_Brand SET brand_name = 'Pantoloc' WHERE brand_name_rxcui = 'KEBI5358'
UPDATE c_Drug_Brand SET brand_name = 'Pantoloc' WHERE brand_name_rxcui = 'KEBI5361'
UPDATE c_Drug_Brand SET brand_name = 'Para-Denk' WHERE brand_name_rxcui = 'KEBI4095'
UPDATE c_Drug_Brand SET brand_name = 'Para-Denk' WHERE brand_name_rxcui = 'KEBI4081'
UPDATE c_Drug_Brand SET brand_name = 'ParaCo-Denk' WHERE brand_name_rxcui = 'KEBI11610'
UPDATE c_Drug_Brand SET brand_name = 'Parafast ET' WHERE brand_name_rxcui = 'KEBI10644'
UPDATE c_Drug_Brand SET brand_name = 'Paraflam' WHERE brand_name_rxcui = 'KEBI6026'
UPDATE c_Drug_Brand SET brand_name = 'Parcoten' WHERE brand_name_rxcui = 'KEBI7304'
UPDATE c_Drug_Brand SET brand_name = 'Pariet' WHERE brand_name_rxcui = 'KEBI7481'
UPDATE c_Drug_Brand SET brand_name = 'Pariet' WHERE brand_name_rxcui = 'KEBI7483'
UPDATE c_Drug_Brand SET brand_name = 'Penamox' WHERE brand_name_rxcui = 'KEBI3332'
UPDATE c_Drug_Brand SET brand_name = 'Penamox' WHERE brand_name_rxcui = 'KEBI3333'
UPDATE c_Drug_Brand SET brand_name = 'Penamox' WHERE brand_name_rxcui = 'KEBI3328'
UPDATE c_Drug_Brand SET brand_name = 'Penamox' WHERE brand_name_rxcui = 'KEBI3329'
UPDATE c_Drug_Brand SET brand_name = 'Pentalink - D' WHERE brand_name_rxcui = 'KEBI5232'
UPDATE c_Drug_Brand SET brand_name = 'Pioday' WHERE brand_name_rxcui = 'KEBI2673'
UPDATE c_Drug_Brand SET brand_name = 'Pioday' WHERE brand_name_rxcui = 'KEBI2677'
UPDATE c_Drug_Brand SET brand_name = 'Pioday M' WHERE brand_name_rxcui = 'KEBI2680'
UPDATE c_Drug_Brand SET brand_name = 'Plendil' WHERE brand_name_rxcui = 'KEBI7724'
UPDATE c_Drug_Brand SET brand_name = 'Plendil' WHERE brand_name_rxcui = 'KEBI7725'
UPDATE c_Drug_Brand SET brand_name = 'Ponstan Forte' WHERE brand_name_rxcui = 'KEBI2974'
UPDATE c_Drug_Brand SET brand_name = 'POWERcef' WHERE brand_name_rxcui = 'KEBI3234'
UPDATE c_Drug_Brand SET brand_name = 'Powerdol Plus' WHERE brand_name_rxcui = 'KEBI11297'
UPDATE c_Drug_Brand SET brand_name = 'Prasu' WHERE brand_name_rxcui = 'KEBI11717'
UPDATE c_Drug_Brand SET brand_name = 'Prasusafe' WHERE brand_name_rxcui = 'KEBI522'
UPDATE c_Drug_Brand SET brand_name = 'Prasusafe' WHERE brand_name_rxcui = 'KEBI9706'
UPDATE c_Drug_Brand SET brand_name = 'Proceptin' WHERE brand_name_rxcui = 'KEBI2458'
UPDATE c_Drug_Brand SET brand_name = 'Proguanil-BP' WHERE brand_name_rxcui = 'KEBI4738'
UPDATE c_Drug_Brand SET brand_name = 'Proximexa' WHERE brand_name_rxcui = 'KEBI5130'
UPDATE c_Drug_Brand SET brand_name = 'Pyramax' WHERE brand_name_rxcui = 'KEBI13066'
UPDATE c_Drug_Brand SET brand_name = 'Quimed' WHERE brand_name_rxcui = 'KEBI6884'
UPDATE c_Drug_Brand SET brand_name = 'Quinaquin Mixture' WHERE brand_name_rxcui = 'KEBI3583'
UPDATE c_Drug_Brand SET brand_name = 'Quinas' WHERE brand_name_rxcui = 'KEBI276'
UPDATE c_Drug_Brand SET brand_name = 'Quinidil' WHERE brand_name_rxcui = 'KEBI4030'
UPDATE c_Drug_Brand SET brand_name = 'quiNINE Mixture' WHERE brand_name_rxcui = 'KEBI4721'
UPDATE c_Drug_Brand SET brand_name = 'Rabtune-D' WHERE brand_name_rxcui = 'KEBI10420'
UPDATE c_Drug_Brand SET brand_name = 'Ramizid' WHERE brand_name_rxcui = 'KEBI14876'
UPDATE c_Drug_Brand SET brand_name = 'Ramizid' WHERE brand_name_rxcui = 'KEBI11351'
UPDATE c_Drug_Brand SET brand_name = 'Rapiclav' WHERE brand_name_rxcui = 'KEBI13712'
UPDATE c_Drug_Brand SET brand_name = 'RAZ' WHERE brand_name_rxcui = 'KEBI11031'
UPDATE c_Drug_Brand SET brand_name = 'Relvar Ellipta' WHERE brand_name_rxcui = 'KEBI10555'
UPDATE c_Drug_Brand SET brand_name = 'Relvar Ellipta' WHERE brand_name_rxcui = 'KEBI10556'
UPDATE c_Drug_Brand SET brand_name = 'Revelol XL' WHERE brand_name_rxcui = 'KEBI637'
UPDATE c_Drug_Brand SET brand_name = 'Revelol XL' WHERE brand_name_rxcui = 'KEBI639'
UPDATE c_Drug_Brand SET brand_name = 'Risek' WHERE brand_name_rxcui = 'KEBI3349'
UPDATE c_Drug_Brand SET brand_name = 'Risek' WHERE brand_name_rxcui = 'KEBI3351'
UPDATE c_Drug_Brand SET brand_name = 'Risek' WHERE brand_name_rxcui = 'KEBI3350'
UPDATE c_Drug_Brand SET brand_name = 'Risek Insta' WHERE brand_name_rxcui = 'KEBI9721'
UPDATE c_Drug_Brand SET brand_name = 'Risek Insta' WHERE brand_name_rxcui = 'KEBI9720'
UPDATE c_Drug_Brand SET brand_name = 'Rito SR' WHERE brand_name_rxcui = 'KEBI13672'
UPDATE c_Drug_Brand SET brand_name = 'Rivaxime' WHERE brand_name_rxcui = 'KEBI11129'
UPDATE c_Drug_Brand SET brand_name = 'Robi-D' WHERE brand_name_rxcui = 'KEBI11597'
UPDATE c_Drug_Brand SET brand_name = 'Rocephin' WHERE brand_name_rxcui = 'KEBI7808'
UPDATE c_Drug_Brand SET brand_name = 'Rocephin' WHERE brand_name_rxcui = 'KEBI7807'
UPDATE c_Drug_Brand SET brand_name = 'Rocephin' WHERE brand_name_rxcui = 'KEBI7809'
UPDATE c_Drug_Brand SET brand_name = 'Rocephin' WHERE brand_name_rxcui = 'KEBI7806'
UPDATE c_Drug_Brand SET brand_name = 'Rocephin' WHERE brand_name_rxcui = 'KEBI7805'
UPDATE c_Drug_Brand SET brand_name = 'Rolac' WHERE brand_name_rxcui = 'KEBI5255'
UPDATE c_Drug_Brand SET brand_name = 'Rolac' WHERE brand_name_rxcui = 'KEBI1245'
UPDATE c_Drug_Brand SET brand_name = 'Rolac' WHERE brand_name_rxcui = 'KEBI1247'
UPDATE c_Drug_Brand SET brand_name = 'Rovista' WHERE brand_name_rxcui = 'KEBI3353'
UPDATE c_Drug_Brand SET brand_name = 'Rovista' WHERE brand_name_rxcui = 'KEBI3354'
UPDATE c_Drug_Brand SET brand_name = 'Rovista' WHERE brand_name_rxcui = 'KEBI3352'
UPDATE c_Drug_Brand SET brand_name = 'Roxicam' WHERE brand_name_rxcui = 'KEBI10362'
UPDATE c_Drug_Brand SET brand_name = 'S-Amlosafe' WHERE brand_name_rxcui = 'KEBI14277'
UPDATE c_Drug_Brand SET brand_name = 'S-Amlosafe' WHERE brand_name_rxcui = 'KEBI14278'
UPDATE c_Drug_Brand SET brand_name = 'S-Quin' WHERE brand_name_rxcui = 'KEBI8302'
UPDATE c_Drug_Brand SET brand_name = 'Sabulin' WHERE brand_name_rxcui = 'KEBI1431'
UPDATE c_Drug_Brand SET brand_name = 'Sanmol' WHERE brand_name_rxcui = 'KEBI12560'
UPDATE c_Drug_Brand SET brand_name = 'Sanmol' WHERE brand_name_rxcui = 'KEBI12561'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Accuhaler/ Diskus' WHERE brand_name_rxcui = 'KEBI3509'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Accuhaler/ Diskus' WHERE brand_name_rxcui = 'KEBI3496'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Accuhaler/ Diskus' WHERE brand_name_rxcui = 'KEBI3488'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Evohaler' WHERE brand_name_rxcui = 'KEBI3504'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Evohaler' WHERE brand_name_rxcui = 'KEBI3506'
UPDATE c_Drug_Brand SET brand_name = 'Seretide Evohaler' WHERE brand_name_rxcui = 'KEBI3501'
UPDATE c_Drug_Brand SET brand_name = 'Serviflox' WHERE brand_name_rxcui = 'KEBI9548'
UPDATE c_Drug_Brand SET brand_name = 'Sodamint' WHERE brand_name_rxcui = 'KEBI4895'
UPDATE c_Drug_Brand SET brand_name = 'Sompraz IT' WHERE brand_name_rxcui = 'KEBI7642'
UPDATE c_Drug_Brand SET brand_name = 'Sona Moja' WHERE brand_name_rxcui = 'KEBI995'
UPDATE c_Drug_Brand SET brand_name = 'Sonadol Extra' WHERE brand_name_rxcui = 'KEBI993'
UPDATE c_Drug_Brand SET brand_name = 'Spirolon' WHERE brand_name_rxcui = 'KEBI4638'
UPDATE c_Drug_Brand SET brand_name = 'Starval' WHERE brand_name_rxcui = 'KEBI2613'
UPDATE c_Drug_Brand SET brand_name = 'Starval' WHERE brand_name_rxcui = 'KEBI2640'
UPDATE c_Drug_Brand SET brand_name = 'Steriject Hydralazine' WHERE brand_name_rxcui = 'KEBI10027'
UPDATE c_Drug_Brand SET brand_name = 'Strirab-D' WHERE brand_name_rxcui = 'KEBI13580'
UPDATE c_Drug_Brand SET brand_name = 'Strom P' WHERE brand_name_rxcui = 'KEBI5235'
UPDATE c_Drug_Brand SET brand_name = 'Strom SR' WHERE brand_name_rxcui = 'KEBI5233'
UPDATE c_Drug_Brand SET brand_name = 'Sulbacin' WHERE brand_name_rxcui = 'KEBI13529'
UPDATE c_Drug_Brand SET brand_name = 'Suprapen' WHERE brand_name_rxcui = 'KEBI3517'
UPDATE c_Drug_Brand SET brand_name = 'Suprapen Syrup' WHERE brand_name_rxcui = 'KEBI3518'
UPDATE c_Drug_Brand SET brand_name = 'Symbicort' WHERE brand_name_rxcui = 'KEBI7758-120'
UPDATE c_Drug_Brand SET brand_name = 'Symbicort' WHERE brand_name_rxcui = 'KEBI7758-60'
UPDATE c_Drug_Brand SET brand_name = 'Symbicort' WHERE brand_name_rxcui = 'KEBI7759'
UPDATE c_Drug_Brand SET brand_name = 'Symbicort' WHERE brand_name_rxcui = 'KEBI7750'
UPDATE c_Drug_Brand SET brand_name = 'Tavanic' WHERE brand_name_rxcui = 'KEBI5931'
UPDATE c_Drug_Brand SET brand_name = 'Tazid' WHERE brand_name_rxcui = 'KEBI14405'
UPDATE c_Drug_Brand SET brand_name = 'Teltas-40 H' WHERE brand_name_rxcui = 'KEBI6211'
UPDATE c_Drug_Brand SET brand_name = 'Teltas-80 H' WHERE brand_name_rxcui = 'KEBI6216'
UPDATE c_Drug_Brand SET brand_name = 'Tenadol' WHERE brand_name_rxcui = 'KEBI10794'
UPDATE c_Drug_Brand SET brand_name = 'Tenoret' WHERE brand_name_rxcui = 'KEBI7763'
UPDATE c_Drug_Brand SET brand_name = 'Theotaz' WHERE brand_name_rxcui = 'KEBI15406'
UPDATE c_Drug_Brand SET brand_name = 'Ticagre' WHERE brand_name_rxcui = 'KEBI13185'
UPDATE c_Drug_Brand SET brand_name = 'Ticamet' WHERE brand_name_rxcui = 'KEBI2286'
UPDATE c_Drug_Brand SET brand_name = 'Tolvat' WHERE brand_name_rxcui = 'KEBI12382'
UPDATE c_Drug_Brand SET brand_name = 'Tolvat' WHERE brand_name_rxcui = 'KEBI12386'
UPDATE c_Drug_Brand SET brand_name = 'Topquine' WHERE brand_name_rxcui = 'KEBI1463'
UPDATE c_Drug_Brand SET brand_name = 'Toras-Denk' WHERE brand_name_rxcui = 'KEBI10766'
UPDATE c_Drug_Brand SET brand_name = 'Toras-Denk' WHERE brand_name_rxcui = 'KEBI10765'
UPDATE c_Drug_Brand SET brand_name = 'Trabilin 100 MG in' WHERE brand_name_rxcui = 'KEBI4640'
UPDATE c_Drug_Brand SET brand_name = 'Tramacetamol' WHERE brand_name_rxcui = 'KEBI14909'
UPDATE c_Drug_Brand SET brand_name = 'Tramadol Denk' WHERE brand_name_rxcui = 'KEBI10964'
UPDATE c_Drug_Brand SET brand_name = 'Tramal' WHERE brand_name_rxcui = 'KEBI7890'
UPDATE c_Drug_Brand SET brand_name = 'Tramal SR' WHERE brand_name_rxcui = 'KEBI7892'
UPDATE c_Drug_Brand SET brand_name = 'Tramed' WHERE brand_name_rxcui = 'KEBI7219'
UPDATE c_Drug_Brand SET brand_name = 'Traxol-S' WHERE brand_name_rxcui = 'KEBI5082'
UPDATE c_Drug_Brand SET brand_name = 'Trevia' WHERE brand_name_rxcui = 'KEBI1197'
UPDATE c_Drug_Brand SET brand_name = 'Trevia' WHERE brand_name_rxcui = 'KEBI950'
UPDATE c_Drug_Brand SET brand_name = 'Treviamet' WHERE brand_name_rxcui = 'KEBI3361'
UPDATE c_Drug_Brand SET brand_name = 'Treviamet' WHERE brand_name_rxcui = 'KEBI3360'
UPDATE c_Drug_Brand SET brand_name = 'Tricozole' WHERE brand_name_rxcui = 'KEBI5188'
UPDATE c_Drug_Brand SET brand_name = 'Triplixam' WHERE brand_name_rxcui = 'KEBI11753'
UPDATE c_Drug_Brand SET brand_name = 'Triplixam' WHERE brand_name_rxcui = 'KEBI11727'
UPDATE c_Drug_Brand SET brand_name = 'Triplixam' WHERE brand_name_rxcui = 'KEBI11755'
UPDATE c_Drug_Brand SET brand_name = 'Triplixam' WHERE brand_name_rxcui = 'KEBI11743'
UPDATE c_Drug_Brand SET brand_name = 'Tripride' WHERE brand_name_rxcui = 'KEBI6121'
UPDATE c_Drug_Brand SET brand_name = 'Tritace' WHERE brand_name_rxcui = 'KEBI5933'
UPDATE c_Drug_Brand SET brand_name = 'Tritace' WHERE brand_name_rxcui = 'KEBI5835'
UPDATE c_Drug_Brand SET brand_name = 'Tritace' WHERE brand_name_rxcui = 'KEBI5932'
UPDATE c_Drug_Brand SET brand_name = 'Tritazide' WHERE brand_name_rxcui = 'KEBI7308'
UPDATE c_Drug_Brand SET brand_name = 'Tritazide' WHERE brand_name_rxcui = 'KEBI5952'
UPDATE c_Drug_Brand SET brand_name = 'Tritazide' WHERE brand_name_rxcui = 'KEBI5950'
UPDATE c_Drug_Brand SET brand_name = 'Tritazide' WHERE brand_name_rxcui = 'KEBI5947'
UPDATE c_Drug_Brand SET brand_name = 'Trixon-S' WHERE brand_name_rxcui = 'KEBI9513'
UPDATE c_Drug_Brand SET brand_name = 'TX-MF' WHERE brand_name_rxcui = 'KEBI5808'
UPDATE c_Drug_Brand SET brand_name = 'Unasyn' WHERE brand_name_rxcui = 'KEBI5216'
UPDATE c_Drug_Brand SET brand_name = 'Unitram' WHERE brand_name_rxcui = 'KEBI9482'
UPDATE c_Drug_Brand SET brand_name = 'Uperio' WHERE brand_name_rxcui = 'KEBI13806'
UPDATE c_Drug_Brand SET brand_name = 'Uperio' WHERE brand_name_rxcui = 'KEBI13803'
UPDATE c_Drug_Brand SET brand_name = 'Uperio' WHERE brand_name_rxcui = 'KEBI13804'
UPDATE c_Drug_Brand SET brand_name = 'Urgendol' WHERE brand_name_rxcui = 'KEBI7247'
UPDATE c_Drug_Brand SET brand_name = 'Valsar-Denk' WHERE brand_name_rxcui = 'KEBI11921'
UPDATE c_Drug_Brand SET brand_name = 'Valsar-Denk' WHERE brand_name_rxcui = 'KEBI10774'
UPDATE c_Drug_Brand SET brand_name = 'Valsar-Denk' WHERE brand_name_rxcui = 'KEBI11919'
UPDATE c_Drug_Brand SET brand_name = 'Valvas' WHERE brand_name_rxcui = 'KEBI5937'
UPDATE c_Drug_Brand SET brand_name = 'Varinil' WHERE brand_name_rxcui = 'KEBI10965'
UPDATE c_Drug_Brand SET brand_name = 'Varinil' WHERE brand_name_rxcui = 'KEBI3259'
UPDATE c_Drug_Brand SET brand_name = 'Vasopril' WHERE brand_name_rxcui = 'KEBI2287'
UPDATE c_Drug_Brand SET brand_name = 'Vastor' WHERE brand_name_rxcui = 'KEBI5811'
UPDATE c_Drug_Brand SET brand_name = 'Vedrox' WHERE brand_name_rxcui = 'KEBI644'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4584'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin Respirator Solution' WHERE brand_name_rxcui = 'KEBI4567'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin Rotacaps' WHERE brand_name_rxcui = 'KEBI4558-100'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin Rotacaps' WHERE brand_name_rxcui = 'KEBI4558-128'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin Syrup' WHERE brand_name_rxcui = 'KEBI4552'
UPDATE c_Drug_Brand SET brand_name = 'Vera-Denk' WHERE brand_name_rxcui = 'KEBI4661'
UPDATE c_Drug_Brand SET brand_name = 'VERcef' WHERE brand_name_rxcui = 'KEBI2800'
UPDATE c_Drug_Brand SET brand_name = 'Vermox' WHERE brand_name_rxcui = 'KEBI4044'
UPDATE c_Drug_Brand SET brand_name = 'Victoza' WHERE brand_name_rxcui = 'KEBI10719'
UPDATE c_Drug_Brand SET brand_name = 'Wombit' WHERE brand_name_rxcui = 'KEBI11999'
UPDATE c_Drug_Brand SET brand_name = 'Xime' WHERE brand_name_rxcui = 'KEBI5786'
UPDATE c_Drug_Brand SET brand_name = 'Xoprim' WHERE brand_name_rxcui = 'KEBI11678'
UPDATE c_Drug_Brand SET brand_name = 'Zamadol P' WHERE brand_name_rxcui = 'KEBI10825'
UPDATE c_Drug_Brand SET brand_name = 'Zentel' WHERE brand_name_rxcui = 'KEBI3675'
UPDATE c_Drug_Brand SET brand_name = 'Zentel' WHERE brand_name_rxcui = 'KEBI3681'
UPDATE c_Drug_Brand SET brand_name = 'Zerover Paediatric Paracetamol' WHERE brand_name_rxcui = 'KEBI8009'
UPDATE c_Drug_Brand SET brand_name = 'Zetoren' WHERE brand_name_rxcui = 'KEBI15512'
UPDATE c_Drug_Brand SET brand_name = 'Zetro' WHERE brand_name_rxcui = 'KEBI3363'
UPDATE c_Drug_Brand SET brand_name = 'Ziak' WHERE brand_name_rxcui = 'KEBI10479'
UPDATE c_Drug_Brand SET brand_name = 'Ziak' WHERE brand_name_rxcui = 'KEBI10367'
UPDATE c_Drug_Brand SET brand_name = 'Ziak' WHERE brand_name_rxcui = 'KEBI10477'
UPDATE c_Drug_Brand SET brand_name = 'Zilab' WHERE brand_name_rxcui = 'KEBI15516'
UPDATE c_Drug_Brand SET brand_name = 'Zinnat' WHERE brand_name_rxcui = 'KEBI4096'
UPDATE c_Drug_Brand SET brand_name = 'Zinnat' WHERE brand_name_rxcui = 'KEBI4087'
UPDATE c_Drug_Brand SET brand_name = 'Zinnat' WHERE brand_name_rxcui = 'KEBI3684'
UPDATE c_Drug_Brand SET brand_name = 'Ziprax-DT' WHERE brand_name_rxcui = 'KEBI8616'
UPDATE c_Drug_Brand SET brand_name = 'Zithromax' WHERE brand_name_rxcui = 'KEBI5120'
UPDATE c_Drug_Brand SET brand_name = 'Zithroriv' WHERE brand_name_rxcui = 'KEBI8947'
UPDATE c_Drug_Brand SET brand_name = 'Zyrtal OD' WHERE brand_name_rxcui = 'KEBI2921'
UPDATE c_Drug_Brand SET brand_name = 'Zyrtal-SP' WHERE brand_name_rxcui = 'KEBI3704'

update c_Drug_Formulation set ingr_rxcui = '135805' where ingr_rxcui = 'KEBI1148'
update c_Drug_Formulation set ingr_rxcui = '135805' where ingr_rxcui = 'KEBI1202'
update c_Drug_Formulation set ingr_rxcui = '1372730' where ingr_rxcui = 'KEBI7696'
update c_Drug_Formulation set ingr_rxcui = '1372733' where ingr_rxcui = 'KEBI3564'
update c_Drug_Formulation set ingr_rxcui = '1372733' where ingr_rxcui = 'KEBI3566'
update c_Drug_Formulation set ingr_rxcui = '1372738' where ingr_rxcui = 'KEBI9539'
update c_Drug_Formulation set ingr_rxcui = '1372738' where ingr_rxcui = 'KEBI9535'
update c_Drug_Formulation set ingr_rxcui = '1372744' where ingr_rxcui = 'KEBI1217'
update c_Drug_Formulation set ingr_rxcui = '152699' where ingr_rxcui = 'KEBI1133'
update c_Drug_Formulation set ingr_rxcui = '152819' where ingr_rxcui = 'KEBI5940'
update c_Drug_Formulation set ingr_rxcui = '153592' where ingr_rxcui = 'KEBI5080'
update c_Drug_Formulation set ingr_rxcui = '196474' where ingr_rxcui = 'KEBI5120'
update c_Drug_Formulation set ingr_rxcui = '327148' where ingr_rxcui = 'KEBI7758-120'
update c_Drug_Formulation set ingr_rxcui = '327148' where ingr_rxcui = 'KEBI7758-60'
update c_Drug_Formulation set ingr_rxcui = '327148' where ingr_rxcui = 'KEBI7759'
update c_Drug_Formulation set ingr_rxcui = '327148' where ingr_rxcui = 'KEBI7750'
update c_Drug_Formulation set ingr_rxcui = '400560' where ingr_rxcui = 'KEBI297Vial'
update c_Drug_Formulation set ingr_rxcui = '8887' where ingr_rxcui = 'KEBI4584'
update c_Drug_Formulation set ingr_rxcui = '897123' where ingr_rxcui = 'KEBI10719'
update c_Drug_Formulation set ingr_rxcui = '92880' where ingr_rxcui = 'KEBI1239'
update c_Drug_Formulation set ingr_rxcui = '92880' where ingr_rxcui = 'KEBI1235'
update c_Drug_Formulation set ingr_rxcui = '92880' where ingr_rxcui = 'KEBI1239-4ML'
update c_Drug_Formulation set ingr_rxcui = '92881' where ingr_rxcui = 'KEBI1246'
update c_Drug_Formulation set ingr_rxcui = '92881' where ingr_rxcui = 'KEBI1241'
update c_Drug_Formulation set ingr_rxcui = '92881' where ingr_rxcui = 'KEBI1246-4ML'
update c_Drug_Formulation set ingr_rxcui = '1116636' where ingr_rxcui = 'KEBI6722'
update c_Drug_Formulation set ingr_rxcui = '151392' where ingr_rxcui = 'KEBI2758'
update c_Drug_Formulation set ingr_rxcui = '151392' where ingr_rxcui = 'KEBI2759'
update c_Drug_Formulation set ingr_rxcui = '151392' where ingr_rxcui = 'KEBI2761'
update c_Drug_Formulation set ingr_rxcui = '202866' where ingr_rxcui = 'KEBI5641'
update c_Drug_Formulation set ingr_rxcui = '202866' where ingr_rxcui = 'KEBI5897'
update c_Drug_Formulation set ingr_rxcui = '202972' where ingr_rxcui = 'KEBI4044'
update c_Drug_Formulation set ingr_rxcui = '202988' where ingr_rxcui = 'KEBI3129'
update c_Drug_Formulation set ingr_rxcui = '202988' where ingr_rxcui = 'KEBI3131'
update c_Drug_Formulation set ingr_rxcui = '202988' where ingr_rxcui = 'KEBI3130'
update c_Drug_Formulation set ingr_rxcui = '202991' where ingr_rxcui = 'KEBI5459'
update c_Drug_Formulation set ingr_rxcui = '203016' where ingr_rxcui = 'KEBI7724'
update c_Drug_Formulation set ingr_rxcui = '203016' where ingr_rxcui = 'KEBI7725'
update c_Drug_Formulation set ingr_rxcui = '203489' where ingr_rxcui = 'KEBI5308'
update c_Drug_Formulation set ingr_rxcui = '203565' where ingr_rxcui = 'KEBI1580'
update c_Drug_Formulation set ingr_rxcui = '261551' where ingr_rxcui = 'KEBI5912'
update c_Drug_Formulation set ingr_rxcui = '284743' where ingr_rxcui = 'KEBI10486'
update c_Drug_Formulation set ingr_rxcui = '284743' where ingr_rxcui = 'KEBI10487'
update c_Drug_Formulation set ingr_rxcui = '284743' where ingr_rxcui = 'KEBI10488'
update c_Drug_Formulation set ingr_rxcui = '284799' where ingr_rxcui = 'KEBI7719'
update c_Drug_Formulation set ingr_rxcui = '284799' where ingr_rxcui = 'KEBI7721'
update c_Drug_Formulation set ingr_rxcui = '404914' where ingr_rxcui = 'KEBI1577'
update c_Drug_Formulation set ingr_rxcui = '57773' where ingr_rxcui = 'KEBI5216'
update c_Drug_Formulation set ingr_rxcui = '722127' where ingr_rxcui = 'KEBI3037'
update c_Drug_Formulation set ingr_rxcui = '722127' where ingr_rxcui = 'KEBI2994'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2372', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2372'	UPDATE c_Drug_Brand SET brand_name = 'Albuzol' WHERE brand_name_rxcui = 'KEBI2372'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI937', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB937'	UPDATE c_Drug_Brand SET brand_name = 'Amlovas' WHERE brand_name_rxcui = 'KEBI937'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI934', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB934'	UPDATE c_Drug_Brand SET brand_name = 'Amlovas' WHERE brand_name_rxcui = 'KEBI934'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2622', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2622'	UPDATE c_Drug_Brand SET brand_name = 'Anginal' WHERE brand_name_rxcui = 'KEBI2622'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4662', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4662'	UPDATE c_Drug_Brand SET brand_name = 'Artequin' WHERE brand_name_rxcui = 'KEBI4662'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4664', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4664'	UPDATE c_Drug_Brand SET brand_name = 'Artequin' WHERE brand_name_rxcui = 'KEBI4664'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7937', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7937'	UPDATE c_Drug_Brand SET brand_name = 'Asomex' WHERE brand_name_rxcui = 'KEBI7937'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7938', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7938'	UPDATE c_Drug_Brand SET brand_name = 'Asomex' WHERE brand_name_rxcui = 'KEBI7938'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7939', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7939'	UPDATE c_Drug_Brand SET brand_name = 'Asomex' WHERE brand_name_rxcui = 'KEBI7939'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6417', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6417'	UPDATE c_Drug_Brand SET brand_name = 'ASP' WHERE brand_name_rxcui = 'KEBI6417'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI511', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB511'	UPDATE c_Drug_Brand SET brand_name = 'ATM' WHERE brand_name_rxcui = 'KEBI511'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8176', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8176'	UPDATE c_Drug_Brand SET brand_name = 'Avas' WHERE brand_name_rxcui = 'KEBI8176'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3225', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3225'	UPDATE c_Drug_Brand SET brand_name = 'Cardi' WHERE brand_name_rxcui = 'KEBI3225'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15490', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15490'	UPDATE c_Drug_Brand SET brand_name = 'Cilneed' WHERE brand_name_rxcui = 'KEBI15490'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15189', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15189'	UPDATE c_Drug_Brand SET brand_name = 'Cilvas' WHERE brand_name_rxcui = 'KEBI15189'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11906', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11906'	UPDATE c_Drug_Brand SET brand_name = 'Dolafree' WHERE brand_name_rxcui = 'KEBI11906'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13846', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13846'	UPDATE c_Drug_Brand SET brand_name = 'Glucodip' WHERE brand_name_rxcui = 'KEBI13846'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15001', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15001'	UPDATE c_Drug_Brand SET brand_name = 'Gsunate' WHERE brand_name_rxcui = 'KEBI15001'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI470', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB470'	UPDATE c_Drug_Brand SET brand_name = 'Gvither' WHERE brand_name_rxcui = 'KEBI470'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI464', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB464'	UPDATE c_Drug_Brand SET brand_name = 'Gvither' WHERE brand_name_rxcui = 'KEBI464'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI670', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB670'	UPDATE c_Drug_Brand SET brand_name = 'HCQS' WHERE brand_name_rxcui = 'KEBI670'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3539', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3539'	UPDATE c_Drug_Brand SET brand_name = 'Ibufen' WHERE brand_name_rxcui = 'KEBI3539'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8654', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8654'	UPDATE c_Drug_Brand SET brand_name = 'Lanzol' WHERE brand_name_rxcui = 'KEBI8654'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6112', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6112'	UPDATE c_Drug_Brand SET brand_name = 'Levobact' WHERE brand_name_rxcui = 'KEBI6112'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13140', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13140'	UPDATE c_Drug_Brand SET brand_name = 'Nebilong' WHERE brand_name_rxcui = 'KEBI13140'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI591', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB591'	UPDATE c_Drug_Brand SET brand_name = 'Oxipod' WHERE brand_name_rxcui = 'KEBI591'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4327', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4327'	UPDATE c_Drug_Brand SET brand_name = 'Rilif' WHERE brand_name_rxcui = 'KEBI4327'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI205', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB205'	UPDATE c_Drug_Brand SET brand_name = 'Rostat' WHERE brand_name_rxcui = 'KEBI205'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11802', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11802'	UPDATE c_Drug_Brand SET brand_name = 'Rostat' WHERE brand_name_rxcui = 'KEBI11802'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI204', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB204'	UPDATE c_Drug_Brand SET brand_name = 'Rostat' WHERE brand_name_rxcui = 'KEBI204'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8308', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8308'	UPDATE c_Drug_Brand SET brand_name = 'S-Numlo' WHERE brand_name_rxcui = 'KEBI8308'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8309', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8309'	UPDATE c_Drug_Brand SET brand_name = 'S-Numlo' WHERE brand_name_rxcui = 'KEBI8309'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15340', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15340'	UPDATE c_Drug_Brand SET brand_name = 'Spirolac' WHERE brand_name_rxcui = 'KEBI15340'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6210', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6210'	UPDATE c_Drug_Brand SET brand_name = 'Teltas' WHERE brand_name_rxcui = 'KEBI6210'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6214', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6214'	UPDATE c_Drug_Brand SET brand_name = 'Teltas' WHERE brand_name_rxcui = 'KEBI6214'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13141', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13141'	UPDATE c_Drug_Brand SET brand_name = 'Torsinex' WHERE brand_name_rxcui = 'KEBI13141'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4644', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4644'	UPDATE c_Drug_Brand SET brand_name = 'Trabilin' WHERE brand_name_rxcui = 'KEBI4644'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3630', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3630'	UPDATE c_Drug_Brand SET brand_name = 'Ventosal' WHERE brand_name_rxcui = 'KEBI3630'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2960', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2960'	UPDATE c_Drug_Brand SET brand_name = 'Warexx' WHERE brand_name_rxcui = 'KEBI2960'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9825', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9825'	UPDATE c_Drug_Brand SET brand_name = 'Acepar-SP' WHERE brand_name_rxcui = 'KEBI9825'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13360', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13360'	UPDATE c_Drug_Brand SET brand_name = 'Aclosara-MR' WHERE brand_name_rxcui = 'KEBI13360'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5310', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5310'	UPDATE c_Drug_Brand SET brand_name = 'Amqunate' WHERE brand_name_rxcui = 'KEBI5310'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5740', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5740'	UPDATE c_Drug_Brand SET brand_name = 'Amtas-AT' WHERE brand_name_rxcui = 'KEBI5740'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9380', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9380'	UPDATE c_Drug_Brand SET brand_name = 'Anamint' WHERE brand_name_rxcui = 'KEBI9380'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3192', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3192'	UPDATE c_Drug_Brand SET brand_name = 'APC' WHERE brand_name_rxcui = 'KEBI3192'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11726', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11726'	UPDATE c_Drug_Brand SET brand_name = 'Apflu Syrup' WHERE brand_name_rxcui = 'KEBI11726'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1358', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1358'	UPDATE c_Drug_Brand SET brand_name = 'Artefan Dispersible' WHERE brand_name_rxcui = 'KEBI1358'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1293', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1293'	UPDATE c_Drug_Brand SET brand_name = 'Artefan' WHERE brand_name_rxcui = 'KEBI1293'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4392', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4392'	UPDATE c_Drug_Brand SET brand_name = 'Axylin' WHERE brand_name_rxcui = 'KEBI4392'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4138', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4138'	UPDATE c_Drug_Brand SET brand_name = 'Benylin Daytime Flu' WHERE brand_name_rxcui = 'KEBI4138'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1035', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1035'	UPDATE c_Drug_Brand SET brand_name = 'Benylin Four Flu' WHERE brand_name_rxcui = 'KEBI1035'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI12154', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB12154'	UPDATE c_Drug_Brand SET brand_name = 'Beta Cool Double Action' WHERE brand_name_rxcui = 'KEBI12154'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7106', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7106'	UPDATE c_Drug_Brand SET brand_name = 'Betafen Plus' WHERE brand_name_rxcui = 'KEBI7106'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8159', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8159'	UPDATE c_Drug_Brand SET brand_name = 'Betapyn' WHERE brand_name_rxcui = 'KEBI8159'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8169', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8169'	UPDATE c_Drug_Brand SET brand_name = 'BronchoPed Expectorant and Bronchodilator' WHERE brand_name_rxcui = 'KEBI8169'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11705', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11705'	UPDATE c_Drug_Brand SET brand_name = 'Cefo-L Powder for' WHERE brand_name_rxcui = 'KEBI11705'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9377', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9377'	UPDATE c_Drug_Brand SET brand_name = 'Cinepar Kid' WHERE brand_name_rxcui = 'KEBI9377'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10329', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10329'	UPDATE c_Drug_Brand SET brand_name = 'Co-Corither' WHERE brand_name_rxcui = 'KEBI10329'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11125', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11125'	UPDATE c_Drug_Brand SET brand_name = 'Co-Malather Compact' WHERE brand_name_rxcui = 'KEBI11125'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7162', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7162'	UPDATE c_Drug_Brand SET brand_name = 'Co-Malather' WHERE brand_name_rxcui = 'KEBI7162'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2246', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2246'	UPDATE c_Drug_Brand SET brand_name = 'Co-Max' WHERE brand_name_rxcui = 'KEBI2246'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2470', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2470'	UPDATE c_Drug_Brand SET brand_name = 'Coartem Dispersible' WHERE brand_name_rxcui = 'KEBI2470'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15190', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15190'	UPDATE c_Drug_Brand SET brand_name = 'Cocoflu' WHERE brand_name_rxcui = 'KEBI15190'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI480', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB480'	UPDATE c_Drug_Brand SET brand_name = 'Coldcap Daytime and Night time' WHERE brand_name_rxcui = 'KEBI480'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2996', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2996'	UPDATE c_Drug_Brand SET brand_name = 'Coldcap Daytime' WHERE brand_name_rxcui = 'KEBI2996'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI496', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB496'	UPDATE c_Drug_Brand SET brand_name = 'Coldcap Night Time' WHERE brand_name_rxcui = 'KEBI496'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI510', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB510'	UPDATE c_Drug_Brand SET brand_name = 'Coldcap Original' WHERE brand_name_rxcui = 'KEBI510'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI588', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB588'	UPDATE c_Drug_Brand SET brand_name = 'Coldcap Syrup' WHERE brand_name_rxcui = 'KEBI588'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3287', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3287'	UPDATE c_Drug_Brand SET brand_name = 'ColdFlu' WHERE brand_name_rxcui = 'KEBI3287'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11122', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11122'	UPDATE c_Drug_Brand SET brand_name = 'Coldril' WHERE brand_name_rxcui = 'KEBI11122'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11124', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11124'	UPDATE c_Drug_Brand SET brand_name = 'Coldril' WHERE brand_name_rxcui = 'KEBI11124'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2566', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2566'	UPDATE c_Drug_Brand SET brand_name = 'Comax DPS' WHERE brand_name_rxcui = 'KEBI2566'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3715', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3715'	UPDATE c_Drug_Brand SET brand_name = 'Combiart' WHERE brand_name_rxcui = 'KEBI3715'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI146', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB146'	UPDATE c_Drug_Brand SET brand_name = 'Contus Plus Paediatric' WHERE brand_name_rxcui = 'KEBI146'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7346', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7346'	UPDATE c_Drug_Brand SET brand_name = 'Coscof CD Linctus' WHERE brand_name_rxcui = 'KEBI7346'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3623', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3623'	UPDATE c_Drug_Brand SET brand_name = 'DF118' WHERE brand_name_rxcui = 'KEBI3623'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5791', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5791'	UPDATE c_Drug_Brand SET brand_name = 'Doloact-MR' WHERE brand_name_rxcui = 'KEBI5791'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7202', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7202'	UPDATE c_Drug_Brand SET brand_name = 'Dolomed MR' WHERE brand_name_rxcui = 'KEBI7202'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10511', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10511'	UPDATE c_Drug_Brand SET brand_name = 'Ecofree Plus' WHERE brand_name_rxcui = 'KEBI10511'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16158', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16158'	UPDATE c_Drug_Brand SET brand_name = 'Entamaxin' WHERE brand_name_rxcui = 'KEBI16158'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5630', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5630'	UPDATE c_Drug_Brand SET brand_name = 'Enzoflam' WHERE brand_name_rxcui = 'KEBI5630'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3748', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3748'	UPDATE c_Drug_Brand SET brand_name = 'Ephicol' WHERE brand_name_rxcui = 'KEBI3748'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13531', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13531'	UPDATE c_Drug_Brand SET brand_name = 'Etofix-P' WHERE brand_name_rxcui = 'KEBI13531'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI719', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB719'	UPDATE c_Drug_Brand SET brand_name = 'Febricol' WHERE brand_name_rxcui = 'KEBI719'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11831', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11831'	UPDATE c_Drug_Brand SET brand_name = 'Flamacor MR' WHERE brand_name_rxcui = 'KEBI11831'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2473', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2473'	UPDATE c_Drug_Brand SET brand_name = 'Flamoryl-S' WHERE brand_name_rxcui = 'KEBI2473'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3832', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3832'	UPDATE c_Drug_Brand SET brand_name = 'Flu-Gone C+F' WHERE brand_name_rxcui = 'KEBI3832'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3815', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3815'	UPDATE c_Drug_Brand SET brand_name = 'Flu-Gone' WHERE brand_name_rxcui = 'KEBI3815'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3861', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3861'	UPDATE c_Drug_Brand SET brand_name = 'Flu-Gone-P Plus Syrup' WHERE brand_name_rxcui = 'KEBI3861'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3201', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3201'	UPDATE c_Drug_Brand SET brand_name = 'Flucoldex-E' WHERE brand_name_rxcui = 'KEBI3201'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI108', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB108'	UPDATE c_Drug_Brand SET brand_name = 'Gaviscon Double Action Liquid' WHERE brand_name_rxcui = 'KEBI108'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI235', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB235'	UPDATE c_Drug_Brand SET brand_name = 'Gaviscon Original Liquid' WHERE brand_name_rxcui = 'KEBI235'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3022', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3022'	UPDATE c_Drug_Brand SET brand_name = 'Glimiday M1' WHERE brand_name_rxcui = 'KEBI3022'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10796', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10796'	UPDATE c_Drug_Brand SET brand_name = 'Gramocef-CV' WHERE brand_name_rxcui = 'KEBI10796'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11503', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11503'	UPDATE c_Drug_Brand SET brand_name = 'Grilinctus - BM Syrup' WHERE brand_name_rxcui = 'KEBI11503'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1123', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1123'	UPDATE c_Drug_Brand SET brand_name = 'Gripe Water' WHERE brand_name_rxcui = 'KEBI1123'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11423', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11423'	UPDATE c_Drug_Brand SET brand_name = 'Helicoban' WHERE brand_name_rxcui = 'KEBI11423'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11962', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11962'	UPDATE c_Drug_Brand SET brand_name = 'Homacure' WHERE brand_name_rxcui = 'KEBI11962'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3785', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3785'	UPDATE c_Drug_Brand SET brand_name = 'Homagon' WHERE brand_name_rxcui = 'KEBI3785'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1156', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1156'	UPDATE c_Drug_Brand SET brand_name = 'Hyspar' WHERE brand_name_rxcui = 'KEBI1156'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6024', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6024'	UPDATE c_Drug_Brand SET brand_name = 'Ibex' WHERE brand_name_rxcui = 'KEBI6024'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3957', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3957'	UPDATE c_Drug_Brand SET brand_name = 'Ibuflam Plus' WHERE brand_name_rxcui = 'KEBI3957'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1862', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1862'	UPDATE c_Drug_Brand SET brand_name = 'Kelvin-P' WHERE brand_name_rxcui = 'KEBI1862'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4069', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4069'	UPDATE c_Drug_Brand SET brand_name = 'Kofed Compound Linctus' WHERE brand_name_rxcui = 'KEBI4069'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4396', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4396'	UPDATE c_Drug_Brand SET brand_name = 'Laefin' WHERE brand_name_rxcui = 'KEBI4396'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14708', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14708'	UPDATE c_Drug_Brand SET brand_name = 'Lamitar AM' WHERE brand_name_rxcui = 'KEBI14708'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10575', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10575'	UPDATE c_Drug_Brand SET brand_name = 'Lartem' WHERE brand_name_rxcui = 'KEBI10575'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI215', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB215'	UPDATE c_Drug_Brand SET brand_name = 'Lemsip Max Cold & Flu Powder for' WHERE brand_name_rxcui = 'KEBI215'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2097', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2097'	UPDATE c_Drug_Brand SET brand_name = 'Levostar' WHERE brand_name_rxcui = 'KEBI2097'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI405', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB405'	UPDATE c_Drug_Brand SET brand_name = 'Lonart Dispersible' WHERE brand_name_rxcui = 'KEBI405'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI397', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB397'	UPDATE c_Drug_Brand SET brand_name = 'Lonart' WHERE brand_name_rxcui = 'KEBI397'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI439', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB439'	UPDATE c_Drug_Brand SET brand_name = 'Lonart' WHERE brand_name_rxcui = 'KEBI439'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8162', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8162'	UPDATE c_Drug_Brand SET brand_name = 'Lotem' WHERE brand_name_rxcui = 'KEBI8162'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5430', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5430'	UPDATE c_Drug_Brand SET brand_name = 'Lufanate Dispersible' WHERE brand_name_rxcui = 'KEBI5430'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5434', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5434'	UPDATE c_Drug_Brand SET brand_name = 'Lufanate' WHERE brand_name_rxcui = 'KEBI5434'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI13036', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB13036'	UPDATE c_Drug_Brand SET brand_name = 'Lum-Artem Forte' WHERE brand_name_rxcui = 'KEBI13036'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1165', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1165'	UPDATE c_Drug_Brand SET brand_name = 'Lum-Artem Powder for' WHERE brand_name_rxcui = 'KEBI1165'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8376', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8376'	UPDATE c_Drug_Brand SET brand_name = 'Lumet' WHERE brand_name_rxcui = 'KEBI8376'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1912', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1912'	UPDATE c_Drug_Brand SET brand_name = 'Lumiter' WHERE brand_name_rxcui = 'KEBI1912'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2098', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2098'	UPDATE c_Drug_Brand SET brand_name = 'Luteriam' WHERE brand_name_rxcui = 'KEBI2098'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14953', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14953'	UPDATE c_Drug_Brand SET brand_name = 'Lysodol MR' WHERE brand_name_rxcui = 'KEBI14953'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4920', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4920'	UPDATE c_Drug_Brand SET brand_name = 'Lysoflam' WHERE brand_name_rxcui = 'KEBI4920'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3975', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3975'	UPDATE c_Drug_Brand SET brand_name = 'Magnocid Mixture' WHERE brand_name_rxcui = 'KEBI3975'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3132', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3132'	UPDATE c_Drug_Brand SET brand_name = 'Malanil Adult' WHERE brand_name_rxcui = 'KEBI3132'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3133', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3133'	UPDATE c_Drug_Brand SET brand_name = 'Malanil Paediatric' WHERE brand_name_rxcui = 'KEBI3133'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI14001', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB14001'	UPDATE c_Drug_Brand SET brand_name = 'Medisart H' WHERE brand_name_rxcui = 'KEBI14001'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8261', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8261'	UPDATE c_Drug_Brand SET brand_name = 'Metrogyl Denta' WHERE brand_name_rxcui = 'KEBI8261'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3551', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3551'	UPDATE c_Drug_Brand SET brand_name = 'Mifupen' WHERE brand_name_rxcui = 'KEBI3551'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4459', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4459'	UPDATE c_Drug_Brand SET brand_name = 'Myolgin' WHERE brand_name_rxcui = 'KEBI4459'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16179', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB16179'	UPDATE c_Drug_Brand SET brand_name = 'Myonac MR' WHERE brand_name_rxcui = 'KEBI16179'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7228', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7228'	UPDATE c_Drug_Brand SET brand_name = 'Myospaz' WHERE brand_name_rxcui = 'KEBI7228'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8163', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8163'	UPDATE c_Drug_Brand SET brand_name = 'Mypaid' WHERE brand_name_rxcui = 'KEBI8163'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8217', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8217'	UPDATE c_Drug_Brand SET brand_name = 'Myprodol' WHERE brand_name_rxcui = 'KEBI8217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI891', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB891'	UPDATE c_Drug_Brand SET brand_name = 'Neosanmag Fast Chewable' WHERE brand_name_rxcui = 'KEBI891'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11049', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11049'	UPDATE c_Drug_Brand SET brand_name = 'Nolgripp Junior' WHERE brand_name_rxcui = 'KEBI11049'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11050', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11050'	UPDATE c_Drug_Brand SET brand_name = 'Nolgripp Plus' WHERE brand_name_rxcui = 'KEBI11050'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI6917', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB6917'	UPDATE c_Drug_Brand SET brand_name = 'Painotab Analgesic' WHERE brand_name_rxcui = 'KEBI6917'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9594', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9594'	UPDATE c_Drug_Brand SET brand_name = 'Panadol Cold and Flu Day' WHERE brand_name_rxcui = 'KEBI9594'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1949', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1949'	UPDATE c_Drug_Brand SET brand_name = 'Powergesic MR' WHERE brand_name_rxcui = 'KEBI1949'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI15892', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB15892'	UPDATE c_Drug_Brand SET brand_name = 'Pro-Fantrine Forte' WHERE brand_name_rxcui = 'KEBI15892'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI11092', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB11092'	UPDATE c_Drug_Brand SET brand_name = 'Profenazone' WHERE brand_name_rxcui = 'KEBI11092'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI8218', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB8218'	UPDATE c_Drug_Brand SET brand_name = 'Pynstop' WHERE brand_name_rxcui = 'KEBI8218'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI461', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB461'	UPDATE c_Drug_Brand SET brand_name = 'Quadrajel' WHERE brand_name_rxcui = 'KEBI461'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3664', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3664'	UPDATE c_Drug_Brand SET brand_name = 'Razid-M Sustained Release' WHERE brand_name_rxcui = 'KEBI3664'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3557', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3557'	UPDATE c_Drug_Brand SET brand_name = 'RiLIF MR' WHERE brand_name_rxcui = 'KEBI3557'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI1435', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB1435'	UPDATE c_Drug_Brand SET brand_name = 'Sabulin' WHERE brand_name_rxcui = 'KEBI1435'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3456', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3456'	UPDATE c_Drug_Brand SET brand_name = 'Salcof' WHERE brand_name_rxcui = 'KEBI3456'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9414', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9414'	UPDATE c_Drug_Brand SET brand_name = 'Shal''artem Forte' WHERE brand_name_rxcui = 'KEBI9414'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9411', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9411'	UPDATE c_Drug_Brand SET brand_name = 'Shal''artem' WHERE brand_name_rxcui = 'KEBI9411'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI10677', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB10677'	UPDATE c_Drug_Brand SET brand_name = 'Sonacold with Vitamin C' WHERE brand_name_rxcui = 'KEBI10677'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI978', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB978'	UPDATE c_Drug_Brand SET brand_name = 'Sonapen' WHERE brand_name_rxcui = 'KEBI978'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2831', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB2831'	UPDATE c_Drug_Brand SET brand_name = 'Spasmocare Plus' WHERE brand_name_rxcui = 'KEBI2831'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI9944', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB9944'	UPDATE c_Drug_Brand SET brand_name = 'Tinilox-MPS' WHERE brand_name_rxcui = 'KEBI9944'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7916', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7916'	UPDATE c_Drug_Brand SET brand_name = 'Tinilox-MPS' WHERE brand_name_rxcui = 'KEBI7916'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5237', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB5237'	UPDATE c_Drug_Brand SET brand_name = 'Toflox TZ' WHERE brand_name_rxcui = 'KEBI5237'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI4892', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB4892'	UPDATE c_Drug_Brand SET brand_name = 'Tramacetal' WHERE brand_name_rxcui = 'KEBI4892'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7134', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB7134'	UPDATE c_Drug_Brand SET brand_name = 'Woodwards Gripe Water' WHERE brand_name_rxcui = 'KEBI7134'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI3632', ingr_tty = 'BN_KE' WHERE form_rxcui = 'KEB3632'	UPDATE c_Drug_Brand SET brand_name = 'ZyrTAL MR' WHERE brand_name_rxcui = 'KEBI3632'


UPDATE c_Drug_Brand SET brand_name = 'Amqunate' WHERE brand_name_rxcui = 'KEBI11742'
UPDATE c_Drug_Brand SET brand_name = 'Amqunate' WHERE brand_name_rxcui = 'KEBI6023'
UPDATE c_Drug_Brand SET brand_name = 'Azflor' WHERE brand_name_rxcui = 'KEBI13286'
UPDATE c_Drug_Brand SET brand_name = 'Baby Gripe Water' WHERE brand_name_rxcui = 'KEBI4409'
UPDATE c_Drug_Brand SET brand_name = 'Bromsal' WHERE brand_name_rxcui = 'KEBI6458'
UPDATE c_Drug_Brand SET brand_name = 'Bro-Zedex' WHERE brand_name_rxcui = 'KEBI2611'
UPDATE c_Drug_Brand SET brand_name = 'Ciprobay' WHERE brand_name_rxcui = 'KEBI1581'
UPDATE c_Drug_Brand SET brand_name = 'Clear-T' WHERE brand_name_rxcui = 'KEBI6931'
UPDATE c_Drug_Brand SET brand_name = 'Clindar' WHERE brand_name_rxcui = 'KEBI4991'
UPDATE c_Drug_Brand SET brand_name = 'Co-Arinate' WHERE brand_name_rxcui = 'KEBI1532'
UPDATE c_Drug_Brand SET brand_name = 'Co-Arinate' WHERE brand_name_rxcui = 'KEBI1527'
UPDATE c_Drug_Brand SET brand_name = 'Combigan' WHERE brand_name_rxcui = 'KEBI6235'
UPDATE c_Drug_Brand SET brand_name = 'Combivent' WHERE brand_name_rxcui = 'KEBI2421'
UPDATE c_Drug_Brand SET brand_name = 'Dacof' WHERE brand_name_rxcui = 'KEBI1517'
UPDATE c_Drug_Brand SET brand_name = 'Deep Relief' WHERE brand_name_rxcui = 'KEBI1500'
UPDATE c_Drug_Brand SET brand_name = 'Diltigesic' WHERE brand_name_rxcui = 'KEBI2135'
UPDATE c_Drug_Brand SET brand_name = 'Drez' WHERE brand_name_rxcui = 'KEBI150'
UPDATE c_Drug_Brand SET brand_name = 'Drez' WHERE brand_name_rxcui = 'KEBI151'
UPDATE c_Drug_Brand SET brand_name = 'Drez' WHERE brand_name_rxcui = 'KEBI6957'
UPDATE c_Drug_Brand SET brand_name = 'Eno' WHERE brand_name_rxcui = 'KEBI4377'
UPDATE c_Drug_Brand SET brand_name = 'Esclam' WHERE brand_name_rxcui = 'KEBI8620'
UPDATE c_Drug_Brand SET brand_name = 'Esose' WHERE brand_name_rxcui = 'KEBI14713'
UPDATE c_Drug_Brand SET brand_name = 'Feveral' WHERE brand_name_rxcui = 'KEBI5332'
UPDATE c_Drug_Brand SET brand_name = 'Finmol' WHERE brand_name_rxcui = 'KEBI375'
UPDATE c_Drug_Brand SET brand_name = 'Ganfort' WHERE brand_name_rxcui = 'KEBI6247'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon' WHERE brand_name_rxcui = 'KEBI231'
UPDATE c_Drug_Brand SET brand_name = 'Gynanfort' WHERE brand_name_rxcui = 'KEBI10412'
UPDATE c_Drug_Brand SET brand_name = 'H-Cure' WHERE brand_name_rxcui = 'KEBI13462'
UPDATE c_Drug_Brand SET brand_name = 'Heligo' WHERE brand_name_rxcui = 'KEBI5777'
UPDATE c_Drug_Brand SET brand_name = 'Heligone' WHERE brand_name_rxcui = 'KEBI10820'
UPDATE c_Drug_Brand SET brand_name = 'Infa-V' WHERE brand_name_rxcui = 'KEBI10723'
UPDATE c_Drug_Brand SET brand_name = 'Kemoyl' WHERE brand_name_rxcui = 'KEBI4015'
UPDATE c_Drug_Brand SET brand_name = 'Klenzit-C' WHERE brand_name_rxcui = 'KEBI6491'
UPDATE c_Drug_Brand SET brand_name = 'Lacoma-T' WHERE brand_name_rxcui = 'KEBI13777'
UPDATE c_Drug_Brand SET brand_name = 'Metrogyl' WHERE brand_name_rxcui = 'KEBI7193'
UPDATE c_Drug_Brand SET brand_name = 'Minoxin' WHERE brand_name_rxcui = 'KEBI6494'
UPDATE c_Drug_Brand SET brand_name = 'Nexiken' WHERE brand_name_rxcui = 'KEBI9106'
UPDATE c_Drug_Brand SET brand_name = 'nuclin-V' WHERE brand_name_rxcui = 'KEBI10561'
UPDATE c_Drug_Brand SET brand_name = 'Parafen' WHERE brand_name_rxcui = 'KEBI401'
UPDATE c_Drug_Brand SET brand_name = 'Vagiclin' WHERE brand_name_rxcui = 'KEBI14720'
UPDATE c_Drug_Brand SET brand_name = 'VDM' WHERE brand_name_rxcui = 'KEBI8977'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4558'
UPDATE c_Drug_Brand SET brand_name = 'Zolichek-T' WHERE brand_name_rxcui = 'KEBI10905'
UPDATE c_Drug_Brand SET brand_name = 'Zyrtal' WHERE brand_name_rxcui = 'KEBI13411'
UPDATE c_Drug_Brand SET brand_name = 'Pylodi' WHERE brand_name_rxcui = 'KEBI8744'
UPDATE c_Drug_Brand SET brand_name = 'Pylotrip' WHERE brand_name_rxcui = 'KEBI2120'
UPDATE c_Drug_Brand SET brand_name = 'Stednac' WHERE brand_name_rxcui = 'KEBI13589'


UPDATE c_Drug_Brand SET brand_name = 'ACTrapid' WHERE brand_name_rxcui = 'KEBI214'
UPDATE c_Drug_Brand SET brand_name = 'Adol' WHERE brand_name_rxcui = 'KEBI14370'
UPDATE c_Drug_Brand SET brand_name = 'Aerovent' WHERE brand_name_rxcui = 'KEBI8719'
UPDATE c_Drug_Brand SET brand_name = 'Amdocal' WHERE brand_name_rxcui = 'KEBI2166'
UPDATE c_Drug_Brand SET brand_name = 'Amdocal' WHERE brand_name_rxcui = 'KEBI2170'
UPDATE c_Drug_Brand SET brand_name = 'Amlozaar' WHERE brand_name_rxcui = 'KEBI6087'
UPDATE c_Drug_Brand SET brand_name = 'Amtas' WHERE brand_name_rxcui = 'KEBI5739'
UPDATE c_Drug_Brand SET brand_name = 'Amtel' WHERE brand_name_rxcui = 'KEBI10266'
UPDATE c_Drug_Brand SET brand_name = 'Aprovasc' WHERE brand_name_rxcui = 'KEBI9006'
UPDATE c_Drug_Brand SET brand_name = 'Aprovasc' WHERE brand_name_rxcui = 'KEBI7742'
UPDATE c_Drug_Brand SET brand_name = 'Aprovasc' WHERE brand_name_rxcui = 'KEBI9009'
UPDATE c_Drug_Brand SET brand_name = 'Aprovasc' WHERE brand_name_rxcui = 'KEBI9008'
UPDATE c_Drug_Brand SET brand_name = 'Azarga' WHERE brand_name_rxcui = 'KEBI6822'
UPDATE c_Drug_Brand SET brand_name = 'Azmasol' WHERE brand_name_rxcui = 'KEBI2307'
UPDATE c_Drug_Brand SET brand_name = 'Betrozole' WHERE brand_name_rxcui = 'KEBI7081'
UPDATE c_Drug_Brand SET brand_name = 'Bexitrol' WHERE brand_name_rxcui = 'KEBI2315'
UPDATE c_Drug_Brand SET brand_name = 'Bexitrol' WHERE brand_name_rxcui = 'KEBI2318'
UPDATE c_Drug_Brand SET brand_name = 'BronchoPed' WHERE brand_name_rxcui = 'KEBI8169'
UPDATE c_Drug_Brand SET brand_name = 'Budecort' WHERE brand_name_rxcui = 'KEBI8540'
UPDATE c_Drug_Brand SET brand_name = 'Cefo-L' WHERE brand_name_rxcui = 'KEBI11705'
UPDATE c_Drug_Brand SET brand_name = 'Citro-Soda' WHERE brand_name_rxcui = 'KEBI8170'
UPDATE c_Drug_Brand SET brand_name = 'Clindar' WHERE brand_name_rxcui = 'KEBI5293'
UPDATE c_Drug_Brand SET brand_name = 'Coartem' WHERE brand_name_rxcui = 'KEBI2470'
UPDATE c_Drug_Brand SET brand_name = 'Co-Artesiane' WHERE brand_name_rxcui = 'KEBI1505'
UPDATE c_Drug_Brand SET brand_name = 'Co-Diovan' WHERE brand_name_rxcui = 'KEBI2804'
UPDATE c_Drug_Brand SET brand_name = 'Co-Malather' WHERE brand_name_rxcui = 'KEBI11125'
UPDATE c_Drug_Brand SET brand_name = 'Co-Micardis' WHERE brand_name_rxcui = 'KEBI1154'
UPDATE c_Drug_Brand SET brand_name = 'Co-Micardis' WHERE brand_name_rxcui = 'KEBI1175'
UPDATE c_Drug_Brand SET brand_name = 'Diuride' WHERE brand_name_rxcui = 'KEBI3698'
UPDATE c_Drug_Brand SET brand_name = 'Duovent' WHERE brand_name_rxcui = 'KEBI2674'
UPDATE c_Drug_Brand SET brand_name = 'Galaxy''s' WHERE brand_name_rxcui = 'KEBI16548'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon' WHERE brand_name_rxcui = 'KEBI108'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon' WHERE brand_name_rxcui = 'KEBI3004'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon' WHERE brand_name_rxcui = 'KEBI235'
UPDATE c_Drug_Brand SET brand_name = 'Gaviscon' WHERE brand_name_rxcui = 'KEBI118'
UPDATE c_Drug_Brand SET brand_name = 'Grilinctus' WHERE brand_name_rxcui = 'KEBI11503'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' WHERE brand_name_rxcui = 'KEBI1207'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' WHERE brand_name_rxcui = 'KEBI1211'
UPDATE c_Drug_Brand SET brand_name = 'HumaLOG' WHERE brand_name_rxcui = 'KEBI1213'
UPDATE c_Drug_Brand SET brand_name = 'Hycin' WHERE brand_name_rxcui = 'KEBI1147'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan' WHERE brand_name_rxcui = 'KEBI5907Vial'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan' WHERE brand_name_rxcui = 'KEBI5907'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan' WHERE brand_name_rxcui = 'KEBI10906'
UPDATE c_Drug_Brand SET brand_name = 'InSUMan' WHERE brand_name_rxcui = 'KEBI10907'
UPDATE c_Drug_Brand SET brand_name = 'Koact' WHERE brand_name_rxcui = 'KEBI1754'
UPDATE c_Drug_Brand SET brand_name = 'Larither' WHERE brand_name_rxcui = 'KEBI718'
UPDATE c_Drug_Brand SET brand_name = 'Lemsip' WHERE brand_name_rxcui = 'KEBI215'
UPDATE c_Drug_Brand SET brand_name = 'Lonart' WHERE brand_name_rxcui = 'KEBI405'
UPDATE c_Drug_Brand SET brand_name = 'Lornex' WHERE brand_name_rxcui = 'KEBI11641'
UPDATE c_Drug_Brand SET brand_name = 'Lornex' WHERE brand_name_rxcui = 'KEBI11642'
UPDATE c_Drug_Brand SET brand_name = 'Levemir' WHERE brand_name_rxcui = 'KEBI297Pen'
UPDATE c_Drug_Brand SET brand_name = 'Levemir' WHERE brand_name_rxcui = 'KEBI297'
UPDATE c_Drug_Brand SET brand_name = 'Losec' WHERE brand_name_rxcui = 'KEBI7705'
UPDATE c_Drug_Brand SET brand_name = 'Losec' WHERE brand_name_rxcui = 'KEBI7706'
UPDATE c_Drug_Brand SET brand_name = 'Loxiam' WHERE brand_name_rxcui = 'KEBI9672'
UPDATE c_Drug_Brand SET brand_name = 'Lufanate' WHERE brand_name_rxcui = 'KEBI5430'
UPDATE c_Drug_Brand SET brand_name = 'Lum-Artem' WHERE brand_name_rxcui = 'KEBI1165'
UPDATE c_Drug_Brand SET brand_name = 'Lum-Artem' WHERE brand_name_rxcui = 'KEBI13036'
UPDATE c_Drug_Brand SET brand_name = 'Magnocid' WHERE brand_name_rxcui = 'KEBI3975'
UPDATE c_Drug_Brand SET brand_name = 'Malanil' WHERE brand_name_rxcui = 'KEBI3132'
UPDATE c_Drug_Brand SET brand_name = 'Malanil' WHERE brand_name_rxcui = 'KEBI3133'
UPDATE c_Drug_Brand SET brand_name = 'Met XL' WHERE brand_name_rxcui = 'KEBI1277'
UPDATE c_Drug_Brand SET brand_name = 'Methomine' WHERE brand_name_rxcui = 'KEBI3390'
UPDATE c_Drug_Brand SET brand_name = 'MIXTArd' WHERE brand_name_rxcui = 'KEBI191'
UPDATE c_Drug_Brand SET brand_name = 'MIXTArd' WHERE brand_name_rxcui = 'KEBI281Pen'
UPDATE c_Drug_Brand SET brand_name = 'MIXTArd' WHERE brand_name_rxcui = 'KEBI281'
UPDATE c_Drug_Brand SET brand_name = 'Moduretic' WHERE brand_name_rxcui = 'KEBI6951'
UPDATE c_Drug_Brand SET brand_name = 'Mono-Tildiem' WHERE brand_name_rxcui = 'KEBI5480'
UPDATE c_Drug_Brand SET brand_name = 'Mono-Tildiem' WHERE brand_name_rxcui = 'KEBI5477'
UPDATE c_Drug_Brand SET brand_name = 'Nebilong-5' WHERE brand_name_rxcui = 'KEBI6127'
UPDATE c_Drug_Brand SET brand_name = 'Neosanmag' WHERE brand_name_rxcui = 'KEBI891'
UPDATE c_Drug_Brand SET brand_name = 'Nolgripp' WHERE brand_name_rxcui = 'KEBI11049'
UPDATE c_Drug_Brand SET brand_name = 'Nolgripp' WHERE brand_name_rxcui = 'KEBI11050'
UPDATE c_Drug_Brand SET brand_name = 'NovoMIX' WHERE brand_name_rxcui = 'KEBI283Vial'
UPDATE c_Drug_Brand SET brand_name = 'NovoMIX' WHERE brand_name_rxcui = 'KEBI283Pen'
UPDATE c_Drug_Brand SET brand_name = 'NovoMIX' WHERE brand_name_rxcui = 'KEBI283'
UPDATE c_Drug_Brand SET brand_name = 'NovoRAPID' WHERE brand_name_rxcui = 'KEBI289Pen'
UPDATE c_Drug_Brand SET brand_name = 'NovoRAPID' WHERE brand_name_rxcui = 'KEBI289'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar' WHERE brand_name_rxcui = 'KEBI10827'
UPDATE c_Drug_Brand SET brand_name = 'Olmesar' WHERE brand_name_rxcui = 'KEBI10828'
UPDATE c_Drug_Brand SET brand_name = 'Nurofen' WHERE brand_name_rxcui = 'KEBI16475'
UPDATE c_Drug_Brand SET brand_name = 'Painotab' WHERE brand_name_rxcui = 'KEBI6917'
UPDATE c_Drug_Brand SET brand_name = 'Panadol' WHERE brand_name_rxcui = 'KEBI4005'
UPDATE c_Drug_Brand SET brand_name = 'Panadol' WHERE brand_name_rxcui = 'KEBI4110'
UPDATE c_Drug_Brand SET brand_name = 'Panadol' WHERE brand_name_rxcui = 'KEBI9594'
UPDATE c_Drug_Brand SET brand_name = 'Panadol' WHERE brand_name_rxcui = 'KEBI432'
UPDATE c_Drug_Brand SET brand_name = 'Panadol' WHERE brand_name_rxcui = 'KEBI4376'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4598'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4567'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4558-100'
UPDATE c_Drug_Brand SET brand_name = 'Ventolin' WHERE brand_name_rxcui = 'KEBI4558-128'
UPDATE c_Drug_Brand SET brand_name = 'Zerover' WHERE brand_name_rxcui = 'KEBI8009'
UPDATE c_Drug_Brand SET brand_name = 'Razid-M' WHERE brand_name_rxcui = 'KEBI3664'
UPDATE c_Drug_Brand SET brand_name = 'Shalcip-TZ' WHERE brand_name_rxcui = 'KEBI9410'
UPDATE c_Drug_Brand SET brand_name = 'Teltas' WHERE brand_name_rxcui = 'KEBI6211'
UPDATE c_Drug_Brand SET brand_name = 'Teltas' WHERE brand_name_rxcui = 'KEBI6216'
UPDATE c_Drug_Brand SET brand_name = 'Trabilin' WHERE brand_name_rxcui = 'KEBI4640'
UPDATE c_Drug_Brand SET brand_name = 'Steriject' WHERE brand_name_rxcui = 'KEBI10027'

update c_Drug_Formulation set ingr_rxcui = '135805' where ingr_rxcui = 'KEBI1207'
update c_Drug_Formulation set ingr_rxcui = '135805' where ingr_rxcui = 'KEBI1211'
update c_Drug_Formulation set ingr_rxcui = '135805' where ingr_rxcui = 'KEBI1213'
update c_Drug_Formulation set ingr_rxcui = '400560' where ingr_rxcui = 'KEBI297Pen'
update c_Drug_Formulation set ingr_rxcui = '400560' where ingr_rxcui = 'KEBI297'
update c_Drug_Formulation set ingr_rxcui = '8887' where ingr_rxcui = 'KEBI4567'
update c_Drug_Formulation set ingr_rxcui = '8887' where ingr_rxcui = 'KEBI4558-100'
update c_Drug_Formulation set ingr_rxcui = '8887' where ingr_rxcui = 'KEBI4558-128'
update c_Drug_Formulation set ingr_rxcui = '202432' where ingr_rxcui = 'KEBI4376'
update c_Drug_Formulation set ingr_rxcui = '202432' where ingr_rxcui = 'KEBI4005'
update c_Drug_Formulation set ingr_rxcui = '202432' where ingr_rxcui = 'KEBI4110'
update c_Drug_Formulation set ingr_rxcui = '202432' where ingr_rxcui = 'KEBI9594'
update c_Drug_Formulation set ingr_rxcui = '202432' where ingr_rxcui = 'KEBI432'
update c_Drug_Formulation set ingr_rxcui = '25655' where ingr_rxcui = 'KEBI108'
update c_Drug_Formulation set ingr_rxcui = '25655' where ingr_rxcui = 'KEBI235'
update c_Drug_Formulation set ingr_rxcui = '25655' where ingr_rxcui = 'KEBI3004'
update c_Drug_Formulation set ingr_rxcui = '718834' where ingr_rxcui = 'KEBI2470'

/* These go into Packs (contain { } */

INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI4662','Artequin',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB4662','Artequin-300/375 Lactab','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4662','{ 3 (artesunate 100 MG Oral Tablet) / 3 (mefloquine 125 MG Oral Tablet) } Pack','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4662','')
INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB4664','Artequin-600/750 Lactab','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4664','{ 3 (artesunate 200 MG Oral Tablet) / 3 (mefloquine 250 MG Oral Tablet) } Pack','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4664','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13286','Azflor',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB13286','Azflor Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG13286','{ 2 (azithromycin 500 MG Oral Tablet) / 1 (fluconazole 150 MG Oral Capsule) / 2 ( ornidazole 750 MG Oral Tablet) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13286','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI1532','Co-Arinate',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB1532','Co-Arinate FDC Adult','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG1532','{3 (artesunate 200 MG / sulfamethoxypyrazine 500 MG / pyrimethamine 25 MG Oral Tablet) } Pack','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1532','')
 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB1527','Co-Arinate FDC Junior','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG1527','{3 (artesunate 100 MG / sulfamethoxypyrazine 250 MG / pyrimethamine 12.5 MG Oral Tablet) } Pack','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE1527','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI480','Coldcap',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB480','Coldcap Daytime and Night time Oral Capsules Pack','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG480','{12 (paracetamol 500 MG / caffeine 30 MG / pseudoephedrine 30 MG Oral Capsule) 12 (paracetamol 500 MG / chlorpheniramine maleate 2 MG Oral Capsule ) } Pack','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE480','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8620','Esclam',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB8620','Esclam H. Pylori Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG8620','7 { 2 (esomeprazole USP 20 MG Oral Tablet) / 2 (clarithromycin USP 500 MG Oral Tablet) / 2 (amoxicillin 1000 MG Oral Tablet) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8620','')
 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB14713','Esose H. Pylori Kit','SBD_KE') 		INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG14713','7 { 1 (esomeprazole 40 MG Oral Tablet ) / 1 (levofloxacin 500 MG Oral Tablet ) / 2 (amoxicillin 500 MG Oral Capsule ) Morning Pack / 1 (esomeprazole 40 MG Oral Tablet ) / 1 (levofloxacin 500 MG Oral Tablet ) / 2 (amoxicillin 500 MG Oral Capsule ) Evening Pack } Kit','SCD_KE')	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE14713','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI13462','H-Cure',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB13462','H-Cure ES Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG13462','7 { 2 (esomeprazole 40 MG Oral Capsule) / 2 (clarithromycin USP 500 MG Oral Tablet) / 2 (tinidazole 500 MG Oral Tablet) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE13462','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI11423','Helicoban',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB11423','Helicoban Oral Capsules Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG11423','7 { 2 (omeprazole BP 20 MG Oral Capsule) / 2 (clarithromycin USP 250 MG Oral Capsule) / 2 (tinidazole BP 500 MG Oral Capsule) }','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE11423','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI5777','Heligo',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB5777','Heligo H. Pylori Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG5777','7 { 2 (lansoprazole 30 MG Oral Capsule) / 2 (clarithromycin 250 MG Oral Tablet) / 2 (tinidazole 500 MG Oral Tablet) }','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE5777','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI10820','Heligone',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB10820','Heligone Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG10820','{ 6 (azithromycin 500 MG Oral Tablet) / 28 (amoxicillin 500 MG Oral Capsule) / 14 (omeprazole 20 MG Oral Capsule) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE10820','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI9106','Nexiken',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB9106','Nexiken H. Pylori Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG9106','7 { 2 (esomeprazole 20 MG Delayed Release Oral Tablet) / 2 (clarithromycin USP 500 MG Oral Tablet) / 2 (amoxicillin 1000 MG Oral Tablet ) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE9106','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8744','Pylodi',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB8744','Pylodi H. Pylori Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG8744','7 { 2 (lansoprazole USP 30 MG Oral Capsule) / 2 (clarithromycin USP 500 MG Oral Tablet) / 2 (tinidazole BP 500 MG Oral Tablet) }','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8744','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI2120','Pylotrip',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB2120','Pylotrip H. Pylori Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG2120','7 { 2 (lansoprazole USP 30 MG Delayed Release Capsule) / 2 (amoxicillin USP 1000 MG Oral Capsule) / 2 (clarithromycin USP 500 MG Oral Tablet) }','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE2120','')
 INSERT INTO c_Drug_Brand (brand_name_rxcui, brand_name, is_single_ingredient) VALUES ('KEBI8977','VDM Kit',0) 	 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB8977','VDM Kit','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG8977','{ 1 (azithromycin 1000 MG Oral Tablet) / 1 (fluconazole 150 MG Oral Tablet) / 2 ( secnidazole 1000 MG Oral Tablet) } Kit','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE8977','')
 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB4558-100','Ventolin Rotacaps 100 Capsules','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4558-100','salbutamol 100 Capsules','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4558-100','')
 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEB4558-128','Ventolin Rotacaps 128 Capsules','SBD_KE') 		 INSERT INTO c_Drug_Pack (rxcui, descr, tty) VALUES ('KEG4558-128','salbutamol 128 Capsules','SCD_KE') 	insert into c_Drug_Addition (country,country_drug_id, rxcui) values ('ke','KE4558-128','')

UPDATE c_Drug_Formulation SET ingr_rxcui = left(form_rxcui, 3) + 'I' + substring(form_rxcui,4,20)
WHERE ingr_rxcui IS NULL AND left(form_rxcui,2) = 'KE'

UPDATE c_Drug_Formulation
 SET valid_in = 'ke;' where form_rxcui like 'KE%'

UPDATE c_Drug_Pack
 SET valid_in = 'ke;' where rxcui like 'KE%'

SELECT count(*) FROM c_Drug_Formulation d
WHERE  
	NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Generic g WHERE g.generic_rxcui = d.ingr_rxcui)
	AND NOT EXISTS (SELECT drug_id 
		FROM c_Drug_Brand b WHERE b.brand_name_rxcui = d.ingr_rxcui)

DELETE g FROM c_Drug_Generic g
WHERE NOT EXISTS (SELECT ingr_rxcui 
	FROM c_Drug_Formulation f 
	WHERE g.generic_rxcui = f.ingr_rxcui)
AND EXISTS (SELECT 1 
	FROM c_Drug_Generic g1 
	WHERE g1.generic_name = g.generic_name
	AND left(g1.generic_rxcui,2) != 'KE')

DELETE g FROM c_Drug_Brand g
WHERE NOT EXISTS (SELECT ingr_rxcui 
	FROM c_Drug_Formulation f 
	WHERE g.brand_name_rxcui = f.ingr_rxcui)
AND EXISTS (SELECT 1 
	FROM c_Drug_Brand g1 
	WHERE g1.brand_name = g.brand_name
	AND left(g1.brand_name_rxcui,2) != 'KE')

-- Deduplicate brand names before assigning drug_ids
SELECT brand_name, MIN(brand_name_rxcui) as chosen_brand_rxcui
INTO #chosen_ones
FROM c_Drug_Brand
GROUP BY brand_name
HAVING count(*) > 1

SELECT brand_name, brand_name_rxcui, drug_id
INTO #all_dupes
FROM c_Drug_Brand
WHERE brand_name IN (SELECT brand_name from #chosen_ones)

UPDATE f
SET ingr_rxcui = c.chosen_brand_rxcui
FROM c_Drug_Formulation f
JOIN #all_dupes b ON b.brand_name_rxcui = f.ingr_rxcui
JOIN #chosen_ones c ON c.brand_name = b.brand_name
AND c.chosen_brand_rxcui != f.ingr_rxcui

DELETE g
FROM c_Drug_Brand g
WHERE brand_name IN (SELECT brand_name from #chosen_ones)
AND NOT EXISTS (SELECT ingr_rxcui 
	FROM c_Drug_Formulation f 
	WHERE g.brand_name_rxcui = f.ingr_rxcui)

DELETE b FROM c_Drug_Brand b
WHERE brand_name IN (SELECT brand_name from #chosen_ones)
AND brand_name_rxcui NOT IN (SELECT brand_name_rxcui from #chosen_ones)


-- Add drug_ids and generic_rxcui for brands that have none
UPDATE b
SET generic_rxcui = f.ingr_rxcui select 
FROM c_Drug_Brand b
JOIN c_Drug_Addition a ON a.country_drug_id = replace(b.brand_name_rxcui, 'KEBI', 'KE')
JOIN c_Drug_Formulation f ON f.form_rxcui = substring(RTRIM(LTRIM(a.rxcui)),5,20)
WHERE generic_rxcui IS NULL
AND RTRIM(LTRIM(a.rxcui)) LIKE 'SCD-%'
-- (252 row(s) affected)

UPDATE b
SET generic_rxcui = g.generic_rxcui
FROM c_Drug_Brand b
JOIN c_Drug_Generic g on g.generic_rxcui = replace(b.brand_name_rxcui, 'KEB', 'KEG')
WHERE b.generic_rxcui IS NULL
AND b.brand_name_rxcui like 'KE%'
-- (124 row(s) affected)

-- Will need to retrieve these separately (RXNORM full set)
/*
select b.brand_name, b.brand_name_rxcui, f.form_descr, c2.[STR], c2.rxcui as generic_rxcui_min
FROM c_Drug_Brand b
JOIN c_Drug_Addition a ON a.country_drug_id = replace(b.brand_name_rxcui, 'KEBI', 'KE')
JOIN c_Drug_Formulation f ON f.ingr_rxcui = b.brand_name_rxcui
JOIN [DESKTOP-GU15HUD\ENCOUNTERPRO].interfaces.dbo.rxnrel_full r ON r.rxcui2 = substring(RTRIM(LTRIM(a.rxcui)),5,20)
JOIN [DESKTOP-GU15HUD\ENCOUNTERPRO].interfaces.dbo.rxnconso_full c2 ON c2.rxcui = r.rxcui1
WHERE generic_rxcui IS NULL
AND RTRIM(LTRIM(a.rxcui)) LIKE 'SCD-%'
AND brand_name_rxcui like 'KE%'
AND c2.TTY = 'MIN'

brand_name	brand_name_rxcui	form_descr	STR	generic_rxcui_min
Fanlar	KEBI1093	Fanlar 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Lacoma-T	KEBI13777	Lacoma - T Eye Drops	latanoprost / Timolol	388053
Deep Relief	KEBI1500	Deep Relief Anti-Inflammatory Topical Gel	Ibuprofen / LEVOMENTHOL	687386
Malacide	KEBI2253	Malacide 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Malodar	KEBI2253R	Malodar 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Methomine	KEBI3390	Methomine - S 500 MG / 25 MG Oral Tablet	Pyrimethamine / Sulfadoxine	203218
Nilol	KEBI5858	Nilol 20 MG / 50 MG Oral Tablet	Atenolol / Nifedipine	392475
select * from c_Drug_Generic where  generic_rxcui in ('203218','388053','687386','392475')
*/

-- Generics haven't been duplicated
SELECT generic_name, MIN(generic_rxcui) as chosen_generic_rxcui
FROM c_Drug_Generic g
WHERE drug_id IS NULL
AND EXISTS (SELECT 1 FROM c_Drug_Generic g1
		WHERE g1.generic_name = g.generic_name
		AND g1.generic_rxcui != g.generic_rxcui)
GROUP BY generic_name

-- Find Kenya drugs which match existing EncounterPro drug_ids
INSERT INTO c_Drug_Definition
(	[drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[controlled_substance_flag]
      ,[default_duration_amount]
      ,[default_duration_unit]
      ,[default_duration_prn]
      ,[max_dose_per_day]
      ,[max_dose_unit]
      ,[status]
      ,[last_updated]
      ,[owner_id]
      ,[patient_reference_material_id]
      ,[provider_reference_material_id]
      ,[dea_schedule]
      ,[dea_number]
      ,[dea_narcotic_status]
      ,[procedure_id]
      ,[reference_ndc_code]
      ,[fda_generic_available]
      ,[available_strengths]
      ,[is_generic]
)
SELECT d2.[drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[controlled_substance_flag]
      ,[default_duration_amount]
      ,[default_duration_unit]
      ,[default_duration_prn]
      ,[max_dose_per_day]
      ,[max_dose_unit]
      ,[status]
      ,[last_updated]
      ,[owner_id]
      ,[patient_reference_material_id]
      ,[provider_reference_material_id]
      ,[dea_schedule]
      ,[dea_number]
      ,[dea_narcotic_status]
      ,[procedure_id]
      ,[reference_ndc_code]
      ,[fda_generic_available]
      ,[available_strengths]
      ,[is_generic]
FROM c_Drug_Brand b
JOIN c_Drug_Definition_archive d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- 4 rows

DELETE d2 
FROM c_Drug_Brand b
JOIN c_Drug_Definition_archive d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- 4 rows

UPDATE b
SET drug_id = d2.drug_id
FROM c_Drug_Brand b
JOIN c_Drug_Definition d2 ON d2.common_name = b.brand_name
WHERE b.drug_id is null
-- (6 row(s) affected)

-- No existing EncounterPro generics match Kenya drugs (archive neither)
select * FROM c_Drug_Generic g
JOIN c_Drug_Definition d2 ON d2.generic_name = g.generic_name
WHERE g.drug_id is null

-- Create drug_definition records for Kenya drugs
INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT generic_rxcui, generic_name, generic_name
FROM c_Drug_Generic 
WHERE drug_id is null

UPDATE c_Drug_Generic
SET drug_id = generic_rxcui
WHERE drug_id is null

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT brand_name_rxcui, brand_name, generic_name
FROM c_Drug_Brand b
LEFT JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id is null
-- (621 row(s) affected)

UPDATE c_Drug_Brand
SET drug_id = brand_name_rxcui
WHERE drug_id is null
