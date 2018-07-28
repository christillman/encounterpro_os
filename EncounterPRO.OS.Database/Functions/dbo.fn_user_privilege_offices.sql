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

-- Drop Function [dbo].[fn_user_privilege_offices]
Print 'Drop Function [dbo].[fn_user_privilege_offices]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_privilege_offices]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_privilege_offices]
GO

-- Create Function [dbo].[fn_user_privilege_offices]
Print 'Create Function [dbo].[fn_user_privilege_offices]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_user_privilege_offices (
	@ps_user_id varchar(24),
	@ps_privilege_id varchar(24)
	)

RETURNS @offices TABLE (
	office_id varchar(4) NOT NULL,
	office_nickname varchar(24) NOT NULL)
AS

BEGIN

DECLARE @ls_secure_flag char(1),
		@ll_rowcount int,
		@ll_error int

SELECT @ls_secure_flag = secure_flag
FROM c_Privilege
WHERE privilege_id = @ps_privilege_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	RETURN

IF @ls_secure_flag = 'Y'
	BEGIN
	INSERT INTO @offices (
		office_id,
		office_nickname)
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND user_id = @ps_user_id
		AND privilege_id = @ps_privilege_id
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	UNION
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND user_id = @ps_user_id
		AND privilege_id = 'Super User'
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	END
ELSE
	BEGIN
	INSERT INTO @offices (
		office_id,
		office_nickname)
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
	WHERE o.status = 'OK'
	AND NOT EXISTS (
		SELECT 1
		FROM o_User_Privilege p
		WHERE p.office_id = o.office_id
		AND p.user_id = @ps_user_id
		AND p.privilege_id = @ps_privilege_id
		AND p.access_flag = 'R' )
	UNION
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND user_id = @ps_user_id
		AND privilege_id = 'Super User'
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	END

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_user_privilege_offices]
	TO [cprsystem]
GO

