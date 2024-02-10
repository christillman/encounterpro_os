
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_user_top_20_search]
Print 'Drop Procedure [dbo].[sp_user_top_20_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_user_top_20_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_user_top_20_search]
GO

-- Create Procedure [dbo].[sp_user_top_20_search]
Print 'Create Procedure [dbo].[sp_user_top_20_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_user_top_20_search (
	@ps_top_20_code varchar(64) ,
	@ps_top_20_user_id varchar(24),
	@ps_role_prefix varchar(24) = NULL)
AS

DECLARE @users TABLE (
	top_20_user_id varchar(24) NOT NULL,
	top_20_code varchar(64) NOT NULL,
	top_20_sequence int NOT NULL,
	user_id varchar(24) NOT NULL,
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
	top_20_user_id,
	top_20_code,
	top_20_sequence,
	user_id,
	sort_sequence )
SELECT user_id,
	top_20_code,
	top_20_sequence,
	item_id,
	sort_sequence 
FROM u_Top_20 WITH (NOLOCK)
WHERE [user_id] = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code

UPDATE t
	SET user_full_name = u.user_full_name,
		color = u.color,
		icon = s.icon,
		user_status = ISNULL(u.user_status, 'NA')
FROM @users t
	INNER JOIN c_User u
	ON t.user_id = u.user_id
	LEFT OUTER JOIN c_Specialty s
	ON u.specialty_id = s.specialty_id
WHERE LEFT(t.user_id, 1) <> '!'

UPDATE t
	SET user_full_name = '<' + @ps_role_prefix + r.role_name + '>',
		color = r.color,
		icon = r.icon,
		user_status = 'ROLE'
FROM @users t
	INNER JOIN c_Role r
	ON t.user_id = r.role_id
WHERE LEFT(t.user_id, 1) = '!'

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


SELECT t.user_id,
	t.top_20_user_id,
	t.top_20_code,
	t.top_20_sequence,
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
	ON u.user_id = t.user_id
	LEFT OUTER JOIN c_Specialty s
	ON u.specialty_id = s.specialty_id


GO
GRANT EXECUTE
	ON [dbo].[sp_user_top_20_search]
	TO [cprsystem]
GO

