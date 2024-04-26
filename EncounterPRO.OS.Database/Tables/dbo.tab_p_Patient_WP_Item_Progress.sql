
-- DROP TRIGGER [dbo].[tr_patient_wp_item_progress_insert]
-- DROP PROCEDURE [dbo].sp_update_patient_wp_item_2

DROP TYPE IF EXISTS [tab_p_Patient_WP_Item_Progress]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TYPE [tab_p_Patient_WP_Item_Progress]
	AS TABLE (
	[patient_workplan_id] [int] NOT NULL,
	[patient_workplan_item_id] [int] NOT NULL,
	[patient_workplan_item_prog_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[user_id] [varchar](24) NOT NULL,
	[progress_date_time] [datetime] NOT NULL,
	[progress_type] [varchar](24) NOT NULL,
	[created] [datetime] NULL,
	[created_by] [varchar](24) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[computer_id] [int] NULL,
	PRIMARY KEY NONCLUSTERED 
	(
		[patient_workplan_item_id] ASC,
		[patient_workplan_item_prog_id] ASC
	)
) 