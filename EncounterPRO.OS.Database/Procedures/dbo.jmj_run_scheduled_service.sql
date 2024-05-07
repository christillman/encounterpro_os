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

-- Drop Procedure [dbo].[jmj_run_scheduled_service]
Print 'Drop Procedure [dbo].[jmj_run_scheduled_service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_run_scheduled_service]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_run_scheduled_service]
GO

-- Create Procedure [dbo].[jmj_run_scheduled_service]
Print 'Create Procedure [dbo].[jmj_run_scheduled_service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_run_scheduled_service
(
	@pl_service_sequence int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24)
)
AS

-- This procedure dispatches the specified scheduled service

SET NOCOUNT ON

DECLARE @ll_patient_workplan_item_id int,
		@ll_error int,
		@ll_rowcount int

IF @pl_service_sequence IS NULL
	BEGIN
	RAISERROR ('Null Scheduled Service',16,-1)
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	item_number,
	item_type,
	ordered_service,
	in_office_flag,
	auto_perform_flag,
	description,
	ordered_by,
	ordered_for,
	created_by)
SELECT 0,
	-1,  -- Scheduled Service
	service_sequence,
	'Service',
	[service],
	'N',
	'N',
	description,
	@ps_ordered_by,
	[user_id],
	@ps_created_by
FROM o_Service_Schedule
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_rowcount <> 1
	BEGIN
	ROLLBACK TRANSACTION
	RAISERROR ('Scheduled Service not found (%d)',16,-1, @pl_service_sequence)
	RETURN -1
	END

SELECT @ll_patient_workplan_item_id = @@identity


-- Transfer the attributes
INSERT INTO p_Patient_WP_Item_Attribute
(	 patient_workplan_id
	,patient_workplan_item_id
	,attribute
	,value_short
	,message
	,created_by
)
SELECT		
	 0
	,@ll_patient_workplan_item_id
	,attribute
	,CASE WHEN len(value) <= 50 THEN CAST(value AS varchar(50)) ELSE NULL END
	,CASE WHEN len(value) > 50 THEN value ELSE NULL END
	,@ps_created_by
FROM dbo.o_Service_Schedule_Attribute
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Dispatch workplan item
INSERT INTO p_Patient_WP_Item_Progress (
	patient_workplan_id,
	patient_workplan_item_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
VALUES (
	0,
	@ll_patient_workplan_item_id,
	@ps_ordered_by,
	dbo.get_client_datetime(),
	'DISPATCHED',
	@ps_created_by)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE o_Service_Schedule
SET last_service_date = dbo.get_client_datetime(),
	last_service_status = 'Ordered'
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION


GO
GRANT EXECUTE
	ON [dbo].[jmj_run_scheduled_service]
	TO [cprsystem]
GO

