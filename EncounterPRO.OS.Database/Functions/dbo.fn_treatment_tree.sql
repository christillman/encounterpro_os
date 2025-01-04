
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_treatment_tree]
Print 'Drop Function [dbo].[fn_treatment_tree]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_treatment_tree]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_treatment_tree]
GO

-- Create Function [dbo].[fn_treatment_tree]
Print 'Create Function [dbo].[fn_treatment_tree]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_treatment_tree (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int)

RETURNS @treatments TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[treatment_id] [int] NOT NULL ,
	[parent_treatment_id] [int] NULL ,
	[level] int NOT NULL )

AS

BEGIN

DECLARE @ll_current_treatment_id int,
		@ll_parent_treatment_id int,
		@ll_last_parent_treatment_id int,
		@ll_error int,
		@ll_rowcount int,
		@ll_loop_count int,
		@ll_level int

-- First, go up the tree to find the root treatment (the one with no parent_treatment_id)
SET @ll_current_treatment_id = @pl_treatment_id
SET @ll_last_parent_treatment_id = NULL
SET @ll_loop_count = 0

WHILE 1 = 1
	BEGIN
	SELECT @ll_parent_treatment_id = IsNull(parent_treatment_id,-999)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_current_treatment_id
			
	IF @@ERROR <> 0
		RETURN
	
	-- Treatment not found - broken link
	IF @ll_parent_treatment_id IS NULL
		RETURN
	
	-- treatment points to itself - bad link
	IF @ll_parent_treatment_id = @ll_last_parent_treatment_id
		RETURN
	
	-- Found the root treatment so break
	IF @ll_parent_treatment_id = -999
		BREAK
	
	-- Make sure we don't have an infinite loop
	SET @ll_loop_count = @ll_loop_count + 1
	IF @ll_loop_count > 100
		RETURN
	SET @ll_current_treatment_id = @ll_parent_treatment_id
	END

-- Next, insert the root treatment into our result set
INSERT INTO @treatments (
	cpr_id ,
	treatment_id ,
	level)
VALUES (
	@ps_cpr_id,
	@ll_current_treatment_id,
	1)
		
IF @@ERROR <> 0
	RETURN

-- Finally, loop down the tree adding the levels
SET @ll_level = 1

WHILE 1 = 1
	BEGIN
	SET @ll_level = @ll_level + 1
	IF @ll_level > 100
		RETURN

	INSERT INTO @treatments (
		cpr_id ,
		treatment_id ,
		parent_treatment_id ,
		level)
	SELECT t.cpr_id,
			t.treatment_id,
			t.parent_treatment_id,
			@ll_level
	FROM p_Treatment_Item t
		INNER JOIN @treatments x
		ON t.cpr_id = x.cpr_id
		AND t.parent_treatment_id = x.treatment_id
		AND x.level = @ll_level - 1
	
	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN
	
	-- If the query returned no rows then we're done
	IF @ll_rowcount = 0
		RETURN
	END

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_treatment_tree] TO [cprsystem]
GO

