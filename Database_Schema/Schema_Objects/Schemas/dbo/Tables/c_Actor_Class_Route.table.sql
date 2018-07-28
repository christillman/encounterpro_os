CREATE TABLE [dbo].[c_Actor_Class_Route] (
    [actor_class]     VARCHAR (24)     NOT NULL,
    [document_route]  VARCHAR (24)     NOT NULL,
    [document_format] VARCHAR (24)     NOT NULL,
    [status]          VARCHAR (12)     NOT NULL,
    [owner_id]        INT              NOT NULL,
    [last_updated]    DATETIME         NOT NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL,
    [sort_sequence]   INT              NULL
);



