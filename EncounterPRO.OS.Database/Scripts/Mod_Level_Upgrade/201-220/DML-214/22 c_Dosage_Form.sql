
UPDATE [c_Dosage_Form] 
set [default_administer_method] = '-'
-- select [dosage_form], [default_administer_method] from c_Dosage_Form
WHERE [dosage_form] not like '%Inhal%'
  and ([dosage_form] like '%EYE%' 
	or [dosage_form] like '%Ophth%' 
	or [dosage_form] like '%EAR%' 
	or [dosage_form] like '%Nasal %' 
	or [dosage_form] like '%Otic%')

-- Invalid one
DELETE FROM [c_Dosage_Form]
WHERE dosage_form = 'Opth Ointment'

UPDATE [c_Dosage_Form] set 
		[default_dose_unit] = 'APPLYEYE',
		[default_administer_unit] = 'APPLYEYE'
WHERE dosage_form LIKE 'Ophth%'

DELETE FROM c_Dosage_Form
WHERE dosage_form = 'Otic Lotion'

INSERT INTO c_Dosage_Form (
	[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      )
VALUES ( 'Otic Lotion','Otic Lotion','Otic Lotion','-',1,'APPLYEAR','N','APPLYEAR')


DELETE FROM c_Dosage_Form
WHERE dosage_form = 'CUTANEOUSSTICK'

INSERT INTO c_Dosage_Form (
	[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      )
VALUES ( 'CUTANEOUSSTICK','Cutaneous Stick','Cutaneous Stick','ASDIR',1,'APPLY','N','APPLY')

DELETE FROM c_Dosage_Form
WHERE dosage_form = 'OralVaccine'
INSERT INTO [dbo].[c_Dosage_Form]
           ([dosage_form]
           ,[description]
           ,[abbreviation]
           ,[dose_in_name_flag])
     VALUES
           ('OralVaccine'
           ,'Oral Vaccine'
           ,'Oral Vaccine'
           ,'N')


DELETE FROM c_Dosage_Form
WHERE dosage_form = 'Enteral'
INSERT INTO [dbo].[c_Dosage_Form]
           ([dosage_form]
           ,[description]
           ,[abbreviation]
           ,[dose_in_name_flag])
     VALUES
           ('Enteral'
           ,'Enteral Suspension'
           ,'Enteral'
           ,'N')

DELETE FROM c_Dosage_Form
WHERE dosage_form = 'RectalSusp'
INSERT INTO [dbo].[c_Dosage_Form]
           ([dosage_form]
           ,[description]
           ,[abbreviation]
           ,[dose_in_name_flag])
     VALUES
           ('RectalSusp'
           ,'Rectal Suspension'
           ,'Rectal Susp'
           ,'N')

DELETE FROM [c_Dosage_Form]
WHERE dosage_form = 'TopicalStick'		   
INSERT INTO [dbo].[c_Dosage_Form]
           ([dosage_form]
           ,[description]
           ,[abbreviation]
           ,[dose_in_name_flag])
     VALUES
           ('TopicalStick'
           ,'Topical Stick'
           ,'Topical Stick'
           ,'N')

-- Unused, ambiguous
DELETE FROM [c_Dosage_Form]
WHERE dosage_form = 'Topical'
DELETE FROM [c_Dosage_Form]
WHERE dosage_form = 'Liquid'

-- Duplicate
UPDATE c_Package SET dosage_form = 'Chew Tab'
WHERE dosage_form = 'Chewable Tablet'

DELETE FROM [c_Dosage_Form]
WHERE dosage_form = 'Chew Tab'
AND description = 'Chew Tabs'

UPDATE [c_Dosage_Form] set 
	dosage_form = 'Chew Tab'
WHERE dosage_form = 'Chewable Tablet'

UPDATE c_Dosage_Form
SET description = 'Patch' -- not Patches
WHERE dosage_form = 'Patch'

DELETE FROM [c_Administration_Method]
WHERE [administer_method] = 'CHEWASDIR'

INSERT INTO [dbo].[c_Administration_Method]
           ([administer_method]
           ,[description])
     VALUES
           ('CHEWASDIR','Chew in the mouth as directed')

DELETE FROM c_Unit
WHERE unit_id = 'PIECE'

INSERT INTO c_Unit (
	[unit_id]
      ,[description]
      ,[unit_type]
      ,[pretty_fraction]
      ,[plural_flag]
      ,[print_unit]
      ,[abbreviation]
      ,[display_mask]
      ,[prefix]
	  )
SELECT 'PIECE'
      ,'PIECE'
      ,[unit_type]
      ,[pretty_fraction]
      ,[plural_flag]
      ,[print_unit]
      ,'PC'
      ,[display_mask]
      ,[prefix]
  FROM [dbo].[c_Unit]
  WHERE unit_id = 'GUM'
  
UPDATE [c_Dosage_Form] set description = 'Drug Implant'
WHERE dosage_form = 'Implant'

UPDATE [c_Dosage_Form] set default_dose_unit = 'PIECE'
WHERE dosage_form = 'Chewing Gum'

UPDATE [c_Dosage_Form] set default_dose_unit = 'DROP'
WHERE dosage_form = 'Drops Or'

UPDATE [c_Dosage_Form] set default_dose_unit = 'ENEMA'
WHERE dosage_form = 'Enema'

UPDATE [c_Dosage_Form] set default_dose_unit = 'STRIP'
WHERE dosage_form like '%film%'

UPDATE [c_Dosage_Form] set default_dose_unit = 'PACKE'
WHERE dosage_form IN ('Oral Granules', 'GranuleOralSusp', 'DROralGran')

UPDATE [c_Dosage_Form] set default_dose_unit = 'ML'
WHERE dosage_form IN ('Oral Solution', 'Oral Suspension',
	'ER Suspension', 'Injectable Foam', 'Irrigation Soln',
	'Ophthalmic Irri')

UPDATE [c_Dosage_Form] set default_dose_unit = 'SPRAYNOSTRIL'
WHERE dosage_form IN ('Nasal Spray', 'MeterNasalSpray')

UPDATE [c_Dosage_Form] set default_dose_unit = 'DROPNOSTRIL'
WHERE dosage_form IN ('Nasal Solution')

UPDATE [c_Dosage_Form] set default_dose_unit = 'DROPEYE'
WHERE dosage_form IN ('Ophthalmic Soln', 'Ophthalmic Susp')

UPDATE [c_Dosage_Form] set default_dose_unit = 'STRIP'
WHERE dosage_form IN ('Oral Strip')

UPDATE [c_Dosage_Form] set default_dose_unit = 'WAFER'
WHERE dosage_form IN ('Oral Wafer')

UPDATE [c_Dosage_Form] set default_dose_unit = 'DROPEAR'
WHERE dosage_form IN ('Otic Solution', 'Otic Suspension')

UPDATE [c_Dosage_Form] set default_dose_unit = 'MG'
WHERE dosage_form IN ('Pen Injector')

UPDATE [c_Dosage_Form] set default_dose_unit = 'APPLY'
WHERE dosage_form IN ('Rectal Ointment')

UPDATE [c_Dosage_Form] set default_dose_unit = 'SPRAY'
WHERE dosage_form IN ('Topical Spray')

/*
select distinct 
	u.dosage_form, 
	dbo.fn_std_dosage_form (form_descr, generic_form_descr) as [Revised dosage_form], 
	u.form_rxcui, u.form_descr, u.generic_form_descr
  from vw_dose_unit u
where u.dosage_form != dbo.fn_std_dosage_form (form_descr, generic_form_descr)
order by 1, 2, 3

UPDATE u
SET dosage_form = dbo.fn_std_dosage_form (form_descr, generic_form_descr)
FROM vw_dose_unit u
WHERE u.dosage_form IS NULL
OR dbo.fn_std_dosage_form (form_descr, generic_form_descr) != u.dosage_form
*/


  update [c_Dosage_Form]
  set [default_dose_unit] = 
	replace([default_dose_unit],'M','m')
	where [default_dose_unit] in ('ML','MG')

  update [c_Dosage_Form]
  set [default_administer_unit] = 
	replace(replace([default_administer_unit],'M','m'),'C','c')
	where [default_administer_unit] in ('MCG','MG','ML')

