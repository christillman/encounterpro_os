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

-- Drop Procedure [dbo].[jmj_copy_object_params]
Print 'Drop Procedure [dbo].[jmj_copy_object_params]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_object_params]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_object_params]
GO

-- Create Procedure [dbo].[jmj_copy_object_params]
Print 'Create Procedure [dbo].[jmj_copy_object_params]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_object_params (
	@ps_from_id varchar(40) ,
	@pl_from_param_sequence int = NULL ,
	@ps_to_id varchar(40) ,
	@ps_param_mode varchar(12) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @lui_from_id uniqueidentifier ,
		@lui_to_id uniqueidentifier,
		@ll_sort_sequence int

SET @lui_from_id = CAST(@ps_from_id AS uniqueidentifier)
SET @lui_to_id = CAST(@ps_to_id AS uniqueidentifier)

IF @pl_from_param_sequence IS NULL
	BEGIN
	DELETE
	FROM c_Component_Param
	WHERE id = @lui_to_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)

	INSERT INTO c_Component_Param (
		id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build )
	SELECT @lui_to_id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build
	FROM c_Component_Param
	WHERE id = @lui_from_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)
	END
ELSE
	BEGIN
	SELECT @ll_sort_sequence = max(sort_sequence)
	FROM c_Component_Param
	WHERE id = @lui_to_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)

	IF @ll_sort_sequence IS NULL
		SET @ll_sort_sequence = 1
	ELSE
		SET @ll_sort_sequence = @ll_sort_sequence + 1

	INSERT INTO c_Component_Param (
		id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build )
	SELECT @lui_to_id,
		param_class,
		param_mode,
		@ll_sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build
	FROM c_Component_Param
	WHERE id = @lui_from_id
	AND param_sequence = @pl_from_param_sequence
	END

GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_object_params]
	TO [cprsystem]
GO

