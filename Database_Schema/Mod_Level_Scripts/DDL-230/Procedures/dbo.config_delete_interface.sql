
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_delete_interface]
Print 'Drop Procedure [dbo].[config_delete_interface]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_delete_interface]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_delete_interface]
GO

-- Create Procedure [dbo].[config_delete_interface]
Print 'Create Procedure [dbo].[config_delete_interface]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_delete_interface (
	@pl_interfaceServiceId int)
AS

DECLARE @ll_customer_id int,
		@ll_owner_id int,
		@ls_document_route varchar(24)

IF @pl_interfaceServiceId IS NULL
	BEGIN
	RAISERROR('NULL InterfaceServiceID', 16, -1)
	RETURN
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_owner_id = owner_id,
		@ls_document_route = document_route
FROM dbo.c_Component_Interface
WHERE interfaceServiceId = @pl_interfaceServiceId

IF @@ERROR <> 0
	RETURN

IF @ll_owner_id IS NULL
	BEGIN
	RAISERROR('InterfaceServiceID not found (%d)', 16, -1, @pl_interfaceServiceId)
	RETURN
	END

IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR('InterfaceServiceID is not locally owned (%d)', 16, -1, @pl_interfaceServiceId)
	RETURN
	END

-- First delete the document_route records for the transports
DELETE r
FROM c_Document_Route r
	INNER JOIN dbo.c_component_interface_route t
	ON r.document_route = @ls_document_route + '.' + t.document_route_suffix

-- Delete the document_route record for the interface
DELETE r
FROM c_Document_Route r
WHERE send_via_addressee = @pl_interfaceServiceId

DELETE t
FROM dbo.c_component_interface_route t
WHERE ownerid = @ll_customer_id
AND interfaceServiceId = @pl_interfaceServiceId

DELETE i
FROM dbo.c_component_interface i
WHERE owner_id = @ll_customer_id
AND interfaceServiceId = @pl_interfaceServiceId

GO
GRANT EXECUTE
	ON [dbo].[config_delete_interface]
	TO [cprsystem]
GO

