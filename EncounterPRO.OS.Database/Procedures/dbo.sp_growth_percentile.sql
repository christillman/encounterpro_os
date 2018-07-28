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

-- Drop Procedure [dbo].[sp_growth_percentile]
Print 'Drop Procedure [dbo].[sp_growth_percentile]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_growth_percentile]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_growth_percentile]
GO

-- Create Procedure [dbo].[sp_growth_percentile]
Print 'Create Procedure [dbo].[sp_growth_percentile]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 7/25/2000 8:43:57 AM ******/
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 2/16/99 12:00:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 10/26/98 2:20:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 10/4/98 6:28:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 9/24/98 3:06:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_growth_percentile    Script Date: 8/17/98 4:16:49 PM ******/
CREATE PROCEDURE sp_growth_percentile (
	@ps_measurement varchar(12),
	@ps_sex char(1),
	@pi_age_months smallint,
	@pr_value real,
	@pr_percentile real OUTPUT)
AS
DECLARE @lr_percentile_5 real
DECLARE @lr_percentile_10 real
DECLARE @lr_percentile_25 real
DECLARE @lr_percentile_50 real
DECLARE @lr_percentile_75 real
DECLARE @lr_percentile_90 real
DECLARE @lr_percentile_95 real
SELECT @lr_percentile_5 = percentile_5 ,
	@lr_percentile_10 = percentile_10 ,
	@lr_percentile_25 = percentile_25 , 	@lr_percentile_50 = percentile_50 ,
	@lr_percentile_75 = percentile_75 ,
	@lr_percentile_90 = percentile_90 ,
	@lr_percentile_95 = percentile_95  FROM c_Growth_Data (NOLOCK)
WHERE	measurement = @ps_measurement
AND	sex = @ps_sex
AND	age_months = @pi_age_months
IF @@rowcount < 1
BEGIN
RAISERROR ('Percentile not found (%s, %s, %d)',16,-1, @ps_measurement, @ps_sex, @pi_age_months)
ROLLBACK TRANSACTION
RETURN
END
IF @pr_value < @lr_percentile_5
BEGIN
IF @pr_value < @lr_percentile_5 + @lr_percentile_5 - @lr_percentile_10
	SELECT @pr_percentile = 1
ELSE
	SELECT @pr_percentile = 3
END
ELSE IF @pr_value < @lr_percentile_10
	SELECT @pr_percentile = 5 + (5 * (@pr_value - @lr_percentile_5)/(@lr_percentile_10 - @lr_percentile_5))
ELSE IF @pr_value < @lr_percentile_25
	SELECT @pr_percentile = 10 + (15 * (@pr_value - @lr_percentile_10)/(@lr_percentile_25 - @lr_percentile_10))
ELSE IF @pr_value < @lr_percentile_50
	SELECT @pr_percentile = 25 + (25 * (@pr_value - @lr_percentile_25)/(@lr_percentile_50 - @lr_percentile_25))
ELSE IF @pr_value < @lr_percentile_75
	SELECT @pr_percentile = 50 + (25 * (@pr_value - @lr_percentile_50)/(@lr_percentile_75 - @lr_percentile_50))
ELSE IF @pr_value < @lr_percentile_90
	SELECT @pr_percentile = 75 + (15 * (@pr_value - @lr_percentile_75)/(@lr_percentile_90 - @lr_percentile_75))
ELSE IF @pr_value <= @lr_percentile_95
	SELECT @pr_percentile = 90 + (5 * (@pr_value - @lr_percentile_90)/(@lr_percentile_95 - @lr_percentile_90))
ELSE IF @pr_value > @lr_percentile_95 + @lr_percentile_95 - @lr_percentile_90
SELECT @pr_percentile = 99
ELSE
SELECT @pr_percentile = 97

GO
GRANT EXECUTE
	ON [dbo].[sp_growth_percentile]
	TO [cprsystem]
GO

