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

-- Drop Function [dbo].[fn_practice_interfaces]
Print 'Drop Function [dbo].[fn_practice_interfaces]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_practice_interfaces]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_practice_interfaces]
GO

-- Create Function [dbo].[fn_practice_interfaces]
Print 'Create Function [dbo].[fn_practice_interfaces]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_practice_interfaces()

RETURNS @interfaces TABLE (
	owner_id int NOT NULL,
	interfaceServiceId int NOT NULL,
	interfacedescription varchar(80) NOT NULL,
	subscriber_owner_id int NOT NULL,
	interfaceServiceType varchar(80) NOT NULL,
	sortSequence int NOT NULL,
	description varchar(50) NOT NULL,
	document_route varchar(24) NULL,
	receive_flag char(1) NULL,
	send_flag char(1) NULL,
	serviceState varchar(20) NOT NULL,
	status varchar(12) NOT NULL,
	created datetime NOT NULL ,
	id uniqueidentifier NOT NULL ,
	last_updated datetime NOT NULL ,
	interfaceServiceType_description varchar(80) NULL ,
	interfaceServiceType_icon varchar(255) NULL
	)

AS
BEGIN

INSERT INTO @interfaces (
	owner_id ,
	interfaceServiceId ,
	interfacedescription ,
	subscriber_owner_id ,
	interfaceServiceType ,
	sortSequence ,
	description ,
	document_route ,
	receive_flag ,
	send_flag ,
	serviceState ,
	status ,
	created ,
	id ,
	last_updated ,
	interfaceServiceType_description ,
	interfaceServiceType_icon )
SELECT i.owner_id ,
	i.interfaceServiceId ,
	i.description ,
	i.subscriber_owner_id ,
	i.interfaceServiceType ,
	i.sortSequence ,
	i.description ,
	i.document_route ,
	i.receive_flag ,
	i.send_flag ,
	i.serviceState ,
	i.status ,
	i.created ,
	i.id ,
	i.last_updated ,
	d.domain_item_description ,
	d.domain_item_bitmap
FROM c_component_interface i
	LEFT OUTER JOIN c_Domain d
	ON d.domain_id = 'InterfaceServiceType'
	AND i.interfaceServiceType = d.domain_item

UPDATE x
SET interfaceServiceType_description = COALESCE(interfaceServiceType_description, interfaceServiceType),
	interfaceServiceType_icon = COALESCE(interfaceServiceType_icon, 'interface_bidirectional_icon.bmp')
FROM @interfaces x


DECLARE @suffix TABLE (
	interfaceserviceid int NOT NULL,
	suffix varchar(30) NULL)

DECLARE @ll_customer_id int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

INSERT INTO @suffix (
	interfaceserviceid,
	suffix)
SELECT interfaceserviceid,
	CASE status WHEN 'OK' THEN CASE owner_id WHEN @ll_customer_id THEN 'Local' ELSE '' END 
				ELSE CASE owner_id WHEN @ll_customer_id THEN 'Local, Disabled' ELSE 'Disabled' END END
FROM @interfaces

UPDATE x
SET interfacedescription = interfacedescription + ' (' + s.suffix + ')'
FROM @interfaces x
	INNER JOIN @suffix s
	ON x.interfaceserviceid = s.interfaceserviceid
WHERE LEN(s.suffix) > 0

RETURN
END
GO
GRANT SELECT ON [dbo].[fn_practice_interfaces] TO [cprsystem]
GO

