CREATE TABLE [dbo].[c_Chart_Section_Page] (
    [chart_id]      INT              NOT NULL,
    [section_id]    INT              NOT NULL,
    [page_id]       INT              IDENTITY (1, 1) NOT NULL,
    [sort_sequence] SMALLINT         NULL,
    [description]   VARCHAR (40)     NULL,
    [page_class]    VARCHAR (80)     NULL,
    [bitmap]        VARCHAR (128)    NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((chart_id=9))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'c_Chart_Section_Page.chart_id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'chart_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'chart_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 870, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'chart_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'section_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'section_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1065, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'section_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 855, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1545, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2805, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'page_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'bitmap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'bitmap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1890, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'bitmap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1965, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Chart_Section_Page', @level2type = N'COLUMN', @level2name = N'id';

