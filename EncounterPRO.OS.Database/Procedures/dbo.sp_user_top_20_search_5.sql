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

-- Drop Procedure [dbo].[sp_user_top_20_search_5]
Print 'Drop Procedure [dbo].[sp_user_top_20_search_5]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_user_top_20_search_5]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_user_top_20_search_5]
GO

-- Create Procedure [dbo].[sp_user_top_20_search_5]
Print 'Create Procedure [dbo].[sp_user_top_20_search_5]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_user_top_20_search_5 (
	@ps_top_20_code varchar(64) ,
	@ps_top_20_user_id varchar(24),
	@ps_role_prefix varchar(24) = NULL)
AS

DECLARE @users TABLE (
	user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	top_20_sequence int NOT NULL,
	search_user_id varchar(24) NOT NULL,
	user_full_name varchar(64) NULL,
	icon varchar(128) NULL,
	color int NULL,
	sort_sequence int NULL,
	user_status varchar(8) NULL,
	pretty_address varchar(80) NULL )

IF @ps_role_prefix IS NULL OR @ps_role_prefix = ''
	SET @ps_role_prefix = ''
ELSE
	SET @ps_role_prefix = @ps_role_prefix + ' '

INSERT INTO @users (
	user_id,
	top_20_code,
	top_20_sequence,
	search_user_id,
	sort_sequence )
SELECT user_id,
	top_20_code,
	top_20_sequence,
	CAST(item_id AS varchar(24)),
	sort_sequence 
FROM u_Top_20 WITH (NOLOCK)
WHERE user_id = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code
AND item_id IS NOT NULL

UPDATE t
	SET user_full_name = u.user_full_name,
		color = u.color,
		icon = s.icon,
		user_status = ISNULL(u.user_status, 'NA')
FROM @users t
	INNER JOIN c_User u
	ON t.search_user_id = u.user_id
	LEFT OUTER JOIN c_Specialty s
	ON u.specialty_id = s.specialty_id
WHERE LEFT(t.search_user_id, 1) <> '!'

UPDATE t
	SET user_full_name = '<' + @ps_role_prefix + r.role_name + '>',
		color = r.color,
		icon = r.icon,
		user_status = 'ROLE'
FROM @users t
	INNER JOIN c_Role r
	ON t.search_user_id = r.role_id
WHERE LEFT(t.search_user_id, 1) = '!'

-- First get the primary address
UPDATE x
SET pretty_address = dbo.fn_pretty_address(a.address_line_1, a.address_line_2, a.city, a.state, a.zip, a.country)
FROM @users x
	INNER JOIN c_User u
	ON u.user_id = x.search_user_id
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
	ON u.user_id = x.search_user_id
	INNER JOIN c_Actor_Address a
	ON a.actor_id = u.actor_id
WHERE a.status = 'OK'
AND x.pretty_address IS NULL


SELECT t.user_id,
	t.top_20_code,
	t.top_20_sequence,
	t.search_user_id,
	t.user_full_name,
	t.color,
	COALESCE(t.icon, 'user_icon.bmp') as icon,
	t.sort_sequence,
	selected_flag=CONVERT(int, 0),
	isnull(t.user_status, 'NA') as user_status,
	s.specialty_id,
	s.description as spclty_description,
	t.pretty_address
FROM c_User u
	INNER JOIN @users t
	ON u.user_id = t.search_user_id
	LEFT OUTER JOIN c_Specialty s
	ON u.specialty_id = s.specialty_id
WHERE LEFT(t.search_user_id, 1) <> '!'
UNION
SELECT t.user_id,
	t.top_20_code,
	t.top_20_sequence,
	t.search_user_id,
	t.user_full_name,
	t.color,
	COALESCE(t.icon, 'user_icon.bmp') as icon,
	t.sort_sequence,
	selected_flag=CONVERT(int, 0),
	isnull(t.user_status, 'NA') as user_status,
	CAST(NULL AS varchar(24)) as specialty_id,
	CAST(NULL AS varchar(80)) as spclty_description,
	t.pretty_address
FROM @users t
WHERE LEFT(t.search_user_id, 1) = '!'


GO
GRANT EXECUTE
	ON [dbo].[sp_user_top_20_search_5]
	TO [cprsystem]
GO

