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

