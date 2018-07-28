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

-- Drop Procedure [dbo].[jmjdoc_get_treatment]
Print 'Drop Procedure [dbo].[jmjdoc_get_treatment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_treatment]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_treatment]
GO

-- Create Procedure [dbo].[jmjdoc_get_treatment]
Print 'Create Procedure [dbo].[jmjdoc_get_treatment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_treatment (
	@ps_cpr_id varchar(24),
	@ps_context_object varchar(24),
	@pl_object_key int
)

AS

/*****************************************************************************************************
	
			Specific Treatment

	Retrieve all the Specific Treatment Information
*****************************************************************************************************/

IF @ps_context_object = 'Treatment' 
BEGIN
-- get the last order by, last order date and last order encounter
DECLARE @iLastEncounter int,
		@sLastOrderBy varchar(40),
		@dtLastOrderDt datetime
SELECT TOP 1 @iLastEncounter = Encounter_id, @dtLastOrderDt = Ordered_Date, @sLastOrderBy=Ordered_By
FROM dbo.fn_patient_treatment_orders(@ps_cpr_id, @pl_object_key)
ORDER BY order_sequence desc

SELECT t.cpr_id as cprid,   
         t.open_encounter_id as openencounter,  
	t.treatment_id as treatmentid, 
         t.treatment_type as treatmenttype, 
         t.begin_date as begindate,
         t.treatment_description as description,
         t.specimen_id as specimenid,
	 c.description as treatmentlocation,
        CASE WHEN t.treatment_status IS NULL THEN 'OPEN'
		ELSE t.treatment_status
	END as treatmentstatus,
	t.close_encounter_id as closeencounter,
	t.end_date as enddate,
	t.ordered_by as orderedby_actorid,
	u.user_full_name as orderedby_actorname,
	u.first_name as orderedby_actorfirstname,
	u.last_name as orderedby_actorlastname,
	u.actor_class as orderedby_actorclass,
	t.observation_id as observationid,
	t.end_date as enddate,
	t.parent_treatment_id as parent_treatment_id,
	t.original_treatment_id as original_treatment_id,
	t.ordered_for as ordered_for,
	ofor.user_full_name as orderedfor_actorname,
	ofor.first_name as orderedfor_actorfirstname,
	ofor.last_name as orderedfor_actorlastname,
	ofor.actor_class as orderedfor_actorclass,
	t.completed_by as completed_by,
	cmpby.user_full_name as cmpby_actorname,
	cmpby.first_name as cmpby_actorfirstname,
	cmpby.last_name as cmpby_actorlastname,
	cmpby.actor_class as cmpby_actorclass,
	CASE WHEN t.brand_name_required IS NULL THEN 'True'
	     WHEN t.brand_name_required = 'N' THEN 'True'
	     ELSE 'False'
	END as brandnamerequired,
	@iLastEncounter as last_encounter_id,
	@dtLastOrderDt as last_order_date,
	@sLastOrderBy as last_orderedby,
	lofor.user_full_name as last_orderedby_actorname,
	lofor.first_name as last_orderedby_actorfirstname,
	lofor.last_name as last_orderedby_actorlastname,
	lofor.actor_class as last_orderedby_actorclass
FROM	p_Treatment_Item t
	LEFT OUTER JOIN c_Location c
	ON t.location = c.location
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON t.ordered_by = u.user_id
	LEFT OUTER JOIN c_User ofor WITH (NOLOCK)
	ON t.ordered_for = ofor.user_id
	LEFT OUTER JOIN c_User cmpby WITH (NOLOCK)
	ON t.completed_by = cmpby.user_id
	LEFT OUTER JOIN c_User lofor WITH (NOLOCK)
	ON lofor.user_id = @sLastOrderBy
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_object_key
END

/*****************************************************************************************************
	
			Assessment Treatments

	Retrieve all the Treatments associated with the given assessment instance
*****************************************************************************************************/

