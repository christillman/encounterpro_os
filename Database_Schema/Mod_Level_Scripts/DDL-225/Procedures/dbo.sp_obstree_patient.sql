
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_obstree_patient]
Print 'Drop Procedure [dbo].[sp_obstree_patient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_obstree_patient]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_obstree_patient]
GO

-- Create Procedure [dbo].[sp_obstree_patient]
Print 'Create Procedure [dbo].[sp_obstree_patient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE sp_obstree_patient
(	 @ps_cpr_id varchar(12)
	,@ps_observation_id varchar(24)
	,@pdt_begin_date datetime = NULL
	,@pdt_end_date datetime = NULL
)
AS

SET NOCOUNT ON

DECLARE  @ll_iterations int
	,@ll_rowcount INT
	,@ll_more_records INT
	,@ll_level INT
	,@ll_level_source INT
	,@ll_level_1_2_flag VARCHAR (1)

/*
	This procedure flushes out the latest observation tree for a given
	patient and root observation.  The top part of the tree is the latest 
	tree definition from c_observation_tree.  It is referred to as the
	"c_tree".  This tree always includes the first level children.  This assures that 
	the user can see all the possible observations under the root.
	Additionally the c_tree is flushed until a node with an in_context node observation is encountered
	
	Once the c_tree is fleshed out, the patient specific data is pulled from the p tables.  This starts with the 
	c_leaf pages which are replace with p_data if it exists.  The p_data also represents
	trees which are referred to as p_trees.  All possible p_trees are generated for the c_leaf pages
	When multiple p_trees exist for one c_leaf, the most recent tree with data 
	(i.e., has an associated comment or result record)is used.

	As a final step before returning the data to the calling program, all nodes deeper than first
	level children that have no directly or indirectly associated data are trimmed.


	Note:  History_sequence is a identity column that uniquely identifies every record 
	inserted into the working table.  It along iwth parent_history_sequence dynamically
	defines the final tree created by this algorithm.  This mechanism is essential because
	the ultimate tree has both a c_tree and p_tree component that are welded together with
	this mechansim.

*/

DECLARE @tmp_patient_results TABLE
(
	 record_type varchar(12) NOT NULL
	,display_flag char(1) NULL DEFAULT ('Y')
	,history_sequence int IDENTITY (1,1) NOT NULL
	,parent_history_sequence int NOT NULL
	,observation_id varchar(24) NOT NULL
	,observation_description varchar(80) NULL
	,observation_sequence int NULL
	,observation_type varchar(24) NULL
	,composite_flag char(1) NULL
	,in_context_flag char(1)
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
	,result_expected_date datetime
	,parent_observation_id VARCHAR(24)
	,c_leaf_flag VARCHAR(1) NOT NULL DEFAULT 'N'
	,p_root_flag varchar(1) NOT NULL DEFAULT 'N'
	,associated_results_flag VARCHAR (1) NOT NULL DEFAULT 'N'
	,record_source VARCHAR (1) NOT NULL
	,p_tree_id INT  --history_sequence of p_tree_root.  Used to uniquely_identify p_tree
	,c_leaf_id INT  --history_sequence of source c_leaf for p_trees.  Uniquely identifies set of p_trees associated with a leaf
	,obsolete_flag VARCHAR (1) NOT NULL DEFAULT 'N'
	,level_1_2_flag VARCHAR (1) NOT NULL DEFAULT 'N'
	,default_view char(1) DEFAULT ('R')
	,abnormal_nature varchar(8) NULL
	,normal_range varchar(40) NULL
	,observed_by varchar(24) NULL
	,current_flag char(1) NULL DEFAULT 'Y'
	,id uniqueidentifier NULL
)

/* 
	"results_level" identifies the level in the tree a set of nodes is on.  
	It is used to generate and walk trees.  For backward
	compatibility to a previous alorithm, the level counts down from 2000.  
	There is no significance to individual result level values
*/


