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

-- Drop Procedure [dbo].[sp_open_encounters_in_room_type]
Print 'Drop Procedure [dbo].[sp_open_encounters_in_room_type]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_open_encounters_in_room_type]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_open_encounters_in_room_type]
GO

-- Create Procedure [dbo].[sp_open_encounters_in_room_type]
Print 'Create Procedure [dbo].[sp_open_encounters_in_room_type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE    PROCEDURE sp_open_encounters_in_room_type
	@ps_office_id varchar(4),
	@ps_room_type varchar(24) = NULL
AS

DECLARE @open_encounters TABLE (
	cpr_id varchar(12) NOT NULL ,
	encounter_id int NOT NULL ,
	encounter_type varchar(24) NULL,
	encounter_date datetime NULL,
	encounter_description varchar(80) NULL,
	patient_workplan_id int NULL,
	patient_location varchar(12) NOT NULL,
	attending_doctor varchar(24) NULL,
	dispatch_date datetime NULL,
	alert_count int  NULL,
	room_name varchar(24) NULL,
	room_sequence smallint NULL,
	color INT NULL,
	date_of_birth datetime NULL,
	sex VARCHAR (1),
	patient_name VARCHAR (80) NOT NULL,
	patient_age varchar(12) NULL
)

SET @ps_room_type = COALESCE(@ps_room_type, '%')
SET @ps_office_id = COALESCE(@ps_office_id, '%')

INSERT INTO @open_encounters 
(
	cpr_id ,
	encounter_id ,
	encounter_type ,
	encounter_date ,
	encounter_description ,
	patient_workplan_id ,
	patient_location ,
	attending_doctor,
	dispatch_date,
	alert_count,
	room_name,
	room_sequence,
	color,
	date_of_birth,
	sex,
	patient_name,
	patient_age
)
SELECT 	e.cpr_id ,
	e.encounter_id ,
	e.encounter_type ,
	e.encounter_date ,
	e.encounter_description ,
	e.patient_workplan_id ,
	e.patient_location ,
	e.attending_doctor,
	NULL,
	NULL,
	r.room_name,
	r.room_sequence,
	u.color,
	p.date_of_birth,
	p.sex,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	dbo.fn_pretty_age(p.date_of_birth, dbo.get_client_datetime())
FROM p_Patient_Encounter e WITH (NOLOCK)
INNER JOIN o_Rooms r WITH (NOLOCK)
ON e.patient_location = r.room_id
INNER JOIN p_Patient p WITH (NOLOCK)
ON e.cpr_id = p.cpr_id
LEFT OUTER JOIN c_User u WITH (NOLOCK)
ON e.attending_doctor = u.user_id
WHERE e.encounter_status = 'OPEN'
AND e.office_id LIKE @ps_office_id
AND r.room_type LIKE @ps_room_type


UPDATE e
SET dispatch_date = (	SELECT min(wi.dispatch_date)
			FROM p_Patient_WP_Item wi WITH (NOLOCK)
			WHERE 
				wi.cpr_id = e.cpr_id
			AND	wi.encounter_id = e.encounter_id
			AND	wi.active_service_flag = 'Y'
		    )
FROM @open_encounters e
INNER JOIN p_Patient_WP_Item ca WITH (NOLOCK)
ON 	    e.cpr_id =ca.cpr_id
AND		ca.encounter_id = e.encounter_id
WHERE
	ca.active_service_flag = 'Y'


UPDATE e
SET alert_count = (	SELECT
				 count(a.cpr_id)
			FROM p_Chart_Alert a WITH (NOLOCK)
			WHERE
				a.alert_status IS NULL
			AND	e.cpr_id = a.cpr_id
		  )
FROM @open_encounters e
INNER JOIN p_chart_alert ca WITH (NOLOCK)
ON e.cpr_id =ca.cpr_id
WHERE
	ca.alert_status IS NULL

SELECT
	e.cpr_id ,
	e.encounter_id ,
	e.encounter_type ,
	e.encounter_date ,
	e.encounter_description ,
	e.patient_workplan_id ,
	e.patient_location ,
	e.attending_doctor ,
	e.patient_name,
	e.date_of_birth,
	e.sex,
	DATEDIFF(minute, e.dispatch_date, dbo.get_client_datetime()) as minutes,
	e.room_name,
	e.room_sequence,
	e.color,
	e.alert_count,
	e.patient_age
FROM @open_encounters e

GO
GRANT EXECUTE
	ON [dbo].[sp_open_encounters_in_room_type]
	TO [cprsystem]
GO

