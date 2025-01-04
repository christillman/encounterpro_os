
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_delete_obs_definition]
Print 'Drop Procedure [dbo].[sp_delete_obs_definition]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_delete_obs_definition]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_delete_obs_definition]
GO

-- Create Procedure [dbo].[sp_delete_obs_definition]
Print 'Create Procedure [dbo].[sp_delete_obs_definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_delete_obs_definition (
	@ps_observation_id varchar(24) )
AS
UPDATE c_Observation
SET status = 'NA'
WHERE observation_id = @ps_observation_id
DELETE FROM u_Top_20
WHERE item_id = @ps_observation_id
AND top_20_code like 'TEST%'

GO
GRANT EXECUTE
	ON [dbo].[sp_delete_obs_definition]
	TO [cprsystem]
GO

