CREATE TABLE [dbo].[x_Message_Type] (
    [message_type]          VARCHAR (128)    NOT NULL,
    [integration_operation] VARCHAR (24)     NOT NULL,
    [creator_component_id]  VARCHAR (24)     NOT NULL,
    [handler_component_id]  VARCHAR (24)     NOT NULL,
    [schema]                TEXT             NULL,
    [documentation]         TEXT             NULL,
    [status]                VARCHAR (12)     NOT NULL,
    [created]               DATETIME         NOT NULL,
    [created_by]            VARCHAR (24)     NOT NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL
);



