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
CREATE FUNCTION fn_treatment_tree (
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
	SELECT @ll_parent_treatment_id = parent_treatment_id
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_current_treatment_id
	
	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN
	
	-- Treatment not found - broken link
	IF @ll_rowcount = 0
		RETURN
	
	-- treatment points to itself - bad link
	IF @ll_parent_treatment_id = @ll_last_parent_treatment_id
		RETURN
	
	-- Found the root treatment so break
	IF @ll_parent_treatment_id IS NULL
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

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
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
GRANT SELECT
	ON [dbo].[fn_treatment_tree]
	TO [cprsystem]
GO

