
UPDATE c_Assessment_Definition 
SET assessment_category_id = 'TELEPHONE'
WHERE assessment_type = 'TELEPHONE'

-- No show: not SICK/AANEW (icd10_code not assigned)
UPDATE c_Assessment_Definition 
SET last_updated=getdate(), 
	assessment_type = 'PROBLEM',
	assessment_category_id = 'SOCIAL'
WHERE assessment_id IN ('DEMO11396')

-- Correct existing categories and types to match ICD10 implied categories
UPDATE d
SET last_updated=getdate(), 
	assessment_category_id = c.assessment_category_id,
	assessment_type = c.assessment_type
FROM c_Assessment_Definition d
JOIN c_Assessment_Category c ON d.icd10_code BETWEEN c.icd10_start and c.icd10_end + 'ZZZ'
WHERE d.assessment_type NOT IN ('ALLERGY', 'TELEPHONE')
AND c.is_default = 'Y'
AND d.assessment_category_id != c.assessment_category_id
-- exclude assessments which have been duplicated previously as separate category
AND NOT (d.assessment_category_id = 'RPERI' 
	AND EXISTS (SELECT 1 FROM c_Assessment_Definition d1
		WHERE d1.assessment_id LIKE d.assessment_id + '%'
		AND d1.assessment_category_id = 'OBP' )
		)
AND NOT (d.assessment_category_id = 'Z' 
	AND EXISTS (SELECT 1 FROM c_Assessment_Definition d1
		WHERE d1.assessment_id LIKE d.assessment_id + '%'
		AND d1.assessment_category_id != 'Z' )
		)
-- exclude non-default PGUU / PGYN, will update separately below
AND NOT d.icd10_code BETWEEN 'N40' and 'N53ZZZ'
AND NOT d.icd10_code BETWEEN 'N60' and 'N98ZZZ'

-- Cases where ICD ranges overlap
UPDATE d
SET last_updated=getdate(), 
	assessment_category_id = 'PGUU',
	assessment_type = 'SICK'
FROM c_Assessment_Definition d
WHERE d.assessment_category_id != 'PGUU'
AND d.icd10_code BETWEEN 'N40' and 'N53ZZZ'

UPDATE d
SET last_updated=getdate(), 
	assessment_category_id = 'PGYN',
	assessment_type = 'SICK'
FROM c_Assessment_Definition d
WHERE d.assessment_category_id != 'PGYN'
AND d.icd10_code BETWEEN 'N60' and 'N98ZZZ'

UPDATE d
SET assessment_type = c.assessment_type
FROM c_Assessment_Definition d
JOIN c_Assessment_Category c ON c.assessment_category_id = d.assessment_category_id
WHERE d.assessment_type != c.assessment_type


-- Updates from FreshDuplicateWCategory-response.xslx 
-- copy treatment lists

/*
EXEC jmj_copy_assessment_treatment_list 'SPRWRI', '$', 'SPRHAN', '$', 'Merge';
EXEC jmj_copy_assessment_treatment_list 'SPRWRI', '$FP', 'SPRHAN', '$FP', 'Merge';
EXEC jmj_copy_assessment_treatment_list 'SPRWRI', '$NEUROLOGY', 'SPRHAN', '$NEUROLOGY', 'Merge';
EXEC jmj_copy_assessment_treatment_list 'SPRWRI', '$PEDS', 'SPRHAN', '$PEDS', 'Merge';

select *
from u_assessment_treat_definition
where assessment_id IN (
'SPRHAN'
) 
and user_id = '$' order by definition_id
order by user_id, assessment_id
-- 54
*/


--   deletions
/*
DELETE FROM u_assessment_treat_definition
WHERE assessment_id IN ('SPRARM','SPRWRI','SPRFOO')
*/

DELETE FROM c_Common_Assessment
WHERE assessment_id IN ('SPRARM','SPRWRI','SPRFOO','DEMO10323','DEMO6511Q','DEMO8037a')

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('SPRARM','SPRWRI','SPRFOO','DEMO10323','DEMO6665Q',
	'DEMO6665','DEMO6656Q','DEMO6515Q','DEMO6511Q','DEMO8037a')

--   column J description updates


update c_Assessment_Definition set last_updated=getdate(), description ='Accessory lacrimal canal', long_description='Accessory lacrimal canal' where assessment_id = 'DEMO5757'
update c_Assessment_Definition set last_updated=getdate(), description ='Acidemia of newborn', long_description='Acidemia of newborn' where assessment_id = 'DEMO6679'

update c_Assessment_Definition set last_updated=getdate(), description ='Acidosis of newborn', long_description='Acidosis of newborn' where assessment_id = 'DEMO6683'
update c_Assessment_Definition set last_updated=getdate(), description ='Pre-existing secondary hypertension complicating pregnancy, unspecified trime…' where assessment_id = 'DEMO898'
update c_Assessment_Definition set last_updated=getdate(), description ='Pre-existing secondary hypertension complicating pregnancy, unspecified trime…' where assessment_id = 'DEMO898a'

