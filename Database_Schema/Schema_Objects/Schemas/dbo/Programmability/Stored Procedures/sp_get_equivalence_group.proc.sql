CREATE PROCEDURE sp_get_equivalence_group
	(
	@ps_object_id varchar(40),
	@ps_object_type varchar(32),
	@ps_description varchar(80),
	@ps_created_by varchar(24)
	)
AS

DECLARE @ll_equivalence_group_id int,
		@lu_object_id uniqueidentifier

SET @lu_object_id = CAST(@ps_object_id AS uniqueidentifier)
IF @@ERROR <> 0
	RETURN -1

-- See if this object is already a member of an equivalence group
SELECT @ll_equivalence_group_id = equivalence_group_id
FROM c_Equivalence
WHERE object_id = @lu_object_id

IF @@ROWCOUNT = 0
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
	getdate(),
	@ps_created_by )

SET @ll_equivalence_group_id = SCOPE_IDENTITY()

-- This object as the first item in the newly created equivalence group so make it primary
UPDATE c_Equivalence
SET primary_flag = 'Y',
	equivalence_group_id = @ll_equivalence_group_id
WHERE object_id = @lu_object_id

RETURN @ll_equivalence_group_id
