

UPDATE s SET term_type = 'brand_name'
-- select s.*, d.common_name 
FROM c_Synonym s
JOIN c_Drug_Definition d on d.common_name = s.term 
	OR d.common_name = s.alternate
WHERE d.common_name != d.generic_name
AND d.common_name NOT IN ('Ascorbic Acid','Benzylpenicillin Sodium',
	'Vitamin C','Penicillin G Sodium','Senna','Isoptocarpine')
and term_type = 'drug_ingredient'
-- (45 rows affected)

UPDATE s SET term_type = 'brand_name'
-- select s.*, d.brand_name 
FROM c_Synonym s
JOIN c_Drug_Brand d on d.brand_name = s.term 
	OR d.brand_name = s.alternate
WHERE d.brand_name NOT IN ('Ascorbic Acid','Benzylpenicillin Sodium',
	'Vitamin C','Penicillin G Sodium','Senna','Isoptocarpine')
and term_type = 'drug_ingredient'
-- (45 rows affected)


UPDATE c_Synonym SET preferred_term = 'aciclovir' where term in ('acyclovir')
UPDATE c_Synonym SET preferred_term = 'adrenaline' where term in ('Adrenalin','Adrenaline','Epinephrine')
UPDATE c_Synonym SET preferred_term = 'alpha lipoic acid' where term in ('alpha lipoic acid','Thioctate')
UPDATE c_Synonym SET preferred_term = 'aluminIUM', term = 'aluminUM' where term in ('AliminUM')
UPDATE c_Synonym SET preferred_term = 'atracurium besilate' where term in ('Atracurium Besilate')
UPDATE c_Synonym SET preferred_term = 'atropine sulfate' where term in ('Atropine Sulphate')
UPDATE c_Synonym SET preferred_term = 'beclometasone' where term in ('Beclomethasone','Beclometasone')
UPDATE c_Synonym SET preferred_term = 'trihexyphenidyl' where term in ('benzhexol')
UPDATE c_Synonym SET preferred_term = 'benzylpenicillin' where alternate like ('Penicillin G%')
UPDATE c_Synonym SET preferred_term = 'phenoxymethylpenicillin' where alternate like ('Penicillin V%')
UPDATE c_Synonym SET preferred_term = 'cefalexin' where term in ('Cephalexin')
UPDATE c_Synonym SET preferred_term = 'colecalciferol' where term in ('Cholecalciferol','Colecalciferol','Vitamin D3')
UPDATE c_Synonym SET preferred_term = 'chromic chloride hexahydrate' where term in ('chromic chloride')
UPDATE c_Synonym SET preferred_term = 'clomifene' where term in ('Clomifene','Clomifene Citrate')
UPDATE c_Synonym SET preferred_term = 'ciclosporin' where term in ('Cyclosporin','Cyclosporine')
UPDATE c_Synonym SET preferred_term = 'ubidecarenone' where term in ('coenzyme Q10','Ubiquinone')
UPDATE c_Synonym SET preferred_term = 'cyanocobalamin', term = 'Vitamin B12' where term in ('Vitamin B 12')
UPDATE c_Synonym SET preferred_term = 'dimeticone' where term in ('Dimethicone')
UPDATE c_Synonym SET preferred_term = 'etacrynic acid' where term in ('Ethacrynate')
UPDATE c_Synonym SET preferred_term = 'etamsylate' where term in ('Ethamsylate')
UPDATE c_Synonym SET preferred_term = 'flucloxacillin' where term in ('Flucloxacillin')
UPDATE c_Synonym SET preferred_term = 'flumetasone' where term in ('flumethasone')
UPDATE c_Synonym SET preferred_term = 'flupentixol' where term in ('Flupentixol')
UPDATE c_Synonym SET preferred_term = 'fumarate' where term in ('fumarate')
UPDATE c_Synonym SET preferred_term = 'glucose' where term in ('Glucose','dextrose')
UPDATE c_Synonym SET preferred_term = 'guaifenesin' where term in ('Guaiphenesin')
UPDATE c_Synonym SET preferred_term = 'hematoporphyrin' where term in ('Dihematoporphyrin Ether')
UPDATE c_Synonym SET preferred_term = 'hydroxycarbamide' where term in ('Hydroxycarbamide')
UPDATE c_Synonym SET preferred_term = 'insulin aspart' where term in ('Insulin, Aspart, Human')
UPDATE c_Synonym SET preferred_term = 'insulin glulisine' where term in ('Insulin, Glulisine, Human')
UPDATE c_Synonym SET preferred_term = 'lidocaine' where term in ('Lignocaine')
UPDATE c_Synonym SET preferred_term = 'linoleate' where term in ('linoleate')
UPDATE c_Synonym SET preferred_term = 'mecobalamin' where term in ('methylcobalamin')
UPDATE c_Synonym SET preferred_term = 'nadide' where term in ('Nicotinamide')
UPDATE c_Synonym SET preferred_term = 'oxybutynin' where term in ('Oxybutynin Hydrochloride')
UPDATE c_Synonym SET preferred_term = 'phenobarbital' where term in ('Phenobarb','Phenobarbitone')
UPDATE c_Synonym SET preferred_term = 'phytonadione' where term in ('Vitamin K')
UPDATE c_Synonym SET preferred_term = 'phytonadione', term = 'Vitamin K1' where term in ('Vitamin K 1')
UPDATE c_Synonym SET preferred_term = 'prasterone' where term in ('prasterone')
UPDATE c_Synonym SET preferred_term = 'pyridoxine' where term in ('Vitamin B6')
UPDATE c_Synonym SET preferred_term = 'procaine benzylpenicillin' where term in ('Procaine Penicillin','Procaine Penicillin G')
UPDATE c_Synonym SET preferred_term = 'simeticone', alternate = 'simeticone' where term in ('simethicone')
UPDATE c_Synonym SET preferred_term = 'thiamine', alternate = 'thiamine' where term in ('thiamin','Vitamin B1')
UPDATE c_Synonym SET preferred_term = 'fosfomycin trometamol' where term in ('Tromethamine')
UPDATE c_Synonym SET preferred_term = 'tocofersolan' where term in ('Vitamin E')
UPDATE c_Synonym SET preferred_term = 'talimogene laherparepvec' where alternate in ('talimogene laherparepvec')
UPDATE c_Synonym SET preferred_term = 'simoctocog alfa' where alternate in ('simoctocog alfa')
UPDATE c_Synonym SET preferred_term = 'turoctocog alfa' where alternate in ('turoctocog alfa')
UPDATE c_Synonym SET preferred_term = 'albutrepenonacog alfa' where alternate in ('albutrepenonacog alfa')
UPDATE c_Synonym SET preferred_term = 'valganciclovir' where term in ('Valgancyclovir HCl')


