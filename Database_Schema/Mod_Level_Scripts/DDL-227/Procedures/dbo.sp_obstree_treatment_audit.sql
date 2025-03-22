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

-- Drop Procedure [dbo].[sp_obstree_treatment_audit]
Print 'Drop Procedure [dbo].[sp_obstree_treatment_audit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_obstree_treatment_audit]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_obstree_treatment_audit]
GO

-- Create Procedure [dbo].[sp_obstree_treatment_audit]
Print 'Create Procedure [dbo].[sp_obstree_treatment_audit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE      PROCEDURE sp_obstree_treatment_audit
(	 @ps_cpr_id varchar(12)
	,@pl_treatment_id int
)
AS

DECLARE @tmp_obstree TABLE
(	 record_type varchar(12) NOT NULL
	,display_flag char(1) NULL DEFAULT ('Y')
	,history_sequence int IDENTITY (1,1) NOT NULL
	,parent_history_sequence int NOT NULL
	,observation_id varchar(24) NOT NULL
	,observation_description varchar(80) NULL
	,observation_sequence int NULL
	,observation_type varchar(24) NULL
	,composite_flag char(1) NULL
	,in_context_flag char(1) NULL
	,display_style varchar(255) NULL
	,perform_location_domain varchar(24) NULL
	,treatment_id int NULL
	,parent_observation_sequence int NULL
	,observation_comment_id int NULL
	,comment_user_id varchar(24) NULL
	,comment_title varchar(48) NULL
	,comment varchar(max) NULL
	,attachment_id int NULL
	,location_result_sequence int NULL
	,location varchar(24) NULL
	,location_description varchar(40) NULL
	,result_sequence smallint NULL
	,result_date_time datetime NULL
	,result varchar(80) NULL
	,result_value varchar(40) NULL
	,result_unit varchar(12) NULL
	,result_amount_flag char(1) NULL
	,print_result_flag char(1) NULL
	,print_result_separator varchar(8) NULL
	,abnormal_flag char(1) NULL
	,severity smallint NULL
	,result_type varchar(12) NULL
	,unit_preference varchar(24) NULL
	,display_mask varchar(40) NULL
	,sort_sequence smallint NULL
	,edit_service varchar(24) NULL
	,stage int NULL
	,stage_description varchar(32) NULL
	,results_level int NOT NULL DEFAULT (0) 
	,default_view char(1) DEFAULT ('R')
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
)


-- First, generate a root record

INSERT INTO @tmp_obstree 
(	 record_type
	,observation_sequence
	,observation_id
	,observation_description
	,parent_history_sequence
	,results_level
)
SELECT	 'Root'
	,0
	,t.observation_id
	,t.treatment_description
	,0
	,1
FROM p_Treatment_Item t WITH (NOLOCK)
WHERE	t.cpr_id = @ps_cpr_id
AND 	t.treatment_id = @pl_treatment_id


INSERT INTO @tmp_obstree 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,observation_id
	,observation_description
	,location
	,result_sequence
	,location_result_sequence
	,result_date_time
	,result
	,result_value
	,result_unit
	,abnormal_flag
	,severity
	,result_type
	,unit_preference
	,display_mask
	,sort_sequence
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,location_description
	,results_level
	,abnormal_nature
	,normal_range
	,observed_by
)
SELECT  'Result'
	,1
	,o.observation_sequence
	,o.observation_id
	,o.description
	,p.location
	,p.result_sequence
	,p.location_result_sequence
	,p.result_date_time
	,p.result
	,p.result_value
	,p.result_unit
	,p.abnormal_flag
	,p.severity
	,p.result_type
	,c.unit_preference
	,c.display_mask
	,c.sort_sequence
	,c.result_amount_flag
	,c.print_result_flag
	,c.print_result_separator
	,l.description
	,2
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
FROM 	p_Observation o
INNER JOIN p_Observation_Result p WITH (NOLOCK)
	ON	o.cpr_id = p.cpr_id
	AND o.observation_sequence = p.observation_sequence
INNER JOIN c_Observation_Result c WITH (NOLOCK)
	ON	p.observation_id = c.observation_id
	AND p.result_sequence = c.result_sequence
INNER JOIN c_Location l WITH (NOLOCK)
	ON	p.location = l.location
WHERE 	o.cpr_id = @ps_cpr_id
AND		o.treatment_id = @pl_treatment_id
AND p.result_type NOT IN ('Comment', 'Attachment')
ORDER BY
	 c.sort_sequence
	,c.result_sequence
	,p.result

-- Finally, get the comments

INSERT INTO @tmp_obstree
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_description
	,comment_user_id
	,comment_title
	,comment
	,observation_comment_id
	,attachment_id
	,results_level
)
SELECT   'Comment'
	,1
	,o.observation_sequence
	,o.parent_observation_sequence
	,o.observation_id
	,o.description
	,c.user_id as comment_user_id
	,CAST(c.comment_title AS varchar(48)) as comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.observation_comment_id
	,c.attachment_id
	,2
FROM p_Observation o
INNER JOIN p_Observation_Comment c WITH (NOLOCK)
	ON	o.cpr_id = c.cpr_id
	AND o.observation_sequence = c.observation_sequence
WHERE 	o.cpr_id = @ps_cpr_id
AND		o.treatment_id = @pl_treatment_id


SELECT   t.record_type
	,t.history_sequence
	,t.parent_history_sequence
	,t.observation_sequence
	,t.parent_observation_sequence
	,t.observation_id
	,t.observation_type
	,t.composite_flag
	,t.in_context_flag
	,t.display_style
	,t.perform_location_domain
	,t.observation_description
	,t.location
	,t.result_sequence
	,t.location_result_sequence
	,t.result_date_time
	,t.result
	,t.result_value
	,t.result_unit
	,t.abnormal_flag
	,t.severity
	,t.result_type
	,t.location_description
	,t.result_amount_flag
	,t.print_result_flag
	,t.print_result_separator
	,t.observation_comment_id
	,t.comment_user_id
	,t.comment_title
	,t.comment
	,t.attachment_id
	,t.unit_preference
	,t.display_mask
	,t.sort_sequence
	,t.edit_service
	,t.display_flag
	,t.stage
	,t.stage_description
	,t.results_level AS [level]
	,@pl_treatment_id AS treatment_id
	,t.default_view
	,t.abnormal_nature
	,t.normal_range
	,t.observed_by
FROM @tmp_obstree t
ORDER BY t.observation_sequence, t.location_result_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_obstree_treatment_audit]
	TO [cprsystem]
GO

