CREATE TABLE [dbo].[c_Assessment_Type_Progress_Type] (
    [assessment_type]              VARCHAR (24) NOT NULL,
    [progress_type]                VARCHAR (24) NOT NULL,
    [display_flag]                 CHAR (1)     NULL,
    [progress_key_required_flag]   CHAR (1)     NULL,
    [progress_key_enumerated_flag] CHAR (1)     NULL,
    [progress_key_object]          VARCHAR (24) NULL,
    [sort_sequence]                SMALLINT     NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Assessment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Assessment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Assessment_Type_Progress_Type', @level2type = N'COLUMN', @level2name = N'progress_key_object';

