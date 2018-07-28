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

-- Drop Procedure [dbo].[jmj_document_set_recipient]
Print 'Drop Procedure [dbo].[jmj_document_set_recipient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_document_set_recipient]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_document_set_recipient]
GO

-- Create Procedure [dbo].[jmj_document_set_recipient]
Print 'Create Procedure [dbo].[jmj_document_set_recipient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_document_set_recipient (
	@pl_patient_workplan_item_id int,
	@ps_ordered_for varchar(24),
	@ps_dispatch_method varchar(24),
	@ps_address_attribute varchar(64),
	@ps_address_value varchar(255),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ls_last_ordered_for varchar(24),
		@ls_last_dispatch_method varchar(24),
		@ll_last_attachment_id int,
		@ls_cpr_id varchar(12),
		@ls_status varchar(12),
		@ll_error int,
		@ll_rowcount int

SELECT @ls_last_ordered_for = ordered_for,
		@ls_last_dispatch_method = dispatch_method,
		@ll_last_attachment_id = attachment_id,
		@ls_cpr_id = cpr_id,
		@ls_status = status
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('Document record not found (%d)',16,-1, @pl_patient_workplan_item_id)
	RETURN -1
	END

IF ISNULL(@ls_last_ordered_for, '!NULL') <> ISNULL(@ps_ordered_for, '!NULL')
	OR ISNULL(@ls_last_dispatch_method, '!NULL') <> ISNULL(@ps_dispatch_method, '!NULL')
	BEGIN
	UPDATE p_Patient_WP_Item
	SET ordered_for = @ps_ordered_for,
		dispatch_method = @ps_dispatch_method,
		attachment_id = NULL -- Null out any existing attachment because it will need to be recreated
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	IF @ll_last_attachment_id > 0
		BEGIN
		-- Delete the existing attachment because it is no longer valid
		EXECUTE [dbo].[sp_set_attachment_progress] 
		   @ps_cpr_id = @ls_cpr_id
		  ,@pl_attachment_id = @ll_last_attachment_id
		  ,@pl_patient_workplan_item_id = @pl_patient_workplan_item_id
		  ,@ps_user_id = @ps_user_id
		  ,@ps_progress_type = 'DELETED'
		  ,@ps_progress = 'Attachment Deleted'
		  ,@ps_created_by = @ps_created_by

		-- Null out the attachment_id for this document
		EXEC sp_add_workplan_item_attribute
			@ps_cpr_id = @ls_cpr_id,
			@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
			@ps_attribute = 'attachment_id',
			@ps_value = NULL,
			@ps_user_id = @ps_user_id,
			@ps_created_by = @ps_created_by
		END

	END

-- If an address attribute was passed in then set it
IF LEN(@ps_address_attribute) > 0 AND LEN(@ps_address_value) > 0
	BEGIN
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ls_cpr_id,
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_attribute = @ps_address_attribute,
		@ps_value = @ps_address_value,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by
	END

RETURN 1
GO
GRANT EXECUTE
	ON [dbo].[jmj_document_set_recipient]
	TO [cprsystem]
GO

