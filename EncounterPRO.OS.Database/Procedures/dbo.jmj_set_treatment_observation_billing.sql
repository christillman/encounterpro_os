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

-- Drop Procedure [dbo].[jmj_set_treatment_observation_billing]
Print 'Drop Procedure [dbo].[jmj_set_treatment_observation_billing]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_treatment_observation_billing]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_treatment_observation_billing]
GO

-- Create Procedure [dbo].[jmj_set_treatment_observation_billing]
Print 'Create Procedure [dbo].[jmj_set_treatment_observation_billing]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_treatment_observation_billing (
	@ps_cpr_id varchar(12) ,
	@pl_encounter_id integer ,
	@pl_treatment_id integer ,
	@ps_created_by varchar(24) )
AS

SET NOCOUNT ON

DECLARE @ls_accumulate_perform_type varchar(24),
		@ls_accumulate_collect_type varchar(24)

DECLARE @charges TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	treatment_id int NOT NULL,
	observation_sequence int NOT NULL,
	procedure_type varchar(12) NOT NULL,
	procedure_id varchar(24) NOT NULL,
	bill_flag char(1) NOT NULL)

SET @ls_accumulate_perform_type = 'TESTPERFORM'
SET @ls_accumulate_collect_type = 'TESTCOLLECT'


-- Add the root perform charges
INSERT INTO @charges (
	cpr_id ,
	encounter_id ,
	treatment_id ,
	observation_sequence ,
	procedure_type ,
	procedure_id,
	bill_flag )
SELECT DISTINCT t.cpr_id ,
	t.open_encounter_id ,
	t.treatment_id ,
	o.observation_sequence ,
	@ls_accumulate_perform_type,
	c.perform_procedure_id,
	COALESCE(p.default_bill_flag, 'N')
from p_treatment_item t
	INNER JOIN p_Observation o
	on t.cpr_id = o.cpr_id
	and t.treatment_id = o.treatment_id
	and o.parent_observation_sequence IS NULL
	INNER JOIN c_Observation c
	on o.observation_id = c.observation_id
	INNER JOIN c_Procedure p
	on c.perform_procedure_id = p.procedure_id
where t.bill_observation_perform = 1
and c.perform_procedure_id is not null
and t.cpr_id = @ps_cpr_id
and t.treatment_id = @pl_treatment_id
and o.encounter_id = @pl_encounter_id

-- Add the Treatment Observation charge if it's not already there
IF NOT EXISTS (
	SELECT 1
	FROM p_treatment_item t
		INNER JOIN c_Observation c
		on t.observation_id = c.observation_id
		INNER JOIN @charges x
		ON t.cpr_id = x.cpr_id
		and t.open_encounter_id = x.encounter_id
		and t.treatment_id = x.treatment_id
		and x.procedure_type = @ls_accumulate_perform_type
		AND c.perform_procedure_id = x.procedure_id)
	BEGIN
	INSERT INTO @charges (
		cpr_id ,
		encounter_id ,
		treatment_id ,
		observation_sequence ,
		procedure_type ,
		procedure_id,
		bill_flag )
	SELECT DISTINCT t.cpr_id ,
		t.open_encounter_id ,
		t.treatment_id ,
		0 ,
		@ls_accumulate_perform_type,
		c.perform_procedure_id,
		COALESCE(p.default_bill_flag, 'N')
	from p_treatment_item t
		INNER JOIN c_Observation c
		on t.observation_id = c.observation_id
		INNER JOIN c_Procedure p
		on c.perform_procedure_id = p.procedure_id
	where t.bill_observation_perform = 1
	and c.perform_procedure_id is not null
	and t.cpr_id = @ps_cpr_id
	and t.treatment_id = @pl_treatment_id
	END	

-- Add the child perform charges
INSERT INTO @charges (
	cpr_id ,
	encounter_id ,
	treatment_id ,
	observation_sequence ,
	procedure_type ,
	procedure_id,
	bill_flag )
SELECT DISTINCT r.cpr_id ,
	r.encounter_id ,
	r.treatment_id ,
	r.observation_sequence ,
	@ls_accumulate_perform_type,
	c.perform_procedure_id,
	COALESCE(p.default_bill_flag, 'N')
from p_observation_result r
	INNER JOIN p_Observation o
	on r.cpr_id = o.cpr_id
	and r.observation_sequence = o.observation_sequence
	INNER JOIN c_Observation c
	on r.observation_id = c.observation_id
	INNER JOIN p_treatment_item t
	on t.cpr_id = t.cpr_id
	and r.treatment_id = t.treatment_id
	INNER JOIN c_Procedure p
	on c.perform_procedure_id = p.procedure_id
where t.bill_children_perform = 1
and r.result_type = 'PERFORM'
and r.current_flag = 'Y'
and o.parent_observation_sequence IS NOT NULL
and c.perform_procedure_id is not null
and r.cpr_id = @ps_cpr_id
and r.encounter_id = @pl_encounter_id
and r.treatment_id = @pl_treatment_id
AND NOT EXISTS (
	SELECT 1
	FROM @charges x
	WHERE x.cpr_id = r.cpr_id
	AND x.encounter_id = r.encounter_id
	AND x.treatment_id = r.treatment_id
	AND x.observation_sequence = r.observation_sequence
	AND x.procedure_type = @ls_accumulate_perform_type 
	AND x.procedure_id = c.perform_procedure_id )


