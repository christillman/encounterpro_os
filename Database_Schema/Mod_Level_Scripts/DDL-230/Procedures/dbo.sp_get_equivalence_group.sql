
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_equivalence_group]
Print 'Drop Procedure [dbo].[sp_get_equivalence_group]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_equivalence_group]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_equivalence_group]
GO

-- Create Procedure [dbo].[sp_get_equivalence_group]
Print 'Create Procedure [dbo].[sp_get_equivalence_group]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_equivalence_group
	(
	@ps_object_id varchar(40),
	@ps_object_type varchar(32),
	@ps_description varchar(80),
	@ps_created_by varchar(24)
	)
AS

DECLARE @ll_equivalence_group_id int,
		@lu_object_id uniqueidentifier,
		@ls_object_type varchar(24)

SET @lu_object_id = CAST(@ps_object_id AS uniqueidentifier)
IF @@ERROR <> 0
	RETURN -1

-- See if this object is already a member of an equivalence group
SELECT @ll_equivalence_group_id = equivalence_group_id,
	@ls_object_type = object_type
FROM c_Equivalence
WHERE object_id = @lu_object_id

IF @ls_object_type IS NULL
	BEGIN
	RAISERROR ('object not found (%s)', 16, 1, @ps_object_id)
	RETURN -1
	END

-- If we found the object as a member of a group, return the group id
IF @ll_equivalence_group_id > 0
	RETURN @ll_equivalence_group_id

-- If this object is not already a member of an equivalence group, then create a new group
INSERT INTO c_Equivalence_Group (
	[object_type] ,
	[description],
	[created] ,
	[created_by] )
VALUES (
	@ps_object_type ,
	@ps_description ,
	dbo.get_client_datetime(),
	@ps_created_by )

SET @ll_equivalence_group_id = SCOPE_IDENTITY()

-- This object as the first item in the newly created equivalence group so make it primary
UPDATE c_Equivalence
SET primary_flag = 'Y',
	equivalence_group_id = @ll_equivalence_group_id
WHERE object_id = @lu_object_id

RETURN @ll_equivalence_group_id
GO
GRANT EXECUTE
	ON [dbo].[sp_get_equivalence_group]
	TO [cprsystem]
GO

