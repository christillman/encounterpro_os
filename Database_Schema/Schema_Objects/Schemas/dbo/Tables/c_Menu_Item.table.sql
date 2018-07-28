CREATE TABLE [dbo].[c_Menu_Item] (
    [menu_id]            INT              NOT NULL,
    [menu_item_id]       INT              IDENTITY (1, 1) NOT NULL,
    [menu_item_type]     VARCHAR (24)     NOT NULL,
    [menu_item]          VARCHAR (24)     NOT NULL,
    [button_title]       VARCHAR (40)     NULL,
    [button_help]        VARCHAR (255)    NULL,
    [button]             VARCHAR (128)    NULL,
    [sort_sequence]      SMALLINT         NULL,
    [auto_close_flag]    CHAR (1)         NOT NULL,
    [authorized_user_id] VARCHAR (24)     NULL,
    [context_object]     VARCHAR (24)     NULL,
    [id]                 UNIQUEIDENTIFIER NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((menu_id=483))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'c_Menu_Item.sort_sequence', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2025, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2565, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'menu_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2670, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_help';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_help';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3720, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button_help';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2610, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'button';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Menu_Item', @level2type = N'COLUMN', @level2name = N'sort_sequence';

