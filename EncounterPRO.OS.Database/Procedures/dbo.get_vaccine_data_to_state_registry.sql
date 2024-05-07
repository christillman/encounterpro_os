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

-- Drop Procedure [dbo].[get_vaccine_data_to_state_registry]
Print 'Drop Procedure [dbo].[get_vaccine_data_to_state_registry]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[get_vaccine_data_to_state_registry]') AND [type]='P'))
DROP PROCEDURE [dbo].[get_vaccine_data_to_state_registry]
GO

-- Create Procedure [dbo].[get_vaccine_data_to_state_registry]
Print 'Create Procedure [dbo].[get_vaccine_data_to_state_registry]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE get_vaccine_data_to_state_registry 

AS

DECLARE @ldt_min_datetime datetime,
		@ll_interval_amount int, 
		@ll_max_rows int,
		@ls_interval_unit varchar(20),
		@ls_temp varchar(255),
		@ls_vaccine_registry_approval_required varchar(12),
		@ll_toaddressee_id int


SET @ls_vaccine_registry_approval_required = dbo.fn_get_preference('PREFERENCES', 'Vaccine Registry Approval Required', NULL, NULL)
IF @ls_vaccine_registry_approval_required IS NULL
	SET @ls_vaccine_registry_approval_required = 'N'

SET @ll_max_rows = convert(int,dbo.fn_get_preference('PREFERENCES', 'Vaccine Registry Max Rows', NULL, NULL))
IF @ll_max_rows IS NULL OR @ll_max_rows <= 0
	SET @ll_max_rows = 100

SET @ls_temp = dbo.fn_get_preference('PREFERENCES', 'Vaccine Registry Past Duration', NULL, NULL)
IF @ls_temp IS NULL
	SET @ls_temp = '6 Month'

SET @ll_toaddressee_id = dbo.fn_get_preference('PREFERENCES', 'Sent To RegistryId', NULL, NULL)

-- Split preference and cast amount as integer
SET @ll_interval_amount = Convert(int,LEFT(@ls_temp,PATINDEX ( '%Month%' , @ls_temp ) - 1))
SET @ls_interval_unit = SUBSTRING(@ls_temp,PATINDEX ( '%Month%' , @ls_temp ),7)

IF @ll_interval_amount IS NULL or @ll_interval_amount <= 0 
	SET @ll_interval_amount = 6
IF @ls_interval_unit IS NULL or Len(@ls_interval_unit) = 0 
	SET @ls_interval_unit = 'Month'


SET @ldt_min_datetime = dbo.fn_date_add_interval(dbo.get_client_datetime(), -@ll_interval_amount, @ls_interval_unit)

DECLARE @immunizations TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	drug_id varchar(24) NULL,
	procedure_id varchar(24) NULL,
	sent_to_registry varchar(40) NULL,
	registry_approval varchar(40) NULL,
	consent_date varchar(24) NULL,
	consent_firstname varchar(40) NULL,
	consent_lastname varchar(40) NULL,
	consent_relation varchar(24) NULL)

DECLARE @immunizations1 TABLE (
	cpr_id varchar(12) NOT NULL,
	treatment_id int NOT NULL,
	drug_id varchar(24) NULL,
	procedure_id varchar(24) NULL,
	sent_to_registry varchar(40) NULL,
	registry_approval varchar(40) NULL,
	regcount int IDENTITY (1,1) NOT NULL,
	consent_date varchar(24) NULL,
	consent_firstname varchar(40) NULL,
	consent_lastname varchar(40) NULL,
	consent_relation varchar(24) NULL)

-- If the procedure_id is specified directly in the p_Treatment_Item record, then we'll us it for the cpt_code
-- Otherwise we'll look up the procedure_id associated with the drug_id, so get both the procedure_id and
-- drug_id in the temp table
INSERT INTO @immunizations (
	cpr_id  ,
	treatment_id  ,
	drug_id ,
	procedure_id ,
	sent_to_registry)
SELECT t.cpr_id,
		t.treatment_id,
		t.drug_id,
		t.procedure_id,
		pr.progress_value
FROM p_Treatment_Item t
	LEFT OUTER JOIN p_Treatment_Progress pr
	ON t.cpr_id = pr.cpr_id
	AND t.treatment_id = pr.treatment_id
	AND pr.progress_type = 'Property'
	AND pr.progress_key = 'Sent To Registry'
	AND pr.current_flag = 'Y'
WHERE t.treatment_type = 'IMMUNIZATION'
AND t.created > @ldt_min_datetime
AND t.treatment_status = 'CLOSED'

DELETE @immunizations
WHERE sent_to_registry IS NOT NULL

-- Get the consent information

	UPDATE x
	SET registry_approval = pr.progress_value
		FROM @immunizations x
		LEFT OUTER JOIN p_Patient_Progress pr
		ON x.cpr_id = pr.cpr_id
	WHERE pr.progress_type = 'Property'
	AND pr.progress_key = 'Vaccine Transfer To Registry Approved'
	AND pr.current_flag = 'Y'

