CREATE TABLE [dbo].[u_assessment_treat_def_attrib] (
    [definition_id]      INT           NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (80)  NOT NULL,
    [value]              VARCHAR (255) NULL,
    [long_value]         TEXT          NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((u_assessment_treat_def_attrib.definition_id=323))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'u_assessment_treat_def_attrib.definition_id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'definition_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'attribute';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'value';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'value';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_assessment_treat_def_attrib', @level2type = N'COLUMN', @level2name = N'value';

