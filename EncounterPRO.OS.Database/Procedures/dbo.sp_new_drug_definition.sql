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

-- Drop Procedure [dbo].[sp_new_drug_definition]
Print 'Drop Procedure [dbo].[sp_new_drug_definition]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_drug_definition]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_drug_definition]
GO

-- Create Procedure [dbo].[sp_new_drug_definition]
Print 'Create Procedure [dbo].[sp_new_drug_definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_drug_definition (
	@ps_drug_type varchar(24),
	@ps_common_name varchar(40),
	@ps_generic_name varchar(80),
	@ps_status varchar(12) = 'OK',
	@ps_controlled_substance_flag varchar(12) = 'Y',
	@pr_default_duration_amount real = NULL,
	@ps_default_duration_unit varchar(12) = NULL,
	@ps_default_duration_prn varchar(32) = NULL,
	@pr_max_dose_per_day real = NULL,
	@ps_max_dose_unit varchar(12) = NULL,
	@pl_owner_id int = NULL,
	@ps_drug_id varchar(24) OUTPUT )

AS

DECLARE @ll_key_value integer,
	@ls_drug_id varchar(24),
	@ls_status varchar(12)

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_drug_type IS NULL OR @ps_drug_type = '' OR @ps_drug_type = 'Drug'
	SET @ps_drug_type = 'Single Drug'

IF @ps_common_name IS NULL OR @ps_common_name = ''
	BEGIN
	RAISERROR ('No common name supplied',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- See if drug already exists with drug_type/common_name combination
SELECT TOP 1 @ps_drug_id = drug_id,
			@ls_status = status
FROM c_Drug_Definition
WHERE drug_type = @ps_drug_type
AND common_name = @ps_common_name
ORDER BY status desc

IF @@ROWCOUNT <= 0 OR @ps_drug_id IS NULL
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'DRUG_ID',
		@pl_key_value = @ll_key_value OUTPUT
		
	SET @ls_drug_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_Drug_Definition where drug_id = @ls_drug_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'DRUG_ID',
			@pl_key_value = @ll_key_value OUTPUT
			
		SET @ls_drug_id = CAST(@pl_owner_id AS varchar(12)) + '^' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END


	INSERT INTO c_Drug_Definition (
		drug_id,
		drug_type,
		common_name,
		generic_name,
		status ,
		controlled_substance_flag ,
		default_duration_amount ,
		default_duration_unit ,
		default_duration_prn ,
		max_dose_per_day ,
		max_dose_unit ,
		owner_id )
	VALUES (
		@ls_drug_id,
		@ps_drug_type,
		@ps_common_name,
		@ps_generic_name,
		@ps_status ,
		@ps_controlled_substance_flag ,
		@pr_default_duration_amount ,
		@ps_default_duration_unit ,
		@ps_default_duration_prn ,
		@pr_max_dose_per_day ,
		@ps_max_dose_unit ,
		@pl_owner_id )

	SET @ps_drug_id = @ls_drug_id
	END
ELSE
	BEGIN
	IF @ls_status = 'NA' AND @ps_status = 'OK'
		UPDATE c_Drug_Definition
		SET status = 'OK'
		WHERE drug_id = @ps_drug_id
	
	END
	
GO
GRANT EXECUTE
	ON [dbo].[sp_new_drug_definition]
	TO [cprsystem]
GO

