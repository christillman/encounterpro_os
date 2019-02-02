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
	assessment = COALESCE(pa.assessment, ad.description),
	icd10_code = COALESCE(a.icd10_code, ad.icd10_code),
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

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjdoc_get_assessment]
Print 'Drop Procedure [dbo].[jmjdoc_get_assessment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_assessment]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_assessment]
GO

-- Create Procedure [dbo].[jmjdoc_get_assessment]
Print 'Create Procedure [dbo].[jmjdoc_get_assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_assessment (
	@ps_cpr_id varchar(24),
	@ps_context_object varchar(24),
	@pl_object_key int
)

AS

/*****************************************************************************************************
	
		Patient Assessments

	Retrieve all the assessments diagnosed for this given patient instance.
*****************************************************************************************************/

IF @ps_context_object = 'Patient' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd10_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
        CASE WHEN a.assessment_status IS NULL THEN 'OPEN'
		ELSE a.assessment_status
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate
FROM	p_Assessment a
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE a.cpr_id = @pl_object_key
--AND a.current_flag = 'Y'
AND (ISNULL(assessment_status,'OPEN') <> 'CANCELLED')
END

/*****************************************************************************************************
	
		Specific Assessment

	Retrieve the assessment details for the given assessment instance only.
*****************************************************************************************************/

IF @ps_context_object = 'Assessment' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd10_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
	CASE WHEN a.assessment_status IS NULL THEN 'OPEN' 
		ELSE a.assessment_status 
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate
FROM	p_Assessment a
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.problem_id = @pl_object_key
AND current_flag = 'Y'
END

/*****************************************************************************************************
	
		Encounter Assessments

 	a) Assessments created in this encounter
	b) Assessments Closed in this encounter
	c) Assessments opened prior to this encounter but yet open or closed later to this encounter
*****************************************************************************************************/
IF @ps_context_object = 'Encounter' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd10_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
       CASE WHEN a.assessment_status IS NULL THEN 'OPEN'
                  ELSE CASE WHEN a.close_encounter_id > @pl_object_key THEN 'OPEN'
                                          ELSE a.assessment_status
                          END 
        END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate,
	 ea.assessment_sequence as EncAssSequence,
	 ea.created as EncAssCreated
FROM	p_Assessment a
	INNER JOIN p_Encounter_Assessment ea
		ON ea.cpr_id = a.cpr_id
		AND ea.encounter_id = a.open_encounter_id
		AND ea.problem_id = a.problem_id
	INNER JOIN p_Patient_Encounter e
		ON a.cpr_id = e.cpr_id
		AND (e.encounter_id = a.open_encounter_id OR e.encounter_id=a.close_encounter_id
		 OR (a.begin_date <= e.encounter_date and (a.end_date IS NULL OR a.end_date >= e.encounter_date)))
	LEFT OUTER JOIN c_User u
		ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
		ON c.assessment_id = a.assessment_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_object_key
AND (ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED' OR a.close_encounter_id > @pl_object_key)

END

/*****************************************************************************************************
	
			Treatment Assessments

	Retrieve all the assessments associated with the given treatment instance
*****************************************************************************************************/

IF @ps_context_object = 'Treatment' 
BEGIN
SELECT a.cpr_id as cprid,   
         a.open_encounter_id as openencounter,   
         a.problem_id as problemid, 
         a.diagnosis_sequence as diagnosissequence,
	 a.assessment_id as assessmentdefinitionid,
	 a.assessment_type as assessmenttype,
 	 a.assessment as description,
	 a.location as location,
	-- a.acuteness as acuteness,
	 c.icd10_code as icd9,
	 a.begin_date as begindate,
	 a.diagnosed_by as diagnosedby_actorid,
	 u.user_full_name as diagnosedby_actorname,
	 u.first_name as diagnosedby_actorfirstname,
	 u.last_name as diagnosedby_actorlastname,
	CASE WHEN a.assessment_status IS NULL THEN 'OPEN' 
		ELSE a.assessment_status 
	END as assessmentstatus,
	 a.close_encounter_id as closeencounter,
	 a.end_date as endate,
	 at.created as AsstTrtCreated
FROM	p_Assessment_Treatment at
	INNER JOIN p_Assessment a
	ON at.cpr_id = a.cpr_id
	AND at.encounter_id = a.open_encounter_id
	AND at.problem_id = a.problem_id
	LEFT OUTER JOIN c_User u
	ON a.diagnosed_by = u.user_id
	LEFT OUTER JOIN c_Assessment_Definition c
	ON c.assessment_id = a.assessment_id
WHERE at.cpr_id = @ps_cpr_id
AND at.treatment_id = @pl_object_key
--AND a.current_flag = 'Y'
AND (ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED')
ORDER BY at.created
END



GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_assessment]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjdoc_get_treatment_assessments]
Print 'Drop Procedure [dbo].[jmjdoc_get_treatment_assessments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_treatment_assessments]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_treatment_assessments]
GO

-- Create Procedure [dbo].[jmjdoc_get_treatment_assessments]
Print 'Create Procedure [dbo].[jmjdoc_get_treatment_assessments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE jmjdoc_get_treatment_assessments (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int,
	@pl_charge_id int
)

AS

-- Extract the assessments associated with a given charge record


SELECT ac.problem_id as problemid,
      COALESCE(ea.icd10_code,a.icd10_code) as icd9code
FROM p_Encounter_Assessment_Charge ac
    INNER JOIN p_Encounter_Assessment ea
  	ON ac.cpr_id = ea.cpr_id
	AND ac.encounter_id = ea.encounter_id
	AND ac.problem_id = ea.problem_id
INNER JOIN c_Assessment_Definition a
	ON ea.assessment_id = a.assessment_id
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.encounter_charge_id = @pl_charge_id
AND ac.bill_flag = 'Y'
ORDER BY ea.assessment_sequence ASC,ea.created ASC

GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_treatment_assessments]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_assessments_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_assessments_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_assessments_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_assessments_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_assessments_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_assessments_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_assessments_bydoc
	@ps_user_id varchar(24)
    ,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @user_id varchar(24)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date
Select @user_id = @ps_user_id
SELECT count(pa.assessment)AS Count, pa.assessment,ca.icd10_code AS ICD_9,
ca.risk_level as EM_Risk, ca.complexity as EM_Complexity
FROM p_assessment pa WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = pa.diagnosed_by
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
AND usr.user_id = @user_id
AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd10_code,ca.risk_level,ca.complexity 
order by Count desc,pa.assessment asc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_assessments_bydoc]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_assessments_byprc]
Print 'Drop Procedure [dbo].[jmjrpt_assessments_byprc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_assessments_byprc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_assessments_byprc]
GO

-- Create Procedure [dbo].[jmjrpt_assessments_byprc]
Print 'Create Procedure [dbo].[jmjrpt_assessments_byprc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_assessments_byprc
AS
SELECT count(pa.assessment)AS Count, pa.assessment,ca.icd10_code AS ICD_9,
ca.risk_level as EM_Risk, ca.complexity as EM_Complexity
FROM p_assessment pa WITH (NOLOCK)
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
group by pa.assessment,ca.icd10_code,ca.risk_level,ca.complexity 
order by Count desc,pa.assessment asc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_assessments_byprc]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_assessment_age]
Print 'Drop Procedure [dbo].[jmjrpt_assessment_age]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_assessment_age]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_assessment_age]
GO

-- Create Procedure [dbo].[jmjrpt_assessment_age]
Print 'Create Procedure [dbo].[jmjrpt_assessment_age]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_assessment_age
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
	,@ps_dob_begin_date varchar(10)
	,@ps_dob_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @dob_begin_date varchar(10),@dob_end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date
Select @dob_begin_date= @ps_dob_begin_date
Select @dob_end_date= @ps_dob_end_date
SELECT count(pa.assessment) AS Count,pa.assessment,ca.icd10_code  
FROM p_assessment pa WITH (NOLOCK)
INNER JOIN p_patient pp WITH (NOLOCK) ON
	pp.cpr_id = pa.cpr_id
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id 
AND Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
AND pp.date_of_birth BETWEEN @dob_begin_date AND DATEADD( day, 1, @dob_end_date)
where pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd10_code
order by Count desc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_assessment_age]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_calc_ewg]
Print 'Drop Procedure [dbo].[jmjrpt_calc_ewg]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_calc_ewg]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_calc_ewg]
GO

-- Create Procedure [dbo].[jmjrpt_calc_ewg]
Print 'Create Procedure [dbo].[jmjrpt_calc_ewg]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_calc_ewg
	@ps_cpr_id varchar(12),
    @pdt_property_date Datetime
AS
Declare @cprid varchar(12)
Declare @result_value varchar(40)
Declare @EWG varchar(40)
Declare @LMP DATETIME
Declare @result_date Datetime
Select @cprid = @ps_cpr_id
Select @result_date = @pdt_property_date

SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
FROM p_Observation, p_Observation_Result 
WHERE (SELECT COUNT(*) FROM p_Assessment 
WHERE p_Assessment.cpr_id = @cprid
AND p_Assessment.assessment_id IN  
(Select assessment_id from c_assessment_definition 
--where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80'))
where assessment_type = 'OB' and assessment_category_id = 'OB')
AND (p_Assessment.assessment_status IS NULL 
OR p_Assessment.assessment_status <> 'CLOSED') 
AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0 
AND p_Observation.cpr_id = @cprid 
AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
AND p_Observation.observation_id = 'DEMO12457'
AND p_Observation.observation_id = p_Observation_Result.observation_id 
AND p_Observation_Result.result_value IS NOT NULL 
ORDER BY p_Observation_Result.created DESC)

If ((@result_value IS NOT NULL) OR (@result_value <> ''))
 Begin
  Select @EWG = 'Ultrasound exam not current' 
  if (ISDATE(@result_value)= 1)
   Begin 
    if DATEDIFF(Week,@result_value,GETDATE()) < 4 
     Begin
      Select @LMP = DateAdd(DAY,-280,@result_value) 
      Select @EWG = Str(DateDiff(Week,@LMP,@result_date),2) + 'w' + Str((DateDiff(DAY,@LMP,@result_date) - (DateDiff(Week,@LMP,@result_date)*7)),2) + 'd'
      Select @EWG = @EWG
      END
   End
 End
ELSE
 Begin
 SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
 FROM p_Observation, p_Observation_Result 
 WHERE (SELECT COUNT(*) FROM p_Assessment 
 WHERE p_Assessment.cpr_id = @cprid
 AND p_Assessment.assessment_id IN  
 (Select assessment_id from c_assessment_definition 
 --where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80'))
 where assessment_type = 'OB' and assessment_category_id = 'OB')
 AND (p_Assessment.assessment_status IS NULL 
 OR p_Assessment.assessment_status <> 'CLOSED')
 AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0  
 AND p_Observation.cpr_id = @cprid 
 AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
 AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
 AND p_Observation.observation_id = 'DEMO12485'
 AND p_Observation.observation_id = p_Observation_Result.observation_id 
 AND p_Observation_Result.result_value IS NOT NULL 
 ORDER BY p_Observation_Result.created DESC)
 If ((@result_value IS NOT NULL) OR (@result_value <> '')) 
  Begin
   Select @EWG = 'No def LMP' 
   if isdate(@result_value) = 1
    Begin
     if DATEDIFF(Week,'result_value',GETDATE()) < 44
      Begin
       Select @LMP = DateAdd(day,280,@result_value)
       Select @EWG = Str(DateDiff(Week,@LMP,@result_date),2) + 'w' + Str((DateDiff(DAY,@LMP,@result_date) - (DateDiff(Week,@LMP,@result_date)*7)),2) + 'd'
       Select @EWG = @result_value
      END
    End
  End
 End
Select @EWG

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_calc_ewg]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_comm_disease]
Print 'Drop Procedure [dbo].[jmjrpt_comm_disease]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_comm_disease]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_comm_disease]
GO

-- Create Procedure [dbo].[jmjrpt_comm_disease]
Print 'Create Procedure [dbo].[jmjrpt_comm_disease]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_comm_disease
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @mycount integer
Declare @name varchar(52),@descrip varchar(40)
Declare @last_name varchar(30),@first_name varchar(20)
Declare @DOB datetime
Declare @billing_id varchar(24)
Declare @icd_9_code varchar(12)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date

RAISERROR ('jmjrpt_comm_disease has not been converted to ICD10', 16, -1)
Declare my_cursor Cursor Local FAST_FORWARD For
Select  ca.icd_9_code,
	ca.description,
       pat.last_name,
       pat.first_name,
       pat.billing_id,
       pat.date_of_birth
FROM p_assessment pa (NOLOCK),
     c_assessment_definition ca (NOLOCK),
     p_patient pat (NOLOCK)
Where pa.cpr_id = pat.cpr_id
AND pa.assessment_id = ca.assessment_id
	AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
	AND (ca.icd_9_code In ('071','482.2','038.41','041.5','033.0','042','501','008.43','099.0','099.41','099.5','483.1','007.4','061','065.4','064','323.4','323.5','323.6','008.0','038.42','041.4','482.82','647.1','030.8','030.9','079.81','283.11','795.71','482.84','027.0','088.81','072.2','V82.5','026.1','087.9','056','771.0','002.0','004','004.9','011','502','082.0','038.0','320.2','420.99','511.1','511.0','097.9','771.3','037','978.4','124','008.44')       
         OR ca.icd_9_code LIKE '001%'
         OR ca.icd_9_code LIKE '005%'
         OR ca.icd_9_code LIKE '006%'
         OR ca.icd_9_code LIKE '020%'
	 OR ca.icd_9_code LIKE '021%'
     OR ca.icd_9_code LIKE '022%'
 	 OR ca.icd_9_code LIKE '023%'
     OR ca.icd_9_code LIKE '032%'
	 OR ca.icd_9_code LIKE '036%'	
     OR ca.icd_9_code LIKE '045%'
	 OR ca.icd_9_code LIKE '050%'
	 OR ca.icd_9_code LIKE '052%'
     OR ca.icd_9_code LIKE '055%'
	 OR ca.icd_9_code LIKE '060%'
     OR ca.icd_9_code LIKE '065%'
     OR ca.icd_9_code LIKE '070%'
     OR ca.icd_9_code LIKE '080%'
     OR ca.icd_9_code LIKE '081%'
     OR ca.icd_9_code LIKE '082%'
	 OR ca.icd_9_code LIKE '084%'
     OR ca.icd_9_code LIKE '320%')
     AND pa.cpr_id not in (select cpr_id from p_assessment where assessment_status = 'CANCELLED')
Order by ca.description,pat.last_name,pat.first_name


Create Table #comm_disease (
            [id] [int] IDENTITY (1, 1) NOT NULL ,
            [icd_9_code] [varchar] (12) NULL , 
            [descrip] [varchar] (40) NULL, 
            [pat_name] [varchar]  (40) NULL ,
            [billing_id] [varchar] (24)  NULL ,
            [dob] [datetime] NULL 
) ON [PRIMARY]


SELECT @mycount =  (Select count(*)
FROM p_assessment pa (NOLOCK),
     c_assessment_definition ca (NOLOCK)
WHERE
	pa.assessment_id = ca.assessment_id
	AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
	AND (ca.icd_9_code In ('071','482.2','038.41','041.5','033.0','042','501','008.43','099.0','099.41','099.5','483.1','007.4','061','065.4','064','323.4','323.5','323.6','008.0','038.42','041.4','482.82','647.1','030.8','030.9','079.81','283.11','795.71','482.84','027.0','088.81','072.2','V82.5','026.1','087.9','056','771.0','002.0','004','004.9','011','502','082.0','038.0','320.2','420.99','511.1','511.0','097.9','771.3','037','978.4','124','008.44')       
    OR ca.icd_9_code LIKE '001%'
    OR ca.icd_9_code LIKE '005%'
    OR ca.icd_9_code LIKE '006%'
    OR ca.icd_9_code LIKE '020%'
	OR ca.icd_9_code LIKE '021%'
    OR ca.icd_9_code LIKE '022%'
 	OR ca.icd_9_code LIKE '023%'
    OR ca.icd_9_code LIKE '032%'
	OR ca.icd_9_code LIKE '036%'	
    OR ca.icd_9_code LIKE '045%'
	OR ca.icd_9_code LIKE '050%'
	OR ca.icd_9_code LIKE '052%'
    OR ca.icd_9_code LIKE '055%'
	OR ca.icd_9_code LIKE '060%'
    OR ca.icd_9_code LIKE '065%'
    OR ca.icd_9_code LIKE '070%'
    OR ca.icd_9_code LIKE '080%'
    OR ca.icd_9_code LIKE '081%'
    OR ca.icd_9_code LIKE '082%'
	OR ca.icd_9_code LIKE '084%'
    OR ca.icd_9_code LIKE '320%')
    AND pa.cpr_id not in (select cpr_id from p_assessment where assessment_status = 'CANCELLED'))
If @mycount > 0 
 Begin
  OPEN my_cursor
  While @mycount > 0
   Begin
    Fetch Next From my_cursor INTO
    @icd_9_code,@descrip,@last_name,@first_name,@billing_id,@DOB
    select @name = @last_name + ', ' + @first_name
    Insert into #comm_disease values (@icd_9_code,@descrip,@name,@billing_id,@DOB)
    Select @mycount = @mycount - 1
   End
  Close my_cursor 
 End

Select  icd_9_code As ICD_9,
	descrip As Description,
        pat_name As Name,
	billing_id As Billing_id,
	Convert(varchar(10),dob,101) As DOB
From  #comm_disease
DROP Table #comm_disease
DEALLOCATE my_cursor

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_comm_disease]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_dx_meds_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_dx_meds_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_dx_meds_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_dx_meds_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_dx_meds_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_dx_meds_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_dx_meds_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT pa.assessment,ca.icd10_code,count(pa.assessment)AS Count,d.common_name AS Rx
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = i.ordered_by
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
INNER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where i.treatment_type in ('MEDICATION','OFFICEMED')
AND i.ordered_by = @user_id
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd10_code,d.common_name
order by pa.assessment asc, Count desc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_dx_meds_bydoc]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_get_edd]
Print 'Drop Procedure [dbo].[jmjrpt_get_edd]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_edd]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_edd]
GO