UPDATE c_Synonym SET preferred_term = 'paracetamol' where term in ('paracetamol','acetaminophen')
UPDATE c_Synonym SET preferred_term = 'aminolevulinate' where term in ('Aminolevulinate')
UPDATE c_Synonym SET preferred_term = 'chestnut oak pollen extract', term = 'chestnut oak pollen extract' where term in ('chesnut oak pollen extract')
UPDATE c_Synonym SET preferred_term = 'docusate', alternate = 'docusate sodium' where alternate in ('docustate sodium')
UPDATE c_Synonym SET preferred_term = 'vaginal insert', term_type = 'dosage_form' where term in ('Vaginal Suppository')

UPDATE c_Synonym SET preferred_term = lower(alternate)
where preferred_term is null
and term_type = 'drug_ingredient'
-- exclude brand name synonyms
and term not like 'Aminosyn%'

/*
select distinct [Old name], [New name], [Change type],
	--'INSERT INTO c_Synonym (term, term_type, alternate, preferred_term) VALUES 
	'(''' + lower(left([Old name],1)) + substring([Old name],2,200) + ''',''drug_ingredient'',''' + [New name] + ''',''' + [New name] + '''),'
from changed_ingr
where [Change type] not in ('Hydration change only')
*/

DELETE 
-- select * 
FROM c_Synonym 
where (term = 'cholecalciferol' and alternate = 'colecalciferol')
or (term = 'cyclosporin' and alternate = 'ciclosporin')
or (term = 'cyclosporine' and alternate = 'cyclosporin')
or (term = 'procaine penicillin' and alternate = 'procaine benzylpenicillin')

