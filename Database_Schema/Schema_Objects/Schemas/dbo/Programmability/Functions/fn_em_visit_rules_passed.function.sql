CREATE FUNCTION fn_em_visit_rules_passed (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_em_documentation_guide varchar(24))

RETURNS @em_visit_rules_passed TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	visit_level int NOT NULL,
	rule_id int NOT NULL,
	description varchar(1024) NULL,
	passed_flag char(1) NULL)

AS
BEGIN
DECLARE @ls_new_flag char(1),
	@ll_max_component_level int

SELECT @ls_new_flag = COALESCE(new_flag, 'N')
FROM p_Patient_Encounter WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

DECLARE @em_visit_rules TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	visit_level int NOT NULL,
	rule_id int NOT NULL,
	item_count smallint NULL,
	description varchar(1024) NULL,
	possible_item_count smallint NULL,
	passed_item_count smallint NULL)

DECLARE @em_visit_rule_items TABLE (
	em_documentation_guide varchar(24) NOT NULL,
	visit_level int NOT NULL,
	rule_id int NOT NULL,
	item_sequence int NOT NULL,
	em_component varchar(24) NULL,
	min_em_component_level int NULL,
	actual_em_component_level int NULL)

DECLARE @em_component_level_passed TABLE (
	em_component varchar(24) NOT NULL,
	em_component_level int NOT NULL )

INSERT INTO @em_visit_rules (
	em_documentation_guide,
	visit_level,
	rule_id,
	item_count,
	description,
	passed_item_count)
SELECT em_documentation_guide,
	visit_level,
	rule_id,
	item_count,
	description,
	0 as passed_item_count
FROM em_visit_level_rule WITH (NOLOCK)
WHERE em_documentation_guide = @ps_em_documentation_guide
AND new_flag = @ls_new_flag

-- Count how many rule items exist for each rule
UPDATE r
SET possible_item_count = i.possible_item_count
FROM @em_visit_rules as r
	INNER JOIN 
		(SELECT em_documentation_guide,
			visit_level,
			rule_id,
			count(*) as possible_item_count
		FROM em_visit_level_rule_item WITH (NOLOCK)
		GROUP BY em_documentation_guide,
			visit_level,
			rule_id) as i
	ON r.em_documentation_guide = i.em_documentation_guide
	AND r.visit_level = i.visit_level
	AND r.rule_id = i.rule_id

-- Get all the rule items in a temp table
INSERT INTO @em_visit_rule_items (
	em_documentation_guide,
	visit_level,
	rule_id,
	item_sequence,
	em_component,
	min_em_component_level,
	actual_em_component_level)
SELECT i.em_documentation_guide,
	i.visit_level,
	i.rule_id,
	i.item_sequence,
	i.em_component,
	i.min_em_component_level,
	0 as actual_em_type_level
FROM em_visit_level_rule_item i WITH (NOLOCK)
	INNER JOIN @em_visit_rules r
	ON r.em_documentation_guide = i.em_documentation_guide
	AND r.visit_level = i.visit_level
	AND r.rule_id = i.rule_id

-- Get the max em_component_level passed for each em_component
INSERT INTO @em_component_level_passed (
	em_component,
	em_component_level)
SELECT em_component,
	max(em_component_level) as em_component_level
FROM fn_em_component_rules_passed(@ps_cpr_id, @pl_encounter_id, @ps_em_documentation_guide)
WHERE passed_flag = 'Y'
GROUP BY em_component

-- Update the actual em_component level where the em_component is not null
UPDATE i
SET actual_em_component_level = t.em_component_level
FROM @em_visit_rule_items i
	INNER JOIN @em_component_level_passed as t
	ON i.em_component = t.em_component
WHERE i.em_component IS NOT NULL

-- Update the actual em_component level where the em_type is null
SELECT @ll_max_component_level = max(em_component_level)
FROM @em_component_level_passed

UPDATE @em_visit_rule_items
SET actual_em_component_level = @ll_max_component_level
WHERE em_component IS NULL

-- Now update the rule table with a count of how many items passed for each rule
UPDATE r
SET passed_item_count = i.passed_item_count
FROM @em_visit_rules r
	INNER JOIN (
		SELECT visit_level, rule_id, count(*) as passed_item_count
		FROM @em_visit_rule_items
		WHERE min_em_component_level <= actual_em_component_level
		GROUP BY visit_level, rule_id ) as i
	ON i.visit_level = r.visit_level
	AND i.rule_id = r.rule_id
	
UPDATE @em_visit_rules
SET item_count = possible_item_count
WHERE item_count IS NULL

INSERT INTO @em_visit_rules_passed (
	em_documentation_guide,
	visit_level,
	rule_id,
	description,
	passed_flag )
SELECT em_documentation_guide,
	visit_level,
	rule_id,
	description,
	CASE WHEN item_count <= passed_item_count THEN 'Y' ELSE 'N' END as passed_flag
FROM @em_visit_rules

RETURN
END

