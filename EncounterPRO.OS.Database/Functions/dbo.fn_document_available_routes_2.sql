
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_available_routes_2]
Print 'Drop Function [dbo].[fn_document_available_routes_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_available_routes_2]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_available_routes_2]
GO

-- Create Function [dbo].[fn_document_available_routes_2]
Print 'Create Function [dbo].[fn_document_available_routes_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_document_available_routes_2 (
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24),
	@ps_purpose varchar(40),
	@ps_cpr_id varchar(12) = NULL,
	@ps_report_id varchar(40) = NULL)

RETURNS @routes TABLE (
	document_route varchar(24) NOT NULL,
	sort_sequence int NULL,
	document_format varchar(24) NOT NULL,
	communication_type varchar(24) NULL,
	sender_id_key varchar(40) NULL,
	receiver_id_key varchar(40) NULL,
	is_valid bit NOT NULL DEFAULT (1),
	invalid_help varchar(255) NULL
	)
AS
BEGIN

DECLARE @ll_error int,
	@ll_rowcount int,
	@ll_ordered_by_actor_id int,
	@ll_ordered_for_actor_id int,
	@ls_ordered_by_actor_class varchar(24),
	@ls_ordered_for_actor_class varchar(24),
	@ll_format_count int,
	@ls_document_format varchar(24),
	@lui_report_id uniqueidentifier,
	@ls_ordered_for_user_id varchar(24),
	@ls_ordered_for_cpr_id varchar(12),
	@ll_encounter_id int  -- We actually don't know the encounter_id in this function.  Later we'll add it to the function params.

DECLARE @formats TABLE (
	document_format varchar(24) NOT NULL)

SELECT @ll_ordered_by_actor_id = actor_id,
		@ls_ordered_by_actor_class = actor_class
FROM c_User
WHERE [user_id] = @ps_ordered_by

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

SELECT @ll_ordered_for_actor_id = actor_id,
		@ls_ordered_for_actor_class = actor_class
FROM c_User
WHERE [user_id] = @ps_ordered_for

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN


SELECT 	@ls_ordered_for_user_id = user_id,
		@ls_ordered_for_actor_class = actor_class,
		@ll_ordered_for_actor_id = actor_id,
		@ls_ordered_for_cpr_id = cpr_id
FROM dbo.fn_document_recipient_info(@ps_ordered_for, @ps_cpr_id, @ll_encounter_id)

-- Get all the routes that are possibly available for this actor class
INSERT INTO @routes (
	document_route,
	document_format,
	communication_type,
	sender_id_key,
	receiver_id_key)
SELECT DISTINCT r.document_route,
	r.document_format,
	r.communication_type,
	r.sender_id_key,
	r.receiver_id_key
FROM c_Document_Route r
WHERE r.status = 'OK'
AND (send_via_addressee IS NULL
	OR send_via_addressee IN (SELECT interfaceserviceid FROM c_Component_Interface WHERE status = 'OK')
	)

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	-- If no routes are available, then at least allow a printer route
	INSERT INTO @routes (
		document_route,
		document_format,
		communication_type,
		sender_id_key,
		receiver_id_key)
	SELECT DISTINCT r.document_route,
		r.document_format,
		r.communication_type,
		r.sender_id_key,
		r.receiver_id_key
	FROM c_Document_Route r
	WHERE r.document_route = 'Printer'
	AND r.status = 'OK'
	END

-- Invalidate routes not available to the ordered_for users' actor_class
IF @ls_ordered_for_actor_class IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Route is not available for sending to a ' + @ls_ordered_for_actor_class
	FROM @routes r
	WHERE NOT EXISTS (
		SELECT 1
		FROM c_Actor_Class_Route cr
		WHERE r.document_route = cr.document_route
		AND cr.actor_class = @ls_ordered_for_actor_class
		AND cr.status = 'OK')
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END


-- Add some hard-coded rules
IF @ps_purpose = 'NewRX' and @ls_ordered_for_actor_class = 'Patient'
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Patient may not receive ' + @ps_purpose + ' documents via ' + r.document_route
	FROM @routes r
	WHERE r.document_route <> 'Printer'
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

