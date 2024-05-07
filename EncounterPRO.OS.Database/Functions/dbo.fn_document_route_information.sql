--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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

-- Set everything from client if there is no server
IF NOT EXISTS(SELECT 1
				FROM o_Computers
				WHERE status = 'SERVER'
				AND last_connected_date > DATEADD(DAY, -7, dbo.get_client_datetime())
			)
	UPDATE @route_info
	SET send_from = 'Client'

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	RETURN

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_send_via_addressee = send_via_addressee,
		@ls_document_type = document_type
FROM @route_info

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
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
GRANT SELECT
	ON [dbo].[fn_document_route_information]
	TO [cprsystem]
GO

