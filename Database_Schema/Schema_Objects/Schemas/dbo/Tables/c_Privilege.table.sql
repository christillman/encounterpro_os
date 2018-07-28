CREATE TABLE [dbo].[c_Privilege] (
    [privilege_id]  VARCHAR (24)     NOT NULL,
    [description]   VARCHAR (80)     NOT NULL,
    [secure_flag]   CHAR (1)         NOT NULL,
    [created]       DATETIME         NULL,
    [created_by]    VARCHAR (24)     NOT NULL,
    [sort_sequence] INT              NULL,
    [last_updated]  DATETIME         NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL
);

