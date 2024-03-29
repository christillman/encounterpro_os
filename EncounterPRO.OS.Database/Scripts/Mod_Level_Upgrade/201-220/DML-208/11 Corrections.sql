/*
select count(*) from c_Drug_Package dp
JOIN c_Package p ON p.package_id = dp.package_id
-- 5360

SELECT [drug_id]
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
	  into #brand
  FROM [dbo].[c_Drug_Definition] d
  WHERE NOT EXISTS (SELECT drug_id 
	FROM EncounterPro_OS.dbo.c_Drug_Generic g WHERE g.drug_id = d.drug_id)
  AND NOT EXISTS (SELECT drug_id 
	FROM EncounterPro_OS.dbo.c_Drug_Brand b WHERE b.drug_id = d.drug_id)
AND status != 'OBS'
  and drug_id in (select drug_id FROM c_Drug_Package)
  and common_name != generic_name
  order by common_name

  select b.brand_name, b.drug_id, t.common_name, t.drug_id, 'UPDATE c_Drug_Brand SET drug_id = ''' + t.drug_id + ''' WHERE drug_id = ''' + b.drug_id + '''
DELETE FROM c_Drug_Definition WHERE drug_id = ''' + b.drug_id + '''
'
 from c_Drug_Brand b
  join #brand t on b.brand_name like '%' + left(t.common_name,10) + '%'
    order by t.common_name, b.brand_name

  delete d from #brand d where EXISTS (SELECT drug_id 
	FROM EncounterPro_OS.dbo.c_Drug_Brand g WHERE g.drug_id = d.drug_id)
 
select g.generic_name, t.common_name, g.drug_id, t.drug_id, 'UPDATE c_Drug_Generic SET drug_id = ''' + t.drug_id + ''' WHERE drug_id = ''' + g.drug_id + '''
DELETE FROM c_Drug_Definition WHERE drug_id = ''' + g.drug_id + '''
' 
from c_Drug_Generic g
  join #generic t on g.generic_name like '%' + left(t.common_name,5) + '%'
  order by t.common_name, g.generic_name
*/
-- Better mappings to existing EncounterPro drugs
UPDATE c_Drug_Brand SET drug_id = 'Aralen' WHERE drug_id = 'RXNB215392'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB215392'
UPDATE c_Drug_Brand SET drug_id = 'AugmentinES' WHERE brand_name_rxcui = 'KEBI2739'
UPDATE c_Drug_Brand SET drug_id = 'AVC' WHERE drug_id = 'RXNB214949'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB214949'
UPDATE c_Drug_Brand SET drug_id = 'BCG' WHERE drug_id = 'RXNB94317'
UPDATE c_Drug_Definition SET common_name = 'Tice BCG' WHERE drug_id = 'BCG'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB94317'
UPDATE c_Drug_Brand SET drug_id = 'BenadrylAllergyConge' WHERE drug_id = 'RXNB1926216'
UPDATE c_Drug_Definition SET common_name = 'Benadryl Allergy Plus Congestion' WHERE drug_id = 'BenadrylAllergyConge'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB1926216'
UPDATE c_Drug_Brand SET drug_id = '981^17' WHERE drug_id = 'RXNB827261'
UPDATE c_Drug_Definition SET common_name = 'Sudafed PE Children''s Cold & Cough' WHERE drug_id = '981^17'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB827261'
UPDATE c_Drug_Brand SET drug_id = '981^18' WHERE drug_id = 'RXNB827261'
UPDATE c_Drug_Definition SET common_name = 'Sudafed PE Children''s Cold & Cough' WHERE drug_id = '981^18'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB827261'
UPDATE c_Drug_Brand SET drug_id = 'ChlorTrimetron' WHERE drug_id = 'RXNB202384'
UPDATE c_Drug_Definition SET common_name = 'Chlor-Trimeton' WHERE drug_id = 'ChlorTrimetron'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB202384'
UPDATE c_Drug_Brand SET drug_id = 'ChloromycetinOpthalmic' WHERE drug_id = 'RXNB151508'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB151508'
UPDATE c_Drug_Brand SET drug_id = 'ClaritinD12Hour' WHERE drug_id = 'RXNB216076'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB216076'
UPDATE c_Drug_Brand SET drug_id = 'CortisporinTCOtic' WHERE drug_id = 'RXNB216244'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB216244'
UPDATE c_Drug_Brand SET drug_id = 'DermaSmootheFS' WHERE drug_id = 'RXNB352578'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB352578'
UPDATE c_Drug_Brand SET drug_id = 'Fioricetw/Codeine' WHERE drug_id = 'RXNB217126'
UPDATE c_Drug_Definition SET common_name = 'Fioricet with Codeine' WHERE drug_id = 'Fioricetw/Codeine'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB217126'
UPDATE c_Drug_Brand SET drug_id = 'FiorinalCod' WHERE drug_id = 'RXNB217127'
UPDATE c_Drug_Definition SET common_name = 'Fiorinal with Codeine' WHERE drug_id = 'FiorinalCod'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB217127'
UPDATE c_Drug_Brand SET drug_id = 'FMLForte' WHERE drug_id = 'RXNB92675'
UPDATE c_Drug_Definition SET common_name = 'FML Forte Liquifilm' WHERE drug_id = 'FMLForte'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB92675'
UPDATE c_Drug_Brand SET drug_id = 'HMS' WHERE drug_id = 'RXNB992742'
UPDATE c_Drug_Definition SET common_name = 'HMS Suspension' WHERE drug_id = 'HMS'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB992742'
UPDATE c_Drug_Brand SET drug_id = 'HumaLOGMix7525' WHERE drug_id = 'RXNB261542'
UPDATE c_Drug_Definition SET common_name = 'Humalog Mix' WHERE drug_id = 'HumaLOGMix7525'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB261542'
UPDATE c_Drug_Brand SET drug_id = 'LacriLubeNP' WHERE drug_id = 'RXNB1245120'
UPDATE c_Drug_Definition SET common_name = 'Refresh Lacri-Lube' WHERE drug_id = 'LacriLubeNP'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB1245120'
UPDATE c_Drug_Brand SET drug_id = 'Lortab' WHERE drug_id = 'RXNB144254'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB144254'
UPDATE c_Drug_Brand SET drug_id = 'Moisturel' WHERE drug_id = 'RXNB1146125'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB1146125'
UPDATE c_Drug_Brand SET drug_id = 'NeosporinGU.' WHERE drug_id = 'RXNB218680'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB218680'
UPDATE c_Drug_Brand SET drug_id = 'Nix' WHERE drug_id = 'RXNB218756'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB218756'
UPDATE c_Drug_Brand SET drug_id = 'OsCal' WHERE drug_id = 'RXNB218959'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB218959'
UPDATE c_Drug_Brand SET drug_id = 'OsCal500' WHERE drug_id = 'RXNB1243353'
UPDATE c_Drug_Definition SET common_name = 'Os-Cal 500 with D' WHERE drug_id = 'OsCal500'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB1243353'
UPDATE c_Drug_Brand SET drug_id = 'Paser' WHERE drug_id = 'RXNB219113'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB219113'
UPDATE c_Drug_Brand SET drug_id = 'Penlac' WHERE drug_id = 'RXNB262135'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB262135'
UPDATE c_Drug_Brand SET drug_id = 'RobitussinDM' WHERE drug_id = 'RXNB827249'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB827249'
UPDATE c_Drug_Brand SET drug_id = 'Surfak' WHERE drug_id = 'RXNB220130'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB220130'

