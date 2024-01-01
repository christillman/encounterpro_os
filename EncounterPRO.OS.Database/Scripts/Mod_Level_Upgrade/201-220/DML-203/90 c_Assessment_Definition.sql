
-- Updates from VaccineZ23spreadsheets.xslx 

delete from c_Common_Assessment
where assessment_id in ('DEMO10304','2209^V03.89^0','DEMO718',
	'2209^V06.8^1','DEMO9408','DEMO9405','DEMO9397')

delete from u_assessment_treat_definition
where assessment_id in ('DEMO10304','2209^V03.89^0','DEMO718',
	'2209^V06.8^1','DEMO9408','DEMO9405','DEMO9397')

delete from u_top_20
where item_id in ('DEMO10304','2209^V03.89^0','DEMO718',
	'2209^V06.8^1','DEMO9408','DEMO9405','DEMO9397')
and top_20_code = 'ASSESSMENT_VACCINE'

delete from c_Assessment_Definition
where assessment_id in ('DEMO10304','2209^V03.89^0','DEMO718',
	'2209^V06.8^1','DEMO9408','DEMO9405','DEMO9397')

update c_Assessment_Definition set description = 'Encounter for immunization' where assessment_id = '0^V03.5'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for bacterial disease', long_description='Vaccination for bacterial disease' where assessment_id = 'DEMO9988'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for diphtheria, tetanus and acellular pertussis (dtap)', long_description='Vaccination for diphtheria, tetanus and acellular pertussis (dtap)' where assessment_id = 'DEMO10301'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for haemophilus influenzae type b', long_description='Vaccination for haemophilus influenzae type b' where assessment_id = 'DEMO9398'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for human papilloma virus (hpv)', long_description='Vaccination for human papilloma virus (hpv)' where assessment_id = '2209^V04.89^0'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for influenza', long_description='Vaccination for influenza' where assessment_id = 'DEMO716'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for measles', long_description='Vaccination for measles' where assessment_id = 'DEMO9400'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for measles, mumps and rubella (mmr)', long_description='Vaccination for measles, mumps and rubella (mmr)' where assessment_id = 'MMR'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for measles, mumps, rubella and varicella (mmrv)', long_description='Vaccination for measles, mumps, rubella and varicella (mmrv)' where assessment_id = '2209^V06.8^2'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for mumps', long_description='Vaccination for mumps' where assessment_id = 'DEMO9404'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for polio', long_description='Vaccination for polio' where assessment_id = 'DEMO471'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for rotavirus', long_description='Vaccination for rotavirus' where assessment_id = '2209^V04.89^1'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for rubella (german measles)', long_description='Vaccination for rubella (german measles)' where assessment_id = 'DEMO9401'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for single disease', long_description='Vaccination for single disease' where assessment_id = 'DEMO9991'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for streptococcus pneumoniae and influenza', long_description='Vaccination for streptococcus pneumoniae and influenza' where assessment_id = 'DEMO714'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for streptococcus pneumoniae with pneumovax', long_description='Vaccination for streptococcus pneumoniae with pneumovax' where assessment_id = 'DEMO10310'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for tetanus and diphtheria', long_description='Vaccination for tetanus and diphtheria' where assessment_id = 'DEMO9396'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for tetanus with tetanus toxoid', long_description='Vaccination for tetanus with tetanus toxoid' where assessment_id = 'DEMO715'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for tuberculosis (tb) with bacillus calmett-guerron', long_description='Vaccination for tuberculosis (tb) with bacillus calmett-guerron' where assessment_id = 'DEMO9393'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for typhoid and paratyphoid (bacteria)', long_description='Vaccination for typhoid and paratyphoid (bacteria)' where assessment_id = 'DEMO9392'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for varicella (chicken pox)', long_description='Vaccination for varicella (chicken pox)' where assessment_id = 'DEMO717'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for viral hepatitis A', long_description='Vaccination for viral hepatitis A' where assessment_id = '2209^V05.3^0'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for viral hepatitis B', long_description='Vaccination for viral hepatitis B' where assessment_id = 'DEMO713'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination for yellow fever', long_description='Vaccination for yellow fever' where assessment_id = 'DEMO9402'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccination with combination vaccine', long_description='Vaccination with combination vaccine' where assessment_id = 'DEMO9990'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccine, diphtheria, tetanus, acellular pertussis and polio (DTaP/IPV) (Kinrix)', long_description='Vaccine, diphtheria, tetanus, acellular pertussis and polio (DTaP/IPV) (Kinrix)' where assessment_id = '2209^V06.3^0'
update c_Assessment_Definition set [source] = 'ApproxSyn', description = 'Vaccine, rabies', long_description='Vaccine, rabies' where assessment_id = 'DEMO9403'
update c_Assessment_Definition set [source] = 'ApproxSyn', long_description = 'Vaccination for diphtheria, tetanus, acellular pertussis, haemophilus influenzae type b and polio' where assessment_id = '2209^V06.8^0'
update c_Assessment_Definition set [source] = 'ApproxSyn', long_description = 'Vaccination for streptococcus pneumoniae with prevnar 13' where assessment_id = '2209^V03.82^0'
update c_Assessment_Definition set [source] = 'ApproxSyn', long_description = 'Vaccination for tetanus, diphtheria, acellular pertussis, hepatitis b and polio' where assessment_id = 'DEMO11374'
update c_Assessment_Definition set [source] = 'ApproxSyn', long_description = 'Vaccination for viral hepatitis a and hepatitis b' where assessment_id = '0^12304'

