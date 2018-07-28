CREATE TABLE [dbo].[o_Event_Queue] (
    [event_id]        INT          IDENTITY (1, 1) NOT NULL,
    [event]           VARCHAR (24) NOT NULL,
    [event_date_time] DATETIME     NULL,
    [event_status]    VARCHAR (12) NULL,
    [start_date_time] DATETIME     NULL
);



