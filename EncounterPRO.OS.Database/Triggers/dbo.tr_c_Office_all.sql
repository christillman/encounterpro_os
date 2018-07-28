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

-- Drop Trigger [dbo].[tr_c_Office_all]
Print 'Drop Trigger [dbo].[tr_c_Office_all]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Office_all]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_Office_all]
GO

-- Create Trigger [dbo].[tr_c_Office_all]
Print 'Create Trigger [dbo].[tr_c_Office_all]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_Office_all ON dbo.c_Office
FOR INSERT, UPDATE
AS

DECLARE @ll_pms_owner_id int,
		@ls_office_id varchar(4), 
		@ls_billing_id varchar(24),
		@ls_user_id varchar(24),
		@ls_created_by varchar(24)


IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(billing_id)
	BEGIN
	SET @ls_created_by = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

	SELECT 	@ll_pms_owner_id = send_via_addressee
	FROM c_Document_Route
	WHERE document_route = dbo.fn_get_global_preference('Preferences', 'default_billing_system')

	IF @@ROWCOUNT = 1
		BEGIN
		DECLARE lc_mappings CURSOR LOCAL FAST_FORWARD FOR
			SELECT i.office_id, i.billing_id, u.user_id
			FROM inserted i
				INNER JOIN deleted d
				ON i.office_id = d.office_id
				INNER JOIN c_User u
				ON i.office_id = u.office_id
			WHERE i.billing_id IS NOT NULL
			AND u.actor_class = 'Office'
			AND u.status = 'OK'
			AND ISNULL(d.billing_id, '!NULL') <> ISNULL(i.billing_id, '!NULL')

		OPEN lc_mappings

		FETCH lc_mappings INTO @ls_office_id, @ls_billing_id, @ls_user_id
		WHILE @@FETCH_STATUS = 0
			BEGIN
			
			EXECUTE jmj_Set_User_IDValue	@ps_user_id = @ls_user_id,
											@pl_owner_id = @ll_pms_owner_id,
											@ps_IDDomain = 'FacilityID',
											@ps_IDValue = @ls_billing_id,
											@ps_created_by = @ls_created_by

			FETCH lc_mappings INTO @ls_office_id, @ls_billing_id, @ls_user_id
			END

		END

	END

GO

