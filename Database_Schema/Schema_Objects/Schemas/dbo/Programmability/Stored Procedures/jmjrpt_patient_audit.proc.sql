



CREATE PROCEDURE jmjrpt_patient_audit (
	@ps_cpr_id varchar(12)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
	)
AS

Declare @ldt_begin_date datetime,
		@ldt_end_date datetime

IF @ps_begin_date IS NULL OR @ps_begin_date = ''
	SET @ps_begin_date = '1/1/1900'
SET @ldt_begin_date = CAST(@ps_begin_date AS datetime)

IF @ps_end_date IS NULL OR @ps_end_date = ''
	SET @ps_end_date = '1/1/2100'
SET @ldt_end_date = CAST(@ps_end_date + ' 23:59:59' AS datetime)

SELECT Time=ip.created
	,Provider = u.user_full_name
	,Service=i.description
	,Action=lower(ip.progress_type)
FROM	p_patient p WITH (NOLOCK)
	INNER JOIN p_patient_wp_item i WITH (NOLOCK)
	ON	p.cpr_id = i.cpr_id 
	INNER JOIN p_patient_wp_item_progress ip WITH (NOLOCK)
	ON	i.patient_workplan_item_id = ip.patient_workplan_item_id
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ip.user_id = u.user_id
WHERE ip.cpr_id = @ps_cpr_id
AND	i.cpr_id = @ps_cpr_id
AND ip.progress_type NOT IN ('Runtime_Configured', 'dispatched', 'clicked')
AND	ip.created >= @ldt_begin_date
AND	ip.created <= @ldt_end_date
ORDER BY ip.patient_workplan_item_prog_id