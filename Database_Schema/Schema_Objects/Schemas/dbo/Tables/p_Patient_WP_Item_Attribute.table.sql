CREATE TABLE [dbo].[p_Patient_WP_Item_Attribute] (
    [patient_workplan_item_id] INT              NOT NULL,
    [attribute_sequence]       INT              IDENTITY (1, 1) NOT NULL,
    [patient_workplan_id]      INT              NOT NULL,
    [cpr_id]                   VARCHAR (12)     NULL,
    [attribute]                VARCHAR (64)     NOT NULL,
    [message]                  TEXT             NULL,
    [created_by]               VARCHAR (24)     NOT NULL,
    [created]                  DATETIME         NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [value_short]              VARCHAR (50)     NULL,
    [actor_id]                 INT              NULL,
    [value]                    AS               (convert(varchar(255),[value_short]))
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((p_Patient_WP_Item_Attribute.patient_workplan_item_id=345862))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2370, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'patient_workplan_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'cpr_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1755, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created_by';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Patient_WP_Item_Attribute', @level2type = N'COLUMN', @level2name = N'id';

