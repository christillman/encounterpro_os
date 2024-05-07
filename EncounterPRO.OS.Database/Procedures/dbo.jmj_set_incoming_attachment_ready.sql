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

-- Drop Procedure [dbo].[jmj_set_incoming_attachment_ready]
Print 'Drop Procedure [dbo].[jmj_set_incoming_attachment_ready]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_incoming_attachment_ready]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_incoming_attachment_ready]
GO

-- Create Procedure [dbo].[jmj_set_incoming_attachment_ready]
Print 'Create Procedure [dbo].[jmj_set_incoming_attachment_ready]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_incoming_attachment_ready (
	@pl_attachment_id int,
	@pl_interfaceserviceid int,
	@pl_transportsequence int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	)
AS

-- This procedure sets the status of an attachment to 'OK' and creates an 'Incoming' workflow record
-- in p_Patient_WP_Item table.

DECLARE @ll_error int,
		@ll_rowcount int,
		@ll_patient_workplan_item_id int,
		@ls_document_user_id varchar(24),
		@ls_status varchar(12),
		@ls_description varchar(80)

IF @pl_attachment_id IS NULL
	BEGIN
	RAISERROR('Attachment_id is NULL', 16, -1)
	RETURN -1
	END

SET @ls_document_user_id = dbo.fn_get_global_preference('SYSTEM', 'Document Server user_id')
IF @ls_document_user_id IS NULL
	SET @ls_document_user_id = '#JMJ'

SELECT @ls_status = status, 
		@ls_description = attachment_tag
FROM p_Attachment
WHERE attachment_id = @pl_attachment_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 0
	BEGIN
	RAISERROR('Attachment_id not found (%d)', 16, -1, @pl_attachment_id)
	RETURN -1
	END

IF @ls_status <> 'New'
	BEGIN
	RAISERROR('Attachment status is not ''New'' (%d)', 16, -1, @pl_attachment_id)
	RETURN -1
	END

BEGIN TRANSACTION


INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	item_number,
	item_type,
	description,
	attachment_id,
	ordered_by,
	ordered_for,
	status,
	created_by)
VALUES	(
	0,
	@pl_interfaceserviceid,  -- repurposeing workplan_id and item_number to hold the interface/route that this document came through
	@pl_transportsequence,
	'Incoming',
	@ls_description,
	@pl_attachment_id,
	@ps_user_id,
	@ls_document_user_id,
	'Ready',
	@ps_created_by )


SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ll_patient_workplan_item_id = SCOPE_IDENTITY()

INSERT INTO p_Attachment_Progress (
	attachment_id,
	patient_workplan_item_id,
	user_id,
	progress_date_time,
	progress_type,
	created,
	created_by )
VALUES (
	@pl_attachment_id,
	@ll_patient_workplan_item_id,
	@ps_user_id,
	dbo.get_client_datetime(),
	'Incoming',
	dbo.get_client_datetime(),
	@ps_created_by )

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

RETURN 1



GO
GRANT EXECUTE
	ON [dbo].[jmj_set_incoming_attachment_ready]
	TO [cprsystem]
GO

