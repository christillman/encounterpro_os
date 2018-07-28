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

-- Drop Procedure [dbo].[sp_xml_add_observation]
Print 'Drop Procedure [dbo].[sp_xml_add_observation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_xml_add_observation]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_xml_add_observation]
GO

-- Create Procedure [dbo].[sp_xml_add_observation]
Print 'Create Procedure [dbo].[sp_xml_add_observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_xml_add_observation (
	@ps_cpr_id varchar(12),
	@ps_description varchar(80),
	@pl_treatment_id int,
	@pl_encounter_id int,
   	@pdt_result_expected_date datetime,
	@pl_parent_observation_sequence int,
	@pl_owner_id int,
	@ps_event_id varchar(40),
   	@ps_observed_by varchar(24),
   	@ps_created_by varchar(24),
   	@ps_observation_id varchar(24) ,
	@ps_observation_tag varchar(12) = NULL )
AS

DECLARE @ls_cpr_id varchar(12),
		@ll_observation_sequence int,
		@ls_treatment_observation_id varchar(24)

-- Treat empty string as null for event_id
IF @ps_event_id = ''
	SET @ps_event_id = NULL

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_observed_by = ''
	SET @ps_observed_by = NULL

IF @ps_created_by = ''
	SET @ps_created_by = NULL

-- Use Observed_by as created_by if created_by wasn't supplied
SET @ps_created_by = COALESCE(@ps_created_by, @ps_observed_by)

-- if not sent try to find root observation otherwise create a new one[observation id is used from trt rec]
IF @pl_parent_observation_sequence <= 0 
	SELECT @pl_parent_observation_sequence = null

SELECT @ls_treatment_observation_id = observation_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Cannot find treatment (%s, %d)',16,-1, @ps_cpr_id, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Ignore the passed in observation_id
SET @ps_observation_id = NULL

--look up observation_id
IF @ps_observation_id IS NULL
	EXECUTE sp_new_observation_record
		@ps_description = @ps_description,
		@pl_owner_id = @pl_owner_id,
		@ps_observation_id = @ps_observation_id OUTPUT


IF @pl_parent_observation_sequence IS NULL
	BEGIN
	-- If this is a root observation and the treatment doesn't have
	-- an observation_id, then update the treatment
	IF @ls_treatment_observation_id IS NULL
		EXECUTE sp_set_treatment_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'observation_id',
			@ps_progress = @ps_observation_id,
			@ps_user_id = @ps_observed_by,
			@ps_created_by = @ps_created_by
	
	SELECT @ll_observation_sequence = max(observation_sequence)
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND parent_observation_sequence IS NULL
	AND observation_id = @ps_observation_id
	AND ISNULL(observation_tag, '<NULL>') = ISNULL(@ps_observation_tag, '<NULL>')
	AND (@ps_event_id IS NULL OR ISNULL(event_id, '<NULL>') = ISNULL(@ps_event_id, '<NULL>'))
	
	IF @ll_observation_sequence IS NOT NULL
		return @ll_observation_sequence
	END
ELSE
	BEGIN
	SELECT @ll_observation_sequence = max(observation_sequence)
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND parent_observation_sequence = @pl_parent_observation_sequence
	AND observation_id = @ps_observation_id
	
	IF @ll_observation_sequence IS NOT NULL
		return @ll_observation_sequence
	END

INSERT INTO p_Observation
	    (
	    cpr_id,
	    observation_id,
	    description,
	    treatment_id,
	    encounter_id,
	    observation_tag,
		event_id,
	    result_expected_date,
	    parent_observation_sequence,
	    observed_by,
	    created_by
	    )
VALUES (
	    @ps_cpr_id,
	    @ps_observation_id,
	    @ps_description,
	    @pl_treatment_id,
	    @pl_encounter_id,
	    @ps_observation_tag,
		@ps_event_id,
	    @pdt_result_expected_date,
	    @pl_parent_observation_sequence,
	    @ps_observed_by,
	    @ps_created_by
	    )

SET @ll_observation_sequence = SCOPE_IDENTITY()

return @ll_observation_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_xml_add_observation]
	TO [cprsystem]
GO

