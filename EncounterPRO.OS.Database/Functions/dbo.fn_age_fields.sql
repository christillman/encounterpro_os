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

-- Drop Function [dbo].[fn_age_fields]
Print 'Drop Function [dbo].[fn_age_fields]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_age_fields]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_age_fields]
GO

-- Create Function [dbo].[fn_age_fields]
Print 'Create Function [dbo].[fn_age_fields]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_age_fields (
	@pdt_from_date datetime,
	@pdt_to_date datetime)

RETURNS @age_fields TABLE (
	pretty_age varchar(12) NULL,
	pretty_age_amount int NULL,
	pretty_age_unit varchar(12) NULL,
	age_years int NULL,
	age_months int NULL,
	age_days int NULL,
	age_total_months int NULL,
	age_total_days int NULL
	)
AS
BEGIN
DECLARE @ls_pretty_age varchar(12),
		@ll_pretty_age_amount int,
		@ls_pretty_age_unit varchar(12),
		@ll_age_years int ,
		@ll_age_months int ,
		@ll_age_days int ,
		@ll_age_total_months int ,
		@ll_age_total_days int 

SET @ll_age_total_days = DATEDIFF(day, @pdt_from_date, @pdt_to_date)
SET @ll_age_total_months = dbo.fn_age_months(@pdt_from_date, @pdt_to_date)
SET @ll_age_years = @ll_age_total_months / 12

SET @ll_age_months = @ll_age_total_months - (@ll_age_years * 12)
SET @ll_age_days = DATEDIFF(day, DATEADD(month, @ll_age_total_months, @pdt_from_date), @pdt_to_date)

IF @ll_age_total_months >= 36
	BEGIN
	-- Show years
	SET @ll_pretty_age_amount = @ll_age_years
	SET @ls_pretty_age_unit = 'Year'
	END
ELSE IF @ll_age_total_months >= 2
	BEGIN
	-- Show months
	SET @ll_pretty_age_amount = @ll_age_total_months
	SET @ls_pretty_age_unit = 'Month'
	END
ELSE IF @ll_age_total_days >= 7
	BEGIN
	-- Show weeks
	SET @ll_pretty_age_amount = @ll_age_total_days / 7
	SET @ls_pretty_age_unit = 'Week'
	END
ELSE
	BEGIN
	-- Show days
	SET @ll_pretty_age_amount = @ll_age_total_days
	SET @ls_pretty_age_unit = 'Day'
	END

SET @ls_pretty_age = CAST(@ll_pretty_age_amount AS varchar(8)) + ' ' + @ls_pretty_age_unit
IF @ll_pretty_age_amount <> 1
	SET @ls_pretty_age = @ls_pretty_age + 's'

INSERT INTO @age_fields (
	pretty_age,
	pretty_age_amount,
	pretty_age_unit,
	age_years ,
	age_months ,
	age_days ,
	age_total_months ,
	age_total_days  
	)
VALUES (
	@ls_pretty_age,
	@ll_pretty_age_amount,
	@ls_pretty_age_unit,
	@ll_age_years ,
	@ll_age_months ,
	@ll_age_days ,
	@ll_age_total_months ,
	@ll_age_total_days  
	)


RETURN

END

GO
GRANT SELECT ON [dbo].[fn_age_fields] TO [cprsystem]
GO

