CREATE TABLE [dbo].[c_Actor_Class] (
    [actor_class]  VARCHAR (24)     NOT NULL,
    [description]  VARCHAR (80)     NOT NULL,
    [status]       VARCHAR (12)     NOT NULL,
    [owner_id]     INT              NOT NULL,
    [last_updated] DATETIME         NOT NULL,
    [id]           UNIQUEIDENTIFIER NOT NULL
);



