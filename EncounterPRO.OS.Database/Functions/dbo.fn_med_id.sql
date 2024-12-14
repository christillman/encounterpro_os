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

-- Drop Function [dbo].[fn_med_id]
Print 'Drop Function [dbo].[fn_med_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_med_id]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_med_id]
GO

-- Create Function [dbo].[fn_med_id]
Print 'Create Function [dbo].[fn_med_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_med_id (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24)
	 )

RETURNS int

AS
BEGIN


DECLARE @ll_medid int,
		@ll_med_name_id int,
		@ls_med_strength varchar(15),
		@ls_med_strength_uom varchar(15),
		@ls_med_dosage_form_abbr varchar(4),
		@ls_dosage_form varchar(15),
		@ls_code varchar(80),
		@ll_null int

SET @ll_null = NULL

-- Lookup the med name id from the drug id
SET @ls_code = dbo.fn_lookup_code('drug_id', @ps_drug_id, 'med_name_id', 108)
IF @ls_code IS NULL
	RETURN @ll_null

SET @ll_med_name_id = CAST(@ls_code AS int)

-- Get the details of the package
SELECT @ls_med_strength = CONVERT(varchar(8), administer_per_dose),
		@ls_med_strength_uom = dbo.fn_med_strength_unit(administer_unit, dose_amount, dose_unit),
		@ls_dosage_form = dosage_form
FROM c_Package
WHERE package_id = @ps_package_id

IF @@ROWCOUNT <> 1
	RETURN @ll_null

-- Lookup the dosage form abbreviation
SET @ls_med_dosage_form_abbr = dbo.fn_lookup_code('dosage_form', @ls_dosage_form, 'med_dosage_form_abbr', 108)
IF @ls_med_dosage_form_abbr IS NULL
	RETURN @ll_null

-- Now find the highest active composite drug that matches the med, strength and package
--SELECT @ll_medid = max(medid)
--FROM NewCropCompositeDrug
--WHERE med_name_id = @ll_med_name_id
--AND med_strength = @ls_med_strength
--AND med_strength_uom = @ls_med_strength_uom
--AND med_dosage_form_abbr = @ls_med_dosage_form_abbr
--AND status IN ('A', 'P')

RETURN @ll_medid

END
GO
GRANT EXECUTE
	ON [dbo].[fn_med_id]
	TO [cprsystem]
GO

