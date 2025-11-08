
DROP TYPE IF EXISTS [tab_p_Patient_WP_Item]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TYPE [tab_p_Patient_WP_Item] 
	AS TABLE (
	[patient_workplan_id] [int] NOT NULL,
	[patient_workplan_item_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[workplan_id] [int] NOT NULL,
	[item_number] [int] NULL,
	[step_number] [smallint] NULL,
	[item_type] [varchar](12) NOT NULL,
	[ordered_service] [varchar](24) NULL,
	[active_service_flag] [char](1) NOT NULL,
	[in_office_flag] [char](1) NULL,
	[ordered_treatment_type] [varchar](24) NULL,
	[ordered_workplan_id] [int] NULL,
	[followup_workplan_id] [int] NULL,
	[description] [varchar](80) NULL,
	[ordered_by] [varchar](255) NOT NULL,
	[ordered_for] [varchar](255) NULL,
	[priority] [smallint] NULL,
	[step_flag] [char](1) NULL,
	[auto_perform_flag] [char](1) NULL,
	[cancel_workplan_flag] [char](1) NULL,
	[dispatch_date] [datetime] NULL,
	[dispatch_method] [varchar](24) NULL,
	[consolidate_flag] [char](1) NULL,
	[owner_flag] [char](1) NULL,
	[runtime_configured_flag] [char](1) NULL,
	[observation_tag] [varchar](12) NULL,
	[dispatched_patient_workplan_item_id] [int] NULL,
	[owned_by] [varchar](255) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[escalation_date] [datetime] NULL,
	[expiration_date] [datetime] NULL,
	[completed_by] [varchar](255) NULL,
	[room_id] [varchar](12) NULL,
	[status] [varchar](12) NULL,
	[retries] [smallint] NULL,
	[folder] [varchar](40) NULL,
	[created_by] [varchar](255) NOT NULL,
	[created] [datetime] NULL,
	[id] [uniqueidentifier] NOT NULL,
	[treatment_id] [int] NULL,
	[problem_id] [int] NULL,
	[attachment_id] [int] NULL,
	[context_object] [varchar](24) NULL,
	PRIMARY KEY NONCLUSTERED 
	(
		[patient_workplan_item_id] ASC
	)
) 