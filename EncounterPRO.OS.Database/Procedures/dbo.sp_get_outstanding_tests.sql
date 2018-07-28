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

-- Drop Procedure [dbo].[sp_get_outstanding_tests]
Print 'Drop Procedure [dbo].[sp_get_outstanding_tests]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_outstanding_tests]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_outstanding_tests]
GO

-- Create Procedure [dbo].[sp_get_outstanding_tests]
Print 'Create Procedure [dbo].[sp_get_outstanding_tests]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_outstanding_tests (
	@ps_observation_type varchar(24) = NULL,
	@ps_treatment_type varchar(24) = NULL,
	@ps_treatment_key varchar(40) = NULL )
AS

IF @ps_treatment_type IS NOT NULL
	select	p.cpr_id,
		p.first_name,
		p.middle_name,
		p.last_name,
		p.billing_id,
		p.primary_provider_id,
		t.treatment_id,
		t.treatment_type,
		t.treatment_description,
		t.attachment_id,
		t.send_out_flag,
		t.begin_date,
		e.attending_doctor as ordered_by,
		t.treatment_status,
		t.end_date,
		u1.color,
		u2.color,
		selected_flag=0,
		t.open_encounter_id,
		COALESCE(e.office_id, p.office_id)
	from p_Treatment_Item t WITH (NOLOCK)
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
		LEFT OUTER JOIN c_User u1 WITH (NOLOCK)
		ON e.attending_doctor = u1.user_id
		LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
		ON p.primary_provider_id = u2.user_id
	WHERE t.treatment_type = @ps_treatment_type
	AND t.open_flag = 'Y'
	AND (@ps_treatment_key IS NULL OR t.treatment_key = @ps_treatment_key)
ELSE
	select	p.cpr_id,
		p.first_name,
		p.middle_name,
		p.last_name,
		p.billing_id,
		p.primary_provider_id,
		t.treatment_id,
		t.treatment_type,
		t.treatment_description,
		t.attachment_id,
		t.send_out_flag,
		t.begin_date,
		e.attending_doctor as ordered_by,
		t.treatment_status,
		t.end_date,
		u1.color,
		u2.color,
		selected_flag=0,
		t.open_encounter_id,
		COALESCE(e.office_id, p.office_id)
	from c_Treatment_Type tt WITH (NOLOCK)
		INNER LOOP JOIN p_Treatment_Item t WITH (NOLOCK)
		ON t.open_flag = 'Y'
		AND t.treatment_type = tt.treatment_type
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
		LEFT OUTER JOIN c_User u1 WITH (NOLOCK)
		ON e.attending_doctor = u1.user_id
		LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
		ON p.primary_provider_id = u2.user_id
	WHERE tt.observation_type = @ps_observation_type

GO
GRANT EXECUTE
	ON [dbo].[sp_get_outstanding_tests]
	TO [cprsystem]
GO