-- Add the root collect charges
INSERT INTO @charges (
	cpr_id ,
	encounter_id ,
	treatment_id ,
	observation_sequence ,
	procedure_type ,
	procedure_id,
	bill_flag )
SELECT DISTINCT t.cpr_id ,
	t.open_encounter_id ,
	t.treatment_id ,
	o.observation_sequence ,
	@ls_accumulate_collect_type,
	c.collection_procedure_id,
	COALESCE(p.default_bill_flag, 'N')
from p_treatment_item t
	INNER JOIN p_Observation o
	on t.cpr_id = o.cpr_id
	and t.treatment_id = o.treatment_id
	and o.parent_observation_sequence IS NULL
	INNER JOIN c_Observation c
	on o.observation_id = c.observation_id
	INNER JOIN c_Procedure p
	on c.collection_procedure_id = p.procedure_id
where t.bill_observation_collect = 1
and c.collection_procedure_id is not null
and t.cpr_id = @ps_cpr_id
and t.treatment_id = @pl_treatment_id
and o.encounter_id = @pl_encounter_id

-- Add the Treatment Observation collect charge if it's not already there
IF NOT EXISTS (
	SELECT 1
	FROM p_treatment_item t
		INNER JOIN c_Observation c
		on t.observation_id = c.observation_id
		INNER JOIN @charges x
		ON t.cpr_id = x.cpr_id
		and t.open_encounter_id = x.encounter_id
		and t.treatment_id = x.treatment_id
		and x.procedure_type = @ls_accumulate_collect_type
		AND c.collection_procedure_id = x.procedure_id)
	BEGIN
	INSERT INTO @charges (
		cpr_id ,
		encounter_id ,
		treatment_id ,
		observation_sequence ,
		procedure_type ,
		procedure_id,
		bill_flag )
	SELECT DISTINCT t.cpr_id ,
		t.open_encounter_id ,
		t.treatment_id ,
		0 ,
		@ls_accumulate_collect_type,
		c.collection_procedure_id,
		COALESCE(p.default_bill_flag, 'N')
	from p_treatment_item t
		INNER JOIN c_Observation c
		on t.observation_id = c.observation_id
		INNER JOIN c_Procedure p
		on c.collection_procedure_id = p.procedure_id
	where t.bill_observation_collect = 1
	and c.collection_procedure_id is not null
	and t.cpr_id = @ps_cpr_id
	and t.treatment_id = @pl_treatment_id
	END	

-- Add the child collect charges
INSERT INTO @charges (
	cpr_id ,
	encounter_id ,
	treatment_id ,
	observation_sequence ,
	procedure_type ,
	procedure_id,
	bill_flag )
SELECT DISTINCT r.cpr_id ,
	r.encounter_id ,
	r.treatment_id ,
	r.observation_sequence ,
	@ls_accumulate_collect_type,
	c.collection_procedure_id,
	COALESCE(p.default_bill_flag, 'N')
from p_observation_result r
	INNER JOIN p_Observation o
	on r.cpr_id = o.cpr_id
	and r.observation_sequence = o.observation_sequence
	INNER JOIN c_Observation c
	on r.observation_id = c.observation_id
	INNER JOIN p_treatment_item t
	on t.cpr_id = t.cpr_id
	and r.treatment_id = t.treatment_id
	INNER JOIN c_Procedure p
	on c.collection_procedure_id = p.procedure_id
where t.bill_children_collect = 1
and r.result_type = 'COLLECT'
and r.current_flag = 'Y'
and o.parent_observation_sequence IS NOT NULL
and c.collection_procedure_id is not null
and r.cpr_id = @ps_cpr_id
and r.encounter_id = @pl_encounter_id
and r.treatment_id = @pl_treatment_id
AND NOT EXISTS (
	SELECT 1
	FROM @charges x
	WHERE x.cpr_id = r.cpr_id
	AND x.encounter_id = r.encounter_id
	AND x.treatment_id = r.treatment_id
	AND x.observation_sequence = r.observation_sequence
	AND x.procedure_type = @ls_accumulate_collect_type 
	AND x.procedure_id = c.collection_procedure_id )


-- Clear the existing units and bill_flags
DELETE p_Encounter_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND treatment_id = @pl_treatment_id
AND procedure_type IN (@ls_accumulate_perform_type, @ls_accumulate_collect_type)

DECLARE @ls_procedure_id varchar(24),
		@ll_units integer

-- Insert any missing records
DECLARE lc_bill_charge CURSOR LOCAL FAST_FORWARD FOR
	SELECT procedure_id,
			count(*) as proc_count
	FROM @charges
	GROUP BY procedure_id

OPEN lc_bill_charge

FETCH lc_bill_charge INTO @ls_procedure_id, @ll_units

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_add_encounter_charge
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_procedure_id = @ls_procedure_id,
		@pl_treatment_id = @pl_treatment_id,
		@ps_created_by = @ps_created_by,
		@ps_replace_flag = 'N',
		@pl_units = @ll_units

	FETCH lc_bill_charge INTO @ls_procedure_id, @ll_units
	END

CLOSE lc_bill_charge
DEALLOCATE lc_bill_charge



GO
GRANT EXECUTE
	ON [dbo].[jmj_set_treatment_observation_billing]
	TO [cprsystem]
GO

