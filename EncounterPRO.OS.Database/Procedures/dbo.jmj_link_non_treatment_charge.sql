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

-- Drop Procedure [dbo].[jmj_link_non_treatment_charge]
Print 'Drop Procedure [dbo].[jmj_link_non_treatment_charge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_link_non_treatment_charge]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_link_non_treatment_charge]
GO

-- Create Procedure [dbo].[jmj_link_non_treatment_charge]
Print 'Create Procedure [dbo].[jmj_link_non_treatment_charge]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_link_non_treatment_charge (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer,
	@ps_created_by varchar(24) )
AS

-- This procedure implements the billing algorithm rule 12 concerning non-treatment charges

DECLARE @ls_procedure_id varchar(24),
		@ls_well_flag char(1),
		@ls_sick_flag char(1),
		@ls_procedure_well_encounter_flag char(1),
		@ll_well_count int,
		@ll_sick_count int

SELECT @ls_well_flag = well_flag,
	@ls_sick_flag = sick_flag
FROM dbo.fn_encounter_well_sick_status(@ps_cpr_id, @pl_encounter_id)

SELECT @ls_procedure_id = procedure_id
FROM p_Encounter_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

SELECT 	@ls_procedure_well_encounter_flag = well_encounter_flag
FROM c_Procedure
WHERE procedure_id = @ls_procedure_id

IF @ls_procedure_well_encounter_flag IS NULL OR @ls_procedure_well_encounter_flag NOT IN ('Y', 'N')
	SET @ls_procedure_well_encounter_flag = 'A'

-- Remove any existing associations for this charge
DELETE p_Encounter_Assessment_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

SET @ll_well_count = 0
SET @ll_sick_count = 0

-- New Non-Treatment Charge
IF @ls_well_flag = 'Y' AND @ls_procedure_well_encounter_flag IN ('Y', 'A')
	BEGIN
	-- Associate charge with all assessment-billing records where c_Assessment_Type.well_encounter_flag = 'Y'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	pea.cpr_id,
		pea.encounter_id,
		pea.problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment pea
		INNER JOIN c_Assessment_Definition d
		ON pea.assessment_id = d.assessment_id
		INNER JOIN c_Assessment_Type t
		ON d.assessment_type = t.assessment_type
	WHERE pea.cpr_id = @ps_cpr_id
	AND pea.encounter_id = @pl_encounter_id
	AND t.well_encounter_flag = 'Y'
	AND pea.bill_flag = 'Y'
	AND pea.exclusive_link = 'N'
	
	SET @ll_well_count = @@ROWCOUNT
	END

IF @ls_sick_flag = 'Y' AND @ls_procedure_well_encounter_flag IN ('N', 'A')
	BEGIN
	-- Associate charge with all assessment-billing records where c_Assessment_Type.well_encounter_flag = 'N'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	pea.cpr_id,
		pea.encounter_id,
		pea.problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment pea
		INNER JOIN c_Assessment_Definition d
		ON pea.assessment_id = d.assessment_id
		INNER JOIN c_Assessment_Type t
		ON d.assessment_type = t.assessment_type
	WHERE pea.cpr_id = @ps_cpr_id
	AND pea.encounter_id = @pl_encounter_id
	AND t.well_encounter_flag = 'N'
	AND pea.bill_flag = 'Y'
	AND pea.exclusive_link = 'N'
	
	SET @ll_sick_count = @@ROWCOUNT
	END

IF @ll_well_count = 0 AND @ll_sick_count = 0
	BEGIN
	-- If there weren't any associated assessments, then
	-- add an association with all the billed assessments
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	@ps_cpr_id,
		@pl_encounter_id,
		problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND bill_flag = 'Y'
	AND exclusive_link = 'N'

	SET @ll_well_count = @@ROWCOUNT
	END


RETURN @ll_well_count + @ll_sick_count

GO
GRANT EXECUTE
	ON [dbo].[jmj_link_non_treatment_charge]
	TO [cprsystem]
GO

