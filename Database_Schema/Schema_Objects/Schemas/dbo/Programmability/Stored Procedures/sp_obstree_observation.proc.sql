CREATE     PROCEDURE sp_obstree_observation
( 	 @ps_cpr_id varchar(12)
	,@pl_observation_sequence int
)
AS

DECLARE	 @ll_count int
	,@ll_iterations int

DECLARE @patient_observation_tree TABLE 
(	 record_type varchar(12) NOT NULL
	,display_flag char(1) NULL DEFAULT ('Y')
	,history_sequence int NOT NULL
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


INSERT INTO @patient_observation_tree 
(	 record_type
	,history_sequence
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
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
	,location_description
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,observation_comment_id
	,comment_user_id
	,comment_title
	,comment
	,attachment_id
	,unit_preference
	,display_mask
	,sort_sequence
	,edit_service
	,display_flag
	,stage
	,stage_description
	,results_level
	,treatment_id
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
)
SELECT	 record_type
	,history_sequence
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
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
	,location_description
	,result_amount_flag
	,print_result_flag
	,print_result_separator
	,observation_comment_id
	,comment_user_id
	,comment_title
	,comment
	,attachment_id
	,unit_preference
	,display_mask
	,sort_sequence
	,edit_service
	,display_flag
	,stage
	,stage_description
	,results_level
	,treatment_id
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
FROM dbo.fn_patient_observation_tree(@ps_cpr_id, @pl_observation_sequence)

UPDATE @patient_observation_tree
SET record_type = 'Root'
WHERE parent_history_sequence = 0

-- Now, before we return all these records, remove the observation records which don't have
-- any children at all
SET @ll_count = 1
SET @ll_iterations = 0

WHILE @ll_count > 0 AND @ll_iterations <= 100
BEGIN
	DELETE t1
	FROM @patient_observation_tree t1
	LEFT OUTER JOIN @patient_observation_tree t2
	ON t1.history_sequence = t2.parent_history_sequence
	WHERE	t1.record_type = 'Observation'
	AND 	t2.parent_history_sequence IS NULL

	SET @ll_count = @@ROWCOUNT
	SELECT @ll_iterations = @ll_iterations + 1
END

SELECT 
	 t1.record_type
	,t1.history_sequence
	,t1.parent_history_sequence
	,t1.observation_sequence
	,t1.parent_observation_sequence
	,t1.observation_id
	,t1.observation_type
	,t1.composite_flag
	,t1.in_context_flag
	,t1.display_style
	,t1.perform_location_domain
	,t1.observation_description
	,t1.location
	,t1.result_sequence
	,t1.location_result_sequence
	,t1.result_date_time
	,t1.result
	,t1.result_value
	,t1.result_unit
	,t1.abnormal_flag
	,t1.severity
	,t1.result_type
	,t1.location_description
	,t1.result_amount_flag
	,t1.print_result_flag
	,t1.print_result_separator
	,t1.observation_comment_id
	,t1.comment_user_id
	,t1.comment_title
	,t1.comment
	,t1.attachment_id
	,t1.unit_preference
	,t1.display_mask
	,t1.sort_sequence
	,t1.edit_service
	,t1.display_flag
	,t1.stage
	,t1.stage_description
	,t1.results_level AS [level]
	,t1.treatment_id
	,t1.default_view
	,t1.abnormal_nature
	,t1.normal_range
	,t1.observed_by
FROM 	@patient_observation_tree t1
ORDER BY 
	 history_sequence

