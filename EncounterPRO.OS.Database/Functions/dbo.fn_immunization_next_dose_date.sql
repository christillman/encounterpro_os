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

-- Drop Function [dbo].[fn_immunization_next_dose_date]
Print 'Drop Function [dbo].[fn_immunization_next_dose_date]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_immunization_next_dose_date]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_immunization_next_dose_date]
GO

-- Create Function [dbo].[fn_immunization_next_dose_date]
Print 'Create Function [dbo].[fn_immunization_next_dose_date]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_immunization_next_dose_date (
	@pl_disease_id int,
	@pl_dose_number int,
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime,
	@pdt_first_dose_date datetime,
	@pdt_last_dose_date datetime)

RETURNS @next_dose TABLE (
	next_dose_date datetime NOT NULL,
	next_dose_schedule_sequence int NOT NULL,
	next_dose_text varchar(255) NULL )

AS
BEGIN

DECLARE @ldt_due_date datetime,
		@ll_due_dose_schedule_sequence int,
		@ls_due_dose_text varchar(255),
		@ldt_min_age datetime,
		@ldt_min_wait_date datetime,
		@ldt_rule_date datetime,
		@ll_next_dose_schedule_sequence int,
		@ls_next_dose_text varchar(255)

SET @ldt_due_date = NULL

DECLARE lc_dose_rules CURSOR LOCAL FAST_FORWARD FOR
	SELECT min_age = dbo.fn_date_add_interval(@pdt_date_of_birth, a.age_from, a.age_from_unit),
			min_wait_date = dbo.fn_date_add_interval(@pdt_last_dose_date, last_dose_interval_amount, last_dose_interval_unit_id),
			s.dose_schedule_sequence,
			s.dose_text
	FROM c_Immunization_Dose_Schedule s
		INNER JOIN c_Age_Range a
		ON s.patient_age_range_id = a.age_range_id		
	CROSS JOIN o_Office oo
	JOIN c_Office co ON co.office_id = oo.office_id
	WHERE s.valid_in LIKE '%' + co.country + ';%'
	AND s.disease_id = @pl_disease_id
	AND s.dose_number = @pl_dose_number
	AND dbo.fn_age_range_compare(s.patient_age_range_id, @pdt_date_of_birth, @pdt_current_date) <= 0
	AND (first_dose_age_range_id IS NULL OR dbo.fn_age_range_compare(s.first_dose_age_range_id, @pdt_date_of_birth, @pdt_first_dose_date) = 0)
	AND (last_dose_age_range_id IS NULL OR dbo.fn_age_range_compare(s.last_dose_age_range_id, @pdt_date_of_birth, @pdt_last_dose_date) = 0)
	ORDER BY s.sort_sequence

OPEN lc_dose_rules

FETCH lc_dose_rules INTO @ldt_min_age, @ldt_min_wait_date, @ll_next_dose_schedule_sequence, @ls_next_dose_text

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- The due-date for this rule is the greater of the min-age and the min-wait-date
	IF @ldt_min_wait_date IS NULL OR @ldt_min_age >= @ldt_min_wait_date
		SET @ldt_rule_date = @ldt_min_age

	IF @ldt_min_age IS NULL OR @ldt_min_age < @ldt_min_wait_date
		SET @ldt_rule_date = @ldt_min_wait_date

	
	-- Then find the earliest due-date of all the rules for this dose
	IF @ldt_due_date IS NULL OR @ldt_rule_date < @ldt_due_date
		BEGIN
		SET @ldt_due_date = @ldt_rule_date
		SET @ll_due_dose_schedule_sequence = @ll_next_dose_schedule_sequence
		SET @ls_due_dose_text = @ls_next_dose_text
		END
	
	FETCH lc_dose_rules INTO @ldt_min_age, @ldt_min_wait_date, @ll_next_dose_schedule_sequence, @ls_next_dose_text
	END

CLOSE lc_dose_rules
DEALLOCATE lc_dose_rules

IF @ldt_due_date IS NULL OR @ll_due_dose_schedule_sequence IS NULL
	RETURN

INSERT INTO @next_dose (
	next_dose_date ,
	next_dose_schedule_sequence,
	next_dose_text )
VALUES (
	@ldt_due_date,
	@ll_due_dose_schedule_sequence,
	@ls_due_dose_text)

RETURN

END
GO
GRANT SELECT ON [dbo].[fn_immunization_next_dose_date] TO [cprsystem]
GO