-- Create Procedure [dbo].[jmjrpt_get_edd]
Print 'Create Procedure [dbo].[jmjrpt_get_edd]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_get_edd
	@ps_cpr_id varchar(12)
AS

Declare @cprid varchar(12)
Declare @result_value varchar(40)
Declare @EDD varchar(40)
Select @cprid = @ps_cpr_id

SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
FROM p_Observation, p_Observation_Result 
WHERE (SELECT COUNT(*) FROM p_Assessment 
WHERE p_Assessment.cpr_id = @cprid
AND p_Assessment.assessment_id IN 
(Select assessment_id from c_assessment_definition 
--where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.13','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.53','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','648.93','659.63'))
where assessment_type = 'OB' and assessment_category_id = 'OB')
AND (p_Assessment.assessment_status IS NULL 
OR p_Assessment.assessment_status <> 'CLOSED') 
AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0 
AND p_Observation.cpr_id = @cprid 
AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
AND p_Observation.observation_id = 'DEMO12457'
AND p_Observation.observation_id = p_Observation_Result.observation_id 
AND p_Observation_Result.result_value IS NOT NULL 
ORDER BY p_Observation_Result.created DESC)

If ((@result_value IS NOT NULL) OR (@result_value <> ''))
 Begin
  Select @EDD = 'Ultrasound exam not current' 
  if (ISDATE(@result_value)= 1)
   Begin 
    if DATEDIFF(Week,@result_value,GETDATE()) < 4 
     Begin
      Select @EDD = 'By ultrasound exam '+ @result_value
     END
   End
 End
ELSE
 Begin
 SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
 FROM p_Observation, p_Observation_Result 
 WHERE (SELECT COUNT(*) FROM p_Assessment 
 WHERE p_Assessment.cpr_id = @cprid
 AND p_Assessment.assessment_id IN 
 (Select assessment_id from c_assessment_definition 
 --where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.13','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.53','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','648.93','659.63'))
 where assessment_type = 'OB' and assessment_category_id = 'OB')
 AND (p_Assessment.assessment_status IS NULL 
 OR p_Assessment.assessment_status <> 'CLOSED')
 AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0  
 AND p_Observation.cpr_id = @cprid 
 AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
 AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
 AND p_Observation.observation_id = 'DEMO12485'
 AND p_Observation.observation_id = p_Observation_Result.observation_id 
 AND p_Observation_Result.result_value IS NOT NULL 
 ORDER BY p_Observation_Result.created DESC)
 If ((@result_value IS NOT NULL) OR (@result_value <> '')) 
  Begin
   Select @EDD = 'No def LMP' 
   if isdate(@result_value) = 1
    Begin
     if DATEDIFF(Week,@result_value,GETDATE()) < 44
      Begin
       Select @result_value = DateAdd(day,280,@result_value)
       Select @EDD = 'By LMP ' + @result_value
      END
    End
  End
 End
Select @EDD


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_edd]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_get_ewg]
Print 'Drop Procedure [dbo].[jmjrpt_get_ewg]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_ewg]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_ewg]
GO

-- Create Procedure [dbo].[jmjrpt_get_ewg]
Print 'Create Procedure [dbo].[jmjrpt_get_ewg]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_get_ewg
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Declare @result_value varchar(40)
Declare @EWG varchar(40)
Declare @LMP DATETIME
declare @calcday integer
declare @calcweek integer
declare @calcwkday integer
Select @cprid = @ps_cpr_id

SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
FROM p_Observation, p_Observation_Result 
WHERE (SELECT COUNT(*) FROM p_Assessment 
WHERE p_Assessment.cpr_id = @cprid
AND p_Assessment.assessment_id IN  
(Select assessment_id from c_assessment_definition 
--where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','648.93','659.63'))
where assessment_type = 'OB' and assessment_category_id = 'OB')
AND Isnull(p_Assessment.assessment_status,'Open') = 'Open'
AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0 
AND p_Observation.cpr_id = @cprid 
AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
AND p_Observation.observation_id = 'DEMO12457'
AND p_Observation.observation_id = p_Observation_Result.observation_id 
AND p_Observation_Result.result_value IS NOT NULL
AND p_Observation_Result.current_flag = 'Y' 
ORDER BY p_Observation_Result.created DESC)

If ((@result_value IS NOT NULL) OR (@result_value <> ''))
 Begin
  Select @EWG = 'Ultrasound exam not current' 
  if (ISDATE(@result_value)= 1)
   Begin 
    if DATEDIFF(Week,@result_value,GETDATE()) < 4 
     Begin
      Select @LMP = DateAdd(DAY,-280,@result_value) 
      Select @calcday = DateDiff(DAY,@LMP,GETDATE())
      Select @calcweek = @calcday / 7	
      Select @calcwkday = @calcweek * 7		
      Select @EWG = Str(@calcweek,2) + 'w' + Str(@calcday - @calcwkday) + 'd'
      Select @EWG = @EWG
      END
   End
 End
ELSE
 Begin
 SELECT @result_value = (SELECT TOP 1 p_Observation_Result.result_value 
 FROM p_Observation, p_Observation_Result 
 WHERE (SELECT COUNT(*) FROM p_Assessment 
 WHERE p_Assessment.cpr_id = @cprid
 AND p_Assessment.assessment_id IN  
 (Select assessment_id from c_assessment_definition 
 --where icd10_code IN ('V22.0','V22.1','V22.2','V23.0','V23.1','V23.2','V23.3','V23.4','V23.5','V23.7','V23.9','V23.41','V23.49','V23.81','V23.82','V23.83','V23.84','V23.89','V61.6','V61.7','630','631','632','633.0','633.1','633.2','633.8','633.9','633.10','633.11','633.20','633.21','634.0','634.1','634.2','634.3','634.5','634.6','634.7','634.8','634.9','635.1','635.2','635.3','635.4','635.5','635.6','635.7','635.8','635.9','640.0','640.8','640.9','641.00','641.20','641.30','641.80','641.90','642.00','642.10','642.20','642.30','642.40','642.50','642.60','642.70','642.90','643.00','643.10','643.20','643.80','643.90','644.00','644.10','644.20','645.10','645.11','645.13','645.20','645.21','645.23','646.00','646.10','646.20','646.30','646.40','646.50','646.60','646.70','646.80','646.90','647.00','647.10','647.20','647.30','647.40','647.50','647.60','647.80','647.90','648.00','648.10','648.20','648.30','648.40','648.50','648.60','648.70','648.80','648.90','651.01','651.03','651.11','651.13','651.23','651.33','651.41','651.43','651.53','651.60','651.63','651.83','652.00','652.10','652.20','652.30','652.40','652.50','652.60','652.60','652.80','652.90','653.00','653.10','653.20','653.30','653.40','653.50','653.60','653.70','653.80','653.90','654.00','654.10','654.20','654.30','654.40','654.50','654.60','654.70','654.80','654.90','655.00','655.10','655.20','655.30','655.40','655.50','655.60','655.70','655.80','655.90','656.00','656.10','656.20','656.30','656.40','656.50','656.60','656.80','656.90','658.00','658.10','658.20','658.30','658.40','658.80','658.90','659.5','659.80','659.63','648.93'))
 where assessment_type = 'OB' and assessment_category_id = 'OB')
 AND Isnull(p_Assessment.assessment_status,'Open') = 'Open' 
 AND DATEDIFF(Week,p_Assessment.begin_date,GETDATE()) < 44) > 0  
 AND p_Observation.cpr_id = @cprid 
 AND p_Observation.cpr_id = p_Observation_Result.cpr_id 
 AND p_Observation.observation_sequence = p_Observation_Result.observation_Sequence 
 AND p_Observation.observation_id = 'DEMO12485'
 AND p_Observation.observation_id = p_Observation_Result.observation_id 
 AND p_Observation_Result.result_value IS NOT NULL 
 AND p_Observation_Result.current_flag = 'Y'  
 ORDER BY p_Observation_Result.created DESC)
 If ((@result_value IS NOT NULL) OR (@result_value <> '')) 
  Begin
   Select @EWG = 'No def LMP' 
   if isdate(@result_value) = 1
    Begin
     if DATEDIFF(Week,@result_value,GETDATE()) < 44
      Begin
       Select @LMP = DateAdd(day,280,@result_value)
       Select @calcday = DateDiff(DAY,@LMP,GETDATE())
       Select @calcweek = @calcday / 7	
       Select @calcwkday = @calcweek * 7		
       Select @EWG = Str(@calcweek,2) + 'w' + Str(@calcday - @calcwkday) + 'd'
       Select @EWG = @result_value
      END
    End
  End
 End
Select @EWG


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_ewg]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_get_labsendout]
Print 'Drop Procedure [dbo].[jmjrpt_get_labsendout]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_labsendout]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_labsendout]
GO

-- Create Procedure [dbo].[jmjrpt_get_labsendout]
Print 'Create Procedure [dbo].[jmjrpt_get_labsendout]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE jmjrpt_get_labsendout
	@ps_cpr_id varchar(12),
        @pi_encounter_id Integer
AS
Declare @cprid varchar(12)
Declare @encounterid Integer

Select @cprid = @ps_cpr_id
Select @encounterid = @pi_encounter_id

