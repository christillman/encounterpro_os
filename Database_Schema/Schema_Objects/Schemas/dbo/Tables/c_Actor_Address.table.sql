CREATE TABLE [dbo].[c_Actor_Address] (
    [actor_id]         INT              NOT NULL,
    [address_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [description]      VARCHAR (40)     NULL,
    [address_line_1]   VARCHAR (40)     NULL,
    [address_line_2]   VARCHAR (40)     NULL,
    [city]             VARCHAR (40)     NULL,
    [state]            VARCHAR (2)      NULL,
    [zip]              VARCHAR (10)     NULL,
    [country]          VARCHAR (2)      NULL,
    [status]           VARCHAR (12)     NOT NULL,
    [created]          DATETIME         NOT NULL,
    [created_by]       VARCHAR (24)     NULL,
    [id]               UNIQUEIDENTIFIER NOT NULL,
    [c_actor_id]       UNIQUEIDENTIFIER NULL
);



