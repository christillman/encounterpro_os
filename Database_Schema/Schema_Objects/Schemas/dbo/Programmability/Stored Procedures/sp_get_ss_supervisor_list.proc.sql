CREATE PROCEDURE sp_get_ss_supervisor_list
AS


SELECT u.last_name+','+u.first_name as username,
	u.dea_number as deanumber
FROM c_User_Progress up
	INNER JOIN c_User u
	ON up.progress_type='ID'
	and up.progress_key='211^surescript_spi'
	and up.current_flag = 'Y'
	and u.user_id = up.user_id
	and u.actor_class='User'
	and (u.dea_number IS NOT NULL and len(u.dea_number) > 0)
