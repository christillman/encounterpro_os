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

-- Drop Procedure [dbo].[jmj_lookup_proposed_medication_code]
Print 'Drop Procedure [dbo].[jmj_lookup_proposed_medication_code]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_lookup_proposed_medication_code]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_lookup_proposed_medication_code]
GO

-- Create Procedure [dbo].[jmj_lookup_proposed_medication_code]
Print 'Create Procedure [dbo].[jmj_lookup_proposed_medication_code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_lookup_proposed_medication_code (
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(24),
	@pl_code_owner_id int,
	@ps_dosage_form varchar(24) = NULL,
	@ps_package_id varchar(24) = NULL)
AS

IF @ps_treatment_type IS NULL
	BEGIN
	RAISERROR ('Nul treatment_type',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ps_treatment_key IS NULL
	BEGIN
	RAISERROR ('Nul treatment_key',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END


DECLARE @treatmentlist TABLE (
		definition_id int NULL,
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NULL,
		drug_id varchar(24) NULL,
		package_id varchar(24) NULL,
		dosage_form varchar(24) NULL,
		drug_code varchar(80) NULL,
		drug_package_code varchar(80) NULL,
		drug_dosage_form_code varchar(80) NULL,
		drug_common_name varchar(40))

IF @ps_package_id IS NOT NULL
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND dp.package_id = @ps_package_id
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'
ELSE IF @ps_dosage_form IS NOT NULL
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND p.dosage_form = @ps_dosage_form
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'
ELSE
	INSERT INTO @treatmentlist (
			treatment_type,
			treatment_key,
			drug_id,
			package_id,
			dosage_form)
	SELECT @ps_treatment_type,
			@ps_treatment_key,
			dp.drug_id,
			dp.package_id,
			p.dosage_form
	FROM c_Drug_Package dp
		INNER JOIN c_Package p
		ON dp.package_id = p.package_id
	WHERE dp.drug_id = @ps_treatment_key
	AND dbo.fn_treatment_type_treatment_key(@ps_treatment_type) = 'drug_id'

UPDATE t
SET drug_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id
	AND x.epro_domain = 'drug_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_name_id'
WHERE t.drug_id IS NOT NULL

UPDATE t
SET drug_package_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id + '|' + t.package_id
	AND x.epro_domain = 'drug_id|package_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_id'


UPDATE t
SET drug_dosage_form_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.dosage_form
	AND x.epro_domain = 'dosage_form'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_dosage_form_abbr'

UPDATE t
SET drug_common_name = d.common_name
FROM @treatmentlist t
	INNER JOIN c_Drug_Definition d
	ON t.drug_id = d.drug_id

SELECT	definition_id,
		treatment_type ,
		treatment_key ,
		treatment_description ,
		drug_id ,
		package_id ,
		dosage_form ,
		drug_code ,
		drug_package_code ,
		drug_dosage_form_code,
		drug_common_name
FROM @treatmentlist



GO
GRANT EXECUTE
	ON [dbo].[jmj_lookup_proposed_medication_code]
	TO [cprsystem]
GO