update c_Assessment_Definition set last_updated=getdate(), description ='Maternal care for excessive fetal growth, unspecified trimester, not applicab…' where assessment_id = 'DEMO999'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal hypertensive disorders' where assessment_id = 'DEMO6496Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal hypertensive disorders' where assessment_id = 'DEMO6496'
update c_Assessment_Definition set last_updated=getdate(), description ='Anoxia cerebral newborn', long_description='Anoxia cerebral newborn' where assessment_id = 'DEMO6684'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia, newborn', long_description='Asphyxia, newborn' where assessment_id = 'DEMO6685Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal renal and urinary tract diseases' where assessment_id = 'DEMO6497'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal renal and urinary tract diseases' where assessment_id = 'DEMO6497Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal infectious and parasitic diseases' where assessment_id = 'DEMO6499Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal infectious and parasitic diseases' where assessment_id = 'DEMO6499'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury scalpel wound', long_description='Birth injury scalpel wound' where assessment_id = 'DEMO6677'
update c_Assessment_Definition set last_updated=getdate(), description ='contraceptive counseling', long_description='contraceptive counseling' where assessment_id = 'DEMO10322'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal circulatory and respiratory diseases' where assessment_id = 'DEMO6500Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal circulatory and respiratory diseases' where assessment_id = 'DEMO6500'
update c_Assessment_Definition set last_updated=getdate(), description ='Debility congenital or neonatal NOS', long_description='Debility congenital or neonatal NOS' where assessment_id = 'DEMO6721'
update c_Assessment_Definition set last_updated=getdate(), description ='Dislocation (articular) spine due to birth trauma', long_description='Dislocation (articular) spine due to birth trauma' where assessment_id = 'DEMO6673Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal nutritional disorders' where assessment_id = 'DEMO6502'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal nutritional disorders' where assessment_id = 'DEMO6502Q'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal conditions' where assessment_id = 'DEMO6512Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal conditions' where assessment_id = 'DEMO6512'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by multiple pregnancy' where assessment_id = 'DEMO6521Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by multiple pregnancy' where assessment_id = 'DEMO6521'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal complications of pregnancy' where assessment_id = 'DEMO6524Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal complications of pregnancy' where assessment_id = 'DEMO6524'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other forms of placental separation and hemorrhage' where assessment_id = 'DEMO6526Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other forms of placental separation and hemorrhage' where assessment_id = 'DEMO6526'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other morphological and functional abnormalities of placenta' where assessment_id = 'DEMO6527Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other morphological and functional abnormalities of placenta' where assessment_id = 'DEMO6527'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by prolapsed cord' where assessment_id = 'DEMO6529Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by prolapsed cord' where assessment_id = 'DEMO6529'
update c_Assessment_Definition set last_updated=getdate(), description ='Encephalopathy due to drugs', long_description='Encephalopathy due to drugs' where assessment_id = 'DEMO7179'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for insulin pump titration', long_description='Encounter for insulin pump titration' where assessment_id = 'DEMO11548'
update c_Assessment_Definition set last_updated=getdate(), description ='Flail chest newborn (birth injury)', long_description='Flail chest newborn (birth injury)' where assessment_id = 'DEMO6671'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other compression of umbilical cord' where assessment_id = 'DEMO6530'
update c_Assessment_Definition set last_updated=getdate(), description ='Fracture of spine due to birth injury', long_description='Fracture of spine due to birth injury' where assessment_id = 'DEMO6673'
update c_Assessment_Definition set last_updated=getdate(), description ='Hematoma subdural newborn', long_description='Hematoma subdural newborn' where assessment_id = 'SUB'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other conditions of umbilical cord' where assessment_id = 'DEMO6514Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other malpresentation, malposition and disproportion duri…' where assessment_id = 'ASSESSMENT5Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other malpresentation, malposition and disproportion duri…' where assessment_id = 'ASSESSMENT5'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by abnormality in fetal (intrauterine) heart rate or rhythm …' where assessment_id = 'DEMO6643Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by abnormality in fetal (intrauterine) heart rate or rhythm …' where assessment_id = 'DEMO6643'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by abnormality in fetal (intrauterine) heart rate or rhythm …' where assessment_id = 'DEMO6644Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by abnormality in fetal (intrauterine) heart rate or rhythm …' where assessment_id = 'DEMO6644'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal anesthesia and analgesia in pregnancy, labor and…' where assessment_id = 'DEMO6640Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal anesthesia and analgesia in pregnancy, labor and…' where assessment_id = 'DEMO6640'
update c_Assessment_Definition set last_updated=getdate(), description ='Hemorrhage extradural newborn', long_description='Hemorrhage extradural newborn' where assessment_id = 'SUBQ'
update c_Assessment_Definition set last_updated=getdate(), description ='History of cancer metastatic to lung', long_description='History of cancer metastatic to lung' where assessment_id = 'DEMO9002A'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal use of cocaine' where assessment_id = 'DEMO6509Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal use of cocaine' where assessment_id = 'DEMO6509'
update c_Assessment_Definition set last_updated=getdate(), description ='History of cancer of lung', long_description='History of cancer of lung' where assessment_id = 'DEMO9002'
update c_Assessment_Definition set last_updated=getdate(), description ='History of cancer of the nose and sinuses', long_description='History of cancer of the nose and sinuses' where assessment_id = 'DEMO9005'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal use of other drugs of addiction' where assessment_id = 'DEMO6506Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal use of other drugs of addiction' where assessment_id = 'DEMO6506'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by other maternal noxious substances' where assessment_id = 'DEMO6510'
update c_Assessment_Definition set last_updated=getdate(), description ='History of deep venous thrombosis (blood clot)', long_description='History of deep venous thrombosis (blood clot)' where assessment_id = 'DEMO9019'
update c_Assessment_Definition set last_updated=getdate(), description ='History of domestic adult physical abuse', long_description='History of domestic adult physical abuse' where assessment_id = 'DEMO4851A'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal noxious substance, unspecified' where assessment_id = 'DEMO6505Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal noxious substance, unspecified' where assessment_id = 'DEMO6505'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn light for gestational age, 2500 grams and over' where assessment_id = 'DEMO6653Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn light for gestational age, 2500 grams and over' where assessment_id = 'DEMO6653'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, less than 500 grams' where assessment_id = 'DEMO6645Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, less than 500 grams' where assessment_id = 'DEMO6645'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 500-749 grams' where assessment_id = 'DEMO6646Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 500-749 grams' where assessment_id = 'DEMO6646'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 750-999 grams' where assessment_id = 'DEMO6647Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 750-999 grams' where assessment_id = 'DEMO6647'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1000-1249 grams' where assessment_id = 'DEMO6648Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1000-1249 grams' where assessment_id = 'DEMO6648'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1250-1499 grams' where assessment_id = 'DEMO6649Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1250-1499 grams' where assessment_id = 'DEMO6649'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1500-1749 grams' where assessment_id = 'DEMO6650Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1500-1749 grams' where assessment_id = 'DEMO6650'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1750-1999 grams' where assessment_id = 'DEMO6651Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 1750-1999 grams' where assessment_id = 'DEMO6651'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 2000-2499 grams' where assessment_id = 'DEMO6652Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, 2000-2499 grams' where assessment_id = 'DEMO6652'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, other' where assessment_id = 'SGAQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn small for gestational age, other' where assessment_id = 'SGA'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by fetal (intrauterine) malnutrition not light or small for ...', long_description ='Newborn affected by fetal (intrauterine) malnutrition not light or small for gestational age' where assessment_id = 'DEMO6654Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by fetal (intrauterine) malnutrition not light or small for ...', long_description ='Newborn affected by fetal (intrauterine) malnutrition not light or small for gestational age' where assessment_id = 'DEMO6654'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by slow intrauterine growth, unspecified' where assessment_id = 'DEMO6655Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by slow intrauterine growth, unspecified' where assessment_id = 'DEMO6655'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, less than 500 grams' where assessment_id = 'DEMO6657Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, less than 500 grams' where assessment_id = 'DEMO6657'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, 500-749 grams' where assessment_id = 'DEMO6658Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, 500-749 grams' where assessment_id = 'DEMO6658'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, 750-999 grams' where assessment_id = 'DEMO6659Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Extremely low birth weight newborn, 750-999 grams' where assessment_id = 'DEMO6659'

