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

-- Drop Function [dbo].[fn_equivalent_objects]
Print 'Drop Function [dbo].[fn_equivalent_objects]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_equivalent_objects]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_equivalent_objects]
GO

-- Create Function [dbo].[fn_equivalent_objects]
Print 'Create Function [dbo].[fn_equivalent_objects]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_equivalent_objects (
	@ps_object_type varchar(24),
	@ps_object_key varchar(64))

RETURNS @equivalent_objects TABLE (
	object_id uniqueidentifier NOT NULL,
	object_key varchar(64) NOT NULL,
	description varchar(80) NOT NULL
	)
AS

BEGIN

DECLARE @ll_equivalence_group_id int

-- See if we have an equivalence group for this object
SELECT @ll_equivalence_group_id = equivalence_group_id
FROM c_Equivalence
WHERE object_type = @ps_object_type
AND object_key = @ps_object_key

-- These are mostly NULL or not-found
IF @ll_equivalence_group_id > 0 
	INSERT INTO @equivalent_objects (
		object_id ,
		object_key ,
		description )
	SELECT object_id,
			object_key,
			description
	FROM c_Equivalence
	WHERE equivalence_group_id = @ll_equivalence_group_id
ELSE
	INSERT INTO @equivalent_objects (
		object_id ,
		object_key ,
		description )
	SELECT object_id,
			object_key,
			description
	FROM c_Equivalence e
	WHERE object_type = @ps_object_type
	AND object_key = @ps_object_key



RETURN
END

GO
GRANT SELECT ON [dbo].[fn_equivalent_objects] TO [cprsystem]
GO