CREATE TABLE #jmc_flow1 (treat_type varchar(24),treat_descrip varchar(80), assess varchar(80) NULL, icd9 varchar(12) NULL) ON [PRIMARY]
Declare @icd9 varchar(12), @assessment varchar(80)
Declare @assessment_id varchar(24)
Declare @treatment_type varchar(24),@treatment_description varchar(80) 
Declare @treatment_id Integer
Declare @item_id Integer
Declare @mycount Integer
Declare jmc_curse1 cursor LOCAL FAST_FORWARD for 
 SELECT p_Treatment_Item.treatment_id, 
        p_Treatment_Item.treatment_type, 
        p_Treatment_Item.treatment_description
        from p_Treatment_Item With (NOLOCK), c_Treatment_Type With (NOLOCK)
        Where p_Treatment_Item.cpr_id = @cprid 
	AND p_Treatment_Item.open_encounter_id = @encounterid 
	AND (IsNULL(p_Treatment_Item.treatment_status,'Open') = 'Open') AND 
        ((p_Treatment_Item.treatment_mode LIKE '%Send%') OR (p_Treatment_Item.treatment_mode LIKE '%Refer%') OR 
        (p_Treatment_Item.treatment_id in (select p_Treatment_Progress.treatment_id FROM p_Treatment_Progress with (NOLOCK)
            Where p_Treatment_Progress.cpr_id = @cprid and p_Treatment_Progress.encounter_id  = @encounterid
            AND (p_Treatment_Progress.progress_key like '%Referred%' or p_Treatment_Progress.progress_key like '%Specimen Sent%')))) 
        AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test' ORDER BY p_Treatment_Item.treatment_id
Declare jmc_curse2 cursor for 
 SELECT p_Treatment_Item.treatment_id, 
 	p_Treatment_Item.treatment_type, 
 	p_Treatment_Item.treatment_description 
 	from p_Treatment_Item (NOLOCK), c_Treatment_Type, c_workplan 
 	Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid 
 	AND (IsNULL(p_Treatment_Item.treatment_status,'Open') = 'Open')
 	AND ((p_Treatment_Item.treatment_mode Is NULL) OR (p_Treatment_Item.treatment_mode = '')
        OR (p_Treatment_Item.treatment_id in (select p_Treatment_Progress.treatment_id FROM p_Treatment_Progress with (NOLOCK)
            Where p_Treatment_Progress.cpr_id = @cprid and p_Treatment_Progress.treatment_id = p_Treatment_Item.treatment_id
            AND (p_Treatment_Progress.progress_key like '%Referred%' or p_Treatment_Progress.progress_key like '%Specimen Sent%'))))
 	AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type 
 	AND c_Treatment_Type.observation_type = 'Lab/Test' 
 	AND c_Treatment_Type.workplan_id = c_workplan.workplan_id 
 	AND ((c_workplan.description LIKE '%Send%') OR (c_workplan.description LIKE '%Refer%')) 
 	ORDER BY p_Treatment_Item.treatment_id

SELECT @mycount =  (Select count(p_Treatment_Item.treatment_id) From p_Treatment_Item (NOLOCK), c_Treatment_Type Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND (p_Treatment_Item.treatment_status IS NULL OR p_Treatment_Item.treatment_status <> 'CANCELLED') AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test')
If @mycount > 0
 BEGIN
 open jmc_curse1
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse1
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    ORDER BY p_assessment.begin_date desc, p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd9 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd9) 
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse1
 END
Else
 SELECT @mycount = (Select count(p_Treatment_Item.treatment_id) from p_Treatment_Item (NOLOCK), c_Treatment_Type,c_workplan Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND (p_Treatment_Item.treatment_status IS NULL OR p_Treatment_Item.treatment_status <> 'CANCELLED') AND ((p_Treatment_Item.treatment_mode Is NULL) OR (p_Treatment_Item.treatment_mode = '')) AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test' AND c_Treatment_Type.workplan_id = c_workplan.workplan_id AND ((c_workplan.description LIKE '%Send%') OR (c_workplan.description LIKE '%Refer%'))) 
 BEGIN
 open jmc_curse2
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse2
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    WHERE p_assessment.assessment_status in ('','REDIAGNOSED')
                    OR p_assessment.assessment_status is NULL
		    ORDER BY p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd9 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd9)
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse2 
 END


Declare jmc_curse3 cursor LOCAL FAST_FORWARD for 
 SELECT p_Treatment_Item.treatment_id, 
        p_Treatment_Item.treatment_type, 
        p_Treatment_Item.treatment_description
        from p_Treatment_Item With (NOLOCK), c_Treatment_Type With (NOLOCK), p_patient_wp With (NOLOCK), p_patient_wp_item With (NOLOCK)
        Where p_Treatment_Item.cpr_id = @cprid 
	AND p_Treatment_Item.open_encounter_id = @encounterid 
	AND (isnull(p_Treatment_Item.treatment_status,'Open') <> 'CANCELLED') 
        AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test'
	AND p_patient_wp.cpr_id =  p_Treatment_Item.cpr_id 
	AND p_patient_wp.encounter_id = p_Treatment_Item.open_encounter_id
	AND p_patient_wp.treatment_id = p_Treatment_Item.treatment_id
	AND p_patient_wp_item.cpr_id = p_patient_wp.cpr_id
	AND p_patient_wp_item.encounter_id = p_patient_wp.encounter_id
	AND p_patient_wp_item.patient_workplan_id = p_patient_wp.patient_workplan_id
	AND (p_patient_wp_item.ordered_service = 'REFER_TREATMENT'
		OR (p_patient_wp_item.ordered_service = 'SPECIMEN'AND p_patient_wp_item.description like '%Refer Out%'))
	ORDER BY p_Treatment_Item.treatment_id 


SELECT @mycount =  (Select count(p_Treatment_Item.treatment_id) From p_Treatment_Item (NOLOCK), c_Treatment_Type Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test' AND (isNull(p_Treatment_Item.treatment_status,'Open') <> 'CANCELLED'))
If @mycount > 0
 BEGIN
 open jmc_curse3
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse3
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    ORDER BY p_assessment.begin_date desc, p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd9 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd9) 
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse3
 END

SELECT distinct treat_type AS 'Type'
      ,treat_descrip AS 'Treatment requested'
      ,assess AS 'Assessment'
      ,icd9 AS 'ICD9'
FROM #jmc_flow1

DEALLOCATE jmc_curse1
DEALLOCATE jmc_curse2
DEALLOCATE jmc_curse3
DROP TABLE #jmc_flow1


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_labsendout]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_meds_dx_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_meds_dx_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_meds_dx_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_meds_dx_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_meds_dx_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_meds_dx_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_meds_dx_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT count(drug_id) AS Count,drug_id, pa.assessment,ca.icd10_code  
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = i.ordered_by
LEFT OUTER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
LEFT OUTER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where i.treatment_type in ('MEDICATION','OFFICEMED')
AND i.ordered_by = @user_id
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by drug_id,pa.assessment,ca.icd10_code
order by Count desc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_meds_dx_bydoc]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_openlab_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_openlab_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_openlab_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_openlab_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_openlab_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_openlab_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_openlab_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT 
	 p.billing_id
	,convert(varchar(10),i.begin_date,101) AS For_Date 	
	,i.treatment_description
	,pa.assessment
	,ca.icd10_code 
FROM	 p_Treatment_Item i WITH (NOLOCK)
INNER JOIN P_patient p WITH (NOLOCK) ON 
	p.cpr_id = i.cpr_id
INNER JOIN p_patient_encounter a WITH (NOLOCK) ON
	a.cpr_id = i.cpr_id 
AND	a.encounter_id = i.open_encounter_id
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = a.attending_doctor
INNER JOIN c_Treatment_Type t WITH (NOLOCK) ON
	i.treatment_type = t.treatment_type
LEFT OUTER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
LEFT OUTER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
WHERE
	(i.treatment_status IS NULL OR i.treatment_status NOT IN ('CLOSED','MODIFIED','CANCELLED')) 
AND 	t.observation_type = 'Lab/Test'
AND 	a.attending_doctor = @user_id
AND 	i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date) 
ORDER BY
	 i.begin_date
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_openlab_bydoc]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_encounter_charges]
Print 'Drop Procedure [dbo].[jmj_encounter_charges]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_encounter_charges]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_encounter_charges]
GO

-- Create Procedure [dbo].[jmj_encounter_charges]
Print 'Create Procedure [dbo].[jmj_encounter_charges]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_encounter_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer
	)
AS


SELECT	problem_id ,
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
	assessment_sort_sequence ,
	selected_flag = 0
FROM dbo.fn_encounter_charges(@ps_cpr_id, @pl_encounter_id)

GO
GRANT EXECUTE
	ON [dbo].[jmj_encounter_charges]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_process_ICD_Code_Change]
Print 'Drop Procedure [dbo].[jmj_process_ICD_Code_Change]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_process_ICD_Code_Change]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_process_ICD_Code_Change]
GO

-- Create Procedure [dbo].[jmj_process_ICD_Code_Change]
Print 'Create Procedure [dbo].[jmj_process_ICD_Code_Change]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_process_ICD_Code_Change
	@ps_icd10_code varchar(12),
	@ps_description varchar(80),
	@ps_from_description varchar(80) = NULL,
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_long_description text = NULL,
	@ps_operation varchar(24),
	@ps_from_icd10_code varchar(12) = NULL
