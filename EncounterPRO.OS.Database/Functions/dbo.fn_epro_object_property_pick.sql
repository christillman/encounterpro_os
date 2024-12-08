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

-- Drop Function [dbo].[fn_epro_object_property_pick]
Print 'Drop Function [dbo].[fn_epro_object_property_pick]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_epro_object_property_pick]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_epro_object_property_pick]
GO

-- Create Function [dbo].[fn_epro_object_property_pick]
Print 'Create Function [dbo].[fn_epro_object_property_pick]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_epro_object_property_pick (
	@ps_epro_object varchar(64),
	@pb_display_user_defined bit = 0,
	@ps_property_value_object varchar(24) = NULL)

RETURNS @properties TABLE (
	[property_id] [int] NOT NULL,
	[property_name] [varchar](64) NOT NULL,
	[property_type] [varchar](12) NULL,
	[return_data_type] [varchar](12) NULL,
	[function_name] [varchar](64) NULL,
	[description] [varchar](80) NULL,
	[sort_sequence] [int] NULL
	)
AS

BEGIN


-- First add the properties listed in c_Property where the property type is 'SQL', 'built in', or 'object'
INSERT INTO @properties (
	property_id,
	property_name,
	property_type,
	return_data_type,
	function_name,
	description,
	sort_sequence)   
SELECT p.property_id,
	p.property_name,
	p.property_type,
	p.return_data_type,
	p.function_name,
	p.description,
	p.sort_sequence
FROM c_Property p
WHERE p.epro_object = @ps_epro_object 
AND p.property_type IN ('SQL', 'built in', 'object', 'User Defined')
AND (@pb_display_user_defined = 1 OR p.property_type IN ('SQL', 'built in', 'object'))
AND (@ps_property_value_object IS NULL OR p.property_value_object = @ps_property_value_object)
AND  p.status = 'OK' 



RETURN

END

GO
GRANT SELECT ON [dbo].[fn_epro_object_property_pick] TO [cprsystem]
GO

