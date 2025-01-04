
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_get_document_potential_routes]
Print 'Drop Procedure [dbo].[jmj_get_document_potential_routes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_document_potential_routes]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_document_potential_routes]
GO

-- Create Procedure [dbo].[jmj_get_document_potential_routes]
Print 'Create Procedure [dbo].[jmj_get_document_potential_routes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_get_document_potential_routes (
	@ps_report_id varchar(40),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24))
AS
-- Unused 2025-01-01
DECLARE @lui_report_id uniqueidentifier,
	@ll_error int,
	@ll_rowcount int,
	@ll_ordered_by_actor_id int,
	@ll_ordered_for_actor_id int

DECLARE @reports TABLE (
	report_id uniqueidentifier NOT NULL)

DECLARE @routes TABLE (
	document_route varchar(24) NOT NULL,
	document_format varchar(24) NOT NULL,
	communication_type varchar(24) NULL,
	sender_id_key varchar(40) NULL,
	receiver_id_key varchar(40) NULL,
	is_valid bit NOT NULL DEFAULT (1)
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

IF LEN(@ps_report_id) >= 36
	BEGIN
	SET @lui_report_id = CAST(@ps_report_id AS uniqueidentifier)
	
	-- Add the called report
	INSERT INTO @reports (
		report_id )
	VALUES (
		@lui_report_id )

	-- Add all the reports linked from the called report
	INSERT INTO @reports (
		report_id )
	SELECT CAST(value AS uniqueidentifier)
	FROM c_Report_Attribute
	WHERE report_id = @lui_report_id
	AND attribute LIKE '%report_id'
	AND LEN(value) >= 36
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
	INNER JOIN c_Report_Definition rd
	ON rd.document_format = cr.document_format
	INNER JOIN @reports r
	ON r.report_id = rd.report_id
WHERE cr.is_valid = 1


GO
GRANT EXECUTE
	ON [dbo].[jmj_get_document_potential_routes]
	TO [cprsystem]
GO

