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

-- Drop Procedure [dbo].[sp_cancel_in_office_services]
Print 'Drop Procedure [dbo].[sp_cancel_in_office_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_cancel_in_office_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_cancel_in_office_services]
GO

-- Create Procedure [dbo].[sp_cancel_in_office_services]
Print 'Create Procedure [dbo].[sp_cancel_in_office_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_cancel_in_office_services
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24)
	) 

AS

DECLARE @ll_patient_workplan_item_id int,
		@ls_wp_item_status varchar(12),
		@ldt_progress_date_time datetime


-- First convert the in-office workplan to an out-of-office workplan
UPDATE p_Patient_WP
SET in_office_flag = 'N'
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND in_office_flag = 'Y'
AND (status <> 'Pending' OR workplan_type NOT IN ('Followup', 'Referral'))

-- Then convert the in-office messages to out-of-office messages
UPDATE i
SET in_office_flag = 'N'
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP wp
	ON i.patient_workplan_id = wp.patient_workplan_id
WHERE i.cpr_id = @ps_cpr_id
AND i.encounter_id = @pl_encounter_id
AND i.active_service_flag = 'Y'
AND i.in_office_flag = 'Y'
AND i.item_type = 'Service'
AND i.ordered_service = 'MESSAGE'
AND (wp.status <> 'Pending' OR wp.workplan_type NOT IN ('Followup', 'Referral'))

SET @ldt_progress_date_time = getdate()
SET @ls_wp_item_status = 'Cancelled'

-- Close/Cancel all the workplan items which are still pending
INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	i.encounter_id,
	@ps_ordered_by,
	@ldt_progress_date_time,
	@ls_wp_item_status,
	@ps_created_by
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP wp
	ON i.patient_workplan_id = wp.patient_workplan_id
WHERE i.cpr_id = @ps_cpr_id
AND i.encounter_id = @pl_encounter_id
AND (i.status NOT IN('COMPLETED', 'CANCELLED', 'Skipped') OR i.status IS NULL)
AND i.in_office_flag = 'Y'
AND (wp.status <> 'Pending' OR wp.workplan_type NOT IN ('Followup', 'Referral'))



GO
GRANT EXECUTE
	ON [dbo].[sp_cancel_in_office_services]
	TO [cprsystem]
GO

