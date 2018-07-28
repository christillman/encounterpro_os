CREATE PROCEDURE jmj_treatment_type_set_default_mode (
	@ps_office_id varchar(4),
	@ps_treatment_type varchar(24),
	@ps_treatment_mode varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ls_default_treatment_key varchar(40)

SET @ls_default_treatment_key = '!Default'

IF NOT EXISTS (SELECT 1 
				FROM o_Treatment_Type_Default_Mode 
				WHERE office_id = @ps_office_id
				AND treatment_type = @ps_treatment_type
				AND treatment_key = @ls_default_treatment_key)
	BEGIN
	INSERT INTO o_Treatment_Type_Default_Mode (
		treatment_type,
		treatment_key,
		office_id,
		treatment_mode,
		created,
		created_by)
	VALUES (
		@ps_treatment_type,
		@ls_default_treatment_key,
		@ps_office_id,
		@ps_treatment_mode,
		getdate(),
		@ps_created_by)
	END
ELSE
	BEGIN
	UPDATE o_Treatment_Type_Default_Mode
	SET treatment_mode = @ps_treatment_mode
	WHERE office_id = @ps_office_id
	AND treatment_type = @ps_treatment_type
	AND treatment_key = @ls_default_treatment_key
	END

