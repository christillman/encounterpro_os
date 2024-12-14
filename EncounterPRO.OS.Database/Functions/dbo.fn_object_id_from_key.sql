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

-- Drop Function [dbo].[fn_object_id_from_key]
Print 'Drop Function [dbo].[fn_object_id_from_key]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_object_id_from_key]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_object_id_from_key]
GO

-- Create Function [dbo].[fn_object_id_from_key]
Print 'Create Function [dbo].[fn_object_id_from_key]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_object_id_from_key (
	@ps_object_type varchar(24),
	@ps_object_key varchar(64))

RETURNS uniqueidentifier

AS
BEGIN

DECLARE @lu_object_id uniqueidentifier,
		@ls_observation_id varchar(24),
		@li_result_sequence smallint

SET @lu_object_id = NULL

IF @ps_object_type = 'Assessment'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_object_key
	END

IF @ps_object_type = 'Drug'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Drug_Definition
	WHERE drug_id = @ps_object_key
	END

IF @ps_object_type = 'Procedure'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Procedure
	WHERE procedure_id = @ps_object_key
	END

IF @ps_object_type = 'Material'
	BEGIN
	IF ISNUMERIC(@ps_object_key) = 1
		SELECT @lu_object_id = id
		FROM c_Patient_Material
		WHERE material_id = CAST(@ps_object_key AS int)
	END

IF @ps_object_type = 'Observation'
	BEGIN
	SELECT @lu_object_id = id
	FROM c_Observation
	WHERE observation_id = @ps_object_key
	END

IF @ps_object_type = 'Result'
	BEGIN
	SELECT @ls_observation_id = CAST(item AS varchar(24))
	FROM dbo.fn_parse_string(@ps_object_key, '|')
	WHERE item_number = 1

	SELECT @li_result_sequence = CAST(item AS smallint)
	FROM dbo.fn_parse_string(@ps_object_key, '|')
	WHERE item_number = 2

	SELECT @lu_object_id = id
	FROM c_Observation_Result
	WHERE observation_id = @ls_observation_id
	AND result_sequence = @li_result_sequence
	END



RETURN @lu_object_id
END

GO
GRANT EXECUTE
	ON [dbo].[fn_object_id_from_key]
	TO [cprsystem]
GO

