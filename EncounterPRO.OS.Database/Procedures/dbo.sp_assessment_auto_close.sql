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

-- Drop Procedure [dbo].[sp_assessment_auto_close]
Print 'Drop Procedure [dbo].[sp_assessment_auto_close]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_auto_close]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_auto_close]
GO

-- Create Procedure [dbo].[sp_assessment_auto_close]
Print 'Create Procedure [dbo].[sp_assessment_auto_close]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_assessment_auto_close (
		@ps_user_id varchar(24) = NULL,
		@ps_created_by varchar(24)  = NULL)	
AS

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int,
		@ll_open_encounter_id int,
		@li_diagnosis_sequence integer,
		@ldt_end_date datetime

DECLARE @close_candidates TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	diagnosis_sequence smallint NOT NULL,
	open_encounter_id int NULL,
	begin_date datetime NULL,
	auto_close_interval_amount smallint NULL,
	auto_close_interval_unit varchar(24) NULL,
	last_touch_date datetime NULL,
	expected_end_date datetime NULL )

IF @ps_user_id IS NULL
	SET @ps_user_id = '#SYSTEM'

IF @ps_created_by IS NULL
	SET @ps_user_id = '#SYSTEM'

-- First, construct a table of the open diagnoses with auto-close intervals specified
INSERT INTO @close_candidates (
	cpr_id,
	problem_id,
	diagnosis_sequence,
	open_encounter_id,
	begin_date,
	auto_close_interval_amount,
	auto_close_interval_unit,
	last_touch_date )
SELECT a.cpr_id,
	a.problem_id,
	a.diagnosis_sequence,
	a.open_encounter_id,
	a.begin_date,
	d.auto_close_interval_amount,
	d.auto_close_interval_unit,
	a.begin_date
FROM p_Assessment a WITH (NOLOCK)
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
WHERE d.auto_close = 'D'
AND d.auto_close_interval_amount IS NOT NULL
AND d.auto_close_interval_unit IS NOT NULL
AND a.assessment_status IS NULL

-- Set the last touch date from the assessment progress notes
DECLARE @assessment_progress TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	progress_date_time datetime NOT NULL)

INSERT INTO @assessment_progress (
	cpr_id ,
	problem_id ,
	progress_date_time )
SELECT ap.cpr_id ,
	ap.problem_id ,
	max(ap.progress_date_time) as progress_date_time
FROM @close_candidates cc
	INNER JOIN p_Assessment_Progress ap WITH (NOLOCK)
	ON cc.cpr_id = ap.cpr_id
	AND cc.problem_id = ap.problem_id
GROUP BY ap.cpr_id ,
	ap.problem_id

UPDATE cc
SET last_touch_date = CASE WHEN ap.progress_date_time > cc.last_touch_date THEN ap.progress_date_time ELSE cc.last_touch_date END
FROM @close_candidates cc
	INNER JOIN @assessment_progress ap
	ON cc.cpr_id = ap.cpr_id
	AND cc.problem_id = ap.problem_id
	

-- Set the last touch date from the treatments
DECLARE @treatment TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	begin_date datetime NOT NULL)

INSERT INTO @treatment (
	cpr_id ,
	problem_id ,
	begin_date )
SELECT pat.cpr_id ,
	pat.problem_id ,
	max(t.begin_date) as begin_date
FROM @close_candidates cc
	INNER JOIN p_Assessment_Treatment pat WITH (NOLOCK)
	ON cc.cpr_id = pat.cpr_id
	AND cc.problem_id = pat.problem_id
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON pat.cpr_id = t.cpr_id
	AND pat.treatment_id = t.treatment_id
GROUP BY pat.cpr_id ,
	pat.problem_id

UPDATE cc
SET last_touch_date = CASE WHEN t.begin_date > cc.last_touch_date THEN t.begin_date ELSE cc.last_touch_date END
FROM @close_candidates cc
	INNER JOIN @treatment t
	ON cc.cpr_id = t.cpr_id
	AND cc.problem_id = t.problem_id

-- Update the expected_end_date
UPDATE @close_candidates
SET expected_end_date = CASE auto_close_interval_unit
							WHEN 'YEAR' THEN dateadd(year, auto_close_interval_amount, last_touch_date)
							WHEN 'MONTH' THEN dateadd(month, auto_close_interval_amount, last_touch_date)
							WHEN 'DAY' THEN dateadd(day, auto_close_interval_amount, last_touch_date)
							END

-- Then close the assessments where the expected_end_date has arrived
DECLARE lc_assessment CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT
		cpr_id,
		problem_id,
		open_encounter_id,
		diagnosis_sequence,
		expected_end_date
	FROM @close_candidates
	WHERE dbo.get_client_datetime() >= expected_end_date
	UNION
	SELECT
		 p.cpr_id
		,p.problem_id
		,p.open_encounter_id
		,p.diagnosis_sequence
		,e.discharge_date
	from p_assessment p WITH (NOLOCK)
	inner join c_assessment_definition a WITH (NOLOCK)
	on p.assessment_id = a.assessment_id
	inner join p_patient_encounter e WITH (NOLOCK)
	on p.cpr_id = e.cpr_id
	and p.open_encounter_id = e.encounter_id
	where p.assessment_status is null
	and a.auto_close = 'Y'
	and e.encounter_status = 'CLOSED'
	

OPEN lc_assessment

FETCH lc_assessment INTO @ls_cpr_id,
						@ll_problem_id,
						@ll_open_encounter_id,
						@li_diagnosis_sequence,
						@ldt_end_date

WHILE @@FETCH_STATUS = 0
	BEGIN
	
	EXECUTE sp_set_assessment_progress
		@ps_cpr_id = @ls_cpr_id,
		@pl_problem_id = @ll_problem_id,
		@pl_encounter_id = @ll_open_encounter_id,
		@pdt_progress_date_time = @ldt_end_date,
		@pi_diagnosis_sequence = @li_diagnosis_sequence,
		@ps_progress_type = 'Closed',
		@ps_progress_key = 'Closed',
		@ps_progress = 'Auto Closed',
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	FETCH lc_assessment INTO @ls_cpr_id,
							@ll_problem_id,
							@ll_open_encounter_id,
							@li_diagnosis_sequence,
							@ldt_end_date
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_auto_close]
	TO [cprsystem]
GO

