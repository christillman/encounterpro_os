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

-- Drop Procedure [dbo].[sp_get_next_component_counter]
Print 'Drop Procedure [dbo].[sp_get_next_component_counter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_next_component_counter]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_next_component_counter]
GO

-- Create Procedure [dbo].[sp_get_next_component_counter]
Print 'Create Procedure [dbo].[sp_get_next_component_counter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_next_component_counter
	(
	@ps_component_id varchar(24),
	@ps_attribute varchar(64),
	@pl_next_counter int OUTPUT
	)
AS

DECLARE @ll_attribute_sequence int,
		@ll_counter int

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM c_Component_Attribute
WHERE component_id = @ps_component_id
AND attribute = @ps_attribute

-- If the record doesn't exist then create it
IF @ll_attribute_sequence IS NULL
	BEGIN
	INSERT INTO c_Component_Attribute (
		component_id,
		attribute,
		value)
	VALUES (
		@ps_component_id,
		@ps_attribute,
		'1')
	
	SELECT @ll_attribute_sequence = @@IDENTITY
	END

SELECT @ll_counter = CONVERT(int, CONVERT(varchar(12),value))
FROM c_Component_Attribute (UPDLOCK)
WHERE component_id = @ps_component_id
AND attribute_sequence = @ll_attribute_sequence

IF @ll_counter > 0
	SET @ll_counter = @ll_counter + 1
ELSE
	SET @ll_counter = 1

UPDATE c_Component_Attribute
SET value = CONVERT(varchar(12), @ll_counter)
WHERE component_id = @ps_component_id
AND attribute_sequence = @ll_attribute_sequence

SELECT @pl_next_counter = @ll_counter


GO
GRANT EXECUTE
	ON [dbo].[sp_get_next_component_counter]
	TO [cprsystem]
GO

