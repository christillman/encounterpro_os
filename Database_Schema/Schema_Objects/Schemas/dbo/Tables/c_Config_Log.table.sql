CREATE TABLE [dbo].[c_Config_Log] (
    [config_log_id]      INT              IDENTITY (1, 1) NOT NULL,
    [config_object_id]   UNIQUEIDENTIFIER NOT NULL,
    [config_object_type] VARCHAR (24)     NOT NULL,
    [description]        VARCHAR (80)     NOT NULL,
    [operation]          VARCHAR (24)     NOT NULL,
    [property]           VARCHAR (64)     NULL,
    [from_value]         VARCHAR (80)     NULL,
    [to_value]           VARCHAR (80)     NULL,
    [operation_datetime] DATETIME         NOT NULL,
    [performed_by]       VARCHAR (24)     NOT NULL,
    [computer_id]        INT              NOT NULL
);



