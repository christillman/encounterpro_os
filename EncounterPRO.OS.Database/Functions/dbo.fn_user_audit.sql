--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
CREATE FUNCTION fn_user_audit (
	@ps_user_id varchar(24),
	@pdt_audit_date datetime = NULL,
	@ps_include_object_updates char(1) = 'Y'
	)

RETURNS @events TABLE (
	cpr_id varchar(12) NULL,
	billing_id varchar(24) NULL,
	patient_name varchar(128) NULL,
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
	user_id varchar(24) NULL ,
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
	FROM fn_patient_object_progress_user(@ps_user_id, @ldt_begin_date, @ldt_end_date) p
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
GRANT SELECT
	ON [dbo].[fn_user_audit]
	TO [cprsystem]
GO

