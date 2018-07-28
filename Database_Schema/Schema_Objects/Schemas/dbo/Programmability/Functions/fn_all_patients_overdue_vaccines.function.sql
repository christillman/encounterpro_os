CREATE FUNCTION dbo.fn_all_patients_overdue_vaccines (
	@pl_past_amount int,
	@ps_past_unit varchar(12) -- Day, Week, Month, Year
	)

RETURNS @patient_results TABLE (
	cpr_id varchar(12) NOT NULL,
	drug_id varchar(24) NOT NULL,
	due_date datetime NOT NULL
	)
AS

BEGIN




RETURN
END

