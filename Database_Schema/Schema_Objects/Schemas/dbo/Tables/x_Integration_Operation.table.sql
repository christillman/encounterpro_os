CREATE TABLE [dbo].[x_Integration_Operation] (
    [integration_operation] VARCHAR (24)     NOT NULL,
    [operation_type]        VARCHAR (12)     NOT NULL,
    [created]               DATETIME         NOT NULL,
    [created_by]            VARCHAR (24)     NOT NULL,
    [status]                VARCHAR (12)     NOT NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL
);