-- Invalidate routes based on availability of communication_type
IF @ls_ordered_for_actor_class = 'Patient'
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Patient does not have a ' + communication_type + CASE WHEN communication_type IN ('Fax', 'Phone') THEN ' number' ELSE ' address' END
	FROM @routes r
	WHERE r.communication_type IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM dbo.fn_patient_communication(@ls_ordered_for_cpr_id) c
		WHERE r.communication_type = c.communication_type
		AND c.communication_value IS NOT NULL )
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END
ELSE IF @ll_ordered_for_actor_id IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Recipient does not have a ' + communication_type + CASE WHEN communication_type IN ('Fax', 'Phone') THEN ' number' ELSE ' address' END
	FROM @routes r
	WHERE r.communication_type IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM c_Actor_communication c
		WHERE c.actor_id = @ll_ordered_for_actor_id
		AND r.communication_type = c.communication_type
		AND c.communication_value IS NOT NULL )
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

-- Invalidate routes based on availability of receiver_id_key
IF @ls_ordered_for_user_id IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Recipient is not registered for ' + r.document_route + ' transactions'
	FROM @routes r
	WHERE r.receiver_id_key IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM c_User_Progress p
		WHERE p.user_id = @ls_ordered_for_user_id
		AND p.progress_type = 'ID'
		AND p.progress_key = r.receiver_id_key
		AND p.progress_value IS NOT NULL
		AND p.current_flag = 'Y' )
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

-- Invalidate routes based on availability of sender_id_key
IF @ps_ordered_by IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
		invalid_help = 'Sender is not registered for ' + r.document_route + ' transactions'
	FROM @routes r
	WHERE r.sender_id_key IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM c_User_Progress p
		WHERE p.user_id = @ps_ordered_by
		AND p.progress_type = 'ID'
		AND p.progress_key = r.sender_id_key
		AND p.progress_value IS NOT NULL
		AND p.current_flag = 'Y' )
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

-- If @ps_purpose is specified, then invalidate routes based on actor-route-purpose settings
IF @ps_purpose IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
	invalid_help = 'Recipient is not allowed to receive ' + @ps_purpose + ' transactions'
	FROM @routes r
		INNER JOIN dbo.fn_actor_route_purposes(@ls_ordered_for_user_id, NULL) rp
		ON rp.document_route = r.document_route
		AND rp.purpose = @ps_purpose
	WHERE rp.allow_flag = 'N'
	AND r.is_valid = 1

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

IF LEN(@ps_report_id) >= 36
	BEGIN
	SET @lui_report_id = CAST(@ps_report_id AS uniqueidentifier)
	
	-- Add the called report
	INSERT INTO @formats (
		document_format )
	SELECT DISTINCT document_format
	FROM c_Report_Definition
	WHERE report_id = @lui_report_id

	-- Add all the reports linked from the called report
	INSERT INTO @formats (
		document_format )
	SELECT DISTINCT r.document_format
	FROM c_Report_Attribute a
		INNER JOIN c_Report_Definition r
		ON r.report_id = CAST(a.value AS uniqueidentifier)
	WHERE a.report_id = @lui_report_id
	AND a.attribute LIKE '%report_id'
	AND LEN(a.value) >= 36
	AND r.document_format NOT IN (
		SELECT document_format
		 FROM @formats)
	END

SET @ll_format_count = (SELECT count(*) FROM @formats)
IF @ll_format_count = 1
	SET @ls_document_format = (SELECT document_format FROM @formats)
ELSE
	SET @ls_document_format = NULL -- Allow either document format


-- If @ps_purpose is specified, then invalidate routes based on actor-route-purpose settings
IF @ls_document_format IS NOT NULL
	BEGIN
	UPDATE r
	SET is_valid = 0,
	invalid_help = 'Only ' + LOWER(r.document_format) + ' readable documents may be sent via this route'
	FROM @routes r
	WHERE r.is_valid = 1
	AND r.document_format <> @ls_document_format

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END


RETURN
END
GO
GRANT SELECT
	ON [dbo].[fn_document_available_routes_2]
	TO [cprsystem]
GO