update c_Assessment_Definition set last_updated=getdate(), description ='History of middle ear cancer', long_description='History of middle ear cancer' where assessment_id = 'DEMO9005A'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, unspecified weight' where assessment_id = 'DEMO289Q'

update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, unspecified weight' where assessment_id = 'DEMO289'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1000-1249 grams' where assessment_id = 'DEMO6660Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1000-1249 grams' where assessment_id = 'DEMO6660'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1250-1499 grams' where assessment_id = 'DEMO6661Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1250-1499 grams' where assessment_id = 'DEMO6661'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1500-1749 grams' where assessment_id = 'DEMO6662Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1500-1749 grams' where assessment_id = 'DEMO6662'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1750-1999 grams' where assessment_id = 'DEMO6663Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 1750-1999 grams' where assessment_id = 'DEMO6663'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 2000-2499 grams' where assessment_id = 'DEMO6664Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other low birth weight newborn, 2000-2499 grams' where assessment_id = 'DEMO6664'
update c_Assessment_Definition set last_updated=getdate(), description ='Preterm newborn, unspecified weeks of gestation' where assessment_id = 'DEMO11416Q'

update c_Assessment_Definition set last_updated=getdate(), description ='Preterm newborn, unspecified weeks of gestation' where assessment_id = 'DEMO11416'

update c_Assessment_Definition set last_updated=getdate(), description ='Exceptionally large newborn baby' where assessment_id = 'DEMO6667Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Exceptionally large newborn baby' where assessment_id = 'DEMO6667'
update c_Assessment_Definition set last_updated=getdate(), description ='Other heavy for gestational age newborn' where assessment_id = 'LGAQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Other heavy for gestational age newborn' where assessment_id = 'LGA'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury to facial nerve' where assessment_id = 'DEMO6674Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury to facial nerve' where assessment_id = 'DEMO6674'
update c_Assessment_Definition set last_updated=getdate(), description ='History of nasal cavity cancer', long_description='History of nasal cavity cancer' where assessment_id = 'DEMO9006'
update c_Assessment_Definition set last_updated=getdate(), description ='History of neuroblastoma', long_description='History of neuroblastoma' where assessment_id = 'DEMO9009'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury to spine and spinal cord' where assessment_id = 'DEMO6672Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury to spine and spinal cord' where assessment_id = 'DEMO6672'

update c_Assessment_Definition set last_updated=getdate(), description ='History of of sinus cancer', long_description='History of of sinus cancer' where assessment_id = 'DEMO9006A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of recurrent deep vein thrombosis', long_description='History of recurrent deep vein thrombosis' where assessment_id = 'DEMO9019A'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injuries to other parts of skeleton' where assessment_id = 'DEMO6670Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injuries to other parts of skeleton' where assessment_id = 'DEMO6670'
update c_Assessment_Definition set last_updated=getdate(), description ='Other brachial plexus birth injuries' where assessment_id = 'DEMO6675Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other brachial plexus birth injuries' where assessment_id = 'DEMO6675'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injuries to other parts of peripheral nervous system' where assessment_id = 'DEMO6676Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injuries to other parts of peripheral nervous system' where assessment_id = 'DEMO6676'
update c_Assessment_Definition set last_updated=getdate(), description ='History of rhabdomyosarcoma', long_description='History of rhabdomyosarcoma' where assessment_id = 'DEMO9009A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of skin ulcer of leg', long_description='History of skin ulcer of leg' where assessment_id = 'DEMO9026A'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified birth injuries' where assessment_id = 'DEMO10136Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified birth injuries' where assessment_id = 'DEMO10136'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury, unspecified' where assessment_id = 'DEMO53Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Birth injury, unspecified' where assessment_id = 'DEMO53'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia in newborn first noted before onset of labor' where assessment_id = 'DEMO6680Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia in newborn first noted before onset of labor' where assessment_id = 'DEMO6680'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia in newborn first noted during labor' where assessment_id = 'DEMO6681Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia in newborn first noted during labor' where assessment_id = 'DEMO6681'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia, unspecified' where assessment_id = 'DEMO6682Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Metabolic acidemia, unspecified' where assessment_id = 'DEMO6682'
update c_Assessment_Definition set last_updated=getdate(), description ='Omphalitis without hemorrhage' where assessment_id = 'DEMO9978Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Omphalitis without hemorrhage' where assessment_id = 'DEMO9978'
update c_Assessment_Definition set last_updated=getdate(), description ='History of smoking', long_description='History of smoking' where assessment_id = 'DEMO191'
update c_Assessment_Definition set last_updated=getdate(), description ='History of spouse or partner violence, physical', long_description='History of spouse or partner violence, physical' where assessment_id = 'DEMO4851'
update c_Assessment_Definition set last_updated=getdate(), description ='Other intracranial (nontraumatic) hemorrhages of newborn' where assessment_id = 'DEMO6669Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other intracranial (nontraumatic) hemorrhages of newborn' where assessment_id = 'DEMO6669'
update c_Assessment_Definition set last_updated=getdate(), description ='Other neonatal gastrointestinal hemorrhage' where assessment_id = 'HEMAQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Other neonatal gastrointestinal hemorrhage' where assessment_id = 'HEMA'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice due to other specified excessive hemolysis' where assessment_id = 'DEMO6717Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice due to other specified excessive hemolysis' where assessment_id = 'DEMO6717'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice associated with preterm delivery' where assessment_id = 'DEMO6716Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice associated with preterm delivery' where assessment_id = 'DEMO6716'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice from other hepatocellular damage' where assessment_id = 'DEMO6719Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice from other hepatocellular damage' where assessment_id = 'DEMO6719'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice from other specified causes' where assessment_id = 'DEMO6718Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice from other specified causes' where assessment_id = 'DEMO6718'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice, unspecified' where assessment_id = 'HYPERBILIQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal jaundice, unspecified' where assessment_id = 'HYPERBILI'
update c_Assessment_Definition set last_updated=getdate(), description ='Breast engorgement of newborn' where assessment_id = 'BREASTHQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Breast engorgement of newborn' where assessment_id = 'BREASTH'