UPDATE c_Drug_Brand SET drug_id = 'TAR' WHERE drug_id = 'RXNB92309'
UPDATE c_Drug_Definition SET common_name = 'DHS Tar Shampoo' WHERE drug_id = 'TAR'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB92309'
UPDATE c_Drug_Brand SET drug_id = 'UTA' WHERE drug_id = 'RXNB1738131'
UPDATE c_Drug_Definition SET common_name = 'UTA Capsule Reformulated Feb 2016' WHERE drug_id = 'UTA'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB1738131'
UPDATE c_Drug_Brand SET drug_id = 'Vicodin' WHERE drug_id = 'RXNB128793'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB128793'

-- Generic
UPDATE c_Drug_Generic SET drug_id = 'Acacia' WHERE drug_id = 'RXNG851732'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851732'
UPDATE c_Drug_Generic SET drug_id = 'Adenovirus' WHERE drug_id = 'RXNG1099933'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1099933'
UPDATE c_Drug_Generic SET drug_id = 'Alfalfa' WHERE drug_id = 'RXNG852634'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852634'
UPDATE c_Drug_Generic SET drug_id = 'Allspice' WHERE drug_id = 'RXNG895552'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG895552'
UPDATE c_Drug_Generic SET drug_id = 'Almond' WHERE drug_id = 'RXNG892507'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892507'
UPDATE c_Drug_Generic SET drug_id = 'Aternariatenius' WHERE drug_id = 'RXNG901845'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG901845'
UPDATE c_Drug_Generic SET drug_id = 'AmitriptylineHCl' WHERE drug_id = 'RXNG704'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG704'
UPDATE c_Drug_Generic SET drug_id = 'Amprenavir' WHERE drug_id = 'RXNG358262'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG358262'
UPDATE c_Drug_Generic SET drug_id = 'Aspen' WHERE drug_id = 'RXNG852339'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852339'
UPDATE c_Drug_Generic SET drug_id = 'Aspergillusfuming.' WHERE drug_id = 'RXNG466192'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG466192'
UPDATE c_Drug_Generic SET drug_id = 'Aspergillusniger' WHERE drug_id = 'RXNG1006297'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1006297'
UPDATE c_Drug_Generic SET drug_id = 'Bahia' WHERE drug_id = 'RXNG852673'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852673'
UPDATE c_Drug_Generic SET drug_id = 'Banana' WHERE drug_id = 'RXNG891830'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG891830'
UPDATE c_Drug_Generic SET drug_id = 'BermudaGrass' WHERE drug_id = 'RXNG851906'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851906'
UPDATE c_Drug_Generic SET drug_id = 'Bermudagrasssmut' WHERE drug_id = 'RXNG1014385'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1014385'
UPDATE c_Drug_Generic SET drug_id = 'Bluegrass,KentuckyJune' WHERE drug_id = 'RXNG852834'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852834'
UPDATE c_Drug_Generic SET drug_id = 'Bluegrass,KentuckyJune' WHERE drug_id = 'RXNG898404'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG898404'
UPDATE c_Drug_Generic SET drug_id = 'Boxelder' WHERE drug_id = 'RXNG851740'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851740'
UPDATE c_Drug_Generic SET drug_id = 'Canaryfeathers' WHERE drug_id = 'RXNG894961'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG894961'
UPDATE c_Drug_Generic SET drug_id = 'Candidaalbicans' WHERE drug_id = 'RXNG214355'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG214355'
UPDATE c_Drug_Generic SET drug_id = 'Catdander' WHERE drug_id = 'RXNG465953'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG465953'
UPDATE c_Drug_Generic SET drug_id = 'Chickenfeathers' WHERE drug_id = 'RXNG894934'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG894934'
UPDATE c_Drug_Generic SET drug_id = 'Chocolate' WHERE drug_id = 'RXNG1010915'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1010915'
UPDATE c_Drug_Generic SET drug_id = 'Cholestyramine' WHERE drug_id = 'RXNG2447'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG2447'
UPDATE c_Drug_Generic SET drug_id = 'Cladosporidiumherb.' WHERE drug_id = 'RXNG466198'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG466198'
UPDATE c_Drug_Generic SET drug_id = 'Clam' WHERE drug_id = 'RXNG892539'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892539'
UPDATE c_Drug_Generic SET drug_id = 'Cocklebur' WHERE drug_id = 'RXNG880341'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG880341'
UPDATE c_Drug_Generic SET drug_id = 'CockroachAmerican' WHERE drug_id = 'RXNG905258'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG905258'
UPDATE c_Drug_Generic SET drug_id = 'CockroachGerman' WHERE drug_id = 'RXNG905276'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG905276'
UPDATE c_Drug_Generic SET drug_id = 'Corn' WHERE drug_id = 'RXNG852015'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852015'
UPDATE c_Drug_Generic SET drug_id = 'Cottonseed' WHERE drug_id = 'RXNG852440'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852440'
UPDATE c_Drug_Generic SET drug_id = 'Cottonwood,Black' WHERE drug_id = 'RXNG852376'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852376'
UPDATE c_Drug_Generic SET drug_id = 'Cottonwood,Fremont' WHERE drug_id = 'RXNG852355'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852355'
UPDATE c_Drug_Generic SET drug_id = 'Crab' WHERE drug_id = 'RXNG892610'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892610'
UPDATE c_Drug_Generic SET drug_id = 'Curvulariaspecifera' WHERE drug_id = 'RXNG999438'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG999438'
UPDATE c_Drug_Generic SET drug_id = 'Dandelion' WHERE drug_id = 'RXNG852079'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852079'
UPDATE c_Drug_Generic SET drug_id = 'DesmopressinAcetate' WHERE drug_id = 'RXNG3251'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG3251'
UPDATE c_Drug_Generic SET drug_id = 'DicloxacillinSodium' WHERE drug_id = 'RXNG3356'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG3356'
UPDATE c_Drug_Generic SET drug_id = 'DoxycyclineCalcium' WHERE drug_id = 'RXNG3640'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG3640'
UPDATE c_Drug_Generic SET drug_id = 'Duckfeathers' WHERE drug_id = 'RXNG892851'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892851'
UPDATE c_Drug_Generic SET drug_id = 'Eggwhite' WHERE drug_id = 'RXNG892616'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892616'
UPDATE c_Drug_Generic SET drug_id = 'Epicoccumpur.' WHERE drug_id = 'RXNG852466'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852466'
UPDATE c_Drug_Generic SET drug_id = 'ErgoloidMesylates' WHERE drug_id = 'RXNG4024'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG4024'
UPDATE c_Drug_Generic SET drug_id = 'Eucalyptus' WHERE drug_id = 'RXNG852386'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852386'
UPDATE c_Drug_Generic SET drug_id = 'FescueGrass,Meadow' WHERE drug_id = 'RXNG851918'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851918'
UPDATE c_Drug_Generic SET drug_id = 'Geotrichumcandida' WHERE drug_id = 'RXNG999463'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG999463'
UPDATE c_Drug_Generic SET drug_id = 'Goosefeathers' WHERE drug_id = 'RXNG894783'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG894783'
UPDATE c_Drug_Generic SET drug_id = 'GuineaPig,Epitheli' WHERE drug_id = 'RXNG852298'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852298'
UPDATE c_Drug_Generic SET drug_id = 'Hackberry' WHERE drug_id = 'RXNG852324'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852324'
UPDATE c_Drug_Generic SET drug_id = 'Helminthosporiums.' WHERE drug_id = 'RXNG867232'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG867232'
UPDATE c_Drug_Generic SET drug_id = 'Honeybee' WHERE drug_id = 'RXNG854163'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG854163'
UPDATE c_Drug_Generic SET drug_id = 'IpratropiumBromide' WHERE drug_id = 'RXNG7213'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG7213'
UPDATE c_Drug_Generic SET drug_id = 'Johnsongrass' WHERE drug_id = 'RXNG852136'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852136'
UPDATE c_Drug_Generic SET drug_id = 'Kapoc' WHERE drug_id = 'RXNG852315'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852315'
UPDATE c_Drug_Generic SET drug_id = 'Karayagum' WHERE drug_id = 'RXNG904554'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG904554'
UPDATE c_Drug_Generic SET drug_id = 'Lobster' WHERE drug_id = 'RXNG892561'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892561'
UPDATE c_Drug_Generic SET drug_id = 'MangoBlossom' WHERE drug_id = 'RXNG1006371'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1006371'
UPDATE c_Drug_Generic SET drug_id = 'MarshelderRough' WHERE drug_id = 'RXNG852532'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852532'
UPDATE c_Drug_Generic SET drug_id = 'Misquite' WHERE drug_id = 'RXNG852320'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852320'
UPDATE c_Drug_Generic SET drug_id = 'MethotrexateSodium' WHERE drug_id = 'RXNG6851'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG6851'
UPDATE c_Drug_Generic SET drug_id = 'MethylphenidateHCI' WHERE drug_id = 'RXNG6901'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG6901'
UPDATE c_Drug_Generic SET drug_id = 'Mexicantea' WHERE drug_id = 'RXNG897391'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG897391'
UPDATE c_Drug_Generic SET drug_id = 'Mucorplumbeus' WHERE drug_id = 'RXNG314415'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG314415'
UPDATE c_Drug_Generic SET drug_id = 'Orange' WHERE drug_id = 'RXNG892565'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892565'
UPDATE c_Drug_Generic SET drug_id = 'OrchardGrass' WHERE drug_id = 'RXNG851878'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851878'
UPDATE c_Drug_Generic SET drug_id = 'Orrisroot' WHERE drug_id = 'RXNG1098353'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1098353'
UPDATE c_Drug_Generic SET drug_id = 'Parakeetfeathers' WHERE drug_id = 'RXNG1192987'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1192987'
UPDATE c_Drug_Generic SET drug_id = 'Peanut' WHERE drug_id = 'RXNG891658'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG891658'
UPDATE c_Drug_Generic SET drug_id = 'Pecan' WHERE drug_id = 'RXNG892332'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892332'
UPDATE c_Drug_Generic SET drug_id = 'PhenazopyridineHCI' WHERE drug_id = 'RXNG8120'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG8120'
UPDATE c_Drug_Generic SET drug_id = 'Privet' WHERE drug_id = 'RXNG852622'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852622'
UPDATE c_Drug_Generic SET drug_id = 'Pyrethrum' WHERE drug_id = 'RXNG967970'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG967970'
UPDATE c_Drug_Generic SET drug_id = 'Rice' WHERE drug_id = 'RXNG901337'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG901337'
UPDATE c_Drug_Generic SET drug_id = 'Ryepollen' WHERE drug_id = 'RXNG900148'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG900148'
UPDATE c_Drug_Generic SET drug_id = 'Saccharomycessc.' WHERE drug_id = 'RXNG9511'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG9511'
UPDATE c_Drug_Generic SET drug_id = 'Soybean' WHERE drug_id = 'RXNG891668'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG891668'
UPDATE c_Drug_Generic SET drug_id = 'SugarBeet' WHERE drug_id = 'RXNG899359'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG899359'
UPDATE c_Drug_Generic SET drug_id = 'SweetGum' WHERE drug_id = 'RXNG852627'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852627'
UPDATE c_Drug_Generic SET drug_id = 'Sweetvernal' WHERE drug_id = 'RXNG851898'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851898'
UPDATE c_Drug_Generic SET drug_id = 'Testosterone' WHERE drug_id = 'RXNG10379'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG10379'
UPDATE c_Drug_Generic SET drug_id = 'TimothyGrass' WHERE drug_id = 'RXNG851994'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851994'
UPDATE c_Drug_Generic SET drug_id = 'TobaccoLeaf' WHERE drug_id = 'RXNG852062'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852062'
UPDATE c_Drug_Generic SET drug_id = 'Tomato' WHERE drug_id = 'RXNG892499'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG892499'
UPDATE c_Drug_Generic SET drug_id = 'Tragacanthgum' WHERE drug_id = 'RXNG1232630'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1232630'
UPDATE c_Drug_Generic SET drug_id = 'TriamcinoloneDiacetate' WHERE drug_id = 'Triamcinolone'
DELETE FROM c_Drug_Definition WHERE drug_id = 'Triamcinolone'
UPDATE c_Drug_Generic SET drug_id = 'Trichodermaviride' WHERE drug_id = 'RXNG968401'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG968401'
UPDATE c_Drug_Generic SET drug_id = 'Trichophytonrubrum' WHERE drug_id = 'RXNG968413'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG968413'
UPDATE c_Drug_Generic SET drug_id = 'Tropicamide/NeoSynephrin' WHERE drug_id = 'RXNG1008101'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1008101'
UPDATE c_Drug_Generic SET drug_id = 'Tropicamide/NeoSynephrin' WHERE drug_id = 'Tropicamide'
DELETE FROM c_Drug_Definition WHERE drug_id = 'Tropicamide'
UPDATE c_Drug_Generic SET drug_id = 'Wasp' WHERE drug_id = 'RXNG260051'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG260051'
UPDATE c_Drug_Generic SET drug_id = 'Wheatpollen' WHERE drug_id = 'RXNG867361'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG867361'
UPDATE c_Drug_Generic SET drug_id = 'MixedYellowJacket' WHERE drug_id = 'RXNG285170'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG285170'


