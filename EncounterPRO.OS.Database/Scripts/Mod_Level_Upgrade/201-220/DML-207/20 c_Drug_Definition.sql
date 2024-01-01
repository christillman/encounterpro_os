

-- UPDATE c_Drug_Brand set drug_id = NULL where drug_id is not null
-- UPDATE c_Drug_Generic set drug_id = NULL where drug_id is not null

-- Now, relate these to the existing drug structure

-- Correct misspellings which will affect matching

UPDATE c_Drug_Definition
SET generic_name = common_name
WHERE common_name in (
'Acetylcysteine',
'Aspirin',
'Bacitracin',
'Beclomethasone',
'Bethanechol',
'carBAMazepine',
'cloNIDine',
'Fluvastatin',
'Homatropine',
'hydroCHLOROthiazide',
'Interferon Beta-1b',
'Losartan',
'Metoprolol',
'Penbutolol',
'quiNINE',
'Timolol',
'Tropicamide',
'Verapamil')

UPDATE c_Drug_Definition
SET generic_name = 'Amphetamine aspartate / Amphetamine Sulfate / Dextroamphetamine saccharate / Dextroamphetamine Sulfate'
WHERE common_name like '%adderall%'

DELETE FROM c_Drug_Definition
WHERE drug_id LIKE 'RXN%'

UPDATE c_Drug_Definition
SET is_generic = CASE WHEN common_name = generic_name THEN 1 ELSE 0 END

