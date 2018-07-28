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

-- Drop Trigger [dbo].[tr_p_patient_encounter_insert]
Print 'Drop Trigger [dbo].[tr_p_patient_encounter_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_patient_encounter_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_patient_encounter_insert]
GO

-- Create Trigger [dbo].[tr_p_patient_encounter_insert]
Print 'Create Trigger [dbo].[tr_p_patient_encounter_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[tr_p_patient_encounter_insert]
    ON [dbo].[p_Patient_Encounter]
    AFTER INSERT
    AS 
BEGIN

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_exclude_role varchar(24),
		@ll_isvalid int,
		@ls_cpr_id varchar(12), 
		@ll_encounter_id int,
		@ls_set_patient_referring_provider varchar(255)

UPDATE e
SET encounter_description = et.description
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_Encounter_Type et
	ON e.encounter_type = et.encounter_type
WHERE i.encounter_type = i.encounter_description
AND e.encounter_description IS NULL

UPDATE e
SET discharge_date = i.encounter_date
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
WHERE i.encounter_status = 'CLOSED'
AND i.discharge_date IS NULL

UPDATE e
SET attending_doctor = NULL
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
WHERE i.attending_doctor = ''


SET @ls_exclude_role = dbo.fn_get_preference('BILLINGSYSTEM', 'Medicaid No Supervisor Role', NULL, NULL)

UPDATE e
SET supervising_doctor = u.supervisor_user_id
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_User u
	ON i.attending_doctor = u.user_id
WHERE i.supervising_doctor IS NULL
AND u.supervisor_user_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM inserted i
		INNER JOIN c_User_Role r
		ON i.attending_doctor = r.user_id
		INNER JOIN p_Patient_Authority a
		ON i.cpr_id = a.cpr_id
		INNER JOIN c_Authority ca
		ON ca.authority_id = a.authority_id
	WHERE  r.role_id = @ls_exclude_role
	AND a.authority_type = 'PAYOR'
	AND a.authority_sequence = 1
	AND ca.authority_category = 'Medicaid'
	)

UPDATE e
SET encounter_location = u.user_id
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_User u
	ON e.office_id = u.office_id
	AND u.actor_class = 'Office'
WHERE e.encounter_location IS NULL
AND u.status = 'OK'

UPDATE e
SET indirect_flag = COALESCE(c.default_indirect_flag, 'D')
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	LEFT OUTER JOIN c_Encounter_Type c
	ON e.encounter_type = c.encounter_type
WHERE e.indirect_flag IS NULL
OR e.indirect_flag = ''

IF UPDATE(referring_doctor)
	BEGIN
	SET @ls_set_patient_referring_provider = dbo.fn_get_preference('PREFERENCES', 'auto_update_referring_provider', NULL, NULL)
	IF LEFT(@ls_set_patient_referring_provider, 1) IN ('T', 'Y')
		BEGIN
		INSERT INTO p_Patient_Progress (
			cpr_id,
			encounter_id,
			user_id,
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			created,
			created_by)
		SELECT i.cpr_id,
			i.encounter_id,
			'#SYSTEM',
			getdate(),
			'Modify',
			'referring_provider_id',
			i.referring_doctor,
			getdate(),
			'#SYSTEM'
		FROM inserted i
			INNER JOIN p_Patient p
			ON i.cpr_id = p.cpr_id
		WHERE i.referring_doctor IS NOT NULL
		AND ISNULL(i.referring_doctor, '!NULL') <> ISNULL(p.referring_provider_id, '!NULL')
		END
	END

END
GO

