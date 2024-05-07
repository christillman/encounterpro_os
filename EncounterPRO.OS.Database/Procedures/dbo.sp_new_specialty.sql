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

-- Drop Procedure [dbo].[sp_new_specialty]
Print 'Drop Procedure [dbo].[sp_new_specialty]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_specialty]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_specialty]
GO

-- Create Procedure [dbo].[sp_new_specialty]
Print 'Create Procedure [dbo].[sp_new_specialty]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_specialty (
		@ps_specialty_id varchar(24) OUTPUT,
		@ps_description varchar(80),
		@pl_owner_id int,
		@ps_status varchar(12) = 'OK' )
AS

DECLARE @ls_specialty_key varchar(24),
		@ll_tries int

-- If a candidate key was supplied then see if it exists
IF @ps_specialty_id IS NOT NULL
	BEGIN
	IF EXISTS(SELECT 1 FROM c_Specialty WHERE specialty_id = @ps_specialty_id)
		RETURN 1
	END

-- If we get here, make sure we have a description
IF @ps_description IS NULL
	BEGIN
	RAISERROR ('Specialty description cannot be null',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_status = ''
	SET @ps_status = 'OK'

IF @ps_status IS NULL
	IF @pl_owner_id = 0
		SET @ps_status = 'OK'
	ELSE
		SET @ps_status = 'NA'

-- See if a specialty with the same description already exists
SELECT @ps_specialty_id = max(specialty_id)
FROM c_Specialty c
WHERE description = @ps_description

IF @ps_specialty_id IS NULL
	BEGIN
	-- Set our template either from the passed in key or from the description
	IF @ps_specialty_id IS NULL
		SET @ls_specialty_key = CAST(@ps_description AS varchar(24))
	ELSE
		SET @ls_specialty_key = @ps_specialty_id
	
	-- Initialize our candidate key from the template
	SET @ps_specialty_id = @ls_specialty_key
	
	SET @ll_tries = 0
	
	WHILE EXISTS(SELECT 1 FROM c_Specialty WHERE specialty_id = @ps_specialty_id)
		BEGIN
		SET @ll_tries = @ll_tries + 1
		IF @ll_tries >= 1000
			BEGIN
			SET @ps_specialty_id = NULL
			RETURN 0
			END
		
		SET @ps_specialty_id = CAST(@ls_specialty_key AS varchar(21)) + CAST(@ll_tries AS varchar(3))
		END

	-- If we get here then we have a specialty_id which does not exist in the c_Specialty table
	
	INSERT INTO c_Specialty (
		specialty_id,
		description,
		id,
		owner_id,
		last_updated,
		status)
	VALUES (
		@ps_specialty_id,
		@ps_description,
		newid(),
		@pl_owner_id,
		dbo.get_client_datetime(),
		@ps_status)
	
	END

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[sp_new_specialty]
	TO [cprsystem]
GO