update c_Assessment_Definition set last_updated=getdate(), description ='History of stasis ulceration (skin ulcer due to vein disease)', long_description='History of stasis ulceration (skin ulcer due to vein disease)' where assessment_id = 'DEMO9026'
update c_Assessment_Definition set last_updated=getdate(), description ='History of tobacco use', long_description='History of tobacco use' where assessment_id = 'DEMO4857A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of victim of adult sexual abuse', long_description='History of victim of adult sexual abuse' where assessment_id = 'DEMO4850A'
update c_Assessment_Definition set last_updated=getdate(), description ='History personal of nicotine dependence', long_description='History personal of nicotine dependence' where assessment_id = 'DEMO4857'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypercapnia of newborn', long_description='Hypercapnia of newborn' where assessment_id = 'DEMO6685'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoxemia of newborn', long_description='Hypoxemia of newborn' where assessment_id = 'DEMO6679Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoxia newborn', long_description='Hypoxia newborn' where assessment_id = 'DEMO6683Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Injury skeleton, birth injury specified part NEC', long_description='Injury skeleton, birth injury specified part NEC' where assessment_id = 'DEMO6671Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other problems with newborn' where assessment_id = 'DEMO6678Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other problems with newborn' where assessment_id = 'DEMO6678'
update c_Assessment_Definition set last_updated=getdate(), description ='Left ovarian pregnancy with intrauterine pregnancy', long_description='Left ovarian pregnancy with intrauterine pregnancy' where assessment_id = 'ICD-O00212'
update c_Assessment_Definition set last_updated=getdate(), description ='Condition originating in the perinatal period, unspecified' where assessment_id = 'DEMO6721Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Low birthweight (2499 grams or less)', long_description='Low birthweight (2499 grams or less)' where assessment_id = 'DEMO6656'
update c_Assessment_Definition set last_updated=getdate(), description ='Other congenital malformations of lacrimal apparatus' where assessment_id = 'DEMO211'

update c_Assessment_Definition set last_updated=getdate(), description ='Maternal malnutrition NOS', long_description='Maternal malnutrition NOS' where assessment_id = 'DEMO6503'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal malnutrition NOS', long_description='Maternal malnutrition NOS' where assessment_id = 'DEMO6503Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Mixed metabolic and respiratory acidosis of newborn', long_description='Mixed metabolic and respiratory acidosis of newborn' where assessment_id = 'DEMO6684Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for other general counseling and advice on contraception' where assessment_id = 'DEMO10322X'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surveillance of contraceptives, unspecified' where assessment_id = 'DEMO304X'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surveillance of contraceptives, unspecified' where assessment_id = 'DEMO304'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for other contraceptive management' where assessment_id = 'DEMO9432'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for other contraceptive management' where assessment_id = 'DEMO9454'

update c_Assessment_Definition set last_updated=getdate(), description ='Occupational exposure to other risk factors' where assessment_id = 'DEMO9040A'
update c_Assessment_Definition set last_updated=getdate(), description ='Occupational exposure to other risk factors' where assessment_id = 'DEMO9040'

update c_Assessment_Definition set last_updated=getdate(), description ='Contact with and (suspected) exposure to asbestos' where assessment_id = 'DEMO9039A'
update c_Assessment_Definition set last_updated=getdate(), description ='Contact with and (suspected) exposure to asbestos' where assessment_id = 'DEMO9039'

update c_Assessment_Definition set last_updated=getdate(), description ='Family history of other diseases of the digestive system' where assessment_id = '0^V18.59^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Family history of other diseases of the digestive system' where assessment_id = '0^V18.59^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of esophagus' where assessment_id = 'DEMO1407A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of esophagus' where assessment_id = 'DEMO1407'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of stomach' where assessment_id = 'DEMO1408A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of stomach' where assessment_id = 'DEMO1408'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of large intestine' where assessment_id = 'DEMO1409A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of large intestine' where assessment_id = 'DEMO1409'

update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of liver' where assessment_id = 'DEMO1411A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of liver' where assessment_id = 'DEMO1411'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by entanglement of umbilical cord', long_description='Newborn affected by entanglement of umbilical cord' where assessment_id = 'DEMO6531'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by knot in umbilical cord', long_description='Newborn affected by knot in umbilical cord' where assessment_id = 'DEMO6531Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of bronchus and lung' where assessment_id = 'DEMO9001A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of bronchus and lung' where assessment_id = 'DEMO9001'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of trachea' where assessment_id = 'DEMO9003A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of trachea' where assessment_id = 'DEMO9003'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of larynx' where assessment_id = 'DEMO1413A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of larynx' where assessment_id = 'DEMO1413'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal antineoplastic chemotherapy', long_description='Newborn affected by maternal antineoplastic chemotherapy' where assessment_id = 'Newborn affected by maternal antibiotics'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal circulatory disease', long_description='Newborn affected by maternal circulatory disease' where assessment_id = 'DEMO6501'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal cytotoxic drugs', long_description='Newborn affected by maternal cytotoxic drugs' where assessment_id = 'Newborn affected by maternal antibiotics'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal renal disease', long_description='Newborn affected by maternal renal disease' where assessment_id = 'DEMO6498'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of nasal cavities, middle ear, and acc…' where assessment_id = 'DEMO9004A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of nasal cavities, middle ear, and acc…' where assessment_id = 'DEMO9004'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of other respiratory and intrathoracic…' where assessment_id = 'DEMO1412'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of breast' where assessment_id = 'DEMO1420A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of breast' where assessment_id = 'DEMO1420'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified female genital organ' where assessment_id = 'DEMO8996A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified female genital organ' where assessment_id = 'DEMO8996'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of cervix uteri' where assessment_id = 'DEMO1414A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of cervix uteri' where assessment_id = 'DEMO1414'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of other parts of uterus' where assessment_id = 'DEMO1415A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of other parts of uterus' where assessment_id = 'DEMO1415'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of ovary' where assessment_id = 'DEMO1416A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of ovary' where assessment_id = 'DEMO1416'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified male genital organ' where assessment_id = 'DEMO8997A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified male genital organ' where assessment_id = 'DEMO8997'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of prostate' where assessment_id = 'DEMO1431A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of prostate' where assessment_id = 'DEMO1431'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of testis' where assessment_id = 'DEMO8998A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of testis' where assessment_id = 'DEMO8998'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of epididymis' where assessment_id = 'DEMO9007A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of epididymis' where assessment_id = 'DEMO9007'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of bladder' where assessment_id = 'DEMO9008A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of bladder' where assessment_id = 'DEMO9008'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of kidney' where assessment_id = 'DEMO1418A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of kidney' where assessment_id = 'DEMO1418'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of renal pelvis' where assessment_id = 'DEMO10596A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of renal pelvis' where assessment_id = 'DEMO10596'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of Hodgkin lymphoma' where assessment_id = 'DEMO1426A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of Hodgkin lymphoma' where assessment_id = 'DEMO1426'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of tongue' where assessment_id = 'DEMO1405A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of tongue' where assessment_id = 'DEMO1405'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified site of lip, oral cavit…' where assessment_id = 'DEMO1406A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified site of lip, oral cavit…' where assessment_id = 'DEMO1406'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant melanoma of skin' where assessment_id = 'DEMO1434A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant melanoma of skin' where assessment_id = 'DEMO1434'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of skin' where assessment_id = 'DEMO1435A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of skin' where assessment_id = 'DEMO1435'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of bone' where assessment_id = 'DEMO1433A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of bone' where assessment_id = 'DEMO1433'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal respiratory disease', long_description='Newborn affected by maternal respiratory disease' where assessment_id = 'DEMO6501Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal urinary tract disease', long_description='Newborn affected by maternal urinary tract disease' where assessment_id = 'DEMO6498Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of soft tissue' where assessment_id = 'DEMO1423A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of soft tissue' where assessment_id = 'DEMO1423'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of eye' where assessment_id = 'DEMO1436A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of eye' where assessment_id = 'DEMO1436'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of brain' where assessment_id = 'DEMO1419A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of brain' where assessment_id = 'DEMO1419'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of thyroid' where assessment_id = 'DEMO1437A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of malignant neoplasm of thyroid' where assessment_id = 'DEMO1437'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of colonic polyps' where assessment_id = 'DEMO9022A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of colonic polyps' where assessment_id = 'DEMO9022'

