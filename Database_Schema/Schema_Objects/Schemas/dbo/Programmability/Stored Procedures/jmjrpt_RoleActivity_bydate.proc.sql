



CREATE PROCEDURE jmjrpt_RoleActivity_bydate @ps_role varchar(24), @ps_encounter_date varchar(10)
AS
Declare @ls_role varchar(24)
Declare @encounterdate varchar(10)
Select @ls_role = @ps_role
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
	AND cu.user_id = pi.completed_by
        AND cu.user_id = @ls_role
        AND cu.user_id = cur.user_id
        And cur.role_id = cr.role_id
        group by cu.user_full_name,cr.description,pi.description