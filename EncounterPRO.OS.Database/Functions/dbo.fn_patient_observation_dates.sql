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

-- Drop Function [dbo].[fn_patient_observation_dates]
Print 'Drop Function [dbo].[fn_patient_observation_dates]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_observation_dates]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_observation_dates]
GO

-- Create Function [dbo].[fn_patient_observation_dates]
Print 'Create Function [dbo].[fn_patient_observation_dates]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE     FUNCTION dbo.fn_patient_observation_dates
(	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24) = 'Patient',
	@pl_object_key int = NULL,
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint = NULL,
	@ps_result_type varchar(24) = NULL
)

RETURNS @patient_observation_dates TABLE (	 
	observation_date datetime NOT NULL )

AS

BEGIN
DECLARE @temp_dates TABLE (	 
	observation_date datetime NOT NULL )

DECLARE @ll_encounter_id int,
		@ll_treatment_id int,
		@ll_observation_sequence int,
		@ls_child_observation_id varchar(24), 
		@li_child_result_sequence smallint

SET @ll_encounter_id = NULL
SET @ll_treatment_id = NULL
SET @ll_observation_sequence = NULL

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	SET @ll_observation_sequence = @pl_object_key

-- First get the specified results from the specified observation
IF @pi_result_sequence IS NOT NULL
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND result_sequence = @pi_result_sequence
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END
ELSE IF @ps_result_type IS NOT NULL
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND result_type = @ps_result_type
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END
ELSE
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END

-- If we're not after results for the specified observation, then
-- get all the results from the first level children of the specified
-- observation
IF @pi_result_sequence IS NULL AND @ps_result_type IS NULL
	BEGIN
	DECLARE lc_children CURSOR LOCAL FAST_FORWARD FOR
		SELECT child_observation_id,
				result_sequence
		FROM c_Observation_Tree
		WHERE parent_observation_id = @ps_observation_id

	OPEN lc_children

	FETCH lc_children INTO @ls_child_observation_id, @li_child_result_sequence

	WHILE @@FETCH_STATUS = 0
		BEGIN
		INSERT INTO @temp_dates (
			observation_date)
		SELECT observation_date
		FROM dbo.fn_patient_observation_dates(@ps_cpr_id ,
												@ps_context_object ,
												@pl_object_key ,
												@ls_child_observation_id ,
												@li_child_result_sequence ,
												DEFAULT )
		

		FETCH lc_children INTO @ls_child_observation_id, @li_child_result_sequence
		END

	CLOSE lc_children
	DEALLOCATE lc_children

	END




INSERT INTO @patient_observation_dates (
	observation_date )
SELECT DISTINCT observation_date
FROM @temp_dates

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_observation_dates] TO [cprsystem]
GO

