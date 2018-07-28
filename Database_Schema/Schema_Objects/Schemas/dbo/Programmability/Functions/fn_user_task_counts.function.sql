CREATE FUNCTION fn_user_task_counts (
	@ps_user_id varchar(24))

RETURNS @counts TABLE (
	my_task_count int NULL,
	role_task_count int NULL,
	max_priority smallint NULL )

AS

BEGIN

DECLARE @ll_my_task_count int,
		@ll_role_task_count int,
		@li_max_priority_role smallint,
		@li_max_priority smallint

DECLARE @offices TABLE (
	office_id varchar(4) NOT NULL)

SELECT @ll_my_task_count = COUNT(*),
		@li_max_priority = max(priority)
FROM o_Active_Services
WHERE owned_by = @ps_user_id
AND ordered_service <> 'MESSAGE'
AND in_office_flag = 'N'

INSERT INTO @offices (
	office_id)
SELECT office_id
FROM dbo.fn_user_privilege_offices(@ps_user_id, 'View Patients')

SELECT @ll_role_task_count = COUNT(*),
		@li_max_priority_role = max(priority)
FROM o_Active_Services a
	INNER JOIN c_User_Role r
	ON a.owned_by = r.role_id
WHERE r.user_id = @ps_user_id
AND ordered_service <> 'MESSAGE'
AND in_office_flag = 'N'
AND (office_id IS NULL OR office_id IN (SELECT office_id FROM @offices))

IF ISNULL(@li_max_priority_role, 0) > ISNULL(@li_max_priority, 0)
	SET @li_max_priority = @li_max_priority_role

INSERT INTO @counts (
	my_task_count,
	role_task_count,
	max_priority)
VALUES (
	@ll_my_task_count,
	@ll_role_task_count,
	@li_max_priority)

RETURN

END


