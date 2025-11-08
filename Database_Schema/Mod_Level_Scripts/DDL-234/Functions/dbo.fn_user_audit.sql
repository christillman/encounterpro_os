
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_user_audit]
Print 'Drop Function [dbo].[fn_user_audit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_audit]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_audit]
GO

-- Create Function [dbo].[fn_user_audit]
Print 'Create Function [dbo].[fn_user_audit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_user_audit (
	@ps_user_id varchar(255),
	@pdt_audit_date datetime = NULL,
	@ps_include_object_updates char(1) = 'Y'
	)

RETURNS @events TABLE (
	cpr_id varchar(12) NULL,
	billing_id varchar(24) NULL,
	patient_name varchar(128) NULL,
	[Time] datetime NOT NULL,
	[Provider] varchar(64) NOT NULL ,
	context_object varchar(24) NOT NULL ,
	object_key int NULL ,
	object_type varchar(24) NULL ,
	object_description varchar(80) NULL ,
	Item_Type varchar(12) NOT NULL ,
	Item varchar(80) NULL ,
	[Action] varchar(80) NULL ,
	event_id int NULL ,
	[user_id] varchar(255) NULL ,
	computer_id int NULL ,
	computer_description varchar(80) NULL )
AS

BEGIN

DECLARE @ldt_begin_date datetime,
		@ldt_end_date datetime

SET @ldt_begin_date = dbo.fn_date_truncate(@pdt_audit_date, 'DAY')
SET @ldt_end_date = DATEADD(day, 1, @ldt_begin_date)

INSERT INTO @events (
	cpr_id,
	billing_id,
	patient_name,
	Time ,
	Provider ,
	context_object ,
	object_key ,
	Item_Type ,
	Item ,
	Action ,
	event_id ,
	user_id ,
	computer_id)
SELECT i.cpr_id
	,p.billing_id
	,dbo.fn_pretty_name(p.last_name, p.first_name, p.middle_name, p.name_suffix, p.name_prefix, p.degree)
	,ip.created
	,u.user_full_name
	,CASE wp.workplan_type WHEN 'Patient' THEN 'Patient'
							WHEN 'Encounter' THEN 'Encounter'
							WHEN 'Assessment' THEN 'Assessment'
							WHEN 'Treatment' THEN 'Treatment'
							WHEN 'Followup' THEN 'Treatment'
							WHEN 'Referral' THEN 'Treatment'
							WHEN 'Observation' THEN 'Observation'
							WHEN 'Attachment' THEN 'Attachment'
							WHEN 'General' THEN 'General'
							ELSE 'Encounter' END
	,CASE wp.workplan_type WHEN 'Patient' THEN NULL
							WHEN 'Encounter' THEN wp.encounter_id
							WHEN 'Assessment' THEN wp.problem_id
							WHEN 'Treatment' THEN wp.treatment_id
							WHEN 'Followup' THEN wp.treatment_id
							WHEN 'Referral' THEN wp.treatment_id
							WHEN 'Observation' THEN wp.observation_sequence
							WHEN 'Attachment' THEN wp.attachment_id
							WHEN 'General' THEN NULL
							ELSE wp.encounter_id END
	,'Service'
	,i.description
	,lower(ip.progress_type)
	,ip.patient_workplan_item_prog_id
	,ip.user_id
	,ip.computer_id
FROM	p_patient_wp_item i WITH (NOLOCK)
	INNER JOIN p_patient_wp wp WITH (NOLOCK)
	ON	i.patient_workplan_id = wp.patient_workplan_id 
	INNER JOIN p_patient_wp_item_progress ip WITH (NOLOCK)
	ON	i.patient_workplan_item_id = ip.patient_workplan_item_id
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ip.user_id = u.user_id
	LEFT OUTER JOIN p_patient p WITH (NOLOCK)
	ON	p.cpr_id = i.cpr_id 
WHERE ip.user_id = @ps_user_id
AND	ip.created >= @ldt_begin_date
AND	ip.created < @ldt_end_date
AND ip.progress_type NOT IN ('Runtime_Configured', 'dispatched', 'clicked', 'Skipped', 'Error')

UPDATE @events
SET object_type = dbo.fn_context_object_type(context_object, cpr_id, object_key),
	object_description = dbo.fn_patient_object_description(cpr_id, context_object, object_key)

IF @ps_include_object_updates IN ('Y', 'T')
	INSERT INTO @events (
		cpr_id,
		billing_id,
		patient_name,
		Time ,
		Provider ,
		Context_object ,
		object_key ,
		object_type ,
		object_description ,
		Item_Type ,
		Item ,
		Action ,
		event_id ,
		user_id )
	SELECT p.cpr_id
		,pp.billing_id
		,dbo.fn_pretty_name(pp.last_name, pp.first_name, pp.middle_name, pp.name_suffix, pp.name_prefix, pp.degree)
		,p.progress_created
		,u.user_full_name
		,p.context_object
		,p.object_key
		,p.object_type
		,CAST(p.description AS varchar(80))
		,'Progress'
		,upper(p.progress_type)
		,CAST(CASE WHEN p.progress_key IS NULL THEN p.progress ELSE p.progress_key + ' = ' + p.progress END AS varchar(80))
		,p.progress_sequence
		,p.progress_user_id
	FROM dbo.fn_patient_object_progress_user(@ps_user_id, @ldt_begin_date, @ldt_end_date) p
		INNER JOIN c_user u WITH (NOLOCK)
		ON	p.progress_user_id = u.user_id
		INNER JOIN p_Patient pp
		ON p.cpr_id = pp.cpr_id


-- Now include all logon/logoff events

INSERT INTO @events (
	Time ,
	Provider ,
	Context_object ,
	Item_type ,
	Item ,
	Action ,
	event_id ,
	user_id ,
	computer_id )
SELECT Time=ul.action_time
	,Provider = u.user_full_name
	,'User'
	,'Security'
	,ul.action + COALESCE(' for ' + u2.user_short_name, '')
	,ul.action_status + CASE WHEN ul.action = 'Login' THEN ', winuser: ' + c.logon_id + ', office: ' + ul.office_id ELSE '' END
	,ul.action_id
	,ul.user_id
	,ul.computer_id
FROM o_User_Logins ul
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ul.user_id = u.user_id
	INNER JOIN o_Computers c WITH (NOLOCK)
	ON	ul.computer_id = c.computer_id
	LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
	ON ul.action_for_user_id = u2.user_id
WHERE ul.action_time >= @ldt_begin_date
AND ul.action_time < @ldt_end_date
AND ul.user_id = @ps_user_id

UPDATE e
SET computer_description = COALESCE(c.description, c.computername)
FROM @events e
	INNER JOIN o_Computers c
	ON e.computer_id = c.computer_id


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_user_audit] TO [cprsystem]
GO

