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

-- Drop Procedure [dbo].[jmj_allergy_shot_history]
Print 'Drop Procedure [dbo].[jmj_allergy_shot_history]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_allergy_shot_history]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_allergy_shot_history]
GO

-- Create Procedure [dbo].[jmj_allergy_shot_history]
Print 'Create Procedure [dbo].[jmj_allergy_shot_history]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_allergy_shot_history (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int
)

AS

DECLARE @shothistory TABLE (
	treatment_id int NOT NULL,
	treatment_begin_date datetime NOT NULL,
	dose_amount real,
	dose_unit varchar(24),
	description varchar(255) NULL,
	completed_by varchar(24) NULL,
	user_short_name varchar(20) NULL ,
	comments varchar(255) NULL,
	vial_description varchar(80) NULL,
	shot_description varchar(80) NULL,
	reaction varchar(255) NULL,
	location_description varchar(80) NULL,
	vial_type varchar(24) NULL,
	vial_type_description varchar(80) NULL,
	location varchar(24) NULL,
	encounter_id int NULL)

-- Get the injections
INSERT INTO @shothistory (
	treatment_id ,
	treatment_begin_date ,
	dose_amount ,
	dose_unit ,
	completed_by ,
	user_short_name ,
	vial_description ,
	shot_description ,
	reaction ,
	comments,
	location_description,
	vial_type,
	vial_type_description,
	location,
	encounter_id )
SELECT shot.treatment_id ,
	shot.begin_date ,
	shot.dose_amount ,
	shot.dose_unit ,
	shot.completed_by ,
	u.user_short_name ,
	vial.treatment_description ,
	shot.treatment_description ,
	reaction=dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', shot.treatment_id, 'Reaction'),
	comments=dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', shot.treatment_id, 'Comment'),
	l.description,
	vial.vial_type,
	vial_type_description=dbo.fn_vial_type_description(vial.vial_type),
	l.location,
	shot.open_encounter_id
FROM p_Treatment_Item root
	INNER JOIN p_Treatment_Item vial
	ON root.cpr_id = vial.cpr_id
	AND root.treatment_id = vial.parent_treatment_id
	AND vial.treatment_type = 'AllergyVialInstance'
	INNER JOIN p_Treatment_Item shot
	ON vial.cpr_id = shot.cpr_id
	AND vial.treatment_id = shot.parent_treatment_id
	AND shot.treatment_type = 'AllergyInjection'
	LEFT OUTER JOIN c_User u
	ON shot.completed_by = u.user_id
	LEFT OUTER JOIN c_Location l
	ON shot.location = l.location
WHERE root.cpr_id = @ps_cpr_id
AND root.treatment_id = @pl_treatment_id
AND shot.treatment_status = 'Closed'

SELECT 	treatment_id ,
	treatment_begin_date ,
	dose_amount ,
	dose_unit ,
	completed_by ,
	user_short_name ,
	vial_description ,
	shot_description ,
	CASE reaction WHEN 'No Reaction' THEN NULL ELSE reaction END ,
	comments ,
	description ,
	location_description,
	vial_type,
	vial_type_description,
	location,
	CAST(0 AS int) as shot_number,
	CAST(0 AS int) as selected_flag,
	encounter_id
FROM @shothistory


GO
GRANT EXECUTE
	ON [dbo].[jmj_allergy_shot_history]
	TO [cprsystem]
GO

