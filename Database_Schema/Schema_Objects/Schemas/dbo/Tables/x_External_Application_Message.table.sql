CREATE TABLE [dbo].[x_External_Application_Message] (
    [external_application_id] VARCHAR (24)     NOT NULL,
    [message_type]            VARCHAR (24)     NOT NULL,
    [allow_incoming_flag]     CHAR (1)         NOT NULL,
    [allow_outgoing_flag]     CHAR (1)         NOT NULL,
    [notes]                   TEXT             NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



