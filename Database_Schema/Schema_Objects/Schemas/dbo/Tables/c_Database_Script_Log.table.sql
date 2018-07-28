CREATE TABLE [dbo].[c_Database_Script_Log] (
    [script_log_id]             INT           IDENTITY (1, 1) NOT NULL,
    [script_id]                 INT           NOT NULL,
    [executed_date_time]        DATETIME      NULL,
    [executed_from_computer_id] INT           NULL,
    [db_script]                 TEXT          NULL,
    [completion_status]         VARCHAR (12)  NOT NULL,
    [error_index]               INT           NULL,
    [error_message]             VARCHAR (512) NULL,
    [end_date]                  DATETIME      DEFAULT (getdate()) NULL
);



