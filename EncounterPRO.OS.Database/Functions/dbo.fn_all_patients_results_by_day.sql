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

-- Drop Function [dbo].[fn_all_patients_results_by_day]
Print 'Drop Function [dbo].[fn_all_patients_results_by_day]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_all_patients_results_by_day]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_all_patients_results_by_day]
GO

-- Create Function [dbo].[fn_all_patients_results_by_day]
Print 'Create Function [dbo].[fn_all_patients_results_by_day]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_all_patients_results_by_day (
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint)

RETURNS @patient_results TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	treatment_id int NULL,
	encounter_id int NULL,
	result_sequence smallint NOT NULL,
	location varchar(24) NOT NULL,
	result_date_time datetime NOT NULL,
	result_day datetime NOT NULL,
	result_type varchar(12) NOT NULL,
	result varchar(80) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	abnormal_flag char(1) NULL)
AS

BEGIN


DECLARE @tmp_results_all TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	treatment_id int NULL,
	encounter_id int NULL,
	result_sequence smallint NOT NULL,
	location varchar(24) NOT NULL,
	result_date_time datetime NOT NULL,
	result_day datetime NOT NULL,
	result_type varchar(12) NOT NULL,
	result varchar(80) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	abnormal_flag char(1) NULL)

-- Get all the max result per day
-- If the result sequence is null then get the latest result regardless of result sequence
IF @pi_result_sequence IS NULL
	BEGIN
	INSERT INTO @tmp_results_all (
		cpr_id,
		observation_sequence,
		location_result_sequence ,
		treatment_id ,
		observation_id,
		encounter_id,
		result_sequence ,
		location ,
		result_date_time ,
		result_day ,
		result_type ,
		result ,
		result_value ,
		result_unit ,
		abnormal_flag)
	SELECT 
		r.cpr_id,
		r.observation_sequence,
		r.location_result_sequence ,
		r.treatment_id ,
		r.observation_id ,
		r.encounter_id ,
		r.result_sequence ,
		r.location ,
		r.result_date_time ,
		convert(datetime, convert(varchar, r.result_date_time, 112)) ,
		r.result_type ,
		r.result ,
		r.result_value ,
		r.result_unit ,
		r.abnormal_flag
	FROM p_Observation_Result r WITH (NOLOCK)
		INNER JOIN dbo.fn_equivalent_observations(@ps_observation_id) q
		ON r.observation_id = q.observation_id
	WHERE r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	END
ELSE
	BEGIN
	INSERT INTO @tmp_results_all (
		cpr_id,
		observation_sequence,
		location_result_sequence ,
		treatment_id ,
		observation_id,
		encounter_id,
		result_sequence ,
		location ,
		result_date_time ,
		result_day ,
		result_type ,
		result ,
		result_value ,
		result_unit ,
		abnormal_flag)
	SELECT 
		r.cpr_id,
		r.observation_sequence,
		r.location_result_sequence ,
		r.treatment_id ,
		r.observation_id ,
		r.encounter_id ,
		r.result_sequence ,
		r.location ,
		r.result_date_time ,
		convert(datetime, convert(varchar, r.result_date_time, 112)) ,
		r.result_type ,
		r.result ,
		r.result_value ,
		r.result_unit ,
		r.abnormal_flag
	FROM p_Observation_Result r WITH (NOLOCK)
		INNER JOIN dbo.fn_equivalent_observation_results(@ps_observation_id, @pi_result_sequence) q
		ON r.observation_id = q.observation_id
		AND r.result_sequence = q.result_sequence
	WHERE r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	END


-- Get the final list of non-deleted results
INSERT INTO @patient_results (
	cpr_id,
	observation_sequence,
	location_result_sequence ,
	treatment_id ,
	observation_id,
	encounter_id,
	result_sequence ,
	location ,
	result_date_time ,
	result_day ,
	result_type ,
	result ,
	result_value ,
	result_unit ,
	abnormal_flag)
SELECT 	r.cpr_id,
	r.observation_sequence,
	r.location_result_sequence ,
	r.treatment_id ,
	r.observation_id ,
	r.encounter_id ,
	r.result_sequence ,
	r.location ,
	r.result_date_time ,
	t.result_day ,
	r.result_type ,
	r.result ,
	r.result_value ,
	r.result_unit ,
	r.abnormal_flag
FROM @tmp_results_all r 
	INNER JOIN (SELECT cpr_id,
					result_day,
					max(location_result_sequence) as location_result_sequence
				FROM @tmp_results_all
				GROUP BY cpr_id, result_day) t
	ON r.location_result_sequence = t.location_result_sequence

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_all_patients_results_by_day] TO [cprsystem]
GO

