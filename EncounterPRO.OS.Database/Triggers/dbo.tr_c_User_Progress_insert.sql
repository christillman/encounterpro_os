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

-- Drop Trigger [dbo].[tr_c_User_Progress_insert]
Print 'Drop Trigger [dbo].[tr_c_User_Progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_User_Progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_User_Progress_insert]
GO

-- Create Trigger [dbo].[tr_c_User_Progress_insert]
Print 'Create Trigger [dbo].[tr_c_User_Progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_User_Progress_insert ON dbo.c_User_Progress
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE
	@Modify_flag int
	,@Grant_Privilege_flag int
	,@Revoke_Privilege_flag int
	,@ID_flag int

DECLARE @ls_progress_key varchar(40),
		@ll_user_progress_sequence int,
		@ll_last_user_progress_sequence int,
		@ls_last_progress_value varchar(255),
		@ls_user_id varchar(24),
		@ls_created_by varchar(24),
		@ldt_user_created datetime,
		@ls_progress_value varchar(40),
		@ls_owner_id varchar(40),
		@ll_owner_id int,
		@ls_code_domain varchar(40),
		@ls_epro_domain varchar(64),
		@ls_user_full_name varchar(64),
		@ll_customer_id int,
		@ll_service_level int,
		@li_bit_0 smallint,
		@li_bit_1 smallint,
		@li_bit_2 smallint,
		@li_bit_3 smallint,
		@li_bit_4 smallint,
		@li_bit_5 smallint,
		@li_bit_6 smallint,
		@ls_allow_flag char(1)

/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
	,@Grant_Privilege_flag = SUM( CHARINDEX( 'Grant Privilege', inserted.progress_type ) )
	,@Revoke_Privilege_flag = SUM( CHARINDEX( 'Revoke Privilege', inserted.progress_type ) )
	,@ID_flag = SUM( CHARINDEX( 'ID', inserted.progress_type ) )
FROM inserted

