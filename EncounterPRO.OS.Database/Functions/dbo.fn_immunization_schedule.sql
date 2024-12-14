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

-- Drop Function [dbo].[fn_immunization_schedule]
Print 'Drop Function [dbo].[fn_immunization_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_immunization_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_immunization_schedule]
GO

-- Create Function [dbo].[fn_immunization_schedule]
Print 'Create Function [dbo].[fn_immunization_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_immunization_schedule (
	@pl_disease_id int,
	@pl_next_dose_number int,
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime,
	@pdt_first_dose_date datetime,
	@pdt_last_dose_date datetime)

RETURNS @schedule TABLE (
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_schedule_sequence int NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @pl_next_dose_number IS NULL
	RETURN

SET @pdt_current_date = convert(datetime, convert(varchar,@pdt_current_date, 112))
SET @pdt_first_dose_date = convert(datetime, convert(varchar,@pdt_first_dose_date, 112))
SET @pdt_last_dose_date = convert(datetime, convert(varchar,@pdt_last_dose_date, 112))

DECLARE @ldt_dose_date datetime,
		@ldt_hypothetical_current_date datetime,
		@ldt_hypothetical_first_dose_date datetime,
		@ldt_hypothetical_last_dose_date datetime,
		@ll_dose_schedule_sequence int,
		@ls_dose_text varchar(255)

SET @ll_dose_schedule_sequence = NULL
SET @ldt_hypothetical_current_date = @pdt_current_date
SET @ldt_hypothetical_first_dose_date = @pdt_first_dose_date
SET @ldt_hypothetical_last_dose_date = @pdt_last_dose_date

WHILE 1 = 1
	BEGIN

	SELECT @ldt_dose_date = next_dose_date,
			@ll_dose_schedule_sequence = next_dose_schedule_sequence,
			@ls_dose_text = next_dose_text
	FROM dbo.fn_immunization_next_dose_date(@pl_disease_id ,
											@pl_next_dose_number ,
											@pdt_date_of_birth ,
											@ldt_hypothetical_current_date ,
											@ldt_hypothetical_first_dose_date ,
											@ldt_hypothetical_last_dose_date)
	
	IF @@ROWCOUNT = 0
		BREAK
	
	IF @ldt_dose_date < @ldt_hypothetical_current_date
		SET @ldt_dose_date = @ldt_hypothetical_current_date
	
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_schedule_sequence,
		dose_text )
	VALUES (
		@pl_next_dose_number,
		@ldt_dose_date,
		@ll_dose_schedule_sequence,
		@ls_dose_text)

	IF @pl_next_dose_number = 1
		SET @ldt_hypothetical_first_dose_date = @ldt_dose_date
		
	SET @pl_next_dose_number = @pl_next_dose_number + 1
	SET @ldt_hypothetical_last_dose_date = @ldt_dose_date
	SET @ldt_hypothetical_current_date = @ldt_dose_date
	
	END

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_immunization_schedule] TO [cprsystem]
GO

