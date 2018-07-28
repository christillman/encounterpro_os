CREATE PROCEDURE sp_get_posting_errors (
	@pdt_date datetime
)
AS

DECLARE	 @ldt_today datetime
	,@ldt_tomorrow datetime

SET @ldt_today = convert(datetime, convert(varchar,@pdt_date, 112))

SET @ldt_tomorrow = DATEADD(day, 1, @ldt_today)

DECLARE @failure_reasons TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	encounter_description varchar(80) NOT NULL,
	date_time varchar(12) NOT NULL ,
	[reason] [varchar] (1024) NULL
	)


INSERT INTO @failure_reasons
	(
	cpr_id,
	encounter_id,
	encounter_description,
	date_time,
	reason
	)
SELECT DISTINCT
	p_Patient_Encounter.cpr_id
	,p_Patient_Encounter.encounter_id
	,COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description) as encounter_description
	,convert(varchar(12),log_date_time,1)
	,caller + ',' + message
FROM p_Patient_Encounter WITH (NOLOCK, INDEX( idx_encounter_date ) )
INNER JOIN o_Log WITH (NOLOCK)
ON	p_Patient_Encounter.cpr_id = o_Log.cpr_id
AND	p_Patient_Encounter.encounter_id = o_Log.encounter_id
AND     o_Log.user_id in ('#BILL','#TRANOUT')
INNER JOIN c_Encounter_Type WITH (NOLOCK)
ON	p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
WHERE  p_Patient_Encounter.billing_posted = 'E'
AND p_Patient_Encounter.encounter_date >= @ldt_today
AND p_Patient_Encounter.encounter_date < @ldt_tomorrow


INSERT INTO @failure_reasons
	(
	cpr_id,
	encounter_id,
	encounter_description,
	date_time,
	reason
	)
SELECT DISTINCT
	p_Patient_Encounter.cpr_id
	,p_Patient_Encounter.encounter_id
	,COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description) as encounter_description
	,convert(varchar(12),message_date_time,1)
	,COALESCE(o_message_log.comments,'Reason not received') as reason
FROM p_Patient_Encounter WITH (NOLOCK, INDEX( idx_encounter_date ) )
INNER JOIN o_Message_Log WITH (NOLOCK)
ON	p_Patient_Encounter.cpr_id = o_Message_Log.cpr_id
AND	p_Patient_Encounter.encounter_id = o_Message_Log.encounter_id
AND     o_Message_Log.direction = 'O' AND o_message_log.status = 'ACK_REJECT'
INNER JOIN c_Encounter_Type WITH (NOLOCK)
ON	p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
WHERE  p_Patient_Encounter.billing_posted = 'E'
AND p_Patient_Encounter.encounter_date >= @ldt_today
AND p_Patient_Encounter.encounter_date < @ldt_tomorrow

SELECT DISTINCT
	e.cpr_id,
	e.encounter_id,
	billing_id,
	first_name,
	last_name,
	date_of_birth,
	encounter_description,
	date_time,
	reason
FROM @failure_reasons e
INNER JOIN p_Patient WITH (NOLOCK)
ON e.cpr_id = p_patient.cpr_id


