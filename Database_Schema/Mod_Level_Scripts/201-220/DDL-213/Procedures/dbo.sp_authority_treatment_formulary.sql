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

-- Drop Procedure [dbo].[sp_authority_treatment_formulary]
Print 'Drop Procedure [dbo].[sp_authority_treatment_formulary]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_authority_treatment_formulary]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_authority_treatment_formulary]
GO

-- Create Procedure [dbo].[sp_authority_treatment_formulary]
Print 'Create Procedure [dbo].[sp_authority_treatment_formulary]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_authority_treatment_formulary (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int ,
	@ps_authority_id varchar(24) )
AS

DECLARE @ls_treatment_key varchar(40),
		@ls_treatment_type varchar(24)

SELECT @ls_treatment_type = treatment_type,
	@ls_treatment_key = dbo.fn_treatment_key(cpr_id, treatment_id)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

DECLARE @assessments TABLE (
	icd10_code varchar(12) )

INSERT INTO @assessments (
	icd10_code )
SELECT DISTINCT ad.icd10_code
FROM p_Assessment a
	INNER JOIN p_Assessment_Treatment t
	ON a.cpr_id = t.cpr_id
	AND a.problem_id = t.problem_id
	INNER JOIN c_Assessment_Definition ad
	ON a.assessment_id = ad.assessment_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id

SELECT DISTINCT 
	pa.authority_type,
	pa.authority_id,
	pa.authority_sequence,
	af.authority_formulary_id,
	af.authority_formulary_sequence,
	af.icd10_code,
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM p_Patient_Authority pa
	INNER JOIN c_Authority_Formulary af
	ON af.authority_id = pa.authority_id
	INNER JOIN c_Formulary f
	ON af.formulary_code = f.formulary_code
WHERE pa.cpr_id = @ps_cpr_id
AND af.treatment_type = @ls_treatment_type
AND af.treatment_key = @ls_treatment_key
AND (af.icd10_code IS NULL
	OR EXISTS(
			SELECT aa.icd10_code
			FROM @assessments aa
			WHERE aa.icd10_code LIKE (af.icd10_code + '%') ) )

GO
GRANT EXECUTE
	ON [dbo].[sp_authority_treatment_formulary]
	TO [cprsystem]
GO

