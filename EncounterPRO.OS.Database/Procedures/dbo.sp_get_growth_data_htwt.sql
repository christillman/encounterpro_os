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

-- Drop Procedure [dbo].[sp_get_growth_data_htwt]
Print 'Drop Procedure [dbo].[sp_get_growth_data_htwt]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_growth_data_htwt]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_growth_data_htwt]
GO

-- Create Procedure [dbo].[sp_get_growth_data_htwt]
Print 'Create Procedure [dbo].[sp_get_growth_data_htwt]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure sp_get_growth_data_htwt (@ps_cpr_id varchar(12),
@pdt_birth_date datetime,
@pd_age_start int,
@pd_age_end int,
@ps_visit varchar(10))
AS 

DECLARE @growth_data TABLE (
	cpr_id varchar(12) NULL,
	encounter_id int NULL,
	encounter_status varchar(8) NULL,
	result_date_time datetime NOT NULL,
	observation_id varchar(24) NOT NULL,
	result_value varchar(40) NOT NULL,
	result_unit varchar(12) NOT NULL,
	actual_observation_id varchar(24) NOT NULL)
	
INSERT INTO @growth_data (
	cpr_id,
	encounter_id,
	result_date_time,
	observation_id ,
	result_value ,
	result_unit ,
	actual_observation_id )
SELECT 	@ps_cpr_id,
	encounter_id,
	result_date_time,
	'HGT' ,
	result_value ,
	result_unit ,
	observation_id
FROM dbo.fn_patient_results(@ps_cpr_id, 'HGT', -1)
WHERE location = 'NA'
AND result_value IS NOT NULL
AND result_unit IS NOT NULL
AND ISNUMERIC(result_value) = 1

INSERT INTO @growth_data (
	cpr_id,
	encounter_id,
	result_date_time,
	observation_id ,
	result_value ,
	result_unit ,
	actual_observation_id )
SELECT @ps_cpr_id,
	encounter_id,
	result_date_time,
	'WGT' ,
	result_value ,
	result_unit ,
	observation_id
FROM dbo.fn_patient_results(@ps_cpr_id, 'WGT', -1)
WHERE location = 'NA'
AND result_value IS NOT NULL
AND result_unit IS NOT NULL
AND ISNUMERIC(result_value) = 1

UPDATE x
SET encounter_status = e.encounter_status
FROM @growth_data x
	INNER JOIN p_Patient_Encounter e
	ON x.cpr_id = e.cpr_id
	AND x.encounter_id = e.encounter_id

IF @ps_visit = 'ALL'
	SELECT result_date_time,
		Datediff(day,@pdt_birth_date,result_date_time) as Age,
		observation_id as observation_id,
		result_value as result_value,
		result_unit as result_unit,
		actual_observation_id
	FROM @growth_data
	WHERE DATEDIFF(day, @pdt_birth_date,result_date_time) >= @pd_age_start
	AND DATEDIFF(day, @pdt_birth_date,result_date_time) <= @pd_age_end
	AND CAST(result_value as decimal) <> 0
	Order by result_date_time asc
ELSE
	SELECT a.result_date_time,
		Datediff(day,@pdt_birth_date,a.result_date_time) as Age,
		a.observation_id ,
		a.result_value ,
		a.result_unit ,
		a.actual_observation_id
	FROM @growth_data a
	WHERE DATEDIFF(day, @pdt_birth_date,result_date_time) >= @pd_age_start
	AND DATEDIFF(day, @pdt_birth_date,result_date_time) <= @pd_age_end
	AND CAST(result_value as decimal) <> 0
	AND (EXISTS (
				SELECT  * 
				FROM p_assessment b
				WHERE b.cpr_id = @ps_cpr_id
				AND a.encounter_id = b.open_encounter_id
				AND b.assessment_type = 'WELL' 
				)
		OR a.encounter_status = 'OPEN')
	Order by result_date_time asc

GO
GRANT EXECUTE
	ON [dbo].[sp_get_growth_data_htwt]
	TO [cprsystem]
GO

