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

-- Drop Trigger [dbo].[tr_p_observation_result_progress_insert]
Print 'Drop Trigger [dbo].[tr_p_observation_result_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_observation_result_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_observation_result_progress_insert]
GO

-- Create Trigger [dbo].[tr_p_observation_result_progress_insert]
Print 'Create Trigger [dbo].[tr_p_observation_result_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_observation_result_progress_insert ON dbo.p_Observation_Result_Progress
FOR INSERT
AS
IF @@ROWCOUNT = 0
	RETURN


DECLARE
	 @Highlight_flag SMALLINT
	,@Modify_flag SMALLINT


/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @Highlight_flag = SUM( CHARINDEX( 'Highlight', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
FROM inserted


IF @Modify_flag > 0
BEGIN
	UPDATE r
	SET abnormal_flag = CASE i.progress_key WHEN 'abnormal_flag' then CONVERT(varchar(1), i.progress_value) ELSE r.abnormal_flag END,
		abnormal_nature = CASE i.progress_key WHEN 'abnormal_nature' then CONVERT(varchar(8), i.progress_value) ELSE r.abnormal_nature END,
		severity = CASE i.progress_key WHEN 'severity' then CONVERT(smallint, i.progress_value) ELSE r.severity END,
		current_flag = CASE i.progress_key WHEN 'current_flag' then CONVERT(char(1), i.progress_value) ELSE r.current_flag END,
		normal_range = CASE i.progress_key WHEN 'normal_range' then CONVERT(varchar(40), i.progress_value) ELSE r.normal_range END
	FROM p_Observation_Result r
		INNER JOIN inserted i
		ON i.cpr_id = r.cpr_id
		AND i.observation_sequence = r.observation_sequence
		AND i.location_result_sequence = r.location_result_sequence
	WHERE i.progress_type = 'Modify'
END

-- Set the current_flag
UPDATE p1
SET current_flag = 'N'
FROM p_Observation_Result_Progress p1
	INNER JOIN inserted p2
	ON p1.cpr_id = p2.cpr_id
	AND p1.observation_sequence = p2.observation_sequence
	AND p1.location_result_sequence = p2.location_result_sequence
	AND p1.progress_type = p2.progress_type
	AND ISNULL(p1.progress_key, '!NULL') = ISNULL(p2.progress_key, '!NULL')
WHERE p1.result_progress_sequence < p2.result_progress_sequence

-- Set the treatment_id
UPDATE p
SET treatment_id = o.treatment_id
FROM p_Observation_Result_Progress p
	INNER JOIN inserted i
	ON p.cpr_id = i.cpr_id
	AND p.observation_sequence = i.observation_sequence
	AND p.location_result_sequence = i.location_result_sequence
	AND p.result_progress_sequence = i.result_progress_sequence
	INNER JOIN p_Observation o
	ON o.cpr_id = i.cpr_id
	AND o.observation_sequence = i.observation_sequence
WHERE p.treatment_id IS NULL

GO

