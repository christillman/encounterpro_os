CREATE TABLE [dbo].[p_Chart_Alert] (
    [cpr_id]              VARCHAR (12)     NOT NULL,
    [alert_id]            INT              IDENTITY (1, 1) NOT NULL,
    [open_encounter_id]   INT              NULL,
    [ordered_by]          VARCHAR (24)     NULL,
    [ordered_for]         VARCHAR (24)     NULL,
    [begin_date]          DATETIME         NULL,
    [expiration_date]     DATETIME         NULL,
    [alert_category_id]   VARCHAR (12)     NULL,
    [alert_text]          TEXT             NULL,
    [priority]            INT              NULL,
    [attachment_id]       INT              NULL,
    [created]             DATETIME         NULL,
    [created_by]          VARCHAR (24)     NULL,
    [alert_status]        VARCHAR (12)     NULL,
    [end_date]            DATETIME         NULL,
    [close_encounter_id]  INT              NULL,
    [patient_workplan_id] INT              NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL
);



