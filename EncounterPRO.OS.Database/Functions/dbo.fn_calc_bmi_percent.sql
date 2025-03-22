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

-- Drop Function [dbo].[fn_calc_bmi_percent]
Print 'Drop Function [dbo].[fn_calc_bmi_percent]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_calc_bmi_percent]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_calc_bmi_percent]
GO

-- Create Function [dbo].[fn_calc_bmi_percent]
Print 'Create Function [dbo].[fn_calc_bmi_percent]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_calc_bmi_percent (
	@dec_bmi decimal(15,7)
	,@l1 decimal(9,7)
	,@m1 decimal(9,7)
	,@s1 decimal(9,7)
	,@ld_age decimal(9,3)
	,@ld_months1 decimal(9,3)
	,@ld_months2 decimal(9,3)
	,@l2 decimal(9,7)
	,@m2 decimal(9,2)
	,@s2 decimal(9,2)
	)
RETURNS decimal(19,3)

AS
BEGIN

DECLARE @b1 decimal(9,8),@b2 decimal(9,8),@b3 decimal(9,8),@b4 decimal(9,8),@b5 decimal(9,8)
DECLARE @ab decimal(9,8)
DECLARE @z  decimal(19,9)
DECLARE @k  decimal(19,9)
DECLARE @temp decimal(19,9)
DECLARE @ld_percentile1 decimal(19,9)
DECLARE @ld_percentile2 decimal(19,9)
DECLARE @ld_percentile_interpolated decimal(19,9)
Declare @calc_percent decimal(19,3)

SET @b1 = 0.31938153
SET @b2 = -0.356563782
SET @b3 = 1.781477937
SET @b4 = -1.821255978
SET @b5 = 1.330274429
SET @ab = 0.2316419

-- Find Z value
Set @z = (Power((@dec_bmi/@m1),@l1)) - 1
Set @z = @z/(@l1*@s1)

-- Find Percentile from Z value
Set @k = 1 / (1 + @ab * Abs(@z))
Set @temp = @b1 * @k + @b2 * Power(@k, 2) + @b3 * Power(@k,3) + @b4 * Power(@k,4) + @b5 * Power(@k,5)
Set @temp = 1 - (1 / SQRT(2 * PI())) * Exp(-Power((Abs(@z)),2) / 2) * @temp

If @z > 0 
BEGIN
	Set @ld_percentile1 =  @temp
END	
Else
BEGIN
	Set @ld_percentile1 =  1 - @temp
End 

if @ld_age = @ld_months1 
BEGIN
	Set @ld_percentile_interpolated = @ld_percentile1
END
else
BEGIN
	Set @z = (Power((@dec_bmi/@m2), @l2)) - 1
	Set @z = @z/(@l2*@s2)
	
-- Find Percentile from Z value
	Set @k = 1 / (1 + @ab * Abs(@z))
	Set @temp = @b1 * @k + @b2 * Power(@k, 2) + @b3 * Power(@k,3) + @b4 * Power(@k,4) + @b5 * Power(@k,5)
	Set @temp = 1 - (1 / SQRT(2 * PI())) * Exp(-Power((Abs(@z)),2) / 2) * @temp

	If @z > 0 
	BEGIN
		Set @ld_percentile2 =  @temp
	END
	Else
	BEGIN
		Set @ld_percentile2 =  1 - @temp
	End
	Set @ld_percentile_interpolated = @ld_percentile1 + ((@ld_age - @ld_months1) * (@ld_percentile2 - @ld_percentile1) / (@ld_months2 - @ld_months1) )
END

if @ld_percentile_interpolated IS NOT NULL 
BEGIN
	SET @calc_percent = Round((@ld_percentile_interpolated * 100),3)
END
RETURN @calc_percent

END


GO
GRANT EXECUTE
	ON [dbo].[fn_calc_bmi_percent]
	TO [cprsystem]
GO