AS

--
-- @ps_operation = Type of code change
--       Options are:	New			This is a brand new code
--						Revise		This is an existing code but the description has been revised
--						CodeChange	An existing code has been changed to this new code
--						Delete		This code has been discontinued
--						Replaced	This code has been replaced by more detailed codes.  This code
--									is no longer assignable directly
--
-- New and Revised codes
-- 1) Add new assessment
-- 2) If new assessment does not have a treatment list then ...
--   2a) Find all assessments with the same ICD code which have a treatment list
--   2b) If none found and ICD has 5 digits, then find all assessments with the same 1st 4 digits of the ICD code which have a treatment list
--   2c) if any assessments found in 2a or 2b, then determine which assessment was most recently used.  If none have ever been used then
--       find which assessment was most recently created.
--   2d) Copy the treatment list from the assessment found in 2c to the new assessment
--
--
-- Deleted codes
-- 1) Update all existing assessments by adding the suffix " (deleted)"
--

IF @ps_icd10_code IS NULL
	BEGIN
	RAISERROR ('icd10_code cannot be NULL',16,-1)
	RETURN -1
	END

IF @ps_description IS NULL AND @ps_operation <> 'Replaced'
	BEGIN
	RAISERROR ('Description cannot be NULL unless the operation is "Replaced"',16,-1)
	RETURN -1
	END

IF @ps_assessment_category_id IS NULL
 SET @ps_assessment_category_id = 'AANEW'

DECLARE @ls_new_assessment_id varchar(24),
	@ls_existing_assessment_id varchar(24),
	@ls_deleted_suffix varchar(32),
	@ls_replaced_suffix varchar(32),
	@ll_count int,
	@ls_assessment_type varchar(24)

DECLARE @assessments TABLE (
	assessment_id varchar(24) NOT NULL,
	treatment_count int NULL,
	last_used datetime NULL)

SET @ls_deleted_suffix = ' (Deleted)'
SET @ls_replaced_suffix = ' (Replaced - Use detailed code)'

IF @ps_operation IN ('New', 'Revise')
	BEGIN
	IF @ps_assessment_type IS NULL
		BEGIN
		IF LEFT(@ps_icd10_code, 2) = 'V2'
			SET @ls_assessment_type = 'WELL'
		ELSE
			SET @ls_assessment_type = 'SICK'
		END
	ELSE
		SET @ls_assessment_type = @ps_assessment_type
	
	-- If the description is supposed to be updated, then do it now
	IF @ps_operation = 'Revise' AND @ps_from_description IS NOT NULL
		BEGIN
		UPDATE c_Assessment_Definition
		SET description = @ps_description
		WHERE icd10_code = COALESCE(@ps_from_icd10_code, @ps_icd10_code)
		AND description = @ps_from_description
		END
		
	EXECUTE sp_new_assessment
		@ps_assessment_type = @ls_assessment_type,
		@ps_icd10_code = @ps_icd10_code,
		@ps_assessment_category_id = @ps_assessment_category_id,
		@ps_description = @ps_description,
		@ps_long_description = @ps_long_description,
		@ps_assessment_id = @ls_new_assessment_id OUTPUT

	IF @ls_new_assessment_id IS NOT NULL
		BEGIN
		SELECT @ll_count = count(*)
		FROM u_Assessment_Treat_Definition
		WHERE assessment_id = @ls_new_assessment_id
		
		IF @ll_count = 0
			BEGIN
			IF @ps_from_icd10_code IS NOT NULL
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = @ps_from_icd10_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = @ps_icd10_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0 AND LEN(@ps_icd10_code) = 6 -- 5 digits plus the decimal point
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = LEFT(@ps_icd10_code, 5)
				GROUP BY u.assessment_id
				END
				
			-- If we found any assessments, then determine the latest one used
			IF (SELECT COUNT(*) FROM @assessments) > 0
				BEGIN
				UPDATE a
				SET last_used = x.last_used
				FROM @assessments a
					INNER JOIN (SELECT assessment_id, max(created) as last_used
								FROM p_Assessment
								GROUP BY assessment_id) x
					ON a.assessment_id = x.assessment_id
				
				SELECT TOP 1 @ls_existing_assessment_id = assessment_id
				FROM @assessments
				ORDER BY last_used desc
				
				EXECUTE jmj_copy_assessment_treatment_lists
					@ps_From_assessment_id = @ls_existing_assessment_id,
					@ps_To_assessment_id = @ls_new_assessment_id,
					@ps_Action = 'Ignore' -- Don't copy if there are already treatment list items for the new assesment				
				
				END
			
			END
		END
	END

IF @ps_operation IN ('CodeChange')
	BEGIN
	IF @ps_from_icd10_code IS NOT NULL AND @ps_icd10_code IS NOT NULL
		UPDATE c_Assessment_Definition
		SET icd10_code = @ps_icd10_code
		WHERE icd10_code = @ps_from_icd10_code
		AND (description = @ps_description OR definition = @ps_description)
	END

IF @ps_operation IN ('Delete')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_deleted_suffix)) + @ls_deleted_suffix
	WHERE icd10_code = @ps_icd10_code
	AND (description = @ps_description OR definition = @ps_description)
	AND RIGHT(description, LEN(@ls_deleted_suffix)) <> @ls_deleted_suffix

	END

IF @ps_operation IN ('Replaced')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_replaced_suffix)) + @ls_replaced_suffix
	WHERE icd10_code = @ps_icd10_code
	AND RIGHT(description, LEN(@ls_replaced_suffix)) <> @ls_replaced_suffix

	END

GO
GRANT EXECUTE
	ON [dbo].[jmj_process_ICD_Code_Change]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_assessment_search]
Print 'Drop Procedure [dbo].[sp_assessment_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_search]
GO

-- Create Procedure [dbo].[sp_assessment_search]
Print 'Create Procedure [dbo].[sp_assessment_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_assessment_search (
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_icd_code varchar(24) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_assessment_type IS NULL
	SELECT @ps_assessment_type = '%'

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_assessment_category_id = '%'
	SET @ps_assessment_category_id = NULL

IF @ps_icd_code IS NULL
	SELECT @ps_icd_code = '%'

IF @ps_specialty_id IS NULL
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd10_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd10_code like @ps_icd_code OR a.icd10_code is null)
ELSE
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd10_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Common_Assessment c WITH (NOLOCK)
		ON a.assessment_id = c.assessment_id
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND c.specialty_id = @ps_specialty_id
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd10_code like @ps_icd_code OR a.icd10_code is null)

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_search]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_assessment_treatment_formulary]
Print 'Drop Procedure [dbo].[sp_assessment_treatment_formulary]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_treatment_formulary]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_treatment_formulary]
GO

-- Create Procedure [dbo].[sp_assessment_treatment_formulary]
Print 'Create Procedure [dbo].[sp_assessment_treatment_formulary]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_assessment_treatment_formulary (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24) )
AS

DECLARE @ls_icd10_code varchar(12),
	@ls_authority_id varchar(24)

SELECT @ls_icd10_code = icd10_code
FROM c_Assessment_Definition
WHERE assessment_id = @ps_assessment_id

SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_sequence = 1

SELECT DISTINCT af.treatment_type,
	af.treatment_key, 
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM c_Authority_Formulary af, 
	c_Formulary f
WHERE af.formulary_code = f.formulary_code
AND af.authority_id = @ls_authority_id
AND @ls_icd10_code LIKE (af.icd10_code + '%')

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_treatment_formulary]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_authority_treatment_formulary]
Print 'Drop Procedure [dbo].[sp_authority_treatment_formulary]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_authority_treatment_formulary]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_authority_treatment_formulary]
GO

-- Create Procedure [dbo].[sp_authority_treatment_formulary]
Print 'Create Procedure [dbo].[sp_authority_treatment_formulary]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_authority_treatment_formulary (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int ,
	@ps_authority_id varchar(24) )
AS

DECLARE @ls_treatment_key varchar(40),
		@ls_treatment_type varchar(24)

SELECT @ls_treatment_type = treatment_type,
	@ls_treatment_key = dbo.fn_treatment_key(cpr_id, treatment_id)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

DECLARE @assessments TABLE (
	icd10_code varchar(12) )

INSERT INTO @assessments (
	icd10_code )
SELECT DISTINCT ad.icd10_code
FROM p_Assessment a
	INNER JOIN p_Assessment_Treatment t
	ON a.cpr_id = t.cpr_id
	AND a.problem_id = t.problem_id
	INNER JOIN c_Assessment_Definition ad
	ON a.assessment_id = ad.assessment_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id

SELECT DISTINCT 
	pa.authority_type,
	pa.authority_id,
	pa.authority_sequence,
	af.authority_formulary_id,
	af.authority_formulary_sequence,
	af.icd10_code,
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM p_Patient_Authority pa
	INNER JOIN c_Authority_Formulary af
	ON af.authority_id = pa.authority_id
	INNER JOIN c_Formulary f
	ON af.formulary_code = f.formulary_code
WHERE pa.cpr_id = @ps_cpr_id
AND af.treatment_type = @ls_treatment_type
AND af.treatment_key = @ls_treatment_key
AND (af.icd10_code IS NULL
	OR EXISTS(
			SELECT aa.icd10_code
			FROM @assessments aa
			WHERE aa.icd10_code LIKE (af.icd10_code + '%') ) )

