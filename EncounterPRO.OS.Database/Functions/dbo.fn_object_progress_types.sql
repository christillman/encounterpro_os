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

-- Drop Function [dbo].[fn_object_progress_types]
Print 'Drop Function [dbo].[fn_object_progress_types]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_object_progress_types]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_object_progress_types]
GO

-- Create Function [dbo].[fn_object_progress_types]
Print 'Create Function [dbo].[fn_object_progress_types]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_object_progress_types ()

RETURNS @progress_type TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	progress_type varchar(24) NOT NULL,
	display_flag char(1) NOT NULL DEFAULT ('Y'),
	display_style varchar(24) NULL,
	soap_display_style varchar(24) NULL,
	progress_key_required_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_enumerated_flag char(1) NOT NULL DEFAULT ('N'),
	progress_key_object varchar(24) NULL,
	sort_sequence int NULL
	)

AS

BEGIN


--------------------------------------------------------
-- Patient Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		'Patient' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Patient'

--------------------------------------------------------
-- Encounter Specific Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Encounter' ,
		pt.encounter_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Encounter_Type_Progress_Type pt

--------------------------------------------------------
-- Encounter Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		e.encounter_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Encounter_Type e
WHERE d.context_object = 'Encounter'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = e.encounter_type
	AND p.progress_type = d.progress_type)


--------------------------------------------------------
-- Assessment Specific Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Assessment' ,
		pt.assessment_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Assessment_Type_Progress_Type pt

--------------------------------------------------------
-- Assessment Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		a.assessment_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Assessment_Type a
WHERE d.context_object = 'Assessment'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = a.assessment_type
	AND p.progress_type = d.progress_type)


--------------------------------------------------------
-- Treatment Specific Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	'Treatment' ,
		pt.treatment_type ,
		pt.progress_type ,
		ISNULL(pt.display_flag, 'N') ,
		pt.display_style ,
		pt.soap_display_style ,
		ISNULL(pt.progress_key_required_flag, 'N') ,
		ISNULL(pt.progress_key_enumerated_flag, 'N') ,
		pt.progress_key_object ,
		pt.sort_sequence 
FROM c_Treatment_Type_Progress_Type pt


--------------------------------------------------------
-- Treatment Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		t.treatment_type ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
	CROSS JOIN c_Treatment_Type t
WHERE d.context_object = 'Treatment'
AND NOT EXISTS (
	SELECT 1
	FROM @progress_type p
	WHERE p.context_object = d.context_object
	AND p.context_object_type = t.treatment_type
	AND p.progress_type = d.progress_type)





--------------------------------------------------------
-- Observation Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		'Observation' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Observation'


--------------------------------------------------------
-- Attachment Default Progress Types
--------------------------------------------------------
INSERT INTO @progress_type (	
	context_object,
	context_object_type,
	progress_type ,
	display_flag ,
	display_style ,
	soap_display_style ,
	progress_key_required_flag ,
	progress_key_enumerated_flag ,
	progress_key_object ,
	sort_sequence )
SELECT	d.context_object ,
		'Attachment' ,
		d.progress_type ,
		ISNULL(d.display_flag, 'N') ,
		d.display_style ,
		d.soap_display_style ,
		ISNULL(d.progress_key_required_flag, 'N') ,
		ISNULL(d.progress_key_enumerated_flag, 'N') ,
		d.progress_key_object ,
		d.sort_sequence 
FROM c_Object_Default_Progress_Type d
WHERE d.context_object = 'Attachment'




RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_object_progress_types]
	TO [cprsystem]
GO

