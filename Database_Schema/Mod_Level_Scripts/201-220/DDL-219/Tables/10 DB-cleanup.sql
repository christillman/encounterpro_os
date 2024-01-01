
-- Empty, unreferenced
DROP TABLE IF EXISTS c_Nomenclature_Medcin
DROP TABLE IF EXISTS x_ID_Lists
DROP TABLE IF EXISTS [icd10cm_codes_2018]
DROP TABLE IF EXISTS [icd10cm_codes_2019]
 -- delete scripts from Tables
DROP TABLE IF EXISTS c_Drug_Brand_Related
DROP TABLE IF EXISTS c_Drug_Generic_Related
DROP TABLE IF EXISTS c_Drug_Generic_Ingredient
DROP TABLE IF EXISTS c_Drug_Addition
DROP VIEW IF EXISTS [dbo].[TECHSERV_EPRO_40_Master_dbo_u_assessment_treat_definition]
DROP VIEW IF EXISTS [dbo].[TECHSERV_EPRO_40_Master_dbo_u_assessment_treat_definition1]
DROP VIEW IF EXISTS vw_Drug_Brand_Ingredient


-- missing perms
GRANT SELECT ON vw_dose_unit TO cprsystem
GRANT SELECT, INSERT, UPDATE ON [dbo].[p_Observation_Comment] TO [cprsystem]

GRANT EXECUTE
	ON [dbo].[sp_get_open_assessments_treatments]
	TO [cprsystem]
GO
