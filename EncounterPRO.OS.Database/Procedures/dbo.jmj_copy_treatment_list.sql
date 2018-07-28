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

-- Drop Procedure [dbo].[jmj_copy_treatment_list]
Print 'Drop Procedure [dbo].[jmj_copy_treatment_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_treatment_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_treatment_list]
GO

-- Create Procedure [dbo].[jmj_copy_treatment_list]
Print 'Create Procedure [dbo].[jmj_copy_treatment_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_treatment_list
	@ps_From_assessment_id varchar(24)
	,@ps_From_user_id varchar(24)
	,@ps_To_assessment_id varchar(24)
	,@ps_To_user_id varchar(24)
AS
Declare @From_assessment_id varchar(24)
Declare @From_user_id varchar(24)
Declare @To_assessment_id varchar(24)
Declare @To_user_id varchar(24)

--Select @From_assessment_id = 'HEMATCZ'
--SELECT @From_user_id = '$GASTRO'
--SELECT @To_assessment_id = 'HEMATCZ2'
--SELECT @To_user_id = '$GASTRO'

Select @From_assessment_id = @ps_From_assessment_id
SELECT @From_user_id = @ps_From_user_id
SELECT @To_assessment_id = @ps_To_assessment_id
SELECT @To_user_id = @ps_To_user_id

DECLARE @nextidentval integer
DECLARE @checkidentval integer
DECLARE @attnextidentval integer
DECLARE @attcheckidentval integer
Declare @Count integer
Declare @Count2 integer
SELECT @nextidentval = MAX(IDENTITYCOL) + IDENT_INCR('u_assessment_treat_definition')
   FROM u_assessment_treat_definition

--SELECT @nextidentval AS 'New_assess_treat_seed'

DECLARE @tmp_u_assessment_treat_definition TABLE (
	[identity_id] [int] not NULL PRIMARY KEY,
	new_definition_id int null,
	[assessment_id] [varchar] (24) NULL ,
	[treatment_type] [varchar] (24) NULL ,
	[treatment_description] [varchar] (255) NULL ,
	[workplan_id] [int] NULL ,
	[followup_workplan_id] [int] NULL ,
	[user_id] [varchar] (24) NULL ,
	[sort_sequence] [smallint] NULL ,
	[instructions] [varchar] (50) NULL ,
	[parent_definition_id] [int] NULL ,
	[child_flag] [char] (1)  NULL 
) 

-- Due to a "feature" in powerbuilder, this proc might get run twice
-- when run from an RTF command.  If any items were created in the last 20 seconds, then don't do anyting
IF EXISTS(SELECT 1 
			FROM u_Assessment_Treat_Definition 
			WHERE assessment_id = @To_assessment_id
			AND user_id = @To_user_id
			AND created > DATEADD(ss, -20, getdate()) )
	BEGIN
	Select 
		assessment_id,
                treatment_type,
                treatment_description,
                workplan_id,
                followup_workplan_id,
                user_id,
                sort_sequence,
                instructions,
                parent_definition_id,
                child_flag
		FROM u_assessment_treat_definition
		where assessment_id = @To_assessment_id
		and user_id = @To_user_id
	RETURN
	END

-- Clean up orphans in the "From" assessment
DELETE d
FROM u_assessment_treat_definition d
WHERE assessment_id = @From_assessment_id
AND user_id = @From_user_id
AND d.parent_definition_id IS NOT NULL
AND NOT EXISTS (SELECT 1
				FROM u_assessment_treat_definition dp
				WHERE dp.definition_id = d.parent_definition_id)
 
--When composite treatments are removed from a treatment list and the constituents of the composite
-- themselves have child treatments, the child treatments are not deleted from  u_assessment_treat_definition 
--when the composite treatment is removed. 
DELETE FROM u_assessment_treat_definition WHERE definition_id in
(SELECT distinct d.definition_id
FROM u_assessment_treat_definition d
LEFT OUTER JOIN u_assessment_treat_definition d2
ON d.parent_definition_id = d2.definition_id
AND d.user_id = d2.user_id
AND d.assessment_id = d.assessment_id
WHERE d2.definition_id IS NULL
AND d.parent_definition_id IS NOT NULL)
AND assessment_id = @From_assessment_id
and user_id = @From_user_id

--another cleanup issue that is a bug in the delete composite functionality.!
DELETE from u_assessment_treat_definition WHERE parent_definition_id IN
(SELECT distinct parent_definition_id FROM u_assessment_treat_definition
WHERE parent_definition_id IS NOT NULL
AND parent_definition_id not in
(SELECT definition_id FROM u_assessment_treat_definition))
AND assessment_id = @From_assessment_id
and user_id = @From_user_id


INSERT INTO @tmp_u_assessment_treat_definition
              ( identity_id,
		new_definition_id,
		assessment_id,
                treatment_type,
                treatment_description,
                workplan_id,
                followup_workplan_id,
                user_id,
                sort_sequence,
                instructions,
                parent_definition_id,
                child_flag
              )
SELECT 		definition_id,
		@nextidentval,
		@To_assessment_id,
                treatment_type,
                treatment_description,
                workplan_id,
                followup_workplan_id,
                @To_user_id,
                sort_sequence,
                instructions,
                parent_definition_id,
                child_flag
FROM u_assessment_treat_definition
where assessment_id = @From_assessment_id
and user_id = @From_user_id
order by definition_id asc


select @Count =  count(*) from @tmp_u_assessment_treat_definition

