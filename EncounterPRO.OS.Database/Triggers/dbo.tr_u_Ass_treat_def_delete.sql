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

-- Drop Trigger [dbo].[tr_u_Ass_treat_def_delete]
Print 'Drop Trigger [dbo].[tr_u_Ass_treat_def_delete]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_u_Ass_treat_def_delete]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_u_Ass_treat_def_delete]
GO

-- Create Trigger [dbo].[tr_u_Ass_treat_def_delete]
Print 'Create Trigger [dbo].[tr_u_Ass_treat_def_delete]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_u_Ass_treat_def_delete ON dbo.u_Assessment_treat_definition
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_xml varchar(8000),
		@ll_definition_id int,
		@ls_message varchar(255)

DECLARE lc_deleted CURSOR LOCAL FAST_FORWARD FOR
	SELECT definition_id
	FROM deleted

OPEN lc_deleted

FETCH lc_deleted INTO @ll_definition_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_xml = (	SELECT '<deleted'
						+ ' definition_id="' + CAST(definition_id AS varchar(12)) + '"'
						+ ' assessment_id="' + ISNULL(assessment_id, '') + '"'
						+ ' treatment_type="' + ISNULL(treatment_type, '') + '"'
						+ ' treatment_description="' + ISNULL(treatment_description, '') + '"'
						+ ' workplan_id="' + ISNULL(CAST(workplan_id AS varchar(24)), '') + '"'
						+ ' followup_workplan_id="' + ISNULL(CAST(followup_workplan_id AS varchar(24)), '') + '"'
						+ ' user_id="' + ISNULL(user_id, '') + '"'
						+ ' sort_sequence="' + ISNULL(CAST(sort_sequence AS varchar(24)), '') + '"'
						+ ' instructions="' + ISNULL(instructions, '') + '"'
						+ ' parent_definition_id="' + ISNULL(CAST(parent_definition_id AS varchar(24)), '') + '"'
						+ ' child_flag="' + ISNULL(child_flag, '') + '"'
						+ ' created="' + CAST(created AS varchar(24)) + '"'
						+ ' />'
					FROM deleted 
					WHERE definition_id = @ll_definition_id )

	SELECT @ls_message = CAST(ISNULL(icd_9_code, '') + ' : ' + a.description + ' - ' + d.treatment_description AS varchar(255))
	FROM deleted d
		INNER JOIN c_Assessment_Definition a
		ON d.assessment_id = a.assessment_id
	WHERE definition_id = @ll_definition_id

	EXECUTE jmj_new_log_message
		@ps_severity = 'WARNING',
		@ps_caller = 'u_Assessment_Treat_Definition',
		@ps_script = 'DELETE Trigger',
		@ps_message = @ls_message,
		@ps_log_data = @ls_xml

	FETCH lc_deleted INTO @ll_definition_id
	END

CLOSE lc_deleted
DEALLOCATE lc_deleted

-- Delete attributes
DELETE FROM u_Assessment_treat_def_attrib
FROM deleted
WHERE deleted.definition_id = u_Assessment_treat_def_attrib.definition_id

-- Delete the children
DELETE d
FROM u_Assessment_treat_definition d
	INNER JOIN deleted x
	ON d.parent_definition_id = x.definition_id

GO

