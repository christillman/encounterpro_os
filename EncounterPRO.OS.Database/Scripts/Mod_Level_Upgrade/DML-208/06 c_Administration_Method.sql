-- Modify administration methods
UPDATE [dbo].[c_Administration_Method] 
SET [administer_method] = 'RightEye' 
WHERE [administer_method] = 'OD'
UPDATE [dbo].[c_Administration_Method] 
SET [administer_method] = 'LeftEye' 
WHERE [administer_method] = 'OS'
UPDATE [dbo].[c_Administration_Method] 
SET [administer_method] = 'EachEye' 
WHERE [administer_method] = 'OU'
UPDATE [dbo].[c_Administration_Method] 
SET [description] = 'Spray on Affected Area As Directed' 
WHERE [administer_method] = 'SPRAY'
UPDATE [dbo].[c_Administration_Method] 
SET [administer_method] = 'Subcut' 
WHERE [administer_method] = 'SQ'
UPDATE [dbo].[c_Administration_Method] 
SET [description] = 'Apply/Insert/Fit in Office ' 
WHERE [administer_method] = 'IN OFFICE'

DELETE FROM [c_Administration_Method]
WHERE [administer_method] IN (
'VAPORIZER',
'MOUTHWASH',
'INTRANASAL',
'NASAL IRRIGATION',
'IART',
'UPPER EYELID',
'INTRANASAL',
'SPRAYORAL',
'SWISHSWAL',
'SWISHSPIT',
'GARGLE',
'AFFECTED NOSTRIL',
'BUCCAL',
'IMPLANT SUBDERMAL',
'ENTERAL',
'INTRAUTERINE',
'IMPLANT-SINUS',
'IMPLANT-SUBCUT',
'CHEW',
'TO TEETH',
'TO THIGHS',
'TO UPPER ARMS AND SHOULDERS',
'TO ARMPITS',
'INTRA-ARTICULAR'
)
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('VAPORIZER','Use in Vaporizer')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('INTRANASAL','Intranasal')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('NASAL IRRIGATION','Nasal Irrigation')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IART','Intra-Articular')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('UPPER EYELID','Upper Eyelid Margin')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('SPRAYORAL','Spray in Mouth As Directed')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('SWISHSWAL','Swish in Mouth and Swallow')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('SWISHSPIT','Swish in Mouth and Spit')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('GARGLE','Gargle')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('AFFECTED NOSTRIL','Affected Nostril')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('BUCCAL','Buccal')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IMPLANT SUBDERMAL','Subdermal Implant')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('ENTERAL','Enteral')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('INTRAUTERINE','Intrauterine')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IMPLANT-SINUS','Sinus Implant')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IMPLANT-SUBCUT','Subcutaneous Implant')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('CHEW','Chew in the Mouth and Swallow')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('TO TEETH','Apply to Teeth')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('TO THIGHS','Apply to Front and Inner Thighs')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('TO UPPER ARMS AND SHOULDERS','Apply to Upper Arms and Shoulders')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('TO ARMPITS','Apply to Armpits')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('INTRA-ARTICULAR','Intra-Articular')

-- Found in admin method spreadsheet, but not in units tab
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('DROPNOSTRIL','Drop(s) in nostril')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('SPRAYNOSTRIL','Spray in nostril')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IM ONLY','Intramuscular ONLY')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IV ONLY','Intravenous ONLY')
