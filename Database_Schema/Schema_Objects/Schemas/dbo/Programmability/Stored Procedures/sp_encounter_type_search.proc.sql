CREATE PROCEDURE sp_encounter_type_search (
	@ps_indirect_flag char(1) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_indirect_flag IS NULL
	SELECT @ps_indirect_flag = '%'

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

SELECT encounter_type,
		description,
		icon,
		default_indirect_flag,
		status,
		selected_flag=0
FROM c_Encounter_Type
WHERE default_indirect_flag like @ps_indirect_flag
AND status like @ps_status
AND description like @ps_description

