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

-- Drop Procedure [dbo].[sp_get_objects_since_last_encounter]
Print 'Drop Procedure [dbo].[sp_get_objects_since_last_encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_objects_since_last_encounter]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_objects_since_last_encounter]
GO

-- Create Procedure [dbo].[sp_get_objects_since_last_encounter]
Print 'Create Procedure [dbo].[sp_get_objects_since_last_encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_objects_since_last_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS

DECLARE @ldt_begin_date datetime,
		@ldt_last_begin_date datetime,
		@ldt_end_date datetime,
		@ll_last_encounter_id int

DECLARE @objects TABLE (
	cpr_id varchar(12) NOT NULL,
	context_object varchar(24) NOT NULL,
	object_key int NOT NULL,
	object_type varchar(24) NOT NULL,
	progress_sequence int NOT NULL,
	description varchar(255) NOT NULL,
	progress_type varchar(24) NOT NULL,
	progress varchar(128) NULL,
	progress_attachment_id int NULL,
	progress_current_flag char(1) NOT NULL,
	progress_created datetime NOT NULL)

DECLARE @objects_first_touch TABLE (
	cpr_id varchar(12) NOT NULL,
	context_object varchar(24) NOT NULL,
	object_key int NOT NULL,
	progress_sequence int NOT NULL )

SELECT 	@ldt_end_date = DATEADD(second, -1, created)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

SELECT 	@ll_last_encounter_id = max(encounter_id)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id < @pl_encounter_id
AND indirect_flag = 'D'

IF @ll_last_encounter_id IS NULL
	SET @ldt_begin_date = '1/1/1900'
ELSE
	BEGIN
	SELECT 	@ldt_begin_date = DATEADD(second, 1, discharge_date),
			@ldt_last_begin_date = encounter_date
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_last_encounter_id

	-- If the previous encounter is still open then use
	-- one hour after it was opened as the effective end_date
	IF @ldt_begin_date IS NULL 
		SET @ldt_begin_date = DATEADD(hour, 1, @ldt_last_begin_date)
	END



INSERT INTO @objects (
	cpr_id ,
	context_object ,
	object_key ,
	object_type ,
	progress_sequence ,
	description ,
	progress_type ,
	progress ,
	progress_attachment_id ,
	progress_current_flag ,
	progress_created )
SELECT cpr_id ,
	context_object ,
	object_key ,
	object_type ,
	progress_sequence ,
	COALESCE(description, context_object + ' ' + COALESCE(object_type, '') ) ,
	progress_type ,
	progress ,
	progress_attachment_id ,
	progress_current_flag ,
	progress_created
FROM dbo.fn_patient_object_progress(@ps_cpr_id, @ldt_begin_date, @ldt_end_date)

INSERT INTO @objects_first_touch (
	cpr_id ,
	context_object ,
	object_key ,
	progress_sequence )
SELECT o.cpr_id ,
	o.context_object ,
	o.object_key ,
	min(o.progress_sequence) as progress_sequence
FROM @objects o
	INNER JOIN (SELECT cpr_id ,
						context_object ,
						object_key ,
						min(progress_created) as first_touched
					FROM @objects
					WHERE progress_attachment_id IS NULL
					GROUP BY cpr_id, context_object, object_key ) f
	ON o.cpr_id = f.cpr_id
	AND o.context_object = f.context_object
	AND o.object_key = f.object_key
	AND o.progress_created = f.first_touched
	AND o.progress_attachment_id IS NULL
GROUP BY o.cpr_id ,
	o.context_object ,
	o.object_key

SELECT o.cpr_id ,
		o.context_object ,
		o.object_key ,
		o.object_type ,
		o.progress_sequence ,
		o.description ,
		o.progress_type ,
		o.progress ,
		o.progress_attachment_id ,
		CAST(NULL as varchar(24)) as attachment_extension ,
		o.progress_current_flag ,
		o.progress_created
FROM @objects o
	INNER JOIN @objects_first_touch f
	ON o.cpr_id = f.cpr_id
	AND o.context_object = f.context_object
	AND o.object_key = f.object_key
	AND o.progress_sequence = f.progress_sequence
UNION
SELECT o.cpr_id ,
		o.context_object ,
		o.object_key ,
		o.object_type ,
		o.progress_sequence ,
		o.description ,
		o.progress_type ,
		o.progress ,
		o.progress_attachment_id ,
		a.extension as attachment_extension ,
		o.progress_current_flag ,
		o.progress_created
FROM @objects o
	INNER JOIN p_Attachment a
	ON o.cpr_id = a.cpr_id
	AND o.progress_attachment_id = a.attachment_id
WHERE progress_attachment_id IS NOT NULL
AND progress_current_flag = 'Y'
ORDER BY progress_created

GO
GRANT EXECUTE
	ON [dbo].[sp_get_objects_since_last_encounter]
	TO [cprsystem]
GO

