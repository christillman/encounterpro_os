CREATE TABLE [dbo].[c_Component_Registry] (
    [component_id]            VARCHAR (24)     NOT NULL,
    [component_type]          VARCHAR (24)     NOT NULL,
    [component]               VARCHAR (24)     NOT NULL,
    [description]             VARCHAR (80)     NULL,
    [component_class]         VARCHAR (128)    NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL,
    [component_location]      VARCHAR (255)    NULL,
    [component_data]          VARCHAR (255)    NULL,
    [component_install]       IMAGE            NULL,
    [min_build]               INT              NULL,
    [owner_id]                VARCHAR (255)    NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [last_version_installed]  INT              NULL,
    [created]                 DATETIME         NOT NULL,
    [license_data]            VARCHAR (2000)   NULL,
    [license_status]          VARCHAR (24)     NOT NULL,
    [license_expiration_date] DATETIME         NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'c_Component_Registry.component_id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2715, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1695, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2190, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3675, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3960, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'component_class';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Component_Registry', @level2type = N'COLUMN', @level2name = N'id';

