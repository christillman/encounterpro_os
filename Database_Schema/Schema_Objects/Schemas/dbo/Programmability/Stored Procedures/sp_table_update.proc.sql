CREATE PROCEDURE sp_table_update (
	@ps_table_name varchar(64),
	@ps_updated_by varchar(24) = NULL )
AS


UPDATE c_Table_Update
SET last_updated = getdate(),
	updated_by = @ps_updated_by
WHERE table_name = @ps_table_name

IF @@ROWCOUNT <> 1
	INSERT INTO c_Table_Update (
		table_name,
		last_updated,
		updated_by)
	VALUES (
		@ps_table_name,
		getdate(),
		@ps_updated_by)


