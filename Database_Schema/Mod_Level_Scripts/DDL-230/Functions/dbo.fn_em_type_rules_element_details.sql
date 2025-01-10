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

-- Drop Function [dbo].[fn_em_type_rules_element_details]
Print 'Drop Function [dbo].[fn_em_type_rules_element_details]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_em_type_rules_element_details]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_em_type_rules_element_details]
GO

-- Create Function [dbo].[fn_em_type_rules_element_details]
Print 'Create Function [dbo].[fn_em_type_rules_element_details]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_em_type_rules_element_details (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_em_component varchar(24),
	@ps_em_type varchar(24))

RETURNS @em_type_rules_data TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	observation_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	observation_description varchar(80) NOT NULL,
	parent_observation_sequence int NULL,
	em_category varchar(24) NOT NULL,
	em_element varchar(40) NOT NULL)


AS
BEGIN
DECLARE @ls_em_documentation_guide varchar(24),
	@ls_em_component varchar(24),
	@ls_em_type varchar(24),
	@ll_em_type_level int,
	@ll_rule_id int,
	@ll_item_sequence int,
	@ls_em_category varchar(24),
	@ll_min_element_count int,
	@ll_min_category_count int,
	@ll_min_elements_per_category int,
	@ls_actual_new_flag char(1),
	@ls_new_flag char(1),
	@li_item_count smallint,
	@li_actual_element_count smallint,
	@li_actual_category_count smallint,
	@ll_actual_encounter_complexity int,
	@ll_actual_encounter_risk_level int,
	@ll_actual_encounter_results int,
	@ll_ordered_encounter_results int,
	@ll_reviewed_encounter_results int,
	@ll_total_encounter_results int,
	@ls_count_physical char(1)

DECLARE @patient_observations TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	parent_observation_sequence int NULL,
	treatment_id int NULL,
	result_count int NULL)

DECLARE @em_elements TABLE (
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_category varchar(24) NOT NULL,
	em_element varchar(40) NOT NULL)

-- Get a list of the observations for this encounter
INSERT INTO @em_type_rules_data (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	observation_sequence ,
	observation_id ,
	observation_description ,
	parent_observation_sequence ,
	em_category ,
	em_element )
SELECT 'Treatment' ,
	t.treatment_type,
	tt.description,
	t.treatment_id,
	t.treatment_description,
	p.observation_sequence ,
	p.observation_id ,
	p.description,
	p.parent_observation_sequence ,
	e.em_category ,
	e.em_element 
FROM dbo.fn_patient_observations(@ps_cpr_id, @pl_encounter_id, DEFAULT) as o
	INNER JOIN em_observation_element as e WITH (NOLOCK)
	ON o.observation_id = e.observation_id
	INNER JOIN p_Observation p
	ON p.cpr_id = @ps_cpr_id
	AND p.observation_sequence = o.observation_sequence
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_id = p.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
WHERE e.em_component = @ps_em_component
AND e.em_type = @ps_em_type


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_em_type_rules_element_details] TO [cprsystem]
GO

