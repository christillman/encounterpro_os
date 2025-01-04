
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_obj_list_selection]
Print 'Drop Procedure [dbo].[sp_get_obj_list_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_obj_list_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_obj_list_selection]
GO

-- Create Procedure [dbo].[sp_get_obj_list_selection]
Print 'Create Procedure [dbo].[sp_get_obj_list_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_get_obj_list_selection (
	@ps_user_id varchar(24),
	@ps_root_category varchar(24),
	@ps_observation_id varchar(24) OUTPUT)
AS

SELECT @ps_observation_id = min(observation_id)
FROM c_Observation_Tree_Root
WHERE root_category = @ps_root_category


GO
GRANT EXECUTE
	ON [dbo].[sp_get_obj_list_selection]
	TO [cprsystem]
GO

