CREATE TABLE [dbo].[c_Database_Table] (
    [tablename]               VARCHAR (64)     NOT NULL,
    [major_release]           INT              NOT NULL,
    [database_version]        VARCHAR (4)      NOT NULL,
    [index_script]            TEXT             NULL,
    [last_update]             DATETIME         NOT NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL,
    [sync_algorithm]          VARCHAR (24)     NOT NULL,
    [parent_tablename]        VARCHAR (64)     NULL,
    [create_script]           TEXT             NULL,
    [trigger_script]          TEXT             NULL,
    [modification_level]      INT              NULL,
    [sync_modification_level] INT              NULL,
    [permission_script]       VARCHAR (255)    NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'(((c_Database_Table.sync_algorithm="c-Object"))) AND ((c_Database_Table.parent_tablename Is Null))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'c_Database_Table.sync_algorithm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3210, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'major_release';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'major_release';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'major_release';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'database_version';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'database_version';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'database_version';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'index_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'index_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'index_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'last_update';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'last_update';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'last_update';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'sync_algorithm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'sync_algorithm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1740, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'sync_algorithm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'parent_tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'parent_tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2325, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'parent_tablename';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'create_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'create_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'create_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'trigger_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'trigger_script';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Database_Table', @level2type = N'COLUMN', @level2name = N'trigger_script';

