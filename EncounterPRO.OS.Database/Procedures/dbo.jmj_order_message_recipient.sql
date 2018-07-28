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

-- Drop Procedure [dbo].[jmj_order_message_recipient]
Print 'Drop Procedure [dbo].[jmj_order_message_recipient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_order_message_recipient]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_order_message_recipient]
GO

-- Create Procedure [dbo].[jmj_order_message_recipient]
Print 'Create Procedure [dbo].[jmj_order_message_recipient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_order_message_recipient
	(
	@pl_dispatched_patient_workplan_item_id int,
	@ps_ordered_for varchar(24) = NULL,
	@ps_created_by varchar(24),
	@pl_patient_workplan_item_id int OUTPUT ,
	@ps_dispatch_method varchar(24) = NULL
	)
AS

DECLARE @ls_in_office_flag char(1)

-- If the dispatch method was not passed in then pull the in_office_flag and dispatch_method from the parent message
IF @ps_dispatch_method IS NULL
	SET @ls_in_office_flag = NULL
ELSE IF @ps_dispatch_method = 'Office View'
	SET @ls_in_office_flag = 'Y'
ELSE
	SET @ls_in_office_flag = 'N'

-- Create the new service record
INSERT INTO p_Patient_WP_Item (
	cpr_id ,
	patient_workplan_id ,
	encounter_id ,
	workplan_id ,
	item_number,
	step_number,
	item_type ,
	ordered_service ,
	in_office_flag ,
	runtime_configured_flag ,
	description ,
	ordered_by,
	ordered_for ,
	priority,
	step_flag,
	auto_perform_flag,
	cancel_workplan_flag,
	dispatch_method,
	consolidate_flag,
	owner_flag,
	observation_tag,
	dispatched_patient_workplan_item_id,
	created_by ,
	created )
SELECT cpr_id ,
	patient_workplan_id  ,
	encounter_id ,
	workplan_id ,
	item_number,
	step_number,
	item_type ,
	ordered_service ,
	COALESCE(@ls_in_office_flag, in_office_flag ),
	runtime_configured_flag ,
	description ,
	ordered_by ,
	@ps_ordered_for ,
	priority,
	step_flag,
	auto_perform_flag,
	cancel_workplan_flag,
	COALESCE(@ps_dispatch_method, in_office_flag ),
	consolidate_flag,
	owner_flag,
	observation_tag,
	@pl_dispatched_patient_workplan_item_id,
	@ps_created_by ,
	created
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_dispatched_patient_workplan_item_id

SELECT @pl_patient_workplan_item_id = SCOPE_IDENTITY()

-- Transfer all the attributes except disposition and message
INSERT INTO p_Patient_WP_Item_Attribute (
	patient_workplan_id,
	patient_workplan_item_id,
	cpr_id,
	attribute,
	value_short,
	message,
	actor_id,
	created_by)
SELECT
	patient_workplan_id,
	@pl_patient_workplan_item_id ,
	cpr_id,
	attribute,
	value_short,
	message,
	actor_id,
	@ps_created_by
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_dispatched_patient_workplan_item_id

-- Dispatch the service
INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
SELECT
	cpr_id,
	patient_workplan_id,
	@pl_patient_workplan_item_id,
	encounter_id,
	COALESCE(ordered_by, @ps_created_by) ,
	getdate(),
	'DISPATCHED',
	@ps_created_by
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_order_message_recipient]
	TO [cprsystem]
GO

