﻿--EncounterPRO Open Source Project
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

-- Drop Function [dbo].[fn_treatment_type_key_description]
Print 'Drop Function [dbo].[fn_treatment_type_key_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_treatment_type_key_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_treatment_type_key_description]
GO

-- Create Function [dbo].[fn_treatment_type_key_description]
Print 'Create Function [dbo].[fn_treatment_type_key_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION dbo.fn_treatment_type_key_description (
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(64) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ps_treatment_key_description varchar(80),
		@ps_treatment_key_field varchar(64)


SET @ps_treatment_key_field = dbo.fn_treatment_type_treatment_key(@ps_treatment_type)

IF @ps_treatment_key_field = 'procedure_id'
	BEGIN
	SELECT @ps_treatment_key_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'material_id'
	BEGIN
	IF ISNUMERIC(@ps_treatment_key) = 1
		SELECT @ps_treatment_key_description = title
		FROM c_Patient_Material
		WHERE material_id = CAST(@ps_treatment_key AS int)
	END

IF @ps_treatment_key_field = 'drug_id'
	BEGIN
	SELECT @ps_treatment_key_description = common_name
	FROM c_Drug_Definition
	WHERE drug_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'observation_id'
	BEGIN
	SELECT @ps_treatment_key_description = description
	FROM c_Observation
	WHERE observation_id = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'treatment_description'
	BEGIN
	SET @ps_treatment_key_description = @ps_treatment_key
	END

IF @ps_treatment_key_field = 'treatment_type'
	BEGIN
	SET @ps_treatment_key_description = @ps_treatment_key
	END

RETURN @ps_treatment_key_description 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_treatment_type_key_description]
	TO [cprsystem]
GO

