CREATE TABLE [dbo].[b_Resource] (
    [resource]          VARCHAR (24) NOT NULL,
    [resource_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [resource_text]     VARCHAR (50) NULL,
    [appointment_type]  VARCHAR (50) NULL,
    [encounter_type]    VARCHAR (24) NULL,
    [new_flag]          CHAR (1)     NULL,
    [user_id]           VARCHAR (24) NULL,
    [sort_sequence]     INT          NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Resource', @level2type = N'COLUMN', @level2name = N'resource_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Resource', @level2type = N'COLUMN', @level2name = N'resource_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Resource', @level2type = N'COLUMN', @level2name = N'resource_text';

