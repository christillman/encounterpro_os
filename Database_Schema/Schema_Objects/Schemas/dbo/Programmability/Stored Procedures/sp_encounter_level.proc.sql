CREATE PROCEDURE sp_encounter_level (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_em_documentation_guide varchar(24),
	@pi_history_level smallint OUTPUT ,
	@pi_exam_level smallint OUTPUT ,
	@pi_decision_level smallint OUTPUT)
AS

DECLARE @em_component_levels TABLE (
	em_component varchar(24) NOT NULL,
	em_component_level int NULL )

-- Get the max em_type_level passed for each em_type
INSERT INTO @em_component_levels (
	em_component,
	em_component_level)
SELECT em_component,
	max(em_component_level) as em_component_level
FROM fn_em_component_rules_passed(@ps_cpr_id, @pl_encounter_id, @ps_em_documentation_guide)
WHERE passed_flag = 'Y'
GROUP BY em_component

SELECT @pi_history_level = COALESCE(max(em_component_level), 0)
FROM @em_component_levels
WHERE em_component = 'History'

SELECT @pi_exam_level = COALESCE(max(em_component_level), 0)
FROM @em_component_levels
WHERE em_component = 'Examination'

SELECT @pi_decision_level = COALESCE(max(em_component_level), 0)
FROM @em_component_levels
WHERE em_component = 'Decision Making'




