
UPDATE d
SET drug_type = 'Single Drug'
FROM c_Drug_Definition d
WHERE (common_name like '%antigen%'
or common_name like '%globulin%'
or generic_name like '%antigen%'
or generic_name like '%globulin%'
)
and generic_name not like '%Vaccine%' 
and generic_name not like '%virus%' 
and common_name not like '%Vaccine%' 
and common_name not in ('Shan-5')
AND drug_type = 'Vaccine' 
and drug_id not in (select vaccine_id from c_Vaccine)
and drug_id not in (select drug_id from c_Vaccine)
-- (53 row(s) affected)

-- Also these which contain 'virus', according to Sheet1 of 
-- 04_06_2021_Vaccine_Formulations_Procedures.xslx
UPDATE d
SET drug_type = 'Single Drug'
FROM c_Drug_Definition d
WHERE drug_type = 'Vaccine' 
AND drug_id IN (
'RXNB216315',
'RXNG1316105',
'RXNG1986821',
'RXNG22178')
-- (4 row(s) affected)

UPDATE d
SET drug_type = 'Vaccine'
FROM c_Drug_Definition d
WHERE drug_type = 'Single Drug' 
AND drug_id IN (
'RXNB94297'
)

UPDATE c_Drug_Formulation
SET form_descr = replace(form_descr,'Hib generic','Hib) (generic') 
WHERE form_descr like '%Hib generic%'
-- (2 row(s) affected)

DELETE -- select *
FROM c_Drug_Definition WHERE drug_id IN ('Quadracel','DTAPHIB','Comvax')

-- Insert records from c_Vaccine currently missing in c_Drug_Definition
-- Ignore the procedure_id column in c_drug_definition, instead the
-- vaccine_id column in c_Procedure ties back to c_drug_definition
INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name, status)
VALUES 
('DTAPHIB', 'Vaccine', 'DTaP and Hib', 'DTaP and Hib', 'OK'),
('Comvax', 'Vaccine', 'Comvax', 'Comvax', 'OK'),
('Quadracel', 'Vaccine', 'Quadracel', 'Quadracel', 'OK')
