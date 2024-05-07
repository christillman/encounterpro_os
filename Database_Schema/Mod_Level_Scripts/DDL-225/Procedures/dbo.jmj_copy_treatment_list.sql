
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
			AND [user_id] = @To_user_id
			AND created > DATEADD(ss, -20, dbo.get_client_datetime()) )
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
		and [user_id] = @To_user_id
	RETURN
	END

-- Clean up orphans in the "From" assessment
DELETE d
FROM u_assessment_treat_definition d
WHERE assessment_id = @From_assessment_id
AND [user_id] = @From_user_id
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
and [user_id] = @From_user_id

--another cleanup issue that is a bug in the delete composite functionality.!
DELETE from u_assessment_treat_definition WHERE parent_definition_id IN
(SELECT distinct parent_definition_id FROM u_assessment_treat_definition
WHERE parent_definition_id IS NOT NULL
AND parent_definition_id not in
(SELECT definition_id FROM u_assessment_treat_definition))
AND assessment_id = @From_assessment_id
and [user_id] = @From_user_id


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
and [user_id] = @From_user_id
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
FROM u_assessment_treat_def_attrib
JOIN @tmp_u_assessment_treat_definition ON definition_id = identity_id
where definition_id in (select definition_id
FROM u_assessment_treat_definition
where assessment_id = @From_assessment_id
and [user_id] = @From_user_id)

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
and [user_id] = @To_user_id
GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_treatment_list]
	TO [cprsystem]
GO

