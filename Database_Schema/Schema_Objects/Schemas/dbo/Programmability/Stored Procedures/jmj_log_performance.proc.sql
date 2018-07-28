CREATE PROCEDURE jmj_log_performance (
	@pl_computer_id int,
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@ps_metric varchar(24),
	@pd_value decimal(18,4) )
AS


INSERT INTO [dbo].[x_Performance_Log] (
           [computer_id],
           [patient_workplan_item_id],
           [user_id],
           [metric],
           [value])
 VALUES (
	@pl_computer_id ,
	@pl_patient_workplan_item_id ,
	@ps_user_id ,
	@ps_metric ,
	@pd_value )
