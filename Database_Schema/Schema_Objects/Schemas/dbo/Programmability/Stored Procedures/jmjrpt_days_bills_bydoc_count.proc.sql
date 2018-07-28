


CREATE PROCEDURE jmjrpt_days_bills_bydoc_count @ps_userid varchar(24), @ps_encounter_date varchar(10)
AS
Declare @user_id varchar(24)
Declare @encounterdate datetime
Select @encounterdate = @ps_encounter_date
Select @user_id = @ps_userid

SELECT	Count(pe.encounter_id)
	FROM p_Patient_Encounter pe (NOLOCK)
	WHERE 
	bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND DATEDIFF(day, encounter_date, @encounterdate) = 0
        AND (pe.attending_doctor = @user_id)