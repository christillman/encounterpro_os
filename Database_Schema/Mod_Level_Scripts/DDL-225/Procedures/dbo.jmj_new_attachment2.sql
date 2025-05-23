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

-- Drop Procedure [dbo].[jmj_new_attachment2]
Print 'Drop Procedure [dbo].[jmj_new_attachment2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_attachment2]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_attachment2]
GO

-- Create Procedure [dbo].[jmj_new_attachment2]
Print 'Create Procedure [dbo].[jmj_new_attachment2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_attachment2 (
	@ps_description varchar(80),
	@ps_attachment_file varchar(128),
	@ps_extension varchar(24),
	@pl_owner_id int = NULL,
	@pl_box_id int = NULL,
	@pl_item_id int = NULL,
	@pl_interfaceserviceid int,
	@pl_transportsequence int,
	@pl_patient_workplan_item_id int,
	@ps_attached_by varchar(24),
	@ps_created_by varchar(24),
	@ps_id varchar(40) = NULL )
AS

-- This procedure creates an empty attachment record and returns the attachment_id to the caller.
-- The caller should post the attachment binary into the attachment_image column, and then 
-- call the stored procedure "jmj_set_incoming_attachment_ready"

DECLARE @ll_attachment_id int,
		@ll_error int,
		@ll_rowcount int,
		@luo_id uniqueidentifier

IF @ps_id IS NULL
	SET @luo_id = newid()
ELSE
	SET @luo_id = CAST(@ps_id AS uniqueidentifier)


INSERT INTO p_Attachment (
	attachment_tag ,
	attachment_file ,
	extension ,
	owner_id ,
	box_id ,
	item_id ,
	interfaceserviceid ,
	transportsequence ,
	patient_workplan_item_id ,
	status ,
	attachment_date,
	storage_flag,
	attached_by ,
	created_by,
	id )
VALUES (
	@ps_description ,
	@ps_attachment_file ,
	@ps_extension ,
	@pl_owner_id ,
	@pl_box_id ,
	@pl_item_id ,
	@pl_interfaceserviceid ,
	@pl_transportsequence ,
	@pl_patient_workplan_item_id ,
	'New',
	dbo.get_client_datetime(),
	'D',
	@ps_attached_by ,
	@ps_created_by,
	@luo_id )

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

SET @ll_attachment_id = SCOPE_IDENTITY()

RETURN @ll_attachment_id



GO
GRANT EXECUTE
	ON [dbo].[jmj_new_attachment2]
	TO [cprsystem]
GO

