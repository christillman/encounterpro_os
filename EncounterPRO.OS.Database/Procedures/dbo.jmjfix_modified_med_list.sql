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

-- Drop Procedure [dbo].[jmjfix_modified_med_list]
Print 'Drop Procedure [dbo].[jmjfix_modified_med_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjfix_modified_med_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjfix_modified_med_list]
GO

-- Create Procedure [dbo].[jmjfix_modified_med_list]
Print 'Create Procedure [dbo].[jmjfix_modified_med_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[jmjfix_modified_med_list]
AS

DECLARE @modified TABLE (
 cpr_id varchar(12) NOT NULL,
 billing_id varchar(24) NULL,
 original_treatment_id int NOT NULL,
 modified_treatment_id int NOT NULL,
 original_date datetime NOT NULL,
 modified_date datetime NOT NULL,
 original_treatment_description varchar(1024) NULL,
 modified_treatment_description varchar(1024) NULL,
 modified_description_count int NULL)

INSERT INTO @modified (
 cpr_id ,
 original_treatment_id ,
 modified_treatment_id ,
 original_date,
 modified_date )
SELECT t1.cpr_id ,
 t2.treatment_id ,
 t1.treatment_id ,
 t2.begin_date,
 t1.begin_date
FROM p_Treatment_Item t1 WITH (NOLOCK)
 INNER JOIN p_Treatment_Item t2 WITH (NOLOCK)
 ON t1.cpr_id = t2.cpr_id
 AND t1.original_treatment_id = t2.treatment_id
WHERE t1.treatment_type = 'MEDICATION'

UPDATE x
SET modified_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024))),
	modified_description_count = y.modified_description_count
FROM @modified x
	INNER JOIN (SELECT cpr_id,
						treatment_id,
						max(treatment_progress_sequence) as treatment_progress_sequence,
						count(treatment_progress_sequence) as modified_description_count
				FROM p_Treatment_Progress WITH (NOLOCK)
				WHERE progress_type = 'Modify'
				AND progress_key = 'treatment_description'
				AND current_flag = 'Y'
				GROUP BY cpr_id, treatment_id) y
	ON x.cpr_id = y.cpr_id
	AND x.modified_treatment_id = y.treatment_id
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id
	AND x.modified_treatment_id = p.treatment_id
	AND y.treatment_progress_sequence = p.treatment_progress_sequence

UPDATE x
SET original_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024)))
FROM @modified x
	INNER JOIN (SELECT cpr_id, treatment_id, max(treatment_progress_sequence) as treatment_progress_sequence
				FROM p_Treatment_Progress WITH (NOLOCK)
				WHERE progress_type = 'Modify'
				AND progress_key = 'treatment_description'
				AND current_flag = 'Y'
				GROUP BY cpr_id, treatment_id) y
	ON x.cpr_id = y.cpr_id
	AND x.original_treatment_id = y.treatment_id
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id
	AND x.original_treatment_id = p.treatment_id
	AND y.treatment_progress_sequence = p.treatment_progress_sequence

DECLARE @ldt_migration_date datetime

SELECT @ldt_migration_date = max(l.executed_date_time)
FROM c_Database_Script_Log l
	INNER JOIN c_Database_Script s
	ON l.script_id = s.script_id
WHERE s.script_type = 'Migration24'

DECLARE @wrongdesc TABLE (
	cpr_id varchar(12) NOT NULL,
	billing_id varchar(24) NULL,
	treatment_id int NOT NULL,
	begin_date datetime NOT NULL,
	treatment_description varchar(80) NULL,
	common_name varchar(80) NOT NULL,
	left_desc varchar(80) NULL)

IF @ldt_migration_date IS NOT NULL
	INSERT INTO @wrongdesc (
		cpr_id ,
		billing_id ,
		treatment_id ,
		begin_date ,
		treatment_description,
		common_name )
	SELECT t.cpr_id ,
		COALESCE(p.billing_id, t.cpr_id) as billing_id ,
		t.treatment_id ,
		t.begin_date datetime ,
		t.treatment_description ,
		d.common_name
	FROM p_Treatment_Item t WITH (NOLOCK)
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN c_Drug_Definition d WITH (NOLOCK)
		ON t.drug_id = d.drug_id
	WHERE t.treatment_type = 'MEDICATION'
	AND t.treatment_description NOT LIKE d.common_name + '%'
	AND t.begin_date < @ldt_migration_date
	AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
	AND d.common_name IS NOT NULL

UPDATE @wrongdesc
SET left_desc = RTRIM(LEFT(treatment_description, CHARINDEX(',', treatment_description) - 1))
WHERE CHARINDEX(',', treatment_description) > 0



-- Get the modified treatments that appear to have the wrong treatment_description, and
-- Add the medication treatments that appear incomplete.
SELECT cpr_id ,
	COALESCE(billing_id, cpr_id) as billing_id ,
	original_treatment_id ,
	modified_treatment_id ,
	original_date ,
	modified_date ,
	original_treatment_description
FROM @modified
WHERE original_treatment_description = modified_treatment_description
AND modified_description_count = 1
UNION
SELECT i.cpr_id ,
	COALESCE(pp.billing_id, i.cpr_id) as billing_id ,
	i.treatment_id as original_treatment_id,
	i.treatment_id as modified_treatment_id,
	begin_date as original_date ,
	begin_date as modified_date ,
	treatment_description as original_treatment_description
FROM p_Treatment_Item i WITH (NOLOCK)
	INNER JOIN p_Patient pp WITH (NOLOCK)
	ON i.cpr_id = pp.cpr_id
WHERE LEN(treatment_description) >= 78
AND PATINDEX('%refill%', treatment_description) = 0
AND refills <> 0
AND treatment_type = 'MEDICATION'
AND NOT EXISTS (
	SELECT 1
	FROM p_Treatment_Progress p WITH (NOLOCK)
	WHERE i.cpr_id = p.cpr_id
	AND i.treatment_id = p.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description')
UNION
SELECT w.cpr_id ,
	w.billing_id ,
	w.treatment_id as original_treatment_id,
	w.treatment_id as modified_treatment_id,
	w.begin_date as original_date ,
	w.begin_date as modified_date ,
	w.treatment_description as original_treatment_description
FROM @wrongdesc w
WHERE w.common_name NOT LIKE w.left_desc + '%'
AND NOT EXISTS (
	SELECT 1
	FROM p_Treatment_Progress p WITH (NOLOCK)
	WHERE w.cpr_id = p.cpr_id
	AND w.treatment_id = p.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description')

GO
GRANT EXECUTE
	ON [dbo].[jmjfix_modified_med_list]
	TO [cprsystem]
GO

