CREATE PROCEDURE sp_set_exam_defaults_from_actuals
	(
	@ps_user_id varchar(24),
	@pl_exam_sequence int,
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@pl_branch_id int
	)
AS

EXECUTE sp_clear_exam_defaults
	@ps_user_id = @ps_user_id,
	@pl_exam_sequence = @pl_exam_sequence,
	@pl_branch_id = @pl_branch_id

INSERT INTO u_Exam_Default_Results (
	exam_sequence,
	[user_id],
	branch_id ,
	observation_id ,
	result_sequence ,
	result_type ,
	result ,
	location ,
	result_value ,
	long_result_value ,
	result_unit ,
	abnormal_flag ,
	severity ,
	result_flag )
SELECT
	@pl_exam_sequence,
	@ps_user_id,
	branch_id ,
	observation_id ,
	result_sequence ,
	result_type ,
	result ,
	location ,
	result_value ,
	CAST(long_result_value AS varchar(4000)),
	result_unit ,
	abnormal_flag ,
	severity ,
	'Y'
FROM dbo.fn_defaults_from_actuals(@ps_cpr_id, @pl_observation_sequence, @pl_branch_id)



