CREATE PROCEDURE sp_get_user_previliges
	(
	@ps_user_id varchar(24),
	@ps_office_id varchar(4)
	)
AS

SELECT c_Privilege.privilege_id,   
       c_Privilege.description,   
       o_User_Privilege.user_id,   
       selected_flag=0  
FROM c_Privilege  WITH (NOLOCK)
LEFT OUTER JOIN o_User_Privilege WITH (NOLOCK)
	ON c_Privilege.privilege_id = o_User_Privilege.privilege_id
	and  o_User_Privilege.user_id = @ps_user_id 
	and o_User_Privilege.office_id = @ps_office_id
ORDER BY description asc

