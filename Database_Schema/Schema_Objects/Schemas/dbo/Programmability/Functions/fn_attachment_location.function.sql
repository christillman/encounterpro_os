CREATE FUNCTION [dbo].[fn_attachment_location] (
	@ps_assignment_code varchar(12)
	)

RETURNS @attachment_location TABLE (
	[attachment_location_id] [int] NOT NULL,
	[attachment_server] [varchar](128) NOT NULL,
	[attachment_share] [varchar](128) NOT NULL
	)
AS

BEGIN


IF @ps_assignment_code IS NOT NULL
	INSERT INTO @attachment_location (
		attachment_location_id,
		attachment_server,
		attachment_share)
	SELECT TOP 1 attachment_location_id,
				attachment_server,
				attachment_share
	FROM c_Attachment_Location
	WHERE assignment_code = @ps_assignment_code
	AND status = 'OK'
	ORDER BY sort_sequence, attachment_location_id

IF NOT EXISTS (SELECT 1 FROM @attachment_location)
	INSERT INTO @attachment_location (
		attachment_location_id,
		attachment_server,
		attachment_share)
	SELECT TOP 1 attachment_location_id,
				attachment_server,
				attachment_share
	FROM c_Attachment_Location
	WHERE assignment_code IS NULL
	AND status = 'OK'
	ORDER BY sort_sequence, attachment_location_id


RETURN

END

