CREATE TABLE [dbo].[em_Risk] (
    [risk_level]         INT           NOT NULL,
    [description]        VARCHAR (24)  NULL,
    [history_type_level] INT           NULL,
    [help_text]          VARCHAR (255) NULL,
    [button]             VARCHAR (128) NULL,
    [icon]               VARCHAR (128) NULL,
    [sort_sequence]      SMALLINT      NULL
);



