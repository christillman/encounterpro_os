CREATE TABLE [dbo].[c_Attachment_Type] (
    [attachment_type] VARCHAR (24)     NOT NULL,
    [description]     VARCHAR (80)     NULL,
    [button]          VARCHAR (64)     NULL,
    [button_new]      VARCHAR (64)     NULL,
    [button_not]      VARCHAR (64)     NULL,
    [icon]            VARCHAR (64)     NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL
);



