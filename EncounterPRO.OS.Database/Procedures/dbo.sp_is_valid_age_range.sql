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

-- Drop Procedure [dbo].[sp_is_valid_age_range]
Print 'Drop Procedure [dbo].[sp_is_valid_age_range]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_is_valid_age_range]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_is_valid_age_range]
GO

-- Create Procedure [dbo].[sp_is_valid_age_range]
Print 'Create Procedure [dbo].[sp_is_valid_age_range]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_is_valid_age_range (
	@ps_age_range_category varchar(24),
	@pl_age_from int,
	@ps_unit_from varchar(24),
	@pl_age_to int,
	@ps_unit_to varchar(24),
	@ps_message varchar(80) OUTPUT)
AS
DECLARE @ldt_fixed_date datetime,
		@ldt_age_from_date datetime,
		@ldt_age_to_date datetime,
		@ll_age_range_id int,
		@ls_overlap_flag char(1)

-- Validate the age_range_category
SELECT @ls_overlap_flag = ISNULL(overlap_flag, 'N')
FROM c_Age_Range_Category
WHERE age_range_category = @ps_age_range_category

IF @@ROWCOUNT = 0
	BEGIN
	SET @ps_message = 'Invalid Age Range Category.'
	RETURN 0
	END

SET @ldt_fixed_date = convert(datetime, '1/1/1980')
SET @ldt_age_from_date = convert(datetime, '1/1/1780')
SET @ldt_age_to_date = convert(datetime, '1/1/1780')

SET @ldt_age_from_date = CASE @ps_unit_from
			WHEN 'YEAR' THEN dateadd(year, @pl_age_from, @ldt_fixed_date)
			WHEN 'MONTH' THEN dateadd(month, @pl_age_from, @ldt_fixed_date)
			WHEN 'DAY' THEN dateadd(day, @pl_age_from, @ldt_fixed_date)
			END

SET @ldt_age_to_date = CASE @ps_unit_to
			WHEN 'YEAR' THEN dateadd(year, @pl_age_to, @ldt_fixed_date)
			WHEN 'MONTH' THEN dateadd(month, @pl_age_to, @ldt_fixed_date)
			WHEN 'DAY' THEN dateadd(day, @pl_age_to, @ldt_fixed_date)
			END

-- Make sure the from-date is valid
IF @ldt_age_from_date < @ldt_fixed_date
	BEGIN
	SET @ps_message = 'Invalid From-Date.'
	RETURN 0
	END

-- Make sure the to-date is valid
IF @ldt_age_to_date < @ldt_fixed_date
	BEGIN
	SET @ps_message = 'Invalid To-Date.'
	RETURN 0
	END

-- Make sure the from-date is less than the to-date
IF @ldt_age_to_date <= @ldt_age_from_date
	BEGIN
	SET @ps_message = 'To-Date must be greater than From-Date.'
	RETURN 0
	END

-- If we're not supposed to overlap then make sure we don't
IF @ls_overlap_flag = 'Y'
	BEGIN
	-- Check the from-date
	select @ll_age_range_id = min(c_Age_Range.age_range_id)
	FROM c_Age_Range
	WHERE age_range_category = @ps_age_range_category
	AND @ldt_age_from_date >= CASE age_from_unit
				WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, @ldt_fixed_date)
				WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, @ldt_fixed_date)
				WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, @ldt_fixed_date)
				END
	AND @ldt_age_from_date < CASE age_to_unit
				WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, @ldt_fixed_date)
				WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, @ldt_fixed_date)
				WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, @ldt_fixed_date)
				END

	IF @ll_age_range_id > 0
		BEGIN
		SET @ps_message = 'From-Date conflicts with another age range.'
		RETURN 0
		END

	-- Check the to-date
	select @ll_age_range_id = min(c_Age_Range.age_range_id)
	FROM c_Age_Range
	WHERE age_range_category = @ps_age_range_category
	AND @ldt_age_to_date > CASE age_from_unit
				WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, @ldt_fixed_date)
				WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, @ldt_fixed_date)
				WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, @ldt_fixed_date)
				END
	AND @ldt_age_to_date <= CASE age_to_unit
				WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, @ldt_fixed_date)
				WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, @ldt_fixed_date)
				WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, @ldt_fixed_date)
				END

	IF @ll_age_range_id > 0
		BEGIN
		SET @ps_message = 'To-Date conflicts with another age range.'
		RETURN 0
		END
END

-- If we made it to here then the age range is OK
SET @ps_message = 'Age Range OK'
RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[sp_is_valid_age_range]
	TO [cprsystem]
GO

