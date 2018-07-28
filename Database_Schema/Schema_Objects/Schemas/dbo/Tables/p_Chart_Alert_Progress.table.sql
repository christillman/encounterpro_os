CREATE TABLE [dbo].[p_Chart_Alert_Progress] (
    [cpr_id]                  VARCHAR (12)     NOT NULL,
    [alert_id]                INT              NOT NULL,
    [alert_progress_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [encounter_id]            INT              NULL,
    [user_id]                 VARCHAR (24)     NULL,
    [progress_date_time]      DATETIME         NULL,
    [progress_type]           VARCHAR (24)     NULL,
    [progress]                TEXT             NULL,
    [attachment_id]           INT              NULL,
    [created]                 DATETIME         NULL,
    [created_by]              VARCHAR (24)     NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



