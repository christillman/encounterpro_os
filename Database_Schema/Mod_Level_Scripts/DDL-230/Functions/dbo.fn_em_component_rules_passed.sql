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

-- Drop Function [dbo].[fn_em_component_rules_passed]
Print 'Drop Function [dbo].[fn_em_component_rules_passed]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_em_component_rules_passed]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_em_component_rules_passed]
GO

-- Create Function [dbo].[fn_em_component_rules_passed]
Print 'Create Function [dbo].[fn_em_component_rules_passed]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_em_component_rules_passed (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_em_documentation_guide varchar(24))

RETURNS @em_component_rules_passed TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_component_level int NOT NULL,
	rule_id int NOT NULL,
	description varchar(1024) NULL,
	passed_flag char(1) NULL)

AS
BEGIN

DECLARE @em_component_rules TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_component_level int NOT NULL,
	rule_id int NOT NULL,
	item_count smallint NULL,
	description varchar(1024) NULL,
	possible_item_count smallint NULL,
	passed_item_count smallint NULL)

DECLARE @em_component_rule_items TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	em_component varchar(24) NOT NULL,
	em_component_level int NOT NULL,
	rule_id int NOT NULL,
	item_sequence int NOT NULL,
	em_type varchar(24) NULL,
	min_em_type_level int NULL,
	actual_em_type_level int NULL)

DECLARE @em_type_level_passed TABLE (
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_type_level int NOT NULL )

INSERT INTO @em_component_rules (
	em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	item_count,
	description,
	passed_item_count)
SELECT em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	item_count,
	description,
	0 as passed_item_count
FROM em_component_rule WITH (NOLOCK)
WHERE em_documentation_guide = @ps_em_documentation_guide

-- Count how many rule items exist for each rule
UPDATE r
SET possible_item_count = i.possible_item_count
FROM @em_component_rules as r
	INNER JOIN 
		(SELECT em_documentation_guide,
			em_component,
			em_component_level,
			rule_id,
			count(*) as possible_item_count
		FROM em_component_rule_item WITH (NOLOCK)
		GROUP BY em_documentation_guide,
			em_component,
			em_component_level,
			rule_id) as i
	ON r.em_documentation_guide = i.em_documentation_guide
	AND r.em_component = i.em_component
	AND r.em_component_level = i.em_component_level
	AND r.rule_id = i.rule_id

-- Get all the rule items in a temp table
INSERT INTO @em_component_rule_items (
	em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	item_sequence,
	em_type,
	min_em_type_level,
	actual_em_type_level)
SELECT em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	item_sequence,
	em_type,
	min_em_type_level,
	0 as actual_em_type_level
FROM em_component_rule_item WITH (NOLOCK)
WHERE em_documentation_guide = @ps_em_documentation_guide

-- Get the max em_type_level passed for each em_type
INSERT INTO @em_type_level_passed (
	em_component,
	em_type,
	em_type_level)
SELECT em_component,
	em_type,
	max(em_type_level) as em_type_level
FROM dbo.fn_em_type_rules_passed(@ps_cpr_id, @pl_encounter_id, @ps_em_documentation_guide)
WHERE passed_flag = 'Y'
GROUP BY em_component, em_type

-- Update the actual em_type level where the em_type is not null
UPDATE i
SET actual_em_type_level = t.em_type_level
FROM @em_component_rule_items i
	INNER JOIN @em_type_level_passed as t
	ON i.em_component = t.em_component
	AND i.em_type = t.em_type
AND i.em_type IS NOT NULL

-- Update the actual em_type level where the em_type is null
UPDATE i
SET actual_em_type_level = t.em_type_level
FROM @em_component_rule_items i
	INNER JOIN (
		SELECT em_component, max(em_type_level) as em_type_level
		FROM @em_type_level_passed
		GROUP BY em_component) as t
	ON i.em_component = t.em_component
AND i.em_type IS NULL

-- Now update the rule table with a count of how many items passed for each rule
UPDATE r
SET passed_item_count = i.passed_item_count
FROM @em_component_rules r
	INNER JOIN (
		SELECT em_component, em_component_level, rule_id, count(*) as passed_item_count
		FROM @em_component_rule_items
		WHERE min_em_type_level <= actual_em_type_level
		GROUP BY em_component, em_component_level, rule_id ) as i
	ON i.em_component = r.em_component
	AND i.em_component_level = r.em_component_level
	AND i.rule_id = r.rule_id
	
UPDATE @em_component_rules
SET item_count = possible_item_count
WHERE item_count IS NULL

INSERT INTO @em_component_rules_passed (
	em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	description,
	passed_flag )
SELECT em_documentation_guide,
	em_component,
	em_component_level,
	rule_id,
	description,
	CASE WHEN item_count <= passed_item_count THEN 'Y' ELSE 'N' END as passed_flag
FROM @em_component_rules

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_em_component_rules_passed] TO [cprsystem]
GO

