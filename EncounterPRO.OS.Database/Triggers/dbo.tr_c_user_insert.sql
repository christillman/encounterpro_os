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

-- Drop Trigger [dbo].[tr_c_user_insert]
Print 'Drop Trigger [dbo].[tr_c_user_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_user_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_user_insert]
GO

-- Create Trigger [dbo].[tr_c_user_insert]
Print 'Create Trigger [dbo].[tr_c_user_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_user_insert ON dbo.c_user
FOR INSERT
AS

if @@ROWCOUNT = 0
	RETURN

-- Make sure there's no conflict with c_Consultant
-- Msc - Disable until we can distinguish between an insert directly into c_User and the insert from the
--       c_Consultant trigger
--IF EXISTS (SELECT 1 FROM c_Consultant c
--					INNER JOIN inserted i
--					ON c.consultant_id = i.user_id)
--	BEGIN
--	RAISERROR ('Cannot create consultant_id which is duplicate a user_id', 16, -1)
--	ROLLBACK TRANSACTION
--	RETURN
--	END					

DECLARE @ls_consultant_id varchar(24),
		@ls_specialty_id varchar(24),
		@ls_description varchar(80),
		@ll_actor_id int,
		@ls_address_line_1 varchar(40) ,
		@ls_address_line_2 varchar(40) ,
		@ls_city varchar(40) ,
		@ls_state varchar(2) ,
		@ls_zip varchar(10) ,
		@ls_phone varchar(32) ,
		@ls_phone2 varchar(32) ,
		@ls_fax varchar(32) ,
		@ls_email_address varchar(64) ,
		@ls_user_status varchar(8),
		@ls_actor_class varchar(12),
		@ls_user_full_name varchar(64),
		@ll_rows int,
		@ls_user_short_name varchar(12),
		@ls_new_user_short_name varchar(12),
		@ll_count int,
		@ls_count varchar(6),
		@ls_first_name varchar(20),
		@ls_last_name varchar(40),
		@ls_user_id varchar(24),
		@ls_authority_id varchar(24),
		@ll_key_value int,
		@ll_owner_id int,
		@ll_error int,
		@ls_created_by varchar(24),
		@ls_progress_key varchar(40),
		@ls_office_id varchar(4),
		@ls_status varchar(12),
		@lui_id uniqueidentifier,
		@li_office_number smallint,
		@ls_dup_property varchar(80)

DECLARE @dupcheck TABLE (
	user_property varchar(80) NOT NULL,
	dup_count int NULL)

-- Make sure there's no duplicate short name among users
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

INSERT INTO c_User_Role (
	[user_id],
	role_id,
	role_order)
SELECT [user_id],
	'!Everyone',
	99
FROM inserted
WHERE user_status IN ('OK', 'NA')
AND NOT EXISTS (
	SELECT 1
	FROM c_User_Role ur
	WHERE ur.user_id = inserted.user_id
	AND ur.role_id = '!Everyone' )

-- Make sure actor_type is specified
UPDATE u
SET actor_type = x.actor_type
FROM c_User u
	INNER JOIN inserted i
	ON u.user_id = i.user_id
	INNER JOIN (SELECT actor_class, max(actor_type) as actor_type
				FROM c_Actor_Class_Type
				GROUP BY actor_class) x
	ON u.actor_class = x.actor_class
WHERE u.actor_type IS NULL


-- Get the customer_id
SELECT @ll_owner_id = customer_id
FROM c_database_status

---------------------------------------------------------------
-- Copy the consultant users to c_Consultant
---------------------------------------------------------------
DECLARE lc_cons CURSOR LOCAL STATIC FOR
	SELECT user_id,
			user_full_name ,
			email_address ,
			specialty_id ,
			actor_id
	FROM inserted i
	WHERE actor_class = 'Consultant'

OPEN lc_cons

FETCH lc_cons INTO @ls_consultant_id,
					@ls_user_full_name ,
					@ls_email_address ,
					@ls_specialty_id ,
					@ll_actor_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- See if the c_Consultant record already exists
	SELECT @ll_count = count(*)
	FROM c_Consultant
	WHERE consultant_id = @ls_consultant_id

	IF @ll_count = 0
		BEGIN
		INSERT INTO c_Consultant (
				consultant_id,
				specialty_id,
				description,
				first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				contact,
				id )
		SELECT user_id,
				COALESCE(specialty_id, '$'),
				user_full_name,
				first_name,
				middle_name,
				last_name,
				degree,
				name_prefix,
				name_suffix,
				CAST(organization_contact AS varchar(40)),
				id
		FROM c_User
		WHERE user_id = @ls_consultant_id

		SELECT @ll_rows = @@ROWCOUNT

		IF @ll_rows = 0
			BEGIN
			RAISERROR ('No consultant record created', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					
		END
	ELSE
		BEGIN
		-- Only update the columns that have changed.  This will prevent the infinite loop
		UPDATE c
		SET	specialty_id = u.specialty_id
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.specialty_id, '!NULL') <> ISNULL(u.specialty_id, '!NULL')

		UPDATE c
		SET	description = u.user_full_name
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.description, '!NULL') <> ISNULL(u.user_full_name, '!NULL')

		UPDATE c
		SET	first_name = u.first_name
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.first_name, '!NULL') <> ISNULL(u.first_name, '!NULL')

		UPDATE c
		SET	middle_name = u.middle_name
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.middle_name, '!NULL') <> ISNULL(u.middle_name, '!NULL')

		UPDATE c
		SET	last_name = u.last_name
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.last_name, '!NULL') <> ISNULL(u.last_name, '!NULL')

		UPDATE c
		SET	degree = u.degree
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.degree, '!NULL') <> ISNULL(u.degree, '!NULL')

		UPDATE c
		SET	name_prefix = u.name_prefix
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.name_prefix, '!NULL') <> ISNULL(u.name_prefix, '!NULL')

		UPDATE c
		SET	name_suffix = u.name_suffix
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.name_suffix, '!NULL') <> ISNULL(u.name_suffix, '!NULL')

		UPDATE c
		SET	contact = u.organization_contact
		FROM c_Consultant c
			INNER JOIN c_User u
			ON u.user_id = c.consultant_id
		WHERE c.consultant_id = @ls_consultant_id
		AND ISNULL(c.contact, '!NULL') <> ISNULL(u.organization_contact, '!NULL')

		END

	
	FETCH lc_cons INTO @ls_consultant_id,
						@ls_user_full_name ,
						@ls_email_address ,
						@ls_specialty_id ,
						@ll_actor_id
	END

