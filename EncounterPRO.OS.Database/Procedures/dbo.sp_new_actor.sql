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

-- Drop Procedure [dbo].[sp_new_actor]
Print 'Drop Procedure [dbo].[sp_new_actor]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_actor]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_actor]
GO

-- Create Procedure [dbo].[sp_new_actor]
Print 'Create Procedure [dbo].[sp_new_actor]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_actor (
	@ps_actor_class varchar(12),
	@ps_name varchar(64) = NULL,
	@ps_last_name varchar(40) = NULL,
	@ps_first_name varchar(40) = NULL,
	@ps_middle_name varchar(40) = NULL,
	@ps_name_prefix varchar(12) = NULL,
	@ps_name_suffix varchar(12) = NULL,
	@ps_degree varchar(24) = NULL,
	@ps_title varchar(64) = NULL,
	@ps_information_system_type varchar(24) = NULL ,
	@ps_information_system_version varchar(24) = NULL ,
	@ps_organization_contact varchar(64) = NULL,
	@ps_organization_director varchar(64) = NULL )
AS

DECLARE @ll_owner_id int,
		@ll_key_value int,
		@ll_actor_id int,
		@ls_user_id varchar(24)

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @ps_actor_class IS NULL
	BEGIN
	RAISERROR ('No actor_class specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- We don't allow 'User' classes through this procedure
IF @ps_actor_class = 'User'
	BEGIN
	RAISERROR ('actor_class User not allowed through this procedure',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Generate the name if we need to for a person
IF @ps_actor_class = 'Person' AND @ps_name IS NULL
	BEGIN
	SET @ps_name = dbo.fn_pretty_name ( @ps_last_name ,
										@ps_first_name ,
										@ps_middle_name ,
										@ps_name_suffix ,
										@ps_name_prefix ,
										@ps_degree )
	END

-- Check to see if we have enough information
IF @ps_name IS NULL OR @ps_name = ''
	BEGIN
	RAISERROR ('No Name Specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ls_user_id = user_id,
		@ll_actor_id = actor_id
FROM c_User
WHERE actor_class = @ps_actor_class
AND user_full_name = @ps_name

IF @@ROWCOUNT <= 0
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'USER_ID',
		@pl_key_value = @ll_key_value OUTPUT

	SET @ls_user_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select 1 from c_User where user_id = @ls_user_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'USER_ID',
			@pl_key_value = @ll_key_value OUTPUT
		SET @ls_user_id = CAST(@ll_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END
	
	INSERT INTO c_User (
			user_id,
			user_status,
			actor_class,
			user_full_name ,
			last_name ,
			first_name ,
			middle_name ,
			name_prefix ,
			name_suffix ,
			degree ,
			title ,
			information_system_type ,
			information_system_version ,
			organization_contact ,
			organization_director )
	VALUES (@ls_user_id,
			'Actor',
			@ps_actor_class,
			@ps_name ,
			@ps_last_name ,
			@ps_first_name ,
			@ps_middle_name ,
			@ps_name_prefix ,
			@ps_name_suffix ,
			@ps_degree ,
			@ps_title ,
			@ps_information_system_type ,
			@ps_information_system_version ,
			@ps_organization_contact ,
			@ps_organization_director )
	
	SET @ll_actor_id = SCOPE_IDENTITY()
	END
ELSE
	UPDATE c_User
	SET 	last_name = @ps_last_name,
			first_name = @ps_first_name,
			middle_name = @ps_middle_name,
			name_prefix = @ps_name_prefix,
			name_suffix = @ps_name_suffix,
			degree = @ps_degree,
			title = @ps_title,
			information_system_type = @ps_information_system_type,
			information_system_version = @ps_information_system_version,
			organization_contact = @ps_organization_contact,
			organization_director = @ps_organization_director
	WHERE user_id = @ls_user_id

RETURN @ll_actor_id

GO
GRANT EXECUTE
	ON [dbo].[sp_new_actor]
	TO [cprsystem]
GO

