
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_Drug_Package]
Print 'Drop Trigger [dbo].[tr_c_Drug_Package]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Drug_Package]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_Drug_Package]
GO

-- Create Trigger [dbo].[tr_c_Drug_Package]
Print 'Create Trigger [dbo].[tr_c_Drug_Package]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_Drug_Package  ON c_Drug_Package
FOR  DELETE 
AS

DECLARE @ls_dosage_form varchar(24),
	@ls_drug_id varchar(24),
	@ll_count int

-- Get the dosage form of deleted package
SELECT @ls_dosage_form = dosage_form,@ls_drug_id=drug_id
FROM deleted
JOIN c_Package ON deleted.package_id = c_Package.package_id

-- Check if any other package for this drug has same dosage form of deleted package
SELECT @ll_count = count(*)
FROM c_Drug_Package
JOIN c_Package ON c_Drug_Package.package_id = c_Package.package_id
WHERE c_Drug_Package.drug_id = @ls_drug_id
AND c_Package.dosage_form = @ls_dosage_form
-- If this is last package of the same dosage form then delete all the references from treatment list
IF  @ll_count = 0
	BEGIN	
	DELETE FROM u_assessment_treat_definition
	WHERE EXISTS (
		SELECT A.definition_id
		FROM u_Assessment_treat_def_attrib A
		WHERE EXISTS (
			SELECT definition_id
			FROM u_Assessment_treat_def_attrib B
			WHERE B.attribute = 'drug_id'
			AND B.value = @ls_drug_id
			AND B.definition_id = A.definition_id
		)
	AND attribute = 'dosage_form'
	AND value = @ls_dosage_form
	AND A.definition_id = u_assessment_treat_definition.definition_id
	)
	END
GO

