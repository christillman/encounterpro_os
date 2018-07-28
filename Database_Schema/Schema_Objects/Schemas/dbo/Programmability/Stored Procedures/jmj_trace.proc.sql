CREATE PROCEDURE jmj_trace
	 @trace_file NVARCHAR (245)
	,@run_minutes INT
	,@ApplicationName SYSNAME = NULL
	,@NTUserName SYSNAME = NULL
	,@ClientHostName SYSNAME = NULL
	,@SPID INT = NULL
	,@ClientProcessID INT = NULL
	,@DatabaseID INT = NULL
AS

DECLARE
	 @trace_id INT
	,@trace_options INT
	,@max_file_size BIGINT
	,@event_id INT
	,@column_id INT
	,@on_trace BIT
	,@return INT
	,@stop_time DATETIME
	,@now datetime
	

SET	@trace_options = 2
SET	@max_file_size = 50
SET	@event_id = 0
SET	@on_trace = 1
SET	@now = getdate()
SET	@stop_time = DATEADD( minute, @run_minutes, @now )

SET	@trace_file = @trace_file +
		CAST( DATEPART( yyyy, @now ) AS VARCHAR ) +
		CAST( DATEPART( mm, @now ) AS VARCHAR ) +
		CAST( DATEPART( dd, @now ) AS VARCHAR ) +
		CAST( DATEPART( hh, @now ) AS VARCHAR ) +
		CAST( DATEPART( mm, @now ) AS VARCHAR ) +
		CAST( DATEPART( ss, @now ) AS VARCHAR )


-- Create Trace in SQL

EXEC @return = sp_trace_create
	 @traceid = @trace_id OUTPUT
	,@options = @trace_options
	,@tracefile = @trace_file
	,@maxfilesize = @max_file_size
	,@stoptime = @stop_time

IF @return <> 0
BEGIN
	PRINT 'Error creating trace.  Error: ' + CAST( @return AS VARCHAR )
	RETURN @return
END
ELSE
	PRINT 'New Trace ID: ' + CAST( @trace_id AS VARCHAR )


WHILE @event_id < 150
BEGIN
	-- Monitor the events listed in the IN list.  See sp_trace_setevent for definition of event_id.

	IF @event_id IN ( 10, 12 )
	BEGIN
		SET @column_id = 0

		WHILE @column_id < 50
		BEGIN
			-- Data elements to be recorded in trace.  See sp_trace_setevent for definition of column_id.

			IF @column_id IN ( 1, 3, 6, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 26, 31 )
			BEGIN

				EXEC @return = sp_trace_setevent
					 @traceid = @trace_id
					,@eventid = @event_id
					,@columnid = @column_id
					,@on	= @on_trace

				IF @return <> 0
				BEGIN
					PRINT 'Trace Set Error: @event_id = ' + CAST( @event_id AS VARCHAR ) 
						+ ' @column_id = ' + CAST( @column_id AS VARCHAR )
						+ ' Error = ' + CAST( @return AS VARCHAR )
					RETURN @return
				END
		END

			SET @column_id = @column_id + 1

			CONTINUE
		END
	END

	SET @event_id = @event_id + 1

	CONTINUE
END

IF ISNULL( @DatabaseID, 0 ) <> 0
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 3
		,@logical_operator = 0
		,@comparison_operator = 0
		,@value = @DatabaseID
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 3'
		RETURN @return
	END
END

IF ISNULL( @NTUserName, '') <> ''
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 6
		,@logical_operator = 0
		,@comparison_operator = 6
		,@value = @NTUsername
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 6'
		RETURN @return
	END
END

IF ISNULL( @ClientHostName, '') <> ''
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 8
		,@logical_operator = 0
		,@comparison_operator = 6
		,@value = @ClientHostName
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 8'
		RETURN @return
	END
END


IF ISNULL( @ClientProcessID, 0 ) <> 0
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 9
		,@logical_operator = 0
		,@comparison_operator = 0
		,@value = @ClientProcessID
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 9'
		RETURN @return
	END
END

IF ISNULL( @ApplicationName, '') <> ''
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 10
		,@logical_operator = 0
		,@comparison_operator = 6
		,@value = @ApplicationName
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 10'
		RETURN @return
	END
END


IF ISNULL( @SPID, 0 ) <> 0
BEGIN
	EXEC @return = sp_trace_setfilter
		 @traceid = @trace_id
		,@column_id = 12
		,@logical_operator = 0
		,@comparison_operator = 0
		,@value = @ClientProcessID
	IF @return <> 0
	BEGIN
		PRINT 'Filter Set Error on column_id 12'
		RETURN @return
	END
END

EXEC @return = sp_trace_setstatus @trace_id, 1

IF @return <> 0
BEGIN
	PRINT 'Trace Failed to start'
	RETURN @return
END

RETURN 0

