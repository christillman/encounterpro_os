CREATE TABLE [dbo].[x_Integrations] (
    [Name]             VARCHAR (50)  NOT NULL,
    [billing_system]   VARCHAR (20)  NOT NULL,
    [Schedule_Id]      VARCHAR (50)  NOT NULL,
    [Billing_Id]       VARCHAR (50)  NOT NULL,
    [message_handler]  VARCHAR (24)  NULL,
    [message_type_in]  VARCHAR (50)  NOT NULL,
    [message_type_out] VARCHAR (50)  NOT NULL,
    [message_in]       VARCHAR (50)  NOT NULL,
    [message_out]      VARCHAR (50)  NOT NULL,
    [input_file]       VARCHAR (255) NOT NULL,
    [output_file]      VARCHAR (255) NOT NULL,
    [Enabled]          CHAR (1)      NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((x_Integrations.message_type_in ALike "LYTEC_DEMO"))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2835, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'billing_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'billing_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'billing_system';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Schedule_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Schedule_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2520, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Schedule_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Billing_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Billing_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2325, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Billing_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_handler';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_handler';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3090, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_handler';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2880, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2970, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_type_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2355, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_in';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2565, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'message_out';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'input_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'input_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3285, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'input_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'output_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'output_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3480, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'output_file';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Enabled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Enabled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'x_Integrations', @level2type = N'COLUMN', @level2name = N'Enabled';

