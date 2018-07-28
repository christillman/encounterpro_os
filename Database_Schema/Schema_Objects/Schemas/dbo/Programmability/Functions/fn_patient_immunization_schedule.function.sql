CREATE FUNCTION fn_patient_immunization_schedule (
	@ps_cpr_id varchar(12),
	@pdt_current_date datetime)

RETURNS @schedule TABLE (
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_group_sort_sequence int NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @ps_cpr_id IS NULL
	RETURN

DECLARE @ls_disease_group varchar(24),
		@ll_disease_group_sort_sequence int


DECLARE lc_diseases CURSOR LOCAL FAST_FORWARD FOR
	SELECT disease_group, sort_sequence
	FROM c_Disease_Group
	WHERE status = 'OK'

OPEN lc_diseases

FETCH lc_diseases INTO @ls_disease_group, @ll_disease_group_sort_sequence

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO @schedule (
		disease_group ,
		disease_id ,
		description ,
		disease_group_sort_sequence ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT @ls_disease_group ,
		disease_id ,
		description ,
		@ll_disease_group_sort_sequence ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text
	FROM dbo.fn_patient_disease_group_schedule(@ps_cpr_id, @ls_disease_group, @pdt_current_date)
	
	
	FETCH lc_diseases INTO @ls_disease_group, @ll_disease_group_sort_sequence
	END

CLOSE lc_diseases
DEALLOCATE lc_diseases


RETURN
END