-- Update Encounter Field
IF @Modify_flag > 0
BEGIN
	-- Make sure that the "from" value is preserved in the log
	-- First see if the modified field has been modified before.  If so then we don't need to log the "from" value.
	DECLARE lc_mods CURSOR LOCAL FAST_FORWARD FOR
		SELECT i.user_id, 
				i.user_progress_sequence, 
				i.progress_key, 
				i.created_by, 
				user_created = u.created,
				last_progress_value = CASE i.progress_key WHEN 'certified' then u.certified
															WHEN 'clinical_access_flag' then u.clinical_access_flag
															WHEN 'first_name' then u.first_name
															WHEN 'middle_name' then u.middle_name
															WHEN 'last_name' then u.last_name
															WHEN 'name_prefix' then u.name_prefix
															WHEN 'name_suffix' then u.name_suffix
															WHEN 'degree' then u.degree
															WHEN 'dea_number' then u.dea_number
															WHEN 'license_number' then u.license_number
															WHEN 'certification_number' then u.certification_number
															WHEN 'upin' then u.upin
															WHEN 'npi' then u.npi
															WHEN 'office_id' then u.office_id
															WHEN 'status' then u.status
															WHEN 'specialty_id' then u.specialty_id
															WHEN 'user_full_name' then u.user_full_name
															WHEN 'user_short_name' then u.user_short_name
															WHEN 'color' then CAST(u.color AS varchar(40))
															WHEN 'user_initial' then u.user_initial
															WHEN 'supervisor_user_id' then u.supervisor_user_id
															WHEN 'license_flag' then u.license_flag
															WHEN 'email_address' then u.email_address
															WHEN 'actor_class' then u.actor_class
															WHEN 'organization_contact' then u.organization_contact
															WHEN 'organization_director' then u.organization_director
															WHEN 'title' then u.title
															WHEN 'information_system_type' then u.information_system_type
															WHEN 'information_system_version' then u.information_system_version END
		FROM inserted i
			INNER JOIN c_User u
			ON i.user_id = u.user_id
		WHERE progress_type = 'Modify'

	OPEN lc_mods

	FETCH lc_mods INTO @ls_user_id, @ll_user_progress_sequence, @ls_progress_key, @ls_created_by, @ldt_user_created, @ls_last_progress_value
	WHILE @@FETCH_STATUS = 0
		BEGIN
		SELECT @ll_user_progress_sequence = MAX(user_progress_sequence)
		FROM c_User_Progress
		WHERE user_id = @ls_user_id
		AND progress_type = 'Modify'
		AND progress_key = @ls_progress_key
		AND user_progress_sequence < @ll_user_progress_sequence

		IF @ll_user_progress_sequence IS NULL
			BEGIN
			-- This modified field has not been modified before, so log a record with the "from" value
			IF LEN(@ls_last_progress_value) > 40
				INSERT INTO c_User_Progress (
					[user_id] ,
					[progress_user_id] ,
					[progress_date_time] ,
					[progress_type] ,
					[progress_key] ,
					[progress] ,
					[created] ,
					[created_by] )
				VALUES (
					@ls_user_id,
					@ls_created_by,
					@ldt_user_created,
					'Modify',
					@ls_progress_key,
					@ls_last_progress_value,
					getdate(),
					@ls_created_by )
			ELSE
				INSERT INTO c_User_Progress (
					[user_id] ,
					[progress_user_id] ,
					[progress_date_time] ,
					[progress_type] ,
					[progress_key] ,
					[progress_value] ,
					[created] ,
					[created_by] )
				VALUES (
					@ls_user_id,
					@ls_created_by,
					@ldt_user_created,
					'Modify',
					@ls_progress_key,
					@ls_last_progress_value,
					getdate(),
					@ls_created_by )
			END
		
		FETCH lc_mods INTO @ls_user_id, @ll_user_progress_sequence, @ls_progress_key, @ls_created_by, @ldt_user_created, @ls_last_progress_value
		END

	CLOSE lc_mods
	DEALLOCATE lc_mods

	-- Update the fields in c_User that are affected by the 'Modify' progress
	UPDATE u
	SET 	certified = CASE i.progress_key WHEN 'certified' then CAST(i.progress_value AS char(1)) ELSE u.certified END,
			clinical_access_flag = CASE i.progress_key WHEN 'clinical_access_flag' then CAST(i.progress_value AS char(1)) ELSE u.clinical_access_flag END,
			first_name = CASE i.progress_key WHEN 'first_name' then i.progress_value ELSE u.first_name END,
			middle_name = CASE i.progress_key WHEN 'middle_name' then i.progress_value ELSE u.middle_name END,
			last_name = CASE i.progress_key WHEN 'last_name' then i.progress_value ELSE u.last_name END,
			name_prefix = CASE i.progress_key WHEN 'name_prefix' then i.progress_value ELSE u.name_prefix END,
			name_suffix = CASE i.progress_key WHEN 'name_suffix' then i.progress_value ELSE u.name_suffix END,
			degree = CASE i.progress_key WHEN 'degree' then i.progress_value ELSE u.degree END,
			dea_number = CASE i.progress_key WHEN 'dea_number' then i.progress_value ELSE u.dea_number END,
			license_number = CASE i.progress_key WHEN 'license_number' then i.progress_value ELSE u.license_number END,
			certification_number = CASE i.progress_key WHEN 'certification_number' then i.progress_value ELSE u.certification_number END,
			upin = CASE i.progress_key WHEN 'upin' then i.progress_value ELSE u.upin END,
			npi = CASE i.progress_key WHEN 'npi' then i.progress_value ELSE u.npi END,
			office_id = CASE i.progress_key WHEN 'office_id' then CAST(i.progress_value AS varchar(4)) ELSE u.office_id END,
			status = CASE i.progress_key WHEN 'status' then CAST(i.progress_value AS varchar(12)) ELSE u.status END,
			specialty_id = CASE i.progress_key WHEN 'specialty_id' then CAST(i.progress_value AS varchar(24)) ELSE u.specialty_id END,
			user_full_name = CASE i.progress_key WHEN 'user_full_name' then CAST(i.progress_value AS varchar(64)) ELSE u.user_full_name END,
			user_short_name = CASE i.progress_key WHEN 'user_short_name' then CAST(i.progress_value AS varchar(12)) ELSE u.user_short_name END,
			user_status = CASE i.progress_key WHEN 'user_status' then CAST(i.progress_value AS varchar(8)) ELSE u.user_status END,
			color = CASE i.progress_key WHEN 'color' then CAST(i.progress_value AS int) ELSE u.color END,
			user_initial = CASE i.progress_key WHEN 'user_initial' then CAST(i.progress_value AS varchar(3)) ELSE u.user_initial END,
			supervisor_user_id = CASE i.progress_key WHEN 'supervisor_user_id' then CAST(i.progress_value AS varchar(24)) ELSE u.supervisor_user_id END,
			license_flag = CASE i.progress_key WHEN 'license_flag' then CAST(i.progress_value AS char(1)) ELSE u.license_flag END,
			email_address = CASE i.progress_key WHEN 'email_address' then CAST(i.progress_value AS varchar(64)) ELSE u.email_address END,
			actor_class = CASE i.progress_key WHEN 'actor_class' then CAST(i.progress_value AS varchar(12)) ELSE u.actor_class END,
			organization_contact = CASE i.progress_key WHEN 'organization_contact' then CAST(i.progress_value AS varchar(64)) ELSE u.organization_contact END,
			organization_director = CASE i.progress_key WHEN 'organization_director' then CAST(i.progress_value AS varchar(64)) ELSE u.organization_director END,
			title = CASE i.progress_key WHEN 'title' then CAST(i.progress_value AS varchar(64)) ELSE u.title END,
			information_system_type = CASE i.progress_key WHEN 'information_system_type' then CAST(i.progress_value AS varchar(24)) ELSE u.information_system_type END,
			information_system_version = CASE i.progress_key WHEN 'information_system_version' then CAST(i.progress_value AS varchar(24)) ELSE u.information_system_version END
	FROM c_User u
		INNER JOIN inserted i
		ON i.user_id = u.user_id
	WHERE i.progress_type = 'Modify'

	-- If the user is being deactivated then clear out the access_id
	UPDATE u
	SET access_id = NULL
	FROM inserted i
		INNER JOIN c_User u
		ON i.user_id = u.user_id
	WHERE i.progress_type = 'Modify'
	AND i.progress_key = 'status'
	AND i.progress_value = 'NA'

	-- Update c_Office if necessary
	UPDATE o
	SET status = CAST(i.progress_value AS varchar(12))
	FROM inserted i
		INNER JOIN c_User u
		ON i.user_id = u.user_id
		INNER JOIN c_Office o
		ON u.office_id = o.office_id
		AND u.actor_class = 'Office'
	WHERE i.progress_type = 'Modify'
	AND i.progress_key = 'status'

