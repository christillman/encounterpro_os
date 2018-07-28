CREATE TABLE [dbo].[em_Type_Rule_Item] (
    [em_documentation_guide]    VARCHAR (24) NOT NULL,
    [em_component]              VARCHAR (24) NOT NULL,
    [em_type]                   VARCHAR (24) NOT NULL,
    [em_type_level]             INT          NOT NULL,
    [rule_id]                   INT          NOT NULL,
    [item_sequence]             INT          NOT NULL,
    [em_category]               VARCHAR (24) NULL,
    [min_element_count]         INT          NULL,
    [min_category_count]        INT          NULL,
    [min_elements_per_category] INT          NULL,
    [min_encounter_complexity]  INT          NULL,
    [min_encounter_risk_level]  INT          NULL,
    [min_encounter_results]     INT          NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_documentation_guide';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2085, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_type_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'em_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_element_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_element_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_element_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_category_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_category_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_category_count';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_elements_per_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_elements_per_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_elements_per_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_complexity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_complexity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_complexity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_results';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_results';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'em_Type_Rule_Item', @level2type = N'COLUMN', @level2name = N'min_encounter_results';

