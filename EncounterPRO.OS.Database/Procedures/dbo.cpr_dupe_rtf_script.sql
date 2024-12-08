
-- Drop Procedure [dbo].[cpr_dupe_rtf_script]
Print 'Drop Procedure [dbo].[cpr_dupe_rtf_script]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[cpr_dupe_rtf_script]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[cpr_dupe_rtf_script]
GO

-- Create Procedure [dbo].[cpr_dupe_rtf_script]
Print 'Create Procedure [dbo].[cpr_dupe_rtf_script]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [cpr_dupe_rtf_script]
	@sourceid Integer
AS
declare @fix_display as integer
declare @mycount as integer
declare @cmd_count as integer
declare @att_count as integer
select @fix_display = @sourceid
select @mycount = 0

-- execute cpr_dupe_rtf_script 5  where 5=display_script_id to be duplicated 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jmc_display_stuff]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[jmc_display_stuff]

CREATE TABLE [dbo].[jmc_display_stuff] (
	[orig_command_id] [int] ,
	[command_id] [int] NULL ,
) ON [PRIMARY]

INSERT INTO c_display_script (
	context_object,
	display_script,
	description,
	example,
	status,
	last_updated,
	updated_by
	)
SELECT
	context_object,
	display_script,
	description,
	example,
	status,
	last_updated,
	updated_by
FROM c_display_script
where display_script_id = @fix_display


SELECT count(*) As Commands 
from c_display_script_command
where display_script_id = @fix_display

Select count(*) As Attributes 
from c_display_script_cmd_attribute
where c_display_script_cmd_attribute.display_script_id = @fix_display

SELECT @cmd_count = count(*) 
from c_display_script_command
where display_script_id = @fix_display

SELECT count(*) As Good_Attributes 
from c_display_script_cmd_attribute
join c_display_script_command
on c_display_script_cmd_attribute.display_command_id = c_display_script_command.display_command_id
where c_display_script_cmd_attribute.display_script_id = @fix_display
and c_display_script_command.display_script_id = @fix_display

SELECT @att_count = count(*) 
from c_display_script_cmd_attribute
join c_display_script_command
on c_display_script_cmd_attribute.display_command_id = c_display_script_command.display_command_id
where c_display_script_cmd_attribute.display_script_id = @fix_display
and c_display_script_command.display_script_id = @fix_display

SELECT @@IDENTITY AS 'Identity'
declare @fix_script_id as integer
declare @fix_command_id as integer
Select @fix_script_id = @@IDENTITY

declare @orig_command_id as integer
declare jmc_curse1 cursor for
	select 	display_command_id,
		context_object,
		display_command,
		sort_sequence,
		status
	from c_display_script_command
	where display_script_id = @fix_display
	order by sort_sequence

declare jmc_curse2 cursor for
	select 	c_display_script_cmd_attribute.display_command_id,
		attribute,
		value
	from c_display_script_cmd_attribute
	join c_display_script_command
	on c_display_script_cmd_attribute.display_command_id = c_display_script_command.display_command_id
	where c_display_script_cmd_attribute.display_script_id = @fix_display
	and c_display_script_command.display_script_id = @fix_display
	
declare @mycontext_object varchar(24), @mydisplay_command varchar(40), @mysort_sequence integer, @mystatus varchar(8)
declare @myattribute varchar(40), @myvalue varchar(255)

open jmc_curse1
FETCH NEXT FROM jmc_curse1
into @orig_command_id, @mycontext_object, @mydisplay_command, @mysort_sequence, @mystatus

insert into c_display_script_command
(display_script_id,context_object,display_command,sort_sequence,status) 
  values(
	@fix_script_id,
	@mycontext_object,
	@mydisplay_command,
	@mysort_sequence,
	@mystatus
	)

Select @fix_command_id = @@IDENTITY

insert into dbo.jmc_display_stuff
values(@orig_command_id,@fix_command_id)
SELECT @cmd_count = @cmd_count - 1

WHILE (@@FETCH_STATUS <> -1)
BEGIN
   IF (@@FETCH_STATUS <> -2)
   BEGIN   
   	FETCH NEXT FROM jmc_curse1
	into @orig_command_id,@mycontext_object, @mydisplay_command, @mysort_sequence, @mystatus
	If @cmd_count > 0
	BEGIN 
		insert into c_display_script_command
		(display_script_id,context_object,display_command,sort_sequence,status) 
		values(
		@fix_script_id,
		@mycontext_object,
		@mydisplay_command,
		@mysort_sequence,
		@mystatus)
		Select @fix_command_id = @@IDENTITY
		insert into dbo.jmc_display_stuff
		values(@orig_command_id,@fix_command_id)
		SELECT @cmd_count = @cmd_count - 1
	END
	END
END
CLOSE jmc_curse1
Select count(*) As Mapped_Commands from dbo.jmc_display_stuff

select * from dbo.jmc_display_stuff
Select @cmd_count = count(*) from dbo.jmc_display_stuff

open jmc_curse2
FETCH NEXT FROM jmc_curse2
into @orig_command_id, @myattribute, @myvalue

Select @fix_command_id = command_id
from dbo.jmc_display_stuff
where orig_command_id = @orig_command_id

Insert into c_display_script_cmd_attribute
	(display_script_id,display_command_id,attribute,value)
	Values(
	@fix_script_id,
	@fix_command_id,
	@myattribute,
	@myvalue
	)
SELECT @att_count = @att_count - 1
WHILE (@@FETCH_STATUS <> -1)
BEGIN
   IF (@@FETCH_STATUS <> -2)
   BEGIN
	If @att_count > 0 
	BEGIN   
	FETCH NEXT FROM jmc_curse2
	into @orig_command_id, @myattribute, @myvalue

	Select @fix_command_id = command_id 
	from dbo.jmc_display_stuff
	where orig_command_id = @orig_command_id

	Insert into c_display_script_cmd_attribute
	(display_script_id,display_command_id,attribute,value)
	Values(
	@fix_script_id,
	@fix_command_id,
	@myattribute,
	@myvalue)
	Select @att_count = @att_count - 1
	END
    END
END

SELECT count(*) As New_Commands 
from c_display_script_command
where c_display_script_command.display_script_id = @fix_script_id

SELECT count(*) As New_attributes 
from c_display_script_cmd_attribute
join c_display_script_command
on c_display_script_cmd_attribute.display_command_id = c_display_script_command.display_command_id
where c_display_script_cmd_attribute.display_script_id = @fix_script_id
and c_display_script_command.display_script_id = @fix_script_id
CLOSE jmc_curse2

Select a.display_command_id,a.attribute,a.value,
		b.display_command_id,b.attribute ,b.value
From dbo.jmc_display_stuff 
join c_display_script_cmd_attribute b ON b.display_command_id = dbo.jmc_display_stuff.command_id
join c_display_script_cmd_attribute a ON a.display_command_id = dbo.jmc_display_stuff.orig_command_id

DEALLOCATE jmc_curse1
DEALLOCATE jmc_curse2
drop table [dbo].[jmc_display_stuff]


GO
GRANT EXECUTE ON [cpr_dupe_rtf_script] TO [cprsystem] AS [dbo]
GO
