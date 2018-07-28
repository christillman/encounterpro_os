CREATE PROCEDURE jmj_patient_immunization_schedule (
	@ps_cpr_id varchar(12),
	@ps_disease_group varchar(24) = NULL,
	@pl_disease_id int = NULL,
	@pdt_current_date datetime = NULL)

AS

IF @pdt_current_date IS NULL
	SET @pdt_current_date = getdate()

SELECT disease_group ,
	disease_id ,
	description ,
	disease_group_sort_sequence ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text
FROM dbo.fn_patient_immunization_schedule(@ps_cpr_id, @pdt_current_date)
WHERE (@ps_disease_group IS NULL OR disease_group = @ps_disease_group)
AND (@pl_disease_id IS NULL OR disease_id = @pl_disease_id)


