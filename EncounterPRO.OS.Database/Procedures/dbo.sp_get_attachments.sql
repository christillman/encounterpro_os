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

-- Drop Procedure [dbo].[sp_get_attachments]
Print 'Drop Procedure [dbo].[sp_get_attachments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_attachments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_attachments]
GO

-- Create Procedure [dbo].[sp_get_attachments]
Print 'Create Procedure [dbo].[sp_get_attachments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_attachments (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)
AS

IF @ps_context_object = 'Patient'
	BEGIN
	SELECT u.user_full_name,   
			at.button,   
			a.attachment_id,   
			a.attachment_tag,   
			a.attachment_text,   
			a.created,  
			a.attachment_folder,
			a.attachment_type,
			a.attached_by,
			ISNULL(pp.progress_type, 'Attachment'),
			pp.progress_key,
			a.attachment_date,   
			selected_flag = 0,
			a.extension,
			f.status AS folder_status,
			DATALENGTH(a.attachment_image) as attachment_length
	FROM p_Attachment a
		INNER JOIN c_Attachment_Type at
		ON a.attachment_type = at.attachment_type
		INNER JOIN c_User u
		ON a.created_by = u.user_id
		LEFT OUTER JOIN p_Patient_Progress pp
		ON a.cpr_id = pp.cpr_id
		AND a.attachment_id = pp.attachment_id
		AND pp.current_flag = 'Y'
		LEFT OUTER JOIN c_Folder f
		ON a.attachment_folder = f.folder
	WHERE a.status = 'OK'
	AND a.cpr_id = @ps_cpr_id
	ORDER BY a.created desc
	END
ELSE
	BEGIN
	SELECT u.user_full_name,   
			at.button,   
			a.attachment_id,   
			a.attachment_tag,   
			a.attachment_text,   
			a.created,
			a.attachment_folder,
			a.attachment_type,
			p.user_id,
			p.progress_type,
			p.progress_key,
			p.progress_date_time,   
			selected_flag=0,
			a.extension,
			f.status AS folder_status,
			DATALENGTH(a.attachment_image) as attachment_length
	FROM dbo.fn_progress(@ps_cpr_id , @ps_context_object, @pl_object_key, NULL, NULL, 'Y') p
		INNER JOIN c_User u
		ON p.user_id = u.user_id
		INNER JOIN p_Attachment a
		ON a.cpr_id = p.cpr_id
		AND a.attachment_id = p.attachment_id
		INNER JOIN c_Attachment_Type at
		ON a.attachment_type = at.attachment_type
		LEFT OUTER JOIN c_Folder f
		ON a.attachment_folder = f.folder
	WHERE a.status = 'OK'
	AND a.cpr_id = @ps_cpr_id
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_get_attachments]
	TO [cprsystem]
GO

