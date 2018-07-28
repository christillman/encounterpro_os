CREATE TABLE [dbo].[c_Disease_Group_Item] (
    [disease_group] VARCHAR (24)     NOT NULL,
    [disease_id]    INT              NOT NULL,
    [sort_sequence] INT              NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL,
    [last_updated]  DATETIME         NOT NULL,
    [owner_id]      INT              NOT NULL
);



