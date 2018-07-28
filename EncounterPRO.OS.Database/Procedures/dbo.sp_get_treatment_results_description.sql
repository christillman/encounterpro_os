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

-- Drop Procedure [dbo].[sp_get_treatment_results_description]
Print 'Drop Procedure [dbo].[sp_get_treatment_results_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_results_description]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_results_description]
GO

-- Create Procedure [dbo].[sp_get_treatment_results_description]
Print 'Create Procedure [dbo].[sp_get_treatment_results_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_treatment_results_description (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_description varchar(255) OUTPUT )
AS

DECLARE @ls_root_observation_id varchar(24),
	@ls_composite_flag char(1)

SELECT @ls_root_observation_id = observation_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such treatment (%s, %d)',16,-1, @ps_cpr_id, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ls_root_observation_id IS NULL
	BEGIN
	SELECT @ps_description = NULL
	RETURN
	END

SELECT @ls_composite_flag = composite_flag
FROM c_Observation
WHERE observation_id = @ls_root_observation_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such observation (%s)',16,-1, @ls_root_observation_id)
	ROLLBACK TRANSACTION
	RETURN
	END

select	p_observation_result.treatment_id,
	p_observation_result.observation_id,
	p_observation_result.location,
	p_observation_result.result_sequence,
	p_observation_result.encounter_id,
	p_observation_result.attachment_id,
	p_observation_result.attachment_id,
	p_observation_result.attachment_id,
	convert(real,p_observation_result.result_value)as result_amount,
	p_observation_result.result_date_time,
	c_observation.description as observation_description,
	c_observation.collection_location_domain,
	c_observation.perform_location_domain,
	c_observation_result.result_unit,
	c_observation_result.result,
	c_observation_result.result_amount_flag,
	c_observation_result.abnormal_flag,
	c_observation_result.severity,
	c_observation_result.sort_sequence as result_sort_sequence,
	c_observation_result.status,
	c_Location.sort_sequence as location_sort_sequence,
	c_Location.description as location_description,
	c_treatment_type.treatment_type,
	c_treatment_type.sort_sequence as treatment_sort_sequence,
	c_treatment_type.icon
from	p_observation_result (NOLOCK),
	c_observation_result (NOLOCK),
	c_observation (NOLOCK),
	c_Location (NOLOCK),
	c_treatment_type (NOLOCK),
	p_treatment_item (NOLOCK)
where p_observation_result.observation_id = c_observation_result.observation_id
and p_observation_result.result_sequence = c_observation_result.result_sequence
and p_observation_result.observation_id = c_Observation.observation_id
and p_observation_result.location = c_Location.location
and p_observation_result.cpr_id = @ps_cpr_id
and p_observation_result.treatment_id = @pl_treatment_id
and c_observation_result.result_type = 'PERFORM'
and p_treatment_item.treatment_type = c_treatment_type.treatment_type
and p_treatment_item.cpr_id = @ps_cpr_id
and p_treatment_item.treatment_id = @pl_treatment_id
ORDER BY c_treatment_type.sort_sequence,
	c_Observation.description,
	c_Observation.observation_id,
	c_Location.sort_sequence,
	c_Location.description,
	c_observation_result.sort_sequence,
	c_observation_result.result

GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_results_description]
	TO [cprsystem]
GO

