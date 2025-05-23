﻿--EncounterPRO Open Source Project
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

-- Drop Function [dbo].[fn_patient_object_last_result]
Print 'Drop Function [dbo].[fn_patient_object_last_result]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_last_result]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_last_result]
GO

-- Create Function [dbo].[fn_patient_object_last_result]
Print 'Create Function [dbo].[fn_patient_object_last_result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_object_last_result (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int,
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
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	result varchar(80) NOT NULL,
	abnormal_flag char(1) NULL,
	result_amount_flag char(1) NULL,
	print_result_flag char(1) NULL,
	print_result_separator varchar(8) NULL,
	unit_preference varchar(24) NULL,
	display_mask varchar(40)
	)
AS

BEGIN

DECLARE @ll_encounter_id int,
		@ll_treatment_id int

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key
ELSE
	SET @ll_encounter_id = NULL

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key
ELSE
	SET @ll_treatment_id = NULL

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
	result_value ,
	result_unit,
	result,
	abnormal_flag,
	result_amount_flag,
	print_result_flag,
	print_result_separator,
	unit_preference,
	display_mask )
SELECT 	TOP 1 p.cpr_id,
	p.observation_sequence,
	p.location_result_sequence ,
	p.treatment_id ,
	p.observation_id ,
	p.encounter_id ,
	p.result_sequence ,
	p.location ,
	p.result_date_time ,
	p.result_value ,
	p.result_unit ,
	p.result ,
	p.abnormal_flag ,
	c.result_amount_flag ,
	c.print_result_flag ,
	c.print_result_separator ,
	c.unit_preference ,
	c.display_mask
FROM p_Observation_Result p
	LEFT OUTER JOIN c_Observation_Result c
	ON p.observation_id = c.observation_id
	AND p.result_sequence = c.result_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.observation_id = @ps_observation_id
AND p.result_sequence = @pi_result_sequence
AND p.current_flag = 'Y'
AND (@ll_encounter_id IS NULL OR p.encounter_id = @ll_encounter_id)
AND (@ll_treatment_id IS NULL OR p.treatment_id = @ll_treatment_id)
ORDER BY p.result_date_time DESC

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_object_last_result] TO [cprsystem]
GO

