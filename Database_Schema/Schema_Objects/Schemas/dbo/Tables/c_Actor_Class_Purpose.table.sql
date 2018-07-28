CREATE TABLE [dbo].[c_Actor_Class_Purpose] (
    [purpose]       VARCHAR (40)     NOT NULL,
    [actor_class]   VARCHAR (24)     NOT NULL,
    [sort_sequence] INT              NULL,
    [status]        VARCHAR (12)     NOT NULL,
    [last_updated]  DATETIME         NOT NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL
);



