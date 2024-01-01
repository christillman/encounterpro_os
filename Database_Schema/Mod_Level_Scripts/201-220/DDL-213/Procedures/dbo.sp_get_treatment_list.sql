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
SET QUOTED_IDENTIFIER ON
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

