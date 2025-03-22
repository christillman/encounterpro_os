
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_delete_equivalence_item]
Print 'Drop Procedure [dbo].[jmj_delete_equivalence_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_delete_equivalence_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_delete_equivalence_item]
GO

-- Create Procedure [dbo].[jmj_delete_equivalence_item]
Print 'Create Procedure [dbo].[jmj_delete_equivalence_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_delete_equivalence_item (
	@pl_equivalence_group_id int ,
	@ps_object_id varchar(40) = NULL,
	@ps_object_key varchar(24) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ls_object_type varchar(32),
		@lu_object_id uniqueidentifier,
		@ll_other_equivalence_group_id int

IF @ps_object_key IS NULL
	BEGIN
	RAISERROR ('object_key cannot be null', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

SELECT @ls_object_type = object_type
FROM c_Equivalence_Group
WHERE equivalence_group_id = @pl_equivalence_group_id

IF @ls_object_type IS NULL
	BEGIN
	RAISERROR ('Equivalence Group ID Not Found', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE c_Equivalence
SET equivalence_group_id = NULL,
	primary_flag = 'N'
WHERE object_type = @ls_object_type
AND object_key = @ps_object_key


GO
GRANT EXECUTE
	ON [dbo].[jmj_delete_equivalence_item]
	TO [cprsystem]
GO

