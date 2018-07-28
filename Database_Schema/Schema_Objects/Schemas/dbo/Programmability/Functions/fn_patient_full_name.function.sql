CREATE FUNCTION fn_patient_full_name (
	@ps_cpr_id varchar(12) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_patient_full_name varchar(80),
	@ls_last_name varchar(40),
	@ls_first_name varchar(20),
	@ls_middle_name varchar(20),
	@ls_name_suffix varchar(12),
	@ls_name_prefix varchar(12),
	@ls_degree varchar(12)

IF @ps_cpr_id IS NULL
	BEGIN
	SET @ls_patient_full_name = NULL
	RETURN @ls_patient_full_name
	END

SELECT @ls_last_name = last_name,
	@ls_first_name = first_name,
	@ls_middle_name = middle_name,
	@ls_name_suffix = name_suffix,
	@ls_name_prefix = name_prefix,
	@ls_degree = degree
FROM p_Patient (NOLOCK)
WHERE cpr_id = @ps_cpr_id

IF @@ROWCOUNT <> 1
	BEGIN
	SET @ls_patient_full_name = NULL
	RETURN @ls_patient_full_name
	END

SET @ls_patient_full_name = dbo.fn_pretty_name(@ls_last_name ,
											@ls_first_name ,
											@ls_middle_name ,
											@ls_name_suffix ,
											@ls_name_prefix ,
											@ls_degree )

RETURN @ls_patient_full_name 

END

