

CREATE PROCEDURE jmjrpt_userprivilege
AS
SELECT 	u.user_full_name
	,o.description
	,p.description
	,us.access_flag
	,us.service
FROM c_user u 
WITH (NOLOCK)
LEFT OUTER JOIN
c_user_role ur
WITH (NOLOCK)
ON u.user_id = ur.user_id
LEFT OUTER JOIN c_role r 
WITH (NOLOCK)
ON ur.role_id = r.role_id
LEFT OUTER JOIN
o_user_privilege up 
WITH (NOLOCK)
on u.user_id = up.user_id
LEFT OUTER JOIN c_privilege p
WITH (NOLOCK)
ON up.privilege_id = p.privilege_id
LEFT OUTER JOIN c_office o
WITH (NOLOCK)
ON up.office_id = o.office_id
LEFT OUTER JOIN 
o_user_service us
WITH (NOLOCK)
ON ((u.user_id = us.user_id OR r.role_id = us.user_id) AND o.office_id = us.office_id)
LEFT OUTER JOIN o_service s
WITH (NOLOCK)
on us.service = s.service
ORDER by 
u.user_full_name, o.description