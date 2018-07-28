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

-- Drop Procedure [dbo].[jmj_Set_Patient_IDValue]
Print 'Drop Procedure [dbo].[jmj_Set_Patient_IDValue]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_Set_Patient_IDValue]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_Set_Patient_IDValue]
GO

-- Create Procedure [dbo].[jmj_Set_Patient_IDValue]
Print 'Create Procedure [dbo].[jmj_Set_Patient_IDValue]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_Set_Patient_IDValue (
	@ps_cpr_id varchar(24),
	@pl_owner_id int,
	@ps_IDDomain varchar(30),
	@ps_IDValue varchar(255),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40),
	@ll_customer_id int,
	@ls_current_value varchar(255),
	@ll_rowcount int,
	@ll_error int,
	@ll_encounter_id int,
	@ls_other_cpr_id varchar(12)

SET @ll_encounter_id = NULL

IF @ps_cpr_id IS NULL
	BEGIN
	RAISERROR ('Null cpr_id',16,-1)
	RETURN -1
	END

IF @ps_IDDomain IS NULL
	BEGIN
	RAISERROR ('Null IDDomain',16,-1)
	RETURN -1
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain

-- Make sure this represents a change
SET @ls_current_value = dbo.fn_lookup_patient_ID(@ps_cpr_id, @pl_owner_id, @ps_IDDomain)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

IF @ls_current_value = @ps_IDValue
	RETURN 1

-- Make sure that this ID is not assigned to another patient
SET @ls_other_cpr_id = dbo.fn_lookup_patient2(@pl_owner_id, @ps_IDDomain, @ps_IDValue)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

IF LEN(@ls_other_cpr_id) > 0 AND @ls_other_cpr_id <> @ps_cpr_id
	BEGIN
	RAISERROR ('Cannot assign ID Value (%d, %s, %s) to patient (%s) because it already belongs to a different patient (%s)',16,-1, @pl_owner_id, @ps_IDDomain, @ps_IDValue, @ps_cpr_id, @ls_other_cpr_id)
	RETURN -1
	END


SELECT @ll_length = LEN(@ps_IDValue)

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_IDValue)

	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@ll_encounter_id,
		@ps_created_by,
		getdate(),
		'ID',
		@ls_progress_key,
		@ls_progress_value,
		NULL,
		NULL,
		NULL,
		getdate(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@ll_encounter_id,
		@ps_created_by,
		getdate(),
		'ID',
		@ls_progress_key,
		@ps_IDValue,
		NULL,
		NULL,
		NULL,
		getdate(),
		@ps_created_by )



GO
GRANT EXECUTE
	ON [dbo].[jmj_Set_Patient_IDValue]
	TO [cprsystem]
GO

