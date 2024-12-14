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

-- Drop Function [dbo].[fn_patient_disease_group_schedule]
Print 'Drop Function [dbo].[fn_patient_disease_group_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_disease_group_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_disease_group_schedule]
GO

-- Create Function [dbo].[fn_patient_disease_group_schedule]
Print 'Create Function [dbo].[fn_patient_disease_group_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_disease_group_schedule (
	@ps_cpr_id varchar(12),
	@ps_disease_group varchar(24),
	@pdt_current_date datetime)

RETURNS @schedule TABLE (
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @ps_cpr_id IS NULL
	RETURN

DECLARE @temp_schedule TABLE (
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

DECLARE @ll_disease_id int,
		@ll_date_count int,
		@ll_all_same int,
		@ls_description varchar(80),
		@ll_sort_sequence int,
		@ll_age_range int,
		@ls_sex char(1),
		@ls_eligible char(1),
		@ldt_patient_date_of_birth datetime,
		@ls_patient_sex char(1),
		@ls_ineligible_dose_text varchar(255)

SET @ll_date_count = NULL
SET @ll_all_same = 1
SET @ls_eligible = 'Y'
SET @ls_ineligible_dose_text = ''

-- If this patient is not elegible for this disease group, then return "Inelegible"
SELECT @ll_age_range = age_range, @ls_sex = sex
FROM c_Disease_Group
WHERE disease_group = @ps_disease_group

SELECT @ldt_patient_date_of_birth = date_of_birth, @ls_patient_sex = sex
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

IF @ll_age_range IS NOT NULL
	BEGIN
	IF dbo.fn_age_range_compare(@ll_age_range, @ldt_patient_date_of_birth, @pdt_current_date) < 0
		BEGIN
		SET @ls_eligible = 'N'
		SET @ls_ineligible_dose_text = 'Patient is too young for this disease group'
		END
	IF dbo.fn_age_range_compare(@ll_age_range, @ldt_patient_date_of_birth, @pdt_current_date) > 0
		BEGIN
		SET @ls_eligible = 'N'
		SET @ls_ineligible_dose_text = 'Patient is too old for this disease group'
		END
	END

IF @ls_sex IS NOT NULL
	BEGIN
	IF @ls_patient_sex IS NOT NULL AND @ls_patient_sex <> @ls_sex
		BEGIN
		SET @ls_eligible = 'N'
		IF LEN(@ls_ineligible_dose_text) > 0
			SET @ls_ineligible_dose_text = @ls_ineligible_dose_text + '; '
		SET @ls_ineligible_dose_text = 'Patient is wrong gender'
		END
	END

IF @ls_eligible = 'N'
	BEGIN
	INSERT INTO @schedule (
		disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	VALUES (
		0,
		@ps_disease_group ,
		0 ,
		1,
		@pdt_current_date,
		'Ineligible' ,
		@ls_ineligible_dose_text)

	RETURN
	END


DECLARE lc_diseases CURSOR LOCAL FAST_FORWARD FOR
	SELECT d.disease_id, d.description, COALESCE(i.sort_sequence, d.sort_sequence, i.disease_id)
	FROM c_Disease_Group_Item i
		INNER JOIN c_Disease d
		ON d.disease_id = i.disease_id
	WHERE disease_group = @ps_disease_group

OPEN lc_diseases

FETCH lc_diseases INTO @ll_disease_id, @ls_description, @ll_sort_sequence

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO @temp_schedule (
		disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT @ll_disease_id ,
		@ls_description ,
		@ll_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text
	FROM dbo.fn_patient_disease_immunization_schedule(@ps_cpr_id, @ll_disease_id, @pdt_current_date)
	
	IF @ll_date_count IS NULL
		BEGIN
		INSERT INTO @schedule (
			disease_id ,
			description ,
			disease_sort_sequence ,
			dose_number ,
			dose_date ,
			dose_status ,
			dose_text )
		SELECT 0 ,
			@ps_disease_group ,
			0 ,
			dose_number ,
			dose_date ,
			dose_status ,
			dose_text
		FROM @temp_schedule
		
		SET @ll_date_count = @@ROWCOUNT
		END
	ELSE
		BEGIN
		IF @ll_date_count <> (SELECT count(*)
							FROM @temp_schedule t
								INNER JOIN @schedule s
								ON t.dose_number = s.dose_number
								AND t.dose_date = s.dose_date
								AND t.dose_status = s.dose_status
							WHERE t.disease_id = @ll_disease_id)
			BEGIN
			SET @ll_all_same = 0
			END
		END
	
	
	FETCH lc_diseases INTO @ll_disease_id, @ls_description, @ll_sort_sequence
	END

CLOSE lc_diseases
DEALLOCATE lc_diseases

IF @ll_all_same = 0
	BEGIN
	DELETE FROM @schedule
	
	INSERT INTO @schedule (
		disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text
	FROM @temp_schedule
	END


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_disease_group_schedule] TO [cprsystem]
GO

