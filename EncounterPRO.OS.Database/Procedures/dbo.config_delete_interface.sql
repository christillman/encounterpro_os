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
SET QUOTED_IDENTIFIER OFF
GO
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

GO
GRANT EXECUTE
	ON [dbo].[config_delete_interface]
	TO [cprsystem]
GO