GO
GRANT EXECUTE
	ON [dbo].[sp_authority_treatment_formulary]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_get_assessments]
Print 'Drop Procedure [dbo].[sp_get_assessments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessments]
GO

-- Create Procedure [dbo].[sp_get_assessments]
Print 'Create Procedure [dbo].[sp_get_assessments]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 7/25/2000 8:44:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 2/16/99 12:00:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 10/26/98 2:20:31 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 10/4/98 6:28:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 9/24/98 3:05:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_assessments
(@ps_cpr_id varchar(12))
AS
SELECT p_Assessment.problem_id,
p_Assessment.diagnosis_sequence,
p_Assessment.assessment_id,
	 p_Assessment.assessment_type,
c_Assessment_Definition.assessment_category_id,
c_Assessment_Definition.description,
c_Assessment_Definition.icd10_code,
c_Assessment_Definition.auto_close,
p_Assessment.open_encounter_id,
p_Assessment.attachment_id,
p_Assessment.begin_date
FROM c_Assessment_Definition (NOLOCK),
p_Assessment (NOLOCK) WHERE	c_Assessment_Definition.assessment_id = p_Assessment.assessment_id
AND	p_Assessment.cpr_id = @ps_cpr_id
ORDER BY p_Assessment.problem_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessments]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_get_assessment_icd10]
Print 'Drop Procedure [dbo].[sp_get_assessment_icd10]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessment_icd10]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessment_icd10]
GO

-- Create Procedure [dbo].[sp_get_assessment_icd10]
Print 'Create Procedure [dbo].[sp_get_assessment_icd10]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_assessment_icd10 (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24)
	--, @ps_insurance_id varchar(24) OUTPUT,
	--@ps_icd10_code varchar(12) OUTPUT
	)
AS
DECLARE @li_authority_sequence smallint
	, @ls_insurance_id varchar(24)
	, @ls_icd10_code varchar(12)
	, @ls_asst_description varchar(80)
	
SELECT @ls_insurance_id = NULL,
	@ls_icd10_code = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
IF @li_authority_sequence IS NOT NULL
	SELECT @ls_insurance_id = i.authority_id,
		@ls_icd10_code = i.icd10_code
	FROM c_Assessment_Coding i, p_Patient_Authority pi WITH (NOLOCK)
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence
	AND i.assessment_id = @ps_assessment_id
	AND pi.authority_id = i.authority_id
IF @ls_insurance_id IS NULL
	SELECT @ls_icd10_code = icd10_code,@ls_asst_description=description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_assessment_id

SELECT @ls_insurance_id AS insurance_id, @ls_icd10_code AS icd10_code,@ls_asst_description as asst_description

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessment_icd10]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_get_treatment_list]
Print 'Drop Procedure [dbo].[sp_get_treatment_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_list]
GO

-- Create Procedure [dbo].[sp_get_treatment_list]
Print 'Create Procedure [dbo].[sp_get_treatment_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_treatment_list (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24) = NULL,
	@ps_user_id varchar(24) = NULL,
	@pl_parent_definition_id int = NULL)
AS

DECLARE @ls_assessment_id varchar(24),
		@ls_icd10_code varchar(12),
		@ls_authority_id varchar(24)


DECLARE @treatments TABLE (
		definition_id int NOT NULL,   
		assessment_id varchar(24) NOT NULL,   
		treatment_type varchar(24) NOT NULL,   
		treatment_description varchar(80) NOT NULL,   
		followup_workplan_id int NULL,
		[user_id] varchar(24) NULL,   
		sort_sequence smallint NULL,   
		instructions varchar(50) NULL,   
		parent_definition_id int NULL,   
		child_flag char(1) NULL,
		treatment_key_field varchar(64) NULL,
		treatment_key varchar(40) NULL,
		authority_formulary_sequence int NULL,
		formulary_code_icon varchar(128) NULL,
		rating [numeric](18, 0) NULL  )

IF @pl_parent_definition_id IS NULL
	BEGIN
	SET @ls_assessment_id = @ps_assessment_id
	INSERT INTO @treatments ( 
			definition_id ,
			assessment_id ,
			treatment_type , 
			treatment_description ,
			followup_workplan_id ,
			[user_id] ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag ,
			treatment_key_field )
	SELECT definition_id ,
			assessment_id ,
			treatment_type , 
			treatment_description ,
			followup_workplan_id ,
			[user_id] ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag,
			dbo.fn_treatment_type_treatment_key(treatment_type)
	FROM u_Assessment_Treat_Definition
	WHERE assessment_id = @ps_assessment_id
	AND user_id = @ps_user_id
	END
ELSE
	BEGIN
	SELECT @ls_assessment_id = assessment_id
	FROM u_Assessment_Treat_Definition
	WHERE definition_id = @pl_parent_definition_id
	
	INSERT INTO @treatments ( 
			definition_id ,
			assessment_id ,
			treatment_type , 
			treatment_description ,
			followup_workplan_id ,
			[user_id] ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag ,
			treatment_key_field )
	SELECT definition_id ,
			assessment_id ,
			treatment_type , 
			treatment_description ,
			followup_workplan_id ,
			[user_id] ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag,
			dbo.fn_treatment_type_treatment_key(treatment_type)
	FROM u_Assessment_Treat_Definition
	WHERE parent_definition_id = @pl_parent_definition_id
	END

UPDATE t
SET treatment_key = CONVERT(varchar(40), CASE t.treatment_key_field
										WHEN 'treatment_type' THEN t.treatment_type
										ELSE a.value END )
FROM @treatments t
	LEFT OUTER JOIN u_assessment_treat_def_attrib a
	ON t.definition_id = a.definition_id
WHERE a.attribute = t.treatment_key_field

UPDATE @treatments
SET treatment_key = CONVERT(varchar(40), treatment_description)
WHERE treatment_key_field = 'treatment_description'
AND treatment_key IS NULL

-- Get the icd10_code
SELECT @ls_icd10_code = icd10_code
FROM c_Assessment_Definition
WHERE assessment_id = @ls_assessment_id

-- Get the primary authority
SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_sequence = 1

-- Find the highest authority_formulary_sequence
UPDATE t1
SET authority_formulary_sequence = x.authority_formulary_sequence
FROM @treatments t1
	INNER JOIN (SELECT t.treatment_type,
						af.treatment_key,
						max(af.authority_formulary_sequence) as authority_formulary_sequence
				FROM @treatments t
					INNER JOIN c_Authority_Formulary af
					ON t.treatment_type = af.treatment_type
				WHERE @ls_icd10_code LIKE (af.icd10_code + '%')
				AND af.authority_id = @ls_authority_id
				GROUP BY t.treatment_type,
						af.treatment_key) as x
	ON t1.treatment_type = x.treatment_type
	AND t1.treatment_key = x.treatment_key
	
UPDATE t
SET formulary_code_icon = f.icon
FROM @treatments t
	INNER JOIN c_Authority_Formulary af
	ON t.treatment_type = af.treatment_type
	INNER JOIN c_Formulary f
	ON af.formulary_code = f.formulary_code
WHERE af.authority_id = @ls_authority_id
AND af.authority_formulary_sequence = t.authority_formulary_sequence

UPDATE t
SET rating = r.rating
FROM @treatments t
	INNER JOIN r_Assessment_Treatment_Efficacy r
	ON t.assessment_id = r.assessment_id
	AND t.treatment_type = r.treatment_type
	AND t.treatment_key = r.treatment_key

SELECT t.definition_id,   
         t.assessment_id,   
         t.treatment_type,   
         t.treatment_description,   
         t.user_id,   
         t.sort_sequence,   
         t.parent_definition_id,   
         t.instructions,   
         t.child_flag,   
         t.followup_workplan_id,   
         t.rating,
		 t.authority_formulary_sequence ,
		 t.formulary_code_icon ,
         t.treatment_key,
         tt.description as treatment_type_description,   
         tt.in_office_flag,
         tt.followup_flag,
         tt.button,   
         tt.icon,   
         tt.sort_sequence as treatment_type_sort_sequence,   
         onset = convert(datetime,null),   
         duration = convert(datetime,null),   
         selected_flag = 0,   
         update_flag = 0,   
         open_encounter_id = convert(int, null)
FROM @treatments t 
    LEFT OUTER JOIN c_Treatment_Type tt
    ON t.treatment_type = tt.treatment_type  


GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_list]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_new_assessment]
Print 'Drop Procedure [dbo].[sp_new_assessment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_assessment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_assessment]
GO

-- Create Procedure [dbo].[sp_new_assessment]
Print 'Create Procedure [dbo].[sp_new_assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_assessment (
	@ps_assessment_type varchar(24),
	@ps_icd10_code varchar(12) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_location_domain varchar(12) = NULL,
	@ps_auto_close char(1) = 'N',
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text = NULL ,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL,
	@ps_assessment_id varchar(24) OUTPUT,
	@ps_allow_dup_icd10_code char(1) = 'Y' )
AS

