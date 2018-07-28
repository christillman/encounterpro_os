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

-- Drop Procedure [dbo].[sp_drug_search]
Print 'Drop Procedure [dbo].[sp_drug_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_drug_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_drug_search]
GO

-- Create Procedure [dbo].[sp_drug_search]
Print 'Create Procedure [dbo].[sp_drug_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_drug_search (
	@ps_drug_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_generic_name varchar(40) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_drug_type varchar(24) = NULL )
AS

DECLARE @ls_drug_flag char(1)

SET @ls_drug_flag = '%'

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_description IS NULL
	SET @ps_description = '%'

IF @ps_generic_name IS NULL
	SET @ps_generic_name = '%'

IF @ps_drug_category_id IS NULL
	SET @ps_drug_category_id = '%'

-- Check for the special drug type "Drug" which really means drug_flag='Y'
-- For backward compatibility, also check for the special code '%Drug'
IF @ps_drug_type = 'Drug' OR @ps_drug_type LIKE '%Drug'
	BEGIN
	SET @ps_drug_type = '%'
	SET @ls_drug_flag = 'Y'
	END

IF @ps_drug_type IS NULL
	SET @ps_drug_type = '%'

IF @ps_specialty_id IS NULL
	IF @ps_drug_category_id = '%' -- drugs in all category plus null category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			LEFT OUTER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
	ELSE -- drugs in specific category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			INNER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
ELSE
	IF @ps_drug_category_id = '%' -- to includes drugs with no category with left outer join
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			LEFT OUTER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
			INNER JOIN c_Common_Drug cd
			ON a.drug_id = cd.drug_id
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND cd.specialty_id = @ps_specialty_id
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
	ELSE -- drugs in specific category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			INNER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
			INNER JOIN c_Common_Drug cd
			ON a.drug_id = cd.drug_id
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND cd.specialty_id = @ps_specialty_id
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id	
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END


GO
GRANT EXECUTE
	ON [dbo].[sp_drug_search]
	TO [cprsystem]
GO

