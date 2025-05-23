﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_remove_results]
Print 'Drop Procedure [dbo].[sp_remove_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_remove_results]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_remove_results]
GO

-- Create Procedure [dbo].[sp_remove_results]
Print 'Create Procedure [dbo].[sp_remove_results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_remove_results (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@ps_location varchar(24),
	@pi_result_sequence smallint,
	@pl_encounter_id integer,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_child_observation_sequence int

-- First recursively call this stored procedure for each child observation
DECLARE lc_children CURSOR LOCAL FAST_FORWARD FOR
	SELECT observation_sequence
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND parent_observation_sequence = @pl_observation_sequence

OPEN lc_children

FETCH lc_children INTO @ll_child_observation_sequence
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_remove_results
		@ps_cpr_id = @ps_cpr_id,
		@pl_observation_sequence = @ll_child_observation_sequence,
		@ps_location = @ps_location,
		@pi_result_sequence = @pi_result_sequence,
		@pl_encounter_id = @pl_encounter_id,
		@ps_user_id = @ps_user_id,
		@ps_created_by =  @ps_created_by

	FETCH lc_children INTO @ll_child_observation_sequence
	END

-- Then "delete" then results and comments for this observation_sequence
INSERT INTO [dbo].[p_Observation_Result_Progress]
           ([cpr_id]
           ,[observation_sequence]
           ,[location_result_sequence]
           ,[encounter_id]
           ,[treatment_id]
           ,[user_id]
           ,[progress_date_time]
           ,[progress_type]
           ,[progress_key]
           ,[progress_value]
           ,[created_by])
SELECT cpr_id,
	observation_sequence,
	location_result_sequence,
	encounter_id,
	treatment_id,
	@ps_user_id,
	dbo.get_client_datetime(),
	'Modify',
	'current_flag',
	'N',
	@ps_created_by
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence
AND current_flag = 'Y'
AND (@ps_location IS NULL OR @ps_location = location)
AND (@pi_result_sequence IS NULL OR @pi_result_sequence = result_sequence)


GO
GRANT EXECUTE
	ON [dbo].[sp_remove_results]
	TO [cprsystem]
GO