END


IF @Grant_Privilege_flag > 0
BEGIN
	DELETE p
	FROM o_User_Privilege p
		INNER JOIN inserted i
		ON p.office_id = i.progress_key
		AND p.user_id = i.user_id
		AND p.privilege_id = i.progress_value
	WHERE i.progress_type = 'Grant Privilege'
		
	INSERT INTO o_User_Privilege (
		office_id,
		user_id,
		privilege_id,
		access_flag,
		created,
		created_by)
	SELECT CAST(i.progress_key AS varchar(4)),
			i.user_id,
			CAST(i.progress_value AS varchar(24)),
			'G',
			getdate(),
			i.created_by
	FROM inserted i
	WHERE i.progress_type = 'Grant Privilege'
END

IF @Revoke_Privilege_flag > 0
BEGIN
	DELETE p
	FROM o_User_Privilege p
		INNER JOIN inserted i
		ON p.office_id = i.progress_key
		AND p.user_id = i.user_id
		AND p.privilege_id = i.progress_value
	WHERE i.progress_type = 'Revoke Privilege'
		
	INSERT INTO o_User_Privilege (
		office_id,
		user_id,
		privilege_id,
		access_flag,
		created,
		created_by)
	SELECT CAST(i.progress_key AS varchar(4)),
			i.user_id,
			CAST(i.progress_value AS varchar(24)),
			'R',
			getdate(),
			i.created_by
	FROM inserted i
	WHERE i.progress_type = 'Revoke Privilege'
END

