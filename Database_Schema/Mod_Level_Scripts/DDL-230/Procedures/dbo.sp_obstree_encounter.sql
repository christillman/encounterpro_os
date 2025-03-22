
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_obstree_encounter]
Print 'Drop Procedure [dbo].[sp_obstree_encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_obstree_encounter]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_obstree_encounter]
GO

-- Create Procedure [dbo].[sp_obstree_encounter]
Print 'Create Procedure [dbo].[sp_obstree_encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_obstree_encounter
(	 @ps_cpr_id varchar(12)
	,@pl_encounter_id int
	,@ps_treatment_type varchar(24) = NULL
	,@ps_observation_type varchar(24) = NULL
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
	,result_sequence smallint NULL
	,result_date_time datetime NULL
	,result varchar(80) NULL
	,result_value varchar(40) NULL
	,result_unit varchar(12) NULL
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
	,observation_id_original VARCHAR (24) 
	,default_view char(1) DEFAULT ('R')
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
)

IF @ps_treatment_type IS NULL
BEGIN
	-- Add the root records for each observation_type
	INSERT INTO @tmp_obstree 
	(	 record_type
		,display_flag
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,in_context_flag
		,perform_location_domain
		,parent_history_sequence
		,sort_sequence
		,results_level
		,observation_id_original
	)
	SELECT   'Root'
		,display_flag
		,observation_type
		,observation_type
		,observation_type
		,'Y'
		,'N'
		,'NA'
		,0
		,sort_sequence
		,@ll_level
		,observation_type
	FROM 	c_Observation_Type WITH (NOLOCK)
	WHERE 
		observation_type = COALESCE(@ps_observation_type, observation_type)

	-- Get the first level observation records
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
		,observation_id_original
		,default_view
	)
	SELECT   'Observation'
		,a.observation_sequence
		,a.observation_id
		,a.description
		,c.observation_type
		,a.composite_flag
		,a.stage
		,a.stage_description
		,c.in_context_flag
		,c.display_style
		,c.perform_location_domain
		,x.history_sequence
		,@ll_level
		,x.observation_id_original
		,c.default_view
	FROM	@tmp_obstree x
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	x.observation_type = c.observation_type
	INNER JOIN p_Observation a WITH (NOLOCK)
	ON	c.observation_id = a.observation_id
	LEFT OUTER JOIN p_Treatment_Item t
	ON a.cpr_id = t.cpr_id
	AND a.treatment_id = t.treatment_id
	WHERE	a.cpr_id = @ps_cpr_id
	AND 	a.encounter_id = @pl_encounter_id
	AND 	a.parent_observation_sequence IS NULL
	AND 	x.record_type = 'Root'
	AND		ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'

	-- Add the first results_level descendents of composite root records
	-- where the observation_type differs from the root and the
	-- in_context_flag = 'N'
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
		,observation_id_original
		,default_view
	)
	SELECT   'Observation'
		,b.observation_sequence
		,b.observation_id
		,b.description
		,d.observation_type
		,b.composite_flag
		,b.stage
		,b.stage_description
		,d.in_context_flag
		,d.display_style
		,d.perform_location_domain
		,x.history_sequence
		,@ll_level
		,x.observation_id_original
		,c.default_view
	FROM	p_Observation a WITH (NOLOCK)
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	a.observation_id = c.observation_id
	INNER JOIN p_Observation b WITH (NOLOCK)
	ON 	a.cpr_id = b.cpr_id
	AND	a.encounter_id = b.encounter_id
	AND 	a.treatment_id = b.treatment_id
	AND 	a.observation_sequence = b.parent_observation_sequence
	LEFT OUTER JOIN p_Treatment_Item t
	ON b.cpr_id = t.cpr_id
	AND b.treatment_id = t.treatment_id
	INNER JOIN c_Observation d WITH (NOLOCK)
	ON	b.observation_id = d.observation_id
	AND	c.observation_type <> d.observation_type 
	INNER JOIN @tmp_obstree x
	ON 	d.observation_type = x.observation_type
	WHERE 	a.cpr_id = @ps_cpr_id
	AND 	a.encounter_id = @pl_encounter_id
	AND 	b.cpr_id = @ps_cpr_id
	AND 	b.encounter_id = @pl_encounter_id
	AND 	a.parent_observation_sequence IS NULL
	AND 	a.composite_flag = 'Y'
	AND 	d.in_context_flag = 'N'
	AND 	x.record_type = 'Root'
	AND		ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
