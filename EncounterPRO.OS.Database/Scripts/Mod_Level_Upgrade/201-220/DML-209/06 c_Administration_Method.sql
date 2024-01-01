

DELETE FROM [c_Administration_Method]
WHERE [administer_method] IN (
'INTRAVITREAL',
'IV INFUSION',
'IV INFUSION ONLY',
'Subcut ONLY'
)

INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('INTRAVITREAL','Intravitreal')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IV INFUSION','Intravenous Infusion')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('IV INFUSION ONLY','Intravenous Infusion ONLY')
INSERT INTO [dbo].[c_Administration_Method] ([administer_method],[description]) VALUES ('Subcut ONLY','Subcutaneous ONLY')
