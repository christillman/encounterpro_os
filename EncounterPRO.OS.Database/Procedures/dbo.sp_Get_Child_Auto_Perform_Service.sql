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

-- Drop Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Child_Auto_Perform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Child_Auto_Perform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]
Print 'Create Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE sp_Get_Child_Auto_Perform_Service
	 @pl_patient_workplan_item_id int
	,@ps_user_id varchar(24)
	,@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE  @ls_in_office_flag char(1)
	,@li_iteration smallint
	,@li_more_records smallint
	,@ls_cpr_id varchar(12)
	,@ll_encounter_id int
	,@rows int
	,@ll_patient_workplan_id int

DECLARE @tmp_items TABLE  -- Altered to use table variable instead of temp table
(
	 patient_workplan_item_id int NOT NULL
	,in_office_flag CHAR(1)
	,item_type VARCHAR(12)
	,auto_perform_flag CHAR (1)
	,owned_by_item VARCHAR (24)
	,owned_by_role VARCHAR (24)
	,patient_workplan_item_id_lock INT
	,status VARCHAR (12)
	,iteration smallint DEFAULT (0)
)

SELECT	 @ls_in_office_flag = in_office_flag
	,@ls_cpr_id = cpr_id
	,@ll_encounter_id = encounter_id
	,@ll_patient_workplan_id = patient_workplan_id
FROM 	p_Patient_WP_Item WITH (NOLOCK)
WHERE	patient_workplan_item_id = @pl_patient_workplan_item_id

SET @rows = @@ROWCOUNT

IF @@ROWCOUNT <> 1
	RETURN

-- If the associated encounter is open then look for in office items even if this service is not-in-office
-- Changed "IF" to only execute query if @ls_in_office_flag <> 'Y'

IF @ls_in_office_flag <> 'Y'
BEGIN
	SELECT 
		 @ls_in_office_flag = 'Y'
	FROM 	p_Patient_encounter WITH (NOLOCK)
	WHERE	cpr_id = @ls_cpr_id
	AND	encounter_id = @ll_encounter_id
	AND	encounter_status = 'OPEN'
END

INSERT INTO @tmp_items 
(
	 patient_workplan_item_id
	,in_office_flag
)
VALUES
(
	 @pl_patient_workplan_item_id
	,@ls_in_office_flag
)

/* Modify looping to increment an iteration variable instead of executing a "processed" UPDATE
and DELETE during each loop
*/

SET @li_more_records = 1
SET @li_iteration = 0
SET @pl_next_patient_workplan_item_id = NULL

WHILE @li_more_records = 1
BEGIN
	SET @li_iteration = @li_iteration + 1

/*  Using outer join to pull back additional fields.  This allows the subsequent select to avoid
using any joins including a NOT EXISTS and a SELECT subquery.  
*/

	INSERT INTO @tmp_items 
	(	 patient_workplan_item_id
		,in_office_flag
		,item_type
		,auto_perform_flag
		,owned_by_item
		,owned_by_role
		,patient_workplan_item_id_lock
		,status
		,iteration
	)
	SELECT	 i.patient_workplan_item_id
		,i.in_office_flag	
		,i.item_type
		,i.auto_perform_flag	
		,i.owned_by
		,r.user_id
		,l.patient_workplan_item_id
		,i.status
		,@li_iteration
	FROM 	@tmp_items x
	INNER JOIN p_Patient_WP w WITH (NOLOCK)
	ON	w.parent_patient_workplan_item_id = x.patient_workplan_item_id
	INNER JOIN p_Patient_WP_item i WITH (NOLOCK)
	ON	i.patient_workplan_id = w.patient_workplan_id
	AND	i.in_office_flag = w.in_office_flag
	LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON	i.owned_by = r.role_id
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON	i.patient_workplan_item_id = l.patient_workplan_item_id 
	WHERE	x.iteration = @li_iteration - 1
	AND 	w.in_office_flag = @ls_in_office_flag
	AND 	i.in_office_flag = @ls_in_office_flag
	AND 	i.status IN ('DISPATCHED', 'STARTED')

	SET @rows = @@rowcount

	IF @rows > 0  -- Candidates exist - else skip query
	BEGIN

		SELECT 
			 @pl_next_patient_workplan_item_id = min(patient_workplan_item_id)
		FROM 	@tmp_items
		WHERE   item_type = 'Service'
		AND 	status IN ('DISPATCHED', 'STARTED')
		AND 	auto_perform_flag = 'Y'
		AND 	patient_workplan_item_id_lock IS NULL
		AND 	iteration = @li_iteration
		AND
		(	   owned_by_item IS NULL
			OR owned_by_item = @ps_user_id
			OR owned_by_role = @ps_user_id
		)
		
		IF @pl_next_patient_workplan_item_id IS NOT NULL
			SET @li_more_records = 0 -- End while and return value
	END
	ELSE  -- no Candiate records - Return
		SET @li_more_records = 0
END


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Child_Auto_Perform_Service]
	TO [cprsystem]
GO

