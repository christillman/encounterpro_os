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

-- Drop Function [dbo].[fn_defaults_from_actuals]
Print 'Drop Function [dbo].[fn_defaults_from_actuals]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_defaults_from_actuals]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_defaults_from_actuals]
GO

-- Create Function [dbo].[fn_defaults_from_actuals]
Print 'Create Function [dbo].[fn_defaults_from_actuals]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_defaults_from_actuals (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence integer,
	@pl_branch_id int )

RETURNS @actual_results TABLE (
	branch_id int NULL,
	observation_sequence int NULL,
	observation_id varchar(24) NOT NULL,
	location varchar(24) NULL,
	result_sequence smallint NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	sort_sequence smallint NULL,
	long_result_value varchar(max) NULL,
	result_type varchar(12) NULL,
	result varchar(80) NULL,
	abnormal_flag char(1) NULL,
	severity smallint NULL )

AS

BEGIN

DECLARE @branches TABLE (
	branch_sequence int IDENTITY(1, 1) NOT NULL,
	branch_id int NOT NULL,
	child_observation_id varchar(24) NOT NULL,
	sort_sequence smallint NULL )

DECLARE @patient_results TABLE (
	location varchar(24) NOT NULL,
	result_sequence smallint NOT NULL,
	location_result_sequence int NOT NULL,
	result_date_time datetime NULL)

DECLARE @ll_count int,
		@ll_iterations int,
		@ll_branch_id int,
		@ll_branch_sequence int,
		@ll_observation_sequence int,
		@ls_parent_observation_id varchar(24),
		@ls_child_observation_id varchar(24)


-- First insert the results from this observation_sequence
INSERT INTO @patient_results (
	location,
	result_sequence,
	location_result_sequence )
SELECT location,
	result_sequence,
	max(location_result_sequence) as location_result_sequence
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id	
AND observation_sequence = @pl_observation_sequence
GROUP BY location,
	result_sequence

INSERT INTO @actual_results (
	branch_id ,
	observation_sequence ,
	observation_id ,
	location ,
	result_sequence ,
	result_type ,
	result ,
	result_value ,
	long_result_value ,
	result_unit ,
	abnormal_flag ,
	severity )
SELECT COALESCE(@pl_branch_id, 0) ,
	r.observation_sequence ,
	r.observation_id ,
	r.location ,
	r.result_sequence ,
	r.result_type ,
	r.result ,
	r.result_value ,
	r.long_result_value ,
	r.result_unit ,
	r.abnormal_flag ,
	r.severity
FROM p_Observation_Result r
	INNER JOIN @patient_results x
	ON x.location_result_sequence = r.location_result_sequence
WHERE r.cpr_id = @ps_cpr_id
AND r.observation_sequence = @pl_observation_sequence
AND r.result_date_time IS NOT NULL
AND r.result_type IN ('PERFORM', 'Comment')
AND r.current_flag = 'Y'

SELECT @ls_parent_observation_id = observation_id
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence

-- Get the branches for this parent
INSERT INTO @branches (
	branch_id,
	child_observation_id,
	sort_sequence)
SELECT branch_id,
		child_observation_id,
		sort_sequence
FROM c_Observation_Tree
WHERE parent_observation_id = @ls_parent_observation_id
ORDER BY sort_sequence

-- Then insert the results for each of this observation's children
DECLARE lc_children CURSOR LOCAL STATIC FOR
	SELECT observation_sequence,
			observation_id
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND parent_observation_sequence = @pl_observation_sequence
	ORDER BY observation_sequence

OPEN lc_children

FETCH lc_children INTO @ll_observation_sequence, @ls_child_observation_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Get the first branch that matches the child observation_id
	SELECT @ll_branch_sequence = min(branch_sequence)
	FROM @branches
	WHERE child_observation_id = @ls_child_observation_id

	-- If we found one, then get the results for this child	
	IF 	@ll_branch_sequence IS NOT NULL
		BEGIN
		SELECT @ll_branch_id = branch_id
		FROM @branches
		WHERE branch_sequence = @ll_branch_sequence

		-- Insert the results from this child observation
		INSERT INTO @actual_results (
			branch_id ,
			observation_sequence ,
			observation_id ,
			location ,
			result_sequence ,
			result_type ,
			result ,
			result_value ,
			long_result_value ,
			result_unit ,
			abnormal_flag ,
			severity ,
			sort_sequence )
		SELECT branch_id ,
			observation_sequence ,
			observation_id ,
			location ,
			result_sequence ,
			result_type ,
			result ,
			result_value ,
			long_result_value ,
			result_unit ,
			abnormal_flag ,
			severity ,
			sort_sequence
		FROM dbo.fn_defaults_from_actuals(@ps_cpr_id, @ll_observation_sequence, @ll_branch_id)
		
		-- Delete this branch so the next time the same observation is found it uses the next branch
		DELETE @branches
		WHERE branch_sequence = @ll_branch_sequence
		END
		
	FETCH lc_children INTO @ll_observation_sequence, @ls_child_observation_id
	END
	
CLOSE lc_children
DEALLOCATE lc_children

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_defaults_from_actuals]
	TO [cprsystem]
GO

