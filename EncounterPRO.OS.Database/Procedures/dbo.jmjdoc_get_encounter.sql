﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjdoc_get_encounter]
Print 'Drop Procedure [dbo].[jmjdoc_get_encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_encounter]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_encounter]
GO

-- Create Procedure [dbo].[jmjdoc_get_encounter]
Print 'Create Procedure [dbo].[jmjdoc_get_encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_encounter (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int = NULL
)

AS

IF @pl_encounter_id is NULL OR @pl_encounter_id = 0
BEGIN
SELECT e.cpr_id as cprid,   
         e.encounter_id as encounterid,   
         e.encounter_date as encounterdate,
         COALESCE(e.encounter_description, t.description) as description,
         e.encounter_type as encountertype, 
         e.attending_doctor as attendingdoctor_actorid,
         attenuser.user_full_name as attendingdoctor_actorname,
	 attenuser.first_name as attendingdoctor_actorfirstname,
	 attenuser.last_name as attendingdoctor_actorlastname,
         e.referring_doctor as referringdoctor_actorid,
         refuser.user_full_name as referringdoctor_actorname,
	 refuser.first_name as referringdoctor_actorfirstname,
	 refuser.last_name as referringdoctor_actorlastname,
         e.supervising_doctor as supervisingdoctor_actorid,
         superuser.user_full_name as supervisingdoctor_actorname,
	 superuser.first_name as supervisingdoctor_actorfirstname,
	 superuser.last_name as supervisingdoctor_actorlastname,
	 e.new_flag as newpatientflag,
         e.office_id as encounterlocation,
	o.description as enlocationname, 
	o.address1 as enlocationaddr1,
	IsNull(o.address2,'') as enlocationaddr2,
	o.city as enlocationcity,
	IsNull(o.state,'') as enlocationstate,
	IsNull(o.zip,'') as enlocationzip,
	o.phone as enlocationphone,
	 e.workers_comp_flag as workerscompflag,
	 e.indirect_flag as encountermode,
	 e.appointment_time as appointmenttime,
	 e.est_appointment_length as estappointmentlength,
	 e.encounter_status as encounterstatus,
	 e.discharge_date as dischargedate,
	 e.admit_reason as admitreason
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User attenuser
	ON e.attending_doctor = attenuser.user_id
	LEFT OUTER JOIN c_User superuser
	ON e.attending_doctor = superuser.user_id
	LEFT OUTER JOIN c_User refuser
	ON e.attending_doctor = refuser.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
END

IF @pl_encounter_id > 0
BEGIN
SELECT e.cpr_id as cprid,   
         e.encounter_id as encounterid,   
         e.encounter_date as encounterdate,
         COALESCE(e.encounter_description, t.description) as description,
         e.encounter_type as encountertype, 
         e.attending_doctor as attendingdoctor_actorid,
         attenuser.user_full_name as attendingdoctor_actorname,
	 attenuser.first_name as attendingdoctor_actorfirstname,
	 attenuser.last_name as attendingdoctor_actorlastname,
         e.referring_doctor as referringdoctor_actorid,
         refuser.user_full_name as referringdoctor_actorname,
	 refuser.first_name as referringdoctor_actorfirstname,
	 refuser.last_name as referringdoctor_actorlastname,
         e.supervising_doctor as supervisingdoctor_actorid,
         superuser.user_full_name as supervisingdoctor_actorname,
	 superuser.first_name as supervisingdoctor_actorfirstname,
	 superuser.last_name as supervisingdoctor_actorlastname,
	 e.new_flag as newpatientflag,
         e.office_id as encounterlocation,
	o.description as enlocationname, 
	o.address1 as enlocationaddr1,
	o.address2 as enlocationaddr2,
	o.city as enlocationcity,
	o.state as enlocationstate,
	o.zip as enlocationzip,
	o.phone as enlocationphone,
	 e.workers_comp_flag as workerscompflag,
	 e.indirect_flag as encountermode,
	 e.appointment_time as appointmenttime,
	 e.est_appointment_length as estappointmentlength,
	 e.encounter_status as encounterstatus,
	 e.discharge_date as dischargedate,
	 e.admit_reason as admitreason
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User attenuser
	ON e.attending_doctor = attenuser.user_id
	LEFT OUTER JOIN c_User superuser
	ON e.supervising_doctor = superuser.user_id
	LEFT OUTER JOIN c_User refuser
	ON e.referring_doctor = refuser.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
END






GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_encounter]
	TO [cprsystem]
GO

