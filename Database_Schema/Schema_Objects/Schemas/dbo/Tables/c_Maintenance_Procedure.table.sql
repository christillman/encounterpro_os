CREATE TABLE [dbo].[c_Maintenance_Procedure] (
    [maintenance_rule_id] INT          NOT NULL,
    [procedure_id]        VARCHAR (24) NOT NULL,
    [primary_flag]        CHAR (1)     NULL,
    [treatment_type]      VARCHAR (24) NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'maintenance_rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'maintenance_rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1965, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'maintenance_rule_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'procedure_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'procedure_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2355, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'procedure_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'primary_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'primary_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Maintenance_Procedure', @level2type = N'COLUMN', @level2name = N'primary_flag';

