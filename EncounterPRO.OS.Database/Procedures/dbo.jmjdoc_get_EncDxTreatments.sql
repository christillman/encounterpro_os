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

-- Drop Procedure [dbo].[jmjdoc_get_EncDxTreatments]
Print 'Drop Procedure [dbo].[jmjdoc_get_EncDxTreatments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_EncDxTreatments]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_EncDxTreatments]
GO

-- Create Procedure [dbo].[jmjdoc_get_EncDxTreatments]
Print 'Create Procedure [dbo].[jmjdoc_get_EncDxTreatments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE jmjdoc_get_EncDxTreatments (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int,
	@pl_problem_id int
)

AS

DECLARE @EncTrts TABLE (
	treatmentid int NOT NULL
)

DECLARE @EncLastOrderTrts TABLE (
	treatmentid int NOT NULL,
	lastorderdate datetime NOT NULL,
	lastorderby varchar(24) NOT NULL,
	lastorderencounter int NOT NULL )

DECLARE @ll_treatmentid int

INSERT INTO @EncTrts
SELECT t.treatment_id
FROM	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN p_Assessment_Treatment ae WITH (NOLOCK)
	ON t.cpr_id = ae.cpr_id
	AND t.treatment_id=ae.treatment_id
	INNER JOIN p_Patient_Encounter e
	ON t.cpr_id = e.cpr_id
		AND (e.encounter_id = t.open_encounter_id OR e.encounter_id=t.close_encounter_id
		 OR (t.begin_date <= e.encounter_date and (t.end_date IS NULL OR t.end_date >= e.encounter_date)))
WHERE t.cpr_id = @ps_cpr_id
AND ae.problem_id = @pl_problem_id
AND e.encounter_id=@pl_encounter_id
AND (ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED' OR t.close_encounter_id > @pl_encounter_id)

DECLARE trtLastOrder CURSOR
FOR SELECT * FROM @EncTrts

OPEN trtLastOrder
FETCH NEXT FROM trtLastOrder INTO @ll_treatmentid

WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @EncLastOrderTrts
 SELECT TOP 1 treatment_id,Ordered_Date, Ordered_By,Encounter_id
FROM dbo.fn_patient_treatment_orders(@ps_cpr_id, @ll_treatmentid)
ORDER BY order_sequence desc

FETCH NEXT FROM trtLastOrder INTO @ll_treatmentid
END

-- Filter only the treatments that are associated to the assessment and also created during or prior to the
-- given encounter instance.

SELECT t.cpr_id as cprid,   
         t.open_encounter_id as openencounter,   
 	 t.treatment_id as treatmentid,
        t.treatment_type as treatmenttype, 
         t.begin_date as begindate,
         t.treatment_description as description,
         t.specimen_id as specimenid,
	 c.description as treatmentlocation,
       CASE WHEN t.treatment_status IS NULL THEN 'OPEN'
                  ELSE CASE WHEN t.close_encounter_id > @pl_encounter_id THEN 'OPEN'
                                          ELSE t.treatment_status
                          END 
        END as treatmentstatus,
	t.close_encounter_id as closeencounter,
	t.end_date as enddate,
	t.ordered_by as orderedby_actorid,
	u.user_full_name as orderedby_actorname,
	u.first_name as orderedby_actorfirstname,
	u.last_name as orderedby_actorlastname,
	u.actor_class as orderedby_actorclass,
	t.ordered_for as orderedfor_actorid,
	ofor.user_full_name as orderedfor_actorname,
	ofor.first_name as orderedfor_actorfirstname,
	ofor.last_name as orderedfor_actorlastname,
	ofor.actor_class as orderedfor_actorclass,
	t.completed_by as completed_by,
	cmpby.user_full_name as cmpby_actorname,
	cmpby.first_name as cmpby_actorfirstname,
	cmpby.last_name as cmpby_actorlastname,
	cmpby.actor_class as cmpby_actorclass,
	t.observation_id as observationid,
	lo.lastorderencounter as last_encounter_id,
	lo.lastorderdate as last_order_date,
	lo.lastorderby as last_orderedby,
	lofor.user_full_name as last_orderedby_actorname,
	lofor.first_name as last_orderedby_actorfirstname,
	lofor.last_name as last_orderedby_actorlastname,
	lofor.actor_class as last_orderedby_actorclass
FROM	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN p_Assessment_Treatment ae WITH (NOLOCK)
	ON t.cpr_id = ae.cpr_id
	AND t.treatment_id=ae.treatment_id
	INNER JOIN p_Patient_Encounter e
	ON t.cpr_id = e.cpr_id
		AND (e.encounter_id = t.open_encounter_id OR e.encounter_id=t.close_encounter_id
		 OR (t.begin_date <= e.encounter_date and (t.end_date IS NULL OR t.end_date >= e.encounter_date)))
	LEFT OUTER JOIN @EncLastOrderTrts lo
		ON t.treatment_id = lo.treatmentid
	LEFT OUTER JOIN c_Location c WITH (NOLOCK)
	ON t.location = c.location 
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON t.ordered_by = u.user_id
	LEFT OUTER JOIN c_User ofor WITH (NOLOCK)
	ON t.ordered_for = ofor.user_id
	LEFT OUTER JOIN c_User cmpby WITH (NOLOCK)
	ON t.completed_by = cmpby.user_id
	LEFT OUTER JOIN c_User lofor WITH (NOLOCK)
	ON lo.lastorderby = lofor.user_id
WHERE t.cpr_id = @ps_cpr_id
AND ae.problem_id = @pl_problem_id
AND e.encounter_id=@pl_encounter_id
AND (ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED' OR t.close_encounter_id > @pl_encounter_id)

GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_EncDxTreatments]
	TO [cprsystem]
GO

