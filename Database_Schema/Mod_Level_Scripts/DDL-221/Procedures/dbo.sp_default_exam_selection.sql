
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
	JOIN u_Exam_Selection s WITH (NOLOCK) ON d.exam_sequence = s.exam_sequence
WHERE d.root_observation_id = @ps_root_observation_id
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
	JOIN u_Exam_Selection s WITH (NOLOCK) ON d.exam_sequence = s.exam_sequence
WHERE d.root_observation_id = @ps_root_observation_id
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

