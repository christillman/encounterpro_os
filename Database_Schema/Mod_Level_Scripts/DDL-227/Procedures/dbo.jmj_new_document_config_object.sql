﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_new_document_config_object]
Print 'Drop Procedure [dbo].[jmj_new_document_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_document_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_document_config_object]
GO

-- Create Procedure [dbo].[jmj_new_document_config_object]
Print 'Create Procedure [dbo].[jmj_new_document_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_document_config_object (
	@ps_config_object_type varchar(24) ,
	@ps_description varchar(80) ,
	@ps_context_object varchar(24) ,
	@ps_component_id varchar(24) ,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) ,
	@ps_long_description varchar(max) = NULL ,
	@ps_report_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int,
		@ll_owner_id int,
		@ls_report_component_id varchar(24),
		@ls_document_format varchar(24)

-- The report component for document config objects is always RPT_Document
SET @ls_report_component_id = 'RPT_Document'

SET @ll_return = 1

SET @ps_report_id = CAST(newid() AS varchar(40))

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SET @ls_document_format = 'Machine'

IF @ps_status IS NULL
	SET @ps_status = 'OK'

INSERT INTO c_Report_Definition (
	report_id,
	description,
	report_type,
	component_id,
	status,
	owner_id,
	last_updated,
	document_format,
	config_object_type,
	id,
	long_description)
VALUES (
	@ps_report_id,
	@ps_description,
	@ps_context_object,
	@ls_report_component_id,
	@ps_status,
	@ll_owner_id,
	dbo.get_client_datetime(),
	@ls_document_format,
	@ps_config_object_type,
	newid(),
	@ps_long_description )

IF @@ERROR <> 0
	RETURN -1


-- Now add the document component as an attribute to the report definition
INSERT INTO c_Report_Attribute (
	report_id,
	attribute,
	value,
	component_attribute,
	component_id)
SELECT @ps_report_id,
	'document_component_id',
	@ps_component_id,
	'Y',
	id
FROM c_Component_Registry
WHERE component_id = @ls_report_component_id

IF @@ERROR <> 0
	RETURN -1


RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_document_config_object]
	TO [cprsystem]
GO

