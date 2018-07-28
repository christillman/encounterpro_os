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

-- Drop Procedure [dbo].[sp_user_search]
Print 'Drop Procedure [dbo].[sp_user_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_user_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_user_search]
GO

-- Create Procedure [dbo].[sp_user_search]
Print 'Create Procedure [dbo].[sp_user_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_user_search (
	@ps_role_id varchar(24) = NULL ,
	@ps_specialty_id varchar(24) = NULL ,
	@ps_name varchar(80) = '%' ,
	@ps_user_status varchar(8) = 'OK',
	@ps_actor_class varchar(24) = 'User',
	@ps_cpr_id varchar(12) = NULL,
	@pl_distance_filter_amount int = NULL,
	@ps_distance_filter_unit varchar(24) = NULL,
	@ps_office_id varchar(4) = NULL,
	@ps_zipcode varchar(5) = NULL )
AS

DECLARE @ls_status varchar(12),
		@ls_authority_id varchar(24),
		@ls_use_zip_filter char(1),
		@ls_pref varchar(255)

DECLARE @users TABLE (
	user_id varchar(24) NOT NULL,
	preferred_provider int NOT NULL DEFAULT (0),
	pretty_address varchar(80) NULL )

DECLARE @zipcodes TABLE (
	zipcode varchar(5) NOT NULL )

-- I know this is crazy, but originally the user type and user status were combined in a single field.
-- For backward compatibility, we need to set the user_status according to the actor class
SET @ls_status = @ps_user_status
SET @ps_user_status = CASE @ps_actor_class WHEN 'User' THEN @ps_user_status
											WHEN 'System' THEN 'System'
											WHEN 'Special' THEN 'Special'
											ELSE 'Actor' END


IF @ps_office_id IS NOT NULL
	BEGIN
	-- If the @ps_zipcode param is set to 'No' that means to turn off the zipcode filter for this search
	IF @ps_zipcode = 'No'
		SET @ls_use_zip_filter = 'F'
	ELSE
		BEGIN
		SET @ls_pref = dbo.fn_get_specific_preference('PREFERENCES', 'Office', @ps_office_id, 'Actor Filter Zipcode')
		IF @ls_pref IS NULL
			SET @ls_pref = dbo.fn_get_preference ('PREFERENCES', 'Actor Filter Zipcode', NULL, NULL)

		IF LEFT(@ls_pref, 1) IN ('T', 'Y')
			SET @ls_use_zip_filter = 'T'
		ELSE
			SET @ls_use_zip_filter = 'F'
		END
	END
ELSE
	SET @ls_use_zip_filter = 'F'


IF LEN(@ps_zipcode) = 5
	INSERT INTO @zipcodes (
		zipcode )
	VALUES (
		@ps_zipcode)
ELSE IF @ls_use_zip_filter = 'T' AND @ps_actor_class NOT IN ('User', 'Role', 'System', 'Special')
	INSERT INTO @zipcodes (
		zipcode )
	SELECT CAST(domain_item AS varchar(5))
	FROM c_Domain
	WHERE domain_id = 'ActorZipFilter_' + @ps_office_id

IF (SELECT COUNT(*) FROM @zipcodes) > 0
	INSERT INTO @users (
		user_id )
	SELECT user_id
	FROM c_User u
	WHERE (@ps_name IS NULL OR u.user_full_name like @ps_name)
	AND u.user_status = @ps_user_status
	AND (@ps_specialty_id IS NULL OR u.specialty_id = @ps_specialty_id)
	AND (@ps_actor_class IS NULL OR u.actor_class = @ps_actor_class)
	AND u.status = @ls_status
	AND EXISTS (
		SELECT 1
		FROM c_Actor_Address a
			INNER JOIN @zipcodes z
			ON LEFT(a.zip, 5) = z.zipcode
		WHERE u.actor_id = a.actor_id)
ELSE
	INSERT INTO @users (
		user_id )
	SELECT user_id
	FROM c_User
	WHERE (@ps_name IS NULL OR user_full_name like @ps_name)
	AND user_status = @ps_user_status
	AND (@ps_specialty_id IS NULL OR specialty_id = @ps_specialty_id)
	AND (@ps_actor_class IS NULL OR actor_class = @ps_actor_class)
	AND status = @ls_status

IF @ps_role_id IS NOT NULL
	DELETE t
	FROM @users t
	WHERE NOT EXISTS (
		SELECT user_id
		FROM c_User_Role
		WHERE t.user_id = c_User_Role.user_id
		AND c_User_Role.role_id = @ps_role_id)

IF @ps_cpr_id IS NOT NULL
	BEGIN
	SELECT @ls_authority_id = authority_id
	FROM p_Patient_Authority
	WHERE cpr_id = @ps_cpr_id
	AND authority_type = 'PAYOR'
	AND authority_sequence = 1
	AND status = 'OK'
	
	UPDATE x
	SET preferred_provider = 1
	FROM @users x
		INNER JOIN c_Preferred_provider pp
		ON x.user_id = pp.consultant_id
	WHERE pp.authority_id = @ls_authority_id
	END

-- First get the primary address
UPDATE x
SET pretty_address = dbo.fn_pretty_address(a.address_line_1, a.address_line_2, a.city, a.state, a.zip, a.country)
FROM @users x
	INNER JOIN c_User u
	ON u.user_id = x.user_id
	INNER JOIN c_Actor_Address a
	ON a.actor_id = u.actor_id
WHERE a.description = 'Address'
AND a.status = 'OK'
AND x.pretty_address IS NULL

-- The get any address
UPDATE x
SET pretty_address = dbo.fn_pretty_address(a.address_line_1, a.address_line_2, a.city, a.state, a.zip, a.country)
FROM @users x
	INNER JOIN c_User u
	ON u.user_id = x.user_id
	INNER JOIN c_Actor_Address a
	ON a.actor_id = u.actor_id
WHERE a.status = 'OK'
AND x.pretty_address IS NULL

SELECT u.user_id,
	u.user_full_name,
	u.user_short_name,
	u.color,
	COALESCE(s.icon, 'user_icon.bmp') as icon,
	selected_flag=CONVERT(int, 0),
	ISNULL(u.user_status, 'NA') as user_status,
	s.specialty_id,
	s.description as specialty_description,
	t.preferred_provider,
	t.pretty_address
FROM c_User u
	INNER JOIN @users t
	ON u.user_id = t.user_id
	LEFT OUTER JOIN c_Specialty s
	ON u.specialty_id = s.specialty_id


GO
GRANT EXECUTE
	ON [dbo].[sp_user_search]
	TO [cprsystem]
GO

