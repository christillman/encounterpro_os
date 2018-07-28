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

-- Drop Procedure [dbo].[sp_default_exam_selection]
Print 'Drop Procedure [dbo].[sp_default_exam_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_default_exam_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_default_exam_selection]
GO

-- Create Procedure [dbo].[sp_default_exam_selection]
Print 'Create Procedure [dbo].[sp_default_exam_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_default_exam_selection (
	@ps_root_observation_id varchar(24),
	@ps_cpr_id varchar(12),
	@ps_treatment_type varchar(24),
	@ps_user_id varchar(24)
 )
AS

DECLARE @ls_sex char(1),
	@ls_race varchar(12),
	@ls_specialty_id varchar(24)

SELECT 	@ls_sex = sex, 
	@ls_race = race
FROM p_Patient WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id

DECLARE @tmp_patient_age_ranges TABLE
(	age_range_id INT
)

INSERT INTO @tmp_patient_age_ranges
(	age_range_id
)
SELECT DISTINCT age_range_id
FROM v_Patient_Age_Ranges WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id

SELECT @ls_specialty_id = COALESCE(specialty_id, '$')
FROM c_User WITH (NOLOCK)
WHERE user_id = @ps_user_id

DECLARE @tmp_exams TABLE
(	exam_sequence int NOT NULL,
	description varchar(40) NULL,
	sort_sequence smallint NULL,
	selected_flag smallint NULL DEFAULT (0),
	disabled_flag smallint NULL DEFAULT (0)
)

INSERT INTO @tmp_exams (
	exam_sequence,
	description,
	sort_sequence)
SELECT d.exam_sequence, 
	d.description, 
	min(s.sort_sequence) as sort_sequence
FROM	 u_Exam_Definition d WITH (NOLOCK)
	,u_Exam_Selection s WITH (NOLOCK)
WHERE d.root_observation_id = @ps_root_observation_id
AND d.exam_sequence = s.exam_sequence
AND s.treatment_type = @ps_treatment_type
AND s.user_id = @ps_user_id
AND (s.age_range_id IS NULL OR s.age_range_id IN (SELECT age_range_id FROM @tmp_patient_age_ranges))
AND (s.sex IS NULL OR @ls_sex IS NULL OR s.sex = @ls_sex)
AND (s.race IS NULL OR @ls_race IS NULL OR s.race = @ls_race)
GROUP BY d.exam_sequence, d.description

INSERT INTO @tmp_exams (
	exam_sequence,
	description,
	sort_sequence )
SELECT d.exam_sequence, 
	d.description, 
	1000 + min(s.sort_sequence) as sort_sequence
FROM	 u_Exam_Definition d WITH (NOLOCK)
	,u_Exam_Selection s WITH (NOLOCK)
WHERE d.root_observation_id = @ps_root_observation_id
AND d.exam_sequence = s.exam_sequence
AND s.treatment_type = @ps_treatment_type
AND s.user_id = @ls_specialty_id
AND (s.age_range_id IS NULL OR s.age_range_id IN (SELECT age_range_id FROM @tmp_patient_age_ranges))
AND (s.sex IS NULL OR @ls_sex IS NULL OR s.sex = @ls_sex)
AND (s.race IS NULL OR @ls_race IS NULL OR s.race = @ls_race)
AND NOT EXISTS (
	SELECT x.exam_sequence
	FROM @tmp_exams x
	WHERE x.exam_sequence = d.exam_sequence)
GROUP BY d.exam_sequence, d.description


SELECT exam_sequence,
	description,
	sort_sequence,
	selected_flag,
	disabled_flag
FROM @tmp_exams


GO
GRANT EXECUTE
	ON [dbo].[sp_default_exam_selection]
	TO [cprsystem]
GO

