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

-- Drop Function [dbo].[fn_get_preference]
Print 'Drop Function [dbo].[fn_get_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_get_preference]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_get_preference]
GO

-- Create Function [dbo].[fn_get_preference]
Print 'Create Function [dbo].[fn_get_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_get_preference (
	@ps_preference_type varchar(24),
	@ps_preference_id varchar(40),
	@ps_user_id varchar(40) = NULL,
	@pl_computer_id int = NULL
	)

RETURNS varchar(255)

AS

BEGIN

DECLARE @ls_preference_value varchar(255),
		@ls_global_flag char(1),
		@ls_office_flag char(1),
		@ls_computer_flag char(1),
		@ls_specialty_flag char(1),
		@ls_user_flag char(1),
		@ls_universal_flag char(1)

SELECT @ls_preference_value = NULL

SELECT @ps_preference_type = COALESCE(@ps_preference_type, preference_type),
		@ls_global_flag = global_flag ,
		@ls_office_flag = office_flag ,
		@ls_computer_flag = computer_flag ,
		@ls_specialty_flag = specialty_flag ,
		@ls_user_flag = user_flag ,
		@ls_universal_flag = universal_flag
FROM c_Preference
WHERE preference_id = @ps_preference_id

IF @ls_universal_flag IN ('C', 'Y')
	RETURN dbo.fn_get_global_preference(@ps_preference_type, @ps_preference_id)

-- See if there's a user preference
SELECT @ls_preference_value = preference_value
FROM o_preferences
WHERE preference_level = 'User'
AND preference_key = @ps_user_id
AND preference_id = @ps_preference_id

-- If not, then see if there's a specialty preference
IF @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences p
		INNER JOIN c_User u
		ON p.preference_key = u.specialty_id
	WHERE p.preference_level = 'Specialty'
	AND u.user_id = @ps_user_id
	AND p.preference_id = @ps_preference_id

-- If not, then see if there's a computer preference
IF @pl_computer_id IS NOT NULL AND  @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_level = 'Computer'
	AND preference_key = CAST(@pl_computer_id AS varchar(40))
	AND preference_id = @ps_preference_id

-- If not, then see if there's an office preference
IF @pl_computer_id IS NOT NULL AND  @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences p
		INNER JOIN o_Users u
		ON p.preference_key = u.office_id
	WHERE p.preference_level = 'Office'
	AND u.user_id = @ps_user_id
	AND u.computer_id = @pl_computer_id
	AND p.preference_id = @ps_preference_id

-- If not, then see if there's a global preference
IF @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

RETURN @ls_preference_value

END


GO
GRANT EXECUTE
	ON [dbo].[fn_get_preference]
	TO [cprsystem]
GO