DELETE 
-- select * 
FROM c_Synonym 
where term in (
'acriflavine', 'actinomycin D', 'alpha tocopherol', 'amethocaine', 
'aminacrine', 'amlodipine besylate', 'amoxycillin', 'amphotericin', 'amylobarbitone', 
'atracurium besylate', 'Bacillus Calmette and Guerin', 'beclomethasone dipropionate', 
'bee pollen', 'benztropine mesylate', 'bromocriptine mesylate', 
'butoxyethyl nicotinate', 'cephalexin anhydrous', 'cephalothin', 
'cephamandole', 'cephazolin', 'chitosan', 'chlorbutol', 'chlorpheniramine maleate', 
'chlorthalidone', 'cholestyramine', 'cisatracurium besylate', 
'clomiphene', 'colaspase', 'co-methylcobalamin', 'cysteamine', 
'desferrioxamine mesylate', 'dexamphetamine', 'dextropropoxyphene napsylate', 
'diclofenac diethylammonium', 'di-iodohydroxyquinoline', 'dimeglumine gadobenate', 
'dimeglumine gadopentetate', 'diphemanil', 'disodium etidronate', 
'disodium pamidronate', 'dl-alpha tocopheryl', 'dolasetron mesylate', 'dothiepin', 
'doxazosin mesylate', 'eformoterol', 'eprosartan mesylate', 'ethacrynic acid', 
'ethinyloestradiol', 'ethynodiol diacetate', 'flumethasone', 'flupenthixol', 
'frusemide', 'glutaraldehyde', 'glycol salicylate', 'glycopyrrolate', 
'haematoporphyrin', 'heparinoid', 'hexachlorophane', 'hexamine', 'hydroxyethylrutosides', 
'hydroxyquinoline', 'hydroxyurea', 'imatinib mesylate', 'indomethacin', 
'Lactobacillus kefir', 'lapatinib ditosylate', 'laureth-9', 'maldison', 
'manganese aspartate', 'meglumine diatrizoate', 'meglumine iothalamate', 
'meglumine iotroxate', 'meglumine ioxaglate', 'meta-Cresol', 'mussel - green lipped', 
'noradrenaline acid tartrate', 'octyl triazone', 'oestradiol', 'oestriol', 
'oestrogens - conjugated', 'oxethazaine', 'oxpentifylline', 'paraffin - soft white', 
'pentamidine isethionate', 'pericyazine', 'phytic acid', 
'piperazine oestrone', 'prochlorperazine mesylate', 
'r,S-alpha Lipoic acid', 'retinyl', 'rutin', 'salcatonin', 'saquinavir mesylate', 
'sodium diatrizoate', 'sodium phosphate - monobasic', 'sorafenib tosylate', 
'testosterone enanthate', 'tetracosactrin', 'tetrahydrozoline', 
'thiamine phosphoric acid ester chloride', 'thioguanine', 
'thyroxine', 'triethanolamine lauryl', 'trimeprazine',

'amoxycillin', 'bendrofluazide', 'dosulepin', 'MethotrimEPRAZINE', 'norethisterone', 
'cycloSPORINE')

