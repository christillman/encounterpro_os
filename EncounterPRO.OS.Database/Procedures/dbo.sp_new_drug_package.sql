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

-- Drop Procedure [dbo].[sp_new_drug_package]
Print 'Drop Procedure [dbo].[sp_new_drug_package]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_drug_package]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_drug_package]
GO

-- Create Procedure [dbo].[sp_new_drug_package]
Print 'Create Procedure [dbo].[sp_new_drug_package]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_drug_package (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24),
	@ps_prescription_flag char(1) = 'Y',
	@pr_default_dispense_amount real = NULL,
	@ps_default_dispense_unit varchar(12) = NULL,
	@ps_take_as_directed char(1) = 'N',
	@pi_sort_order smallint = NULL )
AS
DECLARE @li_sort_order smallint
IF @pi_sort_order IS NULL
	BEGIN
	SELECT @li_sort_order = max(sort_order)
	FROM c_Drug_Package
	WHERE drug_id = @ps_drug_id
	AND package_id = @ps_package_id
	IF @li_sort_order IS NULL
		SELECT @li_sort_order = 1
	ELSE
		SELECT @li_sort_order = @li_sort_order + 1
	END
ELSE
	SELECT @li_sort_order = @pi_sort_order

IF @ps_default_dispense_unit IS NULL
	SELECT @ps_default_dispense_unit = dose_unit
	FROM c_Package
	WHERE package_id = @ps_package_id

INSERT INTO c_Drug_Package (
	drug_id,
	package_id,
	prescription_flag,
	default_dispense_amount,
	default_dispense_unit,
	take_as_directed,
	sort_order )
VALUES (
	@ps_drug_id,
	@ps_package_id,
	@ps_prescription_flag,
	@pr_default_dispense_amount,
	@ps_default_dispense_unit,
	@ps_take_as_directed,
	@pi_sort_order )

GO
GRANT EXECUTE
	ON [dbo].[sp_new_drug_package]
	TO [cprsystem]
GO