-- Update the current_flag for previous property records
UPDATE t1
SET current_flag = 'N'
FROM c_User_Progress t1
	INNER JOIN inserted t2
	ON t1.user_id = t2.user_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_key = t2.progress_key
WHERE (t1.user_progress_sequence < t2.user_progress_sequence
		OR (t1.progress_key IS NOT NULL AND t1.progress_value IS NULL AND t1.progress IS NULL ) )

-- Update 2nd foreign key into c_User
UPDATE p
SET c_actor_id = u.id
FROM c_User_Progress p
	INNER JOIN inserted i
	ON p.user_id = i.user_id
	AND p.user_progress_sequence = i.user_progress_sequence
	INNER JOIN c_User u
	ON p.user_id = u.user_id
WHERE p.c_actor_id IS NULL


-- Update redundant IDs
IF @ID_flag > 0
	BEGIN
	UPDATE o
	SET billing_id = CAST(i.progress_value AS varchar(24))
	FROM c_Office o
		INNER JOIN c_User u
		ON u.office_id = o.office_id
		INNER JOIN inserted i
		ON u.user_id = i.user_id
	WHERE u.actor_class = 'Office'
	AND u.status = 'OK'
	AND i.progress_type = 'ID'
	AND i.progress_key LIKE '%^FacilityID'
	AND ISNULL(o.billing_id, '!NULL') <> ISNULL(i.progress_value, '!NULL')

	UPDATE u
	SET billing_id = CAST(i.progress_value AS varchar(24))
	FROM c_User u
		INNER JOIN inserted i
		ON u.user_id = i.user_id
	WHERE u.actor_class = 'Office'
	AND u.status = 'OK'
	AND i.progress_type = 'ID'
	AND i.progress_key LIKE '%^Attending Doctor ID'
	AND ISNULL(u.billing_id, '!NULL') <> ISNULL(i.progress_value, '!NULL')
	END

-----------------------------------------------------------------------------
-- Update Payor Category
-----------------------------------------------------------------------------

SELECT @ls_progress_key = CASE WHEN customer_id > 0 THEN CAST(customer_id AS varchar(12)) + '^authority_id'
													ELSE 'authority_id' END
FROM c_Database_Status

DECLARE @authorities TABLE (
	user_id varchar(24) NOT NULL,
	actor_id int NOT NULL,
	authority_id varchar(24) NOT NULL)

INSERT INTO @authorities (
	user_id,
	actor_id,
	authority_id)
SELECT DISTINCT u.user_id,
		u.actor_id,
		CAST(p.progress_value AS varchar(24))
FROM inserted i
	INNER JOIN c_User u
	ON i.user_id = u.user_id
	INNER JOIN c_User_Progress p
	ON p.user_id = u.user_id
WHERE p.progress_type = 'ID'
AND p.progress_key = @ls_progress_key
AND p.current_flag = 'Y'
AND i.progress_type = 'Property'
AND i.progress_key = 'Payor.Category'

UPDATE a
SET authority_category = CAST(i.progress_value AS varchar(24))
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.user_id = x.user_id
WHERE i.progress_type = 'Property'
AND i.progress_key = 'Payor.Category'
AND ISNULL(a.authority_category, '!NULL') <> ISNULL(i.progress_value, '!NULL')


------------------------------------------------------------------
------------------------------------------------------------------
-- Process the SureScripts ServiceLevel
--
-- This block processes the SureScripts service level into the
-- c_Actor_Route_Purpose table
--
------------------------------------------------------------------
------------------------------------------------------------------

DECLARE lc_servicelevel CURSOR LOCAL FAST_FORWARD FOR
	SELECT [user_id], progress_value, created_by
	FROM inserted
	WHERE progress_type = 'Property'
	AND progress_key = '211^ServiceLevel'
	AND current_flag = 'Y'

OPEN lc_servicelevel

