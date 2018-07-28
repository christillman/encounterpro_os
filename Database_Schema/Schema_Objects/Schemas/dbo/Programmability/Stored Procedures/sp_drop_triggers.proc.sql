CREATE PROCEDURE sp_drop_triggers (
	@ps_table varchar(64) )
AS

DECLARE @Trigger sysname
DECLARE lc_triggers CURSOR FOR
	select o.name
	from sysobjects o WITH (NOLOCK), 
		sysobjects d WITH (NOLOCK)
	where o.type = 'TR'
	and d.type = 'U'
	and o.deltrig = d.id
	and d.name = @ps_table
OPEN lc_triggers
FETCH NEXT FROM lc_triggers INTO @Trigger
WHILE (@@fetch_status = 0)
BEGIN
	IF EXISTS (	SELECT *
			FROM sysobjects WITH (NOLOCK)
			WHERE id = object_id(@Trigger)
			AND sysstat & 0xf = 8
			)
	BEGIN
		EXEC ('DROP TRIGGER ' + @Trigger)
	END
	FETCH NEXT FROM lc_triggers INTO @Trigger
END
DEALLOCATE lc_triggers