update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of poliomyelitis' where assessment_id = 'DEMO9015A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of poliomyelitis' where assessment_id = 'DEMO9015'

update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by maternal use of cannabis', long_description='Newborn affected by maternal use of cannabis' where assessment_id = 'DEMO6510Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by methamphetamine', long_description='Newborn affected by methamphetamine' where assessment_id = 'DEMO6510Q'

update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of thrombophlebitis' where assessment_id = 'DEMO1440A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of thrombophlebitis' where assessment_id = 'DEMO1440'

update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of the digestive system' where assessment_id = 'DEMO9020A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of the digestive system' where assessment_id = 'DEMO9020'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by noxious substances transmitted via placenta or breast mil…', long_description='Newborn affected by noxious substances transmitted via placenta or breast milk, cannabis' where assessment_id = 'DEMO6511'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by short umbilical cord', long_description='Newborn affected by short umbilical cord' where assessment_id = 'DEMO6514'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of diseases of the skin and subcutaneous tissue' where assessment_id = 'DEMO9025A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of diseases of the skin and subcutaneous tissue' where assessment_id = 'DEMO9025'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of the musculoskeletal system and connecti…' where assessment_id = 'DEMO4837A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of the musculoskeletal system and connecti…' where assessment_id = 'DEMO4837'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of urinary calculi' where assessment_id = 'DEMO4836A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of urinary calculi' where assessment_id = 'DEMO4836'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of urinary system' where assessment_id = 'DEMO9023A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of urinary system' where assessment_id = 'DEMO9023'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of pre-term labor' where assessment_id = 'DEMO11427A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of pre-term labor' where assessment_id = 'DEMO11427'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other complications of pregnancy, childbirth and the puer…' where assessment_id = 'DEMO9024A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other complications of pregnancy, childbirth and the puer…' where assessment_id = 'DEMO9024'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of (corrected) hypospadias' where assessment_id = 'DEMO9027A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of (corrected) hypospadias' where assessment_id = 'DEMO9027'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other (corrected) congenital malformations' where assessment_id = 'DEMO9028A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other (corrected) congenital malformations' where assessment_id = 'DEMO9028'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by umbilical cord (tightly) around neck', long_description='Newborn affected by umbilical cord (tightly) around neck' where assessment_id = 'DEMO6530Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by vasa previa', long_description='Newborn affected by vasa previa' where assessment_id = 'DEMO6515'
update c_Assessment_Definition set last_updated=getdate(), description ='Postoperative state NEC', long_description='Postoperative state NEC' where assessment_id = 'DEMO9030'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of nicotine dependence' where assessment_id = 'DEMO9038'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of nicotine dependence' where assessment_id = 'DEMO9038A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9029A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9029'
update c_Assessment_Definition set last_updated=getdate(), description ='Patient''s noncompliance with other medical treatment and regimen' where assessment_id = 'DEMO1430A'
update c_Assessment_Definition set last_updated=getdate(), description ='Patient''s noncompliance with other medical treatment and regimen' where assessment_id = 'DEMO1430'
update c_Assessment_Definition set last_updated=getdate(), description ='Presence (of) contact lens(es)', long_description='Presence (of) contact lens(es)' where assessment_id = 'DEMO9067'
update c_Assessment_Definition set last_updated=getdate(), description ='Solitary ulcer of anus and rectum', long_description='Solitary ulcer of anus and rectum' where assessment_id = '0^11612'
update c_Assessment_Definition set last_updated=getdate(), description ='Status postsurgical', long_description='Status postsurgical' where assessment_id = 'DEMO9030A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of adult physical and sexual abuse' where assessment_id = 'DEMO4850'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of adult neglect' where assessment_id = 'DEMO9034a'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of adult neglect' where assessment_id = 'DEMO9034'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified personal risk factors, not elsewhere classified' where assessment_id = 'DEMO9036A'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified personal risk factors, not elsewhere classified' where assessment_id = 'DEMO9036'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of contraception' where assessment_id = 'DEMO9037A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of contraception' where assessment_id = 'DEMO9037'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of irradiation' where assessment_id = 'DEMO1432A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of irradiation' where assessment_id = 'DEMO1432'
update c_Assessment_Definition set last_updated=getdate(), description ='Torticollis (intermittent) (spastic) due to birth injury', long_description='Torticollis (intermittent) (spastic) due to birth injury ' where assessment_id = 'DEMO6677Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Presence of spectacles and contact lenses' where assessment_id = 'DEMO1448'
update c_Assessment_Definition set last_updated=getdate(), description ='Vaccination for diphtheria, tetanus and acellular pertussis (dtap)', long_description='Vaccination for diphtheria, tetanus and acellular pertussis (dtap)' where assessment_id = '0^V03.5'
update c_Assessment_Definition set last_updated=getdate(), description ='Vaccination for tetanus and diphtheria', long_description='Vaccination for tetanus and diphtheria' where assessment_id = 'DEMO9396'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified postprocedural states' where assessment_id = 'DEMO4848A'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified postprocedural states' where assessment_id = 'DEMO4848'

