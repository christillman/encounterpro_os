
CREATE PROCEDURE sp_rk_blocker_blockee
AS

set transaction isolation level read uncommitted
set nocount on

declare @blocker_spid int, @blockee_spid int, @blockee_blocker int
declare @blockee_waitime int

IF EXISTS
    (SELECT * FROM master.dbo.sysprocesses
    WHERE spid IN (SELECT blocked FROM master.dbo.sysprocesses))
    BEGIN


DECLARE blocker_cursor CURSOR FOR
	SELECT spid FROM master.dbo.sysprocesses WHERE spid IN (SELECT blocked FROM master.dbo.sysprocesses)
            AND blocked=0 

DECLARE blockee_cursor CURSOR FOR
	SELECT spid, blocked, waittime FROM master.dbo.sysprocesses WHERE blocked > 0


OPEN blocker_cursor 


FETCH NEXT FROM blocker_cursor INTO @blocker_spid
	WHILE (@@FETCH_STATUS =0 )
		BEGIN
			Select 'Blocker: ',@blocker_spid 
			exec sp_executesql N'dbcc inputbuffer(@Param)',N'@Param int', @blocker_spid 
			--SELECT Blocked = spid FROM master.dbo.sysprocesses WHERE blocked = @blocker_spid
			OPEN blockee_cursor
					FETCH NEXT FROM blockee_cursor INTO @blockee_spid, @blockee_blocker, @blockee_waitime
				
					WHILE (@@fetch_status = 0)
						BEGIN
						--SELECT Blocked = spid FROM master.dbo.sysprocesses WHERE blocked = @blocker_spid
						--Select 'EE: ', @blockee_blocker, '  Er: ',@blocker_spid
						IF (@blockee_blocker=@blocker_spid)
							BEGIN
								SELECT 'Blockee:    Waittime:', @blockee_spid, @blockee_waitime
								exec sp_executesql N'dbcc inputbuffer(@Param)',N'@Param int', @blockee_spid
							END
						FETCH NEXT FROM blockee_cursor INTO @blockee_spid, @blockee_blocker, @blockee_waitime						                                                      
						END
			CLOSE blockee_cursor
		FETCH NEXT FROM blocker_cursor INTO @blocker_spid
		END
CLOSE blocker_cursor
DEALLOCATE blockee_cursor 
DEALLOCATE blocker_cursor

--go


    END
ELSE
SELECT 'No blocking processes found!'
