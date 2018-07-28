CREATE PROCEDURE jmj_get_user_id_numbers (
	@ps_user_id varchar(24))
AS

SELECT [user_id]
           ,[progress_type]
           ,[progress_key]
           ,[progress_value]
           ,[display_key]
           ,[owner_id]
           ,dbo.fn_owner_description(owner_id) AS owner_description
           ,selected_flag=0
from dbo.fn_user_id_list(@ps_user_id)


