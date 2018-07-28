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

-- Drop Procedure [dbo].[sp_workplan_search]
Print 'Drop Procedure [dbo].[sp_workplan_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_workplan_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_workplan_search]
GO

-- Create Procedure [dbo].[sp_workplan_search]
Print 'Create Procedure [dbo].[sp_workplan_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_workplan_search (
	@ps_workplan_type varchar(24),
	@ps_workplan_category_id varchar(24) = NULL,
	@ps_in_office_flag char(1) = NULL,
	@ps_treatment_type varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_in_office_flag IS NULL
	SELECT @ps_in_office_flag = '%'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_workplan_category_id IS NULL
	SELECT @ps_workplan_category_id = '%'

IF @ps_treatment_type IS NULL
	SELECT @ps_treatment_type = '%'

IF @ps_specialty_id IS NULL
	SELECT a.workplan_id,
		a.workplan_type,
		a.treatment_type,
		a.description,
		a.in_office_flag,
		'b_icon18.bmp',
		selected_flag=0
	FROM c_Workplan a
	WHERE a.workplan_type = @ps_workplan_type
	AND a.description like @ps_description
	AND (a.treatment_type like @ps_treatment_type OR a.treatment_type is NULL OR a.treatment_type = '')
	AND a.in_office_flag like @ps_in_office_flag
	AND a.status = 'OK'
	ORDER BY a.description
ELSE
	SELECT a.workplan_id,
		a.workplan_type,
		a.treatment_type,
		a.description,
		a.in_office_flag,
		'b_icon18.bmp',
		selected_flag=0
	FROM c_Workplan a
	WHERE a.workplan_type = @ps_workplan_type
	AND a.description like @ps_description
	AND (a.treatment_type like @ps_treatment_type OR a.treatment_type is NULL OR a.treatment_type = '')
	AND a.in_office_flag like @ps_in_office_flag
	AND a.specialty_id = @ps_specialty_id
	AND a.status = 'OK'
	ORDER BY a.description

GO
GRANT EXECUTE
	ON [dbo].[sp_workplan_search]
	TO [cprsystem]
GO

