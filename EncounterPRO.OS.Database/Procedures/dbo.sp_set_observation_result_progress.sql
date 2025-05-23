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

-- Drop Procedure [dbo].[sp_set_observation_result_progress]
Print 'Drop Procedure [dbo].[sp_set_observation_result_progress]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_observation_result_progress]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_observation_result_progress]
GO

-- Create Procedure [dbo].[sp_set_observation_result_progress]
Print 'Create Procedure [dbo].[sp_set_observation_result_progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_observation_result_progress (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int ,
	@pl_location_result_sequence int ,
	@pl_encounter_id int,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress varchar(max) = NULL,
	@pdt_progress_date_time datetime = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS


DECLARE @ll_encounter_log_id integer,
	@li_encounter_count smallint,
	@ls_status varchar(12),
	@ll_patient_workplan_id int,
	@ls_progress_value varchar(40),
	@ll_length int

IF @pdt_progress_date_time IS NULL
	SET @pdt_progress_date_time = dbo.get_client_datetime()


-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].
SET @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

IF @ll_length <= 40
	BEGIN
	SET @ls_progress_value = CASE WHEN @ps_progress LIKE char(13) + char(10) + '%' THEN substring(@ps_progress,3,100) ELSE @ps_progress END
	SET @ls_progress_value = CASE WHEN @ls_progress_value LIKE '%' + char(13) + char(10) THEN left(@ls_progress_value, len(@ls_progress_value) - 2) ELSE @ls_progress_value END
	SET @ls_progress_value = CONVERT(varchar(40), TRIM(@ls_progress_value))

	INSERT INTO p_observation_result_Progress (
		cpr_id,
		observation_sequence,
		location_result_sequence,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@pl_location_result_sequence,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		dbo.get_client_datetime(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_observation_result_Progress (
		cpr_id,
		observation_sequence,
		location_result_sequence,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@pl_location_result_sequence,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		dbo.get_client_datetime(),
		@ps_created_by )


GO
GRANT EXECUTE
	ON [dbo].[sp_set_observation_result_progress]
	TO [cprsystem]
GO

