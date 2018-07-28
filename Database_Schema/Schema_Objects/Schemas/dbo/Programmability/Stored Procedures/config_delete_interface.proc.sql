CREATE PROCEDURE config_delete_interface (
	@pl_interfaceServiceId int)
AS

DECLARE @ll_customer_id int,
		@ll_owner_id int,
		@ll_error int,
		@ll_rowcount int,
		@ls_document_route varchar(24)

IF @ll_rowcount = 0
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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
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