DECLARE @tmp_equiv_observations TABLE
(	 history_sequence int NOT NULL
	,observation_sequence int NULL
	,observation_id varchar(24) NOT NULL
	,observation_description varchar(80) NULL
	,default_view char(1) DEFAULT ('R')
	,results_level int NOT NULL DEFAULT (0)
	,record_source VARCHAR (1) NOT NULL
	,p_tree_id INT  --history_sequence of p_tree_root.  Used to uniquely_identify p_tree
	,c_leaf_id INT  --history_sequence of source c_leaf for p_trees.  Uniquely identifies set of p_trees associated with a leaf
)




-- First insert the root observation

INSERT INTO @tmp_patient_results 
(	 record_type
	,observation_id
	,observation_description
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
	,parent_history_sequence
	,results_level
	,c_leaf_flag
	,record_source
	,associated_results_flag
	,level_1_2_flag
	,default_view
	,id
)
SELECT	 'Root'
	,observation_id
	,description
	,observation_type
	,composite_flag
	,ISNULL(in_context_flag, 'N')
	,display_style
	,perform_location_domain
	,0
	,2000
	,'Y'
	,'C'
	,'Y'
	,'Y'
	,default_view
	,id
FROM 	c_Observation WITH (NOLOCK)
WHERE 	observation_id = @ps_observation_id

/*
	Flesh out the c_observation tree, stopping just before the first node with an in context
	observation.  However,
	ALL second level observations must be included.  Hence the "Root" and NOT EXISTS "or"
	in the WHERE clause.
*/

SET  	@ll_iterations = 0
SET	@ll_level = 2000
SET	@ll_more_records = 1
SET	@ll_level_1_2_flag = 'Y' -- only for first iteration which is 1st level children

WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1
	SET @ll_level_source = @ll_level
	SET @ll_level = @ll_level - 1

	INSERT INTO @tmp_patient_results 
	(	 record_type
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,in_context_flag
		,display_style
		,perform_location_domain
		,parent_history_sequence
		,sort_sequence
		,edit_service
		,results_level
		,parent_observation_id
		,c_leaf_flag
		,record_source
		,level_1_2_flag
		,default_view
		,id
	)
	SELECT   'Observation'
		,t.child_observation_id
		,o.description
		,o.observation_type
		,o.composite_flag
		,ISNULL(o.in_context_flag, 'N')
		,o.display_style
		,o.perform_location_domain
		,x.history_sequence
		,t.sort_sequence
		,t.edit_service
		,@ll_level
		,t.parent_observation_id
		,'Y'
		,'C'
		,@ll_level_1_2_flag
		,o.default_view
		,o.id
	FROM	@tmp_patient_results x
	INNER JOIN c_Observation_Tree t WITH (NOLOCK)
	ON	x.observation_id = t.parent_observation_id
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON	t.child_observation_id = o.observation_id
	WHERE 
	 	x.results_level = @ll_level_source
	AND	x.record_source = 'C'
	AND	ISNULL(o.in_context_flag, 'N') <> ' Y' 
	AND	NOT EXISTS
		(	SELECT 1
			FROM 	 c_observation_tree t2 WITH (NOLOCK)
				,c_Observation o2 WITH (NOLOCK)
			WHERE	x.observation_id = t2.parent_observation_id
			AND	t2.child_observation_id = o2.observation_id
			AND 	o2.in_context_flag = 'Y'
		)

	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
	SET @ll_level_1_2_flag = 'N'
END

/*
	identify c_tree leaf pages .  These will be the jumping off point
	for the p_trees.

	The previous step marked all entries as potential leaf nodes.
	Now we are going to set all records that are someone else's parent to 'N'
	This will leave the real leaf pages.
*/

UPDATE 	x
SET	c_leaf_flag = 'N'
FROM 	@tmp_patient_results x
INNER JOIN @tmp_patient_results x2
ON 	x.history_sequence = x2.parent_history_sequence
WHERE
	x.record_source = 'C'
AND	x2.record_source = 'C'

/*  Debugging
xELECT
	 'c_tree'	
 	,history_sequence
	,parent_history_sequence
	,observation_id
	,observation_sequence
	,observation_description
	,in_context_flag
	,c_leaf_flag
	,results_level
FROM	@tmp_patient_results
ORDER BY
	observation_description
*/

/*
	Now that we have The C-tree.  Insert the root level for all corresponding P-trees.
	Note that there can be 0 to many p-tree_roots for each c leaf.  Later we will select which 
	tree to keep
*/