--   column L, icd code updates
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0489' where assessment_id = 'DEMO6510'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0481' where assessment_id = 'DEMO6510Q'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0411' where assessment_id = 'DEMO6508'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0412' where assessment_id = 'DEMO6508Q'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0481' where assessment_id = 'DEMO6511'

--   column N, category updates
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6679'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6683'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO898'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='RPERI' where assessment_id = 'DEMO898a'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6684'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6677'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6721'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6671'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6673'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'SUB'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9002A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO4851A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9005A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9006A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9019A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9009A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9026A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO4857A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO4850A'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6685'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6656'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO10322X'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OB' where assessment_id = 'DEMO9432'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6507'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6501'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6498'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6514'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='OBP' where assessment_id = 'DEMO6515'
update c_Assessment_Definition set last_updated=getdate(), assessment_category_id ='Z' where assessment_id = 'DEMO9030A'

--   second wave (FreshDuplicatesWCategory-selectedWithAllSameICD-response.xlsx)
update c_Assessment_Definition set last_updated=getdate(), description ='Other problems with newborn' where assessment_id = 'DEMO6678'
update c_Assessment_Definition set last_updated=getdate(), description ='Other congenital malformations of lacrimal apparatus' where assessment_id = 'DEMO211'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9029A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9029'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia antenatal', long_description='Asphyxia antenatal', [source]='Dx' where assessment_id = '0^775.81^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia postnatal', long_description='Asphyxia postnatal', [source]='Dx' where assessment_id = '0^770.88^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia prenatal', long_description='Asphyxia prenatal', [source]='Dx' where assessment_id = '0^770.88^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia, newborn', long_description='Asphyxia, newborn', [source]='Dx' where assessment_id = 'DEMO6685Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Distress fetal', long_description='Distress fetal', [source]='Dx' where assessment_id = '0^768.9^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoxia newborn', long_description='Hypoxia newborn', [source]='Dx' where assessment_id = 'DEMO6683Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Mixed metabolic and respiratory acidosis of newborn', long_description='Mixed metabolic and respiratory acidosis of newborn', [source]='IncT' where assessment_id = 'DEMO6684Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Acidemia of newborn', long_description='Acidemia of newborn', [source]='IncT' where assessment_id = 'DEMO6679'
update c_Assessment_Definition set last_updated=getdate(), description ='Acidosis of newborn', long_description='Acidosis of newborn', [source]='IncT' where assessment_id = 'DEMO6683'
update c_Assessment_Definition set last_updated=getdate(), description ='Anoxia cerebral newborn', long_description='Anoxia cerebral newborn', [source]='Dx' where assessment_id = 'DEMO6684'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypercapnia of newborn', long_description='Hypercapnia of newborn', [source]='IncT' where assessment_id = 'DEMO6685'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoxemia of newborn', long_description='Hypoxemia of newborn', [source]='IncT' where assessment_id = 'DEMO6679Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Other problems with newborn' where assessment_id = 'DEMO6678Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Malformation (congenital) lacrimal apparatus', long_description='Malformation (congenital) lacrimal apparatus', [source]='Dx' where assessment_id = 'DEMO5756'
update c_Assessment_Definition set last_updated=getdate(), description ='Accessory lacrimal canal', long_description='Accessory lacrimal canal', [source]='Dx' where assessment_id = 'DEMO5757'
update c_Assessment_Definition set last_updated=getdate(), description ='Supernumerary lacrimonasal duct', long_description='Supernumerary lacrimonasal duct', [source]='Dx' where assessment_id = 'DEMO5758'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital diverticulum of left ventricle', long_description='Congenital diverticulum of left ventricle', [source]='IncT' where assessment_id = 'DEMO128'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified congenital malformations of heart' where assessment_id = 'DEMO128'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital malformation of pericardium', long_description='Congenital malformation of pericardium', [source]='IncT' where assessment_id = 'DEMO2037'
update c_Assessment_Definition set last_updated=getdate(), description ='Malposition of heart', long_description='Malposition of heart', [source]='IncT' where assessment_id = 'DEMO2038'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital malformation of myocardium', long_description='Congenital malformation of myocardium', [source]='IncT' where assessment_id = 'DEMO2039'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified congenital malformations of heart' where assessment_id = 'DEMO2040'
update c_Assessment_Definition set last_updated=getdate(), description ='Cyst pericardial', long_description='Cyst pericardial', [source]='IncT' where assessment_id = 'DEMO2041'
update c_Assessment_Definition set last_updated=getdate(), description ='Stenosis heart valve congenital', long_description='Stenosis heart valve congenital', [source]='IncT' where assessment_id = 'DEMO2042'


--   update for Dx source (highlighted purple)
UPDATE c_Assessment_Definition 
SET source = 'Dx' 
WHERE assessment_id IN
('DEMO5757', 'DEMO6679', 'DEMO6683', 'DEMO6684', 'DEMO6685Q', 
'DEMO6677', 'DEMO10322', 'DEMO6721', 'DEMO6673Q', 'DEMO7179', 
'DEMO11548', 'DEMO6671', 'DEMO6673', 'SUB', 'SUBQ', 'DEMO9002A', 
'DEMO9002', 'DEMO9005', 'DEMO9019', 'DEMO4851A', 
'DEMO9005A', 'DEMO9006', 'DEMO9009', 'DEMO9006A', 'DEMO9019A', 
'DEMO9009A', 'DEMO9026A', 'DEMO191', 'DEMO4851', 'DEMO9026', 
'DEMO4857A', 'DEMO4850A', 'DEMO4857', 'DEMO6685', 'DEMO6679Q', 
'DEMO6683Q', 'DEMO6671Q', 'DEMO6656', 'DEMO6503', 
'DEMO6503Q', 'DEMO6684Q', 'DEMO10322X', 'DEMO6507', 
'DEMO6531', 'DEMO6531Q', 'DEMO6508', 'DEMO6501', 'DEMO6508Q', 
'DEMO6498', 'DEMO6501Q', 'DEMO6498Q', 'DEMO6507Q', 
'DEMO6511', 'DEMO6514', 'DEMO6530Q', 'DEMO6515', 'DEMO9030', 
'DEMO9067', '0^11612', 'DEMO9030A', 'DEMO6677Q', '0^V03.5', 
'DEMO9396')

