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

-- Drop Procedure [dbo].[jmj_medication_allergies]
Print 'Drop Procedure [dbo].[jmj_medication_allergies]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_medication_allergies]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_medication_allergies]
GO

-- Create Procedure [dbo].[jmj_medication_allergies]
Print 'Create Procedure [dbo].[jmj_medication_allergies]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_medication_allergies (
	@ps_cpr_id varchar(12),
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(24))
AS

DECLARE @treatmentlist TABLE (
		definition_id int NULL,
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NOT NULL,
		contraindication_type varchar(24) NULL,
		icon varchar(128) NULL,
		severity int NULL,
		short_description varchar(255) NULL,
		long_description varchar(max) NULL,
		contraindication_warning varchar(max) NULL,
		contraindication_references varchar(max) NULL,
		drug_id varchar(24) NULL,
		allergy_assessment_id varchar(24) NULL,
		allergy_description varchar(80) NULL,
		drug_common_name varchar(40))


DECLARE @ls_common_name varchar(40)

SELECT @ls_common_name = common_name
FROM c_Drug_Definition
WHERE drug_id = @ps_treatment_key

INSERT INTO @treatmentlist (
		treatment_type,
		treatment_key,
		treatment_description,
		contraindication_type ,
		icon ,
		severity ,
		short_description ,
		drug_id,
		allergy_assessment_id,
		allergy_description,
		drug_common_name)
SELECT	@ps_treatment_type,
		@ps_treatment_key,
		@ls_common_name,
		'Drug Allergy',
		'bitmap_drug_allergy.bmp',
		3,
		'This patient has an allergy (' + p.assessment + ') which may cause an adverse reaction to ' + @ls_common_name,
		@ps_treatment_key,
		p.assessment_id,
		p.assessment,
		@ls_common_name
FROM p_Assessment p
	INNER JOIN c_Allergy_Drug ad
	ON p.assessment_id = ad.assessment_id
	AND ad.drug_id = @ps_treatment_key
	INNER JOIN c_Assessment_Definition a
	ON a.assessment_id = p.assessment_id
WHERE p.cpr_id = @ps_cpr_id
AND ISNULL(p.assessment_status, 'OPEN') = 'OPEN'
AND @ps_treatment_type IN ('MEDICATION', 'OFFICEMED')



SELECT	definition_id,
		treatment_type ,
		treatment_key ,
		treatment_description ,
		contraindication_type ,
		icon ,
		severity ,
		short_description ,
		long_description ,
		contraindication_warning ,
		contraindication_references ,
		drug_id ,
		allergy_assessment_id ,
		allergy_description,
		drug_common_name
FROM @treatmentlist



GO
GRANT EXECUTE
	ON [dbo].[jmj_medication_allergies]
	TO [cprsystem]
GO

