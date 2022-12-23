
USE interfaces
GO

UPDATE icd10cm_codes_2018
	SET descr = REPLACE(descr,'"','')

UPDATE icd10pcs_codes_2019
	SET descr = REPLACE(descr,'"','')
