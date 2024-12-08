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

-- Drop Function [dbo].[fn_patient_bmi]
Print 'Drop Function [dbo].[fn_patient_bmi]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_bmi]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_bmi]
GO

-- Create Function [dbo].[fn_patient_bmi]
Print 'Create Function [dbo].[fn_patient_bmi]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_bmi (
	@ps_cpr_id varchar(12)
	)
RETURNS @patient_bmi TABLE (
	result_day datetime NOT NULL,
	weight_kg decimal(9,3) NULL,
	height_cm decimal(9,3) NULL,
	bmi decimal(9,3) NULL)
AS

BEGIN

DECLARE @ld_bmi decimal(9,3),
		@ls_weight varchar(40),
		@ls_weight_unit varchar(24),
		@ld_weight decimal(9,3),
		@ld_weight_kg decimal(9,3),
		@ls_height varchar(40),
		@ls_height_unit varchar(24),
		@ld_height decimal(9,3),
		@ld_height_cm decimal(9,3)


DECLARE @wgt_data TABLE (
	location_result_sequence int NOT NULL,
	result_day datetime NOT NULL,
	weight_result varchar(40),
	weight_unit varchar(24))


DECLARE @hgt_data TABLE (
	location_result_sequence int NOT NULL,
	result_day datetime NOT NULL,
	height_result varchar(40),
	height_unit varchar(24))


INSERT INTO @wgt_data (
	location_result_sequence,
	result_day,
	weight_result,
	weight_unit)
SELECT location_result_sequence,
	dbo.fn_date_truncate(result_date_time, 'DAY'),
	result_value, 
	result_unit
FROM dbo.fn_patient_results(@ps_cpr_id, 'WGT', -1)

INSERT INTO @hgt_data (
	location_result_sequence,
	result_day,
	height_result,
	height_unit)
SELECT location_result_sequence,
	dbo.fn_date_truncate(result_date_time, 'DAY'),
	result_value, 
	result_unit
FROM dbo.fn_patient_results(@ps_cpr_id, 'HGT', -1)

-- Remove duplicate weights for same day
DELETE t
FROM @wgt_data t
	INNER JOIN (SELECT result_day, max(location_result_sequence) as max_location_result_sequence
				FROM @wgt_data
				GROUP BY result_day) x
	ON t.result_day = x.result_day
WHERE t.location_result_sequence < x.max_location_result_sequence


-- Remove duplicate heights for same day
DELETE t
FROM @hgt_data t
	INNER JOIN (SELECT result_day, max(location_result_sequence) as max_location_result_sequence
				FROM @hgt_data
				GROUP BY result_day) x
	ON t.result_day = x.result_day
WHERE t.location_result_sequence < x.max_location_result_sequence


-- Remove invalid weights
DELETE t
FROM @wgt_data t
WHERE weight_unit NOT IN ('LB', 'KG')
OR ISNUMERIC(weight_result) <> 1

-- Remove invalid heights
DELETE t
FROM @hgt_data t
WHERE height_unit NOT IN ('CM', 'INCH', 'FEET')
OR ISNUMERIC(height_result) <> 1

INSERT INTO @patient_bmi (
	result_day ,
	weight_kg ,
	height_cm )
SELECT t1.result_day,
	CASE t1.weight_unit WHEN 'KG' THEN CAST(t1.weight_result AS decimal(9,3))
						WHEN 'LB' THEN CAST(t1.weight_result AS decimal(9,3)) / 2.205
						ELSE NULL END,
	CASE t2.height_unit WHEN 'CM' THEN CAST(t2.height_result AS decimal(9,3))
						WHEN 'INCH' THEN CAST(t2.height_result AS decimal(9,3)) / 0.3937
						WHEN 'FEET' THEN CAST(t2.height_result AS decimal(9,3)) / 0.0328
						ELSE NULL END
FROM @wgt_data t1
	INNER JOIN @hgt_data t2
	ON t1.result_day = t2.result_day

UPDATE @patient_bmi
SET bmi = 10000 * (weight_kg / height_cm / height_cm)
WHERE height_cm > 0

RETURN

END

GO
GRANT SELECT ON [dbo].[fn_patient_bmi] TO [cprsystem]
GO

