CREATE PROCEDURE sp_new_unit_id (
	@ps_description varchar(40),
	@ps_unit_type varchar(12) = 'Number',
	@ps_display_mask varchar(40) = '0.##',
	@pl_owner_id int,
	@ps_unit_id varchar(24) OUTPUT )

AS

DECLARE @ll_key_value integer
	, @ls_unit_id varchar(24)
	
EXECUTE sp_get_next_key
	@ps_cpr_id = '!CPR',
	@ps_key_id = 'UNIT_ID',
	@pl_key_value = @ll_key_value OUTPUT

SET @ls_unit_id = '!JMJUnit' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

WHILE exists(select * from c_unit where unit_id = @ls_unit_id)
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'UNIT_ID',
		@pl_key_value = @ll_key_value OUTPUT
		
	SET @ls_unit_id = '!JMJUnit' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
	END


INSERT INTO c_Unit (
	unit_id,
	description,
	unit_type,
	plural_flag,
	print_unit,
	id,
	display_mask )
VALUES (
	@ls_unit_id,
	@ps_description,
	@ps_unit_type,
	'N',
	'Y',
	newid(),
	@ps_display_mask)

SET @ps_unit_id = @ls_unit_id