--select @Count
--Select * from @tmp_u_assessment_treat_definition

declare @identity_id integer
declare @parent_definition_id integer
declare @new_incr integer
declare this_curse CURSOR FOR 
	select identity_id
	from @tmp_u_assessment_treat_definition
set @new_incr = 0
open this_curse
while @count > 0
begin
	fetch next from this_curse into @identity_id
	Update @tmp_u_assessment_treat_definition
	set new_definition_id = new_definition_id + @new_incr
	where identity_id = @identity_id
	set @new_incr = @new_incr + 1
	set @count = @count - 1
end
close this_curse
deallocate this_curse
--Select * from @tmp_u_assessment_treat_definition

-- If there is a  parent_definition_id as part of the copied stuff
-- and the parent id is part of the set 
declare this_curse3 CURSOR FOR 
	select identity_id,parent_definition_id
	from @tmp_u_assessment_treat_definition where parent_definition_id is not null

select @Count2 =  count(*) from @tmp_u_assessment_treat_definition where parent_definition_id is not null
open this_curse3
while @count2 > 0
begin
	fetch next from this_curse3 into @identity_id,@parent_definition_id
	UPDATE @tmp_u_assessment_treat_definition
	Set parent_definition_id = (select nid.new_definition_id from @tmp_u_assessment_treat_definition nid
				where nid.identity_id = @parent_definition_id)
	where identity_id = @identity_id
	
	set @count2 = @count2 - 1
end
close this_curse3
deallocate this_curse3

--Select * from @tmp_u_assessment_treat_definition

DECLARE @tmp_u_assessment_treat_def_attrib TABLE (
	[old_definition_id] [int] NOT NULL ,
	[new_definition_id] [int] Null,
	[attribute_sequence] [int] IDENTITY (1, 1) NOT NULL PRIMARY KEY ,
	new_attribute_sequence int null,
	[attribute] [varchar] (80) NOT NULL ,
	[value] [varchar] (255)  NULL 
) 


SELECT @attnextidentval = MAX(IDENTITYCOL) + IDENT_INCR('u_assessment_treat_def_attrib')
   FROM u_assessment_treat_def_attrib

--SELECT @nextidentval AS 'New_assess_treat_def_attrb_seed'

INSERT INTO @tmp_u_assessment_treat_def_attrib
              ( old_definition_id,
		new_definition_id,
		attribute   ,
		value  
              )
SELECT 
		definition_id  ,
		new_definition_id ,
		attribute   ,
		value  
FROM u_assessment_treat_def_attrib,@tmp_u_assessment_treat_definition
where definition_id in (select definition_id
FROM u_assessment_treat_definition
where assessment_id = @From_assessment_id
and user_id = @From_user_id)
and definition_id = identity_id

select @Count =  count(*) from @tmp_u_assessment_treat_def_attrib
--select @Count
--Select * from @tmp_u_assessment_treat_def_attrib

declare this_curse2 CURSOR FOR 
	select attribute_sequence
	from @tmp_u_assessment_treat_def_attrib
set @new_incr = 0

open this_curse2
while @count > 0
begin
fetch next from this_curse2 into @identity_id
Update @tmp_u_assessment_treat_def_attrib
set new_attribute_sequence = @nextidentval + @new_incr
where attribute_sequence = @identity_id
set @new_incr = @new_incr + 1
set @count = @count - 1
end
close this_curse2
deallocate this_curse2
--Select * from @tmp_u_assessment_treat_def_attrib

--SET IDENTITY_INSERT u_assessment_treat_definition ON
SELECT @checkidentval = MAX(IDENTITYCOL) + IDENT_INCR('u_assessment_treat_definition')
   FROM u_assessment_treat_definition
SELECT @attcheckidentval = MAX(IDENTITYCOL) + IDENT_INCR('u_assessment_treat_def_attrib')
   FROM u_assessment_treat_def_attrib

IF  @checkidentval =  @nextidentval AND @attcheckidentval = @attnextidentval
BEGIN
Insert into u_assessment_treat_definition
	(
	--definition_id,
	assessment_id,
        treatment_type,
        treatment_description,
        workplan_id,
        followup_workplan_id,
        user_id,
        sort_sequence,
        instructions,
        parent_definition_id,
        child_flag
        )
SELECT --new_definition_id,
	assessment_id,
        treatment_type,
        treatment_description,
        workplan_id,
        followup_workplan_id,
        user_id,
        sort_sequence,
        instructions,
        parent_definition_id,
        child_flag
FROM @tmp_u_assessment_treat_definition
--SET IDENTITY_INSERT u_assessment_treat_definition OFF

--SET IDENTITY_INSERT u_assessment_treat_def_attrib ON

INSERT INTO u_assessment_treat_def_attrib
	(
	definition_id  ,
	--attribute_sequence ,
	attribute   ,
	value 
	)
Select  new_definition_id,
	--new_attribute_sequence,
	attribute,
	value
FROM @tmp_u_assessment_treat_def_attrib
END
--SET IDENTITY_INSERT u_assessment_treat_def_attrib OFF

Select 
		assessment_id,
                treatment_type,
                treatment_description,
                workplan_id,
                followup_workplan_id,
                user_id,
                sort_sequence,
                instructions,
                parent_definition_id,
                child_flag
FROM u_assessment_treat_definition
where assessment_id = @To_assessment_id
and user_id = @To_user_id
GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_treatment_list]
	TO [cprsystem]
GO