--   Add new Dx assessments
CREATE TABLE #new_assess (
	icd10_code varchar(10), 
	assessment_type varchar(24),
	assessment_category_id varchar(24),
	description varchar(400),
	long_description text,
	[source] varchar(10))

INSERT INTO #new_assess VALUES ('P002', 'OB', 'OBP', 'Abscess navel newborn without hemorrhage', null, 'Dx')
INSERT INTO #new_assess VALUES ('P002', 'OB', 'OBP', 'Absorption chemical through placenta', null, 'Dx')
INSERT INTO #new_assess VALUES ('P002', 'OB', 'OBP', 'Arrhythmia newborn occurring before birth before onset of labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0089', 'OB', 'OBP', 'Arrhythmia newborn occurring before birth during labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0089', 'OB', 'OBP', 'Bell''s palsy, infant or newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P014', 'OB', 'OBP', 'Cellulitis navel newborn without hemorrhage', null, 'Dx')
INSERT INTO #new_assess VALUES ('P017', 'OB', 'OBP', 'Compression during birth', null, 'Dx')
INSERT INTO #new_assess VALUES ('P017', 'OB', 'OBP', 'Crack baby', null, 'Dx')
INSERT INTO #new_assess VALUES ('P017', 'OB', 'OBP', 'Diseased, facial nerve newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P017', 'OB', 'OBP', 'Dysrhythmia cardiac newborn occurring before birth before onset of labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P017', 'OB', 'OBP', 'Dysrhythmia cardiac newborn occurring before birth during labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Dystocia affecting newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Dystocia cervical affecting newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Facial palsy due to birth injury', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Ganglionitis geniculate newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Hyperbilirubinemia of prematurity', null, 'Dx')
INSERT INTO #new_assess VALUES ('P021', 'OB', 'OBP', 'Hypertrophy breast newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0229', 'OB', 'OBP', 'Icterus newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0229', 'OB', 'OBP', 'Injury forceps NOS', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0229', 'OB', 'OBP', 'Injury, brachial plexus, newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0229', 'OB', 'OBP', 'Jaundice due to or associated with delayed conjugation associated with preter…',  'Jaundice due to or associated with delayed conjugation associated with preterm delivery', 'Dx')
INSERT INTO #new_assess VALUES ('P031', 'OB', 'OBP', 'Jaundice newborn due to breast milk inhibitors to conjugation associated with…',  'Jaundice newborn due to breast milk inhibitors to conjugation associated with preterm delivery', 'Dx')
INSERT INTO #new_assess VALUES ('P031', 'OB', 'OBP', 'Jaundice newborn due to or associated with absence or deficiency of enzyme sy…',  'Jaundice newborn due to or associated with absence or deficiency of enzyme system for bilirubin conjugation', 'Dx')
INSERT INTO #new_assess VALUES ('P031', 'OB', 'OBP', 'Jaundice newborn due to or associated with delayed conjugation', null, 'Dx')
INSERT INTO #new_assess VALUES ('P031', 'OB', 'OBP', 'Jaundice newborn due to or associated with hereditary hemolytic anemia', null, 'Dx')
INSERT INTO #new_assess VALUES ('P031', 'OB', 'OBP', 'Jaundice symptomatic newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P036', 'OB', 'OBP', 'Neonatal (idiopathic) hepatitis', null, 'Dx')
INSERT INTO #new_assess VALUES ('P036', 'OB', 'OBP', 'Neonatal giant cell hepatitis', null, 'Dx')
INSERT INTO #new_assess VALUES ('P036', 'OB', 'OBP', 'Neonatal physiological jaundice (intense)(prolonged) NOS', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03810', 'OB', 'OBP', 'Neuritis cranial nerve seventh or facial newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03810', 'OB', 'OBP', 'Newborn affected by abdominal pregnancy', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03810', 'OB', 'OBP', 'Newborn affected by abruptio placenta', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03811', 'OB', 'OBP', 'Newborn affected by accidental hemorrhage', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03811', 'OB', 'OBP', 'Newborn affected by antepartum hemorrhage', null, 'Dx')
INSERT INTO #new_assess VALUES ('P03811', 'OB', 'OBP', 'Newborn affected by breech presentation before labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P040', 'OB', 'OBP', 'Newborn affected by contracted pelvis', null, 'Dx')
INSERT INTO #new_assess VALUES ('P040', 'OB', 'OBP', 'Newborn affected by damage to placenta from amniocentesis, cesarean delivery …',  'Newborn affected by damage to placenta from amniocentesis, cesarean delivery or surgical induction', 'Dx')
INSERT INTO #new_assess VALUES ('P040', 'OB', 'OBP', 'Newborn affected by external version before labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P040', 'OB', 'OBP', 'Newborn affected by face presentation before labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P040', 'OB', 'OBP', 'Newborn affected by hypertonic labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P0441', 'OB', 'OBP', 'Newborn affected by malpresentation', null, 'Dx')
INSERT INTO #new_assess VALUES ('P049', 'OB', 'OBP', 'Newborn affected by maternal analgesia', null, 'Dx')
INSERT INTO #new_assess VALUES ('P049', 'OB', 'OBP', 'Newborn affected by maternal anesthesia', null, 'Dx')
INSERT INTO #new_assess VALUES ('P049', 'OB', 'OBP', 'Newborn affected by maternal blood loss', null, 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal genital tract or other localized infections', null, 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal infectious disease', null, 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal opiates administered for procedures during pregn…',  'Newborn affected by maternal opiates administered for procedures during pregnancy or labor and delivery', 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal parasitic disease', null, 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal systemic lupus erythematosus', null, 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by maternal tranquilizers administered for procedures during…',  'Newborn affected by maternal tranquilizers administered for procedures during pregnancy or labor and delivery', 'Dx')
INSERT INTO #new_assess VALUES ('P113', 'OB', 'OBP', 'Newborn affected by noxious substances transmitted through placenta or breast…',  'Newborn affected by noxious substances transmitted through placenta or breast milk', 'Dx')
INSERT INTO #new_assess VALUES ('P143', 'OB', 'OBP', 'Newborn affected by persistent occipitoposterior', null, 'Dx')
INSERT INTO #new_assess VALUES ('P143', 'OB', 'OBP', 'Newborn affected by placental abnormality specified NEC', null, 'Dx')
INSERT INTO #new_assess VALUES ('P148', 'OB', 'OBP', 'Newborn affected by placental dysfunction', null, 'Dx')
INSERT INTO #new_assess VALUES ('P159', 'OB', 'OBP', 'Newborn affected by placental infarction', null, 'Dx')
INSERT INTO #new_assess VALUES ('P159', 'OB', 'OBP', 'Newborn affected by placental insufficiency', null, 'Dx')
INSERT INTO #new_assess VALUES ('P389', 'OB', 'OBP', 'Newborn affected by premature separation of placenta', null, 'Dx')
INSERT INTO #new_assess VALUES ('P389', 'OB', 'OBP', 'Newborn affected by reactions and intoxications from maternal opiates and tra…',  'Newborn affected by reactions and intoxications from maternal opiates and tranquilizers administered for procedures during pregnancy or labor and delivery', 'Dx')
INSERT INTO #new_assess VALUES ('P588', 'OB', 'OBP', 'Newborn affected by transverse lie', null, 'Dx')
INSERT INTO #new_assess VALUES ('P590', 'OB', 'OBP', 'Newborn affected by transverse lie before labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P590', 'OB', 'OBP', 'Newborn affected by unstable lie before labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P590', 'OB', 'OBP', 'Newborn affected by uterine inertia', null, 'Dx')
INSERT INTO #new_assess VALUES ('P5929', 'OB', 'OBP', 'Newborn hyperbilirubinemia', null, 'Dx')
INSERT INTO #new_assess VALUES ('P5929', 'OB', 'OBP', 'Newborn jaundice', null, 'Dx')
INSERT INTO #new_assess VALUES ('P5929', 'OB', 'OBP', 'Newborn jaundice due to or associated with hepatocellular damage specified NEC', null, 'Dx')
INSERT INTO #new_assess VALUES ('P598', 'OB', 'OBP', 'Newborn affected by heart rate abnormalities intrauterine before onset of labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P598', 'OB', 'OBP', 'Newborn affected by heart rate abnormalities intrauterine during labor', null, 'Dx')
INSERT INTO #new_assess VALUES ('P599', 'OB', 'OBP', 'Noxious substances transmitted through placenta or breast milk', null, 'Dx')
INSERT INTO #new_assess VALUES ('P599', 'OB', 'OBP', 'Palsy facial newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P599', 'OB', 'OBP', 'Palsy, brachial plexus newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P599', 'OB', 'OBP', 'Paralysis facial congenital', null, 'Dx')
INSERT INTO #new_assess VALUES ('P599', 'OB', 'OBP', 'Syndrome lower radicular, newborn', null, 'Dx')
INSERT INTO #new_assess VALUES ('P834', 'OB', 'OBP', 'TORCH infection without active infection', null, 'Dx')
INSERT INTO #new_assess VALUES ('Q240', 'OB', 'OBP', 'Transposition heart', null, 'Dx')