FETCH lc_servicelevel INTO @ls_user_id, @ls_progress_value, @ls_created_by
WHILE @@FETCH_STATUS = 0
	BEGIN
	IF ISNUMERIC(@ls_progress_value) = 1
		BEGIN
		SET @ll_service_level = CAST(@ls_progress_value AS int)

		SET @li_bit_0 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_1 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_2 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_3 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_4 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_5 = @ll_service_level % 2

		SET @ll_service_level = @ll_service_level / 2
		SET @li_bit_6 = @ll_service_level % 2

		IF @li_bit_0 = 1
			SET @ls_allow_flag = 'Y'
		ELSE
			SET @ls_allow_flag = 'N'
		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'NewRX',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		IF @li_bit_1 = 1
			SET @ls_allow_flag = 'Y'
		ELSE
			SET @ls_allow_flag = 'N'
		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Refill Request',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Refill Response',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		IF @li_bit_2 = 1
			SET @ls_allow_flag = 'Y'
		ELSE
			SET @ls_allow_flag = 'N'
		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Change Request',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Change Response',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		IF @li_bit_3 = 1
			SET @ls_allow_flag = 'Y'
		ELSE
			SET @ls_allow_flag = 'N'
		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'RX Fulfillment',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		IF @li_bit_4 = 1
			SET @ls_allow_flag = 'Y'
		ELSE
			SET @ls_allow_flag = 'N'
		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Cancel Treatment',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by

		EXECUTE jmj_Set_Actor_Route_Purpose
			@ps_user_id = @ls_user_id,
			@ps_document_route = 'SureScripts',
			@ps_purpose = 'Cancel Response',
			@ps_allow_flag = @ls_allow_flag,
			@ps_created_by = @ls_created_by
		END

	FETCH lc_servicelevel INTO @ls_user_id, @ls_progress_value, @ls_created_by
	END

CLOSE lc_servicelevel
DEALLOCATE lc_servicelevel

------------------------------------------------------------------
------------------------------------------------------------------
-- Sync the IDs with c_XML_Code
------------------------------------------------------------------
------------------------------------------------------------------
SELECT @ll_customer_id = customer_id
FROM c_Database_Status

DECLARE lc_keys CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.[user_id], i.progress_key, i.progress_value, i.created_by, u.user_full_name, u.actor_class + '.user_id'
	FROM inserted i
		INNER JOIN c_User u
		ON i.user_id = u.user_id
	WHERE i.progress_type = 'ID'
	AND i.current_flag = 'Y'

OPEN lc_keys

FETCH lc_keys INTO @ls_user_id, @ls_progress_key, @ls_progress_value, @ls_created_by, @ls_user_full_name, @ls_epro_domain
WHILE @@FETCH_STATUS = 0
	BEGIN
	IF CHARINDEX('^', @ls_progress_key) > 0
		BEGIN
		SET @ls_owner_id = SUBSTRING(@ls_progress_key, 1, CHARINDEX('^', @ls_progress_key) - 1)
		SET @ls_code_domain = SUBSTRING(@ls_progress_key, CHARINDEX('^', @ls_progress_key) + 1, 40)
		END
	ELSE
		BEGIN
		SET @ls_owner_id = CAST(@ll_customer_id AS varchar(40))
		SET @ls_code_domain = @ls_progress_key
		END

	IF ISNUMERIC(@ls_owner_id) = 1
		BEGIN
		SET @ll_owner_id = CAST(@ls_owner_id AS int)

		IF NOT EXISTS ( SELECT 1
						FROM c_XML_Code
						WHERE owner_id = @ll_owner_id
						AND code_domain = @ls_code_domain
						AND code = @ls_progress_value
						AND epro_domain = @ls_epro_domain
						AND epro_id = @ls_user_id)
			BEGIN
			EXECUTE xml_add_mapping
				@pl_owner_id = @ll_owner_id, 
				@ps_code_domain = @ls_code_domain,
				@ps_code_version = NULL,
				@ps_code = @ls_progress_value,
				@ps_code_description = NULL,
				@ps_epro_domain = @ls_epro_domain,
				@ps_epro_id = @ls_user_id,
				@ps_epro_description = @ls_user_full_name,
				@pl_epro_owner_id = @ll_customer_id,
				@ps_created_by = @ls_created_by
			END
		END

	FETCH lc_keys INTO @ls_user_id, @ls_progress_key, @ls_progress_value, @ls_created_by, @ls_user_full_name, @ls_epro_domain
	END

CLOSE lc_keys
DEALLOCATE lc_keys

GO

