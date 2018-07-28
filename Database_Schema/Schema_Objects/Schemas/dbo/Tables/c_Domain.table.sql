CREATE TABLE [dbo].[c_Domain] (
    [domain_id]               VARCHAR (24)     NOT NULL,
    [domain_sequence]         SMALLINT         NOT NULL,
    [domain_item]             VARCHAR (40)     NULL,
    [domain_item_description] VARCHAR (80)     NULL,
    [domain_item_bitmap]      VARCHAR (255)    NULL,
    [sort_sequence]           SMALLINT         NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL,
    [last_updated]            DATETIME         NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2400, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2265, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2370, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_bitmap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_bitmap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Domain', @level2type = N'COLUMN', @level2name = N'domain_item_bitmap';

