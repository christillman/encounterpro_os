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

-- Drop Procedure [dbo].[sp_get_package_id]
Print 'Drop Procedure [dbo].[sp_get_package_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_package_id]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_package_id]
GO

-- Create Procedure [dbo].[sp_get_package_id]
Print 'Create Procedure [dbo].[sp_get_package_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_package_id (
	@ps_description varchar(40),
	@ps_administer_method varchar(12),
	@ps_administer_unit varchar(12),
	@ps_dose_unit varchar(12),
	@pr_administer_per_dose real,
	@pr_dose_amount real = 1,
	@ps_dosage_form varchar(24) = NULL,
	@pl_owner_id int )

AS

DECLARE @ll_key_value integer
	, @ls_package_id varchar(24)


-- See if the package exists
SELECT @ls_package_id = max(package_id)
FROM c_Package
WHERE administer_method = @ps_administer_method
AND administer_unit = @ps_administer_unit
AND dose_unit = @ps_dose_unit
AND administer_per_dose = @pr_administer_per_dose
AND dose_amount = @pr_dose_amount

IF @ls_package_id IS NULL
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'package_ID',
		@pl_key_value = @ll_key_value OUTPUT

	SET @ls_package_id = '!JMJpackage' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))

	WHILE exists(select * from c_package where package_id = @ls_package_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'package_ID',
			@pl_key_value = @ll_key_value OUTPUT
			
		SET @ls_package_id = '!JMJpackage' + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		END


	IF @ps_dosage_form IS NULL
		SET @ps_dosage_form = '**'

	INSERT INTO c_package (
		package_id,
		administer_method,
		description,
		administer_unit,
		dose_unit,
		administer_per_dose,
		dose_amount,
		dosage_form)
	VALUES (
		@ls_package_id,
		@ps_administer_method,
		@ps_description,
		@ps_administer_unit,
		@ps_dose_unit,
		@pr_administer_per_dose,
		@pr_dose_amount,
		@ps_dosage_form)

	END

SELECT package_id = @ls_package_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_package_id]
	TO [cprsystem]
GO

