CREATE TABLE [dbo].[c_Risk_Factor] (
    [risk_factor_id]        INT          IDENTITY (1, 1) NOT NULL,
    [description]           VARCHAR (80) NOT NULL,
    [assessment_id]         VARCHAR (24) NOT NULL,
    [observation_id]        VARCHAR (24) NOT NULL,
    [result_sequence]       SMALLINT     NOT NULL,
    [location]              VARCHAR (24) NULL,
    [result_range_sequence] INT          NULL,
    [risk_level]            INT          NULL,
    [comments]              TEXT         NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Risk_Factor', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'c_Risk_Factor', @level2type = N'COLUMN', @level2name = N'risk_level';

