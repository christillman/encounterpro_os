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

-- Drop Procedure [dbo].[sp_get_assessment_icd10]
Print 'Drop Procedure [dbo].[sp_get_assessment_icd10]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessment_icd10]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessment_icd10]
GO

-- Create Procedure [dbo].[sp_get_assessment_icd10]
Print 'Create Procedure [dbo].[sp_get_assessment_icd10]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_assessment_icd10 (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24)
	--, @ps_insurance_id varchar(24) OUTPUT,
	--@ps_icd10_code varchar(12) OUTPUT
	)
AS
DECLARE @li_authority_sequence smallint
	, @ls_insurance_id varchar(24)
	, @ls_icd10_code varchar(12)
	, @ls_asst_description varchar(80)
	
SELECT @ls_insurance_id = NULL,
	@ls_icd10_code = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
IF @li_authority_sequence IS NOT NULL
	SELECT @ls_insurance_id = i.authority_id,
		@ls_icd10_code = i.icd10_code
	FROM c_Assessment_Coding i, p_Patient_Authority pi WITH (NOLOCK)
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence
	AND i.assessment_id = @ps_assessment_id
	AND pi.authority_id = i.authority_id
IF @ls_insurance_id IS NULL
	SELECT @ls_icd10_code = icd10_code,@ls_asst_description=description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_assessment_id

SELECT @ls_insurance_id AS insurance_id, @ls_icd10_code AS icd10_code,@ls_asst_description as asst_description

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessment_icd10]
	TO [cprsystem]
GO

