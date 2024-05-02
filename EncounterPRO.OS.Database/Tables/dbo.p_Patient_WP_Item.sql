
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[p_Patient_WP_Item]
Print 'Drop Table [dbo].[p_Patient_WP_Item]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_WP_Item]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_WP_Item]
GO
-- Create Table [dbo].[p_Patient_WP_Item]
Print 'Create Table [dbo].[p_Patient_WP_Item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_WP_Item] (
		[patient_workplan_id]                     [int] NOT NULL,
		[patient_workplan_item_id]                [int] IDENTITY(1, 1) NOT NULL,
		[cpr_id]                                  [varchar](12) NULL,
		[encounter_id]                            [int] NULL,
		[workplan_id]                             [int] NOT NULL,
		[item_number]                             [int] NULL,
		[step_number]                             [smallint] NULL,
		[item_type]                               [varchar](12) NOT NULL,
		[ordered_service]                         [varchar](24) NULL,
		[active_service_flag]                     [char](1) NOT NULL,
		[in_office_flag]                          [char](1) NULL,
		[ordered_treatment_type]                  [varchar](24) NULL,
		[ordered_workplan_id]                     [int] NULL,
		[followup_workplan_id]                    [int] NULL,
		[description]                             [varchar](80) NULL,
		[ordered_by]                              [varchar](24) NOT NULL,
		[ordered_for]                             [varchar](24) NULL,
		[priority]                                [smallint] NULL,
		[step_flag]                               [char](1) NULL,
		[auto_perform_flag]                       [char](1) NULL,
		[cancel_workplan_flag]                    [char](1) NULL,
		[dispatch_date]                           [datetime] NULL,
		[dispatch_method]                         [varchar](24) NULL,
		[consolidate_flag]                        [char](1) NULL,
		[owner_flag]                              [char](1) NULL,
		[runtime_configured_flag]                 [char](1) NULL,
		[observation_tag]                         [varchar](12) NULL,
		[dispatched_patient_workplan_item_id]     [int] NULL,
		[owned_by]                                [varchar](24) NULL,
		[begin_date]                              [datetime] NULL,
		[end_date]                                [datetime] NULL,
		[escalation_date]                         [datetime] NULL,
		[expiration_date]                         [datetime] NULL,
		[completed_by]                            [varchar](24) NULL,
		[room_id]                                 [varchar](12) NULL,
		[status]                                  [varchar](12) NULL,
		[retries]                                 [smallint] NULL,
		[folder]                                  [varchar](40) NULL,
		[created_by]                              [varchar](24) NOT NULL,
		[created]                                 [datetime] NULL,
		[id]                                      [uniqueidentifier] NOT NULL,
		[treatment_id]                            [int] NULL,
		[problem_id]                              [int] NULL,
		[attachment_id]                           [int] NULL,
		[context_object]                          [varchar](24) NULL
) ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [PK_p_Patient_WP_Item]
	PRIMARY KEY
	NONCLUSTERED
	([patient_workplan_item_id])
	WITH FILLFACTOR=70
	ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient__in_of__2D67AF2B]
	DEFAULT ('N') FOR [in_office_flag]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient__runti__2E5BD364]
	DEFAULT ('N') FOR [runtime_configured_flag]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient_WP__id__2F4FF79D]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF_p_Patient_Workplan_Item_created]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF_ppwi_active_service_flag_b12]
	DEFAULT ('N') FOR [active_service_flag]
GO
CREATE NONCLUSTERED INDEX [idx_active_services]
	ON [dbo].[p_Patient_WP_Item] ([active_service_flag], [in_office_flag], [patient_workplan_item_id], [ordered_service], [owned_by])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 50) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_cpr_id]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [encounter_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_dispatched_patient_workplan_id]
	ON [dbo].[p_Patient_WP_Item] ([dispatched_patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_item_owner]
	ON [dbo].[p_Patient_WP_Item] ([owned_by], [in_office_flag], [ordered_service], [patient_workplan_item_id], [status], [active_service_flag])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_ordered_by]
	ON [dbo].[p_Patient_WP_Item] ([ordered_by], [ordered_service], [dispatch_date])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_ordered_for]
	ON [dbo].[p_Patient_WP_Item] ([ordered_for], [ordered_service], [status], [folder])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_owned_by_date]
	ON [dbo].[p_Patient_WP_Item] ([owned_by], [dispatch_date], [active_service_flag], [ordered_service])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_workplan_item_id]
	ON [dbo].[p_Patient_WP_Item] ([patient_workplan_id], [patient_workplan_item_id], [item_number])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE CLUSTERED INDEX [idx_wp_item_cluster]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wp_item_guid]
	ON [dbo].[p_Patient_WP_Item] ([id], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wpi_context_object]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [context_object], [encounter_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wpi_documents]
	ON [dbo].[p_Patient_WP_Item] ([item_type], [status], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO


CREATE NONCLUSTERED INDEX [idx_ordered_active_service]
	ON [dbo].[p_Patient_WP_Item] ([ordered_service], [active_service_flag], [owned_by])
	INCLUDE ([priority])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_owner_flag]
	ON [dbo].[p_Patient_WP_Item] ([owner_flag])
	INCLUDE ([patient_workplan_id], [owned_by])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_item_type]
	ON [dbo].[p_Patient_WP_Item] ([item_type], [context_object])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_cpr_treatment_id]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_ordered_service]
	ON [dbo].[p_Patient_WP_Item] ([ordered_service])
	INCLUDE ([patient_workplan_id], [encounter_id], [workplan_id], [item_number], [step_number], [item_type], [active_service_flag], [in_office_flag], [ordered_treatment_type], [ordered_workplan_id], [followup_workplan_id], [description], [ordered_by], [ordered_for], [priority], [step_flag], [auto_perform_flag], [cancel_workplan_flag], [dispatch_date], [dispatch_method], [consolidate_flag], [owner_flag], [runtime_configured_flag], [observation_tag], [dispatched_patient_workplan_item_id], [owned_by], [begin_date], [end_date], [escalation_date], [expiration_date], [completed_by], [room_id], [status], [retries], [folder], [created_by], [created], [id], [treatment_id], [problem_id], [attachment_id], [context_object])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO


GRANT DELETE
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item] SET (LOCK_ESCALATION = TABLE)
GO

