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

-- Drop Function [dbo].[fn_em_type_rules_passed]
Print 'Drop Function [dbo].[fn_em_type_rules_passed]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_em_type_rules_passed]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_em_type_rules_passed]
GO

-- Create Function [dbo].[fn_em_type_rules_passed]
Print 'Create Function [dbo].[fn_em_type_rules_passed]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_em_type_rules_passed (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_em_documentation_guide varchar(24))

RETURNS @em_type_rules_passed TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_type_level int NOT NULL,
	rule_id int NOT NULL,
	new_flag char(1) NULL,
	description varchar(1024) NULL,
	passed_flag char(1) NULL)

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

SET @ls_count_physical = dbo.fn_get_preference('PREFERENCES', 'E&M Count Physical Results', NULL, NULL)
IF @ls_count_physical LIKE 'Y%'
	SET @ls_count_physical = 'Y'
ELSE
	SET @ls_count_physical = 'N'

SELECT @ls_actual_new_flag = new_flag
FROM p_Patient_Encounter WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

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

DECLARE @em_category_counts TABLE (
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_category varchar(24) NOT NULL,
	element_count int NULL)

DECLARE @em_type_rules TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_type_level int NOT NULL,
	rule_id int NOT NULL,
	new_flag char(1) NULL,
	item_count smallint NULL,
	description varchar(1024) NULL,
	possible_item_count smallint NULL,
	passed_item_count smallint NULL)

DECLARE @em_type_rule_items TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_type_level int NOT NULL,
	rule_id int NOT NULL,
	item_sequence int NOT NULL,
	em_category varchar(24) NULL,
	min_element_count int NULL,
	min_category_count int NULL,
	min_elements_per_category int NULL,
	min_encounter_complexity int NULL,
	min_encounter_risk_level int NULL,
	min_encounter_results int NULL,
	actual_element_count int NULL,
	actual_category_count int NULL,
	possible_element_count int NULL)

-- Get a list of the observations for this encounter
INSERT INTO @patient_observations (
	cpr_id ,
	observation_sequence ,
	observation_id ,
	parent_observation_sequence ,
	treatment_id,
	result_count )
SELECT o.cpr_id ,
	o.observation_sequence ,
	o.observation_id ,
	o.parent_observation_sequence ,
	o.treatment_id,
	o.result_count
FROM dbo.fn_patient_observations(@ps_cpr_id, @pl_encounter_id, DEFAULT) as o

-- Get a list of the elements which map to any observations taken during the encounter
INSERT INTO @em_elements (
	em_component,
	em_type,
	em_category,
	em_element)
SELECT DISTINCT
	e.em_component,
	e.em_type,
	e.em_category,
	e.em_element
FROM @patient_observations as o
	INNER JOIN em_observation_element as e WITH (NOLOCK)
	ON o.observation_id = e.observation_id

INSERT INTO @em_category_counts (
	em_component,
	em_type,
	em_category,
	element_count)
SELECT DISTINCT
	em_component,
	em_type,
	em_category,
	count(*) as element_count
FROM @em_elements
GROUP BY em_component,
	em_type,
	em_category

INSERT INTO @em_type_rules (
	em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	new_flag,
	item_count,
	description,
	passed_item_count)
SELECT em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	new_flag,
	item_count,
	description,
	0 as passed_item_count
FROM em_type_rule WITH (NOLOCK)
WHERE em_documentation_guide = @ps_em_documentation_guide
AND ((new_flag IS NULL) OR (new_flag = @ls_actual_new_flag))

-- Count how many rule items exist for each rule
UPDATE r
SET possible_item_count = i.possible_item_count
FROM @em_type_rules as r
	INNER JOIN 
		(SELECT em_documentation_guide,
			em_component,
			em_type,
			em_type_level,
			rule_id,
			count(*) as possible_item_count
		FROM em_type_rule_item WITH (NOLOCK)
		GROUP BY em_documentation_guide,
			em_component,
			em_type,
			em_type_level,
			rule_id) as i
	ON r.em_documentation_guide = i.em_documentation_guide
	AND r.em_component = i.em_component
	AND r.em_type = i.em_type
	AND r.em_type_level = i.em_type_level
	AND r.rule_id = i.rule_id

-- Get all the rule items in a temp table
INSERT INTO @em_type_rule_items (
	em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	item_sequence,
	em_category,
	min_element_count,
	min_category_count,
	min_elements_per_category,
	min_encounter_complexity,
	min_encounter_risk_level,
	min_encounter_results )
SELECT em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	item_sequence,
	em_category,
	min_element_count,
	min_category_count,
	min_elements_per_category,
	min_encounter_complexity,
	min_encounter_risk_level,
	min_encounter_results
FROM em_type_rule_item WITH (NOLOCK)
WHERE em_documentation_guide = @ps_em_documentation_guide

-- Update the possible element count for rules with an em_category
UPDATE i
SET possible_element_count = e.element_count
FROM @em_type_rule_items i
	INNER JOIN (
		SELECT em_component, em_type, em_category, count(*) as element_count
		FROM em_element WITH (NOLOCK)
		GROUP BY em_component, em_type, em_category) as e
	ON i.em_component = e.em_component
	AND i.em_type = e.em_type
	AND i.em_category = e.em_category
WHERE i.em_category IS NOT NULL

