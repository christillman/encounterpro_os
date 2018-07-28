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

-- Drop Procedure [dbo].[jmj_patient_pending_followups]
Print 'Drop Procedure [dbo].[jmj_patient_pending_followups]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_pending_followups]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_pending_followups]
GO

-- Create Procedure [dbo].[jmj_patient_pending_followups]
Print 'Create Procedure [dbo].[jmj_patient_pending_followups]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
-- This procedure returns the treatments which represent the pending followups for the
-- specified patient.

CREATE PROCEDURE jmj_patient_pending_followups (
	@ps_cpr_id varchar(12))
AS

DECLARE @followups TABLE (
	cpr_id varchar(12) NOT NULL ,
	treatment_id int NOT NULL ,
	begin_date datetime NULL ,
	treatment_description varchar(80) NULL ,
	duration_amount real NULL ,
	duration_unit varchar(24) NULL ,
	duration_prn varchar(32) NULL ,
	treatment_goal varchar(80) NULL ,
	ordered_for varchar(24) NULL ,
	appointment_date_time datetime NULL,
	encounter_type varchar(24) NULL,
	followup_date datetime NULL,
	selected_flag int NOT NULL DEFAULT (0))

DECLARE @ldt_follwup_cutoff datetime,
		@ls_followup_check_date_range varchar(255),
		@ls_amount varchar(255),
		@ls_unit varchar(255),
		@ll_count int,
		@ll_amount int,
		@ldt_today datetime,
		@ll_space int

INSERT INTO @followups (
	cpr_id ,
	treatment_id ,
	begin_date ,
	treatment_description ,
	duration_amount ,
	duration_unit ,
	duration_prn ,
	treatment_goal ,
	ordered_for ,
	appointment_date_time,
	followup_date )
SELECT t.cpr_id ,
	t.treatment_id ,
	t.begin_date ,
	t.treatment_description ,
	t.duration_amount ,
	t.duration_unit ,
	t.duration_prn ,
	t.treatment_goal ,
	t.ordered_for ,
	t.appointment_date_time ,
	t.appointment_date_time
FROM p_Treatment_Item t
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_type = 'FOLLOWUP'
AND t.open_flag = 'Y'

-- Set the default cutoff
SET @ldt_today = dbo.fn_date_truncate(getdate(), 'Day')

SET @ldt_follwup_cutoff = NULL

SET @ls_followup_check_date_range = dbo.fn_get_preference('WORKFLOW', 'followup_check_date_range', DEFAULT, DEFAULT)

IF @ls_followup_check_date_range IS NOT NULL
	BEGIN
	SET @ll_space = CHARINDEX(' ', @ls_followup_check_date_range) 
	IF @ll_space > 1
		BEGIN
		SET @ls_amount = LEFT(@ls_followup_check_date_range, @ll_space - 1)
		SET @ls_unit = SUBSTRING(@ls_followup_check_date_range, @ll_space + 1, LEN(@ls_followup_check_date_range) - @ll_space)
		IF ISNUMERIC(@ls_amount) = 1 AND LEN(@ls_unit) > 1
			BEGIN
			SET @ll_amount = CAST(@ls_amount AS int)
			SET @ldt_follwup_cutoff = CASE @ls_unit
						WHEN 'YEAR' THEN dateadd(year, -@ll_amount, @ldt_today)
						WHEN 'MONTH' THEN dateadd(month, -@ll_amount, @ldt_today)
						WHEN 'WEEK' THEN dateadd(week, -@ll_amount, @ldt_today)
						WHEN 'DAY' THEN dateadd(day, -@ll_amount, @ldt_today) END
			END
		END
	END

IF @ldt_follwup_cutoff IS NULL
	SET @ldt_follwup_cutoff = dateadd(day, -30, @ldt_today)

UPDATE @followups
SET followup_date = CASE duration_unit
			WHEN 'YEAR' THEN dateadd(year, duration_amount, begin_date)
			WHEN 'MONTH' THEN dateadd(month, duration_amount, begin_date)
			WHEN 'WEEK' THEN dateadd(week, duration_amount, begin_date)
			WHEN 'DAY' THEN dateadd(day, duration_amount, begin_date)
			END
WHERE followup_date IS NULL

UPDATE @followups
SET followup_date = begin_date
WHERE followup_date IS NULL

DELETE @followups
WHERE followup_date < @ldt_follwup_cutoff

-- Delete any followup that has a followup workplan that has already been dispatched
DELETE x
FROM @followups x
	INNER JOIN p_Patient_WP w
	ON x.cpr_id = w.cpr_id
	AND x.treatment_id = w.treatment_id
WHERE w.workplan_type = 'Followup'
AND w.context_object = 'Treatment'
AND w.status <> 'pending'

UPDATE x
SET encounter_type = p.progress_value
FROM @followups x
	INNER JOIN p_Treatment_Progress p
	ON x.cpr_id = p.cpr_id
	AND x.treatment_id = p.treatment_id
WHERE p.progress_type = 'PROPERTY'
AND p.progress_key = 'encounter_type'
AND p.current_flag = 'Y'

SELECT 	cpr_id,
	treatment_id ,
	begin_date ,
	treatment_description ,
	duration_amount ,
	duration_unit ,
	duration_prn ,
	treatment_goal ,
	ordered_for ,
	appointment_date_time ,
	encounter_type ,
	followup_date ,
	selected_flag
FROM @followups
GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_pending_followups]
	TO [cprsystem]
GO

