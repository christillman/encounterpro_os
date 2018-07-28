CREATE TABLE [dbo].[c_Drug_Definition] (
    [drug_id]                        VARCHAR (24)     NOT NULL,
    [drug_type]                      VARCHAR (24)     NULL,
    [common_name]                    VARCHAR (40)     NULL,
    [generic_name]                   VARCHAR (80)     NULL,
    [controlled_substance_flag]      CHAR (1)         NULL,
    [default_duration_amount]        REAL             NULL,
    [default_duration_unit]          VARCHAR (16)     NULL,
    [default_duration_prn]           VARCHAR (32)     NULL,
    [max_dose_per_day]               REAL             NULL,
    [max_dose_unit]                  VARCHAR (12)     NULL,
    [status]                         VARCHAR (12)     NULL,
    [id]                             UNIQUEIDENTIFIER NOT NULL,
    [last_updated]                   DATETIME         NOT NULL,
    [owner_id]                       INT              NOT NULL,
    [patient_reference_material_id]  INT              NULL,
    [provider_reference_material_id] INT              NULL,
    [dea_schedule]                   VARCHAR (6)      NOT NULL,
    [dea_number]                     VARCHAR (18)     NULL,
    [dea_narcotic_status]            VARCHAR (20)     NULL,
    [procedure_id]                   VARCHAR (24)     NULL,
    [reference_ndc_code]             VARCHAR (24)     NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((c_Drug_Definition.common_name ALike "%Prolex%"))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3315, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'drug_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'common_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'common_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2250, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'common_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'generic_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'generic_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 4110, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'generic_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'controlled_substance_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'controlled_substance_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'controlled_substance_flag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_prn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_prn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'default_duration_prn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_per_day';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_per_day';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_per_day';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'max_dose_unit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Drug_Definition', @level2type = N'COLUMN', @level2name = N'id';

