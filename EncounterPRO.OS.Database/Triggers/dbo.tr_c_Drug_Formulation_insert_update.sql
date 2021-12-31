

IF OBJECT_ID ('tr_c_Drug_Formulation_insert_update', 'TR') IS NOT NULL
     DROP TRIGGER tr_c_Drug_Formulation_insert_update
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER tr_c_Drug_Formulation_insert_update
ON c_Drug_Formulation
FOR INSERT, UPDATE 
AS 
	BEGIN 
	IF EXISTS (SELECT 1 FROM c_Drug_Formulation f
				JOIN inserted i ON i.form_descr = f.form_descr
				WHERE i.form_rxcui != f.form_rxcui)
		BEGIN
		RAISERROR ('Not a unique value for form_descr', 16, 10)
		-- Force Violation of PRIMARY KEY to prevent insertion
		INSERT INTO c_Drug_Formulation (form_rxcui)
		SELECT f.form_rxcui FROM c_Drug_Formulation f
		JOIN inserted i ON i.form_descr = f.form_descr
		END
	END
  
GO


