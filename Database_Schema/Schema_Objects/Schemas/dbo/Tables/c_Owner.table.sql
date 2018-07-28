CREATE TABLE [dbo].[c_Owner] (
    [owner_id]     INT              NOT NULL,
    [owner]        VARCHAR (80)     NOT NULL,
    [description]  VARCHAR (255)    NULL,
    [owner_type]   VARCHAR (40)     NULL,
    [created]      DATETIME         NOT NULL,
    [created_by]   VARCHAR (24)     NOT NULL,
    [last_updated] DATETIME         NOT NULL,
    [status]       VARCHAR (12)     NOT NULL,
    [id]           UNIQUEIDENTIFIER NOT NULL
);



