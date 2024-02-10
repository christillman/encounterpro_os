
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_actor_route_purposes]
Print 'Drop Function [dbo].[fn_actor_route_purposes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_actor_route_purposes]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_actor_route_purposes]
GO

-- Create Function [dbo].[fn_actor_route_purposes]
Print 'Create Function [dbo].[fn_actor_route_purposes]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_actor_route_purposes (
	@ps_user_id varchar(24),
	@ps_document_route varchar(24) )

RETURNS @purpose TABLE (
	[document_route] [varchar] (24) NOT NULL,
	[purpose] [varchar](40) NOT NULL,
	[allow_flag] [char](1) NOT NULL )
AS

BEGIN

DECLARE @ll_actor_id int

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_user_id

-- If no route was passed in then return all routes
IF @ps_document_route IS NULL
	INSERT INTO @purpose (
			document_route,
			purpose,
			allow_flag )
	SELECT	r.document_route,
			p.purpose,
			COALESCE(rp.allow_flag, 'Y')
	FROM c_Document_Purpose p
		CROSS JOIN c_Document_Route r
		LEFT OUTER JOIN dbo.c_Actor_Route_Purpose rp
		ON p.purpose = rp.purpose
		AND rp.actor_id = @ll_actor_id
		AND rp.document_route = @ps_document_route
		AND rp.current_flag = 'Y'
ELSE
	INSERT INTO @purpose (
			document_route,
			purpose,
			allow_flag )
	SELECT @ps_document_route,
			p.purpose,
			COALESCE(rp.allow_flag, 'Y')
	FROM c_Document_Purpose p
		LEFT OUTER JOIN dbo.c_Actor_Route_Purpose rp
		ON p.purpose = rp.purpose
		AND rp.actor_id = @ll_actor_id
		AND rp.document_route = @ps_document_route
		AND rp.current_flag = 'Y'

RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_actor_route_purposes]
	TO [cprsystem]
GO

