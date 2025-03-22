
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Default_Default_Results]
Print 'Drop Procedure [dbo].[sp_Default_Default_Results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Default_Default_Results]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Default_Default_Results]
GO

-- Create Procedure [dbo].[sp_Default_Default_Results]
Print 'Create Procedure [dbo].[sp_Default_Default_Results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Default_Default_Results (
	@pl_branch_id int,
	@ps_observation_id varchar(24) = NULL,
	@pi_result_sequence smallint = NULL,
	@ps_location varchar(24) = NULL)
AS

DECLARE @ls_perform_location_domain varchar(12)

DECLARE @tmp_observation_results TABLE (
	branch_id int NOT NULL,
	parent_observation_id varchar(24) NULL,
	child_observation_id varchar(24) NULL,
	[user_id] varchar(24) NULL,
	result_sequence smallint NULL,
	result_value varchar(40) NULL,
	result_unit varchar(24) NULL,
	result_flag char(1) NULL,
	observation_tag varchar(12) NULL ,
	sort_sequence int NULL ,
	parent_branch_id int NULL ,
	diffuse_flag char(1) NULL ,
	in_results bit NOT NULL DEFAULT (0) )

DECLARE @tmp_locations TABLE (
	location varchar(24) NULL ,
	sort_sequence smallint NULL )

IF @pl_branch_id > 0
	BEGIN
	SELECT @ls_perform_location_domain = o.perform_location_domain
	FROM c_Observation_Tree t
		INNER JOIN c_Observation o
		ON t.child_observation_id = o.observation_id
	WHERE t.branch_id = @pl_branch_id
	
	-- Add the first normal result for the observation
	INSERT INTO @tmp_observation_results (
		branch_id ,
		parent_observation_id ,
		child_observation_id ,
		observation_tag ,
		result_sequence ,
		sort_sequence)
	SELECT TOP 1
		t.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		t.observation_tag ,
		r.result_sequence ,
		r.sort_sequence
	FROM c_Observation_Tree t
		INNER JOIN c_Observation_Result r
		ON t.child_observation_id = r.observation_id
	WHERE t.branch_id = @pl_branch_id
	AND r.abnormal_flag = 'N'
	AND r.result_type = 'PERFORM'
	AND r.status = 'OK'
	AND r.result_sequence = COALESCE(@pi_result_sequence, r.result_sequence)
	ORDER BY r.sort_sequence
	END
ELSE
	BEGIN
	SELECT @ls_perform_location_domain = perform_location_domain
	FROM c_Observation
	WHERE observation_id = @ps_observation_id
	
	-- Add the first normal result for the observation
	INSERT INTO @tmp_observation_results (
		branch_id ,
		parent_observation_id ,
		child_observation_id ,
		result_sequence ,
		sort_sequence)
	SELECT TOP 1
		CONVERT(int, 0) as branch_id ,
		CONVERT(varchar(24), NULL) as parent_observation_id ,
		CONVERT(varchar(24), NULL) as child_observation_id ,
		r.result_sequence ,
		r.sort_sequence
	FROM c_Observation_Result r
	WHERE observation_id = @ps_observation_id
	AND r.abnormal_flag = 'N'
	AND r.result_type = 'PERFORM'
	AND r.status = 'OK'
	AND r.result_sequence = COALESCE(@pi_result_sequence, r.result_sequence)
	ORDER BY r.sort_sequence
	END

IF @ps_location IS NOT NULL
	INSERT INTO @tmp_locations (
		location)
	VALUES (@ps_location)
ELSE
	BEGIN
	-- Add the first diffuse location to the temp locations table
	INSERT INTO @tmp_locations (
		location)
	SELECT TOP 1
		location
	FROM c_Location
	WHERE location_domain = @ls_perform_location_domain
	AND status = 'OK'
	AND diffuse_flag = 'Y'

	-- If we didn't find a diffuse location, then add all locations
	IF @@ROWCOUNT = 0
		INSERT INTO @tmp_locations (
			location, sort_sequence)
		SELECT location, sort_sequence
		FROM c_Location
		WHERE location_domain = @ls_perform_location_domain
		AND status = 'OK'
	END


-- Then return the records which were in the results tree
SELECT 	r.branch_id ,
	r.parent_observation_id ,
	r.child_observation_id ,
	r.[user_id] ,
	r.result_sequence ,
	l.location ,
	r.result_value ,
	r.result_unit ,
	r.parent_branch_id ,
	r.observation_tag
FROM @tmp_observation_results r
CROSS JOIN @tmp_locations l
ORDER BY l.sort_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_Default_Default_Results]
	TO [cprsystem]
GO

