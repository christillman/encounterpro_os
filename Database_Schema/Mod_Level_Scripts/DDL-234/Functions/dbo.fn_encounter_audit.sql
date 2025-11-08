
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_encounter_audit]
Print 'Drop Function [dbo].[fn_encounter_audit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_encounter_audit]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_encounter_audit]
GO

-- Create Function [dbo].[fn_encounter_audit]
Print 'Create Function [dbo].[fn_encounter_audit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_encounter_audit (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_include_object_updates char(1) = 'Y'
	)
RETURNS @events TABLE (
	Time datetime NOT NULL,
	Provider varchar(64) NOT NULL ,
	context_object varchar(24) NOT NULL ,
	object_key int NULL ,
	object_type varchar(24) NULL ,
	object_description varchar(80) NULL ,
	Item_Type varchar(12) NOT NULL ,
	Item varchar(80) NULL ,
	Action varchar(80) NULL ,
	event_id int NULL ,
	[user_id] varchar(255) NULL )
AS

BEGIN

INSERT INTO @events (
	Time ,
	Provider ,
	context_object ,
	object_key ,
	Item_Type ,
	Item ,
	Action ,
	event_id ,
	[user_id] )
SELECT ip.created
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
	,ip.[user_id]
FROM	p_patient p WITH (NOLOCK)
	INNER JOIN p_patient_wp_item i WITH (NOLOCK)
	ON	p.cpr_id = i.cpr_id 
	INNER JOIN p_patient_wp wp WITH (NOLOCK)
	ON	i.patient_workplan_id = wp.patient_workplan_id 
	INNER JOIN p_patient_wp_item_progress ip WITH (NOLOCK)
	ON	i.patient_workplan_item_id = ip.patient_workplan_item_id
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ip.[user_id] = u.[user_id]
WHERE ip.cpr_id = @ps_cpr_id
AND	i.cpr_id = @ps_cpr_id
AND ip.progress_type NOT IN ('Runtime_Configured', 'dispatched', 'clicked', 'Skipped')
AND	ip.encounter_id = @pl_encounter_id

UPDATE @events
SET object_type = dbo.fn_context_object_type(context_object, @ps_cpr_id, object_key),
	object_description = dbo.fn_patient_object_description(@ps_cpr_id, context_object, object_key)

IF @ps_include_object_updates IN ('Y', 'T')
	INSERT INTO @events (
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
		[user_id] )
	SELECT p.progress_created
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
	FROM dbo.fn_patient_object_progress_in_encounter(@ps_cpr_id, @pl_encounter_id) p
		INNER JOIN c_user u WITH (NOLOCK)
		ON	p.progress_user_id = u.[user_id]


-- Now include all logon/logoff events where the user touched this encounter
DECLARE @sessions TABLE (
	[session_id] int NOT NULL)

INSERT INTO @sessions (
	[session_id])
SELECT DISTINCT ul.[session_id]
FROM @events e
	INNER JOIN o_User_Logins ul
	ON e.[user_id] = ul.[user_id]
WHERE e.time <= ul.action_time
AND e.time >= ul.session_start_time
AND ul.action = 'Logout'

INSERT INTO @events (
	Time ,
	Provider ,
	Context_object ,
	Item_type ,
	Item ,
	Action ,
	event_id ,
	[user_id] )
SELECT Time=ul.action_time
	,Provider = u.user_full_name
	,'User'
	,'Session'
	,c.computername + '/' + c.logon_id + ' in office ' + ul.office_id
	,ul.action
	,ul.action_id
	,ul.[user_id]
FROM @sessions s
	INNER JOIN o_User_Logins ul
	ON s.[session_id] = ul.[session_id]
	INNER JOIN c_user u WITH (NOLOCK)
	ON	ul.[user_id] = u.[user_id]
	INNER JOIN o_Computers c WITH (NOLOCK)
	ON	ul.computer_id = c.computer_id


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_encounter_audit] TO [cprsystem]
GO

