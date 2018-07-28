--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
FROM deleted,c_Package
WHERE deleted.package_id = c_Package.package_id
-- Check if any other package for this drug has same dosage form of deleted package
SELECT @ll_count = count(*)
FROM c_Drug_Package,c_Package
WHERE c_Drug_Package.package_id = c_Package.package_id
AND c_Drug_Package.drug_id = @ls_drug_id
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

