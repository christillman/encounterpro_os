﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_get_actor_document_routes]
Print 'Drop Procedure [dbo].[jmj_get_actor_document_routes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_actor_document_routes]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_actor_document_routes]
GO

-- Create Procedure [dbo].[jmj_get_actor_document_routes]
Print 'Create Procedure [dbo].[jmj_get_actor_document_routes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_get_actor_document_routes (
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24))
AS
-- Unused 2025-01-01 (called in commented code w_svc_documents.srw)
DECLARE @ll_error int,
		@ll_rowcount int,
		@ll_ordered_by_actor_id int,
		@ll_ordered_for_actor_id int

DECLARE @routes TABLE (
	document_route varchar(24) NOT NULL,
	document_format varchar(24) NOT NULL,
	communication_type varchar(24) NULL,
	sender_id_key varchar(40) NULL,
	receiver_id_key varchar(40) NULL
	)

IF @ps_ordered_for IS NULL
	BEGIN
	RAISERROR ('ordered_for cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_ordered_by_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_ordered_by

IF @@ERROR <> 0
	RETURN

IF @ll_ordered_by_actor_id IS NULL
	BEGIN
	RAISERROR ('ordered_by not found (%s)',16,-1, @ps_ordered_by)
	RETURN -1
	END

SELECT @ll_ordered_for_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_ordered_for

IF @@ERROR <> 0
	RETURN

IF @ll_ordered_for_actor_id IS NULL
	BEGIN
	RAISERROR ('ordered_for not found (%s)',16,-1, @ps_ordered_for)
	RETURN -1
	END

-- Get the routes availble to this users' actor_class
INSERT INTO @routes (
	document_route,
	document_format,
	communication_type,
	sender_id_key,
	receiver_id_key)
SELECT dr.document_route,
	dr.document_format,
	dr.communication_type,
	dr.sender_id_key,
	dr.receiver_id_key
FROM c_Actor_Class_Route r
	INNER JOIN c_User u
	ON r.actor_class = u.actor_class
	INNER JOIN c_Document_Route dr
	ON r.document_route = dr.document_route
WHERE u.user_id = @ps_ordered_for
AND r.status = 'OK'

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

-- If no routes specified, then list all routes
IF @ll_rowcount = 0
	INSERT INTO @routes (
		document_route,
		document_format,
		communication_type,
		sender_id_key,
		receiver_id_key)
	SELECT document_route,
		document_format,
		communication_type,
		sender_id_key,
		receiver_id_key
	FROM c_Document_Route r
	WHERE status = 'OK'



SELECT DISTINCT cr.document_route,
		cr.document_format,
		cr.communication_type,
		cr.sender_id_key,
		cr.receiver_id_key
FROM @routes cr


GO
GRANT EXECUTE
	ON [dbo].[jmj_get_actor_document_routes]
	TO [cprsystem]
GO

