CREATE TABLE [dbo].[em_Visit_Level_Rule_Item] (
    [em_documentation_guide] VARCHAR (24) NOT NULL,
    [visit_level]            INT          NOT NULL,
    [rule_id]                INT          NOT NULL,
    [item_sequence]          INT          NOT NULL,
    [em_component]           VARCHAR (24) NULL,
    [min_em_component_level] INT          NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'visit_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'visit_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'visit_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1620, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_em_component_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_em_component_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Visit_Level_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_em_component_level';

