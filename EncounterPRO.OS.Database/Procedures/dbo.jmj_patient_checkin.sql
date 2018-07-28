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

-- Drop Procedure [dbo].[jmj_patient_checkin]
Print 'Drop Procedure [dbo].[jmj_patient_checkin]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_checkin]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_checkin]
GO

-- Create Procedure [dbo].[jmj_patient_checkin]
Print 'Create Procedure [dbo].[jmj_patient_checkin]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_patient_checkin (
	@ps_cpr_id varchar(12),
	@ps_encounter_type varchar(24),
	@pdt_encounter_date datetime = NULL,
	@ps_encounter_description varchar(80) = NULL,
	@ps_patient_location varchar(24) = NULL,
	@ps_attending_doctor varchar(24) = NULL,
	@ps_referring_doctor varchar(24) = NULL,
	@ps_admit_reason varchar(24) = NULL,
	@ps_new_flag char(1) = NULL,
	@ps_office_id varchar(4),
	@ps_created_by varchar(24)
)

AS
DECLARE @ll_encounter_id int,
		@ll_patient_workplan_id int,
		@ls_bill_flag char(1),
		@ls_billing_posted char(1),
		@ls_indirect_flag char(1),
		@ls_encounter_status varchar(8),
		@ls_encounter_type_description varchar(80),
		@ls_billing_hold_flag char(1),
		@ls_patient_location varchar(24),
		@ls_next_patient_location varchar(24)

SELECT @ls_bill_flag = bill_flag,
		@ls_indirect_flag = default_indirect_flag,
		@ls_encounter_type_description = description
FROM c_Encounter_Type
WHERE encounter_type = @ps_encounter_type

-- billing posted flag (x -not billed)
SET @ls_billing_posted = CASE @ls_bill_flag WHEN 'Y' THEN 'N' ELSE 'X' END
SET @ls_billing_hold_flag = 'N'

SET @ls_encounter_status = 'OPEN'

IF @pdt_encounter_date IS NULL
	SET @pdt_encounter_date = getdate()

IF @ps_encounter_description IS NULL
	SET @ps_encounter_description = @ls_encounter_type_description

IF @ps_new_flag IS NULL
	SET @ps_new_flag = 'N'

INSERT INTO p_Patient_Encounter (
	cpr_id ,
	encounter_type ,
	encounter_status ,
	encounter_date ,
	encounter_description ,
	patient_location ,
	attending_doctor ,
	referring_doctor ,
	admit_reason ,
	bill_flag ,
	billing_posted ,
	indirect_flag ,
	new_flag ,
	billing_hold_flag ,
	office_id ,
	created_by )
VALUES (
	@ps_cpr_id ,
	@ps_encounter_type ,
	@ls_encounter_status ,
	@pdt_encounter_date ,
	@ps_encounter_description ,
	@ps_patient_location ,
	@ps_attending_doctor ,
	@ps_referring_doctor ,
	@ps_admit_reason ,
	@ls_bill_flag ,
	@ls_billing_posted ,
	@ls_indirect_flag ,
	@ps_new_flag ,
	@ls_billing_hold_flag ,
	@ps_office_id ,
	@ps_created_by )

SET @ll_encounter_id = SCOPE_IDENTITY()

-- Add the "Created" progress record
EXECUTE sp_set_encounter_progress
	@ps_cpr_id = @ps_cpr_id,
	@pl_encounter_id = @ll_encounter_id,
	@ps_progress_type = 'Created',
	@ps_user_id = @ps_created_by,
	@ps_created_by = @ps_created_by

-- Order the encounter workplan
EXECUTE sp_Order_Encounter_Workplan  
	@ps_cpr_id = @ps_cpr_id,   
	@pl_encounter_id = @ll_encounter_id,   
	@ps_ordered_by = @ps_created_by,
	@ps_created_by = @ps_created_by,
	@pl_patient_workplan_id = @ll_patient_workplan_id OUTPUT

-- See if the encounter should be in a room but is waiting on a room-type resolution
SELECT @ls_patient_location = patient_location,
		@ls_next_patient_location = next_patient_location
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @ll_encounter_id

IF @ls_patient_location IS NULL AND LEFT(@ls_next_patient_location, 1) = '$'
	BEGIN
	SELECT @ls_patient_location = MIN(room_id)
	FROM o_Rooms
	WHERE room_type = @ls_next_patient_location
	AND status = 'OK'
	AND office_id = @ps_office_id
	
	IF @ls_patient_location IS NOT NULL
		BEGIN
		EXECUTE sp_set_encounter_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'patient_location',
			@ps_progress = @ls_patient_location,
			@ps_user_id = @ps_created_by,
			@ps_created_by = @ps_created_by
		
		EXECUTE sp_set_encounter_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'next_patient_location',
			@ps_progress = NULL,
			@ps_user_id = @ps_created_by,
			@ps_created_by = @ps_created_by
		END


	END



RETURN @ll_encounter_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_checkin]
	TO [cprsystem]
GO

