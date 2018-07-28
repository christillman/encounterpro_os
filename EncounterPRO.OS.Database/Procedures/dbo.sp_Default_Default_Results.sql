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
SET QUOTED_IDENTIFIER OFF
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
	location varchar(24) NULL,
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
FROM @tmp_observation_results r, @tmp_locations l
ORDER BY l.sort_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_Default_Default_Results]
	TO [cprsystem]
GO