-- Update the actual element count for rules with an em_category
UPDATE i
SET actual_element_count = e.element_count
FROM @em_type_rule_items i
	INNER JOIN @em_category_counts e
	ON i.em_component = e.em_component
	AND i.em_type = e.em_type
	AND i.em_category = e.em_category
WHERE i.em_category IS NOT NULL

-- Update the possible element count for rules without an em_category
UPDATE i
SET possible_element_count = e.element_count
FROM @em_type_rule_items i
	INNER JOIN (
		SELECT em_component, em_type, count(*) as element_count
		FROM em_element WITH (NOLOCK)
		GROUP BY em_component, em_type) as e
	ON i.em_component = e.em_component
	AND i.em_type = e.em_type
WHERE i.em_category IS NULL

UPDATE @em_type_rule_items
SET min_element_count = possible_element_count
WHERE min_element_count > possible_element_count

-- Update the actual element count for rules without an em_category
UPDATE i
SET actual_element_count = e.element_count
FROM @em_type_rule_items i
	INNER JOIN (
		SELECT em_component, em_type, count(*) as element_count
		FROM @em_elements
		GROUP BY em_component, em_type) as e
	ON i.em_component = e.em_component
	AND i.em_type = e.em_type
WHERE i.em_category IS NULL

-- Update the actual category count
UPDATE i
SET actual_category_count = e.category_count
FROM @em_type_rule_items i
	INNER JOIN (
		SELECT j.em_component, j.em_type, j.em_type_level, j.rule_id, j.item_sequence, count(*) as category_count
		FROM @em_type_rule_items j
			INNER JOIN @em_category_counts c
			ON j.em_component = c.em_component
			AND j.em_type = c.em_type
		WHERE j.em_category IS NULL
		AND COALESCE(j.min_elements_per_category, 1) <= c.element_count
		GROUP BY j.em_component, j.em_type, j.em_type_level, j.rule_id, j.item_sequence ) as e
	ON i.em_component = e.em_component
	AND i.em_type = e.em_type
	AND i.rule_id = e.rule_id
	AND i.item_sequence = e.item_sequence
WHERE i.em_category IS NULL


-- Get the actual encounter complexity
SELECT @ll_actual_encounter_complexity = dbo.fn_encounter_complexity(@ps_cpr_id, @pl_encounter_id)

-- Get the actual encounter risk_level
SET @ll_actual_encounter_risk_level = dbo.fn_encounter_risk_level(@ps_cpr_id, @pl_encounter_id)

-- Add up the result_count from all the observations, but exclude those observations
-- which are mapped to history taking bullets
SELECT @ll_actual_encounter_results = sum(result_count)
FROM @patient_observations o
WHERE NOT EXISTS (
	SELECT 1
	FROM em_Observation_Element e
	WHERE o.observation_id = e.observation_id
	AND @ls_count_physical = 'N')

-- Add up the result_count from all the treatments which were ordered but for which no
-- results were recorded
SELECT @ll_ordered_encounter_results = sum(o.result_count)
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON t.observation_id = o.observation_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND NOT EXISTS (
	SELECT p.observation_sequence
	FROM @patient_observations p
	WHERE p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id)
AND NOT EXISTS (
	SELECT 1
	FROM em_Observation_Element e
	WHERE o.observation_id = e.observation_id
	AND @ls_count_physical = 'N')
	
-- Add up the result_count from all the treatments which were reviewed but for which no
-- results were recorded
-- Get the actual encounter risk_level
SET @ll_reviewed_encounter_results = dbo.fn_encounter_reviewed_results(@ps_cpr_id, @pl_encounter_id)

SET @ll_total_encounter_results = COALESCE(@ll_actual_encounter_results, 0)
						+ COALESCE(@ll_ordered_encounter_results, 0)
						+ COALESCE(@ll_reviewed_encounter_results, 0)

-- Now update the rule table with a count of how many items passed for each rule
UPDATE r
SET passed_item_count = i.passed_item_count
FROM @em_type_rules r
	INNER JOIN (
		SELECT em_component, em_type, em_type_level, rule_id, count(*) as passed_item_count
		FROM @em_type_rule_items
		WHERE ((min_element_count IS NULL) OR (min_element_count <= actual_element_count))
		AND ((min_category_count IS NULL) OR (min_category_count <= actual_category_count))
		AND ((min_encounter_complexity IS NULL) OR (min_encounter_complexity <= @ll_actual_encounter_complexity))
		AND ((min_encounter_risk_level IS NULL) OR (min_encounter_risk_level <= @ll_actual_encounter_risk_level))
		AND ((min_encounter_results IS NULL) OR (min_encounter_results <= @ll_total_encounter_results))
		GROUP BY em_component, em_type, em_type_level, rule_id ) as i
	ON i.em_component = r.em_component
	AND i.em_type = r.em_type
	AND i.em_type_level = r.em_type_level
	AND i.rule_id = r.rule_id
	
UPDATE @em_type_rules
SET item_count = possible_item_count
WHERE item_count IS NULL

INSERT INTO @em_type_rules_passed (
	em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	new_flag,
	description,
	passed_flag )
SELECT em_documentation_guide,
	em_component,
	em_type,
	em_type_level,
	rule_id,
	new_flag,
	description,
	CASE WHEN item_count <= passed_item_count THEN 'Y' ELSE 'N' END as passed_flag
FROM @em_type_rules


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_em_type_rules_passed] TO [cprsystem]
GO

