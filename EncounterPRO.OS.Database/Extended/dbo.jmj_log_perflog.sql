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

-- Drop Procedure [dbo].[jmj_log_perflog]
Print 'Drop Procedure [dbo].[jmj_log_perflog]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_log_perflog]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_log_perflog]
GO

-- Create Procedure [dbo].[jmj_log_perflog]
Print 'Create Procedure [dbo].[jmj_log_perflog]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_log_perflog (
	@ps_user_id varchar(24),
	@pl_computer_id int = NULL)
AS

DECLARE @ldt_last_updated datetime,
		@ll_count int,
		@ldt_current_datetime datetime

SET NOCOUNT ON

SET @ldt_current_datetime = dbo.get_client_datetime()

SELECT @ldt_last_updated = last_updated 
FROM c_Table_Update
WHERE table_name = 'Perflog DB Stats'

IF @ldt_last_updated > DATEADD(minute, -10, @ldt_current_datetime)
	RETURN 0

DECLARE @encounters TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	encounter_date datetime NOT NULL,
	open_class varchar(24) NULL )

INSERT INTO @encounters (
	cpr_id ,
	encounter_id ,
	encounter_date ,
	open_class)
SELECT cpr_id ,
	encounter_id ,
	encounter_date ,
	open_class = CASE WHEN encounter_date > DATEADD(hour, -2, @ldt_current_datetime) THEN 'Active' ELSE 'Delayed' END
FROM p_Patient_Encounter
WHERE encounter_status = 'OPEN'

UPDATE @encounters
SET open_class = 'Hold'
WHERE encounter_date < DATEADD(hour, -12, @ldt_current_datetime)

IF @pl_computer_id IS NULL
	SELECT @pl_computer_id = max(computer_id)
	FROM o_Server_Component
	WHERE component_id = 'JMJ_SERVERSERVICE'
	AND system_user_id = @ps_user_id

IF @pl_computer_id IS NULL
	SET @pl_computer_id = 0

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Active'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Active',
	@pd_value = @ll_count

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Delayed'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Delayed',
	@pd_value = @ll_count

SELECT @ll_count = count(*)
FROM @encounters
WHERE open_class = 'Hold'

EXECUTE jmj_log_performance
	@pl_computer_id = @pl_computer_id,
	@pl_patient_workplan_item_id = NULL,
	@ps_user_id = @ps_user_id,
	@ps_metric = 'Open Encounters Hold',
	@pd_value = @ll_count


-- Finally, update the perflog time
EXECUTE sp_table_update
	@ps_table_name = 'Perflog DB Stats',
	@ps_updated_by = @ps_user_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_log_perflog]
	TO [cprsystem]
GO