-- Mark obsoleted brands per RXNORM
UPDATE d
SET d.drug_type = 'OBSOLETE', status = 'OBS'
FROM c_Drug_Definition d 
WHERE d.status = 'OK'
AND d.drug_id IN ('981^22',
'ATS',
'Accutane',
'Accuzyme',
'AciJel',
'ACTIFED',
'Activella',
'Actron',
'AdalatCC',
'Adsorbonac',
'AdvairDiskus',
'AdvilMigraine',
'Aerobid',
'Agenerase',
'Aknemycin',
'Alamast',
'Albalon',
'Aldomet1',
'Aldoril15',
'Alesse28',
'Alupent',
'AnaGuard',
'AnaplexDM',
'Ancef',
'Anusol1',
'Aphthasol',
'Apresoline',
'AquatabC',
'AquatabD',
'Aristocort',
'AristocortA',
'AristocortForte',
'Artane',
'AtussEX1',
'AtussMR',
'AtussMS',
'AtussNX',
'AugmentinXR',
'AURAL',
'AveenoAntiItch',
'Azmacort',
'BactrimDS1',
'BECLOVENT',
'BeconaseAQ',
'BENADRYL',
'Benzac',
'Benzagel',
'BetapaceAF',
'BiaxinXL',
'Bicitra',
'Blocadren',
'Brethaire',
'Brethine',
'BrevoxylCreamyWash',
'Bromfed1',
'981^27',
'CalanSR',
'Capitrol',
'Capoten',
'Capozide',
'Carbatuss',
'Cardioquin',
'CardizemCD',
'CardizemSR',
'CECLOR',
'CeclorCD',
'Cefadyl',
'Celestone',
'Cetapred',
'Chloroptic',
'Citrical',
'Claripelcream',
'ClaritinD24',
'CleocinVaginal',
'Clinoril',
'Clobevate',
'Clomid',
'CodiclearDH1',
'CodimalDH',
'Cognex',
'Combipres01',
'Cotazym',
'CoveraHS',
'Cyclocort',
'Cycrin',
'Cylert',
'Dalmane',
'Danocrine',
'DarvocetN100',
'DarvocetN',
'Darvon',
'DeconamineSR',
'DeconsalII',
'Demulin1/35',
'Demulin1/50',
'DepoTestadiol',
'Deponit',
'Desyrel',
'DetrolLA',
'Dextrostat',
'DHCPlus',
'Diabinese',
'DiamoxSequels',
'Didronel',
'DilacorXR',
'DilatrateSR',
'981^14',
'Dimetapp',
'DiproleneAF',
'Diprosone',
'DitropanXL',
'Dolobid',
'Dolorac',
'DomeboroOtic',
'Donnagel',
'Dostinex',
'Doxidan',
'Duphalac',
'DuraVent',
'Duratuss',
'DuratussHD',
'DURICEF',
'Dynabac',
'DynacircCR',
'Dynapen',
'Dynex',
'Dytan',
'ERYTHRO',
'EffexorXR',
'Eldoquin',
'EldoquinForte',
'EndalHDplus',
'EndalHD',
'Enduron',
'Enduronyl',
'Entex',
'EntexLA',
'EntexPSE',
'EntocortEC',
'Epifrin',
'Epinal',
'Eryc',
'Esclim',
'Estinyl',
'Estratab',
'Estratest',
'Eulexin',
'ExcedrinMigraine',
'ExgestLA',
'ExtraStrengthBayer',
'Fansidar',
'Fastin',
'Fempatch',
'Femstat3',
'Finevin',
'FLEET',
'FLURINEF',
'FloxinOtic',
'981^10',
'Foltx',
'Fortovase',
'Fungizone',
'Furacin',
'FURAZ',
'Gantrisin',
'GARA',
'Garamycin',
'Genoptic',
'Gentacidin',
'Geocillin',
'GlucophageXR',
'GlucotrolXL',
'Glyquincream',
'HaldolDecanoate',
'HalogE',
'HistexHC',
'HistexPD',
'Hivid',
'HumibidDM',
'Humorsol',
'HumuLINL',
'Hycodan',
'Hycominecompound',
'Hycotuss',
'Hydergine',
'HydergineLC',
'Hydrocortone',
'Hydrodiuril',
'Hylorel',
'Hytone',
'Hytrin',
'IBStat',
'Imdur',
'Imferon',
'ImodiumAD',
'Inderide12050',
'InflamaseForte',
'INTAL',
'Ismelin',
'IsoptoCetapred',
'JuniorStrengthTylenol',
'KDur',
'KLyte',
'KLyteDS',
'KPhosMF.',
'KPhosOriginal',
'Klotrix',
'KuZyme',
'Kutrase',
'Kwell',
'Kytril',
'LacriLube',
'LamISILAT',
'Lanoxicaps',
'Lariam',
'Larodopa',
'Levall50',
'Levlen',
'Levlite',
'Lexxel525',
'Librium',
'Lidex',
'LidexE',
'Lo/Ovral',
'LodineXL',
'Loestrin1.5/30',
'LoestrinFe1/20',
'Loniten',
'LORABID',
'Loxitane',
'Lozol',
'Ludiomil',
'Lunelle',
'LupronDepot',
'Luride',
'LurideSF',
'MEND',
'Mantadil',
'Marax',
'MaxaltMLT',
'Mebaral',
'Mellaril',
'MellarilS',
'Meperidinepromethazine',
'MetadateCD',
'MetadateER',
'Mexitil',
'Micronase',
'Micronor',
'Midrin',
'MilkofMagnesia',
'Miltown',
'Mintezol',
'Modicon28',
'Moduretic',
'Monistat3',
'Monistat7',
'MonistatDerm',
'MSIR',
'981^16',
'Mycelex',
'Mycelex7',
'MycelexG',
'MycologII',
'Mycostatin',
'Myochrysine',
'MYTREX',
'Nalex',
'NaprosynEC',
'NasacortAQ',
'Nasalide',
'Nasarel',
'Navane',
'Neggram',
'NicotrolNS',
'Niferex',
'Nitrodisc',
'NorQD',
'Nordette28',
'Norflex',
'Norgesic',
'NorgesicForte',
'Normiflo',
'Normodyne',
'Noroxin',
'Norplant',
'Notuss3',
'NovahistineDH2',
'NovoLINL',
'Nubain1',
'NucofedPediatriExpector',
'Nutracort',
'OcclusalHP',
'OCUMYCIN',
'Opticrom',
'Oramorph',
'Oretic',
'Orinase',
'OrthoDienestrol',
'Orthocept28',
'OrthoEST',
'Orudis',
'Oruvail',
'Osmoglyn',
'Ovral',
'Ovrette',
'Oxyir',
'PalgicDS',
'PancofHC1',
'PancofXP',
'PaxilCR1',
'Pedialyte',
'Pediamist',
'PEDIAZOLE',
'Pediotic',
'Pediox',
'Penetrex',
'PepcidAC',
'Percodan',
'Percolone',
'Perdiem',
'PeriColace',
'Periactin',
'PhenerganVC',
'PhenerganVCwith',
'Phisohex',
'Placidyl',
'PlanB',
'PolyHistForte',
'PolyHistineCS',
'PolyHistineDPED',
'PolycitraK',
'PRELONE',
'Premphase',
'PreparationH',
'PriLOSECOTC',
'Principen',
'Procanbid',
'ProcardiaXL',
'Profasi',
'ProfenForte',
'ProlexDM',
'Prolixin',
'Propine',
'Propulsid',
'Prosom',
'PROzacWeekly',
'Psorcone',
'PyridiumPlus',
'QuestranLight',
'Quinaglute',
'Quinidex',
'Quixin',
'Relafen',
'RhinocortAqua',
'ADDERALLLA',
'Robaxisal',
'RobinulForte',
'Robitussin',
'RobitussinDAC',
'RobitussinPediatric',
'RobitussinPE',
'ROCEPHIN',
'Romazicon',
'Rondec',
'RondecDM',
'Roxanol',
'Ryna121',
'Rynatan',
'Scopace',
'SELDANE',
'SELDANED',
'SELSUN',
'Septra',
'Serax',
'Serentil',
'SINEquan',
'SloBid',
'SlowK',
'SlowMag',
'SolaquinForte',
'SomaCompound',
'Spectazole',
'Stelazine',
'SudalSR',
'SulfacetR',
'Sumycin',
'Symmetrel',
'TStat',
'TagametHB',
'Tanafed',
'TanafedDP',
'TavistAllergy',
'TAVISTD',
'Teczem',
'Tequin',
'Thorazine',
'Tilade',
'Timolide',
'Tolectin',
'Tonocard',
'TORADOL',
'Tornalate',
'TranxeneSD',
'TRENtal',
'TriNasal',
'Triaminic',
'Triavil',
'Trilafon',
'Trisilate',
'Tritec',
'Tussend',
'TussendExpectorant',
'Tussi12',
'Tussi12D',
'TussiOrganidinDMNR',
'Tylox',
'TYMPAGESIC',
'Unidur',
'Urised',
'Urispas',
'981^4',
'VancenaseAQDS',
'Vanceril',
'VancerilDS',
'VANTIN',
'Vascor',
'Vasocidin',
'Vasocon',
'Vasosulf',
'Veetids',
'VerelanPM',
'VicodinES',
'VicodinHP1',
'VicodinTuss',
'Viokase1',
'AraA',
'Visicol',
'Vivactil',
'VivelleDOT',
'VOLMAX',
'Vosol',
'WellbutrinSR',
'Wigraine',
'Wytensin',
'981^7',
'Yasmin',
'Zantac75',
'Zelnorm',
'Zetar',
'ZostrixHP',
'ZotoHC',
'Zymase')
-- 452

