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

-- Drop Procedure [dbo].[sp_check_vaccine_status]
Print 'Drop Procedure [dbo].[sp_check_vaccine_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_check_vaccine_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_check_vaccine_status]
GO

-- Create Procedure [dbo].[sp_check_vaccine_status]
Print 'Create Procedure [dbo].[sp_check_vaccine_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_check_vaccine_status (
	@ps_cpr_id varchar(12),
	@pl_disease_id int,
	@pi_status smallint OUTPUT,
	@pdt_due_date_time datetime OUTPUT )
AS
DECLARE @li_vaccine_count smallint,
	@li_schedule_count smallint,
	@li_assessment_count smallint,
	@ldt_warning_date datetime,
	@ldt_date_of_birth datetime,
	@ldt_age datetime,
	@li_warning_days smallint,
	@lc_no_vaccine_after_disease char(1)
SELECT @lc_no_vaccine_after_disease = no_vaccine_after_disease
FROM c_Disease WITH (NOLOCK)
WHERE disease_id = @pl_disease_id
IF @lc_no_vaccine_after_disease = 'Y'
	BEGIN
	SELECT @li_assessment_count = count(problem_id)
	FROM 	p_Assessment a WITH (NOLOCK)
		, c_Disease_Assessment d WITH (NOLOCK)
	WHERE a.cpr_id = @ps_cpr_id
	AND a.assessment_id = d.assessment_id
	AND d.disease_id = @pl_disease_id
	IF @li_assessment_count > 0
		BEGIN
		SELECT	@pdt_due_date_time = null,
			@pi_status = 0
		RETURN
		END
	END
		
SELECT @ldt_date_of_birth = date_of_birth
FROM p_Patient WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
SELECT @li_vaccine_count = count(*)
FROM 	p_Treatment_Item WITH (NOLOCK)
	, c_vaccine_disease WITH (NOLOCK)
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.drug_id = c_vaccine_disease.vaccine_id
AND p_Treatment_Item.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
AND c_vaccine_disease.disease_id = @pl_disease_id
AND (p_Treatment_Item.treatment_status <> 'CANCELLED'
or p_Treatment_Item.treatment_status IS NULL)
SELECT @li_schedule_count = count(*)
FROM c_Immunization_Schedule WITH (NOLOCK)
WHERE disease_id = @pl_disease_id
IF @li_schedule_count = 0
	SELECT	@pdt_due_date_time = null,
		@pi_status = null
ELSE IF @li_vaccine_count >= @li_schedule_count
	SELECT	@pdt_due_date_time = null,
		@pi_status = 0
ELSE
	BEGIN
	SELECT	@ldt_age = age,
		@li_warning_days = warning_days
	FROM c_Immunization_Schedule WITH (NOLOCK)
	WHERE disease_id = @pl_disease_id 	AND schedule_sequence = @li_vaccine_count + 1
	SELECT @pdt_due_date_time = dateadd(day, datediff(day, '1/1/1980', @ldt_age), @ldt_date_of_birth)
	SELECT @ldt_warning_date = dateadd(day, -@li_warning_days, @pdt_due_date_time)
	IF @ldt_warning_date > getdate()
		SELECT	@pi_status = 1
	ELSE IF @pdt_due_date_time > getdate()
		SELECT	@pi_status = 2
	ELSE
		SELECT	@pi_status = 3
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_check_vaccine_status]
	TO [cprsystem]
GO

