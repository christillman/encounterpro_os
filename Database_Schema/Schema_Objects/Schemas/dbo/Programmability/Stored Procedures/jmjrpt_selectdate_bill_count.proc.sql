


CREATE PROCEDURE jmjrpt_selectdate_bill_count @ps_encounter_date varchar(10)
AS

Declare @encounterdate varchar(10)

Select @encounterdate = @ps_encounter_date

SELECT	'Encounters',
        Count(pe.encounter_id)
 	FROM p_Patient_Encounter pe (NOLOCK)
	WHERE 
	bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND pe.encounter_date BETWEEN @encounterdate AND DATEADD( day, 1, @encounterdate)