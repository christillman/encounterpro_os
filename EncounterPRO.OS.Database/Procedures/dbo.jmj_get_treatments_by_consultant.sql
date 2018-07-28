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

-- Drop Procedure [dbo].[jmj_get_treatments_by_consultant]
Print 'Drop Procedure [dbo].[jmj_get_treatments_by_consultant]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_treatments_by_consultant]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_treatments_by_consultant]
GO

-- Create Procedure [dbo].[jmj_get_treatments_by_consultant]
Print 'Create Procedure [dbo].[jmj_get_treatments_by_consultant]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_get_treatments_by_consultant (
	@ps_consultant_id varchar(24),
	@pdt_begin_date datetime,
	@pdt_end_date datetime = NULL)
AS

-- If the end_date is not supplied, then assume a range of one day
-- specified by the begin_date
IF @pdt_end_date IS NULL
	BEGIN
	SET @pdt_end_date = convert(datetime, convert(varchar(10),@pdt_begin_date, 101) + ' 23:59:59.999')
	SET @pdt_begin_date = convert(datetime, convert(varchar(10),@pdt_begin_date, 101))
	END

DECLARE @treatments TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	results_Status varchar(12) NULL,
	results_date_time datetime NULL,
	reviewed_by varchar(24) NULL,
	reviewed_date_time datetime NULL,
	waiting_on varchar(24) NULL,
	waiting_on_short_name varchar(32))

DECLARE @waiting TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	patient_workplan_item_id int)

INSERT INTO @treatments (
	cpr_id ,
	treatment_id)
SELECT DISTINCT p.cpr_id,
		p.treatment_id
FROM p_Treatment_Progress p WITH (NOLOCK)
	INNER JOIN p_treatment_item i (NOLOCK)
	ON p.cpr_id = i.cpr_id
	AND p.treatment_id = i.treatment_id	
	INNER JOIN p_patient_Encounter e
	ON e.cpr_id=i.cpr_id
	AND e.encounter_id=i.open_encounter_id
WHERE p.progress_type = 'Property'
AND p.progress_key = 'consultant_id'
AND p.progress_value = @ps_consultant_id
AND e.encounter_date >= @pdt_begin_date
AND e.encounter_date <= @pdt_end_date
AND p.current_flag = 'Y'
AND (i.treatment_status IS NULL or i.treatment_status in ('OPEN', 'CLOSED'))




UPDATE t
SET results_Status = p.progress_value,
	results_date_time = p.progress_date_time
FROM @treatments t
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON t.cpr_id = p.cpr_id
	AND t.treatment_id = p.treatment_id
WHERE p.progress_type = 'Results'
AND p.progress_key = 'Status'
AND p.current_flag = 'Y'

UPDATE t
SET reviewed_by = p.user_id,
	reviewed_date_time = p.progress_date_time
FROM @treatments t
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON t.cpr_id = p.cpr_id
	AND t.treatment_id = p.treatment_id
WHERE p.progress_type = 'Reviewed'
AND p.current_flag = 'Y'

INSERT INTO @waiting (
	cpr_id ,
	treatment_id,
	patient_workplan_item_id)
SELECT t.cpr_id ,
	t.treatment_id,
	min(i.patient_workplan_item_id)
FROM @treatments t
	INNER JOIN p_Patient_WP w WITH (NOLOCK)
	ON t.cpr_id = w.cpr_id
	AND t.treatment_id = w.treatment_id
	INNER JOIN p_Patient_WP_Item i WITH (NOLOCK)
	ON i.patient_workplan_id = w.patient_workplan_id
WHERE i.active_service_flag = 'Y'
AND ordered_service <> 'WAIT'
GROUP BY t.cpr_id , t.treatment_id

UPDATE t
SET waiting_on = i.owned_by
FROM @treatments t
	INNER JOIN @waiting w
	ON t.cpr_id = w.cpr_id
	AND t.treatment_id = w.treatment_id
	INNER JOIN p_Patient_WP_Item i WITH (NOLOCK)
	ON i.patient_workplan_item_id = w.patient_workplan_item_id

UPDATE t
SET waiting_on_short_name = u.user_short_name
FROM @treatments t
	INNER JOIN c_User u
	ON t.waiting_on = u.user_id
WHERE LEFT(t.waiting_on, 1) <> '!'

UPDATE t
SET waiting_on_short_name = r.role_name
FROM @treatments t
	INNER JOIN c_Role r
	ON t.waiting_on = r.role_id
WHERE LEFT(t.waiting_on, 1) = '!'

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
	e.attending_doctor as owner,
	t.treatment_status,
	t.end_date,
	u1.color as owner_color,
	u1.user_short_name as owner_short_name,
	selected_flag=0,
	t.open_encounter_id,
	office_id=COALESCE(e.office_id, p.office_id),
	tmp.results_status,
	tmp.results_date_time,
	tmp.reviewed_by,
	u2.user_short_name as reviewed_by_short_name,
	tmp.reviewed_date_time,
	tt.icon,
	tmp.waiting_on,
	tmp.waiting_on_short_name
from @treatments tmp
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
		ON tmp.cpr_id = t.cpr_id
		AND tmp.treatment_id = t.treatment_id
	INNER JOIN p_Patient p WITH (NOLOCK)
		ON p.cpr_id = t.cpr_id
	INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
		ON t.treatment_type = tt.treatment_type
	LEFT OUTER JOIN c_User u1 WITH (NOLOCK)
		ON e.attending_doctor = u1.user_id
	LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
		ON tmp.reviewed_by = u2.user_id
	LEFT OUTER JOIN c_User u3 WITH (NOLOCK)
		ON tmp.waiting_on = u3.user_id
ORDER BY p.last_name, p.first_name, p.middle_name, p.billing_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_get_treatments_by_consultant]
	TO [cprsystem]
GO