-- Fix up a few generic names to get more matches
UPDATE c_Drug_Definition
SET generic_name = replace (replace (generic_name, ', ',','),',',' / ')
WHERE generic_name like '%,%'
and drug_type != 'OBSOLETE'
and drug_id not like 'Alb%'
and drug_id not like 'Humu%'
and drug_id not like 'Nov%'
and drug_id not in ('PREMARIN','NasalcromCAAllergy','Menest',
'Lubriderm','EucerinOriginal','Cenestin','AccuhistDMPediatri',
'Imogam','Macrobid')
-- 247

-- Update existing generic_name to match where brand name matches
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE dd.status = 'OK' 
AND dd.generic_name != CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END
-- 3

-- Update existing generic_name to match where generic name matches (pick up case differences)
UPDATE c_Drug_Definition
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END,
	is_generic = 1
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE dd.status = 'OK'
-- 1119

-- Populate drug_id columns

-- Exact common_name matches to existing table
-- Overwrite any existing values if match is found
UPDATE b 
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Brand b ON b.brand_name = dd.common_name
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
-- 766

UPDATE g
SET drug_id = dd.drug_id
FROM c_Drug_Definition dd
JOIN c_Drug_Generic g ON g.generic_name = dd.generic_name
WHERE dd.common_name = dd.generic_name
-- 211

