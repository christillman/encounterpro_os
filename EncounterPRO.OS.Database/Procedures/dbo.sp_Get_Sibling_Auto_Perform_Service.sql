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

-- Drop Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Sibling_Auto_Perform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Sibling_Auto_Perform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]
Print 'Create Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE sp_Get_Sibling_Auto_Perform_Service
	 @pl_patient_workplan_item_id int
	,@ps_user_id varchar(24)
	,@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE	 @ls_in_office_flag char(1)
	,@li_count smallint
	,@ll_patient_workplan_id int
	,@ll_patient_workplan_item_id int
	,@ls_item_type varchar(12)
	,@rows INT

SET @pl_next_patient_workplan_item_id = NULL

SELECT	@ls_in_office_flag = in_office_flag,
		@ll_patient_workplan_id = patient_workplan_id
FROM 	p_Patient_WP_Item WITH (NOLOCK)
WHERE 	patient_workplan_item_id = @pl_patient_workplan_item_id

SET @rows = @@ROWCOUNT

IF @rows <> 1
	RETURN

-- If this is the "default" workplan, then don't check
IF @ll_patient_workplan_id = 0
	RETURN

DECLARE lc_siblings CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT
		 i2.patient_workplan_item_id
		,i2.item_type
	FROM	p_Patient_WP_Item i2 WITH (NOLOCK)
	LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON 	i2.owned_by = r.role_id
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON 	i2.patient_workplan_item_id = l.patient_workplan_item_id 
	WHERE i2.patient_workplan_id = @ll_patient_workplan_id
	AND 	i2.patient_workplan_item_id <> @pl_patient_workplan_item_id
	AND 	i2.auto_perform_flag = 'Y'
	AND 	i2.in_office_flag = @ls_in_office_flag
	AND 	i2.status IN ('DISPATCHED', 'STARTED')
	AND 	l.patient_workplan_item_id IS NULL
	AND
	(	   i2.owned_by IS NULL
		OR i2.owned_by = @ps_user_id
		OR r.user_id = @ps_user_id
	)
	ORDER BY i2.patient_workplan_item_id

OPEN lc_siblings

FETCH lc_siblings INTO 
	 @ll_patient_workplan_item_id
	,@ls_item_type

WHILE @@FETCH_STATUS = 0
BEGIN

	-- If the sibling is an auto perform service, then we're done
	IF @ls_item_type = 'Service'
	BEGIN
		SET @pl_next_patient_workplan_item_id = @ll_patient_workplan_item_id
		RETURN
	END

	-- If the item wasn't a service, then check it's children for auto-perform services
	EXECUTE sp_Get_Child_Auto_Perform_Service
		 @pl_patient_workplan_item_id = @ll_patient_workplan_item_id
		,@ps_user_id = @ps_user_id
		,@pl_next_patient_workplan_item_id = @pl_next_patient_workplan_item_id OUTPUT

	IF @pl_next_patient_workplan_item_id IS NOT NULL
		RETURN
	
	-- If we still haven't found one, then get the next sibling
	FETCH lc_siblings INTO 
		 @ll_patient_workplan_item_id
		,@ls_item_type
END

CLOSE lc_siblings
DEALLOCATE lc_siblings


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Sibling_Auto_Perform_Service]
	TO [cprsystem]
GO