INSERT INTO @tmp_patient_results 
(	 record_type
	,observation_id
	,observation_description
	,observation_type
	,composite_flag
	,in_context_flag
	,display_style
	,perform_location_domain
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,results_level
	,result_expected_date
	,record_source
	,p_root_flag
	,c_leaf_id
	,associated_results_flag
	,level_1_2_flag
	,sort_sequence
	,edit_service
	,default_view
	,id
)
SELECT   x.record_type
	,o.observation_id
	,o.description
	,c.observation_type
	,c.composite_flag
	,c.in_context_flag
	,c.display_style
	,c.perform_location_domain
	,x.parent_history_sequence
	,o.observation_sequence
	,o.parent_observation_sequence
	,1000
	,o.result_expected_date
	,'P'
	,'Y'
	,x.history_sequence
	,x.associated_results_flag
	,x.level_1_2_flag
	,x.sort_sequence
	,COALESCE(o.service, x.edit_service)
	,c.default_view
	,c.id
FROM 	@tmp_patient_results x
INNER JOIN p_Observation o WITH (NOLOCK)
ON	x.observation_id = o.observation_id
LEFT OUTER JOIN p_Treatment_Item t
ON o.cpr_id = t.cpr_id
AND o.treatment_id = t.treatment_id
INNER JOIN c_Observation c WITH (NOLOCK)
ON	o.observation_id = c.observation_id
WHERE	o.cpr_id = @ps_cpr_id
AND	x.c_leaf_flag = 'Y'
AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'

/*
	Delete Ctree leaf nodes which were just replaced with ptree root nodes.
	Leave the ones not replaced
*/

DELETE x
FROM @tmp_patient_results x
INNER JOIN @tmp_patient_results x2
ON	x.history_sequence = x2.c_leaf_id
WHERE
	x.c_leaf_flag = 'Y'
AND	x2.p_root_flag = 'Y'

/*
	Create a p_tree_id by setting it equal to the history_sequence.  All records in the
	p_tree will carey this ID
*/

UPDATE 	@tmp_patient_results
SET	p_tree_id = history_sequence
WHERE	p_root_flag = 'Y'

/*
	Find if the patient has any results/comments for c_nodes. These
	are rare, but can occur.  Pick only the most recent.
*/

UPDATE x
SET	Observation_sequence = 
		(	SELECT	MAX(observation_sequence)
			FROM	p_observation_result r  WITH (NOLOCK)
			WHERE	r.cpr_id = @ps_cpr_id
			AND	r.observation_id = x.observation_id
			AND	r.current_flag = 'Y'
			AND	r.result_date_time >= ISNULL( @pdt_begin_date, '1-1-1900' )
			AND	r.result_date_time <= ISNULL( @pdt_end_date, '1-1-2100' )

		)
FROM @tmp_patient_results x
WHERE
	record_source = 'C'

UPDATE x
SET	Observation_sequence = 
		(	SELECT	MAX(observation_sequence)
			FROM	p_observation_comment c  WITH (NOLOCK)
			WHERE	c.cpr_id = @ps_cpr_id
			AND	c.observation_id = x.observation_id
			AND	c.current_flag = 'Y'
			AND	c.observation_sequence > ISNULL( x.observation_sequence, 0 )
			AND	c.comment_date_time >= ISNULL( @pdt_begin_date, '1-1-1900' )
			AND	c.comment_date_time <= ISNULL( @pdt_end_date, '1-1-2100' )
		)
FROM 	@tmp_patient_results x
WHERE
	record_source = 'C'

/* debugging
SELECT *
FROM	@tmp_patient_results
WHERE observation_id = 'DEMO19939'
*/

/*
	Flesh out the Ptree nodes
*/

SET  	@ll_iterations = 0
SET	@ll_more_records = 1
SET	@ll_level = 1000

WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1
	SET @ll_level_source = @ll_level
	SET @ll_level = @ll_level - 1

	INSERT INTO @tmp_patient_results 
	(	 record_type
		,observation_id
		,observation_description
		,observation_type
		,composite_flag
		,in_context_flag
		,display_style
		,perform_location_domain
		,parent_history_sequence
		,observation_sequence
		,parent_observation_sequence
		,results_level
		,record_source
		,p_tree_id
		,c_leaf_id
		,edit_service
		,default_view
		,id
	)
	SELECT   'Observation'
		,p.observation_id
		,p.description
		,c.observation_type
		,c.composite_flag
		,c.in_context_flag
		,c.display_style
		,x.perform_location_domain
		,x.history_sequence
		,p.observation_sequence
		,p.parent_observation_sequence
		,@ll_level
		,'P'
		,x.p_tree_id
		,x.c_leaf_id
		,COALESCE(p.service, x.edit_service)
		,c.default_view
		,c.id
	FROM 	@tmp_patient_results x
	INNER JOIN p_Observation p WITH (NOLOCK)
	ON	x.observation_sequence = p.parent_observation_sequence
	INNER JOIN c_Observation c WITH (NOLOCK)
	ON	p.observation_id = c.observation_id
	WHERE	p.cpr_id = @ps_cpr_id
	AND 	x.results_level = @ll_level_source
	AND 	x.record_source = 'P'

	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
END

/* Debugging
SELECT
	 'P-tree'
	,history_sequence
	,parent_history_sequence
	,results_level
	,observation_id
	,observation_description
FROM	@tmp_patient_results
*/


-------------------------------------------------------
-- Now get the equivalence observations, if any
-------------------------------------------------------
INSERT INTO @tmp_equiv_observations (
	history_sequence ,
	observation_sequence,
	observation_id ,
	observation_description ,
	default_view ,
	results_level ,
	record_source ,
	p_tree_id ,
	c_leaf_id )
SELECT DISTINCT t.history_sequence ,
	t.observation_sequence,
	o.observation_id ,
	o.description ,
	o.default_view,
	t.results_level ,
	t.record_source ,
	t.p_tree_id ,
	t.c_leaf_id 
FROM @tmp_patient_results t
	INNER JOIN c_Equivalence g
	ON t.id = g.object_id
	INNER JOIN c_Equivalence e
	ON g.equivalence_group_id = e.equivalence_group_id
	INNER JOIN c_Observation o
	ON e.object_id = o.id

-- Add in the observations which have no equivalences
INSERT INTO @tmp_equiv_observations (
	history_sequence ,
	observation_sequence,
	observation_id ,
	observation_description ,
	default_view ,
	results_level ,
	record_source ,
	p_tree_id ,
	c_leaf_id )
SELECT DISTINCT t.history_sequence ,
	t.observation_sequence,
	t.observation_id ,
	t.observation_description ,
	t.default_view,
	t.results_level ,
	t.record_source ,
	t.p_tree_id ,
	t.c_leaf_id 
FROM @tmp_patient_results t
WHERE NOT EXISTS (
	SELECT 1
	FROM @tmp_equiv_observations e
	WHERE t.observation_sequence = e.observation_sequence
	AND t.observation_id = e.observation_id )



-- Now that we've got all the observations, get the results.

INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
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
	,record_source
	,associated_results_flag
	,p_tree_id
	,c_leaf_id
	,default_view
	,abnormal_nature
	,normal_range
	,observed_by
	,current_flag
)
SELECT   'Result'
	,x.history_sequence
	,r.observation_sequence
	,r.observation_sequence
	,x.observation_id
	,x.observation_description
	,r.location
	,r.result_sequence
	,r.location_result_sequence
	,r.result_date_time
	,r.result
	,r.result_value
	,r.result_unit
	,r.abnormal_flag
	,r.severity
	,r.result_type
	,c.unit_preference
	,c.display_mask
	,c.sort_sequence
	,x.results_level - 1
	,x.record_source
	,'Y'
	,x.p_tree_id
	,x.c_leaf_id
	,x.default_view
	,r.abnormal_nature
	,r.normal_range
	,r.observed_by
	,r.current_flag
FROM @tmp_equiv_observations x
	INNER JOIN p_Observation_Result r WITH (NOLOCK)
	ON r.cpr_id = @ps_cpr_id
	AND x.observation_sequence = r.observation_sequence
	INNER JOIN c_Observation_Result c WITH (NOLOCK)
	ON r.observation_id = c.observation_id
	AND r.result_sequence = c.result_sequence
