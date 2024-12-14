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

-- Drop Function [dbo].[fn_cdc_growth_bmi]
Print 'Drop Function [dbo].[fn_cdc_growth_bmi]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_cdc_growth_bmi]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_cdc_growth_bmi]
GO

-- Create Function [dbo].[fn_cdc_growth_bmi]
Print 'Create Function [dbo].[fn_cdc_growth_bmi]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_cdc_growth_bmi (
	@ps_growth_class varchar(24),
	@pdt_date_of_birth datetime,
	@pdt_date_of_measure datetime,
	@ps_sex char(1),
	@ld_weight decimal(18, 6),
	@ls_weight_unit varchar(24),
	@ld_height decimal(18, 6),
	@ls_height_unit varchar(24)
	)

RETURNS decimal(18, 6)
AS

BEGIN

DECLARE @ld_percentile decimal(18, 6),
		@ld_weight_kg decimal(18, 6),
		@ld_height_cm decimal(18, 6),
		@ld_bmi decimal(18, 6),
		@ld_x decimal(18, 6),
		@ld_l decimal(18, 6),
		@ld_m decimal(18, 6),
		@ld_s decimal(18, 6),
		@ld_age decimal(18, 6),
		@ld_months1 decimal(18, 6),
		@ld_percentile1 decimal(18, 6),
		@ld_months2 decimal(18, 6),
		@ld_percentile2 decimal(18, 6),
		@li_sex smallint,
		@ll_days int,
		@ld_current_age_months decimal(18, 6)

SET @ld_percentile = NULL

IF @ps_sex = 'M'
	SET @li_sex = 1
ELSE
	SET @li_sex = 2

SET @ll_days = DATEDIFF(day, @pdt_date_of_birth, @pdt_date_of_measure)
SET @ld_current_age_months = CAST(@ll_days AS decimal(18, 6)) / 30.42

-- Make sure the weight is in KG
SET @ld_weight_kg = dbo.fn_convert_units(@ld_weight, @ls_weight_unit, 'KG')
IF @ld_weight_kg IS NULL OR @ld_weight_kg <= 0
	RETURN @ld_percentile

-- Make sure the height is in CM
SET @ld_height_cm = dbo.fn_convert_units(@ld_height, @ls_height_unit, 'CM')
IF @ld_height_cm IS NULL OR @ld_height_cm <= 0
	RETURN @ld_percentile

-- Calculate the BMI
SET @ld_bmi = 10000 * @ld_weight_kg / POWER(@ld_height_cm, 2)
IF @ld_bmi IS NULL OR @ld_bmi <= 0
	RETURN @ld_percentile


--Find the "Under" and "Over" months
SELECT @ld_months1 = max(months)
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months <= @ld_current_age_months

SELECT @ld_months2 = min(months)
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months >= @ld_current_age_months

-- If we don't have an under or over then return NULL
IF @ld_months1 IS NULL AND @ld_months2 IS NULL
	RETURN @ld_percentile

-- If we only have and "Over" then use it for both
IF @ld_months1 IS NULL AND @ld_months2 IS NOT NULL
	SET @ld_months1 = @ld_months2

-- If we only have and "Under" then use it for both
IF @ld_months1 IS NOT NULL AND @ld_months2 IS NULL
	SET @ld_months2 = @ld_months1

-- Get the LMS values for the "Under" month
SELECT 	@ld_l = l,
		@ld_m = m,
		@ld_s = s
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months = @ld_months1

-- Get the percentile for the "Under" month
SET @ld_percentile1 = dbo.fn_cdc_lms_calc(@ld_bmi, @ld_l, @ld_m, @ld_s)

-- If  the "Under" is the same as the "Over" then we're done
IF @ld_months1 = @ld_months2
	RETURN @ld_percentile1

-- Get the LMS values for the "Over" month
SELECT 	@ld_l = l,
		@ld_m = m,
		@ld_s = s
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months = @ld_months2

-- Get the percentile for the "Over" month
SET @ld_percentile2 = dbo.fn_cdc_lms_calc(@ld_bmi, @ld_l, @ld_m, @ld_s)

-- Interpolate between the "Over" and "Under"
SET @ld_percentile = dbo.fn_cdc_interpolate_percentile(@ld_current_age_months, @ld_months1, @ld_percentile1, @ld_months2, @ld_percentile2)

RETURN @ld_percentile
END

GO
GRANT EXECUTE
	ON [dbo].[fn_cdc_growth_bmi]
	TO [cprsystem]
GO

