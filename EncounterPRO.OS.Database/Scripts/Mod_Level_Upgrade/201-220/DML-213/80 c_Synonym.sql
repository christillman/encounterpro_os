
DELETE FROM c_Synonym
WHERE term IN ('Epinephrine','dextrose')

INSERT INTO [c_Synonym] VALUES
('Epinephrine','drug_ingredient','Adrenaline'),
('dextrose','drug_ingredient','glucose')

update [c_Synonym]
SET term = 'flumethasone', alternate = 'flumetasone'
where term = 'flumethasone pivalate'
