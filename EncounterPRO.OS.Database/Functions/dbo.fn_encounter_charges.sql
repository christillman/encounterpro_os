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

-- Drop Function [dbo].[fn_encounter_charges]
Print 'Drop Function [dbo].[fn_encounter_charges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_encounter_charges]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_encounter_charges]
GO

-- Create Function [dbo].[fn_encounter_charges]
Print 'Create Function [dbo].[fn_encounter_charges]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_encounter_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int
	)

RETURNS @charges TABLE (
	[problem_id] [int] NOT NULL,
	[assessment_sequence] [smallint] NULL,
	[assessment_id] [varchar](24) NULL,
	[assessment_description] varchar(80) NULL,
	[icd10_code] [varchar](12) NULL,
	[encounter_charge_id] [int] NULL,
	[treatment_id] [int] NULL,
	[procedure_type] [varchar](12) NOT NULL,
	[procedure_id] [varchar](24) NOT NULL,
	[procedure_description] varchar(80) NULL,
	[charge] [money] NULL,
	[cpt_code] [varchar](24) NULL,
	[units] [int] NULL,
	[posted] [char](1) NOT NULL ,
	[modifier] [varchar](2) NULL,
	[other_modifiers] [varchar](12) NULL,
	[last_updated] [datetime] NULL,
	[last_updated_by] [varchar](24) NULL,
	[last_updated_name] [varchar] (64) NULL,
	[units_recovered] [int] NULL,
	[charge_recovered] [money] NULL,
	[assessment_bill_flag] [char] (1) NOT NULL,
	[charge_bill_flag] [char] (1) NOT NULL,
	[assessment_charge_bill_flag] [char] (1) NOT NULL,
	[procedure_type_sort_sequence] [int] NULL,
	[charge_sort_sequence] [int] NULL,
	[assessment_sort_sequence] [int] NULL
	)
AS

BEGIN


INSERT INTO @charges (
	problem_id ,
	assessment_sequence ,
	assessment_id ,
	assessment_description ,
	icd10_code ,
	encounter_charge_id ,
	treatment_id ,
	procedure_type ,
	procedure_id ,
	procedure_description ,
	charge ,
	cpt_code ,
	units ,
	posted ,
	modifier ,
	other_modifiers ,
	last_updated ,
	last_updated_by ,
	last_updated_name ,
	units_recovered ,
	charge_recovered ,
	assessment_bill_flag ,
	charge_bill_flag ,
	assessment_charge_bill_flag ,
	procedure_type_sort_sequence ,
	charge_sort_sequence ,
	assessment_sort_sequence )
SELECT a.problem_id,
	a.assessment_sequence,
	a.assessment_id,
	COALESCE(
	-- With ICD10, especially for vaccination, we need the ICD10 description
	-- rather than the assessment description so it matches the ICD10 code.
						(SELECT descr
						FROM icd10cm_codes
						WHERE code = ad.icd10_code),
						pa.assessment, ad.description),
	COALESCE(a.icd10_code, ad.icd10_code),
	c.encounter_charge_id,
	c.treatment_id,
	c.procedure_type,
	c.procedure_id,
	p.description,
	c.charge,
	cpt_code = COALESCE(c.cpt_code, p.cpt_code),
	c.units,
	c.posted,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	last_updated_name = u.user_full_name,
	c.units_recovered ,
	c.charge_recovered ,
	assessment_bill_flag = a.bill_flag,
	charge_bill_flag = c.bill_flag,
	assessment_charge_bill_flag = ac.bill_flag,
	t.sort_sequence ,
	COALESCE(c.sort_sequence, c.encounter_charge_id) ,
	assessment_sort_sequence = COALESCE(ac.billing_sequence, a.assessment_sequence)
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	INNER JOIN p_Encounter_Assessment_Charge ac
	ON c.cpr_id = ac.cpr_id
	AND c.encounter_id = ac.encounter_id
	AND c.encounter_charge_id = ac.encounter_charge_id
	INNER JOIN p_Encounter_Assessment a
	ON ac.cpr_id = a.cpr_id
	AND ac.encounter_id = a.encounter_id
	AND ac.problem_id = a.problem_id
	INNER JOIN c_Assessment_Definition ad
	ON ad.assessment_id = a.assessment_id
	LEFT OUTER JOIN p_Assessment pa
	ON ac.cpr_id = pa.cpr_id
	AND ac.problem_id = pa.problem_id
	AND pa.current_flag = 'Y'
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
	LEFT OUTER JOIN c_User u
	ON u.user_id = c.last_updated_by
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND c.bill_flag = 'Y'
AND ac.bill_flag = 'Y'

-- Different ICD versions will expect different descriptions
IF [dbo].[fn_icd_version]() = 'ICD10-WHO' 
	UPDATE @charges
	SET icd10_code = COALESCE(a.icd10_code, w.code),
		[assessment_description] = COALESCE(pa.assessment, w.descr)
	FROM @charges ch 
		INNER JOIN p_Encounter_Assessment a
			ON ch.assessment_id = a.assessment_id
		INNER JOIN p_Encounter_Assessment_Charge ac
			ON ac.cpr_id = a.cpr_id
			AND ac.encounter_id = a.encounter_id
			AND ac.problem_id = a.problem_id
		INNER JOIN p_Encounter_Charge c
			ON c.cpr_id = ac.cpr_id
			AND c.encounter_id = ac.encounter_id
			AND c.encounter_charge_id = ac.encounter_charge_id
		INNER JOIN c_Assessment_Definition ad
			ON ad.assessment_id = ch.assessment_id
		INNER JOIN icd10_who w WITH (NOLOCK)
			ON ad.icd10_who_code = w.code
		LEFT OUTER JOIN p_Assessment pa
			ON ac.cpr_id = pa.cpr_id
			AND ac.problem_id = pa.problem_id
			AND pa.current_flag = 'Y'
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND a.bill_flag = 'Y'
	AND c.bill_flag = 'Y'
	AND ac.bill_flag = 'Y'
	AND ch.assessment_id = a.assessment_id
	
