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

-- Drop Function [dbo].[fn_pretty_address]
Print 'Drop Function [dbo].[fn_pretty_address]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_pretty_address]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_pretty_address]
GO

-- Create Function [dbo].[fn_pretty_address]
Print 'Create Function [dbo].[fn_pretty_address]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_pretty_address (
	@ps_address_line_1 varchar(40),
	@ps_address_line_2 varchar(40),
	@ps_city varchar(40),
	@ps_state varchar(2),
	@ps_zip varchar(10),
	@ps_country varchar(20))

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_pretty_address varchar(80),
		@ls_city_state_zip varchar(60),
		@ls_line_delimiter varchar(8)

SET @ls_pretty_address = ''
SET @ls_line_delimiter = '  '

IF LEN(@ps_address_line_1) > 0 
	SET @ls_pretty_address = @ls_pretty_address + @ps_address_line_1

IF LEN(IsNull(@ps_address_line_2,'')) > 0
	BEGIN
	IF LEN(@ls_pretty_address) > 0
		SET @ls_pretty_address = @ls_pretty_address + @ls_line_delimiter
	SET @ls_pretty_address = @ls_pretty_address + @ps_address_line_2
	END

SET @ls_city_state_zip = ''

IF LEN(@ps_city) > 0
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_city


IF LEN(IsNull(@ps_state,'')) > 0
	BEGIN
	IF LEN(@ls_city_state_zip) > 0
		SET @ls_city_state_zip = @ls_city_state_zip + ', '
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_state
	END


IF LEN(IsNull(@ps_zip,'')) > 0
	BEGIN
	IF LEN(@ls_city_state_zip) > 0
		SET @ls_city_state_zip = @ls_city_state_zip + '  '
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_zip
	END


IF LEN(@ls_city_state_zip) > 0
	BEGIN
	IF LEN(@ls_pretty_address) > 0 
		SET @ls_pretty_address = @ls_pretty_address + @ls_line_delimiter
	SET @ls_pretty_address = @ls_pretty_address + @ls_city_state_zip
	END



RETURN @ls_pretty_address 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_pretty_address]
	TO [cprsystem]
GO