END
ELSE
BEGIN
	-- Add a root record for each treatment of the specified treatment_type
	INSERT INTO @tmp_obstree 
	(	 record_type
		,treatment_id
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
		,observation_id_original
		,default_view
	)
	SELECT   'Root'
		,a.treatment_id 
		,a.observation_sequence
		,a.observation_id
		,a.description
		,c.observation_type
		,a.composite_flag
		,a.stage
		,a.stage_description
		,c.in_context_flag
		,c.display_style
		,c.perform_location_domain
		,0
		,@ll_level
		,a.observation_id
		,c.default_view
	FROM 	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN p_Observation a WITH (NOLOCK)
	ON	t.cpr_id = a.cpr_id
	AND	t.open_encounter_id = a.encounter_id
	AND 	t.treatment_id = a.treatment_id
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	a.observation_id = c.observation_id
	WHERE 
		t.cpr_id = @ps_cpr_id
	AND 	t.open_encounter_id = @pl_encounter_id
	AND	a.encounter_id = @pl_encounter_id
	AND 	t.treatment_type = @ps_treatment_type
	AND NOT (t.treatment_status = 'CANCELLED')
	AND 	a.cpr_id = @ps_cpr_id
	AND 	a.parent_observation_sequence IS NULL
END

-- Now add the children of all the records already in the temp table

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
		,observation_id_original
		,default_view
	)
	SELECT   'Observation'
		,p.observation_sequence
		,p.observation_id
		,p.description
		,o.observation_type
		,p.composite_flag
		,p.stage
		,p.stage_description
		,o.in_context_flag
		,o.display_style
		,o.perform_location_domain
		,x.history_sequence
		,x.observation_sequence
		,@ll_level
		,x.observation_id_original
		,o.default_view
	FROM 	@tmp_obstree x
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON 	p.parent_observation_sequence = x.observation_sequence
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON 	p.observation_id = o.observation_id
	WHERE 
		(		x.parent_observation_sequence IS NOT NULL
			OR 	o.observation_type = x.observation_type
		)
	AND 	x.results_level = @ll_leveL + 1
	
	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
END


-- Now that we've got all the observations, get the results

SET @ll_level = @ll_level -1

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
	,results_level
	,observation_id_original
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
)
SELECT   'Result'
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
	,@ll_level
	,o.observation_id_original
	,o.default_view
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
FROM 	 @tmp_obstree o
INNER JOIN p_Observation_Result p WITH (NOLOCK)
ON	o.observation_sequence = p.observation_sequence
INNER JOIN c_Observation_Result c WITH (NOLOCK)
ON	p.observation_id = c.observation_id
AND 	p.result_sequence = c.result_sequence
WHERE
	p.cpr_id = @ps_cpr_id
AND	p.current_flag = 'Y'
AND p.result_type NOT IN ('Comment', 'Attachment')

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
	,observation_id_original
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
	,o.observation_id_original
	,o.default_view
FROM	@tmp_obstree o
INNER JOIN p_Observation_Comment c WITH (NOLOCK)
ON	o.observation_sequence = c.observation_sequence
WHERE
	c.cpr_id = @ps_cpr_id
AND 	o.record_type IN ('Observation', 'Root')
AND	c.current_flag = 'Y'

SELECT 	 t.record_type
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
	,l.description as location_description
	,r.result_amount_flag
	,r.print_result_flag
	,COALESCE(r.print_result_separator, '=') as print_result_separator
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
FROM 	 @tmp_obstree t
LEFT OUTER JOIN c_observation_result r WITH (NOLOCK)
ON	t.observation_id = r.observation_id
AND 	t.result_sequence = r.result_sequence
LEFT OUTER JOIN c_location l WITH (NOLOCK)
ON	t.location = l.location
ORDER BY
	 t.observation_id_original
	,t.history_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_obstree_encounter]
	TO [cprsystem]
GO

