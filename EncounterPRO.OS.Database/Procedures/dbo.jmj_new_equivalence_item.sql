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

-- Drop Procedure [dbo].[jmj_new_equivalence_item]
Print 'Drop Procedure [dbo].[jmj_new_equivalence_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_equivalence_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_equivalence_item]
GO

-- Create Procedure [dbo].[jmj_new_equivalence_item]
Print 'Create Procedure [dbo].[jmj_new_equivalence_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_equivalence_item (
	@pl_equivalence_group_id int ,
	@ps_object_id varchar(40) = NULL,
	@ps_object_key varchar(64),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_object_type varchar(24),
		@ls_item_object_type varchar(24),
		@lu_object_id uniqueidentifier,
		@ll_old_equivalence_group_id int,
		@ll_count int,
		@ls_object_id varchar(40)

SELECT @ls_object_type = object_type
FROM c_Equivalence_Group
WHERE equivalence_group_id = @pl_equivalence_group_id

IF @@ROWCOUNT = 0
	BEGIN
	RAISERROR ('Equivalence Group ID Not Found (%d)', 16, 1, @pl_equivalence_group_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_object_key IS NULL
	BEGIN
	RAISERROR ('object_key cannot be null', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_object_id IS NULL
	SET @lu_object_id = dbo.fn_object_id_from_key(@ls_object_type, @ps_object_key)
ELSE
	SET @lu_object_id = CAST(@ps_object_id AS uniqueidentifier)

SELECT @ll_old_equivalence_group_id = equivalence_group_id,
		@ls_item_object_type = object_type
FROM c_Equivalence
WHERE object_id = @lu_object_id

SET @ll_count = @@ROWCOUNT

IF @ls_item_object_type <> @ls_object_type
	BEGIN
	RAISERROR ('Item object_type doesn''t match equivalence group object_type (%s, %d)', 16, 1, @ps_object_key, @pl_equivalence_group_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_count = 1
	BEGIN
	IF @ll_old_equivalence_group_id IS NULL OR @ll_old_equivalence_group_id <> @pl_equivalence_group_id
		BEGIN

		-- If the object is already a member of a different group, that the two groups are equivalent, so let's merge them
		IF @ll_old_equivalence_group_id > 0
			BEGIN
			BEGIN TRANSACTION
			UPDATE c_Equivalence
			SET equivalence_group_id = @pl_equivalence_group_id
			WHERE equivalence_group_id = @ll_old_equivalence_group_id

			DELETE FROM c_Equivalence_Group
			WHERE equivalence_group_id = @ll_old_equivalence_group_id
			COMMIT TRANSACTION
			END
		ELSE
			UPDATE c_Equivalence
			SET equivalence_group_id = @pl_equivalence_group_id
			WHERE object_id = @lu_object_id
		END	
	END
ELSE
	BEGIN
	SET @ls_object_id = CAST(@lu_object_id AS varchar(40))
	RAISERROR ('object not found (%s)', 16, 1, @ls_object_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END


GO
GRANT EXECUTE
	ON [dbo].[jmj_new_equivalence_item]
	TO [cprsystem]
GO

