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

-- Drop Procedure [dbo].[sp_get_user_workplan_items]
Print 'Drop Procedure [dbo].[sp_get_user_workplan_items]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_user_workplan_items]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_user_workplan_items]
GO

-- Create Procedure [dbo].[sp_get_user_workplan_items]
Print 'Create Procedure [dbo].[sp_get_user_workplan_items]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_user_workplan_items
	@ps_user_id varchar(24),
	@ps_in_office_flag char(1) = '%',
	@pdt_not_started_since datetime = NULL
AS

-- If a not-started-since time is not specified, then
-- use "5 minutes ago" as a default
IF @pdt_not_started_since IS NULL
	BEGIN
	SET @pdt_not_started_since = DATEADD(minute, -5, getdate())
	END

SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	s.visible_flag,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.retries,
	selected_flag=0
FROM p_Patient_WP_Item i WITH (NOLOCK)
	, o_Service s WITH (NOLOCK)
WHERE i.owned_by = @ps_user_id
AND i.active_service_flag = 'Y'
AND i.ordered_service = s.service
AND i.in_office_flag LIKE @ps_in_office_flag
AND ((begin_date IS NULL) OR (begin_date < @pdt_not_started_since))

GO
GRANT EXECUTE
	ON [dbo].[sp_get_user_workplan_items]
	TO [cprsystem]
GO