IF @ps_context_object = 'Assessment'
BEGIN
SELECT t.cpr_id as cprid,   
         t.open_encounter_id as openencounter,   
 	t.treatment_id as treatmentid, 
        t.treatment_type as treatmenttype, 
         t.begin_date as begindate,
         t.treatment_description as description,
         t.specimen_id as specimenid,
	 c.description as treatmentlocation,
        CASE WHEN t.treatment_status IS NULL THEN 'OPEN'
		ELSE t.treatment_status
	END as treatmentstatus,
	t.close_encounter_id as closeencounter,
	t.end_date as enddate,
	t.ordered_by as orderedby_actorid,
	u.user_full_name as orderedby_actorname,
	u.first_name as orderedby_actorfirstname,
	u.last_name as orderedby_actorlastname,
	u.actor_class as orderedby_actorclass,
	t.observation_id as observationid,
	t.end_date as enddate,
	t.parent_treatment_id as parent_treatment_id,
	t.original_treatment_id as original_treatment_id,
	t.ordered_for as ordered_for,
	ofor.user_full_name as orderedfor_actorname,
	ofor.first_name as orderedfor_actorfirstname,
	ofor.last_name as orderedfor_actorlastname,
	ofor.actor_class as orderedfor_actorclass,
	t.completed_by as completed_by,
	cmpby.user_full_name as cmpby_actorname,
	cmpby.first_name as cmpby_actorfirstname,
	cmpby.last_name as cmpby_actorlastname,
	cmpby.actor_class as cmpby_actorclass,
	CASE WHEN t.brand_name_required IS NULL THEN 'True'
	     WHEN t.brand_name_required = 'N' THEN 'True'
	     ELSE 'False'
	END as brandnamerequired
FROM	p_Treatment_Item t
	LEFT OUTER JOIN c_Location c WITH (NOLOCK)
	ON t.location = c.location
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON t.ordered_by = u.user_id
	LEFT OUTER JOIN c_User ofor WITH (NOLOCK)
	ON t.ordered_for = ofor.user_id
	LEFT OUTER JOIN c_User cmpby WITH (NOLOCK)
	ON t.completed_by = cmpby.user_id
	INNER JOIN p_Assessment_Treatment asstrt
	ON asstrt.cpr_id = t.cpr_id
	AND asstrt.treatment_id = t.treatment_id
WHERE asstrt.cpr_id = @ps_cpr_id
AND asstrt.problem_id = @pl_object_key
AND (ISNULL(t.treatment_status,'OPEN') <> 'CANCELLED')
END

/*****************************************************************************************************
	
			Encounter Treatments

	Retrieve all the Treatments that were created during the specific encounter
*****************************************************************************************************/

IF @ps_context_object = 'Encounter'  
BEGIN
SELECT t.cpr_id as cprid,   
         t.open_encounter_id as openencounter,   
	t.treatment_id as treatmentid, 
         t.treatment_type as treatmenttype, 
         t.begin_date as begindate,
         t.treatment_description as description,
         t.specimen_id as specimenid,
	 c.description as treatmentlocation,
        CASE WHEN t.treatment_status IS NULL THEN 'OPEN'
		ELSE t.treatment_status
	END as treatmentstatus,
	t.close_encounter_id as closeencounter,
	t.end_date as enddate,
	t.ordered_by as orderedby_actorid,
	u.user_full_name as orderedby_actorname,
	u.first_name as orderedby_actorfirstname,
	u.last_name as orderedby_actorlastname,
	u.actor_class as orderedby_actorclass,
	t.observation_id as observationid,
	t.end_date as enddate,
	t.parent_treatment_id as parent_treatment_id,
	t.original_treatment_id as original_treatment_id,
	t.ordered_for as ordered_for,
	ofor.user_full_name as orderedfor_actorname,
	ofor.first_name as orderedfor_actorfirstname,
	ofor.last_name as orderedfor_actorlastname,
	ofor.actor_class as orderedfor_actorclass,
	t.completed_by as completed_by,
	cmpby.user_full_name as cmpby_actorname,
	cmpby.first_name as cmpby_actorfirstname,
	cmpby.last_name as cmpby_actorlastname,
	cmpby.actor_class as cmpby_actorclass,
	CASE WHEN t.brand_name_required IS NULL THEN 'True'
	     WHEN t.brand_name_required = 'N' THEN 'True'
	     ELSE 'False'
	END as brandnamerequired
FROM	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
	ON t.cpr_id = e.cpr_id
	AND t.open_encounter_id = e.encounter_id
	LEFT OUTER JOIN c_Location c WITH (NOLOCK)
	ON t.location = c.location 
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON t.ordered_by = u.user_id
	LEFT OUTER JOIN c_User ofor WITH (NOLOCK)
	ON t.ordered_for = ofor.user_id
	LEFT OUTER JOIN c_User cmpby WITH (NOLOCK)
	ON t.completed_by = cmpby.user_id
WHERE t.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_object_key
AND (ISNULL(t.treatment_status,'OPEN') <> 'CANCELLED')
END


/*****************************************************************************************************
	
			Patient Treatments

	Retrieve all the Treatments for the given patient instance
*****************************************************************************************************/

/*
IF IF @ps_context_object = 'Patient' -- Patient Treatments
BEGIN
END*/

GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_treatment]
	TO [cprsystem]
GO

