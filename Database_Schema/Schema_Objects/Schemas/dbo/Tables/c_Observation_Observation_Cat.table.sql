CREATE TABLE [dbo].[c_Observation_Observation_Cat] (
    [treatment_type]          VARCHAR (24) NOT NULL,
    [observation_category_id] VARCHAR (24) NOT NULL,
    [observation_id]          VARCHAR (24) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3420, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_category_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_category_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3720, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_category_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3450, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Observation_Observation_Cat', @level2type = N'COLUMN', @level2name = N'observation_id';

