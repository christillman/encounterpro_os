CREATE TABLE [dbo].[x_Performance_Log] (
    [log_id]                   INT              IDENTITY (1, 1) NOT NULL,
    [log_date_time]            DATETIME         NOT NULL,
    [computer_id]              INT              NOT NULL,
    [patient_workplan_item_id] INT              NULL,
    [user_id]                  VARCHAR (24)     NOT NULL,
    [metric]                   VARCHAR (24)     NOT NULL,
    [value]                    DECIMAL (18, 4)  NOT NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL
);



