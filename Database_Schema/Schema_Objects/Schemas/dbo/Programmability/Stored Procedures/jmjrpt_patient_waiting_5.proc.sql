


CREATE PROCEDURE jmjrpt_patient_waiting_5
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT
	uof.description As Office
       ,usr.user_short_name as Provider	 
       ,convert(varchar(10),i.encounter_date,101) AS For_Date 
       ,DATEDIFF(minute, pp.progress_date_time, wp.begin_date) AS Minutes_Wait	
       ,p.first_name
       ,p.last_name
       ,et.description As Encounter
	FROM p_Patient_Encounter i WITH (NOLOCK)
INNER JOIN p_patient_encounter_progress pp WITH (NOLOCK) ON
		pp.cpr_id = i.cpr_id
                AND pp.encounter_id = i.encounter_id
INNER JOIN P_patient p  WITH (NOLOCK) ON 
            p.cpr_id = i.cpr_id
INNER JOIN c_encounter_type  et  WITH (NOLOCK) ON
            et.encounter_type = i.encounter_type
INNER JOIN c_user usr  WITH (NOLOCK) ON
            usr.user_id = i.attending_doctor
INNER JOIN c_office uof  WITH (NOLOCK) ON
           uof.office_id = i.office_id
INNER JOIN p_patient_wp_item wp WITH (NOLOCK) ON
           wp.patient_workplan_id = i.patient_workplan_id 
WHERE i.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
	AND wp.ordered_service = 'GET_PATIENT'
        AND pp.progress_type = 'created' 
        AND DATEDIFF(minute, pp.progress_date_time, wp.begin_date) > 5
Order by office asc, Provider asc, Minutes_Wait DESC