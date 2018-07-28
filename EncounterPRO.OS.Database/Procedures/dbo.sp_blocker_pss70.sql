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

-- Drop Procedure [dbo].[sp_blocker_pss70]
Print 'Drop Procedure [dbo].[sp_blocker_pss70]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_blocker_pss70]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_blocker_pss70]
GO

-- Create Procedure [dbo].[sp_blocker_pss70]
Print 'Create Procedure [dbo].[sp_blocker_pss70]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


create proc sp_blocker_pss70 (@fast int = 0)
as 
set nocount on
declare @spid varchar(6), @blocked varchar(6) --,@uid varchar(6)
declare @tmpchar varchar(255)
declare @time datetime

select @time = getdate()

select spid, blocked, waittype, dbid into #probclients from master..sysprocesses where blocked!=0 or waittype != 0x0000
create unique clustered index pc on #probclients (blocked,spid)
if exists (select spid from #probclients)
begin
   select @tmpchar='Start time: ' + convert(varchar(26), @time, 113)
   print @tmpchar

   insert #probclients select distinct blocked, 0, 0x0000, 0 from #probclients
   where blocked not in (select spid from #probclients) and blocked != 0

   print ' '
   if (@fast = 1)
   begin
      select spid, status, blocked, open_tran, waitresource, waittype, 
         waittime, cmd, lastwaittype, cpu, physical_io,
         memusage,last_batch=convert(varchar(26), last_batch,113),
         login_time=convert(varchar(26), login_time,113), net_address,
         net_library,dbid, ecid, kpid, hostname,hostprocess,
         loginame,program_name, nt_domain, nt_username, uid, sid,
         'sprocpss70', runtime = convert(varchar(26), @time, 113)
      from master..sysprocesses
      where blocked!=0 or waittype != 0x0000
         or spid in (select blocked from #probclients where blocked != 0)
         or spid in (select spid from #probclients where blocked != 0)

      select spid = convert (smallint, req_spid),
         ecid = convert (smallint, req_ecid),
         rsc_dbid As dbid,
         rsc_objid As ObjId,
         rsc_indid As IndId,
         Type = case rsc_type when 1 then 'NUL'
                              when 2 then 'DB'
                              when 3 then 'FIL'
                              when 4 then 'IDX'
                              when 5 then 'TAB'
                              when 6 then 'PAG'
                              when 7 then 'KEY'
                              when 8 then 'EXT'
                              when 9 then 'RID' end,
         Resource = substring (rsc_text, 1, 16),
         Mode = case req_mode + 1 when 1 then NULL
                                  when 2 then 'Sch-S'
                                  when 3 then 'Sch-M'
                                  when 4 then 'IS'
                                  when 5 then 'SIU'
                                  when 6 then 'IS-S'
                                  when 7 then 'IX'
                                  when 8 then 'SIX'
                                  when 9 then 'S'
                                  when 10 then 'U'
                                  when 11 then 'IIn-Nul'
                                  when 12 then 'IS-X'
                                  when 13 then 'IU'
                                  when 14 then 'IS-U'
                                  when 15 then 'X'
                                  when 16 then 'BU' end,
         Status = case req_status when 1 then 'GRANT'
                                  when 2 then 'CNVT'
                                  when 3 then 'WAIT' end,
         'slockpss70', runtime = convert(varchar(26), @time, 113)

      from master.dbo.syslockinfo s,
         #probclients p
      where p.spid = s.req_spid
   end  -- fast set

   else  
   begin  -- Fast not set
      select spid, status, blocked, open_tran, waitresource, waittype, 
         waittime, cmd, lastwaittype, cpu, physical_io,
         memusage,last_batch=convert(varchar(26), last_batch,113),
         login_time=convert(varchar(26), login_time,113), net_address,
         net_library,dbid, ecid, kpid, hostname,hostprocess,
         loginame,program_name, nt_domain, nt_username, uid, sid,
         'sprocpss70', runtime = convert(varchar(26), @time, 113)
      from master..sysprocesses

      print ''
      print 'SPIDs at the head of blocking chains'
      select spid from #probclients
      where blocked = 0 and spid in (select blocked from #probclients where spid != 0)
      print ''

      select spid = convert (smallint, req_spid),
         ecid = convert (smallint, req_ecid),
         rsc_dbid As dbid,
         rsc_objid As ObjId,
         rsc_indid As IndId,
         Type = case rsc_type when 1 then 'NUL'
                              when 2 then 'DB'
                              when 3 then 'FIL'
                              when 4 then 'IDX'
                              when 5 then 'TAB'
                              when 6 then 'PAG'
                              when 7 then 'KEY'
                              when 8 then 'EXT'
                              when 9 then 'RID' end,
         Resource = substring (rsc_text, 1, 16),
         Mode = case req_mode + 1 when 1 then NULL
                                  when 2 then 'Sch-S'
                                  when 3 then 'Sch-M'
                                  when 4 then 'IS'
                                  when 5 then 'SIU'
                                  when 6 then 'IS-S'
                                  when 7 then 'IX'
                                  when 8 then 'SIX'
                                  when 9 then 'S'
                                  when 10 then 'U'
                                  when 11 then 'IIn-Nul'
                                  when 12 then 'IS-X'
                                  when 13 then 'IU'
                                  when 14 then 'IS-U'
                                  when 15 then 'X'
                                  when 16 then 'BU' end,
         Status = case req_status when 1 then 'GRANT'
                                  when 2 then 'CNVT'
                                  when 3 then 'WAIT' end,
         'slockpss70', runtime = convert(varchar(26), @time, 113)

      from master.dbo.syslockinfo
   end -- Fast not set

   dbcc traceon(3604)
   Print ''
   Print ''
   Print '*********************************************************************'
   Print 'Print out DBCC INPUTBUFFER for all blocked or blocking spids.'
   Print 'Print out DBCC PSS info only for SPIDs at the head of blocking chains'
   Print '*********************************************************************'

   declare ibuffer cursor fast_forward for
   select cast (spid as varchar(6)) as spid, cast (blocked as varchar(6)) as blocked
   from #probclients
   where (spid <> @@spid) and (blocked!=0
      --Remove comment on following line to see DBCC INPUTBUFFER and PSS for spids not involved in blocking
      --or waittype != 0x0000
      or spid in (select blocked from #probclients where blocked != 0))
   open ibuffer
   fetch next from ibuffer into @spid, @blocked
   while (@@fetch_status != -1)
   begin
      print ''
      print ''
      exec ('print ''DBCC INPUTBUFFER FOR SPID ' + @spid + '''')
      exec ('dbcc inputbuffer (' + @spid + ')')
      print ''
      if (@blocked = '0')
      -- if DBCC PSS is not required, comment the line above, remove the
      -- comment on the line below and run the stored procedure in fast 
      -- mode
      -- if (@blocked = '0' and @fast = 0)
      begin
         exec ('print ''DBCC PSS FOR SPID ' + @spid + '''')
         exec ('dbcc pss (0, ' + @spid +')')
         print ''
         print ''
      end
      fetch next from ibuffer into @spid, @blocked
   end
   deallocate ibuffer

   Print ''
   Print ''
   Print '*******************************************************************************'
   Print 'Print out DBCC OPENTRAN for active databases for all blocked or blocking spids.'
   Print '*******************************************************************************'
   declare ibuffer cursor fast_forward for
   select distinct cast (dbid as varchar(6)) from #probclients
   where dbid != 0
   open ibuffer
   fetch next from ibuffer into @spid
   while (@@fetch_status != -1)
   begin
      print ''
      print ''
      exec ('print ''DBCC OPENTRAN FOR DBID ' + @spid + '''')
      exec ('dbcc opentran (' + @spid + ')')
      print ''
      if @spid = '2' select @blocked = 'Y'
      fetch next from ibuffer into @spid
   end
   deallocate ibuffer
   if @blocked != 'Y' 
   begin
      print ''
      print ''
      exec ('print ''DBCC OPENTRAN FOR tempdb database''')
      exec ('dbcc opentran (tempdb)')
   end
   
   if datediff(millisecond, @time, getdate()) > 1000
   begin
      select @tmpchar='End time: ' + convert(varchar(26), getdate(), 113)
      print @tmpchar
   end

   dbcc traceoff(3604)
end -- All

GO
GRANT EXECUTE
	ON [dbo].[sp_blocker_pss70]
	TO [cprsystem]
GO

