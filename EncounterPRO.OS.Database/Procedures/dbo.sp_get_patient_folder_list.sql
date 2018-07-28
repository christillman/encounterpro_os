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

-- Drop Procedure [dbo].[sp_get_patient_folder_list]
Print 'Drop Procedure [dbo].[sp_get_patient_folder_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_patient_folder_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_patient_folder_list]
GO

-- Create Procedure [dbo].[sp_get_patient_folder_list]
Print 'Create Procedure [dbo].[sp_get_patient_folder_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_patient_folder_list (
	@ps_cpr_id varchar(12) )
AS

DECLARE @folders TABLE (
	[folder] [varchar] (40) NOT NULL ,
	[context_object] [varchar] (50) NOT NULL ,
	[description] [varchar] (255) NOT NULL ,
	[status] [varchar] (12) NOT NULL ,
	[sort_sequence] [int] NULL ,
	[id] [varchar] (36) NOT NULL,
	[object_count] [int] NOT NULL DEFAULT (0) )

INSERT INTO @folders (
	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	[id] )
SELECT 
	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	CAST([id] as varchar(36))
FROM c_Folder
WHERE context_object IS NOT NULL
AND context_object <> 'General'
AND status = 'OK'

IF @ps_cpr_id IS NOT NULL
	UPDATE f
	SET object_count = a.attachment_count
	FROM @folders f
		INNER JOIN (
					SELECT a.attachment_folder, count(*) as attachment_count
					FROM p_Attachment a
						LEFT OUTER JOIN p_Patient_Progress pp
						ON a.cpr_id = pp.cpr_id
						AND a.attachment_id = pp.attachment_id
						AND pp.current_flag = 'Y'
					WHERE a.status = 'OK'
					AND a.cpr_id = @ps_cpr_id
					AND a.attachment_type <> 'Signature'
					GROUP BY a.attachment_folder ) a
		ON f.folder = a.attachment_folder

SELECT 	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	[id],
	[object_count],
	selected_flag=0
FROM @folders

GO
GRANT EXECUTE
	ON [dbo].[sp_get_patient_folder_list]
	TO [cprsystem]
GO

