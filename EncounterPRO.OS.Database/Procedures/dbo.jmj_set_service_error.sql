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

-- Drop Procedure [dbo].[jmj_set_service_error]
Print 'Drop Procedure [dbo].[jmj_set_service_error]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_service_error]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_service_error]
GO

-- Create Procedure [dbo].[jmj_set_service_error]
Print 'Create Procedure [dbo].[jmj_set_service_error]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_service_error (
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24),
	@ps_manual_service_flag char(1) = 'N',
	@pl_computer_id int = NULL )
AS

DECLARE 	@ls_temp varchar(255),
			@ll_max_retries int,
			@ll_retries int

EXECUTE sp_set_workplan_item_progress
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_user_id = @ps_user_id,
	@ps_progress_type = 'Error',
	@pdt_progress_date_time = NULL,
	@ps_created_by = @ps_created_by,
	@pl_computer_id = @pl_computer_id

SET @ls_temp = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'max_retries')
IF @ls_temp IS NULL
	SET @ls_temp = dbo.fn_get_global_preference('SYSTEM', 'service_max_retries_default')

IF ISNUMERIC(@ls_temp) > 0
	SET @ll_max_retries = CAST(@ls_temp AS int)

IF @ll_max_retries IS NULL OR @ll_max_retries <= 0
	SET @ll_max_retries = 5

-- If this is a manual service OR this is the #MAINTENANCE user, then cancel the service outright so there are no retries
IF @ps_manual_service_flag = 'Y' OR @ps_user_id = '#MAINTENANCE'
	BEGIN
	EXECUTE sp_set_workplan_item_progress
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@ps_progress_type = 'Cancelled',
		@pdt_progress_date_time = NULL,
		@ps_created_by = @ps_created_by,
		@pl_computer_id = @pl_computer_id
	END
ELSE
	BEGIN
	-- If we've reached our max retries then change the owner to the exception handler
	
	SELECT @ll_retries = retries
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	
	IF @ll_retries >= @ll_max_retries
		BEGIN
		EXECUTE sp_set_workplan_item_progress
			@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
			@ps_user_id = '!Exception',
			@ps_progress_type = 'Change Owner',
			@pdt_progress_date_time = NULL,
			@ps_created_by = @ps_created_by,
			@pl_computer_id = @pl_computer_id
		END
	END
GO
GRANT EXECUTE
	ON [dbo].[jmj_set_service_error]
	TO [cprsystem]
GO

