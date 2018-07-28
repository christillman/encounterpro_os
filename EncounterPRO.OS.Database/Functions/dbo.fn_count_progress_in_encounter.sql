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

-- Drop Function [dbo].[fn_count_progress_in_encounter]
Print 'Drop Function [dbo].[fn_count_progress_in_encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_count_progress_in_encounter]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_count_progress_in_encounter]
GO

-- Create Function [dbo].[fn_count_progress_in_encounter]
Print 'Create Function [dbo].[fn_count_progress_in_encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_count_progress_in_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_context_object varchar(12),
	@pl_object_key int,
	@ps_progress_type varchar(24) )

RETURNS int

AS
BEGIN

-- This function counts the number of attachments for the specified context object within the specified encounter.  


DECLARE @ll_count int,
		@ldt_discharge_date datetime,
		@ll_prev_encounter_id int,
		@ldt_prev_discharge_date datetime,
		@ls_in_office_flag char(1)

-- As a temporary measure, we're going to count all the progress for the object.
SET @ll_count = dbo.fn_count_progress_for_object (	@ps_cpr_id ,
													@ps_context_object ,
													@pl_object_key ,
													@ps_progress_type )
RETURN @ll_count


SET @ll_count = 0

SELECT @ldt_discharge_date = ISNULL(discharge_date, CAST('1/1/2100' AS datetime))
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
IF @@ROWCOUNT = 0
	RETURN -1

SELECT @ll_prev_encounter_id = max(encounter_id)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id < @pl_encounter_id
AND encounter_status <> 'CANCELED'
IF @ll_prev_encounter_id IS NULL
	SET @ldt_prev_discharge_date = NULL
ELSE
	BEGIN
	SELECT @ldt_prev_discharge_date = discharge_date
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_prev_encounter_id
	IF @@ROWCOUNT = 0
		SET @ldt_prev_discharge_date = NULL
	END


IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Encounter'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Treatment'
	BEGIN
	SELECT @ls_in_office_flag = c.in_office_flag
	FROM c_Treatment_Type c
		INNER JOIN p_Treatment_Item t
		ON c.treatment_type = t.treatment_type
	WHERE t.cpr_id = @ps_cpr_id
	AND t.treatment_id = @pl_object_key
	
	SELECT @ll_count = count(*)
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date
		OR @ls_in_office_flag = 'Y')
	AND NOT (progress_type = 'Attachment' and progress_key = 'Signature')
	END


RETURN @ll_count 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_count_progress_in_encounter]
	TO [cprsystem]
GO

