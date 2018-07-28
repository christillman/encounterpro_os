CREATE FUNCTION fn_user_task_list_count (
	@ps_user_id varchar(24),
	@ps_task_list_id varchar(24) )

RETURNS @counts TABLE (
	task_count int NULL,
	max_priority smallint NULL )

AS

BEGIN

DECLARE @offices TABLE (
	office_id varchar(4) NOT NULL)

IF LEFT(@ps_task_list_id, 1) = '!'
	BEGIN
	INSERT INTO @counts (
		task_count,
		max_priority)
	SELECT COUNT(*), 
		max(priority)
	FROM o_Active_Services
	WHERE owned_by = @ps_task_list_id
	AND ordered_service <> 'MESSAGE'
	AND in_office_flag = 'N'
	END
ELSE
	BEGIN
	INSERT INTO @offices (
		office_id)
	SELECT office_id
	FROM dbo.fn_user_privilege_offices(@ps_user_id, 'View Patients')

	INSERT INTO @counts (
		task_count,
		max_priority)
	SELECT COUNT(*), 
		max(priority)
	FROM o_Active_Services
	WHERE owned_by = @ps_task_list_id
	AND ordered_service <> 'MESSAGE'
	AND in_office_flag = 'N'
	AND (office_id IS NULL OR office_id IN (SELECT office_id FROM @offices))
	END

RETURN

END


