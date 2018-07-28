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

-- Drop Trigger [dbo].[tr_c_user_update]
Print 'Drop Trigger [dbo].[tr_c_user_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_user_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_user_update]
GO

-- Create Trigger [dbo].[tr_c_user_update]
Print 'Create Trigger [dbo].[tr_c_user_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_user_update ON dbo.c_user
FOR UPDATE
AS

DECLARE @ll_pms_owner_id int,
		@ls_billing_id varchar(24),
		@ls_user_id varchar(24),
		@ls_created_by varchar(24),
		@ls_email_address varchar(64),
		@ll_actor_id int,
		@ls_dup_property varchar(80)

DECLARE @dupcheck TABLE (
	user_property varchar(80) NOT NULL,
	dup_count int NULL)

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(signature_stamp)
	BEGIN
	UPDATE u
	SET signature_stamp_filetype = 'bmp'
	FROM c_User u
		INNER JOIN inserted i
		ON u.user_id = i.user_id
	WHERE u.signature_stamp_filetype IS NULL
	END

IF UPDATE(supervisor_user_id)
	BEGIN
	IF EXISTS (SELECT 1
				FROM inserted
				WHERE supervisor_user_id = user_id)
		BEGIN
		RAISERROR ('Cannot set user to be their own supervisor', 16, -1)
		ROLLBACK TRANSACTION
		RETURN
		END
	END

IF UPDATE(user_status)
	BEGIN
	DELETE t20
	FROM u_Top_20 t20
		INNER JOIN inserted i
		ON t20.item_id = i.user_id
		INNER JOIN deleted d
		ON i.user_id = d.user_id
	WHERE t20.top_20_code IN ('RECENT_USER_PICKS', 'USERPICKLIST')
	AND i.user_status = 'NA'
	AND d.user_status = 'OK'
	
	END

-- Make sure there's no duplicate short name
IF UPDATE(user_short_name)
	BEGIN
	-- We don't want a user_short_name for anyone but users
	UPDATE u
	SET user_short_name = NULL
	FROM c_User u
		INNER JOIN inserted i
		ON u.user_id = i.user_id
	WHERE u.actor_class <> 'User'

	DELETE FROM @dupcheck

	INSERT INTO @dupcheck (
		user_property ,
		dup_count)
	SELECT x.user_short_name,
			dup_count = count(DISTINCT x.user_id)
	FROM (SELECT user_id, user_short_name
			FROM inserted
			WHERE user_short_name IS NOT NULL
			AND actor_class = 'User'
			UNION
			SELECT user_id, user_short_name
			FROM c_User
			WHERE user_short_name IS NOT NULL
			AND actor_class = 'User'
			) x
	GROUP BY x.user_short_name

	SELECT @ls_dup_property = min(user_property)
	FROM @dupcheck
	WHERE dup_count > 1

	IF @ls_dup_property IS NOT NULL
		BEGIN
		RAISERROR ('Cannot create duplicate a user_short_name (%s)', 16, -1, @ls_dup_property)
		ROLLBACK TRANSACTION
		RETURN
		END					
	END

-- Make sure there's no duplicate email address
IF UPDATE(email_address)
	BEGIN
	DELETE FROM @dupcheck

	INSERT INTO @dupcheck (
		user_property ,
		dup_count)
	SELECT x.email_address,
			dup_count = count(DISTINCT x.user_id)
	FROM (SELECT user_id, email_address
			FROM inserted
			WHERE email_address IS NOT NULL
			UNION
			SELECT user_id, email_address
			FROM c_User
			WHERE email_address IS NOT NULL
			) x
	GROUP BY x.email_address

	SELECT @ls_dup_property = min(user_property)
	FROM @dupcheck
	WHERE dup_count > 1

	IF @ls_dup_property IS NOT NULL
		BEGIN
		RAISERROR ('Cannot create duplicate a email_address (%s)', 16, -1, @ls_dup_property)
		ROLLBACK TRANSACTION
		RETURN
		END					
	END

