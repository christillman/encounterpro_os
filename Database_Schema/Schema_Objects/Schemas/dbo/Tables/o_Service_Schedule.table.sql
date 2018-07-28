CREATE TABLE [dbo].[o_Service_Schedule] (
    [user_id]              VARCHAR (24)     NOT NULL,
    [service_sequence]     INT              IDENTITY (1, 1) NOT NULL,
    [office_id]            VARCHAR (4)      NULL,
    [service]              VARCHAR (24)     NOT NULL,
    [schedule_type]        VARCHAR (24)     NOT NULL,
    [schedule_interval]    VARCHAR (40)     NULL,
    [last_service_date]    DATETIME         NULL,
    [last_service_status]  VARCHAR (12)     NULL,
    [created]              DATETIME         NOT NULL,
    [created_by]           VARCHAR (24)     NOT NULL,
    [status]               VARCHAR (12)     NOT NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL,
    [last_successful_date] DATETIME         NULL,
    [description]          VARCHAR (80)     NULL,
    [parent_component]     UNIQUEIDENTIFIER NULL
);



