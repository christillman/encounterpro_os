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

-- Drop Procedure [dbo].[sp_new_patient_address]
Print 'Drop Procedure [dbo].[sp_new_patient_address]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_patient_address]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_patient_address]
GO

-- Create Procedure [dbo].[sp_new_patient_address]
Print 'Create Procedure [dbo].[sp_new_patient_address]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_patient_address (
	@ps_cpr_id varchar(12),
	@ps_description varchar(40),
	@ps_address_line_1 varchar(40) = NULL,
	@ps_address_line_2 varchar(40) = NULL,
	@ps_city varchar(40) = NULL,
	@ps_state varchar(2) = NULL,
	@ps_zip varchar(10) = NULL,
	@ps_country varchar(2) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ll_owner_id int,
		@ll_count int,
		@ll_error int,
		@ll_rowcount int,
		@ls_current_address_line_1 varchar(40) ,
		@ls_current_address_line_2 varchar(40) ,
		@ls_current_city varchar(40) ,
		@ls_current_state varchar(2) ,
		@ls_current_zip varchar(10) ,
		@ls_current_country varchar(2) 

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @ps_cpr_id IS NULL
	BEGIN
	RAISERROR ('No cpr_id specified',16,-1)
	RETURN
	END

-- Set the default description
IF @ps_description IS NULL
	SET @ps_description = 'Address'

-- Make sure this address represents a change to what we already have
SELECT @ls_current_address_line_1 = address_line_1,
		@ls_current_address_line_2 = address_line_2,
		@ls_current_city = city,
		@ls_current_state = state,
		@ls_current_zip = zip,
		@ls_current_country = country
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('cpr_id not found (%s)',16,-1, @ps_cpr_id)
	RETURN
	END

IF ISNULL(@ls_current_address_line_1, '!NULL') <> ISNULL(@ps_address_line_1, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'address_line_1',
		@ps_progress = @ps_address_line_1,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_address_line_2, '!NULL') <> ISNULL(@ps_address_line_2, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'address_line_2',
		@ps_progress = @ps_address_line_2,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_city, '!NULL') <> ISNULL(@ps_city, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'city',
		@ps_progress = @ps_city,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_state, '!NULL') <> ISNULL(@ps_state, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'state',
		@ps_progress = @ps_state,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_zip, '!NULL') <> ISNULL(@ps_zip, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'zip',
		@ps_progress = @ps_zip,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_country, '!NULL') <> ISNULL(@ps_country, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'country',
		@ps_progress = @ps_country,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

GO
GRANT EXECUTE
	ON [dbo].[sp_new_patient_address]
	TO [cprsystem]
GO