DECLARE @ll_key_value integer ,
	@ls_assessment_id varchar(24) ,
	@ls_old_status varchar(12) ,
	@ll_rows int,
	@ll_count int,
	@ls_trimmed_description varchar(80),
	@ls_key varchar(20),
	@ll_key_suffix int,
	@ls_long_description_varchar varchar(4000)

IF @ps_description IS NULL OR @ps_description = ''
	BEGIN
	RAISERROR ('New assessment must have a description',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_allow_dup_icd10_code IS NULL
	SET @ps_allow_dup_icd10_code = 'Y'

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

SET @ls_long_description_varchar = CAST(@ps_long_description AS varchar(4000))

SELECT TOP 1 @ps_assessment_id = assessment_id,
			@ls_old_status = status
FROM c_Assessment_Definition
WHERE assessment_type = @ps_assessment_type
AND description = @ps_description
AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
AND ISNULL(CAST(long_description AS varchar(4000)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
ORDER BY status desc, last_updated desc

SET @ll_rows = @@ROWCOUNT

-- We didn't find an exact match so see if there's a unique match on icd10_code
IF @ll_rows = 0 AND @ps_icd10_code IS NOT NULL AND @ps_allow_dup_icd10_code <> 'Y'
	BEGIN
	SELECT @ll_count = COUNT(*)
	FROM c_Assessment_Definition
	WHERE icd10_code = @ps_icd10_code
	AND status = 'OK'

	IF @ll_count = 1
		BEGIN
		SELECT TOP 1 @ps_assessment_id = assessment_id,
					@ls_old_status = status
		FROM c_Assessment_Definition
		WHERE icd10_code = @ps_icd10_code
		AND status = 'OK'

		SET @ll_rows = @@ROWCOUNT
		END

	END

-- We didn't find a match yet so see if there's match with commas and spaces removed
IF @ll_rows = 0
	BEGIN
	SET @ls_trimmed_description = REPLACE(@ps_description, ',', '')
	SET @ls_trimmed_description = REPLACE(@ls_trimmed_description, ' ', '')

	SELECT TOP 1 @ps_assessment_id = assessment_id,
				@ls_old_status = status
	FROM c_Assessment_Definition
	WHERE REPLACE(REPLACE(description, ',', ''), ' ', '') = @ls_trimmed_description
	AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
	AND ISNULL(CAST(long_description AS varchar(4000)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
	ORDER BY status desc, last_updated desc

	SET @ll_rows = @@ROWCOUNT

	END

IF @ll_rows = 1
	BEGIN
	IF @ls_old_status <> 'OK' AND @ps_status = 'OK'
		UPDATE c_Assessment_Definition
		SET status = @ps_status
		WHERE assessment_id = @ps_assessment_id
	END
ELSE
	BEGIN
	SET @ls_key = CAST(@pl_owner_id AS varchar(12)) + '^'
	
	IF LEN(@ps_icd10_code) >= 3
		SET @ls_key = @ls_key + @ps_icd10_code
	ELSE
		SET @ls_key = @ls_key + CAST(@ps_description AS varchar(12))
	
	SET @ls_key = @ls_key + '^'
	
	SET @ll_key_suffix = 0
	WHILE exists(select 1 from c_Assessment_Definition where assessment_id = @ls_key + CAST(@ll_key_suffix AS varchar(6)))
		SET @ll_key_suffix = @ll_key_suffix + 1

	SET @ls_assessment_id = @ls_key + CAST(@ll_key_suffix AS varchar(6))

	INSERT INTO c_Assessment_Definition (
		assessment_id,
		assessment_type,
		icd10_code,
		assessment_category_id,
		description,
		location_domain,
		auto_close,
		auto_close_interval_amount,
		auto_close_interval_unit,
		risk_level,
		complexity,
		owner_id,
		status,
		definition )
	VALUES (
		@ls_assessment_id,
		@ps_assessment_type,
		@ps_icd10_code,
		@ps_assessment_category_id,
		@ps_description,
		@ps_location_domain,
		@ps_auto_close,
		@pi_auto_close_interval_amount,
		@ps_auto_close_interval_unit,
		@pl_risk_level,
		@pl_complexity,
		@pl_owner_id,
		@ps_status,
		@ps_description)

	IF @ps_long_description IS NOT NULL
		UPDATE c_Assessment_Definition
		SET long_description = @ps_long_description
		WHERE assessment_id = @ls_assessment_id

	SET @ps_assessment_id = @ls_assessment_id
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_new_assessment]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_new_assessment_definition]
Print 'Drop Procedure [dbo].[sp_new_assessment_definition]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_assessment_definition]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_assessment_definition]
GO

-- Create Procedure [dbo].[sp_new_assessment_definition]
Print 'Create Procedure [dbo].[sp_new_assessment_definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_assessment_definition (
	--@ps_assessment_id varchar(24) OUTPUT,
	@ps_assessment_type varchar(24),
	@ps_icd10_code varchar(12),
	@ps_assessment_category_id varchar(24),
	@ps_description varchar(80),
	@ps_location_domain varchar(12) = NULL,
	@ps_auto_close char(1),
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text = NULL )
AS

DECLARE @ll_key_value integer
	, @ls_assessment_id varchar(24)

EXECUTE sp_new_assessment
	@ps_assessment_type = @ps_assessment_type,
	@ps_icd10_code = @ps_icd10_code,
	@ps_assessment_category_id = @ps_assessment_category_id,
	@ps_description = @ps_description,
	@ps_location_domain = @ps_location_domain,
	@ps_auto_close = @ps_auto_close,
	@pi_auto_close_interval_amount = @pi_auto_close_interval_amount,
	@ps_auto_close_interval_unit = @ps_auto_close_interval_unit,
	@pl_risk_level = @pl_risk_level,
	@pl_complexity = @pl_complexity,
	@ps_long_description = @ps_long_description,
	@ps_assessment_id = @ls_assessment_id OUTPUT


SELECT @ls_assessment_id AS assessment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_new_assessment_definition]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_set_assessment_billing]
Print 'Drop Procedure [dbo].[sp_set_assessment_billing]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_assessment_billing]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_assessment_billing]
GO

-- Create Procedure [dbo].[sp_set_assessment_billing]
Print 'Create Procedure [dbo].[sp_set_assessment_billing]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_assessment_billing (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_problem_id integer,
	@ps_assessment_id varchar(24) = NULL,
	@ps_bill_flag char(1) = NULL,
	@ps_created_by varchar(24),
	@ps_exclusive_link char(1) = 'N' )
AS

-- @ps_bill_flag = 'Y' = Bill the assessment in this encounter
--                 'N' = Don't bill the assessment in this encounter
--                 'X' = Don't change the billing if p_Encounter_Assessment record
--                       already exists.  Don't bill the assessment if
--                       p_Encounter_Assessment record doesn't already exist.
--                Null = Don't change the billing if p_Encounter_Assessment record
--                       already exists.  Use c_Assessment_Type.default_bill_flag if
--                       p_Encounter_Assessment record doesn't already exist.


DECLARE @ls_bill_flag char(1),
	@ls_default_bill_flag char(1),
	@ls_assessment_id varchar(24),
	@li_diagnosis_sequence smallint,
	@ls_icd10_code varchar(12),
	@ll_encounter_charge_id int,
	@ls_assessment_type varchar(24),
	@ll_record_added int

-- Initialize record added flag
SET @ll_record_added = 0

-- If there is no encounter_id, then we have nothing to do here
IF @pl_encounter_id IS NULL
	RETURN

IF @pl_problem_id IS NULL
	BEGIN
	-- If the problem_id isn't supplied then this assessment-billing record isn't
	-- associated with an actual assessment.  We will generate a negative problem_id so that
	-- the joins through p_Encounter_Assessment_Charge will work and to be backward compatible
	
	IF @ps_assessment_id IS NULL
		RETURN
	
	SET @ls_assessment_id = @ps_assessment_id
	SET @li_diagnosis_sequence = NULL
	
	SELECT @ls_icd10_code = a.icd10_code,
			@ls_default_bill_flag = t.default_bill_flag,
			@ls_assessment_type = a.assessment_type
	FROM c_Assessment_Definition a
		INNER JOIN c_Assessment_Type t
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_id = @ps_assessment_id
	
	IF @@ROWCOUNT = 0
		BEGIN
		RAISERROR ('Cannot find assessment_id (%s)',16,-1, @ps_assessment_id)
		RETURN
		END
	
	-- See if this assessment_id is already billed
	SELECT @pl_problem_id = problem_id
	FROM p_Encounter_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND assessment_id = @ps_assessment_id
	
	IF @@ROWCOUNT = 0
		BEGIN
		SELECT @pl_problem_id = min(problem_id) - 1
		FROM p_Encounter_Assessment
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND problem_id < 0
		
		IF @pl_problem_id IS NULL
			SET @pl_problem_id = -1
		END
	
	
	END
ELSE
	BEGIN
	-- If we were passed in a problem_id, then look it up and get some info about it
	SELECT @ls_icd10_code = a.icd10_code,
			@li_diagnosis_sequence = p.diagnosis_sequence,
			@ls_assessment_id = p.assessment_id,
			@ls_default_bill_flag = t.default_bill_flag,
			@ls_assessment_type = a.assessment_type
	FROM p_Assessment p
		INNER JOIN c_Assessment_Definition a
		ON p.assessment_id = a.assessment_id
		INNER JOIN c_Assessment_Type t
		ON p.assessment_type = t.assessment_type
	WHERE p.cpr_id = @ps_cpr_id
	AND p.problem_id = @pl_problem_id
	AND p.current_flag = 'Y'

	IF @@ROWCOUNT = 0
		RETURN
	END


