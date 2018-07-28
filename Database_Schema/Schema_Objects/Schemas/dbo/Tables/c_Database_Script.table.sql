CREATE TABLE [dbo].[c_Database_Script] (
    [script_id]              INT              IDENTITY (1, 1) NOT NULL,
    [script_type]            VARCHAR (24)     NOT NULL,
    [major_release]          INT              NOT NULL,
    [database_version]       VARCHAR (4)      NOT NULL,
    [script_name]            VARCHAR (255)    NOT NULL,
    [description]            VARCHAR (255)    NOT NULL,
    [db_script]              TEXT             NULL,
    [last_executed]          DATETIME         NULL,
    [last_completion_status] VARCHAR (12)     NULL,
    [status]                 VARCHAR (12)     NOT NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [modification_level]     INT              NULL,
    [sort_sequence]          INT              NULL,
    [system_id]              VARCHAR (24)     NULL,
    [created]                DATETIME         NOT NULL,
    [comment]                TEXT             NULL,
    [allow_users]            BIT              NOT NULL
);