CLOSE lc_cons
DEALLOCATE lc_cons


---------------------------------------------------------------
-- Copy the payor users to c_Authority
---------------------------------------------------------------
DECLARE lc_cons CURSOR LOCAL STATIC FOR
	SELECT user_id,
			user_full_name ,
			email_address ,
			specialty_id ,
			actor_id,
			COALESCE(created_by, '#SYSTEM')
	FROM inserted i
	WHERE actor_class IN ('Payor')

OPEN lc_cons

FETCH lc_cons INTO @ls_user_id,
					@ls_user_full_name ,
					@ls_email_address ,
					@ls_specialty_id ,
					@ll_actor_id ,
					@ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- See if the c_Consultant record already exists
	SELECT @ls_authority_id = max(authority_id)
	FROM c_Authority
	WHERE authority_type = 'Payor'
	AND [name] = @ls_user_full_name

	IF @ls_authority_id IS NULL
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'AUTHORITY_ID',
			@pl_key_value = @ll_key_value OUTPUT

		SET @ls_authority_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

		WHILE exists(select 1 from c_Authority where authority_id = @ls_authority_id)
			BEGIN
			EXECUTE sp_get_next_key
				@ps_cpr_id = '!CPR',
				@ps_key_id = 'AUTHORITY_ID',
				@pl_key_value = @ll_key_value OUTPUT
			SET @ls_authority_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
			END
	
		
		INSERT INTO c_Authority (
				authority_id,
				authority_type,
				authority_category,
				[name],
				status )
		VALUES (
				@ls_authority_id,
				'PAYOR',
				'Other',
				left(@ls_user_full_name,50),
				'OK')

		SELECT @ll_rows = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			BEGIN
			ROLLBACK TRANSACTION
			RETURN
			END					

		IF @ll_rows = 0
			BEGIN
			RAISERROR ('No consultant record created', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					
		END
	
	-- Make sure the there is a link to the authority_id
	SET @ls_progress_key = CAST(@ll_owner_id AS varchar(12)) + '^authority_id'

	SELECT @ll_count = count(*)
	FROM c_User_Progress
	WHERE user_id = @ls_user_id
	AND progress_type = 'ID'
	AND progress_key = @ls_progress_key
	AND progress_value = @ls_authority_id
	AND current_flag = 'Y'

	IF @ll_count = 0
		EXECUTE sp_Set_User_Progress
			@ps_user_id = @ls_user_id,
			@ps_progress_user_id = @ls_created_by,
			@ps_progress_type = 'ID',
			@ps_progress_key = @ls_progress_key,
			@ps_progress = @ls_authority_id,
			@ps_created_by = @ls_created_by

	FETCH lc_cons INTO @ls_user_id,
						@ls_user_full_name ,
						@ls_email_address ,
						@ls_specialty_id ,
						@ll_actor_id ,
						@ls_created_by
	END

CLOSE lc_cons
DEALLOCATE lc_cons


---------------------------------------------------------------
-- Copy the office users to c_Office
---------------------------------------------------------------
DECLARE lc_offices CURSOR LOCAL STATIC FOR
	SELECT user_id,
			user_full_name ,
			office_id,
			status,
			id 
	FROM inserted i
	WHERE actor_class IN ('Office')

OPEN lc_offices

FETCH lc_offices INTO @ls_user_id,
					@ls_user_full_name ,
					@ls_office_id ,
					@ls_status ,
					@lui_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- See if the office_id already exists in c_Office
	SELECT @ll_count = count(*)
	FROM c_Office
	WHERE office_id = @ls_office_id

	IF @ll_count = 0
		BEGIN
		SELECT @li_office_number = max(office_number)
		FROM c_Office

		IF @li_office_number IS NULL
			SET @li_office_number = 1
		ELSE
			SET @li_office_number = @li_office_number + 1
	
		
		INSERT INTO c_Office (
				office_id,
				office_number,
				description,
				status,
				id,
				office_nickname )
		VALUES (
				@ls_office_id,
				@li_office_number,
				@ls_user_full_name,
				@ls_status,
				@lui_id,
				CAST(@ls_user_full_name AS varchar(24)))

		SELECT @ll_rows = @@ROWCOUNT,
				@ll_error = @@ERROR

		IF @ll_error <> 0
			BEGIN
			ROLLBACK TRANSACTION
			RETURN
			END					

		IF @ll_rows = 0
			BEGIN
			RAISERROR ('No office record created', 16, -1)
			ROLLBACK TRANSACTION
			RETURN
			END					
		END

	FETCH lc_offices INTO @ls_user_id,
						@ls_user_full_name ,
						@ls_office_id ,
						@ls_status ,
						@lui_id
	END

CLOSE lc_offices
DEALLOCATE lc_offices

GO

