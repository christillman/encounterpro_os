


CREATE PROCEDURE jmjrpt_patient_waits
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date

SELECT uof.description As Office
	,CAST(AVG(DATEDIFF(minute, encounter_date, discharge_date))AS VARCHAR) + ' minute(s) average total visit time.'
FROM p_Patient_Encounter i WITH (NOLOCK)
INNER JOIN c_office uof  WITH (NOLOCK) ON
           uof.office_id = i.office_id
WHERE i.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND i.indirect_flag='D'
AND i.encounter_date > convert(datetime, convert(varchar(10),i.encounter_date, 101))
AND i.discharge_date > convert(datetime, convert(varchar(10),i.discharge_date, 101))
AND DATEDIFF(hour, encounter_date, discharge_date) < 8
AND DATEDIFF(minute, encounter_date, discharge_date) > 5
Group by uof.description
Order by office asc