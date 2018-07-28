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

-- Drop Function [dbo].[fn_vfc_eligibility_code]
Print 'Drop Function [dbo].[fn_vfc_eligibility_code]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_vfc_eligibility_code]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_vfc_eligibility_code]
GO

-- Create Function [dbo].[fn_vfc_eligibility_code]
Print 'Create Function [dbo].[fn_vfc_eligibility_code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_vfc_eligibility_code (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_vfc_eligibility_code varchar(80)

SELECT TOP 1 @ls_vfc_eligibility_code = r.result
FROM p_Observation_Result r
	INNER JOIN fn_equivalent_observations('0^VFCEligCode') eq
	ON r.observation_id = eq.observation_id
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
AND result_unit is NULL
ORDER BY CASE WHEN r.treatment_id = @pl_treatment_id THEN 1 
		ELSE CASE WHEN r.encounter_id = @pl_encounter_id THEN 2 ELSE 3 END
		END DESC,r.location_result_sequence DESC

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', @pl_treatment_id, 'VFC Eligibility Code') AS varchar(80))

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'VFC Eligibility Code') AS varchar(80))

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Patient', NULL, 'VFC Eligibility Code') AS varchar(80))

RETURN @ls_vfc_eligibility_code 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_vfc_eligibility_code]
	TO [cprsystem]
GO

