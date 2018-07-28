CREATE TABLE [dbo].[x_External_Application] (
    [external_application_id] VARCHAR (24)     NOT NULL,
    [description]             VARCHAR (80)     NOT NULL,
    [notes]                   TEXT             NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



