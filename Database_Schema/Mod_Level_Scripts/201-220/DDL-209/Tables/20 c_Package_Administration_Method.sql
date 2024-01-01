
-- 08_14_2020_Injectables Present and Not Present in KE_Formulary
-- Multiple routes

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Package_Administration_Method]') AND [type]='U'))
	DROP TABLE [dbo].[c_Package_Administration_Method]
GO

CREATE TABLE c_Package_Administration_Method (
	package_id varchar(24) NOT NULL,
	administer_method varchar(30) NULL
	)

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[c_Package_Administration_Method] TO CPRSYSTEM

