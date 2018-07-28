CREATE TABLE [dbo].[p_assessment_Progress] (
    [cpr_id]                       VARCHAR (12)     NOT NULL,
    [problem_id]                   INT              NOT NULL,
    [assessment_progress_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [encounter_id]                 INT              NULL,
    [user_id]                      VARCHAR (24)     NOT NULL,
    [progress_date_time]           DATETIME         NOT NULL,
    [progress_type]                VARCHAR (24)     NULL,
    [progress_key]                 VARCHAR (40)     NULL,
    [progress_value]               VARCHAR (40)     NULL,
    [progress]                     TEXT             NULL,
    [diagnosis_sequence]           SMALLINT         NULL,
    [severity]                     VARCHAR (12)     NULL,
    [attachment_id]                INT              NULL,
    [patient_workplan_item_id]     INT              NULL,
    [risk_level]                   INT              NULL,
    [current_flag]                 CHAR (1)         NOT NULL,
    [created]                      DATETIME         NULL,
    [created_by]                   VARCHAR (24)     NULL,
    [id]                           UNIQUEIDENTIFIER NOT NULL
);



