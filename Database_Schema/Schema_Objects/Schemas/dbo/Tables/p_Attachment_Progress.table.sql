CREATE TABLE [dbo].[p_Attachment_Progress] (
    [attachment_id]                INT              NOT NULL,
    [attachment_progress_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [cpr_id]                       VARCHAR (12)     NULL,
    [patient_workplan_item_id]     INT              NULL,
    [user_id]                      VARCHAR (24)     NOT NULL,
    [progress_date_time]           DATETIME         NOT NULL,
    [progress_type]                VARCHAR (24)     NULL,
    [progress]                     TEXT             NULL,
    [attachment_image]             IMAGE            NULL,
    [current_flag]                 CHAR (1)         NOT NULL,
    [created]                      DATETIME         NULL,
    [created_by]                   VARCHAR (24)     NULL,
    [id]                           UNIQUEIDENTIFIER NOT NULL
) TEXTIMAGE_ON [ATTACHMENTS];