WHERE r.result_date_time >= ISNULL( @pdt_begin_date, '1-1-1900' )
AND	r.result_date_time <= ISNULL( @pdt_end_date, '1-1-2100' )
AND r.result_type NOT IN ('Comment', 'Attachment')

-- Get the ROOT comments

INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_description
	,result_date_time
	,comment_user_id
	,comment_title
	,comment
	,abnormal_flag
	,severity
	,observation_comment_id
	,attachment_id
	,results_level
	,record_source
	,associated_results_flag
	,p_tree_id
	,c_leaf_id
	,default_view
	,current_flag
)
SELECT   'Comment'
	,x.history_sequence
	,c.observation_sequence
	,x.observation_sequence
	,x.observation_id
	,x.observation_description
	,c.comment_date_time
	,c.user_id as comment_user_id
	,c.comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.abnormal_flag
	,c.severity
	,c.observation_comment_id
	,c.attachment_id
	,x.results_level - 1
	,x.record_source
	,'Y'
	,x.p_tree_id
	,x.c_leaf_id
	,x.default_view
	,c.current_flag
FROM @tmp_equiv_observations x
	INNER JOIN @tmp_patient_results xr
	ON x.history_sequence = xr.history_sequence
	INNER JOIN p_Observation_Comment c WITH (NOLOCK)
	ON c.cpr_id = @ps_cpr_id
	AND c.observation_id = x.observation_id
WHERE xr.record_type = 'Root'
AND c.comment_date_time >= ISNULL( @pdt_begin_date, '1-1-1900' )
AND	c.comment_date_time <= ISNULL( @pdt_end_date, '1-1-2100' )

-- Get the comments

INSERT INTO @tmp_patient_results 
(	 record_type
	,parent_history_sequence
	,observation_sequence
	,parent_observation_sequence
	,observation_id
	,observation_description
	,result_date_time
	,comment_user_id
	,comment_title
	,comment
	,abnormal_flag
	,severity
	,observation_comment_id
	,attachment_id
	,results_level
	,record_source
	,associated_results_flag
	,p_tree_id
	,c_leaf_id
	,default_view
	,current_flag
)
SELECT   'Comment'
	,x.history_sequence
	,c.observation_sequence
	,x.observation_sequence
	,x.observation_id
	,x.observation_description
	,c.comment_date_time
	,c.user_id as comment_user_id
	,c.comment_title
	,COALESCE(c.short_comment, c.comment)
	,c.abnormal_flag
	,c.severity
	,c.observation_comment_id
	,c.attachment_id
	,x.results_level - 1
	,x.record_source
	,'Y'
	,x.p_tree_id
	,x.c_leaf_id
	,x.default_view
	,c.current_flag
FROM @tmp_equiv_observations x
	INNER JOIN @tmp_patient_results xr
	ON x.history_sequence = xr.history_sequence
	INNER JOIN p_Observation_Comment c WITH (NOLOCK)
	ON c.cpr_id = @ps_cpr_id
	AND x.observation_sequence = c.observation_sequence
WHERE xr.record_type <> 'Root'
AND c.comment_date_time >= ISNULL( @pdt_begin_date, '1-1-1900' )
AND	c.comment_date_time <= ISNULL( @pdt_end_date, '1-1-2100' )

/*
	Now mark all nodes that have associated results	
*/

SET  	@ll_iterations = 0
SET	@ll_more_records = 1

WHILE @ll_more_records > 0 AND @ll_iterations <= 100
BEGIN
	SET @ll_iterations = @ll_iterations + 1

	UPDATE	x
	SET	associated_results_flag = 'Y'
	FROM 	@tmp_patient_results x
	INNER JOIN @tmp_patient_results x2
	ON	x.history_sequence = x2.parent_history_sequence
	WHERE	x2.associated_results_flag = 'Y'
	AND	x.associated_results_flag = 'N'

	SET @ll_rowcount = @@rowcount
	SET @ll_more_records = @ll_rowcount
END

/* Debugging
SELECT
	 'Full Data'
	,level_1_2_flag 
	,record_type	 
	,history_sequence
	,parent_history_sequence
	,observation_id
	,observation_description
FROM	@tmp_patient_results
*/

