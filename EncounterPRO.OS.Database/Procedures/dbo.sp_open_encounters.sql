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

-- Drop Procedure [dbo].[sp_open_encounters]
Print 'Drop Procedure [dbo].[sp_open_encounters]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_open_encounters]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_open_encounters]
GO

-- Create Procedure [dbo].[sp_open_encounters]
Print 'Create Procedure [dbo].[sp_open_encounters]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_open_encounters
	 @ps_office_id varchar(4) = NULL
AS

IF @ps_office_id IS NULL
	SET @ps_office_id = '%'

DECLARE @encounters TABLE (
	[cpr_id] [varchar] (12) NOT NULL ,
	[encounter_id] [int] NOT NULL ,
	[encounter_type] [varchar] (24) NULL ,
	[encounter_date] [datetime] NULL ,
	[encounter_description] [varchar] (80) NULL ,
	[patient_workplan_id] [int] NULL ,
	[patient_location] [varchar] (12) NULL ,
	[attending_doctor] [varchar] (24) NULL ,
	[referring_doctor] [varchar] (24) NULL ,
	[new_flag] [char] (1) NULL ,
	[patient_name] [varchar] (100) NULL ,
	[date_of_birth] [datetime] NULL ,
	[sex] [char] (1) NULL ,
	[room_name] [varchar] (24) NULL ,
	[room_sequence] [smallint] NULL,
	[color] [int] NULL, 
	[document_status] [int] NOT NULL DEFAULT (0)
	)

DECLARE @documents TABLE (
	[cpr_id] [varchar] (12) NOT NULL ,
	[encounter_id] [int] NOT NULL ,
	[patient_workplan_item_id] int NOT NULL ,
	[status] [varchar] (12) NOT NULL
	)

INSERT INTO @encounters (
	[cpr_id] ,
	[encounter_id] ,
	[encounter_type] ,
	[encounter_date] ,
	[encounter_description] ,
	[patient_workplan_id] ,
	[patient_location] ,
	[attending_doctor] ,
	[referring_doctor] ,
	[new_flag] ,
	[patient_name] ,
	[date_of_birth] ,
	[sex] ,
	[room_name] ,
	[room_sequence] ,
	[color] )
SELECT
	 e.cpr_id
	,e.encounter_id
	,e.encounter_type
	,e.encounter_date
	,e.encounter_description
	,e.patient_workplan_id
	,e.patient_location
	,e.attending_doctor
	,e.referring_doctor
	,e.new_flag
	,ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') as patient_name
	,p.date_of_birth
	,p.sex
	,ISNULL( r.room_name, 'Nowhere' ) as room_name
	,ISNULL( r.room_sequence, 9999 ) as room_sequence
	,u.color
FROM p_Patient_Encounter  e WITH (NOLOCK)
INNER JOIN p_Patient p WITH (NOLOCK)
ON 	e.cpr_id = p.cpr_id
LEFT OUTER JOIN o_Rooms r WITH (NOLOCK)
ON 	e.patient_location = r.room_id
LEFT OUTER JOIN c_User u WITH (NOLOCK)
ON 	e.attending_doctor = u.user_id
WHERE
	e.encounter_status = 'OPEN'
AND 	e.office_id LIKE @ps_office_id

--
-- document_status:
--		0 = No documents
--		1 = Documents, but all are sent or cancelled
--		2 = Documents, at least one has not been sent
--
--	,dbo.fn_patient_object_document_status(e.cpr_id, 'Encounter', e.encounter_id) as document_status

INSERT INTO @documents (
	[cpr_id] ,
	[encounter_id] ,
	[patient_workplan_item_id] ,
	[status] )
SELECT i.cpr_id ,
	i.encounter_id ,
	i.patient_workplan_item_id ,
	i.status
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN @encounters e
	ON i.cpr_id = e.cpr_id
	AND i.encounter_id = e.encounter_id
WHERE i.item_type = 'Document'
AND i.status IS NOT NULL
AND i.status <> 'Cancelled'

UPDATE e
SET document_status = 1
FROM @encounters e
	INNER JOIN @documents d
	ON e.cpr_id = d.cpr_id
	AND e.encounter_id = d.encounter_id
	
UPDATE e
SET document_status = 2
FROM @encounters e
	INNER JOIN @documents d
	ON e.cpr_id = d.cpr_id
	AND e.encounter_id = d.encounter_id
WHERE d.status IN ('Ordered', 'Created', 'Error')


SELECT cpr_id ,
	encounter_id ,
	encounter_type ,
	encounter_date ,
	encounter_description ,
	patient_workplan_id ,
	patient_location ,
	attending_doctor ,
	referring_doctor ,
	new_flag ,
	patient_name ,
	date_of_birth ,
	sex ,
	room_name ,
	room_sequence ,
	color,
	document_status
FROM @encounters

GO
GRANT EXECUTE
	ON [dbo].[sp_open_encounters]
	TO [cprsystem]
GO

