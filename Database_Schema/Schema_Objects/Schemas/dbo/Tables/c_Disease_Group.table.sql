CREATE TABLE [dbo].[c_Disease_Group] (
    [disease_group] VARCHAR (24)     NOT NULL,
    [description]   VARCHAR (255)    NULL,
    [sort_sequence] INT              NULL,
    [status]        VARCHAR (12)     NOT NULL,
    [age_range]     INT              NULL,
    [sex]           CHAR (1)         NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL,
    [last_updated]  DATETIME         NOT NULL,
    [owner_id]      INT              NOT NULL
);



