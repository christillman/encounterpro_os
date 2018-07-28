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

-- Drop Procedure [dbo].[sp_get_posting_errors]
Print 'Drop Procedure [dbo].[sp_get_posting_errors]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_posting_errors]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_posting_errors]
GO

-- Create Procedure [dbo].[sp_get_posting_errors]
Print 'Create Procedure [dbo].[sp_get_posting_errors]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_posting_errors (
	@pdt_date datetime
)
AS

DECLARE	 @ldt_today datetime
	,@ldt_tomorrow datetime

SET @ldt_today = convert(datetime, convert(varchar,@pdt_date, 112))

SET @ldt_tomorrow = DATEADD(day, 1, @ldt_today)

DECLARE @failure_reasons TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	encounter_description varchar(80) NOT NULL,
	date_time varchar(12) NOT NULL ,
	[reason] [varchar] (1024) NULL
	)


INSERT INTO @failure_reasons
	(
	cpr_id,
	encounter_id,
	encounter_description,
	date_time,
	reason
	)
SELECT DISTINCT
	p_Patient_Encounter.cpr_id
	,p_Patient_Encounter.encounter_id
	,COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description) as encounter_description
	,convert(varchar(12),log_date_time,1)
	,caller + ',' + message
FROM p_Patient_Encounter WITH (NOLOCK, INDEX( idx_encounter_date ) )
INNER JOIN o_Log WITH (NOLOCK)
ON	p_Patient_Encounter.cpr_id = o_Log.cpr_id
AND	p_Patient_Encounter.encounter_id = o_Log.encounter_id
AND     o_Log.user_id in ('#BILL','#TRANOUT')
INNER JOIN c_Encounter_Type WITH (NOLOCK)
ON	p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
WHERE  p_Patient_Encounter.billing_posted = 'E'
AND p_Patient_Encounter.encounter_date >= @ldt_today
AND p_Patient_Encounter.encounter_date < @ldt_tomorrow


INSERT INTO @failure_reasons
	(
	cpr_id,
	encounter_id,
	encounter_description,
	date_time,
	reason
	)
SELECT DISTINCT
	p_Patient_Encounter.cpr_id
	,p_Patient_Encounter.encounter_id
	,COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description) as encounter_description
	,convert(varchar(12),message_date_time,1)
	,COALESCE(o_message_log.comments,'Reason not received') as reason
FROM p_Patient_Encounter WITH (NOLOCK, INDEX( idx_encounter_date ) )
INNER JOIN o_Message_Log WITH (NOLOCK)
ON	p_Patient_Encounter.cpr_id = o_Message_Log.cpr_id
AND	p_Patient_Encounter.encounter_id = o_Message_Log.encounter_id
AND     o_Message_Log.direction = 'O' AND o_message_log.status = 'ACK_REJECT'
INNER JOIN c_Encounter_Type WITH (NOLOCK)
ON	p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
WHERE  p_Patient_Encounter.billing_posted = 'E'
AND p_Patient_Encounter.encounter_date >= @ldt_today
AND p_Patient_Encounter.encounter_date < @ldt_tomorrow

SELECT DISTINCT
	e.cpr_id,
	e.encounter_id,
	billing_id,
	first_name,
	last_name,
	date_of_birth,
	encounter_description,
	date_time,
	reason
FROM @failure_reasons e
INNER JOIN p_Patient WITH (NOLOCK)
ON e.cpr_id = p_patient.cpr_id


GO
GRANT EXECUTE
	ON [dbo].[sp_get_posting_errors]
	TO [cprsystem]
GO

