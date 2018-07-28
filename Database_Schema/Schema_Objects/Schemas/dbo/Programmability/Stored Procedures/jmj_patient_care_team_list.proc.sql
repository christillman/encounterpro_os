CREATE PROCEDURE jmj_patient_care_team_list (
	@ps_cpr_id varchar(24),
	@ps_show_users_flag char(1) = 'Y',
	@ps_other_actor_class varchar(24) = '%' )
AS

DECLARE @ls_authority_id varchar(24)

DECLARE @actor_class TABLE (
	actor_class varchar(24) NOT NULL)

IF @ps_show_users_flag = 'Y'
	INSERT INTO @actor_class (
		actor_class )
	VALUES (
		'User')

IF @ps_other_actor_class IS NOT NULL
	INSERT INTO @actor_class (
		actor_class )
	SELECT actor_class
	FROM c_Actor_Class
	WHERE actor_class LIKE @ps_other_actor_class
	AND actor_class <> 'User'


SELECT ct.user_id,
	ct.user_full_name,
	ct.user_short_name,
	ct.color,
	ct.icon,
	selected_flag=CONVERT(int, 0),
	ct.user_status,
	ct.type,
	ct.user_key,
	ct.email_address,
	ct.specialty_id,
	ct.specialty_description,
	ct.preferred_provider,
	ct.pretty_address,
	ct.actor_class,
	primary_actor_flag= CASE WHEN ct.primary_actor = 1 THEN 'Y' ELSE 'N' END
FROM dbo.fn_patient_care_team_list(@ps_cpr_id) ct
	INNER JOIN @actor_class ac
	ON ct.actor_class = ac.actor_class


