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

-- Drop Procedure [dbo].[jmjrpt_patient_todo]
Print 'Drop Procedure [dbo].[jmjrpt_patient_todo]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_todo]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_todo]
GO

-- Create Procedure [dbo].[jmjrpt_patient_todo]
Print 'Create Procedure [dbo].[jmjrpt_patient_todo]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_patient_todo
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10) 
AS
Declare @begin_date varchar(10), @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT
p.first_name 
,p.last_name
,uob.user_short_name as sender
,COALESCE( uof.user_short_name, r.role_name) as recipient
,uoc.user_short_name AS DoneBy
,i.dispatch_date ,i.status
,i.description
,a.value
,i.end_date 
FROM p_patient_WP_Item I  WITH (NOLOCK)
INNER JOIN P_patient p  WITH (NOLOCK)
ON i.cpr_id = p.cpr_id  
LEFT OUTER JOIN c_user  uob  WITH (NOLOCK)
ON i.ordered_by = uob.user_id 
LEFT OUTER JOIN c_user  uof  WITH (NOLOCK)
ON i.ordered_for = uof.user_id   
LEFT OUTER JOIN c_user uoc  WITH (NOLOCK)
ON i.completed_by = uoc.user_id  
LEFT OUTER JOIN c_Role r  WITH (NOLOCK)
ON i.ordered_for = r.role_id
LEFT OUTER JOIN p_patient_WP_Item_Attribute a  WITH (NOLOCK)
ON i.patient_workplan_item_id = a.patient_workplan_item_id  
WHERE
i.cpr_id IS NOT NULL  
AND     i.ordered_service = 'TODO'  
AND     i.dispatch_date IS NOT NULL  
AND     a.attribute = 'message'  
AND     i.dispatch_date >= @begin_date 
AND     i.dispatch_date <= @end_date   
ORDER BY               i.dispatch_date ASC

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_todo]
	TO [cprsystem]
GO

