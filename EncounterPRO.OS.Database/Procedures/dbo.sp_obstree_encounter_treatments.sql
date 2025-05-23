﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_obstree_encounter_treatments]
Print 'Drop Procedure [dbo].[sp_obstree_encounter_treatments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_obstree_encounter_treatments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_obstree_encounter_treatments]
GO

-- Create Procedure [dbo].[sp_obstree_encounter_treatments]
Print 'Create Procedure [dbo].[sp_obstree_encounter_treatments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_obstree_encounter_treatments
(	 @ps_cpr_id varchar(12)
	,@pl_encounter_id int
)
AS

DECLARE  @ll_iterations int
	,@ll_rowcount INT
	,@ll_more_records INT
	,@ll_level INT

SET @ll_iterations = 1
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

DECLARE @ldt_encounter_date datetime

DECLARE @treatments TABLE (
	treatment_id int NOT NULL)

SELECT @ldt_encounter_date = encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

-- First, generate a list of treatment_id values for this encounter
INSERT INTO @treatments (
	treatment_id)
SELECT treatment_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND ISNULL(treatment_status, 'OPEN') <> 'CANCELLED'
AND (open_encounter_id = @pl_encounter_id
	 OR close_encounter_id = @pl_encounter_id
	 OR (begin_date <= @ldt_encounter_date AND ISNULL(end_date, CAST('1/1/3000' as datetime)) >= @ldt_encounter_date) )



-- Then, generate a list of root observations for each treatment

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
	,treatment_id
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
	,t.treatment_id
	,c.default_view
FROM 	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN @treatments t2
	ON t.treatment_id = t2.treatment_id
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON t.cpr_id = p.cpr_id
	AND t.treatment_id = p.treatment_id
INNER JOIN c_Observation c WITH (NOLOCK)
ON	p.observation_id = c.observation_id
WHERE	t.cpr_id = @ps_cpr_id
AND		p.cpr_id = @ps_cpr_id
AND 	p.parent_observation_sequence IS NULL

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
		,treatment_id
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
		,p.treatment_id
		,o.default_view
	FROM 	@tmp_obstree x
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON	x.observation_sequence = p.parent_observation_sequence
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON	p.observation_id = o.observation_id 
	WHERE	p.cpr_id = @ps_cpr_id
	AND 	x.results_level = @ll_level + 1
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
	,treatment_id
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
	,p.treatment_id
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
	,treatment_id
	,default_view
)
SELECT   'Comment'
	,o.history_sequence

	,o.observation_sequence
	,o.parent_observation_sequence
	,o.observation_id
	,o.observation_description
	,c.user_id as comment_user_id
	,CAST(c.comment_title AS varchar(48)) as comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.observation_comment_id
	,c.attachment_id
	,@ll_level
	,c.treatment_id
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
	,t.treatment_id
	,t.default_view
	,t.abnormal_nature
	,t.normal_range
	,t.observed_by
FROM @tmp_obstree t
ORDER BY
	 history_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_obstree_encounter_treatments]
	TO [cprsystem]
GO

