
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure dbo.sp_copy_assessment_treat_definition
Print 'Drop Procedure dbo.sp_copy_assessment_treat_definition'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.sp_copy_assessment_treat_definition') AND [type]='P'))
DROP PROCEDURE dbo.sp_copy_assessment_treat_definition
GO

-- Create Procedure dbo.sp_copy_assessment_treat_definition
Print 'Create Procedure dbo.sp_copy_assessment_treat_definition'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_copy_assessment_treat_definition (
	-- same definitions as the columns we are inserting into
	-- notice variables need to be prefixed with @,
	@user_id_copy_to varchar(24),
	@user_id_copy_from varchar(24),
	@treatment_type varchar(24),
	@assessment_id varchar(24)
)
AS BEGIN

	INSERT INTO u_assessment_treat_definition 
	(assessment_id,treatment_type, treatment_description,[user_id])
	SELECT assessment_id,treatment_type, treatment_description,@user_id_copy_to
	FROM u_assessment_treat_definition
	WHERE [user_id]=@user_id_copy_from
	And treatment_type=@treatment_type
	and assessment_id=@assessment_id

	INSERT INTO [u_assessment_treat_def_attrib] 
	([definition_id]
      ,[attribute_sequence]
      ,[attribute]
      ,[value]
      ,[long_value])
	SELECT a.[definition_id]
      ,[attribute_sequence]
      ,[attribute]
      ,[value]
      ,[long_value]
	FROM [u_assessment_treat_def_attrib] a
	JOIN u_assessment_treat_definition t ON a.definition_id = t.definition_id
	WHERE [user_id]=@user_id_copy_from
	And treatment_type=@treatment_type
	and assessment_id=@assessment_id

	-- print + 'Inserted ' + convert(varchar(10), @@rowcount) + ' rows for <' + @assessment_id + '>'
END
GO

