CREATE TABLE [dbo].[p_Lastkey] (
    [cpr_id]    VARCHAR (12)     NOT NULL,
    [key_id]    VARCHAR (24)     NOT NULL,
    [last_key]  INT              NULL,
    [increment] INT              NULL,
    [id]        UNIQUEIDENTIFIER NOT NULL
);



