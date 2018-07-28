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

-- Drop Procedure [dbo].[sp_generate_billing_id]
Print 'Drop Procedure [dbo].[sp_generate_billing_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_generate_billing_id]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_generate_billing_id]
GO

-- Create Procedure [dbo].[sp_generate_billing_id]
Print 'Create Procedure [dbo].[sp_generate_billing_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_generate_billing_id (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	--CWW, 01/13/03, dblib to oledb project
	--,@ps_billing_id varchar(24) OUTPUT 
	)
AS

DECLARE @ll_billing_id int,
		@ll_test int,
		@ls_billing_id varchar(24),
		@ll_last_key int

-- Take a lock on the cpr_id lastkey because we might want to update it later
SELECT @ll_last_key = last_key
FROM p_Lastkey (UPDLOCK)
WHERE cpr_id = '!CPR'
AND key_id = 'CPR_ID'

SET @ll_billing_id = CONVERT(int, @ps_cpr_id)

IF @ll_billing_id < 0 or @ll_billing_id IS NULL
	SET @ll_billing_id = 1

WHILE 1 = 1
	BEGIN
	SET @ls_billing_id = CONVERT(varchar(24), @ll_billing_id)
	
	SELECT @ll_test = 1
	WHERE EXISTS (
		SELECT cpr_id
		FROM p_Patient
		WHERE billing_id = @ls_billing_id )
	
	IF @@ROWCOUNT <> 1
		BREAK
	
	SET @ll_billing_id = @ll_billing_id + 1
	END

EXECUTE sp_Set_Patient_Progress
	@ps_cpr_id = @ps_cpr_id,
	@ps_progress_type = 'Modify',
	@ps_progress_key = 'billing_id',
	@ps_progress = @ls_billing_id ,
	@ps_user_id = @ps_user_id,
	@ps_created_by = @ps_created_by

IF @ll_billing_id > @ll_last_key
	UPDATE p_Lastkey
	SET last_key = @ll_billing_id
	WHERE cpr_id = '!CPR'
	AND key_id = 'CPR_ID'

--SET @ps_billing_id = @ls_billing_id

--CWW, 01/13/03, dblib to oledb project
SELECT @ls_billing_id as billing_id


GO
GRANT EXECUTE
	ON [dbo].[sp_generate_billing_id]
	TO [cprsystem]
GO

