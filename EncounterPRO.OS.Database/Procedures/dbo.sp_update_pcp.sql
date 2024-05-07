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

-- Drop Procedure [dbo].[sp_update_pcp]
Print 'Drop Procedure [dbo].[sp_update_pcp]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_pcp]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_update_pcp]
GO

-- Create Procedure [dbo].[sp_update_pcp]
Print 'Create Procedure [dbo].[sp_update_pcp]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_update_pcp
AS

/*	This SP will set the Primary Care Provider for a patient to the Attending Doctor of the last closed Well Encounter that was closed within 2
	days.  The SP looks for a progress Property record where the value of 'keep pcp' is true.  This progress record can be set by a button from
	the soap screen.  
	
	Making the button - new button, Service, Encounter, New Note, context object = Encounter, Special Note Type = Property, 
	Other Note Title or Key = Keep PCP, Note Text = True

*/





DECLARE @tmp_well table(
        	cpr_id varchar(12) NOT NULL ,
            	encounter_id int NOT NULL ,
		assessment_type varchar (12))

            
INSERT INTO @tmp_well 
	SELECT e.cpr_id, max(e.encounter_id) as encounter_id, ad.assessment_type
	FROM p_patient_encounter e
        	INNER JOIN p_patient p 
		ON (e.cpr_id = p.cpr_id)
		INNER JOIN c_user c
		ON e.attending_doctor = c.user_id
		INNER JOIN c_user_role r
		ON c.user_id = r.user_id
		INNER JOIN p_Encounter_Assessment a
		ON e.encounter_id = a.encounter_id
		AND e.cpr_id = a.cpr_id  
        	INNER JOIN c_Assessment_Definition ad
        	ON a.assessment_id = ad.assessment_id 
	WHERE ad.assessment_type = 'WELL'
	AND e.encounter_date > dbo.get_client_datetime() - 30
      	AND e.encounter_status = 'CLOSED'
	AND r.role_id ='!Physician'
      	GROUP BY e.cpr_id, ad.assessment_type


Update p
SET p.primary_provider_id = y.attending_doctor
FROM p_patient p
      INNER JOIN (
            SELECT DISTINCT e.cpr_id, e.encounter_id, e.attending_doctor
            FROM p_Patient_Encounter e
                  INNER JOIN @tmp_well w
                  ON e.cpr_id = w.cpr_id 
                  AND e.encounter_id = w.encounter_id 
                  
            WHERE NOT EXISTS (Select * FROM p_patient_encounter_progress x 
                                    WHERE e.cpr_id = x.cpr_id
                                    AND e.encounter_id = x.encounter_id
                                    AND x.current_flag = 'Y'
                                    AND x.progress_type = 'Property'
                                    AND x.progress_key = 'Keep PCP'
                                    AND x.progress_value = 'True') ) y
      ON p.cpr_id = y.cpr_id
WHERE (y.attending_doctor <> p.primary_provider_id OR p.primary_provider_id IS NULL)

GO
GRANT EXECUTE
	ON [dbo].[sp_update_pcp]
	TO [cprsystem]
GO

