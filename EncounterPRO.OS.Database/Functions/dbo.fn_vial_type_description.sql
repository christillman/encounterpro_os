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

-- Drop Function [dbo].[fn_vial_type_description]
Print 'Drop Function [dbo].[fn_vial_type_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_vial_type_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_vial_type_description]
GO

-- Create Function [dbo].[fn_vial_type_description]
Print 'Create Function [dbo].[fn_vial_type_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_vial_type_description (
	@ps_vial_type varchar(24) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_description varchar(80),
	@ll_full_strength_ratio int,
	@ls_dilute_from_vial_type varchar(24),
	@ll_dilute_ratio int,
	@ls_full_strength_string varchar(24),
	@ls_full_strength_commas varchar(24),
	@ll_groups int,
	@ll_counter int,
	@ll_groupstart int

-- Get info about the vial type
SELECT @ll_full_strength_ratio = full_strength_ratio,
	@ls_dilute_from_vial_type = dilute_from_vial_type,
	@ll_dilute_ratio = dilute_ratio
FROM c_Vial_Type
WHERE vial_type = @ps_vial_type

IF @@ROWCOUNT <> 1
	BEGIN
	SET @ls_description = NULL
	RETURN @ls_description
	END

SET @ls_full_strength_string = CAST(@ll_full_strength_ratio AS varchar(24))
IF LEN(@ls_full_strength_string) >= 4
	BEGIN
	SET @ls_full_strength_commas = ''
	SET @ll_groups = (LEN(@ls_full_strength_string) - 1) / 3
	SET @ll_counter = 1
	WHILE @ll_counter <= @ll_groups
		BEGIN
		IF @ll_counter > 1
			SET @ls_full_strength_commas = ',' + @ls_full_strength_commas
		SET @ll_groupstart = LEN(@ls_full_strength_string) - (3 * @ll_counter) + 1
		SET @ls_full_strength_commas = SUBSTRING(@ls_full_strength_string, @ll_groupstart, 3) + @ls_full_strength_commas

		SET @ll_counter = @ll_counter + 1
		END
	IF LEN(@ls_full_strength_string) > (3 * @ll_groups)
		SET @ls_full_strength_commas = SUBSTRING(@ls_full_strength_string, 1, LEN(@ls_full_strength_string) - (3 * @ll_groups)) + ',' + @ls_full_strength_commas
	END
ELSE
	SET @ls_full_strength_commas = @ls_full_strength_string

SET @ls_description = '1:' + @ls_full_strength_commas
SET @ls_description = @ls_description + ' ' + @ps_vial_type

RETURN @ls_description 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_vial_type_description]
	TO [cprsystem]
GO

