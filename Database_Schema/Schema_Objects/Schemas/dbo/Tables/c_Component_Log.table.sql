CREATE TABLE [dbo].[c_Component_Log] (
    [component_id]        VARCHAR (24)     NOT NULL,
    [version]             INT              NOT NULL,
    [component_log_id]    INT              IDENTITY (1, 1) NOT NULL,
    [operation]           VARCHAR (24)     NOT NULL,
    [operation_date_time] DATETIME         NOT NULL,
    [computer_id]         INT              NOT NULL,
    [operation_as_user]   VARCHAR (64)     NOT NULL,
    [completion_status]   VARCHAR (12)     NOT NULL,
    [error_message]       TEXT             NULL,
    [created]             DATETIME         NOT NULL,
    [created_by]          VARCHAR (24)     NOT NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL
);



