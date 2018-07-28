CREATE     FUNCTION fn_patient_observation_tree
(	 @ps_cpr_id varchar(12)
	,@pl_observation_sequence integer 
)

RETURNS @patient_observation_tree TABLE
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
	,results_level int NOT NULL 
	,default_view char(1) NULL
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
)

AS

BEGIN

DECLARE  @ll_iterations int
	,@ll_rowcount INT
	,@ll_more_records INT
	,@ll_level INT

SET  	@ll_iterations = 1
SET	@ll_more_records = 1
SET	@ll_level = 1

-- First, insert the root observation
INSERT INTO @patient_observation_tree
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
	,treatment_id
	,parent_history_sequence
	,results_level
	,default_view
)
SELECT	'Observation'
	,p.observation_sequence
	,p.observation_id
	,p.description
	,c.observation_type
	,p.composite_flag
	,p.stage
	,p.stage_description
	,c.in_context_flag
	,c.display_style
	,c.perform_location_domain
	,p.treatment_id
	,0
	,@ll_level
	,c.default_view
FROM 	 p_Observation p WITH (NOLOCK)
INNER JOIN c_Observation c WITH (NOLOCK)
ON 	p.observation_id = c.observation_id
WHERE
	p.cpr_id = @ps_cpr_id
AND 	p.observation_sequence = @pl_observation_sequence


-- Now add the children.  Wee are decrementing level from 1000 to perserve original sort order.


WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1
	SET @ll_level = @ll_level + 1

	INSERT INTO @patient_observation_tree 
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
		,treatment_id
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
		,p.stage
		,p.stage_description
		,o.in_context_flag
		,o.display_style
		,o.perform_location_domain
		,p.treatment_id
		,x.history_sequence
		,x.observation_sequence
		,@ll_level
		,o.default_view
	FROM 	@patient_observation_tree x
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON	p.parent_observation_sequence = x.observation_sequence
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON	p.observation_id = o.observation_id
	WHERE	
		p.cpr_id = @ps_cpr_id
	AND	x.results_level = @ll_level - 1

	SET @ll_rowcount = @@rowcount

	SET @ll_more_records = @ll_rowcount
END


-- Now that we've got all the observations, get the results
-- Set level to 1 level deeper

INSERT INTO @patient_observation_tree
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,observation_id
	,observation_description
	,treatment_id
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
SELECT   'Result'
	,o.history_sequence
	,o.observation_sequence
	,o.observation_id
	,o.observation_description
	,p.treatment_id
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
	,o.results_level + 1
	,o.default_view
	,p.abnormal_nature
	,p.normal_range
	,p.observed_by
FROM 	@patient_observation_tree o
INNER JOIN p_Observation_Result p WITH (NOLOCK)
ON	o.observation_sequence = p.observation_sequence
INNER JOIN c_Observation_Result c WITH (NOLOCK)
ON	p.observation_id = c.observation_id
AND 	p.result_sequence = c.result_sequence
INNER JOIN c_Location l WITH (NOLOCK)
ON	p.location = l.location
WHERE 
	p.cpr_id = @ps_cpr_id
AND 	p.result_date_time IS NOT NULL
AND	p.current_flag = 'Y'
AND p.result_type NOT IN ('Comment', 'Attachment')

-- Finally, get the comments


INSERT INTO @patient_observation_tree 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_description
	,treatment_id
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
	,c.treatment_id
	,c.user_id as comment_user_id
	,CAST(c.comment_title AS varchar(48)) as comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.observation_comment_id
	,c.attachment_id
	,o.results_level + 1
	,o.default_view
FROM 	@patient_observation_tree o
INNER JOIN p_Observation_Comment c  WITH (NOLOCK)
ON  	o.observation_sequence = c.observation_sequence
WHERE
	c.cpr_id = @ps_cpr_id
AND 	o.record_type IN ('Observation', 'Root')
AND	c.current_flag = 'Y'

RETURN
END

