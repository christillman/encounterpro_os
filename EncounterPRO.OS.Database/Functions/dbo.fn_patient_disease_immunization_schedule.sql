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

-- Drop Function [dbo].[fn_patient_disease_immunization_schedule]
Print 'Drop Function [dbo].[fn_patient_disease_immunization_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_disease_immunization_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_disease_immunization_schedule]
GO

-- Create Function [dbo].[fn_patient_disease_immunization_schedule]
Print 'Create Function [dbo].[fn_patient_disease_immunization_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_disease_immunization_schedule (
	@ps_cpr_id varchar(12),
	@pl_disease_id int,
	@pdt_current_date datetime )

RETURNS @schedule TABLE (
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @ps_cpr_id IS NULL
	RETURN

IF @pl_disease_id IS NULL
	RETURN

DECLARE @ll_dose_count int,
		@ll_next_dose_number int,
		@ldt_first_dose_date datetime,
		@ldt_last_dose_date datetime,
		@ldt_date_of_birth datetime,
		@ls_no_vaccine_after_disease char(1),
		@ldt_disease_diagnosis_date datetime,
		@ls_assessment varchar(80)

SET @pdt_current_date = convert(datetime, convert(varchar,@pdt_current_date, 112))

SELECT @ldt_date_of_birth = date_of_birth
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

IF @@ROWCOUNT = 0
	RETURN

IF @ldt_date_of_birth IS NULL
	RETURN

SELECT @ls_no_vaccine_after_disease = no_vaccine_after_disease
FROM c_Disease
WHERE disease_id = @pl_disease_id

IF @@ROWCOUNT = 0
	RETURN

SET @ldt_disease_diagnosis_date = NULL
IF @ls_no_vaccine_after_disease = 'Y'
	BEGIN
	-- If the patient has had this disease then they are not eligible for any more immunizations
	SELECT @ldt_disease_diagnosis_date = min(a.begin_date)
	FROM p_Assessment a
		INNER JOIN c_Disease_Assessment d
		ON a.assessment_id = d.assessment_id
	WHERE a.cpr_id = @ps_cpr_id
	AND d.disease_id = @pl_disease_id
	AND ISNULL(a.assessment_status, 'OPEN') <> 'Cancelled'

	IF @ldt_disease_diagnosis_date IS NOT NULL
		BEGIN
		SELECT @ls_assessment = min(assessment)
		FROM p_Assessment a
			INNER JOIN c_Disease_Assessment d
			ON a.assessment_id = d.assessment_id
		WHERE a.cpr_id = @ps_cpr_id
		AND d.disease_id = @pl_disease_id
		AND ISNULL(a.assessment_status, 'OPEN') <> 'Cancelled'
		AND begin_date = @ldt_disease_diagnosis_date

		IF @ls_assessment IS NULL
			SET @ls_assessment = 'disease'

		END
	END


DECLARE @actual TABLE (
	dose_number int IDENTITY(1,1) NOT NULL,
	dose_date datetime NOT NULL,
	dose_description varchar(80))


INSERT INTO @actual (
	dose_date ,
	dose_description)
SELECT t.begin_date,
	t.treatment_description
FROM p_Treatment_Item t WITH (NOLOCK)
	, c_vaccine_disease d WITH (NOLOCK)
WHERE t.cpr_id = @ps_cpr_id
AND t.drug_id = d.vaccine_id
AND t.treatment_type = 'IMMUNIZATION'
AND d.disease_id = @pl_disease_id
AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
ORDER BY t.begin_date

SET @ll_dose_count = @@ROWCOUNT

INSERT INTO @schedule (
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT dose_number ,
	dose_date ,
	'Given',
	dose_description
FROM @actual

IF @ll_dose_count > 0
	BEGIN
	SELECT @ldt_first_dose_date = dose_date
	FROM @actual
	WHERE dose_number = 1
	
	SELECT @ldt_last_dose_date = dose_date
	FROM @actual
	WHERE dose_number = @ll_dose_count
	END
ELSE
	BEGIN
	SET @ldt_first_dose_date = NULL
	SET @ldt_last_dose_date = NULL
	END

SET @ll_next_dose_number = @ll_dose_count + 1

IF @ldt_disease_diagnosis_date IS NOT NULL
	BEGIN
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	VALUES (
		@ll_next_dose_number,
		@ldt_disease_diagnosis_date,
		'Ineligible',
		'Patient has been diagnosed with ' + @ls_assessment
		)
	END
ELSE
	BEGIN
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT dose_number,
			dose_date,
			CASE WHEN dose_date = @pdt_current_date THEN 'Give Now' ELSE 'Projected' END,
			dose_text
	FROM dbo.fn_immunization_schedule (
		@pl_disease_id ,
		@ll_next_dose_number,
		@ldt_date_of_birth ,
		@pdt_current_date ,
		@ldt_first_dose_date ,
		@ldt_last_dose_date)
	END

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_patient_disease_immunization_schedule]
	TO [cprsystem]
GO

