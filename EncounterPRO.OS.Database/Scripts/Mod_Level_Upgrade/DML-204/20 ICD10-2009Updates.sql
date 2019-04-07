-- clean up 2018 data to make it comparable
UPDATE icd10cm_codes_2018
SET descr = replace(RTRIM(descr),'   ',' ')
WHERE descr LIKE '%   %'

UPDATE icd10cm_codes_2018
SET descr = replace(RTRIM(descr),'  ',' ')
WHERE descr LIKE '%  %'

UPDATE icd10cm_codes_2018
SET code = RTRIM(code)
WHERE code != RTRIM(code)

UPDATE icd10cm_codes_2018
SET descr = RTRIM(descr)
WHERE descr != RTRIM(descr)

UPDATE c_Assessment_Definition
SET long_description = replace(LTRIM(RTRIM(long_description)),'  ',' ')
WHERE long_description != replace(LTRIM(RTRIM(long_description)),'  ',' ')

UPDATE c_Assessment_Definition
SET description = replace(LTRIM(RTRIM(description)),'  ',' ')
WHERE description != replace(LTRIM(RTRIM(description)),'  ',' ')

SELECT * 
INTO #revised
FROM icd10cm_codes_2018 old
WHERE NOT EXISTS (SELECT 1 
			FROM icd10cm_codes_2019 new 
			WHERE new.code = old.code and new.descr = old.descr)
-- 162

SELECT * 
INTO #revisions
FROM icd10cm_codes_2019 new
WHERE NOT EXISTS (SELECT 1 
			FROM icd10cm_codes_2018 old 
			WHERE new.code = old.code and new.descr = old.descr)
-- 390

--12 purely code changes, but exclude those handled manually below due to multiple targets leaving 4 to handle
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code = 'F531' WHERE assessment_id = 'DEMO9606'
-- Update the assessment_id to match since we know they don't have usage yet
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code = 'E7849', assessment_id = 'ICD-E7849' WHERE assessment_id = 'ICD-E784'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code = 'I6389', assessment_id = 'ICD-I6389' WHERE assessment_id = 'ICD-I638'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code = 'Q9359', assessment_id = 'ICD-Q9359' WHERE assessment_id = 'ICD-Q935'

UPDATE a
SET last_updated=getdate(), 
	a.description = CASE WHEN LEN(new.descr) > 80 THEN SUBSTRING(new.descr,1,77)+'...'
	ELSE new.descr END,
	a.long_description = CASE WHEN LEN(new.descr) > 80 THEN new.descr
	ELSE NULL END
--SELECT old.code, old.descr, new.descr, a.description, a.long_description
FROM #revisions new JOIN #revised old ON old.code = new.code
JOIN c_Assessment_Definition a ON a.icd10_code = old.code
WHERE icd10_code NOT IN ('S62659A','S62659B') -- these each have two assessments for the one ICD10 code
AND (a.description != CASE WHEN LEN(new.descr) > 80 THEN SUBSTRING(new.descr,1,77)+'...'
	ELSE new.descr END
	OR (LEN(new.descr) <= 80 AND long_description IS NOT NULL)
	OR (LEN(new.descr) > 80 AND long_description != new.descr)
	)
-- 109 purely description changes

-- get the last two by assessment_id
UPDATE a
SET last_updated=getdate(), 
	a.description = CASE WHEN LEN(new.descr) > 80 THEN SUBSTRING(new.descr,1,77)+'...'
	ELSE new.descr END,
	a.long_description = CASE WHEN LEN(new.descr) > 80 THEN new.descr
	ELSE NULL END
--SELECT old.code, new.descr, a.description
FROM #revisions new JOIN #revised old ON old.code = new.code
JOIN c_Assessment_Definition a ON a.icd10_code = old.code
WHERE assessment_id IN ('DEMO4585','DEMO4586')
AND (a.description != CASE WHEN LEN(new.descr) > 80 THEN SUBSTRING(new.descr,1,77)+'...'
	ELSE new.descr END
	OR (LEN(new.descr) <= 80 AND long_description IS NOT NULL)
	OR (LEN(new.descr) > 80 AND long_description != new.descr)
	)

