CREATE TABLE [dbo].[o_Log] (
    [log_id]                   INT              IDENTITY (1, 1) NOT NULL,
    [severity]                 VARCHAR (12)     NULL,
    [log_date_time]            DATETIME         NULL,
    [caller]                   VARCHAR (40)     NULL,
    [script]                   VARCHAR (40)     NULL,
    [message]                  VARCHAR (255)    NULL,
    [computer_id]              INT              NULL,
    [computername]             VARCHAR (40)     NULL,
    [windows_logon_id]         VARCHAR (40)     NULL,
    [cpr_id]                   VARCHAR (12)     NULL,
    [encounter_id]             INT              NULL,
    [treatment_id]             INT              NULL,
    [patient_workplan_item_id] VARCHAR (12)     NULL,
    [service]                  VARCHAR (24)     NULL,
    [user_id]                  VARCHAR (24)     NULL,
    [scribe_user_id]           VARCHAR (24)     NULL,
    [program]                  VARCHAR (32)     NULL,
    [cleared]                  DATETIME         NULL,
    [cleared_by]               VARCHAR (12)     NULL,
    [os_version]               VARCHAR (64)     NULL,
    [epro_version]             VARCHAR (64)     NULL,
    [sql_version]              VARCHAR (256)    NULL,
    [exception_object]         BINARY (1)       NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [caused_by_id]             UNIQUEIDENTIFIER NULL,
    [spid]                     INT              NULL,
    [log_data]                 TEXT             NULL,
    [component_id]             VARCHAR (24)     NULL,
    [compile_name]             NVARCHAR (128)   NULL
);



