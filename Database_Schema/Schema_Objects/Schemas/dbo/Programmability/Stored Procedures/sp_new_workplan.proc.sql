CREATE PROCEDURE dbo.sp_new_workplan (
	@ps_workplan_type varchar(12),
	@ps_treatment_type varchar(24) = NULL,
	@ps_in_office_flag char(1),
	@ps_description varchar(80),
	@pl_workplan_id int OUTPUT )
AS
INSERT INTO c_Workplan (
	workplan_type,
	treatment_type,
	in_office_flag,
	description )
VALUES (
	@ps_workplan_type,
	@ps_treatment_type,
	@ps_in_office_flag,
	@ps_description)

SELECT @pl_workplan_id = @@IDENTITY

