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

-- Drop Procedure [dbo].[jmj_get_patient_documents]
Print 'Drop Procedure [dbo].[jmj_get_patient_documents]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_patient_documents]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_patient_documents]
GO

-- Create Procedure [dbo].[jmj_get_patient_documents]
Print 'Create Procedure [dbo].[jmj_get_patient_documents]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_get_patient_documents (
	@ps_cpr_id varchar(12))
AS

DECLARE @documents TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	treatment_id int NOT NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(24) NOT NULL,
	description varchar(80) NULL,
	user_id varchar(24) NULL,
	user_full_name varchar(64) NULL,
	dispatch_method varchar(24) NULL,
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12) NULL,
	display_status varchar(12) NULL,
	sent_status varchar(12) NULL,
	retries int NULL,
	escalation_date datetime NULL,
	expiration_date datetime NULL,
	report_id varchar(40) NULL,
	attachment_id int NULL,
	document_category varchar(24) NULL )

INSERT INTO @documents (
	cpr_id,
	encounter_id,
	treatment_id,
	patient_workplan_item_id,
	ordered_by,
	description,
	user_id,
	user_full_name,
	dispatch_method,
	dispatch_date,
	begin_date,
	end_date,
	status,
	display_status,
	sent_status,
	retries,
	escalation_date,
	expiration_date)
SELECT
	i.cpr_id,
	i.encounter_id,
	i.treatment_id,
	i.patient_workplan_item_id,
	i.ordered_by,
	i.description,
	i.ordered_for as user_id,
	u.user_full_name,
	i.dispatch_method,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	CASE i.status WHEN 'Sent' THEN COALESCE(r.sent_status, i.status) ELSE i.status END as display_status,
	r.sent_status,
	i.retries,
	i.escalation_date,
	i.expiration_date
FROM p_Patient_WP_Item i WITH (NOLOCK)
	LEFT OUTER JOIN c_User u
	ON i.ordered_for = u.user_id
	LEFT OUTER JOIN c_Document_Route r
	ON i.dispatch_method = r.document_route
WHERE 	i.cpr_id = @ps_cpr_id
AND 	i.item_type = 'Document'

UPDATE d
SET report_id = CAST(a.value as varchar(40))
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'report_id'

UPDATE d
SET attachment_id = CAST(a.value as int)
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'attachment_id'
AND ISNUMERIC(a.value) = 1

UPDATE d
SET document_category = CAST(a.value as varchar(24))
FROM @documents d
	LEFT OUTER JOIN p_Patient_WP_Item_Attribute a
	ON d.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute = 'document_category'

SELECT cpr_id,
	encounter_id,
	treatment_id,
	patient_workplan_item_id,
	ordered_by,
	description,
	user_id,
	user_full_name,
	dispatch_method,
	dispatch_date,
	begin_date,
	end_date,
	status,
	display_status,
	sent_status,
	retries,
	escalation_date,
	expiration_date,
	report_id,
	attachment_id,
	document_category,
	selected_flag=0
FROM @documents
	


GO
GRANT EXECUTE
	ON [dbo].[jmj_get_patient_documents]
	TO [cprsystem]
GO