UPDATE c_Drug_Generic SET drug_id = 'Alder,red' WHERE drug_id = 'RXNG851914'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851914'
UPDATE c_Drug_Generic SET drug_id = 'Alder,Tagsmooth' WHERE drug_id = 'RXNG851902'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851902'
UPDATE c_Drug_Generic SET drug_id = 'Alder,White' WHERE drug_id = 'RXNG851910'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851910'
UPDATE c_Drug_Generic SET drug_id = 'Aspirinw/Caffeine' WHERE drug_id = 'RXNG214250'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG214250'
UPDATE c_Drug_Generic SET drug_id = 'Atropine' WHERE drug_id = 'RXNG1223'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1223'
UPDATE c_Drug_Generic SET drug_id = 'Benzoyleperoxide' WHERE drug_id = 'RXNG1418'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1418'
UPDATE c_Drug_Generic SET drug_id = 'Birch,Redriver' WHERE drug_id = 'RXNG852148'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852148'
UPDATE c_Drug_Generic SET drug_id = 'Botrytiscinera' WHERE drug_id = 'RXNG466195'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG466195'
UPDATE c_Drug_Generic SET drug_id = 'Bupivicaine' WHERE drug_id = 'RXNG1815'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG1815'
UPDATE c_Drug_Generic SET drug_id = 'CALAMYNE' WHERE drug_id = 'RXNG106212'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG106212'
UPDATE c_Drug_Generic SET drug_id = 'Cedar,Mountain' WHERE drug_id = 'RXNG852581'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852581'
UPDATE c_Drug_Generic SET drug_id = 'Cedar,Red' WHERE drug_id = 'RXNG852609'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852609'
UPDATE c_Drug_Generic SET drug_id = 'Cedar,Salttamarisk' WHERE drug_id = 'RXNG852806'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852806'
UPDATE c_Drug_Generic SET drug_id = 'Ceftibutin' WHERE drug_id = 'RXNG20492'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG20492'
UPDATE c_Drug_Generic SET drug_id = 'Cypress,Arizona' WHERE drug_id = 'RXNG852814'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852814'
UPDATE c_Drug_Generic SET drug_id = 'Cypress,Bald' WHERE drug_id = 'RXNG995747'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG995747'
UPDATE c_Drug_Generic SET drug_id = 'DockYellow' WHERE drug_id = 'RXNG852209'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852209'
UPDATE c_Drug_Generic SET drug_id = 'DocusateSodium' WHERE drug_id = 'RXNG82003'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG82003'
UPDATE c_Drug_Generic SET drug_id = 'fentaNYL' WHERE drug_id = 'RXNG4337'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG4337'
UPDATE c_Drug_Generic SET drug_id = 'Gerbil,Epithelias' WHERE drug_id = 'RXNG895070'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG895070'
UPDATE c_Drug_Generic SET drug_id = 'GlucosamineChrondroitin' WHERE drug_id = 'RXNG4845'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG4845'
UPDATE c_Drug_Generic SET drug_id = 'GLYCERINE' WHERE drug_id = 'RXNG4910'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG4910'
UPDATE c_Drug_Generic SET drug_id = 'Goat,Epithelias' WHERE drug_id = 'RXNG852252'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852252'
UPDATE c_Drug_Generic SET drug_id = 'Hamster,Epithelias' WHERE drug_id = 'RXNG895062'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG895062'
UPDATE c_Drug_Generic SET drug_id = 'Hazelnut,American' WHERE drug_id = 'RXNG891633'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG891633'
UPDATE c_Drug_Generic SET drug_id = 'Hickory,Shagbark' WHERE drug_id = 'RXNG852221'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852221'
UPDATE c_Drug_Generic SET drug_id = 'Hickory,White' WHERE drug_id = 'RXNG899645'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG899645'
UPDATE c_Drug_Generic SET drug_id = 'Horse' WHERE drug_id = 'RXNG852479'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852479'
UPDATE c_Drug_Generic SET drug_id = 'Hydrazaline' WHERE drug_id = 'RXNG5470'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG5470'
UPDATE c_Drug_Definition SET common_name = 'hydrALAZINE' WHERE drug_id = 'Hydrazaline' 
UPDATE c_Drug_Generic SET drug_id = 'Juniper,Oneseed' WHERE drug_id = 'RXNG900108'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG900108'
UPDATE c_Drug_Generic SET drug_id = 'Juniper,Rockymountain' WHERE drug_id = 'RXNG852601'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852601'
UPDATE c_Drug_Generic SET drug_id = 'Juniper,Utah' WHERE drug_id = 'RXNG852597'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852597'
UPDATE c_Drug_Generic SET drug_id = 'Juniper,Western' WHERE drug_id = 'RXNG852589'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852589'
UPDATE c_Drug_Generic SET drug_id = 'LocustBlossomBlack' WHERE drug_id = 'RXNG867325'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG867325'
UPDATE c_Drug_Generic SET drug_id = 'Maple,Coast' WHERE drug_id = 'RXNG851736'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851736'
UPDATE c_Drug_Generic SET drug_id = 'Maple,Red' WHERE drug_id = 'RXNG851744'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851744'
UPDATE c_Drug_Generic SET drug_id = 'Maple,Softsilver' WHERE drug_id = 'RXNG851866'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851866'
UPDATE c_Drug_Generic SET drug_id = 'Maple,Sugarhard' WHERE drug_id = 'RXNG851874'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851874'
UPDATE c_Drug_Generic SET drug_id = 'Methychlothiazide' WHERE drug_id = 'RXNG6860'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG6860'
UPDATE c_Drug_Generic SET drug_id = 'Morphinesulfate' WHERE drug_id = 'RXNG7052'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG7052'
UPDATE c_Drug_Generic SET drug_id = 'Mouse,Epithelias' WHERE drug_id = 'RXNG852693'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852693'
UPDATE c_Drug_Generic SET drug_id = 'MulberryRed' WHERE drug_id = 'RXNG852680'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852680'
UPDATE c_Drug_Generic SET drug_id = 'PecanTree' WHERE drug_id = 'RXNG852272'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852272'
UPDATE c_Drug_Generic SET drug_id = 'Pine,Yellow' WHERE drug_id = 'RXNG852716'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852716'
UPDATE c_Drug_Generic SET drug_id = 'Plantain,English' WHERE drug_id = 'RXNG852742'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852742'
UPDATE c_Drug_Generic SET drug_id = 'PyrantelP' WHERE drug_id = 'RXNG8984'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG8984'
UPDATE c_Drug_Generic SET drug_id = 'Rabbit,Epithelias' WHERE drug_id = 'RXNG895195'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG895195'
UPDATE c_Drug_Generic SET drug_id = 'RagweedGiant' WHERE drug_id = 'RXNG851998'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG851998'
UPDATE c_Drug_Generic SET drug_id = 'Ragweed,Short' WHERE drug_id = 'RXNG896135'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG896135'
UPDATE c_Drug_Generic SET drug_id = 'Ragweed,Southern' WHERE drug_id = 'RXNG885750'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG885750'
UPDATE c_Drug_Generic SET drug_id = 'Rhizopusarrihizus' WHERE drug_id = 'RXNG314443'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG314443'
UPDATE c_Drug_Generic SET drug_id = 'Turkeyfeathers' WHERE drug_id = 'RXNG975119'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG975119'
UPDATE c_Drug_Generic SET drug_id = 'VitaminB12' WHERE drug_id = 'RXNG11248'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG11248'
UPDATE c_Drug_Generic SET drug_id = 'WalnutBlack' WHERE drug_id = 'RXNG891695'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG891695'
UPDATE c_Drug_Generic SET drug_id = 'Wheat' WHERE drug_id = 'RXNG901299'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG901299'
UPDATE c_Drug_Generic SET drug_id = 'WillowBlack' WHERE drug_id = 'RXNG852162'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNG852162'