--   Add new VACCINE assessments drop table #new_assess33
CREATE TABLE #new_assess3 (
	icd10_code varchar(10), 
	assessment_type varchar(24),
	assessment_category_id varchar(24),
	description varchar(80),
	long_description text,
	[source] varchar(10))

INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for meningococcus', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for meningococcus b', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for respiratory syncytial virus (rsv', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for typhoid (bacteria)', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for viral hepatitis', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Varicella vaccination done', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Viral hepatitis a and b vaccination given', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Viral hepatitis a vaccination given', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Viral hepatitis b vaccination given', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Viral hepatitis vaccination given', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Yellow fever vaccination given', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination needed', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for human papilloma virus (hpv) type 16 and 18', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for human papilloma virus with hpv4', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for human papilloma virus with hpv9', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for herpes zoster', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for disease combination', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for diphtheria, tetanus, pertussis, and polio', null, 'ApproxSyn')
INSERT INTO #new_assess3 VALUES ('Z23', 'VACCINE', 'VACCINES', 'Vaccination for streptococcus pneumoniae with prevnar 7 for pediatric age group', null, 'ApproxSyn')

CREATE TABLE #new_assess4 (
	assessment_id varchar(24), 
	icd10_code varchar(10), 
	assessment_type varchar(24),
	assessment_category_id varchar(24),
	description varchar(80),
	long_description text,
	[source] varchar(10))

INSERT INTO #new_assess4
SELECT
	'ASyn-' + #new_assess3.icd10_code + '-' 
		+ convert(varchar(3), 
			row_number() over (
				partition by #new_assess3.icd10_code 
				order by #new_assess3.description
				)
			),  
	icd10_code,
	assessment_type,
	assessment_category_id,
	description,
	long_description,
	[source]
FROM #new_assess3

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
	#new_assess4.assessment_id,
	assessment_type,
	#new_assess4.icd10_code,
	assessment_category_id,
	#new_assess4.description,
	#new_assess4.long_description,
	[source],
	2, -- default risk level
	981, -- default owner
	'OK' -- default status
FROM #new_assess4
-- re-entrancy
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition a 
	WHERE a.assessment_id = #new_assess4.assessment_id )


UPDATE c_Assessment_Definition SET long_description = NULL
WHERE long_description = description