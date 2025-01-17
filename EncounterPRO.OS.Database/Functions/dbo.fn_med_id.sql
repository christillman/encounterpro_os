﻿
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
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_med_id (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24)
	 )

RETURNS int

AS
BEGIN
-- Unused function 2025-01-01 (also, always returns null, and unknown table NewCropCompositeDrug)

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

IF @ls_med_strength IS NULL
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