UPDATE x
	SET consent_firstname = pr.progress_value
		FROM @immunizations x
		LEFT OUTER JOIN p_Patient_Progress pr
		ON x.cpr_id = pr.cpr_id
	WHERE pr.progress_type = 'Property'
	AND pr.progress_key = 'Vaccine Transfer Consent FirstName'
	AND pr.current_flag = 'Y'
	
	UPDATE x
	SET consent_lastname = pr.progress_value
		FROM @immunizations x
		LEFT OUTER JOIN p_Patient_Progress pr
		ON x.cpr_id = pr.cpr_id
	WHERE pr.progress_type = 'Property'
	AND pr.progress_key = 'Vaccine Transfer Consent LastName'
	AND pr.current_flag = 'Y'
	
	UPDATE x
	SET consent_relation = pr.progress_value
		FROM @immunizations x
		LEFT OUTER JOIN p_Patient_Progress pr
		ON x.cpr_id = pr.cpr_id
	WHERE pr.progress_type = 'Property'
	AND pr.progress_key = 'Vaccine Transfer Consent Relation'
	AND pr.current_flag = 'Y'
	
	UPDATE x
	SET consent_date = pr.progress_value
		FROM @immunizations x
		LEFT OUTER JOIN p_Patient_Progress pr
		ON x.cpr_id = pr.cpr_id
	WHERE pr.progress_type = 'Property'
	AND pr.progress_key = 'Vaccine Transfer Consent Date'
	AND pr.current_flag = 'Y'
	
IF LEFT(@ls_vaccine_registry_approval_required, 1) IN ('Y', 'T')
	BEGIN

	DELETE @immunizations
	WHERE registry_approval IS NULL
	OR LEFT(registry_approval, 1) NOT IN ('Y', 'T')
	END

-- copy the records to another temp table which fills in identity column to allow us to filter only max rows
INSERT INTO @immunizations1 (
	cpr_id  ,
	treatment_id  ,
	drug_id ,
	procedure_id ,
	sent_to_registry,
	registry_approval,
	consent_firstname,
	consent_lastname,
	consent_date,
	consent_relation)
SELECT cpr_id  ,
	treatment_id  ,
	drug_id ,
	procedure_id ,
	sent_to_registry,
	registry_approval,
	consent_firstname,
	consent_lastname,
	consent_date,
	consent_relation
FROM @immunizations

-- For the records which did not have the procedure_id specified in the p_Treatment_Item table, look up
-- the procedure_id associated with the drug_id
UPDATE x
SET procedure_id = dd.procedure_id
FROM @immunizations1 x
    INNER JOIN c_Drug_Definition dd
	ON x.drug_id = dd.drug_id
WHERE x.procedure_id IS NULL

SELECT TOP 100 p_Patient.cpr_id,
	p_Patient.last_name,
	p_Patient.first_name,
	p_Patient.middle_name,
	p_Patient.date_of_birth,
	p_Patient.sex,
	p_Patient.phone_number,
	p_Patient.ssn,
	p_Patient.maiden_name,
	p_Patient.address_line_1,
	p_Patient.address_line_2,
	p_Patient.city,
	p_Patient.state,
	p_Patient.zip,
	c_office.office_id as officeid,
	c_office.description as officename,
	c_office.address1 as office_address_line_1,
	c_office.address2 as office_address_line_2,
	c_office.city as office_city,
	c_office.state as office_state,
	c_office.zip as office_zip,
	t.treatment_id,
	t.office_id as vaccineadminlocation,
	t.treatment_type,
	t.begin_date as admin_date,
	tp.progress_value as placeadministered,
	cp.cpt_code as vaccinecode,
	dbo.fn_vfc_eligibility_code(t.cpr_id, t.open_encounter_id, t.treatment_id) as vfc_eligibility_code,
	dbo.fn_vfc_eligibility_date(t.cpr_id, t.open_encounter_id, t.treatment_id) as vfc_eligibility_date,
	t.treatment_description as vaccinename,
	t.maker_id as manufacturer,
	t.lot_number as lotnumber,
	t.dose_amount as doseamount,
	t.dose_unit as doseunit,
	t.ordered_by as providerid,
	c_user.user_full_name as providername,
	c_user.first_name as providerfirstname,
	c_user.last_name as providerlastname,
	c_user.middle_name as providermiddlename,
	c_user.user_short_name as providershortname,
	c_user.dea_number,
	c_user.license_number,
	c_user.upin,
	c_user.actor_id as actorid,
	c_user.id as guid,
	@ll_toaddressee_id as recipientid,
	x.registry_approval,
	x.consent_firstname,
	x.consent_lastname,
	x.consent_date,
	x.consent_relation
FROM @immunizations1 x
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = x.cpr_id
	AND t.treatment_id = x.treatment_id
	INNER JOIN p_Patient_Encounter
	ON t.cpr_id = p_Patient_Encounter.cpr_id
	AND t.open_encounter_id = p_Patient_Encounter.encounter_id
	LEFT OUTER JOIN c_Office
	ON p_Patient_Encounter.office_id = c_Office.office_id
	INNER JOIN p_Patient
	ON p_Patient_Encounter.cpr_id = p_Patient.cpr_id
	INNER JOIN c_User
	ON t.ordered_by = user_id
	LEFT OUTER JOIN p_Treatment_Progress tp
	ON t.cpr_id = tp.cpr_id
	AND t.treatment_id = tp.treatment_id
	AND tp.progress_type = 'Property'
	AND tp.progress_key = 'Place Administered'
	AND tp.current_flag = 'Y'
	LEFT OUTER JOIN c_Procedure cp
	ON x.procedure_id = cp.procedure_id
ORDER BY p_Patient.cpr_id

GO
GRANT EXECUTE
	ON [dbo].[get_vaccine_data_to_state_registry]
	TO [cprsystem]
GO

