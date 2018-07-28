CREATE FUNCTION fn_em_component_rules_passed (
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
FROM fn_em_type_rules_passed(@ps_cpr_id, @pl_encounter_id, @ps_em_documentation_guide)
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

