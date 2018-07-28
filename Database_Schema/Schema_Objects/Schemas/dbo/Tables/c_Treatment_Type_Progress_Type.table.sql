CREATE TABLE [dbo].[c_Treatment_Type_Progress_Type] (
    [treatment_type]               VARCHAR (24) NOT NULL,
    [progress_type]                VARCHAR (24) NOT NULL,
    [display_flag]                 CHAR (1)     NULL,
    [display_style]                VARCHAR (24) NULL,
    [soap_display_style]           VARCHAR (24) NULL,
    [progress_key_required_flag]   CHAR (1)     NULL,
    [progress_key_enumerated_flag] CHAR (1)     NULL,
    [progress_key_object]          VARCHAR (24) NULL,
    [sort_sequence]                SMALLINT     NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((c_Treatment_Type_Progress_Type.progress_type="Rest Dose Given"))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'treatment_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'soap_display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'soap_display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'soap_display_style';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_required_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_required_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_required_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_enumerated_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_enumerated_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_enumerated_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1980, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Treatment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'sort_sequence';