IF [dbo].[fn_icd_version]() = 'Rwanda' 
	UPDATE @charges
	SET icd10_code = COALESCE(a.icd10_code, r.code),
		[assessment_description] = COALESCE(pa.assessment, r.descr)
	FROM @charges ch 
		INNER JOIN p_Encounter_Assessment a
			ON ch.assessment_id = a.assessment_id
		INNER JOIN p_Encounter_Assessment_Charge ac
			ON ac.cpr_id = a.cpr_id
			AND ac.encounter_id = a.encounter_id
			AND ac.problem_id = a.problem_id
		INNER JOIN p_Encounter_Charge c
			ON c.cpr_id = ac.cpr_id
			AND c.encounter_id = ac.encounter_id
			AND c.encounter_charge_id = ac.encounter_charge_id
		INNER JOIN c_Assessment_Definition ad
			ON ad.assessment_id = ch.assessment_id
		INNER JOIN icd10_rwanda r WITH (NOLOCK)
			ON ad.icd10_who_code = r.code
		LEFT OUTER JOIN p_Assessment pa
			ON ac.cpr_id = pa.cpr_id
			AND ac.problem_id = pa.problem_id
			AND pa.current_flag = 'Y'
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND a.bill_flag = 'Y'
	AND c.bill_flag = 'Y'
	AND ac.bill_flag = 'Y'
	
INSERT INTO @charges (
	problem_id ,
	assessment_sequence ,
	assessment_id ,
	assessment_description ,
	icd10_code ,
	encounter_charge_id ,
	treatment_id ,
	procedure_type ,
	procedure_id ,
	procedure_description ,
	charge ,
	cpt_code ,
	units ,
	posted ,
	modifier ,
	other_modifiers ,
	last_updated ,
	last_updated_by ,
	last_updated_name ,
	units_recovered ,
	charge_recovered ,
	assessment_bill_flag ,
	charge_bill_flag ,
	assessment_charge_bill_flag ,
	procedure_type_sort_sequence ,
	charge_sort_sequence ,
	assessment_sort_sequence )
SELECT a.problem_id,
	a.assessment_sequence,
	a.assessment_id,
	pa.assessment ,
	icd10_code = COALESCE(a.icd10_code, ad.icd10_code),
	NULL,
	NULL,
	'UNASSOCIATED',
	'UNASSOCIATED',
	'Diagnoses With No Charges',
	NULL,
	NULL,
	1,
	'N',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	assessment_bill_flag = a.bill_flag,
	'Y',
	'Y',
	999999999,
	999999999,
	assessment_sort_sequence = a.assessment_sequence
FROM p_Encounter_Assessment a
	INNER JOIN p_Assessment pa
	ON a.cpr_id = pa.cpr_id
	AND a.problem_id = pa.problem_id
	AND pa.current_flag = 'Y'
	INNER JOIN c_Assessment_Definition ad
	ON ad.assessment_id = a.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND ISNULL(pa.assessment_status, 'OPEN') <> 'CANCELLED'
AND a.bill_flag = 'Y'
AND a.problem_id NOT IN (
	SELECT DISTINCT problem_id
	FROM @charges
	WHERE problem_id IS NOT NULL )

INSERT INTO @charges (
	problem_id ,
	assessment_sequence ,
	assessment_id ,
	assessment_description ,
	icd10_code ,
	encounter_charge_id ,
	treatment_id ,
	procedure_type ,
	procedure_id ,
	procedure_description ,
	charge ,
	cpt_code ,
	units ,
	posted ,
	modifier ,
	other_modifiers ,
	last_updated ,
	last_updated_by ,
	last_updated_name ,
	units_recovered ,
	charge_recovered ,
	assessment_bill_flag ,
	charge_bill_flag ,
	assessment_charge_bill_flag ,
	procedure_type_sort_sequence ,
	charge_sort_sequence ,
	assessment_sort_sequence )
SELECT 0,
	NULL,
	NULL,
	'Not Billed' ,
	NULL,
	c.encounter_charge_id,
	c.treatment_id,
	c.procedure_type,
	c.procedure_id,
	p.description,
	c.charge,
	cpt_code = COALESCE(c.cpt_code, p.cpt_code),
	c.units,
	c.posted,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	last_updated_name = u.user_full_name,
	c.units_recovered ,
	c.charge_recovered ,
	assessment_bill_flag = 'Y',
	charge_bill_flag = c.bill_flag,
	assessment_charge_bill_flag = 'Y',
	t.sort_sequence ,
	c.sort_sequence ,
	NULL
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
	LEFT OUTER JOIN c_User u
	ON u.user_id = c.last_updated_by
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND c.bill_flag = 'Y'
AND c.encounter_charge_id NOT IN (
	SELECT DISTINCT encounter_charge_id
	FROM @charges
	WHERE encounter_charge_id IS NOT NULL )

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_encounter_charges]
	TO [cprsystem]
GO

