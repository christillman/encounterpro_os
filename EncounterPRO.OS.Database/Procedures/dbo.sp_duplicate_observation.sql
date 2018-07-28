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

-- Drop Procedure [dbo].[sp_duplicate_observation]
Print 'Drop Procedure [dbo].[sp_duplicate_observation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_duplicate_observation]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_duplicate_observation]
GO

-- Create Procedure [dbo].[sp_duplicate_observation]
Print 'Create Procedure [dbo].[sp_duplicate_observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_duplicate_observation
	(
	@ps_observation_id varchar(24),
	@ps_new_description varchar(80),
	@ps_user_id varchar(24),
	@ps_new_observation_id varchar(24) OUTPUT
	)
AS

DECLARE	@ls_collection_location_domain varchar(12),
		@ls_perform_location_domain varchar(12),
		@ls_collection_procedure_id varchar(24),
		@ls_perform_procedure_id varchar(24),
		@ls_composite_flag char(1),
		@ls_exclusive_flag char(1),
		@ls_in_context_flag char(1),
		@ls_location_pick_flag char(1),
		@ls_location_bill_flag char(1),
		@ls_observation_type varchar(24),
		@ls_default_view char(1),
		@ls_display_style varchar(255),
		@ll_owner_id int,
		@ls_owner_key varchar(40)

SELECT @ls_collection_location_domain = collection_location_domain,
		@ls_perform_location_domain = perform_location_domain,
		@ls_collection_procedure_id = collection_procedure_id,
		@ls_perform_procedure_id = perform_procedure_id,
		@ls_composite_flag = composite_flag,
		@ls_exclusive_flag = exclusive_flag,
		@ls_in_context_flag = in_context_flag,
		@ls_location_pick_flag = location_pick_flag,
		@ls_location_bill_flag = location_bill_flag,
		@ls_observation_type = observation_type,
		@ls_default_view = default_view,
		@ls_display_style = display_style
FROM c_Observation
WHERE observation_id = @ps_observation_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Observation does not exist (%s)',16,-1, @ps_observation_id)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SET @ls_owner_key = NULL


EXECUTE sp_new_observation_record
	@ps_observation_id = @ps_new_observation_id OUTPUT,
	@ps_collection_location_domain = @ls_collection_location_domain,
	@ps_perform_location_domain = @ls_perform_location_domain,
	@ps_collection_procedure_id = @ls_collection_procedure_id,
	@ps_perform_procedure_id = @ls_perform_procedure_id,
	@ps_description = @ps_new_description,
	@ps_composite_flag = @ls_composite_flag,
	@ps_exclusive_flag = @ls_exclusive_flag,
	@ps_in_context_flag = @ls_in_context_flag,
	@ps_location_pick_flag = @ls_location_pick_flag,
	@ps_location_bill_flag = @ls_location_bill_flag,
	@ps_observation_type = @ls_observation_type,
	@ps_default_view = @ls_default_view,
	@ps_display_style = @ls_display_style,
	@pl_owner_id = @ll_owner_id,
	@ps_owner_key = @ls_owner_key

IF @ps_new_observation_id IS NULL
	BEGIN
	RAISERROR ('Error creating new observation (%s)',16,-1, @ps_new_description)
	ROLLBACK TRANSACTION
	RETURN
	END


-- Duplicate the results
DELETE FROM c_Observation_Result
WHERE observation_id = @ps_new_observation_id

INSERT INTO c_Observation_Result (
	observation_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	print_result_flag,
	severity,
	abnormal_flag,
	specimen_type,
	specimen_amount,
	external_source,
	property_id,
	service,
	print_result_separator,
	unit_preference,
	display_mask,
	sort_sequence,
	status )
SELECT @ps_new_observation_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	print_result_flag,
	severity,
	abnormal_flag,
	specimen_type,
	specimen_amount,
	external_source,
	property_id,
	service,
	print_result_separator,
	unit_preference,
	display_mask,
	sort_sequence,
	status 
FROM c_Observation_Result
WHERE observation_id = @ps_observation_id
AND status = 'OK'



-- Duplicate the treatment_types
INSERT INTO c_Observation_Treatment_Type (
	observation_id,
	treatment_type)
SELECT @ps_new_observation_id,
	treatment_type
FROM c_Observation_Treatment_Type
WHERE observation_id = @ps_observation_id


-- Duplicate the categories
INSERT INTO c_Observation_Observation_Cat (
	observation_id,
	treatment_type,
	observation_category_id)
SELECT @ps_new_observation_id,
	treatment_type,
	observation_category_id
FROM c_Observation_Observation_Cat
WHERE observation_id = @ps_observation_id

-- Duplicate Specialties
INSERT INTO c_Common_Observation (
	specialty_id,
	observation_id)
SELECT specialty_id,
	@ps_new_observation_id
FROM c_Common_Observation
WHERE observation_id = @ps_observation_id


-- We've copied the c_Observation record, now copy the 1st level tree records
INSERT INTO c_Observation_Tree (
	parent_observation_id ,
	child_observation_id ,
	age_range_id ,
	sex ,
	edit_service ,
	location ,
	result_sequence ,
	result_sequence_2 ,
	description ,
	followon_severity ,
	followon_observation_id ,
	observation_tag ,
	on_results_entered ,
	unit_preference ,
	sort_sequence ,
	last_updated ,
	updated_by )
SELECT @ps_new_observation_id ,
	child_observation_id ,
	age_range_id ,
	sex ,
	edit_service ,
	location ,
	result_sequence ,
	result_sequence_2 ,
	description ,
	followon_severity ,
	followon_observation_id ,
	observation_tag ,
	on_results_entered ,
	unit_preference ,
	sort_sequence ,
	getdate() ,
	@ps_user_id
FROM c_Observation_Tree
WHERE parent_observation_id = @ps_observation_id

GO
GRANT EXECUTE
	ON [dbo].[sp_duplicate_observation]
	TO [cprsystem]
GO