-- Propogate the email address to the actor table
IF UPDATE(email_address)
	BEGIN
	DECLARE lc_email CURSOR LOCAL FAST_FORWARD FOR
		SELECT i.user_id, i.email_address, i.actor_id, i.created_by
		FROM inserted i

	OPEN lc_email

	FETCH lc_email INTO @ls_user_id, @ls_email_address, @ll_actor_id, @ls_created_by
	WHILE @@FETCH_STATUS = 0
		BEGIN
		EXECUTE sp_new_actor_communication  @pl_actor_id = @ll_actor_id,
											@ps_communication_type = 'Email',
											@ps_communication_value = @ls_email_address,
											@ps_created_by = @ls_created_by,
											@ps_communication_name = 'Email'

		FETCH lc_email INTO @ls_user_id, @ls_email_address, @ll_actor_id, @ls_created_by
		END

	CLOSE lc_email
	DEALLOCATE lc_email


	END

IF UPDATE(billing_id)
	BEGIN
	SET @ls_created_by = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

	SELECT 	@ll_pms_owner_id = send_via_addressee
	FROM c_Document_Route
	WHERE document_route = dbo.fn_get_global_preference('Preferences', 'default_billing_system')

	IF @@ROWCOUNT = 1
		BEGIN
		DECLARE lc_mappings CURSOR LOCAL FAST_FORWARD FOR
			SELECT i.user_id, i.billing_id
			FROM inserted i
				INNER JOIN deleted d
				ON i.user_id = d.user_id
			WHERE i.billing_id IS NOT NULL
			AND i.actor_class = 'User'
			AND i.status = 'OK'
			AND ISNULL(d.billing_id, '!NULL') <> ISNULL(i.billing_id, '!NULL')

		OPEN lc_mappings

		FETCH lc_mappings INTO @ls_user_id, @ls_billing_id
		WHILE @@FETCH_STATUS = 0
			BEGIN
			
			EXECUTE jmj_Set_User_IDValue	@ps_user_id = @ls_user_id,
											@pl_owner_id = @ll_pms_owner_id,
											@ps_IDDomain = 'Attending Doctor ID',
											@ps_IDValue = @ls_billing_id,
											@ps_created_by = @ls_created_by

			FETCH lc_mappings INTO @ls_user_id, @ls_billing_id
			END

		CLOSE lc_mappings
		DEALLOCATE lc_mappings

		END

	END

-- Only update the columns that have changed.  This will prevent the infinite loop
IF UPDATE(specialty_id)
	BEGIN
	UPDATE c
	SET	specialty_id = u.specialty_id
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.specialty_id, '!NULL') <> ISNULL(u.specialty_id, '!NULL')
	END

IF UPDATE(user_full_name)
	BEGIN
	UPDATE c
	SET	description = u.user_full_name
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.description, '!NULL') <> ISNULL(u.user_full_name, '!NULL')

	UPDATE o
	SET	description = u.user_full_name
	FROM c_Office o
		INNER JOIN inserted u
		ON u.office_id = o.office_id
		AND u.actor_class = 'Office'
	WHERE ISNULL(o.description, '!NULL') <> ISNULL(u.user_full_name, '!NULL')
	END

IF UPDATE(first_name)
	BEGIN
	UPDATE c
	SET	first_name = u.first_name
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.first_name, '!NULL') <> ISNULL(u.first_name, '!NULL')
	END

IF UPDATE(middle_name)
	BEGIN
	UPDATE c
	SET	middle_name = u.middle_name
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.middle_name, '!NULL') <> ISNULL(u.middle_name, '!NULL')
	END

IF UPDATE(last_name)
	BEGIN
	UPDATE c
	SET	last_name = u.last_name
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.last_name, '!NULL') <> ISNULL(u.last_name, '!NULL')
	END

IF UPDATE(degree)
	BEGIN
	UPDATE c
	SET	degree = u.degree
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.degree, '!NULL') <> ISNULL(u.degree, '!NULL')
	END

IF UPDATE(name_prefix)
	BEGIN
	UPDATE c
	SET	name_prefix = u.name_prefix
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.name_prefix, '!NULL') <> ISNULL(u.name_prefix, '!NULL')
	END

IF UPDATE(name_suffix)
	BEGIN
	UPDATE c
	SET	name_suffix = u.name_suffix
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.name_suffix, '!NULL') <> ISNULL(u.name_suffix, '!NULL')
	END

IF UPDATE(organization_contact)
	BEGIN
	UPDATE c
	SET	contact = u.organization_contact
	FROM c_Consultant c
		INNER JOIN inserted u
		ON u.user_id = c.consultant_id
	WHERE ISNULL(c.contact, '!NULL') <> ISNULL(u.organization_contact, '!NULL')
	END

-- Office columns


GO

