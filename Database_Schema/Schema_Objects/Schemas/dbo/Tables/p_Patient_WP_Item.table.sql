CREATE TABLE [dbo].[p_Patient_WP_Item] (
    [patient_workplan_id]                 INT              NOT NULL,
    [patient_workplan_item_id]            INT              IDENTITY (1, 1) NOT NULL,
    [cpr_id]                              VARCHAR (12)     NULL,
    [encounter_id]                        INT              NULL,
    [workplan_id]                         INT              NOT NULL,
    [item_number]                         INT              NULL,
    [step_number]                         SMALLINT         NULL,
    [item_type]                           VARCHAR (12)     NOT NULL,
    [ordered_service]                     VARCHAR (24)     NULL,
    [active_service_flag]                 CHAR (1)         NOT NULL,
    [in_office_flag]                      CHAR (1)         NULL,
    [ordered_treatment_type]              VARCHAR (24)     NULL,
    [ordered_workplan_id]                 INT              NULL,
    [followup_workplan_id]                INT              NULL,
    [description]                         VARCHAR (80)     NULL,
    [ordered_by]                          VARCHAR (24)     NOT NULL,
    [ordered_for]                         VARCHAR (24)     NULL,
    [priority]                            SMALLINT         NULL,
    [step_flag]                           CHAR (1)         NULL,
    [auto_perform_flag]                   CHAR (1)         NULL,
    [cancel_workplan_flag]                CHAR (1)         NULL,
    [dispatch_date]                       DATETIME         NULL,
    [dispatch_method]                     VARCHAR (24)     NULL,
    [consolidate_flag]                    CHAR (1)         NULL,
    [owner_flag]                          CHAR (1)         NULL,
    [runtime_configured_flag]             CHAR (1)         NULL,
    [observation_tag]                     VARCHAR (12)     NULL,
    [dispatched_patient_workplan_item_id] INT              NULL,
    [owned_by]                            VARCHAR (24)     NULL,
    [begin_date]                          DATETIME         NULL,
    [end_date]                            DATETIME         NULL,
    [escalation_date]                     DATETIME         NULL,
    [expiration_date]                     DATETIME         NULL,
    [completed_by]                        VARCHAR (24)     NULL,
    [room_id]                             VARCHAR (12)     NULL,
    [status]                              VARCHAR (12)     NULL,
    [retries]                             SMALLINT         NULL,
    [folder]                              VARCHAR (40)     NULL,
    [created_by]                          VARCHAR (24)     NOT NULL,
    [created]                             DATETIME         NULL,
    [id]                                  UNIQUEIDENTIFIER NOT NULL,
    [treatment_id]                        INT              NULL,
    [problem_id]                          INT              NULL,
    [attachment_id]                       INT              NULL,
    [context_object]                      VARCHAR (24)     NULL
) ON [Workflow];




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_service';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_service';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_service';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'active_service_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'active_service_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'active_service_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'in_office_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'in_office_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'in_office_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'followup_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_for';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_for';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'ordered_for';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'priority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'priority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'priority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'step_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'auto_perform_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'auto_perform_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'auto_perform_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cancel_workplan_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cancel_workplan_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'cancel_workplan_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_method';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_method';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatch_method';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'consolidate_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'consolidate_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'consolidate_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owner_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owner_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owner_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'runtime_configured_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'runtime_configured_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'runtime_configured_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'observation_tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'observation_tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'observation_tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatched_patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatched_patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'dispatched_patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owned_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owned_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'owned_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'begin_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'begin_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'begin_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'end_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'end_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'end_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'escalation_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'escalation_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'escalation_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'expiration_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'expiration_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'expiration_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'completed_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'completed_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'completed_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'room_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'room_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'room_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'retries';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'retries';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'retries';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'folder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'folder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'folder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item', @level2type = N'COLUMN', @level2name = N'id';

