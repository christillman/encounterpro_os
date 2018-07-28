CREATE TABLE [dbo].[c_Display_Format_Item] (
    [display_format] VARCHAR (40)   NOT NULL,
    [item_sequence]  INT            IDENTITY (1, 1) NOT NULL,
    [command]        VARCHAR (40)   NOT NULL,
    [argument]       VARCHAR (2048) NULL,
    [sort_sequence]  SMALLINT       NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((display_format ALike "acog%"))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'c_Display_Format_Item.sort_sequence', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'display_format';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'display_format';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3330, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'display_format';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 495, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'item_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'command';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'command';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2850, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'command';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'argument';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'argument';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 9705, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'argument';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 495, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Display_Format_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';

