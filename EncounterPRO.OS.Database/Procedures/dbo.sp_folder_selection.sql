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

-- Drop Procedure [dbo].[sp_folder_selection]
Print 'Drop Procedure [dbo].[sp_folder_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_folder_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_folder_selection]
GO

-- Create Procedure [dbo].[sp_folder_selection]
Print 'Create Procedure [dbo].[sp_folder_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_folder_selection (
	@ps_context_object varchar(24) = NULL,
	@ps_context_object_type varchar(40) = NULL,
	@ps_attachment_type varchar(24) = NULL,
	@ps_extension varchar(24) = NULL )
AS

DECLARE @folders TABLE (
	folder varchar(40) NOT NULL,
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NULL,
	description varchar(255) NULL,
	status varchar(12) NOT NULL,
	workplan_required_flag char(1) NOT NULL,
	sort_sequence int NULL,
	auto_select_flag char(1) NOT NULL,
	selected_flag int NOT NULL)

INSERT INTO @folders (
	folder,
	context_object,
	context_object_type,
	description,
	status,
	workplan_required_flag,
	sort_sequence,
	auto_select_flag,
	selected_flag )
SELECT f.folder,
	f.context_object,
	f.context_object_type,
	f.description,
	f.status,
	f.workplan_required_flag,
	min(s.sort_sequence) as sort_sequence,
	max(s.auto_select_flag) as auto_select_flag,
	max(0) as selected_flag
FROM c_Folder f
	INNER JOIN c_Folder_Selection s
	ON f.folder = s.folder
WHERE s.context_object = @ps_context_object
AND (s.context_object_type IS NULL OR s.context_object_type = @ps_context_object_type)
AND (s.attachment_type IS NULL OR s.attachment_type = @ps_attachment_type)
AND (s.extension IS NULL OR s.extension = @ps_extension)
AND (f.status = 'OK' OR s.auto_select_flag = 'Y')
GROUP BY f.folder,
	f.context_object,
	f.context_object_type,
	f.description,
	f.status,
	f.workplan_required_flag

-- If we didn't find any, the show the associated folders, but don't show anything for signatures
IF @@ROWCOUNT <= 0 AND @ps_attachment_type <> 'SIGNATURE'
	IF @ps_context_object = 'Patient'
		INSERT INTO @folders (
			folder,
			context_object,
			context_object_type,
			description,
			status,
			workplan_required_flag,
			sort_sequence,
			auto_select_flag,
			selected_flag )
		SELECT f.folder,
			f.context_object,
			f.context_object_type,
			f.description,
			f.status,
			f.workplan_required_flag,
			f.sort_sequence,
			'N' as auto_select_flag,
			0 as selected_flag
		FROM c_Folder f
		WHERE f.status = 'OK'
	ELSE
		INSERT INTO @folders (
			folder,
			context_object,
			context_object_type,
			description,
			status,
			workplan_required_flag,
			sort_sequence,
			auto_select_flag,
			selected_flag )
		SELECT f.folder,
			f.context_object,
			f.context_object_type,
			f.description,
			f.status,
			f.workplan_required_flag,
			f.sort_sequence,
			'N' as auto_select_flag,
			0 as selected_flag
		FROM c_Folder f
		WHERE f.status = 'OK'
		AND f.context_object = @ps_context_object
		AND ISNULL(f.context_object_type, @ps_context_object_type) = @ps_context_object_type

-- Get the folders as a result set
SELECT folder,
	context_object,
	context_object_type,
	description,
	status,
	workplan_required_flag,
	sort_sequence,
	auto_select_flag,
	selected_flag
FROM @folders


GO
GRANT EXECUTE
	ON [dbo].[sp_folder_selection]
	TO [cprsystem]
GO

