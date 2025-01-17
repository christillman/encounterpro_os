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

-- Drop Procedure [dbo].[jmjrpt_patient_todo_outstanding]
Print 'Drop Procedure [dbo].[jmjrpt_patient_todo_outstanding]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_todo_outstanding]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_todo_outstanding]
GO

-- Create Procedure [dbo].[jmjrpt_patient_todo_outstanding]
Print 'Create Procedure [dbo].[jmjrpt_patient_todo_outstanding]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_patient_todo_outstanding
AS
SELECT
             p.first_name
            ,p.last_name
            ,uob.user_short_name as sender
            ,COALESCE(uof.user_short_name, r.role_name) as recipient
            ,i.dispatch_date
            ,i.description as TODO
            ,a.value
            ,DATEDIFF( hour, i.dispatch_date, dbo.get_client_datetime() ) - 24 AS Hours_Late
FROM
            p_patient_WP_Item I  WITH (NOLOCK)
INNER JOIN P_patient p WITH (NOLOCK) ON  
            p.cpr_id = i.cpr_id
INNER JOIN c_user  uob  WITH (NOLOCK) ON
            uob.user_id = i.ordered_by
LEFT OUTER JOIN c_user  uof  WITH (NOLOCK) ON
            i.ordered_for = uof.user_id
LEFT OUTER JOIN c_role r WITH (NOLOCK) 
ON i.ordered_for = r.role_id
LEFT OUTER JOIN p_patient_WP_Item_Attribute a  WITH (NOLOCK) ON
            i.patient_workplan_item_id = a.patient_workplan_item_id
WHERE
            i.cpr_id IS NOT NULL
AND     i.ordered_service = 'TODO'
AND     i.active_service_flag = 'Y'
AND     i.dispatch_date IS NOT NULL
AND     a.attribute = 'message'
AND     DATEDIFF( hour, i.dispatch_date, dbo.get_client_datetime() ) >= 
       24*(1 + CHARINDEX ( CAST(DATEPART( weekday, i.dispatch_date)AS VARCHAR (1) ), '76' ) )
ORDER BY
             Hours_Late DESC

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_todo_outstanding]
	TO [cprsystem]
GO