UPDATE c_Drug_Generic 
SET drug_id = 'RXNG' + generic_rxcui
WHERE drug_id IS NULL
-- 0

UPDATE c_Drug_Brand
SET drug_id = 'RXNB' + brand_name_rxcui
WHERE drug_id IS NULL
-- 0

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name, status, is_generic)
SELECT 'RXNG' + g.generic_rxcui, 
	CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END , 
	CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END,
	'OK',
	1
FROM c_Drug_Generic g
WHERE g.drug_id = 'RXNG' + g.generic_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNG' + g.generic_rxcui)
-- 3398

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name, status, is_generic)
SELECT 'RXNB' + brand_name_rxcui, 
	brand_name, 
	CASE WHEN LEN(generic_name) <= 500 THEN generic_name ELSE left(generic_name,497) + '...' END,
	'OK',
	0
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id = 'RXNB' + brand_name_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNB' + b.brand_name_rxcui)
-- 3624

/*
-- Added BPCKs
UPDATE c_Drug_Brand 
SET drug_id = 'RXNB' + brand_name_rxcui
WHERE drug_id IS NULL

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT  'RXNB' + brand_name_rxcui, 
	CASE WHEN LEN(brand_name) <= 80 THEN brand_name ELSE left(brand_name,77) + '...' END,
	CASE WHEN LEN(generic_name) <= 500 THEN generic_name ELSE left(generic_name,497) + '...' END
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
WHERE b.drug_id = 'RXNB' + brand_name_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNB' + b.brand_name_rxcui)
-- 450

-- Added GPCKs
UPDATE c_Drug_Generic
SET drug_id = 'RXNG' + generic_rxcui
WHERE drug_id IS NULL

INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
SELECT 'RXNG' + generic_rxcui, 
	CASE WHEN LEN(generic_name) <= 80 THEN generic_name ELSE left(generic_name,77) + '...' END , 
	CASE WHEN LEN(generic_name) <= 500 THEN generic_name ELSE left(generic_name,497) + '...' END
FROM c_Drug_Generic
WHERE drug_id = 'RXNG' + generic_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition d WHERE d.drug_id = 'RXNG' + c_Drug_Generic.generic_rxcui)
-- 291
*/
UPDATE d
set dea_schedule = Substring(b.dea_class,2,4) 
from c_Drug_Definition d
join c_Drug_Brand b on b.drug_id = d.drug_id
where d.dea_schedule != Substring(b.dea_class,2,4) 
-- 137

UPDATE d
set dea_schedule = Substring(g.dea_class,2,4) 
from c_Drug_Definition d
join c_Drug_Generic g on g.drug_id = d.drug_id
where d.dea_schedule != Substring(g.dea_class,2,4) 
-- 44

UPDATE c_Drug_Definition
SET controlled_substance_flag = 'Y'
WHERE dea_schedule in ('II','III')
AND controlled_substance_flag != 'Y'
-- 2