UPDATE c_Drug_Brand SET drug_id = 'NicodermCQ' WHERE drug_id = 'RXNB352799'
DELETE FROM c_Drug_Definition WHERE drug_id = 'RXNB352799'


update c_Drug_Brand set drug_id = 'Norco' where drug_id = 'RXNB218772'
update c_Drug_Brand set drug_id = 'Percocet' where drug_id = 'RXNB42844'

insert into c_Drug_Definition (
[drug_id]
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
SELECT [drug_id]
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
from c_Drug_Definition_Archive where drug_id in ('Norco','Percocet')

DELETE FROM c_Drug_Definition_Archive WHERE drug_id in ('Norco','Percocet')

INSERT INTO [c_Drug_Package] (
	[drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
	  )
SELECT [drug_id]
      ,[package_id]
      ,[sort_order]
      ,[prescription_flag]
      ,[default_dispense_amount]
      ,[default_dispense_unit]
      ,[take_as_directed]
      ,[hcpcs_procedure_id]
FROM [dbo].[c_Drug_Package_Archive] dp
where drug_id in ('Norco','Percocet')


DELETE FROM [c_Drug_Package_Archive]
where drug_id in ('Norco','Percocet')


UPDATE c_Drug_Formulation SET RXN_available_strength = '1000 MG' WHERE form_rxcui = '899932' -- Benefiber
UPDATE c_Drug_Formulation SET RXN_available_strength = '0.5 MG/ML (expressed as Codeine Phosphate) / 15 MG/ML' WHERE form_rxcui = '995226' -- Brontex
UPDATE c_Drug_Formulation SET RXN_available_strength = '360 MG/ML' WHERE form_rxcui = '702157' -- Calcionate
UPDATE c_Drug_Formulation SET RXN_available_strength = '4 MG/ML (expressed as Dextromethorphan Hydrobromide)' WHERE form_rxcui = '1190808' -- Entex S
UPDATE c_Drug_Formulation SET RXN_available_strength = '5.56 MG/ML' WHERE form_rxcui = '392046' -- Fluor a Day
UPDATE c_Drug_Formulation SET RXN_available_strength = '70 MG (expressed as Alendronic acid) / 5600 UNT' WHERE form_rxcui = '904462' -- Fosamax Plus D
UPDATE c_Drug_Formulation SET RXN_available_strength = '70 MG (expressed as Alendronic acid) / 2800 UNT' WHERE form_rxcui = '904492' -- Fosamax Plus D
UPDATE c_Drug_Formulation SET RXN_available_strength = '210000 MG / 740 MG / 2860 MG / 5600 MG' WHERE form_rxcui = '1718983' -- Gavilyte-H
UPDATE c_Drug_Formulation SET RXN_available_strength = '16.7 MG/ML' WHERE form_rxcui = '1661683' -- Goody's Back & Body Pain Relief
UPDATE c_Drug_Formulation SET RXN_available_strength = '1000 MG' WHERE form_rxcui = 'KEG418' -- Goody's Back & Body Pain Relief
UPDATE c_Drug_Formulation SET RXN_available_strength = '40 MG/ML / 0.5 MG/ML (expressed as Hydrocodone Bitartrate) / 6 MG/ML (expressed as Pseudoephedrine Hydrochloride)' WHERE form_rxcui = '1651558' -- Hycofenix
UPDATE c_Drug_Formulation SET RXN_available_strength = '1.3 MG/ML / 50 MG/ML / 0.0302 MEQ/ML / 0.0155 MEQ/ML' WHERE form_rxcui = '800786' -- Isolyte M
UPDATE c_Drug_Formulation SET RXN_available_strength = '40 MG/ML / 1 MG/ML (expressed as Phenylephrine Hydrochloride)' WHERE form_rxcui = '1370427' -- J-Max
UPDATE c_Drug_Formulation SET RXN_available_strength = '5 MG' WHERE form_rxcui = '1294537'	-- Meridia
UPDATE c_Drug_Formulation SET RXN_available_strength = '10 MG (expressed as SIBUTRAMINE HYDROCHLORIDE)' WHERE form_rxcui = '1294541'	-- Meridia
UPDATE c_Drug_Formulation SET RXN_available_strength = '15 MG (expressed as SIBUTRAMINE HYDROCHLORIDE)' WHERE form_rxcui = '1294545'	-- Meridia
UPDATE c_Drug_Formulation SET RXN_available_strength = '500 MG / 25 MG' WHERE form_rxcui = '198449'	-- Midol Teen
UPDATE c_Drug_Formulation SET RXN_available_strength = '6 MG/ML (expressed as Dextromethorphan Hydrobromide) / 40 MG/ML' WHERE form_rxcui = '1147924'	-- Neotuss
UPDATE c_Drug_Formulation SET RXN_available_strength = '20 MG/ML (expressed as Chloroprocaine hydrochloride)' WHERE form_rxcui = '992805'	-- Nesacaine
UPDATE c_Drug_Formulation SET RXN_available_strength = '2 MG/ML (expressed as Codeine Phosphate) / 6 MG/ML (expressed as Pseudoephedrine Hydrochloride) / 0.25 MG/ML (expressed as Triprolidine Hydrochloride)' WHERE form_rxcui = '996640'	-- Pseudodine C
UPDATE c_Drug_Formulation SET RXN_available_strength = '3 MG / 20 MG' WHERE form_rxcui = '895560'	-- Rescon Jr Reformulated Feb 2010
UPDATE c_Drug_Formulation SET RXN_available_strength = '1 MG/ML (expressed as Hydrocodone Bitartrate) / 12 MG/ML (expressed as Pseudoephedrine Hydrochloride)' WHERE form_rxcui = '1114334'	-- Rezira
UPDATE c_Drug_Formulation SET RXN_available_strength = '1000 MG/ML' WHERE form_rxcui = '312541'	-- SSKI brand of Potassium Iodide
UPDATE c_Drug_Formulation SET RXN_available_strength = '32 MG/ML / 0.5 MG/ML (expressed as Phenylephrine Hydrochloride)' WHERE form_rxcui = '1088546'	-- Tylenol Sinus Congestion and Pain Daytime


UPDATE c_Drug_Formulation SET RXN_available_strength = '10 MG (expressed as Doxorubicin Hydrochloride)' WHERE form_rxcui = '1790103'	-- Adriamycin
UPDATE c_Drug_Formulation SET RXN_available_strength = '200 MG / 10 MG (expressed as Phenylephrine Hydrochloride)' WHERE form_rxcui = '1722333'	-- Advil Sinus Congestion and Pain
UPDATE c_Drug_Formulation SET RXN_available_strength = '2 MG/ML (expressed as Sodium Hyaluronate)' WHERE form_rxcui = '1593288'	-- Bionect
UPDATE c_Drug_Formulation SET RXN_available_strength = '0.005 MG/ML / 40 MG/ML (expressed as Prilocaine Hydrochloride)' WHERE form_rxcui = '1993224'	-- Citanest Forte
UPDATE c_Drug_Formulation SET RXN_available_strength = '100 MG/ML (expressed as Undecylenic Acid)' WHERE form_rxcui = '1482679'	-- Diaderm
UPDATE c_Drug_Formulation SET RXN_available_strength = '50 MG/ML' WHERE form_rxcui = '200141'	-- Enfamil Glucose
UPDATE c_Drug_Formulation SET RXN_available_strength = '50 MG (expressed as cyclosporine, modified)' WHERE form_rxcui = '835925'	-- Gengraf
UPDATE c_Drug_Formulation SET RXN_available_strength = '0.0025 MG / 0.5 MG (expressed as norethindrone acetate)' WHERE form_rxcui = '1722245'	-- Jevantique
UPDATE c_Drug_Formulation SET RXN_available_strength = '25.5 MG/ML (expressed as Liver derivative complex)' WHERE form_rxcui = '200238'	-- Nexavir
UPDATE c_Drug_Formulation SET RXN_available_strength = '5 MG/ML' WHERE form_rxcui = '241975'	-- Omnitrope/Saizen
UPDATE c_Drug_Formulation SET RXN_available_strength = '10 MG / 1000 MG (expressed as Metformin hydrochloride)' WHERE form_rxcui = '1593775'	-- Xigduo
UPDATE c_Drug_Formulation SET RXN_available_strength = '10 MG / 500 MG (expressed as Metformin hydrochloride)' WHERE form_rxcui = '1593835'	-- Xigduo
UPDATE c_Drug_Formulation SET RXN_available_strength = '5 MG / 1000 MG (expressed as Metformin hydrochloride)' WHERE form_rxcui = '1593833'	-- Xigduo
UPDATE c_Drug_Formulation SET RXN_available_strength = '5 MG / 500 MG (expressed as Metformin hydrochloride)' WHERE form_rxcui = '1593831'	-- Xigduo
UPDATE c_Drug_Formulation SET RXN_available_strength = '5 MG/ML' WHERE form_rxcui = '241975'	-- Zomacton
UPDATE c_Drug_Formulation SET RXN_available_strength = '2 MG/ML (expressed as Codeine Phosphate) / 1 MG/ML (expressed as Phenylephrine Hydrochloride) / 1 MG/ML (expressed as Pyrilamine Maleate)' WHERE form_rxcui = '996580'	-- Zotex

UPDATE c_Drug_Formulation SET dosage_form = 'InhalantSusp' WHERE form_descr like '%inhalant suspension%'
UPDATE c_Drug_Formulation SET dosage_form = 'InhalantSusp' WHERE form_descr like '%Inhalation suspension%'
-- The formulations with dosage form 'Oral or Rectal Suspension' will be duplicated. 
-- One entry will then have the 'oral suspension' dosage form and the other will have 
-- the 'rectal suspension' dosage form. 

IF NOT EXISTS ( SELECT 1 
	FROM c_Drug_Formulation 
	WHERE form_descr like '%rectal suspension%'
	AND form_rxcui LIKE 'R%')
INSERT INTO c_Drug_Formulation (
		[form_rxcui]
      ,[form_tty]
      ,[form_descr]
      ,[ingr_rxcui]
      ,[ingr_tty]
      ,[valid_in]
      ,[dosage_form]
      ,[dose_amount]
      ,[dose_unit]
      ,[RXN_available_strength]
	  )
SELECT 'R' + [form_rxcui]
      ,[form_tty]
      ,REPLACE([form_descr],'Oral or Rectal Suspension','Rectal Suspension')
      ,[ingr_rxcui]
      ,[ingr_tty]
      ,[valid_in]
      ,'Enema'
      ,[dose_amount]
      ,[dose_unit]
      ,[RXN_available_strength]
  FROM [dbo].[c_Drug_Formulation]
WHERE form_descr like '%oral or rectal suspension%'

UPDATE [c_Drug_Formulation]
SET form_descr = REPLACE([form_descr],'Oral or Rectal Suspension','Oral Suspension')
WHERE form_descr like '%oral or rectal suspension%'

-- Revising Dosage Forms sheet 1
UPDATE c_Drug_Formulation
SET valid_in = 'Suppress' 
WHERE form_descr LIKE '%dental irrigation solution%'
OR form_descr LIKE '%dental solution%'
OR form_descr LIKE '%dental cartridge%'
OR form_descr LIKE '%gas for inhalation%'
OR form_descr LIKE '%hemodialysis injection%'
OR form_descr LIKE '%Intracavitary drug implant%'
OR form_descr LIKE '%intraocular injection%'
OR form_descr LIKE '%intraperitoneal solution%'
OR form_descr LIKE '%intrapleural %'
OR form_descr LIKE '%intrathecal injection%'
OR form_descr LIKE '%intratracheal suspension%'
OR form_descr LIKE '%intraventricular injection%'
OR form_descr LIKE '%intravesical suspension%'
OR form_descr LIKE '%intravitreal drug implant%'
OR form_descr LIKE '%Injectable Foam%'
OR form_descr LIKE '%powder for intrapleural suspension%'
OR form_descr LIKE '%pentamidine%'
OR form_descr LIKE '%periodontal drug implant%'

-- Revising Dosage Forms sheet 3
UPDATE c_Drug_Formulation
SET valid_in = 'Suppress' 
WHERE form_rxcui IN (
'349408'
,'352211'
,'1242617'
,'197435'
,'198412'
,'199211'
,'199408'
,'199958'
,'200238'
,'204536'
,'206967'
,'206970'
,'206972'
,'207315'
,'210677'
,'1858963'
,'238013'
,'238082'
,'238083'
,'238084'
,'240738'
,'1743994'
,'251272'
,'251934'
,'311422'
,'311935'
,'311936'
,'312249'
,'312736'
,'315105'
,'349407'
,'349409'
,'349410'
,'352212'
,'352213'
,'352214'
,'435151'
,'540930'
,'597195'
,'637197'
,'800584'
,'800588'
,'800858'
,'809871'
,'832082'
,'832086'
,'833532'
,'853004'
,'859437'
,'864714'
,'867381'
,'880859'
,'966768'
,'990982'
,'1100742'
,'1100746'
,'1190748'
,'1234995'
,'1244233'
,'1244638'
,'1293443'
,'1293446'
,'1293464'
,'1293466'
,'1429282'
,'1429284'
,'1486165'
,'1594589'
,'1594591'
,'1594593'
,'1599836'
,'1599841'
,'1601982'
,'1654849'
,'1666831'
,'1666837'
,'1718913'
,'1729336'
,'1730194'
,'1788947'
,'1747294'
,'1791721'
,'1791723'
,'1799697'
,'1859009'
,'1926818'
,'1926823'
,'1926825'
,'1926827'
,'2003344'
,'1794440'
,'562366'
,'1549678'
,'542358'
,'542347'
,'200243'
,'997625'
,'208919'
,'542355'
,'541963'
,'1048324'
,'1801824'
,'1801830'
,'1946984'
,'1946986'
)

UPDATE c_Drug_Formulation
SET valid_in = 'TPN Suppress' 
WHERE form_rxcui IN (
'262197'
,'309279'
,'562675'
,'800188'
,'800929'
,'800933'
,'800976'
,'800979'
,'801133'
,'801136'
,'1090635'
,'1094083'
,'1293736'
,'1293739'
,'1486165'
,'1547445'
,'1547450'
,'1549708'
,'1667993'
,'800858'
,'800862'
,'801395'
,'801398'
,'801403'
,'801405'
,'801413'
,'801417'
,'801644'
,'801648'
,'200317'
,'200318'
,'204536'
,'800563'
,'800584'
,'800588'
,'800611'
,'801067'
,'805127'
,'805131'
,'807371'
,'1014427'
,'1014431'
,'1189640'
,'1189645'
,'1293443'
,'1293446'
,'1293464'
,'1293466'
,'1429282'
,'1429284'
,'1601982'
)

UPDATE c_Drug_Formulation
SET valid_in = 'Retired' 
WHERE form_rxcui IN (
'604379'
,'415314'
,'415379'
,'151114'
,'199584'
,'199585'
,'199727'
,'199947'
,'199965'
,'205296'
,'245961'
,'248009'
,'248661'
,'251817'
,'282533'
,'315188'
,'413132'
,'801024'
,'801142'
,'801145'
,'801391'
,'807383'
,'1189657'
,'1189673'
,'358992'
,'1945738'
,'1362214'
,'1190803'
,'1190944'
,'1362218'
,'857668'
,'857666'
,'748308'
,'1250569'
,'199651'
,'582765'
,'1048407'
,'253109'
,'1020400'
,'1020404'
)

-- Previous coding error
DELETE FROM c_Drug_Generic 
WHERE generic_rxcui = 'KEGI1600'
AND generic_name != 'travoprost / timolol maleate'

UPDATE c_Drug_Generic 
SET  generic_rxcui = 'KEGI1600'
WHERE generic_name = 'travoprost / timolol maleate'

-- RXNORM Typo (injecton)
UPDATE c_Drug_Formulation SET form_descr = 'gentamicin sulfate 90 MG in 100 ML Injection' WHERE form_rxcui = '310474'
