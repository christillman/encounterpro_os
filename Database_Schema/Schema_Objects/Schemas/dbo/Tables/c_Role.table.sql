CREATE TABLE [dbo].[c_Role] (
    [role_id]     VARCHAR (24)  NOT NULL,
    [role_name]   VARCHAR (32)  NOT NULL,
    [description] VARCHAR (255) NULL,
    [color]       INT           NULL,
    [icon]        VARCHAR (128) NULL,
    [status]      VARCHAR (12)  NOT NULL
);

