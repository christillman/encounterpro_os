
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_Set_Actor_Route_Purpose]
Print 'Drop Procedure [dbo].[jmj_Set_Actor_Route_Purpose]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_Set_Actor_Route_Purpose]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_Set_Actor_Route_Purpose]
GO

-- Create Procedure [dbo].[jmj_Set_Actor_Route_Purpose]
Print 'Create Procedure [dbo].[jmj_Set_Actor_Route_Purpose]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_Set_Actor_Route_Purpose (
	@ps_user_id varchar(24),
	@ps_document_route varchar(24),
	@ps_purpose varchar(40),
	@ps_allow_flag char(1),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_current_allow_flag char(1),
		@ll_actor_id int

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_user_id

SELECT @ls_current_allow_flag = allow_flag
FROM c_Actor_Route_Purpose
WHERE actor_id = @ll_actor_id
AND document_route = @ps_document_route
AND purpose = @ps_purpose
AND current_flag = 'Y'

IF @ps_allow_flag = @ls_current_allow_flag
	RETURN

INSERT INTO c_Actor_Route_Purpose
   ([actor_id]
   ,[document_route]
   ,[purpose]
   ,[allow_flag]
   ,[created_by])
VALUES (
	@ll_actor_id,
	@ps_document_route,
	@ps_purpose,
	@ps_allow_flag,
	@ps_created_by )

GO
GRANT EXECUTE
	ON [dbo].[jmj_Set_Actor_Route_Purpose]
	TO [cprsystem]
GO

