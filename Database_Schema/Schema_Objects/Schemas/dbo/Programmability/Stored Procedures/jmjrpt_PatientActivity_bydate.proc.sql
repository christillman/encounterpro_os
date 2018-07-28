



CREATE PROCEDURE jmjrpt_PatientActivity_bydate @ps_cpr_id varchar(12), @ps_encounter_date varchar(10)
AS
Declare @ls_cpr_id varchar(12)
Declare @encounterdate varchar(10)
Select @ls_cpr_id = @ps_cpr_id
Select @encounterdate = @ps_encounter_date
SELECT	cu.user_full_name AS User_Name,
	cr.description AS Role,
        pi.description AS Service,
        Count(pi.description) As Count,
        SUM(DateDiff(minute,pi.begin_date,pi.end_date)) As Minutes
       	FROM p_Patient_WP_ITEM pi (NOLOCK),
	c_user cu (NOLOCK),
        c_user_role cur (NOLOCK),
        c_role cr (NOLOCK)
	WHERE 
	DateDiff(day,pi.begin_date,@encounterdate) = 0
	AND pi.cpr_id = @ls_cpr_id
        AND cu.user_id = pi.completed_by
        AND cu.user_id = cur.user_id
        And cur.role_id = cr.role_id
        group by cu.user_full_name,cr.description,pi.description,pi.begin_date
        order by pi.begin_date asc