-- If there is no icd10_code, then don't bill the assessment
IF @ls_icd10_code IS NULL
	SELECT @ps_bill_flag = 'N'

-- Find out if there's a record already, and if so, what is the current bill_flag
SELECT @ls_bill_flag = bill_flag
FROM p_Encounter_Assessment
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND problem_id = @pl_problem_id

IF @@ROWCOUNT = 0
	BEGIN
	-- If the billing record doesn't exist and the bill_flag was not provided
	-- then use the default
	if @ps_bill_flag IS NULL
		SET @ps_bill_flag = @ls_default_bill_flag

	if @ps_bill_flag = 'X'
		SET @ps_bill_flag = 'N'
		
	INSERT INTO p_Encounter_Assessment (
		cpr_id,
		encounter_id,
		problem_id,
		assessment_id,
		bill_flag,
		created_by,
		exclusive_link )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@pl_problem_id,
		@ls_assessment_id,
		@ps_bill_flag,
		@ps_created_by,
		@ps_exclusive_link )

	-- Indicate to later logic that this operation resulted in a new assessment billing record
	SET @ll_record_added = 0
	END
ELSE
	BEGIN
	-- If the billing record already exists then use the bill flag from it if none was provided
	IF @ps_bill_flag IS NULL OR @ps_bill_flag = 'X'
		SET @ps_bill_flag = @ls_bill_flag
	
	UPDATE p_Encounter_Assessment
	SET	bill_flag = @ps_bill_flag,
		assessment_id = @ls_assessment_id
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND problem_id = @pl_problem_id
	END

-- Billing Algorithm 13-b
-- If assessment is billed and the assessment_type is WELL and there are charges 
-- associated with other assessment-billing records where the well_encounter_flag = Y 
-- and not associated with any assessment-billing records where the assessment_type = WELL, 
-- then associate such charges with this new assessment-billing record.
IF @ps_bill_flag = 'Y' AND @pl_problem_id > 0 AND @ls_assessment_type = 'WELL'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by )
	SELECT DISTINCT c.cpr_id,
		c.encounter_id,
		@pl_problem_id,
		c.encounter_charge_id,
		c.bill_flag,
		@ps_created_by
	FROM p_Encounter_Charge c
		INNER JOIN p_Encounter_Assessment_Charge ac1
		ON c.cpr_id = ac1.cpr_id
		AND c.encounter_id = ac1.encounter_id
		AND c.encounter_charge_id = ac1.encounter_charge_id
		INNER JOIN p_Encounter_Assessment pa
		ON pa.cpr_id = ac1.cpr_id
		AND pa.encounter_id = ac1.encounter_id
		AND pa.problem_id = ac1.problem_id
		INNER JOIN c_Assessment_Definition ad
		ON pa.assessment_id = ad.assessment_id
		INNER JOIN c_Assessment_Type at
		ON ad.assessment_type = at.assessment_type
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.bill_flag = 'Y'
	AND at.well_encounter_flag = 'Y'
	AND at.assessment_type <> 'WELL'
	AND pa.problem_id <> @pl_problem_id
	AND pa.bill_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac2
			INNER JOIN p_Encounter_Assessment pa2
			ON pa2.cpr_id = ac2.cpr_id
			AND pa2.encounter_id = ac2.encounter_id
			AND pa2.problem_id = ac2.problem_id
			INNER JOIN c_Assessment_Definition ad2
			ON pa2.assessment_id = ad2.assessment_id
		WHERE c.cpr_id = ac2.cpr_id
		AND c.encounter_id = ac2.encounter_id
		AND c.encounter_charge_id = ac2.encounter_charge_id
		AND ad2.assessment_type = 'WELL'
		AND pa2.bill_flag = 'Y'
		)
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac
		WHERE ac.cpr_id = c.cpr_id
		AND ac.encounter_id = c.encounter_id
		AND ac.problem_id = @pl_problem_id
		AND ac.encounter_charge_id = c.encounter_charge_id)

-- Billing Algorithm 13-c
-- If assessment is billed and there are billed charges not associated with 
-- an assessment-billing record, then associate them with this assessment-billing record.
IF @ps_bill_flag = 'Y' AND @pl_problem_id > 0
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by )
	SELECT DISTINCT @ps_cpr_id,
		@pl_encounter_id,
		@pl_problem_id,
		c.encounter_charge_id,
		c.bill_flag,
		@ps_created_by
	FROM p_Encounter_Charge c
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.bill_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge ac
		WHERE ac.cpr_id = @ps_cpr_id
		AND ac.encounter_id = @pl_encounter_id
		AND ac.encounter_charge_id = c.encounter_charge_id)

IF @ll_record_added = 1
	BEGIN
	-- Billing Algorithm 13-d
	-- If there are any non-treatment charges where the procedure_type is Primary or Secondary, 
	-- then disassociate each such charge from all assessment-billing records and apply the logic
	-- in Rule 12 to re-associate each such charge
	DECLARE lc_non_treatment_charges CURSOR LOCAL FAST_FORWARD FOR
		SELECT encounter_charge_id
		FROM p_Encounter_Charge
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND treatment_id IS NULL
		AND bill_flag = 'Y'

	OPEN lc_non_treatment_charges

	FETCH lc_non_treatment_charges INTO @ll_encounter_charge_id

	WHILE @@FETCH_STATUS = 0
		BEGIN
		EXECUTE jmj_link_non_treatment_charge
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_encounter_charge_id = @ll_encounter_charge_id,
			@ps_created_by = @ps_created_by
		
		FETCH lc_non_treatment_charges INTO @ll_encounter_charge_id
		END

	CLOSE lc_non_treatment_charges
	DEALLOCATE lc_non_treatment_charges

	END
	

GO
GRANT EXECUTE
	ON [dbo].[sp_set_assessment_billing]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[sp_update_assessment_def]
Print 'Drop Procedure [dbo].[sp_update_assessment_def]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_assessment_def]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_update_assessment_def]
GO

-- Create Procedure [dbo].[sp_update_assessment_def]
Print 'Create Procedure [dbo].[sp_update_assessment_def]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_update_assessment_def (
	@ps_assessment_id varchar(24),
	@ps_icd10_code varchar(12),
	@ps_assessment_category_id varchar(24),
	@ps_description varchar(80),
	@ps_location_domain varchar(12),
	@ps_auto_close char(1),
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text )
AS

UPDATE c_Assessment_Definition
SET	icd10_code = @ps_icd10_code,
	description = @ps_description,
	assessment_category_id = @ps_assessment_category_id,
	location_domain = @ps_location_domain,
	auto_close = @ps_auto_close,
	auto_close_interval_amount = COALESCE(@pi_auto_close_interval_amount, auto_close_interval_amount),
	auto_close_interval_unit = COALESCE(@ps_auto_close_interval_unit, auto_close_interval_unit),
	risk_level = COALESCE(@pl_risk_level, risk_level),
	complexity = COALESCE(@pl_complexity, complexity),
	long_description = @ps_long_description
WHERE assessment_id = @ps_assessment_id

UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_assessment_id
AND top_20_code like 'ASS%'


GO
GRANT EXECUTE
	ON [dbo].[sp_update_assessment_def]
	TO [cprsystem]
GO

﻿--EncounterPRO Open Source Project
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

-- Drop Trigger [dbo].[tr_o_Service_insert]
Print 'Drop Trigger [dbo].[tr_o_Service_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_Service_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_Service_insert]
GO

-- Create Trigger [dbo].[tr_o_Service_insert]
Print 'Create Trigger [dbo].[tr_o_Service_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_Service_insert ON dbo.o_Service
FOR INSERT
AS

UPDATE s
SET owner_id = ds.customer_id,
	definition = COALESCE(i.definition, i.description)
FROM o_Service s
	INNER JOIN inserted i
	ON s.service = i.service
	CROSS JOIN c_Database_Status ds
WHERE i.owner_id = -1


-- Set the default context object if it hasn't been set yet

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
AND s.patient_flag = 'Y'
AND (s.encounter_flag = 'Y'
	OR s.assessment_flag = 'Y'
	OR s.treatment_flag = 'Y'
	OR s.observation_flag = 'Y'
	OR s.attachment_flag = 'Y')

UPDATE s
SET default_context_object = 'Attachment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.attachment_flag = 'Y'

UPDATE s
SET default_context_object = 'Observation'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.observation_flag = 'Y'

UPDATE s
SET default_context_object = 'Treatment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.treatment_flag = 'Y'

UPDATE s
SET default_context_object = 'Assessment'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.assessment_flag = 'Y'

UPDATE s
SET default_context_object = 'Encounter'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.encounter_flag = 'Y'

UPDATE s
SET default_context_object = 'Patient'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL
AND s.Patient_flag = 'Y'

UPDATE s
SET default_context_object = 'General'
FROM o_Service s
	INNER JOIN inserted i
	ON i.service = s.service
WHERE s.default_context_object IS NULL


GO

