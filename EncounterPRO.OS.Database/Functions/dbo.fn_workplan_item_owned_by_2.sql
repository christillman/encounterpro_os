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

-- Drop Function [dbo].[fn_workplan_item_owned_by_2]
Print 'Drop Function [dbo].[fn_workplan_item_owned_by_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_workplan_item_owned_by_2]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_workplan_item_owned_by_2]
GO

-- Create Function [dbo].[fn_workplan_item_owned_by_2]
Print 'Create Function [dbo].[fn_workplan_item_owned_by_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_workplan_item_owned_by_2 (
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int,
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_dispatch_method varchar(24))

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_owned_by varchar(24),
		@ls_attending_doctor varchar(24),
		@ls_user_status varchar(8),
		@ll_relation_sequence int,
		@ls_document_sender_user_id varchar(24)

SET @ls_owned_by = NULL


IF LEFT(@ps_ordered_for, 1) = '!'
	BEGIN
	SELECT @ls_user_status = 'ROLE'
	FROM c_Role
	WHERE role_id = @ps_ordered_for
	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ps_ordered_for = NULL
		SET @ls_user_status = 'UNKNOWN'
		END
	END
ELSE
	BEGIN
	SELECT @ls_user_status = user_status
	FROM c_User
	WHERE user_id = @ps_ordered_for
	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ps_ordered_for = NULL
		SET @ls_user_status = 'UNKNOWN'
		END
	END

IF (@ps_ordered_for IS NULL) OR (@ps_ordered_for = '#WORKPLAN_OWNER')
	BEGIN
	SELECT @ls_owned_by = owned_by
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id
	END
ELSE IF LEFT(@ps_ordered_for, 1) = '#'
	BEGIN
	SET @ls_owned_by = dbo.fn_special_user_resolution(@ps_ordered_for ,
													@ps_cpr_id ,
													@pl_encounter_id )

	IF @ls_owned_by IS NULL
		BEGIN
		IF @ps_ordered_for = '#DistList'
			SET @ls_owned_by = @ps_ordered_for
		END
	END


-- If we still don't have an owner, then make the ordered_for the owner if it's a valid workplan item owner
IF @ls_owned_by IS NULL and @ls_user_status IN ('OK', 'SYSTEM', 'ROLE')
	SET @ls_owned_by = @ps_ordered_for

-- If we still don't have an owner and the dispatch_method isn't local, then set the owner to the sending system user
IF @ls_owned_by IS NULL AND @ps_dispatch_method IS NOT NULL AND @ps_dispatch_method NOT IN ('Inbox', 'Tasks')
	BEGIN
	SET @ls_owned_by = dbo.fn_get_global_preference('SERVERCONFIG', 'Document Sender user_id')
	IF @ls_owned_by IS NULL
		SET @ls_owned_by = '#JMJ'
	END

-- And if all else fails, make the !Exception role the owner
IF @ls_owned_by IS NULL
	RETURN '!Exception'

RETURN @ls_owned_by 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_workplan_item_owned_by_2]
	TO [cprsystem]
GO

