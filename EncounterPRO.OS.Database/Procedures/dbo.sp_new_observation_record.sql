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

-- Drop Procedure [dbo].[sp_new_observation_record]
Print 'Drop Procedure [dbo].[sp_new_observation_record]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_observation_record]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_observation_record]
GO

-- Create Procedure [dbo].[sp_new_observation_record]
Print 'Create Procedure [dbo].[sp_new_observation_record]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_observation_record (
	@ps_observation_id varchar(24) OUTPUT,
	@ps_collection_location_domain varchar(12) = 'NA',
	@ps_perform_location_domain varchar(12) = 'NA',
	@ps_collection_procedure_id varchar(24) = NULL,
	@ps_perform_procedure_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_composite_flag char(1) = 'N',
	@ps_exclusive_flag char(1) = 'N',
	@ps_in_context_flag char(1) = 'N',
	@ps_location_pick_flag char(1) = 'N',
	@ps_location_bill_flag char(1) = 'N',
	@ps_observation_type varchar(24) = 'Subjective',
	@ps_default_view char(1) = NULL,
	@ps_display_style varchar(255) = NULL,
	@pl_owner_id int,
	@ps_owner_key varchar(40) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_force_new char(1) = 'N' ,
	@ps_owner_code_domain varchar(40) = NULL ,
	@ps_owner_code varchar(80) = NULL,
	@ps_epro_domain varchar(64) = NULL,
	@ps_code_version varchar(40) = NULL )
AS

DECLARE @ll_key_value integer,
	@li_result_sequence smallint,
	@ls_created_by varchar(24),
	@ls_found_description varchar(80),
	@ll_code_id int,
	@ll_customer_id int

IF @ps_epro_domain IS NULL
	SET @ps_epro_domain = 'observation_id'

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ps_force_new IS NULL OR @ps_force_new <> 'Y'
	SET @ps_force_new = 'N'

IF @ps_status = ''
	SET @ps_status = 'OK'

IF @ps_status IS NULL
	IF @pl_owner_id = 0
		SET @ps_status = 'OK'
	ELSE
		SET @ps_status = 'NA'

SET @ps_observation_id = NULL

SET @ls_created_by = dbo.fn_current_epro_user()

-- See if the observation already exists
IF @ps_force_new = 'N'
	BEGIN
	IF @ps_owner_code_domain IS NOT NULL AND @ps_owner_code IS NOT NULL
		BEGIN
		SET @ps_observation_id = dbo.fn_lookup_epro_id(@pl_owner_id, @ps_owner_code_domain, @ps_owner_code, @ps_epro_domain)
		IF @ps_observation_id IS NOT NULL
			BEGIN
			SELECT @ls_found_description = description
			FROM c_Observation
			WHERE observation_id = @ps_observation_id
			IF @@ROWCOUNT = 0
				SET @ps_observation_id = NULL
			
			IF @ls_found_description <> @ps_description
				SET @ps_observation_id = NULL
			END
		END
	ELSE
		BEGIN
		SELECT @ps_observation_id = max(observation_id)
		FROM c_Observation c
		WHERE description = @ps_description
		AND collection_location_domain = @ps_collection_location_domain
		AND perform_location_domain = @ps_perform_location_domain
		AND ISNULL(collection_location_domain, '<Null>') = ISNULL(@ps_collection_location_domain, '<Null>')
		AND ISNULL(perform_location_domain, '<Null>') = ISNULL(@ps_perform_location_domain, '<Null>')
		AND in_context_flag = @ps_in_context_flag
		AND owner_id = @pl_owner_id
		AND owner_id <> 0
		AND NOT EXISTS (SELECT branch_id
						FROM c_Observation_Tree t
						WHERE t.parent_observation_id = c.observation_id)
		END
	END


IF @ps_observation_id IS NULL
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'OBSERVATION_ID',
		@pl_key_value = @ll_key_value OUTPUT

	SET @ps_observation_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_Observation where observation_id = @ps_observation_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'OBSERVATION_ID',
			@pl_key_value = @ll_key_value OUTPUT
		SET @ps_observation_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END

	IF @pl_owner_id < 0 OR @pl_owner_id IS NULL
		SELECT @pl_owner_id = min(customer_id)
		FROM c_Database_Status



	INSERT INTO c_Observation (
		observation_id,
		collection_location_domain,
		perform_location_domain,
		collection_procedure_id,
		perform_procedure_id,
		description,
		composite_flag,
		exclusive_flag,
		in_context_flag,
		location_pick_flag,
		location_bill_flag,
		observation_type,
		default_view,
		display_style,
		definition,
		owner_id,
		owner_key)
	VALUES (
		@ps_observation_id,
		@ps_collection_location_domain,
		@ps_perform_location_domain,
		@ps_collection_procedure_id,
		@ps_perform_procedure_id,
		@ps_description,
		@ps_composite_flag,
		@ps_exclusive_flag,
		@ps_in_context_flag,
		@ps_location_pick_flag,
		@ps_location_bill_flag,
		@ps_observation_type,
		@ps_default_view,
		@ps_display_style,
		@ps_description,
		@pl_owner_id,
		@ps_owner_key)


	EXECUTE sp_add_default_collect_result @ps_observation_id = @ps_observation_id,
						@pi_result_sequence = @li_result_sequence OUTPUT

	IF @ps_owner_code_domain IS NOT NULL AND @ps_owner_code IS NOT NULL
		BEGIN			
		EXECUTE @ll_code_id = xml_add_mapping
			@pl_owner_id = @pl_owner_id ,
			@ps_code_domain = @ps_owner_code_domain ,
			@ps_code_version = @ps_code_version ,
			@ps_code = @ps_owner_code ,
			@ps_code_description = NULL,
			@ps_epro_domain = @ps_epro_domain,
			@ps_epro_id = @ps_observation_id,
			@ps_epro_description = NULL,
			@pl_epro_owner_id = @ll_customer_id,
			@ps_created_by = @ls_created_by
		END
	END
ELSE
	BEGIN
	UPDATE c_Observation
	SET collection_location_domain = @ps_collection_location_domain,
		perform_location_domain = @ps_perform_location_domain,
		collection_procedure_id = @ps_collection_procedure_id,
		perform_procedure_id = @ps_perform_procedure_id,
		composite_flag = @ps_composite_flag,
		exclusive_flag = @ps_exclusive_flag,
		in_context_flag = @ps_in_context_flag,
		location_pick_flag = @ps_location_pick_flag,
		location_bill_flag = @ps_location_bill_flag,
		observation_type = @ps_observation_type,
		default_view = @ps_default_view,
		display_style = @ps_display_style
	WHERE observation_id = @ps_observation_id
	END


GO
GRANT EXECUTE
	ON [dbo].[sp_new_observation_record]
	TO [cprsystem]
GO

