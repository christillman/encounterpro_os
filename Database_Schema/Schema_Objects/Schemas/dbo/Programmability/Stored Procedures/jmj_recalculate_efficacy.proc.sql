CREATE PROCEDURE jmj_recalculate_efficacy 
AS

DECLARE @eff_counts TABLE (
	assessment_id varchar(24) NOT NULL,
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	effectiveness varchar(24) NOT NULL,
	effectiveness_count int NOT NULL)

DECLARE @eff TABLE (
	assessment_id varchar(24) NOT NULL,
	treatment_type varchar(24) NOT NULL,
	treatment_key varchar(64) NOT NULL,
	very_effective_count int NOT NULL,
	effective_count int NOT NULL,
	no_effect_count int NOT NULL,
	adverse_count int NOT NULL,
	very_adverse_count int NOT NULL)

INSERT INTO @eff_counts (
	assessment_id ,
	treatment_type ,
	treatment_key ,
	effectiveness ,
	effectiveness_count)
SELECT assessment_id ,
	treatment_type ,
	treatment_key ,
	effectiveness ,
	count(*)
FROM r_efficacy_data
GROUP BY assessment_id ,
	treatment_type ,
	treatment_key ,
	effectiveness

INSERT INTO @eff (
	assessment_id ,
	treatment_type ,
	treatment_key ,
	very_effective_count ,
	effective_count ,
	no_effect_count ,
	adverse_count ,
	very_adverse_count )
SELECT DISTINCT assessment_id ,
	treatment_type ,
	treatment_key ,
	0 ,
	0 ,
	0 ,
	0 ,
	0
FROM @eff_counts

UPDATE e
SET very_effective_count = c.effectiveness_count
FROM @eff e
	INNER JOIN @eff_counts c
	ON e.assessment_id = c.assessment_id
	AND e.treatment_type = c.treatment_type
	AND e.treatment_key = c.treatment_key
WHERE c.effectiveness = 'Very Effective'

UPDATE e
SET effective_count = c.effectiveness_count
FROM @eff e
	INNER JOIN @eff_counts c
	ON e.assessment_id = c.assessment_id
	AND e.treatment_type = c.treatment_type
	AND e.treatment_key = c.treatment_key
WHERE c.effectiveness = 'Effective'

UPDATE e
SET no_effect_count = c.effectiveness_count
FROM @eff e
	INNER JOIN @eff_counts c
	ON e.assessment_id = c.assessment_id
	AND e.treatment_type = c.treatment_type
	AND e.treatment_key = c.treatment_key
WHERE c.effectiveness = 'No Effect'

UPDATE e
SET adverse_count = c.effectiveness_count
FROM @eff e
	INNER JOIN @eff_counts c
	ON e.assessment_id = c.assessment_id
	AND e.treatment_type = c.treatment_type
	AND e.treatment_key = c.treatment_key
WHERE c.effectiveness = 'Adverse'

UPDATE e
SET very_adverse_count = c.effectiveness_count
FROM @eff e
	INNER JOIN @eff_counts c
	ON e.assessment_id = c.assessment_id
	AND e.treatment_type = c.treatment_type
	AND e.treatment_key = c.treatment_key
WHERE c.effectiveness = 'Very Adverse'

-- Remove any treatments that don't have enough data
DELETE e
FROM @eff e
WHERE very_effective_count + effective_count + no_effect_count + adverse_count + very_adverse_count < 50

-- Remove any efficacy records we're about to replace
DELETE r
FROM r_Assessment_Treatment_Efficacy r
	INNER JOIN @eff e
	ON e.assessment_id = r.assessment_id
	AND e.treatment_type = r.treatment_type
	AND e.treatment_key = r.treatment_key

-- This calculation sets the rating to the number of effective + very_effective devided by the total of all ratings
INSERT INTO r_Assessment_Treatment_Efficacy (
	assessment_id ,
	treatment_type ,
	treatment_key ,
	rating )
SELECT assessment_id ,
	treatment_type ,
	treatment_key ,
	100 * (very_effective_count + effective_count) / (very_effective_count + effective_count + no_effect_count + adverse_count + very_adverse_count)
FROM @eff
