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

-- Drop Procedure [dbo].[sp_maintenance_expire_services]
Print 'Drop Procedure [dbo].[sp_maintenance_expire_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_maintenance_expire_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_maintenance_expire_services]
GO

-- Create Procedure [dbo].[sp_maintenance_expire_services]
Print 'Create Procedure [dbo].[sp_maintenance_expire_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_maintenance_expire_services (
	@ps_user_id varchar(24) = '#SYSTEM',
	@ps_created_by varchar(24) = '#SYSTEM' )
AS

-- First make sure the expiration date is set
UPDATE i
SET expiration_date = CASE s.default_expiration_unit_id
							WHEN 'Year' THEN dateadd(Year, s.default_expiration_time, i.dispatch_date)
							WHEN 'Month' THEN dateadd(Month, s.default_expiration_time, i.dispatch_date)
							WHEN 'Day' THEN dateadd(Day, s.default_expiration_time, i.dispatch_date)
							WHEN 'Hour' THEN dateadd(Hour, s.default_expiration_time, i.dispatch_date)
							WHEN 'Minute' THEN dateadd(Minute, s.default_expiration_time, i.dispatch_date)
							WHEN 'Second' THEN dateadd(Second, s.default_expiration_time, i.dispatch_date)
							END
FROM p_Patient_WP_Item i
	INNER JOIN o_Service s
	ON i.ordered_service = s.service
	AND i.item_type = 'Service'
WHERE i.active_service_flag = 'Y'
AND i.expiration_date IS NULL
AND s.default_expiration_time > 0
AND s.default_expiration_unit_id IN ('Year', 'Month', 'Day', 'Hour', 'Minute', 'Second')


-- Then expire all the services which are past their expiration date
INSERT INTO p_Patient_WP_Item_Progress (
            patient_workplan_id,
            patient_workplan_item_id,
            cpr_id,
            encounter_id,
            [user_id],
            progress_date_time,
            progress_type,
            created,
            created_by )
SELECT i.patient_workplan_id,
            i.patient_workplan_item_id,
            i.cpr_id,
            i.encounter_id,
            @ps_user_id,
            dbo.get_client_datetime(),
            'Expired',
            dbo.get_client_datetime(),
            @ps_created_by
FROM p_Patient_WP_Item i
WHERE i.active_service_flag = 'Y'
AND expiration_date IS NOT NULL
AND expiration_date < dbo.get_client_datetime()

GO
GRANT EXECUTE
	ON [dbo].[sp_maintenance_expire_services]
	TO [cprsystem]
GO

