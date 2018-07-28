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

-- Drop Procedure [dbo].[jmj_treatment_list]
Print 'Drop Procedure [dbo].[jmj_treatment_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_treatment_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_treatment_list]
GO

-- Create Procedure [dbo].[jmj_treatment_list]
Print 'Create Procedure [dbo].[jmj_treatment_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_treatment_list (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24),
	@ps_user_id varchar(24),
	@pl_care_plan_id int = 0)
AS

DECLARE @treatmentlist TABLE (
		definition_id int NOT NULL,   
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NOT NULL,
		treatment_mode varchar(24) NULL,
		treatment_sort_sequence int NULL,
		parent_definition_id int NULL,   
		instructions varchar(50) NULL,
		child_flag char(1) NULL,   
		followup_workplan_id int NULL,   
		treatment_type_description varchar(80) NULL,
		in_office_flag char(1) NULL,
		button varchar(64) NULL,
		icon varchar(64) NULL,
		efficacy_rating int NULL,
		contraindication_icon_1 varchar(64) NULL,
		contraindication_icon_2 varchar(64) NULL,
		contraindication_icon_3 varchar(64) NULL,
		contraindication_icon_4 varchar(64) NULL,
		contraindication_icon_5 varchar(64) NULL,
		treatment_type_sort_sequence int NULL,
		selected_flag int NOT NULL DEFAULT(0),
		sort_parent_definition_id int NULL,
		sort_parent_sort_sequence int NULL,
		followup_flag char(1) NOT NULL,
		contraindication_index int IDENTITY(1,1) NOT NULL,
		new_treatment_index int NULL)

INSERT INTO @treatmentlist (
		definition_id,   
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_mode,
		treatment_sort_sequence,
		parent_definition_id,   
		instructions,   
		child_flag,   
		followup_workplan_id,   
		treatment_type_description,
		in_office_flag,
		button,
		icon,
		efficacy_rating,
		treatment_type_sort_sequence,
		followup_flag,
		sort_parent_definition_id,
		sort_parent_sort_sequence)
SELECT	d.definition_id,   
		d.treatment_type,
		d.treatment_key,
		d.treatment_description,
		d.treatment_mode,
		d.sort_sequence,
		d.parent_definition_id,   
		d.instructions,   
		d.child_flag,   
		d.followup_workplan_id,   
		t.description as treatment_type_description,
		t.in_office_flag,
		t.button,
		CASE d.treatment_type WHEN '!COMPOSITE' THEN 'iconcomposite.bmp' ELSE t.icon END,
		CAST(e.rating AS int) AS efficacy_rating,
		t.sort_sequence as treatment_type_sort_sequence,
		COALESCE(t.followup_flag, 'N'),
		COALESCE(parent_definition_id, definition_id),
		d.sort_sequence
FROM u_assessment_treat_definition d
	LEFT OUTER JOIN c_Treatment_Type t
	ON d.treatment_type = t.treatment_type
	LEFT OUTER JOIN r_Assessment_Treatment_Efficacy e
	ON d.assessment_id = e.assessment_id
	AND d.treatment_type = e.treatment_type
	AND d.treatment_key = e.treatment_key
WHERE d.user_id = @ps_user_id
AND d.assessment_id = @ps_assessment_id
AND d.treatment_description IS NOT NULL

UPDATE c
SET sort_parent_sort_sequence = p.treatment_sort_sequence
FROM @treatmentlist c
	INNER JOIN @treatmentlist p
	ON c.parent_definition_id = p.definition_id

SELECT	definition_id,   
		treatment_type,
		treatment_key,
		treatment_description,
		treatment_sort_sequence,
		parent_definition_id,   
		instructions,   
		child_flag,   
		followup_workplan_id,   
		treatment_type_description,
		in_office_flag,
		button,
		icon,
		efficacy_rating,
		contraindication_icon_1,
		contraindication_icon_2,
		contraindication_icon_3,
		contraindication_icon_4,
		contraindication_icon_5,
		treatment_type_sort_sequence,
		selected_flag,
		sort_parent_definition_id,
		sort_parent_sort_sequence,
		followup_flag,
		contraindication_index,
		new_treatment_index,
		treatment_mode
FROM @treatmentlist



GO
GRANT EXECUTE
	ON [dbo].[jmj_treatment_list]
	TO [cprsystem]
GO

