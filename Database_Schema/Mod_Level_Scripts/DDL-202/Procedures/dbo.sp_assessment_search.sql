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

-- Drop Procedure [dbo].[sp_assessment_search]
Print 'Drop Procedure [dbo].[sp_assessment_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_search]
GO

-- Create Procedure [dbo].[sp_assessment_search]
Print 'Create Procedure [dbo].[sp_assessment_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_assessment_search (
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_icd_code varchar(24) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_assessment_type IS NULL
	SELECT @ps_assessment_type = '%'

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_assessment_category_id = '%'
	SET @ps_assessment_category_id = NULL

IF @ps_icd_code IS NULL
	SELECT @ps_icd_code = '%'

IF @ps_specialty_id IS NULL
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd10_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd10_code like @ps_icd_code OR a.icd10_code is null)
ELSE
	SELECT a.assessment_id,
		a.assessment_type,
		a.assessment_category_id,
		a.description,
		a.auto_close,
		a.icd10_code,
		a.status,
		a.auto_close_interval_amount,
		a.auto_close_interval_unit,
		t.icon_open,
		selected_flag=0
	FROM c_Assessment_Definition a WITH (NOLOCK)
	INNER JOIN c_Common_Assessment c WITH (NOLOCK)
		ON a.assessment_id = c.assessment_id
	INNER JOIN c_Assessment_Type t WITH (NOLOCK)
		ON a.assessment_type = t.assessment_type
	WHERE a.assessment_type like @ps_assessment_type
	AND c.specialty_id = @ps_specialty_id
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_assessment_category_id IS NULL OR a.assessment_category_id = @ps_assessment_category_id)
	AND (a.icd10_code like @ps_icd_code OR a.icd10_code is null)

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_search]
	TO [cprsystem]
GO

