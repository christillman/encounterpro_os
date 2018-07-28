CREATE TABLE [dbo].[p_Assessment] (
    [cpr_id]             VARCHAR (12)     NOT NULL,
    [problem_id]         INT              NOT NULL,
    [diagnosis_sequence] SMALLINT         NOT NULL,
    [open_encounter_id]  INT              NULL,
    [assessment_type]    VARCHAR (12)     NULL,
    [assessment_id]      VARCHAR (24)     NOT NULL,
    [assessment]         VARCHAR (80)     NULL,
    [location]           VARCHAR (24)     NULL,
    [begin_date]         DATETIME         NULL,
    [diagnosed_by]       VARCHAR (24)     NULL,
    [assessment_status]  VARCHAR (12)     NULL,
    [end_date]           DATETIME         NULL,
    [close_encounter_id] INT              NULL,
    [current_flag]       CHAR (1)         NOT NULL,
    [created]            DATETIME         NULL,
    [created_by]         VARCHAR (24)     NULL,
    [attachment_id]      INT              NULL,
    [risk_level]         INT              NULL,
    [id]                 UNIQUEIDENTIFIER NOT NULL,
    [default_grant]      BIT              NOT NULL,
    [sort_sequence]      INT              NULL,
    [acuteness]          VARCHAR (24)     NULL
);



