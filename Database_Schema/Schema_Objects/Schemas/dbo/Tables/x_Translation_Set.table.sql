CREATE TABLE [dbo].[x_Translation_Set] (
    [translation_set] VARCHAR (24)     NOT NULL,
    [description]     VARCHAR (24)     NULL,
    [domain_id]       VARCHAR (24)     NOT NULL,
    [component_id]    VARCHAR (24)     NULL,
    [created]         DATETIME         NOT NULL,
    [created_by]      VARCHAR (24)     NOT NULL,
    [status]          VARCHAR (12)     NOT NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL
);