--   Second wave (FreshDuplicatesWCategory-selectedWithAllSameICD-response.xlsx)
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Brugada syndrome', null, 'IncT')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Coronary sinus rhythm disorder', null, 'IncT')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Ectopic rhythm disorder', null, 'IncT')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Nodal rhythm disorder', null, 'IncT')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Fibrillation cardiac', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Rhythm disorder coronary sinus', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Rhythm atrioventricular nodal', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Sinus arrhythmia', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Flutter heart', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Wandering pacemaker', null, 'Dx')
INSERT INTO #new_assess VALUES ('I498', 'SICK', 'OCARDIO', 'Arrhythmia specified NEC', null, 'Dx')
INSERT INTO #new_assess VALUES ('Q248', 'SICK', 'OCARDIO', 'Atresia, heart valve NEC', null, 'Dx')
INSERT INTO #new_assess VALUES ('Q248', 'SICK', 'OCARDIO', 'Hypoplasia cardiac', null, 'Dx')
INSERT INTO #new_assess VALUES ('Q248', 'SICK', 'OCARDIO', 'Hemicardia', null, 'Dx')
INSERT INTO #new_assess VALUES ('Q248', 'SICK', 'OCARDIO', 'Hypertrophy cardiac congenital NEC', null, 'Dx')
INSERT INTO #new_assess VALUES ('Z90710', 'SICK', 'ZZMISC', 'Status post total hysterectomy', null, 'IncT')
INSERT INTO #new_assess VALUES ('Z90710', 'SICK', 'ZZMISC', 'History personal of hysterectomy', null, 'Dx')
INSERT INTO #new_assess VALUES ('Z90710', 'SICK', 'ZZMISC', 'Absence of cervix (acquired) (with uterus)', null, 'Dx')
INSERT INTO #new_assess VALUES ('F200', 'SICK', 'MENTAL', 'Paraphrenic schizophrenia', null, 'IncT')
INSERT INTO #new_assess VALUES ('F200', 'SICK', 'MENTAL', 'Psychosis paranoid schizophrenic', null, 'Dx')


CREATE TABLE #new_assess2 (
	assessment_id varchar(24), 
	icd10_code varchar(10), 
	assessment_type varchar(24),
	assessment_category_id varchar(24),
	description varchar(400),
	long_description text,
	[source] varchar(10))

INSERT INTO #new_assess2
SELECT
	'Dx-' + #new_assess.icd10_code + '-' 
		+ convert(varchar(3), 
			row_number() over (
				partition by #new_assess.icd10_code 
				order by #new_assess.description
				)
			),  -- derived from Diagnosis Index for ICD10 code
	icd10_code,
	assessment_type,
	assessment_category_id,
	description,
	long_description,
	[source]
FROM #new_assess

INSERT INTO c_Assessment_Definition (
	assessment_id,
	assessment_type,
	icd10_code,
	assessment_category_id,
	description,
	long_description,
	[source],
	risk_level,
	owner_id,
	status )
SELECT
	#new_assess2.assessment_id,
	assessment_type,
	#new_assess2.icd10_code,
	assessment_category_id,
	#new_assess2.description,
	#new_assess2.long_description,
	[source],
	2, -- default risk level
	981, -- default owner
	'OK' -- default status
FROM #new_assess2
-- re-entrancy
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a 
	WHERE a.assessment_id = #new_assess2.assessment_id )
