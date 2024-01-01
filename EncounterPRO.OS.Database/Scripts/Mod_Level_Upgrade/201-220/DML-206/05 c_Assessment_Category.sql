
-- Update category names

  UPDATE [c_Assessment_Category] 
  SET description = 'Pregnancy/Childbirth/Puerperium'
  WHERE assessment_category_id = 'OB'
  UPDATE [c_Assessment_Category] 
  SET description = 'Neonatal/Newborn'
  WHERE assessment_category_id = 'OBP'

IF NOT EXISTS (SELECT 1 FROM c_Assessment_Category WHERE assessment_category_id = 'ACCTRANS')
BEGIN
-- Add more specific categories for V codes, email 1/6/2019
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ACCTRANS'
           ,'Transport Accidents'
           ,40
           ,'V01'
           ,'V99'
           ,'Y')


INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ACCNONTRANS'
           ,'Non Transport Accidents'
           ,41
           ,'W01'
           ,'X59'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'SELFHARM'
           ,'Intentional self-harm'
           ,42
           ,'X60'
           ,'X84'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ASSAULT'
           ,'Assault'
           ,43
           ,'X85'
           ,'Y09'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'UNDINTENT'
           ,'Undetermined intent'
           ,44
           ,'Y10'
           ,'Y34'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'LEGALWAR'
           ,'Legal intervention, war, terror'
           ,45
           ,'Y35'
           ,'Y36'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ADVEFF'
           ,'Adverse EFFECTS caused by drugs, medicaments and biological substances'
           ,46
           ,'Y40'
           ,'Y59'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'MISADV'
           ,'Misadventures to patients during surgical and medical care'
           ,47
           ,'Y60'
           ,'Y69'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ADVDEV'
           ,'Adverse INCIDENTS associated with medical devices'
           ,48
           ,'Y70'
           ,'Y82'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'MEDSURGCOMP'
           ,'Complications to surgical and medical procedures, no misadventure'
           ,49
           ,'Y83'
           ,'Y84'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'SEQUE'
           ,'Sequelae of external causes of morbidity and mortality'
           ,50
           ,'Y85'
           ,'Y89'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ALCOLVL'
           ,'Blood alcohol level'
           ,51
           ,'Y90'
           ,'Y91'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'PLACE'
           ,'Place of external cause'
           ,52
           ,'Y92'
           ,'Y92'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ACTIVITY'
           ,'Activity codes'
           ,53
           ,'Y93'
           ,'Y93'
           ,'Y')

INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'NOSOCOM'
           ,'Nosocomial condition'
           ,54
           ,'Y95'
           ,'Y95'
           ,'Y')

-- Note, this has no ICD10-CM entries (WHO only)
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'WORK'
           ,'Work related condition'
           ,56
           ,'Y96'
           ,'Y96'
           ,'Y')

-- Note, this has no ICD10-CM entries (WHO only)
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'ENV'
           ,'Environmental pollution related condition'
           ,56
           ,'Y97'
           ,'Y97'
           ,'Y')

-- Note, this has no ICD10-CM entries (WHO only)
INSERT INTO [c_Assessment_Category]
           ([assessment_type]
           ,[assessment_category_id]
           ,[description]
           ,[sort_order]
           ,[icd10_start]
           ,[icd10_end]
           ,[is_default])
     VALUES
           ('SICK'
           ,'LIFESTY'
           ,'Lifestyle related condition'
           ,56
           ,'Y98'
           ,'Y98'
           ,'Y')
END

DELETE FROM c_Assessment_Category WHERE assessment_category_id = 'Z'

UPDATE d
SET d.assessment_category_id = c.assessment_category_id,
	d.assessment_type = c.assessment_type,
	last_updated = getdate()
FROM c_Assessment_Definition d 
JOIN c_Assessment_Category c on d.icd10_code BETWEEN c.icd10_start AND c.icd10_end + 'z'
WHERE d.assessment_category_id = 'Z'

-- (6447 row(s) affected)