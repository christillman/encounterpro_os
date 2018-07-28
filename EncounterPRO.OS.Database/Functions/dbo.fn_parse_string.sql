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

-- Drop Function [dbo].[fn_parse_string]
Print 'Drop Function [dbo].[fn_parse_string]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_parse_string]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_parse_string]
GO

-- Create Function [dbo].[fn_parse_string]
Print 'Create Function [dbo].[fn_parse_string]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_parse_string (
	@ps_string varchar(4000),
	@ps_delimiter varchar(40) )

RETURNS @items TABLE (
	[item_number] int NOT NULL IDENTITY (1, 1),
	[item] [varchar] (255) NOT NULL)
AS

BEGIN

DECLARE @ls_string varchar(4000),
		@ls_item varchar(255),
		@ll_pos int

IF @ps_string IS NULL OR @ps_delimiter IS NULL
	RETURN

SET @ls_string = @ps_string

WHILE LEN(@ls_string) > 0
	BEGIN
	SET @ll_pos = PATINDEX('%' + @ps_delimiter + '%', @ls_string)

	IF @ll_pos > 0
		BEGIN
		IF @ll_pos = 0
			SET @ls_item = ''
		ELSE
			SET @ls_item = CAST(LEFT(@ls_string, @ll_pos - 1) AS varchar(255))

		SET @ls_string = SUBSTRING (@ls_string ,LEN(@ls_item) + LEN(@ps_delimiter) + 1, LEN(@ls_string) )

		END
	ELSE
		BEGIN
		-- Patter was not found, so the rest of the string is the last item
		SET @ls_item = CAST(@ls_string AS varchar(255))
		SET @ls_string = ''
		END

	INSERT INTO @items (
		item)
	VALUES (
		@ls_item)

	END


RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_parse_string]
	TO [cprsystem]
GO

