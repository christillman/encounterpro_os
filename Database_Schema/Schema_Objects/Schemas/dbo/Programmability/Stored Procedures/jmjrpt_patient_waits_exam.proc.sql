


CREATE PROCEDURE jmjrpt_patient_waits_exam
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date

--CALCULATE PHYSICIAN TIME IN EXAM ROOM
SELECT uof.description As Office
	,CAST(AVG(DATEDIFF(minute, wp.begin_date, wp.end_date))AS VARCHAR) + ' minute(s) average exam time.'
FROM p_patient_WP_item wp WITH (NOLOCK)
	,p_Patient_Encounter i WITH (NOLOCK)
	,c_office uof  WITH (NOLOCK)
WHERE i.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND i.indirect_flag='D'
AND wp.ordered_service='EXAM'
AND wp.status='COMPLETED'
AND i.cpr_id = wp.cpr_id
AND i.encounter_id = wp.encounter_id
AND uof.office_id = i.office_id
Group by uof.description
Order by office asc