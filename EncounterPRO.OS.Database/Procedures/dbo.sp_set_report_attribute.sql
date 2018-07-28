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

-- Drop Procedure [dbo].[sp_set_report_attribute]
Print 'Drop Procedure [dbo].[sp_set_report_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_report_attribute]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_report_attribute]
GO

-- Create Procedure [dbo].[sp_set_report_attribute]
Print 'Create Procedure [dbo].[sp_set_report_attribute]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_set_report_attribute    Script Date: 7/25/2000 8:44:08 AM ******/
CREATE PROCEDURE dbo.sp_set_report_attribute (
	@pui_report_id varchar(40),
	@ps_attribute varchar(64),
	@ps_value varchar(255) = NULL,
	@ps_component_id varchar(40) = NULL)
AS

DECLARE @ls_component_attribute char(1),
		@ll_rowcount int,
		@ll_error int,
		@lui_component_id uniqueidentifier,
		@lui_report_id uniqueidentifier,
		@ll_attribute_sequence int

SET @lui_report_id = CAST(@pui_report_id AS uniqueidentifier)

IF @ps_component_id IS NULL
	BEGIN
	SET @ls_component_attribute = 'N'
	SET @lui_component_id = NULL
	END
ELSE
	BEGIN
	SET @ls_component_attribute = 'Y'

	-- If the length is greater than 24 then assume it's already the component guid
	
	IF LEN(@ps_component_id) > 24
		BEGIN
		SET @lui_component_id = CAST(@ps_component_id AS uniqueidentifier)
		SELECT @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN
		END
	ELSE
		BEGIN
		SELECT @lui_component_id = id
		FROM c_Component_Registry
		WHERE component_id = @ps_component_id

		SELECT @ll_error = @@ERROR,
				@ll_rowcount = @@ROWCOUNT

		IF @ll_error <> 0
			RETURN

		IF @ll_rowcount = 0
			BEGIN
			RAISERROR ('Cannot find component (%s)',16,-1, @ps_component_id)
			RETURN 0
			END

		END

	END

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM c_Report_Attribute
WHERE report_id = @lui_report_id
AND attribute = @ps_attribute
AND (component_id = @lui_component_id
	OR (component_id IS NULL AND @lui_component_id IS NULL)
	)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_attribute_sequence IS NULL
	BEGIN
	INSERT INTO c_Report_Attribute (
		report_id,
		attribute,
		value,
		component_attribute,
		component_id)
	VALUES (
		@lui_report_id,
		@ps_attribute,
		@ps_value,
		@ls_component_attribute,
		@lui_component_id)

	SET @ll_attribute_sequence = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
	UPDATE c_Report_Attribute
	SET value = @ps_value
	WHERE report_id = @lui_report_id
	AND attribute_sequence = @ll_attribute_sequence
	END

RETURN @ll_attribute_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_set_report_attribute]
	TO [cprsystem]
GO