/*
	When there are multiple p_trees for the same leaf and there is at least one p_tree with
	results, mark older trees obsolete and trees with no associated results obsolete
*/

UPDATE x
SET	obsolete_flag = 'Y'
FROM @tmp_patient_results x
INNER JOIN @tmp_patient_results x2
ON	x.c_leaf_id = x2.c_leaf_id
AND	x.p_tree_id <> x2.p_tree_id
WHERE
	x.p_root_flag = 'Y'
AND	x2.p_root_flag = 'Y'
AND	x2.associated_results_flag = 'Y'
AND
(
		x.observation_sequence < x2.observation_sequence
	OR	x.associated_results_flag = 'N'
)

/*
	When there are multiple p_trees for the same leaf and there are no p_trees with
	results, mark the older p_trees for deletion.
*/

UPDATE x
SET	obsolete_flag = 'Y'
FROM 	@tmp_patient_results x
INNER JOIN @tmp_patient_results x2
ON	x.c_leaf_id = x2.c_leaf_id
AND	x.p_tree_id <> x2.p_tree_id
AND	x.observation_sequence < x2.observation_sequence
WHERE
	x.p_root_flag = 'Y'

AND	x2.p_root_flag = 'Y'
AND	x2.associated_results_flag = 'N'
AND	x.associated_results_flag = 'N'
AND	x.obsolete_flag = 'N'

/* Delete obsolete p_trees */

DELETE	x
FROM	@tmp_patient_results x
INNER JOIN @tmp_patient_results x2
ON	x.p_tree_id = x2.p_tree_id
WHERE	x2.p_root_flag = 'Y'
AND	x2.obsolete_flag = 'Y'

-- Now remove the results with current_flag = 'N' and any parents which now don't have any children
DELETE	x
FROM	@tmp_patient_results x
WHERE	x.current_flag = 'N'

SET	@ll_rowcount = 1
SET	@ll_iterations = 1

WHILE @ll_rowcount > 0 AND @ll_iterations <= 100
BEGIN
	DELETE	x
	FROM	@tmp_patient_results x
	WHERE x.record_type = 'Observation'
	AND x.level_1_2_flag = 'N'
	AND NOT EXISTS (
		SELECT 1
		FROM @tmp_patient_results y
		WHERE x.history_sequence = y.parent_history_sequence )

	SET @ll_rowcount = @@rowcount
	SET @ll_iterations = @ll_iterations + 1
END

/*
	Get result data with associated result data or that are in the first two levels of the tree.
	This will trim nodes with no resluts below the 1st child level
*/

SELECT 
	 x.record_type
	,x.history_sequence
	,x.parent_history_sequence
	,x.observation_sequence
	,x.parent_observation_sequence
	,x.observation_id
	,x.observation_type
	,x.composite_flag
	,x.in_context_flag
	,x.display_style
	,x.perform_location_domain
	,x.observation_description
	,x.location
	,x.result_sequence
	,x.location_result_sequence
	,x.result_date_time
	,x.result
	,x.result_value
	,x.result_unit
	,x.abnormal_flag
	,x.severity
	,x.result_type
	,l.description as location_description
	,r.result_amount_flag
	,r.print_result_flag
	,COALESCE(r.print_result_separator, '=') as print_result_separator
	,x.observation_comment_id
	,x.comment_user_id
	,x.comment_title
	,x.comment
	,x.attachment_id
	,x.unit_preference
	,x.display_mask
	,x.sort_sequence
	,x.edit_service
	,x.display_flag
	,x.stage
	,x.stage_description
	,x.results_level AS [level]
	,x.treatment_id
	,x.default_view
	,x.abnormal_nature
	,x.normal_range
	,x.observed_by
FROM 	@tmp_patient_results x
	LEFT OUTER JOIN c_observation_result r WITH (NOLOCK)
	ON x.observation_id = r.observation_id
	AND x.result_sequence = r.result_sequence
	LEFT OUTER JOIN c_location l WITH (NOLOCK)
	ON x.location = l.location
	WHERE
	(		associated_results_flag = 'Y'
		OR	level_1_2_flag = 'Y'
	)
ORDER BY
	 x.history_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_obstree_patient]
	TO [cprsystem]
GO

