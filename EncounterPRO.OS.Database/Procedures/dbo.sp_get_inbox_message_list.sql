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

-- Drop Procedure [dbo].[sp_get_inbox_message_list]
Print 'Drop Procedure [dbo].[sp_get_inbox_message_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_inbox_message_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_inbox_message_list]
GO

-- Create Procedure [dbo].[sp_get_inbox_message_list]
Print 'Create Procedure [dbo].[sp_get_inbox_message_list]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_inbox_message_list (
	@ps_user_id varchar(24) )
AS
SELECT i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.button as service_button,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.folder,
	u.user_short_name as from_user,
	u.color as from_user_color,
	a.message,
	i.cpr_id,
	COALESCE(p.first_name + ' ', '') + COALESCE(p.last_name, '') as patient_name,
	selected_flag=0
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_by = u.user_id
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a WITH (NOLOCK)
	ON i.patient_workplan_item_id = a.patient_workplan_item_id
	LEFT OUTER JOIN p_Patient p WITH (NOLOCK)
	ON i.cpr_id = p.cpr_id
WHERE i.ordered_for = @ps_user_id
AND i.active_service_flag = 'Y'
AND i.ordered_service = 'MESSAGE'
AND a.attribute = 'MESSAGE'

GO
GRANT EXECUTE
	ON [dbo].[sp_get_inbox_message_list]
	TO [cprsystem]
GO

