CREATE TABLE [dbo].[u_Top_20] (
    [user_id]         VARCHAR (24)  NOT NULL,
    [top_20_code]     VARCHAR (64)  NOT NULL,
    [top_20_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [item_text]       VARCHAR (255) NULL,
    [item_id]         VARCHAR (64)  NULL,
    [item_id2]        VARCHAR (24)  NULL,
    [item_id3]        INT           NULL,
    [sort_sequence]   INT           NULL,
    [hits]            INT           NULL,
    [last_hit]        DATETIME      NULL,
    [risk_level]      INT           NULL,
    [created]         DATETIME      NULL,
    [item_text_long]  TEXT          NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'(((u_Top_20.top_20_code ALike "ASSESSMENT_SICK"))) AND ((u_Top_20.user_id="$CARDIO"))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'u_Top_20.top_20_code DESC', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2730, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'user_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3510, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1710, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'top_20_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 4785, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2430, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 450, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id3';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id3';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1020, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'item_id3';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 390, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'sort_sequence';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'hits';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'hits';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 510, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'hits';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'last_hit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'last_hit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 630, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'last_hit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'created';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'u_Top_20', @level2type = N'COLUMN', @level2name = N'created';

