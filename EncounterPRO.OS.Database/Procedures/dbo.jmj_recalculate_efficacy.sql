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

-- Drop Procedure [dbo].[jmj_recalculate_efficacy]
Print 'Drop Procedure [dbo].[jmj_recalculate_efficacy]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_recalculate_efficacy]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_recalculate_efficacy]
GO

-- Create Procedure [dbo].[jmj_recalculate_efficacy]
Print 'Create Procedure [dbo].[jmj_recalculate_efficacy]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
GO
GRANT EXECUTE
	ON [dbo].[jmj_recalculate_efficacy]
	TO [cprsystem]
GO