SELECT icd10cm_codes_2018.code as old_code, #revisions.code, #revisions.descr
INTO #map_multiple
FROM icd10cm_codes_2018 JOIN #revisions 
	ON #revisions.code LIKE icd10cm_codes_2018.code + '%'
	WHERE #revisions.code != icd10cm_codes_2018.code
-- 142 maps to higher specificity

SELECT * 
INTO #additions 
FROM #revisions
WHERE code NOT IN (SELECT new.code 
	FROM #revisions new JOIN #revised old ON old.code = new.code)
AND code NOT IN (SELECT code FROM #map_multiple)
AND NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a WHERE a.icd10_code = #revisions.code)
-- 137

-- Prevent subquery problem
update c_Assessment_Category SET icd10_start = null, icd10_end = null, is_default = 'N'
where assessment_category_id = 'MA'

-- Additions
INSERT INTO c_Assessment_Definition (
	assessment_id,
	source,
	assessment_type,
	icd10_code,
	assessment_category_id,
	description,
	long_description,
	risk_level,
	owner_id,
	status )
SELECT
	'ICD-' + #additions.code,
	'MainT', 
	c.assessment_type,
	#additions.code,
	c.assessment_category_id,
	CASE WHEN LEN(#additions.descr) > 80 THEN SUBSTRING(#additions.descr,1,77)+'...'
		ELSE #additions.descr END,
	CASE WHEN LEN(#additions.descr) > 80 THEN #additions.descr
		ELSE NULL END,
	2, -- default risk level
	981, -- default owner
	'OK' -- default status
FROM #additions join c_Assessment_Category c 
		ON #additions.code BETWEEN c.icd10_start AND c.icd10_end + 'z'
		AND c.is_default = 'Y'
-- re-entrancy
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a WHERE a.icd10_code = #additions.code)
-- 137

-- Multiple Maps (ICD10_2019 Multiple matches_response 1.xslx)

UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by maternal antineoplastic chemotherapy' where assessment_id = 'DEMO6508'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by maternal cytotoxic drugs' where assessment_id = 'DEMO6508Q'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by maternal use of anticonvulsants' where assessment_id = '0^12037'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by other maternal medication' where assessment_id = '0^12038'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other abnormal findings in urine' where assessment_id = 'DEMO10205'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of amino-acid metabolism' where assessment_id = 'DEMO4767'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of eye and adnexa' where assessment_id = 'DEMO10491'

UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='E723' where assessment_id = 'DEMO4769'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='E7251' where assessment_id = 'DEMO4768'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='E7289' where assessment_id = 'DEMO4767'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='H5789' where assessment_id = 'DEMO10491'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='H579' where assessment_id = 'DEMO233'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='H579' where assessment_id = 'DEMO6634'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='K611' where assessment_id = 'DEMO7922'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='K6131' where assessment_id = 'DEMO7924'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='K6139' where assessment_id = 'DEMO10435'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='K6139' where assessment_id = 'DEMO7923'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='K6139' where assessment_id = 'DEMO7925'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='N35811' where assessment_id = 'ICD-N358'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='N35911' where assessment_id = 'DEMO7046'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='N35912' where assessment_id = 'DEMO8966'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0411' where assessment_id = 'DEMO6508'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0412' where assessment_id = 'DEMO6508Q'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0413' where assessment_id = '0^12037'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0418' where assessment_id = '0^12038'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0481' where assessment_id = 'DEMO6510Q'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0481' where assessment_id = 'DEMO6511'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P0489' where assessment_id = 'DEMO6510'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P7441' where assessment_id = 'HYMAG'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='P7449' where assessment_id = 'DEMO6727'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R825' where assessment_id = 'DEMO1288'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R825' where assessment_id = 'DEMO2129'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R825' where assessment_id = 'DEMO2130'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R825' where assessment_id = 'DEMO2131'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R82998' where assessment_id = 'DEMO10205'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R82998' where assessment_id = 'DEMO1286'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R82998' where assessment_id = 'DEMO1287'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R82998' where assessment_id = 'DEMO2132'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R82998' where assessment_id = 'DEMO8995'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R931' where assessment_id = 'DEMO1219'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R931' where assessment_id = 'DEMO2134'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R9389' where assessment_id = '0^793.99^0'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R9389' where assessment_id = '0^793.99^1'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='R9389' where assessment_id = 'DEMO2135'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='Z0489' where assessment_id = 'DEMO9293'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='Z0489' where assessment_id = 'DEMO9551'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='Z1342' where assessment_id = 'DEMO9351'
UPDATE c_Assessment_Definition SET last_updated=getdate(), icd10_code ='Z1342' where assessment_id = 'DEMO9352'

-- Multiple Maps (ICD10_2019 Multiple matches_response 2.xslx) (corrections)

UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Hyperglycinemia' where assessment_id = 'DEMO4768'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Saccharopinuria' where assessment_id = 'DEMO4769'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Eye mass', long_description='Eye mass' where assessment_id = 'DEMO233'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Eye discharge', long_description='Eye discharge' where assessment_id = 'DEMO6634'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Perirectal abscess' where assessment_id = 'DEMO7922'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Horseshoe abscess', long_description='Horseshoe abscess' where assessment_id = 'DEMO7924'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of ischiorectal fossa', long_description='Abscess of ischiorectal fossa' where assessment_id = 'DEMO10435'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other ischiorectal abscess', long_description='Other ischiorectal abscess' where assessment_id = 'DEMO7923'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Fistula ischiorectal ', long_description='Fistula ischiorectal ' where assessment_id = 'DEMO7925'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified urethral stricture, male, meatal', long_description='Unspecified urethral stricture, male, meatal' where assessment_id = 'DEMO7046'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified bulbous urethral stricture, male', long_description='Unspecified bulbous urethral stricture, male' where assessment_id = 'DEMO8966'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by other maternal noxious substances' where assessment_id = 'DEMO6510'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by maternal use of cannabis', long_description='Newborn affected by maternal use of cannabis' where assessment_id = 'DEMO6510Q'
UPDATE c_Assessment_Definition SET last_updated=getdate(), 
	description ='Newborn affected by noxious substances transmitted via placenta or breast mil...', 
	long_description='Newborn affected by noxious substances transmitted via placenta or breast milk, cannabis' 
	where assessment_id = 'DEMO6511'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other transitory electrolyte disturbance of newborn', long_description='Other transitory electrolyte disturbance of newborn' where assessment_id = 'DEMO6727'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Alkalosis of newborn', long_description='Alkalosis of newborn' where assessment_id = 'HYMAG'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Elevated urine level of vanillylmandelic acid (VMA)', long_description='Elevated urine level of vanillylmandelic acid (VMA)' where assessment_id = 'DEMO2131'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Elevated urine levels of 17-ketosteroids', long_description='Elevated urine levels of 17-ketosteroids' where assessment_id = 'DEMO1288'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Elevated urine levels of catecholamines', long_description='Elevated urine levels of catecholamines' where assessment_id = 'DEMO2129'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Elevated urine levels of indoleacetic acid', long_description='Elevated urine levels of indoleacetic acid' where assessment_id = 'DEMO2130'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Primary hyperoxaluria', long_description='Primary hyperoxaluria' where assessment_id = 'ICD-E7253'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Casts in urine' where assessment_id = 'DEMO1286'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Crystalluria' where assessment_id = 'DEMO1287'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Melanuria' where assessment_id = 'DEMO2132'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Uricosuria' where assessment_id = 'DEMO8995'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Findings abnormal radiologic (X-ray) placenta', long_description='Findings abnormal radiologic (X-ray) placenta' where assessment_id = '0^793.99^0'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal findings on diagnostic imaging of other specified body structures' where assessment_id = '0^793.99^1'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Abnormal echocardiogram' where assessment_id = 'DEMO1219'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Abnormal heart shadow' where assessment_id = 'DEMO2134'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Abnormal mediastinal shift' where assessment_id = 'DEMO2135'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Observation following inflicted injury' where assessment_id = 'DEMO9293'
UPDATE c_Assessment_Definition SET last_updated=getdate(), long_description ='Request for expert evidence' where assessment_id = 'DEMO9551'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Screening developmental handicap in early childhood', long_description='Screening developmental handicap in early childhood' where assessment_id = 'DEMO9351'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for developmental handicaps in early childhood', long_description='Encounter for screening for developmental handicaps in early childhood' where assessment_id = 'DEMO9352'
UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Other urethral stricture, male, meatal', long_description='Other urethral stricture, male, meatal' where assessment_id = 'ICD-N358'

UPDATE c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified disorder of eye and adnexa', long_description=NULL where assessment_id = 'DEMO6633'


CREATE TABLE #new_assess (icd10_code varchar(10), description varchar(400))

INSERT INTO #new_assess VALUES ('E723','Glutaric aciduria NOS')
INSERT INTO #new_assess VALUES ('E723','Glutaric aciduria (type I)')
INSERT INTO #new_assess VALUES ('E723','Hydroxylysinemia')
INSERT INTO #new_assess VALUES ('E723','Hyperlysinemia')
INSERT INTO #new_assess VALUES ('E7251','Glucoglycinuria')
INSERT INTO #new_assess VALUES ('E7281','Disorders of gamma aminobutyric acid metabolism')
INSERT INTO #new_assess VALUES ('E7281','4-hydroxybutyric aciduria')
INSERT INTO #new_assess VALUES ('E7281','Disorders of GABA metabolism')
INSERT INTO #new_assess VALUES ('E7281','GABA metabolic defect')
INSERT INTO #new_assess VALUES ('E7281','GABA transaminase deficiency')
INSERT INTO #new_assess VALUES ('E7281','GABA-T deficiency')
INSERT INTO #new_assess VALUES ('E7281','Gamma-hydroxybutyric aciduria')
INSERT INTO #new_assess VALUES ('E7281','SSADHD')
INSERT INTO #new_assess VALUES ('E7281','Succinic semialdehyde dehydrogenase deficiency')
INSERT INTO #new_assess VALUES ('E7289','Disorders of beta-amino-acid metabolism')
INSERT INTO #new_assess VALUES ('E7289','Disorders of gamma-glutamyl cycle')
INSERT INTO #new_assess VALUES ('H57811','Brow ptosis, right')
INSERT INTO #new_assess VALUES ('H57812','Brow ptosis, left')
INSERT INTO #new_assess VALUES ('H57813','Brow ptosis, bilateral')
INSERT INTO #new_assess VALUES ('H57819','Brow ptosis, unspecified')
INSERT INTO #new_assess VALUES ('H5789','Cyst eye NEC')
INSERT INTO #new_assess VALUES ('H5789','Disease, eye inflammatory NEC')
INSERT INTO #new_assess VALUES ('H5789','Disease, eye specified NEC')
INSERT INTO #new_assess VALUES ('H5789','Hemorrhage, eye NEC')
INSERT INTO #new_assess VALUES ('H5789','Melanosis, eye NEC')
INSERT INTO #new_assess VALUES ('N35913','Unspecified membranous urethral stricture, male')
INSERT INTO #new_assess VALUES ('N35914','Unspecified anterior urethral stricture, male')
INSERT INTO #new_assess VALUES ('N35916','Unspecified urethral stricture, male, overlapping sites')
INSERT INTO #new_assess VALUES ('N35919','Unspecified urethral stricture, male, unspecified site')
INSERT INTO #new_assess VALUES ('N35919','Pinhole meatus NOS')
INSERT INTO #new_assess VALUES ('N35919','Urethral stricture NOS')
INSERT INTO #new_assess VALUES ('N35919','Spasm(s) urethra')
INSERT INTO #new_assess VALUES ('N35919','Tight, urethral sphincter')
INSERT INTO #new_assess VALUES ('N3592','Unspecified urethral stricture, female')
INSERT INTO #new_assess VALUES ('P0411','Newborn affected by chemotherapy agents')
INSERT INTO #new_assess VALUES ('P0414','Newborn affected by maternal use of opiates')
INSERT INTO #new_assess VALUES ('P0415','Newborn affected by maternal use of antidepressants')
INSERT INTO #new_assess VALUES ('P0416','Newborn affected by maternal use of amphetamines')
INSERT INTO #new_assess VALUES ('P0417','Newborn affected by maternal use of sedative-hypnotics')
INSERT INTO #new_assess VALUES ('P041A','Newborn affected by maternal use of anxiolytics')
INSERT INTO #new_assess VALUES ('P0418','Newborn affected by maternal medication specified type NEC')
INSERT INTO #new_assess VALUES ('P0419','Newborn affected by maternal use of unspecified medication')
INSERT INTO #new_assess VALUES ('P0419','Absorption, drug NEC medicinal through placenta (newborn)')
INSERT INTO #new_assess VALUES ('P7441','Hyperbicarbonatemia')
INSERT INTO #new_assess VALUES ('P7441','Alkalosis metabolic of newborn')
INSERT INTO #new_assess VALUES ('P74421','Hyperchloremia of newborn')
INSERT INTO #new_assess VALUES ('P74421','Hyperchloremic metabolic acidosis')
INSERT INTO #new_assess VALUES ('P74421','Disturbance(s) electrolyte newborn, transitory, hyperchloremia')
INSERT INTO #new_assess VALUES ('P74421','Disturbance(s) electrolyte newborn, transitory, hyperchloremic metabolic acidosis')
INSERT INTO #new_assess VALUES ('P74422','Hypochloremia of newborn')
INSERT INTO #new_assess VALUES ('P74422','Disturbance(s) electrolyte newborn, transitory, hypochloremia')
INSERT INTO #new_assess VALUES ('P7449','Disturbance(s) electrolyte newborn, transitory, specified type NEC')
INSERT INTO #new_assess VALUES ('P7449','Imbalance electrolyte neonatal, transitory NEC')
INSERT INTO #new_assess VALUES ('R82991','Hypocitraturia')
INSERT INTO #new_assess VALUES ('R82992','Hyperoxaluria')
INSERT INTO #new_assess VALUES ('R82992','Disorder (of) glycine metabolism hyperoxaluria')
INSERT INTO #new_assess VALUES ('R82992','Disorder (of) metabolism amino-acid glycine hyperoxaluria')
INSERT INTO #new_assess VALUES ('R82993','Hyperuricoscuria')
INSERT INTO #new_assess VALUES ('R82994','Hypercalciuria')
INSERT INTO #new_assess VALUES ('R82994','Idiopathic hypercalciuria')
INSERT INTO #new_assess VALUES ('R82998','Cells and casts in urine')
INSERT INTO #new_assess VALUES ('R82998','Cells in urine')
INSERT INTO #new_assess VALUES ('R82998','Cylindruria ')
INSERT INTO #new_assess VALUES ('R82998','Abnormal casts, urine')
INSERT INTO #new_assess VALUES ('R82998','Abnormal cells, urine')
INSERT INTO #new_assess VALUES ('R82998','Abnormal crystals, urine')
INSERT INTO #new_assess VALUES ('R82998','Abnormal electrolyte level, urinary')
INSERT INTO #new_assess VALUES ('R82998','Abnormal melanin, urine')
INSERT INTO #new_assess VALUES ('R82998','Lithuria ')
INSERT INTO #new_assess VALUES ('R93811','Abnormal radiologic findings on diagnostic imaging of right testicle')
INSERT INTO #new_assess VALUES ('R93812','Abnormal radiologic findings on diagnostic imaging of left testicle')
INSERT INTO #new_assess VALUES ('R93813','Abnormal radiologic findings on diagnostic imaging of testicles, bilateral')
INSERT INTO #new_assess VALUES ('R93819','Abnormal radiologic findings on diagnostic imaging of unspecified testicle')
INSERT INTO #new_assess VALUES ('R9389','Abnormal findings on diagnostic imaging of other specified body structures')
INSERT INTO #new_assess VALUES ('R9389','Abnormal finding by radioisotope localization of placenta')
INSERT INTO #new_assess VALUES ('R9389','Abnormal radiological finding in skin and subcutaneous tissue')
INSERT INTO #new_assess VALUES ('R9389','Abnormal diagnostic imaging genitourinary organs')
INSERT INTO #new_assess VALUES ('R9389','Abnormal diagnostic imaging intrathoracic organ NEC')
INSERT INTO #new_assess VALUES ('R9389','Abnormal diagnostic imaging site specified NEC')
INSERT INTO #new_assess VALUES ('R9389','Abnormal diagnostic imaging skin and subcutaneous tissue')
INSERT INTO #new_assess VALUES ('R9389','Abnormal thermography')
INSERT INTO #new_assess VALUES ('R9389','Findings abnormal radiologic (X-ray) genitourinary organs')
INSERT INTO #new_assess VALUES ('R9389','Findings abnormal radiologic (X-ray) skin')
INSERT INTO #new_assess VALUES ('R9389','Findings abnormal radiologic (X-ray) subcutaneous tissue')
INSERT INTO #new_assess VALUES ('R9389','Thickening endometrium')
INSERT INTO #new_assess VALUES ('Z0481','Encounter for examination and observation of victim following forced sexual exploitation')
INSERT INTO #new_assess VALUES ('Z0481','Examination for medicolegal reason following forced sexual exploitation')
INSERT INTO #new_assess VALUES ('Z0482','Encounter for examination and observation of victim following forced labor exploitation')
INSERT INTO #new_assess VALUES ('Z0482','Examination for medicolegal reason NEC following forced labor exploitation')
INSERT INTO #new_assess VALUES ('Z0489','Encounter for examination and observation for other specified reasons')
INSERT INTO #new_assess VALUES ('Z0489','Examination for medicolegal reason NEC')
INSERT INTO #new_assess VALUES ('Z0489','Examination specified type or reason NEC')
INSERT INTO #new_assess VALUES ('Z0489','Observation following criminal assault')
INSERT INTO #new_assess VALUES ('Z0489','Testing for blood-alcohol')
INSERT INTO #new_assess VALUES ('Z0489','Testing for blood-drug')
INSERT INTO #new_assess VALUES ('Z0489','Testing laboratory for medicolegal reason NEC')
INSERT INTO #new_assess VALUES ('Z1340','Encounter for screening for unspecified developmental delays')
INSERT INTO #new_assess VALUES ('Z1340','Screening for disease or disorder developmental delays')
INSERT INTO #new_assess VALUES ('Z1341','Encounter for autism screening')
INSERT INTO #new_assess VALUES ('Z1342','Encounter for screening for global developmental delays (milestones)')
INSERT INTO #new_assess VALUES ('Z1349','Encounter for screening for other developmental delays')
INSERT INTO #new_assess VALUES ('N35812','Other urethral bulbous stricture, male')
INSERT INTO #new_assess VALUES ('N35813','Other membranous urethral stricture, male')
INSERT INTO #new_assess VALUES ('N35814','Other anterior urethral stricture, male, anterior')
INSERT INTO #new_assess VALUES ('N35816','Other urethral stricture, male, overlapping sites')
INSERT INTO #new_assess VALUES ('N35819','Other urethral stricture, male, unspecified site')
INSERT INTO #new_assess VALUES ('N3582','Other urethral stricture, female')

CREATE TABLE #new_assess2 (assessment_id varchar(24), icd10_code varchar(10), description varchar(400))

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
	description
FROM #new_assess
-- 107

INSERT INTO c_Assessment_Definition (
	assessment_id,
	source,
	assessment_type,
	icd10_code,
	assessment_category_id,
	description,
	long_description,
	risk_level,
	owner_id,
	status )
SELECT
	#new_assess2.assessment_id,
	'Dx', -- derived from Diagnosis Index for ICD10 code
	(SELECT assessment_type FROM c_Assessment_Category c 
		WHERE #new_assess2.icd10_code BETWEEN c.icd10_start AND c.icd10_end + 'z'
		AND c.is_default = 'Y'),
	#new_assess2.icd10_code,
	(SELECT assessment_category_id FROM c_Assessment_Category c 
		WHERE #new_assess2.icd10_code BETWEEN c.icd10_start AND c.icd10_end + 'z'
		AND c.is_default = 'Y'),
	CASE WHEN LEN(#new_assess2.description) > 80 THEN SUBSTRING(#new_assess2.description,1,77)+'...'
		ELSE #new_assess2.description END,
	CASE WHEN LEN(#new_assess2.description) > 80 THEN #new_assess2.description
		ELSE NULL END,
	2, -- default risk level
	981, -- default owner
	'OK' -- default status
FROM #new_assess2
-- re-entrancy
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a 
	WHERE a.assessment_id = #new_assess2.assessment_id )
-- 107
