CREATE PROCEDURE sp_get_encounter_assessments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer )
AS

DECLARE @assessments TABLE (
	problem_id int NOT NULL,
	assessment_id varchar(24) NOT NULL,
	assessment_sequence int NULL,
	description varchar(80) NULL,
	assessment_billing_id int NULL,
	bill_flag char(1) NOT NULL,
	auto_close char(1) NULL,
	sort_sequence int NULL,
	diagnosis_sequence smallint NOT NULL)

INSERT INTO @assessments (
	problem_id,
	assessment_id,
	assessment_sequence,
	description,
	assessment_billing_id,
	bill_flag,
	auto_close,
	sort_sequence,
	diagnosis_sequence)
SELECT	ea.problem_id,
	ea.assessment_id,
	ea.assessment_sequence,
	ad.description,
	ea.assessment_billing_id,
	ea.bill_flag,
	ad.auto_close,
	a.sort_sequence,
	a.diagnosis_sequence
FROM p_Encounter_Assessment ea
	INNER JOIN c_Assessment_Definition ad
	ON ea.assessment_id = ad.assessment_id
	INNER JOIN p_Assessment a
	ON ea.cpr_id = a.cpr_id
	AND ea.problem_id = a.problem_id
WHERE ea.cpr_id = @ps_cpr_id
AND ea.encounter_id = @pl_encounter_id
AND ea.bill_flag = 'Y'
AND a.current_flag = 'Y'


INSERT INTO @assessments (
	problem_id,
	assessment_id,
	assessment_sequence,
	description,
	assessment_billing_id,
	bill_flag,
	auto_close,
	sort_sequence,
	diagnosis_sequence)
SELECT	ea.problem_id,
	ea.assessment_id,
	ea.assessment_sequence,
	ad.description,
	ea.assessment_billing_id,
	ea.bill_flag,
	ad.auto_close,
	sort_sequence = ea.problem_id + 10000,
	diagnosis_sequence = 1
FROM p_Encounter_Assessment ea
	INNER JOIN c_Assessment_Definition ad
	ON ea.assessment_id = ad.assessment_id
WHERE ea.cpr_id = @ps_cpr_id
AND ea.encounter_id = @pl_encounter_id
AND ea.bill_flag = 'Y'
AND ea.problem_id < 0

SELECT problem_id,
	assessment_id,
	assessment_sequence,
	description,
	assessment_billing_id,
	bill_flag,
	auto_close
FROM @assessments
ORDER BY sort_sequence,
	problem_id desc,
	diagnosis_sequence desc

