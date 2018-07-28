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

-- Drop Procedure [dbo].[jmjdoc_get_obstree_treatment]
Print 'Drop Procedure [dbo].[jmjdoc_get_obstree_treatment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_obstree_treatment]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_obstree_treatment]
GO

-- Create Procedure [dbo].[jmjdoc_get_obstree_treatment]
Print 'Create Procedure [dbo].[jmjdoc_get_obstree_treatment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_obstree_treatment
(	 @ps_cpr_id varchar(12)
	,@pl_treatment_id int
	,@ps_root_observation_id varchar(24) = NULL
	,@ps_root_observation_tag varchar(12) = NULL
	,@ps_child_observation_id varchar(24) = NULL
	,@ps_child_observation_tag varchar(12) = NULL
	,@ps_exclude_observation_tag varchar(12) = NULL
)
AS

DECLARE  @ll_iterations int
	,@ll_rowcount INT
	,@ll_more_records INT
	,@ll_level INT

SET  	@ll_iterations = 1
SET	@ll_more_records = 1
SET	@ll_level = 1001 - @ll_iterations

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
	,comment text NULL
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

SET @ps_exclude_observation_tag = ISNULL(@ps_exclude_observation_tag, '!NOEXCLUDE')

-- First, generate a list of root observations in the treatment

IF @ps_child_observation_id IS NULL AND @ps_child_observation_tag IS NULL 
BEGIN
	INSERT INTO @tmp_obstree 
	(	 record_type
		,observation_sequence
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,stage
		,stage_description
		,in_context_flag
		,display_style
		,perform_location_domain
		,parent_history_sequence
		,results_level
		,default_view
	)
	SELECT	 'Root'
		,p.observation_sequence
		,p.observation_id
		,p.description
		,c.observation_type
		,p.composite_flag
		,P.stage
		,P.stage_description
		,c.in_context_flag
		,c.display_style
		,c.perform_location_domain
		,0
		,@ll_level
		,c.default_view
	FROM 	p_Observation p WITH (NOLOCK)
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	p.observation_id = c.observation_id
	WHERE	p.cpr_id = @ps_cpr_id
	AND 	p.treatment_id = @pl_treatment_id
	AND 	(@ps_root_observation_id IS NULL OR p.observation_id = @ps_root_observation_id )
	AND 	(@ps_root_observation_tag IS NULL OR p.observation_tag = @ps_root_observation_tag )
	AND 	p.parent_observation_sequence IS NULL
END
ELSE
BEGIN
	INSERT INTO @tmp_obstree 
	(	 record_type
		,observation_sequence
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,stage
		,stage_description
		,in_context_flag
		,display_style
		,perform_location_domain
		,parent_history_sequence
		,results_level
		,default_view
	)
	SELECT	 'Root'
		,child.observation_sequence
		,child.observation_id
		,child.description
		,c.observation_type
		,child.composite_flag
		,child.stage
		,child.stage_description
		,c.in_context_flag
		,c.display_style
		,c.perform_location_domain
		,0
		,@ll_level
		,c.default_view
	FROM 	p_Observation parent WITH (NOLOCK)
	INNER JOIN p_Observation child WITH (NOLOCK)
	ON	parent.cpr_id = child.cpr_id
	AND	parent.observation_sequence = child.parent_observation_sequence
	AND	parent.treatment_id = child.treatment_id
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	child.observation_id = c.observation_id
	WHERE	parent.cpr_id = @ps_cpr_id
	AND 	parent.treatment_id = @pl_treatment_id
	AND 	child.cpr_id = @ps_cpr_id
	AND 	child.treatment_id = @pl_treatment_id
	AND 	parent.parent_observation_sequence IS NULL
	AND (@ps_root_observation_id IS NULL OR parent.observation_id = @ps_root_observation_id)
	AND (@ps_root_observation_tag IS NULL OR parent.observation_tag = @ps_root_observation_tag)
	AND (@ps_child_observation_id IS NULL OR child.observation_id = @ps_child_observation_id)
	AND (@ps_child_observation_tag IS NULL OR child.observation_tag = @ps_child_observation_tag)
END

-- Now add the children

WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1
	SET @ll_level = 1001 - @ll_iterations

	INSERT INTO @tmp_obstree 
	(	 record_type
		,observation_sequence
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,stage
		,stage_description
		,in_context_flag
		,display_style
		,perform_location_domain
		,parent_history_sequence
		,parent_observation_sequence
		,results_level
		,default_view
	)
	SELECT   'Observation'
		,p.observation_sequence
		,p.observation_id
		,p.description
		,o.observation_type
		,p.composite_flag
		,P.stage
		,P.stage_description
		,o.in_context_flag
		,o.display_style
		,o.perform_location_domain
		,x.history_sequence
		,x.observation_sequence
		,@ll_level
		,o.default_view
	FROM 	@tmp_obstree x
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON	x.observation_sequence = p.parent_observation_sequence
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON	p.observation_id = o.observation_id 
	WHERE	p.cpr_id = @ps_cpr_id
	AND 	p.treatment_id = @pl_treatment_id
	AND 	x.results_level = @ll_level + 1
	AND 	ISNULL(p.observation_tag, '!NOTAG') <> @ps_exclude_observation_tag
	ORDER BY
		 p.branch_sort_sequence
		,p.observation_sequence

	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
END

-- Now that we've got all the observations, get the results

SET @ll_iterations = @ll_iterations + 1
SET @ll_level = 1001 - @ll_iterations

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
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
)
SELECT  'Result'
	,o.history_sequence
	,o.observation_sequence
	,o.observation_id
	,o.observation_description
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
	,@ll_level
	,o.default_view
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
FROM 	@tmp_obstree o
INNER JOIN p_Observation_Result p WITH (NOLOCK)
ON	o.observation_sequence = p.observation_sequence
INNER JOIN c_Observation_Result c WITH (NOLOCK)
ON	p.observation_id = c.observation_id
AND 	p.result_sequence = c.result_sequence
INNER JOIN c_Location l WITH (NOLOCK)
ON	p.location = l.location
WHERE 	p.cpr_id = @ps_cpr_id
AND	p.current_flag = 'Y'
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
	,default_view
)
SELECT   'Comment'
	,o.history_sequence

	,o.observation_sequence
	,o.parent_observation_sequence
	,o.observation_id
	,o.observation_description
	,c.user_id as comment_user_id
	,c.comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.observation_comment_id
	,c.attachment_id
	,@ll_level
	,o.default_view
FROM 	@tmp_obstree o
INNER JOIN p_Observation_Comment c WITH (NOLOCK)
ON	o.observation_sequence = c.observation_sequence
WHERE 	c.cpr_id = @ps_cpr_id
AND 	o.record_type IN ('Observation', 'Root')
AND	c.current_flag = 'Y'

-- Now, before we return all these records, remove the observation records which don't have
-- any children at all

SET  	@ll_iterations = 1
SET	@ll_more_records = 1

WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1

	DELETE t1
	FROM @tmp_obstree t1
	LEFT OUTER JOIN @tmp_obstree t2
	ON t1.history_sequence = t2.parent_history_sequence
	WHERE 	t1.record_type = 'Observation'
	AND 	t2.parent_history_sequence IS NULL
	
	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
END

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
	,t.observed_by as orderedby_actorid
        , u.user_full_name as orderedby_actorname
	, u.first_name as orderedby_actorfirstname
	, u.last_name as orderedby_actorlastname
FROM @tmp_obstree t
LEFT OUTER JOIN c_User u
ON t.observed_by=u.user_id
ORDER BY
	 history_sequence




GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_obstree_treatment]
	TO [cprsystem]
GO

