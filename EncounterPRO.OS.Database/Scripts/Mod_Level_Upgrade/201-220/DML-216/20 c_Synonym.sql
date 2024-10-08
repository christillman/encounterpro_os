

DELETE FROM c_Synonym
WHERE term IN ('Carbocysteine')

INSERT INTO [c_Synonym] (term, term_type, alternate) VALUES
('Carbocysteine','drug_ingredient','Carbocisteine')


UPDATE c_Drug_Formulation
SET form_descr = replace( form_descr, 'vitamin B 12 ', 'vitamin B12 ')
-- select * from c_Drug_Formulation
where form_descr like '%vitamin B 12 %'

UPDATE c_Drug_Formulation
SET form_descr = replace(form_descr,'\','/') 
where form_descr like '%\%'
