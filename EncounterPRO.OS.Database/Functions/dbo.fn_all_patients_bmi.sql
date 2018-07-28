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

-- Drop Function [dbo].[fn_all_patients_bmi]
Print 'Drop Function [dbo].[fn_all_patients_bmi]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_all_patients_bmi]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_all_patients_bmi]
GO

-- Create Function [dbo].[fn_all_patients_bmi]
Print 'Create Function [dbo].[fn_all_patients_bmi]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_all_patients_bmi ()

RETURNS @patient_bmi TABLE (
	cpr_id varchar(12) NOT NULL,
	date_of_birth datetime NULL,
	sex char(1) NULL,
	result_day datetime NOT NULL,
	weight_kg decimal(18,6) NULL,
	height_cm decimal(18,6) NULL,
	bmi decimal(18,6) NULL,
	bmi_percentile decimal(18,6) NULL)
AS

BEGIN


DECLARE @wgt_results TABLE (
	cpr_id varchar(12) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	result_day datetime NOT NULL)

INSERT INTO @wgt_results (
	cpr_id,
	result_value ,
	result_unit,
	result_day )
SELECT 	cpr_id,
	result_value ,
	result_unit,
	result_day
FROM dbo.fn_all_patients_results_by_day('WGT', -1)

DECLARE @hgt_results TABLE (
	cpr_id varchar(12) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	result_day datetime NOT NULL)

INSERT INTO @hgt_results (
	cpr_id,
	result_value ,
	result_unit,
	result_day )
SELECT 	cpr_id,
	result_value ,
	result_unit,
	result_day
FROM dbo.fn_all_patients_results_by_day('HGT', -1)


-- Remove invalid weights
DELETE t
FROM @wgt_results t
WHERE result_unit NOT IN ('LB', 'KG')
OR ISNUMERIC(result_value) <> 1
OR result_value LIKE '%,%'

-- Remove invalid heights
DELETE t
FROM @hgt_results t
WHERE result_unit NOT IN ('CM', 'INCH', 'FEET')
OR ISNUMERIC(result_value) <> 1
OR result_value LIKE '%,%'

INSERT INTO @patient_bmi (
	cpr_id ,
	result_day ,
	weight_kg ,
	height_cm )
SELECT t1.cpr_id,
	t1.result_day,
	CASE t1.result_unit WHEN 'KG' THEN CAST(t1.result_value AS decimal(18,6))
						WHEN 'LB' THEN CAST(t1.result_value AS decimal(18,6)) / 2.205
						ELSE NULL END,
	CASE t2.result_unit WHEN 'CM' THEN CAST(t2.result_value AS decimal(18,6))
						WHEN 'INCH' THEN CAST(t2.result_value AS decimal(18,6)) / 0.3937
						WHEN 'FEET' THEN CAST(t2.result_value AS decimal(18,6)) / 0.0328
						ELSE NULL END
FROM @wgt_results t1
	INNER JOIN @hgt_results t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.result_day = t2.result_day

-- Remove zero or negative height
DELETE x
FROM @patient_bmi x
WHERE weight_kg IS NULL
OR height_cm IS NULL
OR height_cm <= 0

-- Calculate BMI
UPDATE x
SET bmi = 10000 * (weight_kg / height_cm / height_cm),
	date_of_birth = p.date_of_birth,
	sex = p.sex
FROM @patient_bmi x
	INNER JOIN p_Patient p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id

-- Remove any records that still don't have a BMI that is not absurd
DELETE x
FROM @patient_bmi x
WHERE bmi IS NULL
OR bmi < 5
OR bmi > 100

-- Calculate the BMI percential
UPDATE x
SET bmi_percentile = dbo.fn_cdc_growth_bmi ('Standard',
											x.date_of_birth,
											x.result_day,
											x.sex,
											x.weight_kg,
											'KG',
											x.height_cm,
											'CM')
FROM @patient_bmi x

RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_all_patients_bmi]
	TO [cprsystem]
GO

