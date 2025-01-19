
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_route_information]
Print 'Drop Function [dbo].[fn_document_route_information]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_route_information]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_route_information]
GO

-- Create Function [dbo].[fn_document_route_information]
Print 'Create Function [dbo].[fn_document_route_information]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_document_route_information (
	@ps_document_route varchar(24))

RETURNS @route_info TABLE (
	[document_route] [varchar](24) NOT NULL,
	[sent_status] [varchar](12) NOT NULL ,
	[sending_status] [varchar](12) NOT NULL ,
	[send_from] [varchar](12) NOT NULL ,
	[status] [varchar](12) NOT NULL ,
	[owner_id] [int] NOT NULL ,
	[last_updated] [datetime] NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[document_format] [varchar](24) NOT NULL ,
	[sender_id_key] [varchar](40) NULL,
	[receiver_id_key] [varchar](40) NULL,
	[send_via_addressee] [int] NULL,
	[document_type] [varchar](255) NULL,
	[communication_type] [varchar](24) NULL,
	[transportsequence] [int] NULL,
	[sender_component_id] [varchar] (24) NULL )

AS
BEGIN

DECLARE @ll_rowcount int,
		@ll_error int,
		@ll_send_via_addressee int,
		@ls_document_type varchar(255),
		@ll_transportsequence int,
		@ll_customer_id int

INSERT INTO @route_info (
	[document_route] ,
	[sent_status] ,
	[sending_status] ,
	[send_from] ,
	[status] ,
	[owner_id] ,
	[last_updated] ,
	[id] ,
	[document_format] ,
	[sender_id_key] ,
	[receiver_id_key] ,
	[send_via_addressee] ,
	[document_type] ,
	[sender_component_id] ,
	[communication_type] )
SELECT 	[document_route] ,
	[sent_status] ,
	[sending_status] ,
	[send_from] ,
	[status] ,
	[owner_id] ,
	[last_updated] ,
	[id] ,
	[document_format] ,
	[sender_id_key] ,
	[receiver_id_key] ,
	[send_via_addressee] ,
	[document_type] ,
	[sender_component_id] ,
	[communication_type] 
FROM c_Document_Route
WHERE document_route = @ps_document_route

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	RETURN

-- Set everything from client if there is no server
IF NOT EXISTS(SELECT 1
				FROM o_Computers
				WHERE status = 'SERVER'
				AND last_connected_date > DATEADD(DAY, -7, getdate())
			)
	UPDATE @route_info
	SET send_from = 'Client'

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_send_via_addressee = send_via_addressee,
		@ls_document_type = document_type
FROM @route_info

IF @@ERROR <> 0
	RETURN

SELECT @ll_transportsequence = min(transportsequence)
FROM c_component_interface_route
WHERE subscriber_owner_id = @ll_customer_id
AND interfaceserviceid = @ll_send_via_addressee
AND direction = 'O'
AND (@ls_document_type IS NULL OR documenttype = @ls_document_type)

IF @ll_transportsequence > 0
	UPDATE x
	SET transportsequence = r.transportsequence,
		sender_component_id = r.commcomponent
	FROM @route_info x
		INNER JOIN c_Component_Interface_Route r
		ON x.send_via_addressee = r.interfaceserviceid
	WHERE r.subscriber_owner_id = @ll_customer_id
	AND r.transportsequence = @ll_transportsequence


RETURN
END
GO
GRANT SELECT ON [dbo].[fn_document_route_information] TO [cprsystem]
GO

