CREATE TRIGGER tr_c_workplan_update ON dbo.c_workplan
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @lui_id uniqueidentifier,
		@ls_description varchar(80),
		@ls_from_status varchar(12),
		@ls_to_status varchar(12)

DECLARE lc_updated CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.id,
			i.description,
			d.status as from_status,
			i.status as to_status
	FROM inserted i
		INNER JOIN deleted d
		ON i.workplan_id = d.workplan_id

OPEN lc_updated
FETCH lc_updated INTO @lui_id, @ls_description, @ls_from_status, @ls_to_status

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ls_from_status <> @ls_to_status
	EXECUTE config_log
		@pui_config_object_id = @lui_id ,
		@ps_config_object_type = 'Workplan' ,
		@ps_description = 'Workplan Change' ,
		@ps_operation = 'Update' ,
		@ps_property = 'Status' ,
		@ps_from_value = @ls_from_status ,
		@ps_to_value = @ls_to_status

	FETCH lc_updated INTO @lui_id, @ls_description, @ls_from_status, @ls_to_status
	END

CLOSE lc_updated
DEALLOCATE lc_updated


