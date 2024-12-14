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

-- Drop Function [dbo].[fn_em_encounter_visit_level]
Print 'Drop Function [dbo].[fn_em_encounter_visit_level]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_em_encounter_visit_level]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_em_encounter_visit_level]
GO

-- Create Function [dbo].[fn_em_encounter_visit_level]
Print 'Create Function [dbo].[fn_em_encounter_visit_level]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_em_encounter_visit_level (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS
BEGIN
DECLARE @ll_visit_level int,
		@ls_level varchar(255),
		@ls_em_doc_guide varchar(24)

SET @ll_visit_level = NULL

-- Make sure we have input params
IF @ps_cpr_id IS NULL
	RETURN @ll_visit_level

IF @pl_encounter_id IS NULL
	RETURN @ll_visit_level

-- See if there is a user-selected visit level
SET @ls_level = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'EM_ENCOUNTER_LEVEL')
IF ISNUMERIC(@ls_level) = 1
	BEGIN
	SET @ll_visit_level = CAST(@ls_level AS int)
	IF @ll_visit_level > 0
		RETURN @ll_visit_level
	END

-- See if there is a recorded calculated visit level
SET @ls_level = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'Calculated EM Encounter Level')
IF ISNUMERIC(@ls_level) = 1
	BEGIN
	SET @ll_visit_level = CAST(@ls_level AS int)
	IF @ll_visit_level > 0
		RETURN @ll_visit_level
	END

-- We didn't find a user set level or a recorded calculated level.  Before we recalculate the level from scratch, let's see
-- if we can figure out the level from the billed visit code
SELECT @ll_visit_level = MAX(visit_level)
FROM p_Patient_Encounter e
	INNER JOIN c_Encounter_Type et
	ON e.encounter_type = et.encounter_type
	INNER JOIN em_visit_code_item i
	ON et.visit_code_group = i.visit_code_group
	AND e.new_flag = i.new_flag
	INNER JOIN p_Encounter_Charge c
	ON e.cpr_id = c.cpr_id
	AND e.encounter_id = c.encounter_id
	AND i.procedure_id = c.procedure_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
AND c.procedure_type = 'PRIMARY'
AND c.bill_flag = 'Y'

IF @ll_visit_level > 0
	RETURN @ll_visit_level


-- We need to recalculate the visit level.  First we need to know which doc guide to use.
SET @ls_em_doc_guide = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'em_documentation_guide')
IF @ls_em_doc_guide IS NULL
	SET @ls_em_doc_guide = dbo.fn_get_preference('BILLING', 'em_documentation_guide', DEFAULT, DEFAULT)

IF @ls_em_doc_guide IS NULL
	SET @ls_em_doc_guide = '1997 E&M'

SELECT @ll_visit_level = MAX(visit_level)
FROM dbo.fn_em_visit_rules_passed (@ps_cpr_id, @pl_encounter_id, @ls_em_doc_guide)
WHERE passed_flag = 'Y'

IF @ll_visit_level > 0
	RETURN @ll_visit_level

RETURN 1

END

GO
GRANT EXECUTE
	ON [dbo].[fn_em_encounter_visit_level]
	TO [cprsystem]
GO

