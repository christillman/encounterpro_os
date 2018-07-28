CREATE FUNCTION fn_pretty_name (
	@ps_last_name varchar(40),
	@ps_first_name varchar(20),
	@ps_middle_name varchar(20),
	@ps_name_suffix varchar(12),
	@ps_name_prefix varchar(12),
	@ps_degree varchar(12) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_patient_full_name varchar(80)


SET @ls_patient_full_name = dbo.fn_pretty_name_formatted(@ps_first_name ,
														@ps_middle_name ,
														@ps_last_name ,
														NULL ,
														@ps_name_suffix ,
														@ps_name_prefix ,
														@ps_degree,
														NULL)



RETURN @ls_patient_full_name 

END