-- From Austrlia's name modernizaton project
INSERT INTO c_Synonym (term, term_type, alternate, preferred_term) VALUES
('acriflavine','drug_ingredient','acriflavinium','acriflavinium'),
('actinomycin D','drug_ingredient','dactinomycin','dactinomycin'),
('alpha tocopherol','drug_ingredient','dl-alpha-tocopherol','dl-alpha-tocopherol'),
('amethocaine','drug_ingredient','tetracaine','tetracaine'),
('aminacrine','drug_ingredient','aminoacridine','aminoacridine'),
('amlodipine besylate','drug_ingredient','amlodipine besilate','amlodipine besilate'),
('amoxycillin','drug_ingredient','amoxicillin','amoxicillin'),
('amphotericin','drug_ingredient','amphotericin B','amphotericin B'),
('amylobarbitone','drug_ingredient','amobarbital','amobarbital'),
('atracurium besylate','drug_ingredient','atracurium besilate','atracurium besilate'),
('Bacillus Calmette and Guerin','drug_ingredient','Mycobacterium bovis (Bacillus Calmette and Guerin (BCG) strain)','Mycobacterium bovis (Bacillus Calmette and Guerin (BCG) strain)'),
('beclomethasone dipropionate','drug_ingredient','beclometasone dipropionate','beclometasone dipropionate'),
('bee pollen','drug_ingredient','honey bee pollen','honey bee pollen'),
('benztropine mesylate','drug_ingredient','benzatropine mesilate','benzatropine mesilate'),
('bromocriptine mesylate','drug_ingredient','bromocriptine mesilate','bromocriptine mesilate'),
('butoxyethyl nicotinate','drug_ingredient','nicoboxil','nicoboxil'),
('cephalexin anhydrous','drug_ingredient','cefalexin','cefalexin'),
('cephalothin','drug_ingredient','cefalotin','cefalotin'),
('cephamandole','drug_ingredient','cefamandole','cefamandole'),
('cephazolin','drug_ingredient','cefazolin','cefazolin'),
('chitosan','drug_ingredient','poliglusam','poliglusam'),
('chlorbutol','drug_ingredient','chlorobutanol','chlorobutanol'),
('chlorpheniramine maleate','drug_ingredient','chlorphenamine maleate','chlorphenamine maleate'),
('chlorthalidone','drug_ingredient','chlortalidone','chlortalidone'),
('cholecalciferol','drug_ingredient','colecalciferol','colecalciferol'),
('cholestyramine','drug_ingredient','colestyramine','colestyramine'),
('cisatracurium besylate','drug_ingredient','cisatracurium besilate','cisatracurium besilate'),
('clomiphene','drug_ingredient','clomifene','clomifene'),
('colaspase','drug_ingredient','asparaginase','asparaginase'),
('co-methylcobalamin','drug_ingredient','mecobalamin','mecobalamin'),
('cyclosporin','drug_ingredient','ciclosporin','ciclosporin'),
('cysteamine','drug_ingredient','mercaptamine','mercaptamine'),
('desferrioxamine mesylate','drug_ingredient','desferrioxamine mesilate','desferrioxamine mesilate'),
('dexamphetamine','drug_ingredient','dexamfetamine','dexamfetamine'),
('dextropropoxyphene napsylate','drug_ingredient','dextropropoxyphene napsilate','dextropropoxyphene napsilate'),
('diclofenac diethylammonium','drug_ingredient','diclofenac diethylamine','diclofenac diethylamine'),
('di-iodohydroxyquinoline','drug_ingredient','diiodohydroxyquinoline','diiodohydroxyquinoline'),
('dimeglumine gadobenate','drug_ingredient','gadobenate dimeglumine','gadobenate dimeglumine'),
('dimeglumine gadopentetate','drug_ingredient','gadopentetate dimeglumine','gadopentetate dimeglumine'),
('diphemanil','drug_ingredient','diphemanil','diphemanil'),
('disodium etidronate','drug_ingredient','etidronate disodium','etidronate disodium'),
('disodium pamidronate','drug_ingredient','pamidronate disodium','pamidronate disodium'),
('dl-alpha tocopheryl','drug_ingredient','dl-alpha-tocopheryl','dl-alpha-tocopheryl'),
('dolasetron mesylate','drug_ingredient','dolasetron mesilate','dolasetron mesilate'),
('dothiepin','drug_ingredient','dosulepin','dosulepin'),
('doxazosin mesylate','drug_ingredient','doxazosin mesilate','doxazosin mesilate'),
('eformoterol','drug_ingredient','formoterol','formoterol'),
('eprosartan mesylate','drug_ingredient','eprosartan mesilate','eprosartan mesilate'),
('ethacrynic acid','drug_ingredient','etacrynic acid','etacrynic acid'),
('ethinyloestradiol','drug_ingredient','ethinylestradiol','ethinylestradiol'),
('ethynodiol diacetate','drug_ingredient','etynodiol diacetate','etynodiol diacetate'),
('flupenthixol','drug_ingredient','flupentixol','flupentixol'),
('frusemide','drug_ingredient','furosemide','furosemide'),
('glutaraldehyde','drug_ingredient','glutaral','glutaral'),
('glycol salicylate','drug_ingredient','hydroxyethyl salicylate','hydroxyethyl salicylate'),
('glycopyrrolate','drug_ingredient','glycopyrronium','glycopyrronium'),
('haematoporphyrin','drug_ingredient','hematoporphyrin','hematoporphyrin'),
('heparinoid','drug_ingredient','heparinoids','heparinoids'),
('hexachlorophane','drug_ingredient','hexachlorophene','hexachlorophene'),
('hexamine','drug_ingredient','methenamine','methenamine'),
('hydroxyethylrutosides','drug_ingredient','oxerutins','oxerutins'),
('hydroxyquinoline','drug_ingredient','oxyquinoline','oxyquinoline'),
('hydroxyurea','drug_ingredient','hydroxycarbamide','hydroxycarbamide'),
('imatinib mesylate','drug_ingredient','imatinib mesilate','imatinib mesilate'),
('indomethacin','drug_ingredient','indometacin','indometacin'),
('Lactobacillus kefir','drug_ingredient','Lactobacillus kefiri','Lactobacillus kefiri'),
('lapatinib ditosylate','drug_ingredient','lapatinib ditosilate','lapatinib ditosilate'),
('laureth-9','drug_ingredient','lauromacrogol 400','lauromacrogol 400'),
('maldison','drug_ingredient','malathion','malathion'),
('manganese aspartate','drug_ingredient','manganese diaspartate','manganese diaspartate'),
('meglumine diatrizoate','drug_ingredient','amidotrizoate meglumine','amidotrizoate meglumine'),
('meglumine iothalamate','drug_ingredient','iotalamate meglumine','iotalamate meglumine'),
('meglumine iotroxate','drug_ingredient','iotroxate meglumine','iotroxate meglumine'),
('meglumine ioxaglate','drug_ingredient','ioxaglate meglumine','ioxaglate meglumine'),
('meta-Cresol','drug_ingredient','metacresol','metacresol'),
('mussel - green lipped','drug_ingredient','green lipped mussel','green lipped mussel'),
('noradrenaline acid tartrate','drug_ingredient','norepinephrine','noradrenaline'),
('octyl triazone','drug_ingredient','ethylhexyl triazone','ethylhexyl triazone'),
('oestradiol','drug_ingredient','estradiol','estradiol'),
('oestriol','drug_ingredient','estriol','estriol'),
('oestrogens - conjugated','drug_ingredient','conjugated estrogens','conjugated estrogens'),
('oxethazaine','drug_ingredient','oxetacaine','oxetacaine'),
('oxpentifylline','drug_ingredient','pentoxifylline','pentoxifylline'),
('paraffin - soft white','drug_ingredient','white soft paraffin','white soft paraffin'),
('pentamidine isethionate','drug_ingredient','pentamidine isetionate','pentamidine isetionate'),
('pericyazine','drug_ingredient','periciazine','periciazine'),
('phytic acid','drug_ingredient','fytic acid','fytic acid'),
('piperazine oestrone','drug_ingredient','estropipate','estropipate'),
('procaine penicillin','drug_ingredient','procaine benzylpenicillin','procaine benzylpenicillin'),
('prochlorperazine mesylate','drug_ingredient','prochlorperazine mesilate','prochlorperazine mesilate'),
('r,S-alpha Lipoic acid','drug_ingredient','alpha lipoic acid','alpha lipoic acid'),
('retinyl','drug_ingredient','retinol','retinol'),
('rutin','drug_ingredient','rutoside','rutoside'),
('salcatonin','drug_ingredient','calcitonin salmon','calcitonin salmon'),
('saquinavir mesylate','drug_ingredient','saquinavir mesilate','saquinavir mesilate'),
('sodium diatrizoate','drug_ingredient','sodium amidotrizoate','sodium amidotrizoate'),
('sodium phosphate - monobasic','drug_ingredient','monobasic sodium phosphate','monobasic sodium phosphate'),
('sorafenib tosylate','drug_ingredient','sorafenib tosilate','sorafenib tosilate'),
('testosterone enanthate','drug_ingredient','testosterone enantate','testosterone enantate'),
('tetracosactrin','drug_ingredient','tetracosactide','tetracosactide'),
('tetrahydrozoline','drug_ingredient','tetryzoline','tetryzoline'),
('thiamine phosphoric acid ester chloride','drug_ingredient','monophosphothiamine','monophosphothiamine'),
('thioguanine','drug_ingredient','tioguanine','tioguanine'),
('thyroxine','drug_ingredient','levothyroxine','levothyroxine'),
('triethanolamine lauryl','drug_ingredient','trolamine lauril','trolamine lauril'),
('trimeprazine','drug_ingredient','alimemazine','alimemazine'),

-- NZ warnings
('bendrofluazide','drug_ingredient','bendroflumenthiazide','bendroflumenthiazide'),
('dosulepin','drug_ingredient','doTHIEpin','dosulepin'),
('MethotrimEPRAZINE','drug_ingredient','levopromazine','levopromazine'),
('norethisterone','drug_ingredient','norethindrone','norethindrone'),
('cycloSPORINE','drug_ingredient','cyclosporin','ciclosporin')
