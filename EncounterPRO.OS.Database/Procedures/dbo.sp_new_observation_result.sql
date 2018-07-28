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

-- Drop Procedure [dbo].[sp_new_observation_result]
Print 'Drop Procedure [dbo].[sp_new_observation_result]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_observation_result]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_observation_result]
GO

-- Create Procedure [dbo].[sp_new_observation_result]
Print 'Create Procedure [dbo].[sp_new_observation_result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_observation_result (
	@ps_observation_id varchar(24),
	@ps_result_type varchar(12) = 'PERFORM',
	@ps_result_unit varchar(12) = 'NA',
	@ps_result varchar(80),
	@ps_result_amount_flag char(1) = 'N',
	@ps_print_result_flag char(1) = NULL,
	@ps_specimen_type varchar(24) = NULL ,
	@ps_abnormal_flag char(1) = 'N',
	@pi_severity smallint = 0,
	@ps_external_source varchar(24) = NULL,
	@pl_property_id int = NULL,
	@ps_service varchar(24) = NULL,
	@ps_unit_preference varchar(24) = NULL,
	@ps_status varchar(12) ='OK',
	@pi_result_sequence smallint OUTPUT )
AS

DECLARE @li_sort_sequence smallint

-- First see if the result already exists
SELECT	@pi_result_sequence = max(result_sequence)
FROM c_Observation_Result
WHERE observation_id = @ps_observation_id
AND result_type = @ps_result_type
AND result = @ps_result
AND result_amount_flag = @ps_result_amount_flag

IF @ps_print_result_flag IS NULL
	SET @ps_print_result_flag = CASE @ps_result_type WHEN 'COLLECT' THEN 'N' ELSE 'Y' END

IF @pi_result_sequence IS NULL
	BEGIN
	-- Add the result

	SELECT	@pi_result_sequence = max(result_sequence)
	FROM c_Observation_Result
	WHERE observation_id = @ps_observation_id

	SELECT	@li_sort_sequence = max(sort_sequence)
	FROM c_Observation_Result
	WHERE observation_id = @ps_observation_id

	IF @pi_result_sequence is null
		SET @pi_result_sequence = 1
	ELSE
		SET @pi_result_sequence = @pi_result_sequence + 1

	IF @li_sort_sequence is null
		SET @li_sort_sequence = 1
	ELSE
		SET @li_sort_sequence = @li_sort_sequence + 1

	INSERT INTO c_Observation_Result (
		observation_id,
		result_sequence,
		result_type,
		result_unit,
		result,
		result_amount_flag,
		print_result_flag,
		specimen_type,
		abnormal_flag,
		severity,
		external_source,
		property_id,
		service,
		unit_preference,
		sort_sequence,
		status )
	VALUES (
		@ps_observation_id,
		@pi_result_sequence,
		@ps_result_type,
		@ps_result_unit,
		@ps_result,
		@ps_result_amount_flag,
		@ps_print_result_flag,
		@ps_specimen_type,
		@ps_abnormal_flag,
		@pi_severity,
		@ps_external_source,
		@pl_property_id,
		@ps_service,
		@ps_unit_preference,
		@li_sort_sequence,
		@ps_status )
	END
ELSE
	BEGIN
	
	UPDATE c_Observation_Result
	SET result_unit = CASE @ps_status WHEN 'OK' THEN @ps_result_unit ELSE COALESCE(result_unit, @ps_result_unit) END,
		print_result_flag = CASE @ps_status WHEN 'OK' THEN @ps_print_result_flag ELSE COALESCE(print_result_flag, @ps_print_result_flag) END,
		specimen_type = CASE @ps_status WHEN 'OK' THEN @ps_specimen_type ELSE COALESCE(specimen_type, @ps_specimen_type) END,
		abnormal_flag = CASE @ps_status WHEN 'OK' THEN @ps_abnormal_flag ELSE COALESCE(abnormal_flag, @ps_abnormal_flag) END,
		severity = CASE @ps_status WHEN 'OK' THEN @pi_severity ELSE COALESCE(severity, @pi_severity) END,
		external_source = CASE @ps_status WHEN 'OK' THEN @ps_external_source ELSE COALESCE(external_source, @ps_external_source) END,
		property_id = CASE @ps_status WHEN 'OK' THEN @pl_property_id ELSE COALESCE(property_id, @pl_property_id) END,
		service = CASE @ps_status WHEN 'OK' THEN @ps_service ELSE COALESCE(service, @ps_service) END,
		unit_preference = CASE @ps_status WHEN 'OK' THEN @ps_unit_preference ELSE COALESCE(unit_preference, @ps_unit_preference) END,
		status = CASE @ps_status WHEN 'OK' THEN @ps_status ELSE COALESCE(status, @ps_status) END
	WHERE observation_id = @ps_observation_id
	AND result_sequence = @pi_result_sequence
	
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_new_observation_result]
	TO [cprsystem]
GO

