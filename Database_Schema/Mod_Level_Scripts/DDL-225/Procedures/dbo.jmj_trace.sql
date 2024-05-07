--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_trace]
Print 'Drop Procedure [dbo].[jmj_trace]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_trace]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_trace]
GO

-- Create Procedure [dbo].[jmj_trace]
Print 'Create Procedure [dbo].[jmj_trace]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
SET	@now = dbo.get_client_datetime()
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

GO

