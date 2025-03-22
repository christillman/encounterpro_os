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

-- Drop Function [dbo].[fn_treatment_contraindications]
Print 'Drop Function [dbo].[fn_treatment_contraindications]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_treatment_contraindications]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_treatment_contraindications]
GO

-- Create Function [dbo].[fn_treatment_contraindications]
Print 'Create Function [dbo].[fn_treatment_contraindications]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_treatment_contraindications (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_treatment_type varchar(24) = NULL,
	@ps_treatment_key varchar(64) = NULL,
	@ps_treatment_description varchar(255) = NULL,
	@ps_treatment_list_user_id varchar(24) = NULL,
	@ps_treatment_list_assessment_id varchar(24) = NULL,
	@pl_care_plan_id int = NULL,
	@pdt_check_date datetime = NULL
	)

RETURNS @contra TABLE (
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	treatment_description varchar(255) NOT NULL,
	treatment_definition_id int NULL,
	contraindicationtype varchar(24) NULL,
	icon varchar(64) NULL,
	severity int NULL,
	shortdescription varchar(255) NULL,
	longdescription varchar(max) NULL,
	contraindication_warning varchar(255) NULL,
	contraindication_references varchar(max) NULL)
AS

BEGIN

DECLARE @treatments TABLE (
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	treatment_description varchar(255) NULL,
	treatment_key_property varchar(64) NULL,
	treatment_definition_id int NULL
	)

-- SQL 2000 would not allow a dbo.get_client_datetime() inside a function so we have to pass in the effective check_date.
-- If NULL is passed in, then use 
IF @pdt_check_date IS NULL
	SELECT @pdt_check_date = log_date_time
	FROM o_Log
	WHERE log_id = (SELECT max(log_id) FROM o_Log)

IF @ps_treatment_type IS NOT NULL AND @ps_treatment_key IS NOT NULL
	INSERT INTO @treatments (
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_key_property)
	VALUES (
		@ps_treatment_type,
		@ps_treatment_key,
		@ps_treatment_description,
		dbo.fn_treatment_type_treatment_key(@ps_treatment_type)
		)

IF @ps_treatment_list_user_id IS NOT NULL AND @ps_treatment_list_assessment_id IS NOT NULL
	INSERT INTO @treatments (
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_key_property,
		treatment_definition_id)
	SELECT d.treatment_type,
		COALESCE(d.treatment_key, CAST(d.treatment_description AS varchar(64))),
		d.treatment_description,
		dbo.fn_treatment_type_treatment_key(d.treatment_type),
		d.definition_id
	FROM u_Assessment_Treat_Definition d
	WHERE d.user_id = @ps_treatment_list_user_id
	AND d.assessment_id = @ps_treatment_list_assessment_id
	AND d.treatment_description IS NOT NULL
	AND d.treatment_type IS NOT NULL

-- Now we have a list of the treatments we want to check

-- Add the allergy contraindications
INSERT INTO @contra (
	treatment_type ,
	treatment_key ,
	treatment_description ,
	treatment_definition_id ,
	contraindicationtype ,
	icon ,
	severity ,
	shortdescription ,
	longdescription ,
	contraindication_warning ,
	contraindication_references )
SELECT x.treatment_type ,
	x.treatment_key ,
	COALESCE(x.treatment_description, dd.common_name) ,
	x.treatment_definition_id ,
	'Drug Allergy' ,
	'bitmap_drug_allergy.bmp' ,
	3 ,
	a.assessment + ' Allergy',
	NULL ,
	'This patient has an allergy (' + a.assessment + ') which may cause an adverse reaction to ' + dd.common_name,
	NULL
FROM @treatments x
	INNER JOIN c_Allergy_Drug ad WITH (NOLOCK)
	ON ad.drug_id = x.treatment_key
	INNER JOIN p_Assessment a WITH (NOLOCK)
	ON a.cpr_id = @ps_cpr_id
	AND a.assessment_id = ad.assessment_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	INNER JOIN c_Drug_Definition dd WITH (NOLOCK)
	ON ad.drug_id = dd.drug_id
WHERE ISNULL(a.assessment_status, 'OPEN') = 'OPEN'
AND x.treatment_key_property = 'drug_id'


-- Add the duplicate treatment check
INSERT INTO @contra (
	treatment_type ,
	treatment_key ,
	treatment_description ,
	treatment_definition_id ,
	contraindicationtype ,
	icon ,
	severity ,
	shortdescription ,
	longdescription ,
	contraindication_warning ,
	contraindication_references )
SELECT x.treatment_type ,
	x.treatment_key ,
	COALESCE(x.treatment_description, dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key)) ,
	x.treatment_definition_id ,
	'Duplicate Therapy' ,
	'bitmap_alert.bmp' ,
	3 ,
	'Duplicate Order - ' + dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key),
	NULL ,
	'The ' + tt.description + ' "' +  dbo.fn_treatment_type_key_description(x.treatment_type, x.treatment_key) 
		+ '" was ordered for this patient on ' + CONVERT(varchar(10), t.begin_date, 101),
	NULL
FROM @treatments x
	INNER JOIN c_Treatment_Type tt
	ON x.treatment_type = tt.treatment_type
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_type = x.treatment_type
	AND dbo.fn_treatment_key(t.cpr_id, t.treatment_id) = x.treatment_key
WHERE tt.default_duplicate_check_days > 0
AND (t.open_flag = 'Y'
	OR t.begin_date >= DATEADD(day, -tt.default_duplicate_check_days, @pdt_check_date)
	)
AND ISNULL(t.treatment_status, 'OPEN') <> 'Cancelled'

RETURN
END
GO
GRANT SELECT ON [dbo].[fn_treatment_contraindications] TO [cprsystem]
GO

